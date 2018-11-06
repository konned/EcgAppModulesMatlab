function [syg_wy] = filtrdolno(syg_we, fc1, fs, N, M, w)

%odpowiedz impulsowa filtra dolnoprzepustowego
lp = sin(2*pi*fc1*N)/pi./N;
lp(M+1) = 2*fc1;


%splot odpowiedzi impulsowej filtra z oknem
filtr1 = lp.*w;


syg_wy = conv(syg_we, filtr1, 'same');


figure 
plot (syg_wy(1:5000));
axis tight; title('Sygnal EKG po filtracji doloprzepustowej'); xlabel('Próbki');  ylabel('Amplituda [mV]');

