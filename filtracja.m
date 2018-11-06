
function [syg_wy] = filtracja(syg_we, fc1, fc2, fs, N, M, w)

%odpowiedz impulsowa filtra dolnoprzepustowego
lp = sin(2*pi*fc1*N)/pi./N;
lp(M+1) = 2*fc1;

%odpowiedz impulsowa filtra gornoprzepustowego
hp = -sin(2*pi*fc2*N)/pi./N;
hp(M+1) = 1-2*fc2;

%splot odpowiedzi impulsowej filtra z oknem
filtr1 = lp.*w;
filtr2 = hp.*w;

syg_wy = conv(syg_we, filtr1, 'same');
syg_wy = conv(syg_wy, filtr2, 'same');

% figure 
% plot (syg_wy(1:2000));
% axis tight; title('Sygnal EKG po filtracji pasmowoprzepustowej'); xlabel('Próbki');  ylabel('Amplituda [mV]');
% 
