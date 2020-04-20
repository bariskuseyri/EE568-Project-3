%% Intro
% Electric Loading Analysis
% EM: 12-slot / 4-pole, 3-phase | I = 2.5A
% Author: Baris Kuseyri <baris.kuseyri@metu.edu.tr>
% version 1.0 | 19/04/2020

%% Initialization

clc
clear all
close all

%% Design

m = 3;
Ns = 12;
pp = 2;
p = pp*2;

laxial = 0.100;
lg = 0.001;

Rrotor_inner = 0.100/2;
lm = 0.004;

J = 5*1e6;
Kp = 0.6;

%% Analysis

Rstator_inner = Rrotor_inner+lg;
backiron = 1.5*((2*pi*Rstator_inner)/(Ns*2));

Rslot_outer = Rstator_inner * 1.88;
Rstator_outer = Rslot_outer + backiron;
hslot = (Rslot_outer-Rstator_inner);

a_s = hslot*((Rstator_inner*2*pi)/(Ns*2));

A = (Ns*Kp*a_s*J)/(2*pi*Rstator_inner);


%% Number of turns

Is = a_s*J;
Ncond = Is/2.5;
aa = a_s*Kp;

cond_area = aa/Ncond;

% AWG23: 0.258mm2












