function [ QRSends_T, Tends_T, Tpeaks ] = delete_wrong_T_detection( QRSends_T, Tends_T, Tpeaks, signal, t )
% Funkcja delete_wrong_T_detection() usuwaj�ca b��dne detekcje za�amk�w T.
% Usuwane s� za�amki, dla kt�rych punkty Tend i Tpeak znajduj� si� poza
% zakresem [mean - 2*std; mean + 2*std].
% Dla zachowania parzystej liczby za�amk�w, za�amki o numerach parzystych
% usuwane s� wraz z za�amkiem poprzedzaj�cym, natomiast za�amki o numerach
% nieparzystych usuwane s� wraz z za�amkiem nast�pnym.

% Wej�cia:
% QRSends_T - zbi�r pr�bek odpowiadaj�cych QRSends po przetwarzaniu
% wst�pnym
% Tends_T - zbi�r pr�bek odpowiadaj�cych Tends po przetwarzaniu
% wst�pnym
% Tpeaks - zbi�r pr�bek odpowiadaj�cych Tpeaks wyznaczonych w funkcji
% t_peaks()
% signal - sygna� EKG z wyj�cia modu�u ECG_BASELINE
% t - wektor czasu

% Wyj�cia:
% QRSends_T - zbi�r pr�bek odpowiadaj�cych QRSends po usuni�ciu b��dnych
% detekcji
% Tends_T - zbi�r pr�bek odpowiadaj�cych Tends po usuni�ciu b��dnych
% detekcji
% Tpeaks - zbi�r pr�bek odpowiadaj�cych Tpeaks po usuni�ciu b��dnych
% detekcji

Tends_val = signal(Tends_T);
Tends_val_mean = mean(signal(Tends_T)); % wyznaczenie �redniej warto�ci Tends
Tends_val_std = std(Tends_val); % wyznaczenie odch. stand. Tends

Tpeaks_val = signal(Tpeaks);
Tpeaks_val_mean = mean(Tpeaks_val); % wyznaczenie �redniej warto�ci Tpeaks
Tpeaks_val_std = std(Tpeaks_val); % wyznaczenie odch. stand. Tpeaks

%zmienne pomocnicze do wyrysowania poziomych linii na wykresie
t_line = [min(t) max(t)];
line = ones(1, 2);

figure(2);
plot(t, signal)
hold on
plot(t(QRSends_T), signal(QRSends_T),'.b','MarkerSize',10)
plot(t(Tends_T),signal(Tends_T),'.r','MarkerSize',10)
plot(t(Tpeaks),signal(Tpeaks),'.g','MarkerSize',10)
plot(t_line, line.*Tends_val_mean, '-k')
plot(t_line, line.*(Tends_val_mean+2*Tends_val_std), '-r')
plot(t_line, line.*(Tends_val_mean-2*Tends_val_std), '-r')
plot(t_line, line.*Tpeaks_val_mean, '-k')
plot(t_line, line.*(Tpeaks_val_mean+2*Tpeaks_val_std), '-g')
plot(t_line, line.*(Tpeaks_val_mean-2*Tpeaks_val_std), '-g')
xlabel('Czas [s]')
ylabel('Amplituda [mV]')
legend('Sygna� EKG', 'QRS-end', 'T-end', 'T-peak')
title('Marginesy b��du wyznaczenia zalamka T w sygnale EKG')

% usuni�cie b��dnych detekcji
i=1; %iterator
K = length(Tpeaks); % liczba za�amk�w T w sygnale EKG
% p�tla przechodz�ca przez kolejne za�amki T
while (i<=K)
    % sprawdzenie, czy Tpeak oraz Tend mie�ci si�w zadanym zakresie (mean +- 2*std)
    if(Tends_val(i) > Tends_val_mean+2*Tends_val_std || Tends_val(i) < Tends_val_mean-2*Tends_val_std ||...
            Tpeaks_val(i) > Tpeaks_val_mean+2*Tpeaks_val_std || Tpeaks_val(i) < Tpeaks_val_mean-2*Tpeaks_val_std)
        % je�li za�amek ma numer parzysty, usuwany jest r�wnie� za�amek
        % poprzedzaj�cy
        if(mod(i, 2) == 0) %parzyste
            QRSends_T(i-1:i) = [];
            Tends_T(i-1:i) = [];
            Tpeaks(i-1:i) = [];
            Tends_val(i-1:i) = [];
            Tpeaks_val(i-1:i) = [];
            K = K-2; % uwzgl�dnienie usuni�cia dw�ch za�amk�w T w sumarycznej liczbie za�amk�w
            i = i-1; % zmniejszenie iteratora o 1 zapewnia, �e kolejny za�amek T nie zostanie pomini�ty w analizie
            %display('parz');
        % je�li za�amek ma numer nieparzysty, usuwany jest r�wnie� za�amek
        % nast�pny
        else %nieparzyste
            QRSends_T(i:i+1) = [];
            Tends_T(i:i+1) = [];
            Tpeaks(i:i+1) = [];
            Tends_val(i:i+1) = [];
            Tpeaks_val(i:i+1) = [];
            K=K-2; % uwzgl�dnienie usuni�cia dw�ch za�amk�w T w sumarycznej liczbie za�amk�w
            %display('nieparz');
        end
    else
        i = i+1; % przej�cie do kolejnego za�amka T
    end
end

figure(3)
plot(t, signal)
hold on
plot(t(QRSends_T), signal(QRSends_T),'.b','MarkerSize',10)
plot(t(Tends_T),signal(Tends_T),'.r','MarkerSize',10)
plot(t(Tpeaks),signal(Tpeaks),'.g','MarkerSize',10)
xlabel('Czas [s]')
ylabel('Amplituda [mV]')
legend('Sygna� EKG', 'QRS-end', 'T-end', 'T-peak')
title('Zbi�r za�amk�w T po usuni�ciu b��dnych detekcji')

end

