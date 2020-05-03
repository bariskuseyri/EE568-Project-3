%% Intro
% Comparison & Optimization
% EM: 12-slot / 4-pole, 3-phase | I = 2.5A
% Author: Baris Kuseyri <baris.kuseyri@metu.edu.tr>

%% Initialization

clc
clear all
close all

%% Machine Parameters

m = 3;      % number of phase
Ns = 12;    % number of slots
pp = 2;     % number of pole-pairs
p = pp*2;   % number of poles

l_m = 0.100;        % axial length [m]
lg = 0.001;         % airgap clearance [m]
l_e = l_m + 2*lg;   % axial effective length [m]

do = 0.160;               % stator outer diameter [m]
ro = do/2;      % stator outer radius [m]
lm = 0.004;                             % magnet radial thickness [m]

slotShape = 2;      % shape of slot
% 0: rectangular slot trapezoidal tooth
% 1: trapezoidal slot trapezoidal tooth
% 2: trapezoidal slot rectangular tooth
                                    
I = 2.5;        % coil current
J_max = 5*1e6;      % maximum current density [A/m^2]
Kp = 0.6;       % maximum fill factor

Kt1 = linspace(0.10,0.90,50);       % slot/tooth ratio

%% Dimensions

rro1 = linspace(0.010,0.055,150);        % rotor outer radius
[Kt,rro] = meshgrid(Kt1,rro1);

% rro = 0.025;
rsi = rro + lg;                         % slot inner radius

taoTeeth = Kt .* (2 .* pi .* rsi ./ Ns);      % teeth thickness
taoSlot = (1-Kt) .* (2 .* pi .* rsi ./ Ns);   % slot opening
backiron = taoTeeth .* 1;                % backiron
hslot = ro - (backiron + rsi);          % slot height
rso = rsi + hslot;                      % slot outer radius
d = rsi ./ rso;                         % slot ratio


if slotShape == 0
    Aslot=hslot.*(2*pi.*rsi)/(2*Ns);            % slot area [m^2]
elseif slotShape == 1
    Aslot = hslot.*(((rso+rsi)*pi)/(Ns*2));     % slot area [m^2]
elseif slotShape == 2
    Atooth=hslot.*(2*pi.*rsi)/(2*Ns);               % tooth area [m^2]
    Aslot=(((rso.^2-rsi.^2).*pi)-Ns.*Atooth)./Ns;   % slot area [m^2]
else
end

%% Electrical Loading A

A_cond = 0.518e-6;              % conductor area
Ncond = Kp.*Aslot./A_cond;        % number of conductors

% A_peak=((Ns*Kp*J_max)/(2*pi)).*(Aslot./rsi);
A_peak=((Ns*I)/(2*pi)).*(floor(Ncond)./rsi);
A = (1/sqrt(2)).*A_peak;            % specific electric loading


%% Magnetic Loading B
u_0 = 4 * pi * 1e-7;    % permeability of vacuum
u_r = 1.05;             % relative permeability of magnets
B_rem = 0.4;     % remanence flux density [T]
H_c = -B_rem/(u_0*u_r);           % coercivity [A/m]

Bg_peak_analytic = B_rem / (1 + u_r * (lg / lm));
B = (1/sqrt(2)) * Bg_peak_analytic;

%% Average tangential stress in the rotor surface

sigma_tan = A*B;        % tangential stress [N/m^2]
F = sigma_tan.*2*pi.*rro*l_e;    % total force [N]

%% Power outcome

T = F .* rro;      % rated torque [Nm]
w = 1500;               % rotor speed [rpm]
w_rad = w*(2*pi/60);    % rotor speed [rad/s]
P = T*w_rad;            % power outcome [W]

% plot(d,T)
% xlabel('slot ratio d=slot inner radius/slot outer radius')
% ylabel('Torque [Nm]')
% grid on


[maxT, idx] = max(T);

d(idx)
T(idx)



surf(Kt,d,T);
colormap(jet)
xlabel('K_t:slot-to-tooth ratio')
ylabel('slot ratio d=slot inner radius/slot outer radius')
zlabel('Torque [Nm]')

% tiledlayout(1,2)
% 
% % Left plot
% ax1 = nexttile;
% plot3(ax1,Kt,d,T)
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% 
% % Right plot
% ax2 = nexttile;
% plot3(ax2,Kt,d,T)
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% view(ax2,[90 0]);
