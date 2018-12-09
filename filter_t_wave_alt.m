function [ signal_filtered ] = filter_t_wave_alt( fs, signal )
% Funkcja filter_t_wave_alt() wykonuje filtracjê dolnoprzepustow± sygna³u
% z wykorzystaniem filtru FIR. Zastosowano okno Barletta.
% Mo¿liwo¶æ ustawienia czêstotliwo¶ci odciêcia (fc) oraz liczby próbek (M).

% Wej¶cia:
% fs - czêstotliwo¶æ próbkowania
% signal - wej¶ciowy sygna³ EKG

% Wyj¶cia:
% signal_filtered - sygna³ przefiltrowany dolnoprzepustowo

fc = 15; % czêstotliwo¶æ odciêcia
M = 30; % liczba próbek

f_c = fc/fs/2; %znormalizowana czêstotliwo¶æ odciêcia
N = 2*M+1; % liczba wspó³czynników filtra
t0 = 0;
t1 = -M:M; % wektor czasu

% odpowied¼ impulsowa filtra dolnoprzepustowego
h1 = 2.*f_c.*pi.*sinc(t1.*2.*f_c.*pi);
h0 = 2.*f_c;
h = h1;
h(M+1) = h0; % uwzglêdnienie szczególnego przypadku (N=0)

n = 0:N-1;
okno = 1-(2*abs(n-(N-1)/2))./(N-1); % okno Barletta

h_w = h.*okno; %wyznaczenie wspó³czynników filtra

signal_filtered = conv(signal, h_w, 'same'); %f filtracja sygna³u
end

