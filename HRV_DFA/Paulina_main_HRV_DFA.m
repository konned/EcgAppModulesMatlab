clear all;
close all;
hrv = load('nsr001.dat');
hrv=hrv';% to tylko przyklad, prawdziwy sygnal 
% to nie moze byc tachogram, tylko numery probek pikow R

[alpha1, alpha2] = HRV_DFA(hrv);