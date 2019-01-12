%% TABELA %%
close all
clear all
clc

fs = 360;
load -ascii 102_V5.dat
syg = [X102_V5];
TAB1 = learner(syg,fs);
load -ascii 102_V2.dat
syg = [X102_V2];
TAB2 = learner(syg,fs);
load -ascii 228_V1.dat
syg = [X228_V1];
TAB3 = learner(syg,fs);
load -ascii 228_MLII.dat
syg = [X228_MLII];
TAB4 = learner(syg,fs);
syg = load('101.txt');
fs = 1/(syg(2,1)-syg(1,1));
TAB5 = learner(syg(:,2),fs);
syg = load('102.txt');
fs = 1/(syg(2,1)-syg(1,1));
TAB6 = learner(syg(:,2),fs);
syg = load('102.txt');
fs = 1/(syg(2,1)-syg(1,1));
TAB7 = learner(syg(:,3),fs);
syg = load('103.txt');
fs = 1/(syg(2,1)-syg(1,1));
TAB8 = learner(syg(:,2),fs);
syg = load('103.txt');
fs = 1/(syg(2,1)-syg(1,1));
TAB9 = learner(syg(:,3),fs);
syg = load('104.txt');
fs = 1/(syg(2,1)-syg(1,1));
TAB10 = learner(syg(:,2),fs);
