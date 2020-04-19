%% Intro
% Magnetic Loading Analysis
% EM: solid stator / 4-pole, 3-phase | NdFeB N42 grade (ur=1.05)
% Author: Baris Kuseyri <baris.kuseyri@metu.edu.tr>
% version 1.0 | 19/04/2020

%% Initialization

clc
clear all
close all

%% Design

pp = 2;
p = pp*2;

u_0 = 4 * pi * 1e-7;
u_r = 1.05;
H_c = 1030272;

l_g = 0.001;
l_m = 0.004;

%% Peak Airgap Flux Density


B_r = H_c * u_0 * u_r;
B_g = B_r / (1 + u_r * (l_g / l_m));


%% Magnetic Loading

B = (2/pi) * B_g;


