%% Intro
% Electric Loading Analysis
% EM: 12-slot / 4-pole, 3-phase | I = 2.5A
% Author: Baris Kuseyri <baris.kuseyri@metu.edu.tr>

%% Initialization

clc
clear all
close all

%% Machine Parameters

Bg_peak = 1.039406019862528;

m = 3;      % number of phase
Ns = 12;    % number of slots
pp = 2;     % number of pole-pairs
p = pp*2;   % number of poles



l_m = 0.100;        % axial length [m]
lg = 0.001;         % airgap clearance [m]
l_e = l_m + 2*lg;   % axial effective length [m]

Drotor_outer = 0.100;               % rotor diameter [m]
Rrotor_outer = Drotor_outer/2;      % rotor radius [m]
lm = 0.004;                         % magnet radial thickness [m]
d = 0.545;                           % slot ratio
% d = 0.61 for A = 80k - max A with air cooling
% d = 0.85 for stator diameter = 160mm
slotShape = 2;      % shape of slot
% 0: rectangular slot trapezoidal tooth
% 1: trapezoidal slot trapezoidal tooth
% 2: trapezoidal slot rectangular tooth
                                    
I = 2.5;        % coil current
J_max = 5*1e6;      % maximum current density [A/m^2]
Kp = 0.6;       % maximum fill factor

%% Analysis

Rslot_inner = Rrotor_outer+lg;                  % slot inner radius [m]
backiron = 2*((2*pi*Rslot_inner)/(2*Ns));     % back iron thickness [m]

Rslot_outer = Rslot_inner * (1/d);      % slot outer radius [m]
Rstator_outer = Rslot_outer + backiron; % stator outer radius [m]
hslot = (Rslot_outer-Rslot_inner);      % slot height [m]
Dstator_outer = Rstator_outer * 2;      % stator diameter [m]

if slotShape == 0
    
    areaSlot=hslot*(2*pi*Rslot_inner)/(2*Ns);
    
elseif slotShape == 1
    
    areaSlot = hslot*(((Rslot_outer+Rslot_inner)*pi)/(Ns*2));    % slot area [m^2]
    areaSlot2 = ((Rslot_outer^2-Rslot_inner^2)*pi)/(Ns*2);       % slot area [m^2]
    
elseif slotShape == 2
    
    Ateeth=hslot*Ns*(2*pi*Rslot_inner)/(2*Ns);
    areaSlot=(((Rslot_outer^2-Rslot_inner^2)*pi)-Ateeth)/Ns;
    
else
end

%A = (Ns*Kp*areaSlot*J_max)/(2*pi*Rslot_inner);


%% Number of turns, choosing a cable

Is = Kp*areaSlot*J_max;     % slot current [A]
Ncond = Is/2.5;             % number of conductors per slot
aa = areaSlot*Kp;           % copper area [m^2]
cond_area = aa/Ncond;       % single conductor area [m^2]


% a single conductor area should be 0.5mm2 or higher, as coil current is
% 2.5 A, a conductor area lower than 0.5mm2 would exceed the max. current
% density J=5A/mm2. Thus, the the AWG choice is 0.518mm2
% AWG20: 0.518 mm^2
A_cond = 0.518e-6;              % conductor area

Ncond2 = Kp*areaSlot/A_cond;    % 999 conductors per slot

A=(1/sqrt(2))*(Ns*floor(Ncond2)*I)/(2*pi*Rslot_inner);  % specific electric loading

%% Average tangential stress in the rotor surface

sigma_tan = (A*Bg_peak)/sqrt(2);        % tangential stress [N/m^2]
F = sigma_tan*2*pi*Rrotor_outer*l_e;    % total force [N]

%% Power outcome

T = 2*sigma_tan*((Rrotor_outer^2)*pi*l_e);      % rated torque [Nm]
w = 1500;               % rotor speed [rpm]
w_rad = w*(2*pi/60);    % rotor speed [rad/s]
P = T*w_rad;            % power outcome [W]


