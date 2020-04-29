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

u_0 = 4 * pi * 1e-7;    % permeability of vacuum
u_r = 1.05;             % relative permeability of magnets
H_c = 1030272;          
B_rem = H_c * u_0 * u_r;     % remanence flux density

lg = 0.001;     % air-gap clearance
lm = 0.004;     % magnet thickness

%% Peak Airgap Flux Density

Bg_peak = B_rem / (1 + u_r * (lg / lm));     

Bg_FEMM = FEMM_airgapFluxDensity(2,:);
x_FEMM = FEMM_airgapFluxDensity(1,:);
plot(x_FEMM,Bg_FEMM);


%% Magnetic Loading


Bg_avg = sum(Bg_FEMM,2)./size(Bg_FEMM,2);

B1 = (2/pi) * Bg_peak;
B2 = (1/sqrt(2)) * Bg_peak;


