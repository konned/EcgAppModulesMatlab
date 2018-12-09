function [ signal_filtered ] = filter_t_wave_alt( fs, signal )
% Funkcja filter_t_wave_alt() wykonuje filtracj� dolnoprzepustow� sygna�u
% z wykorzystaniem filtru FIR. Zastosowano okno Barletta.
% Mo�liwo�� ustawienia cz�stotliwo�ci odci�cia (fc) oraz liczby pr�bek (M).

% Wej�cia:
% fs - cz�stotliwo�� pr�bkowania
% signal - wej�ciowy sygna� EKG

% Wyj�cia:
% signal_filtered - sygna� przefiltrowany dolnoprzepustowo

fc = 15; % cz�stotliwo�� odci�cia
M = 30; % liczba pr�bek

f_c = fc/fs/2; %znormalizowana cz�stotliwo�� odci�cia
N = 2*M+1; % liczba wsp�czynnik�w filtra
t0 = 0;
t1 = -M:M; % wektor czasu

% odpowied� impulsowa filtra dolnoprzepustowego
h1 = 2.*f_c.*pi.*sinc(t1.*2.*f_c.*pi);
h0 = 2.*f_c;
h = h1;
h(M+1) = h0; % uwzgl�dnienie szczeg�lnego przypadku (N=0)

n = 0:N-1;
okno = 1-(2*abs(n-(N-1)/2))./(N-1); % okno Barletta

h_w = h.*okno; %wyznaczenie wsp�czynnik�w filtra

signal_filtered = conv(signal, h_w, 'same'); %f filtracja sygna�u
end

