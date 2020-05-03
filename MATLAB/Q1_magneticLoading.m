%% Intro
% Magnetic Loading Analysis
% EM: solid stator / 4-pole, 3-phase | NdFeB N42 grade (ur=1.05)
% Author: Baris Kuseyri <baris.kuseyri@metu.edu.tr>

%% Initialization

clc
clear all
close all

fileID = fopen('airgap_flux_density.txt','r');
formatSpec = '%f %f';
sizeA = [2 1500];
FEMM_airgapFluxDensity = fscanf(fileID,formatSpec,sizeA);

%% Machine Parameters

pp = 2;     % pole-pairs
p = pp*2;   % number of poles

Drotor_outer = 0.100;               % rotor diameter [m]
Rrotor_outer = Drotor_outer/2;      % rotor radius [m]

u_0 = 4 * pi * 1e-7;    % permeability of vacuum
u_r = 1.05;             % relative permeability of magnets
H_c = 994529;           % coercivity [A/m]
B_rem = H_c * u_0 * u_r;     % remanence flux density

lg = 0.001;     % air-gap clearance
lm = 0.004;     % magnet thickness


%% Load Line

Hm = linspace(-1100000,100000,10000);
Bm = B_rem+u_0*u_r*Hm;
LL = (-1)*(u_0)*(lm/lg)*Hm;


figure(1)
showaxes('show')
fig1 = plot(Hm,Bm,'color','k');
hold on
% refline(0,0,'color','k')
fig2 = plot(Hm,LL,'--','color','k');
axis([-1100000 0 0 1.5])
xlabel('H (A/m)')
ylabel('B (T)')
title('B-H Curve')
grid on
grid minor
hold off
legend('B-H Curve','Load Line')

%% Peak Airgap Flux Density

Bg_peak_analytic = B_rem / (1 + u_r * (lg / lm));     

Bg_FEMM = FEMM_airgapFluxDensity(2,:);
Bg_peak_FEMM = max(Bg_FEMM);

x_FEMM_inmeters = FEMM_airgapFluxDensity(1,:);
x_FEMM_indegrees = 180*(FEMM_airgapFluxDensity(1,:))/(pi*(Rrotor_outer+(lg/2)));

figure(2);
fig3 = plot(x_FEMM_indegrees,Bg_FEMM);
fig3.LineStyle = '-';
fig3.LineWidth = 1.5;
fig3.Color = 'k';
% title('Radial Air-gap Flux Density')
xlabel('\theta (degrees)')
ylabel('B_g (T)')
ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'on';
yticks(0:0.1:1.5)
set(gcf,'units','centimeters','position',[0,2,30,15])

%% Magnetic Loading

Bg_avg_FEMM = sum(Bg_FEMM,2)./size(Bg_FEMM,2);

B1 = (2/pi) * Bg_peak_analytic;
B2 = (1/sqrt(2)) * Bg_peak_analytic;

%% Error Calculation

Err1 = abs((Bg_peak_FEMM-Bg_peak_analytic)/Bg_peak_FEMM)*100;
Err2 = abs((Bg_avg_FEMM-B2)/Bg_avg_FEMM)*100;



