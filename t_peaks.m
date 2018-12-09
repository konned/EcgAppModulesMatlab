function [ Tpeaks ] = t_peaks( QRSends_T, Tends_T, signal, t )
% Funkcja t_peaks() pozwala na wyszukanie wierzcho�k�w kolejnych za�amk�w T w
% sygnale EKG

% Wej�cia:
% QRS_ends_T - zbi�r pr�bek odpowiadaj�cych QRS_ends po przetwarzaniu
% wst�pnym
% T_ends_T - zbi�r pr�bek odpowiadaj�cych T_ends po przetwarzaniu
% wst�pnym
% signal - sygna� EKG z wyj�cia modu�u ECG_BASELINE
% t - wektor czasu

% Wyj�cia:
% Tpeaks - zbi�r pr�bek odpowiadaj�cych wyznaczonym punktom Tpeaks

Tpeaks = [];
for i=1:length(Tends_T)
    % wyszukanie Tpeak jako max w zakresie mi�dzy QRSend a Tend.
    Tpeak_val_tmp = max(signal(QRSends_T(i):Tends_T(i)));
    Tpeaks(i) = find(signal==Tpeak_val_tmp);
end

figure(1);
plot(t, signal)
hold on
plot(t(QRSends_T), signal(QRSends_T),'.b','MarkerSize',10)
plot(t(Tends_T),signal(Tends_T),'.r','MarkerSize',10)
plot(t(Tpeaks),signal(Tpeaks),'.g','MarkerSize',10)
xlabel('Czas [s]')
ylabel('Amplituda [mV]')
legend('Sygna� EKG', 'QRS-end', 'T-end', 'T-peak')
title('Oznaczenie zalamka T w sygnale EKG')
end

