function [ QRSends_T, Tends_T, Tpeaks ] = delete_wrong_T_detection( QRSends_T, Tends_T, Tpeaks, signal, t )
% Funkcja delete_wrong_T_detection() usuwaj±ca b³êdne detekcje za³amków T.
% Usuwane s± za³amki, dla których punkty Tend i Tpeak znajduj± siê poza
% zakresem [mean - 2*std; mean + 2*std].
% Dla zachowania parzystej liczby za³amków, za³amki o numerach parzystych
% usuwane s± wraz z za³amkiem poprzedzaj±cym, natomiast za³amki o numerach
% nieparzystych usuwane s± wraz z za³amkiem nastêpnym.

% Wej¶cia:
% QRSends_T - zbiór próbek odpowiadaj±cych QRSends po przetwarzaniu
% wstêpnym
% Tends_T - zbiór próbek odpowiadaj±cych Tends po przetwarzaniu
% wstêpnym
% Tpeaks - zbiór próbek odpowiadaj±cych Tpeaks wyznaczonych w funkcji
% t_peaks()
% signal - sygna³ EKG z wyj¶cia modu³u ECG_BASELINE
% t - wektor czasu

% Wyj¶cia:
% QRSends_T - zbiór próbek odpowiadaj±cych QRSends po usuniêciu b³êdnych
% detekcji
% Tends_T - zbiór próbek odpowiadaj±cych Tends po usuniêciu b³êdnych
% detekcji
% Tpeaks - zbiór próbek odpowiadaj±cych Tpeaks po usuniêciu b³êdnych
% detekcji

Tends_val = signal(Tends_T);
Tends_val_mean = mean(signal(Tends_T)); % wyznaczenie ¶redniej warto¶ci Tends
Tends_val_std = std(Tends_val); % wyznaczenie odch. stand. Tends

Tpeaks_val = signal(Tpeaks);
Tpeaks_val_mean = mean(Tpeaks_val); % wyznaczenie ¶redniej warto¶ci Tpeaks
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
legend('Sygna³ EKG', 'QRS-end', 'T-end', 'T-peak')
title('Marginesy b³êdu wyznaczenia zalamka T w sygnale EKG')

% usuniêcie b³êdnych detekcji
i=1; %iterator
K = length(Tpeaks); % liczba za³amków T w sygnale EKG
% pêtla przechodz±ca przez kolejne za³amki T
while (i<=K)
    % sprawdzenie, czy Tpeak oraz Tend mie¶ci siê w zadanym zakresie (mean +- 2*std)
    if(Tends_val(i) > Tends_val_mean+2*Tends_val_std || Tends_val(i) < Tends_val_mean-2*Tends_val_std ||...
            Tpeaks_val(i) > Tpeaks_val_mean+2*Tpeaks_val_std || Tpeaks_val(i) < Tpeaks_val_mean-2*Tpeaks_val_std)
        % je¶li za³amek ma numer parzysty, usuwany jest równie¿ za³amek
        % poprzedzaj±cy
        if(mod(i, 2) == 0) %parzyste
            QRSends_T(i-1:i) = [];
            Tends_T(i-1:i) = [];
            Tpeaks(i-1:i) = [];
            Tends_val(i-1:i) = [];
            Tpeaks_val(i-1:i) = [];
            K = K-2; % uwzglêdnienie usuniêcia dwóch za³amków T w sumarycznej liczbie za³amków
            i = i-1; % zmniejszenie iteratora o 1 zapewnia, ¿e kolejny za³amek T nie zostanie pominiêty w analizie
            %display('parz');
        % je¶li za³amek ma numer nieparzysty, usuwany jest równie¿ za³amek
        % nastêpny
        else %nieparzyste
            QRSends_T(i:i+1) = [];
            Tends_T(i:i+1) = [];
            Tpeaks(i:i+1) = [];
            Tends_val(i:i+1) = [];
            Tpeaks_val(i:i+1) = [];
            K=K-2; % uwzglêdnienie usuniêcia dwóch za³amków T w sumarycznej liczbie za³amków
            %display('nieparz');
        end
    else
        i = i+1; % przej¶cie do kolejnego za³amka T
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
legend('Sygna³ EKG', 'QRS-end', 'T-end', 'T-peak')
title('Zbiór za³amków T po usuniêciu b³êdnych detekcji')

end

