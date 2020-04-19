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

l = 0.100;
ag = 0.001;

rr_i = 0.100/2;
t_m = 0.004;

J = 5*1e6;
Kp = 0.6;

%% Analysis

sr_i = rr_i+ag;
b_i = 1.5*((sr_i*2*pi)/(Ns*2));

sr_o = sr_i * 1.88;
h_s = (sr_o-sr_i)-b_i;

a_s = h_s*((sr_i*2*pi)/(Ns*2));

A = (Ns*Kp*a_s*J)/(2*pi*sr_i);


%% Number of turns

Is = a_s*J;
Ncond = Is/2.5;
aa = a_s*Kp;

cond_area = aa/Ncond;

% AWG23: 0.258mm2












