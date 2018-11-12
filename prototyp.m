clear all
close all
clc

load -ascii 100_V5.dat
syg = [X100_V5];
syg = syg(1:5000);
plot(syg) 

%% Filtracja dolnoprzepustowa
fc1 = 34;
fs = 360;
fc1 = fc1/(fs/2);

M = 25;
N = -M:M;

w = 0.54 - (0.46*cos((2*pi*(N+M))/(2*M)));

syg_po_filtracji = filtrdolno(syg, fc1, fs, N, M, w);
%syg_po_filtracji = syg;
fs=360; % sampling frequency 500 Hz
N=length(syg_po_filtracji); % data length
t = [0:N-1]/fs; % time array of the data

figure 
subplot(211);plot(t,syg);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Original'); axis ([0 10 -0.5 0.5]);
subplot(212);plot(t,syg_po_filtracji);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Low-pass filtering'); axis ([0 10 -0.5 0.5]);



%% Usuwanie izolinii

fs=360; % sampling frequency 500 Hz
N=length(syg_po_filtracji); % data length
t = [0:N-1]/fs; % time array of the data

%% Butterworth
n = 1;
Ws = 0.1;
[b,a] = butter(n, Ws, 'High');
syg_butter = filter(b,a,syg_po_filtracji);

figure 
subplot(211);plot(t,syg_po_filtracji);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Original'); axis ([0 10 -0.5 0.5]);
subplot(212);plot(t,syg_butter);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Removing baseline wander Butterworth filter'); axis ([0 10 -0.5 0.5]);
%Butterworth(t,syg_po_filtracji);


%% Czebyszewa
Fs = 360;                                               % Sampling Frequency (Hz)
Fn = Fs/2;                                              % Nyquist Frequency
Wp = [1  15]/Fn;                                       % Passband (Normalised)
Ws = [0.5  110]/Fn;                                     % Stopband (Normalised)
Rp = 10;                                                % Passband Ripple (dB)
Rs = 30;                                                % Stopband Ripple (dB)


Chebyshev_filter(Fn, Wp, Ws, Rp, Rs, t, syg_po_filtracji);


%% Keiser
FreqS = 360;                                                   % Sampling frequency
fcuts = [0.5 1.0 45 46];                                        % Frequency Vector
mags =   [0 1 0];                                               % Magnitude (Defines Passbands & Stopbands)
devs = [0.05  0.01  0.05];                                      % Allowable Deviations

Keiser_filter (Fn, fcuts, mags, devs, t, syg_po_filtracji);

%% Moving average


%moving_average_filter(t, syg_po_filtracji, N);

%inna metoda
windowSize = 97; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
y = filter(b,a,syg_po_filtracji);
y = syg_po_filtracji - y;

figure 
subplot(211);plot(t,syg_po_filtracji);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Original'); axis ([0 10 -0.5 0.5]);
subplot(212);plot(t,y);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Removing baseline wander moving average filter'); axis ([0 10 -0.5 0.5]);
 

%% LMS
fc2 = 5;
fc2 = fc2/(fs/2);
fc1 = 15;
fs = 360;
fc1 = fc1/(fs/2);
M = 25;
N = -M:M;
w = 0.54 - (0.46*cos((2*pi*(N+M))/(2*M)));
d= filtracja(syg, fc1, fc2, fs, N, M, w);

[w,y,e,W] = LMS(syg_po_filtracji,d,0.2,15);
syg_LMS = y;
figure 
subplot(211);plot(t,syg_po_filtracji);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Original'); axis ([0 10 -0.5 0.5]);
subplot(212);plot(t,syg_LMS);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Removing baseline wander LMS');axis ([0 10 -0.5 0.5]);


%% Savitzky Golay

order = 3;
framelen = 11;

sgf = sgolayfilt(syg_po_filtracji,order,framelen);
figure 
subplot(211);plot(t,syg_po_filtracji);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Original');axis ([0 10 -0.5 0.5]);
subplot(212);plot(t,syg_LMS);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Removing baseline wander Savitzky Golay');axis ([0 10 -0.5 0.5]);

