%% Intro
% Comparison & Optimization
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

Dstator_outer = 0.160;               % stator outer diameter [m]
Rstator_outer = Dstator_outer/2;      % stator outer radius [m]
lm = 0.004;                             % magnet radial thickness [m]

slotShape = 2;      % shape of slot
% 0: rectangular slot trapezoidal tooth
% 1: trapezoidal slot trapezoidal tooth
% 2: trapezoidal slot rectangular tooth
                                    
I = 2.5;        % coil current
J_max = 5*1e6;      % maximum current density [A/m^2]
Kp = 0.6;       % maximum fill factor

%% Opt

% Rrotor_outer = linspace(0.010,0.055,600);
Rrotor_outer = 0.025;
Rslot_inner = Rrotor_outer + lg;            % slot inner radius
taoTeeth = 2 * pi * Rslot_inner / (2*Ns);       % teeth thickness
taoSlot = 2 * pi * Rslot_inner / (2*Ns);       % slot opening
backiron = taoTeeth * 2;                  % backiron
hslot = Rstator_outer - (backiron + Rslot_inner);   % slot height
Rslot_outer = (-1)*(backiron - Rstator_outer);     % slot outer radius
d = Rslot_inner ./ Rslot_outer;              % slot ratio

Atooth = taoTeeth .* hslot;
Aslot = (pi * (Rslot_outer.^2 - Rslot_inner.^2) - Atooth * Ns) / Ns;

A_cond = 0.518e-6;              % conductor area
Ncond = Kp*Aslot/A_cond;    % 999 conductors per slot

A=(Aslot./Rslot_inner)*(1/sqrt(2))*(Ns*Kp*J_max)/(2*pi);  % specific electric loading


u_0 = 4 * pi * 1e-7;    % permeability of vacuum
u_r = 1.05;             % relative permeability of magnets
H_c = 994529;           % coercivity [A/m]
B_rem = H_c * u_0 * u_r;     % remanence flux density

Bg_peak_analytic = B_rem / (1 + u_r * (lg / lm));
B = (1/sqrt(2)) * Bg_peak_analytic;

%% Average tangential stress in the rotor surface

sigma_tan = (A*Bg_peak)/sqrt(2);        % tangential stress [N/m^2]
F = sigma_tan.*2*pi.*Rrotor_outer*l_e;    % total force [N]

%% Power outcome

T = 2*sigma_tan.*((Rrotor_outer.^2)*pi*l_e);      % rated torque [Nm]
w = 1500;               % rotor speed [rpm]
w_rad = w*(2*pi/60);    % rotor speed [rad/s]
P = T*w_rad;            % power outcome [W]


TT = A.*(Rrotor_outer.^2);
asd = linspace(0.3,0.9,1000);
asdf = (1-asd.^2)./asd;
plot(d,T)
max(T)


















