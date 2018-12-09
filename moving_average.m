function [ Zastepczy_nieparzysty, Zastepczy_parzysty ] = moving_average( QRSends_T, Tends_T, Tpeaks, signal, t )
% Funkcja moving_average() realizuj�ca algorytm ruchomej �redniej do
% wyznaczania alternansu za�amka T.

% Wej�cia:
% QRSends_T - zbi�r pr�bek odpowiadaj�cych QRSends po usuni�ciu b��dnych
% detekcji w funkcji delete_wrong_T_detection()
% Tends_T - zbi�r pr�bek odpowiadaj�cych Tends po usuni�ciu b��dnych
% detekcji w funkcji delete_wrong_T_detection()
% Tpeaks - zbi�r pr�bek odpowiadaj�cych Tpeaks po usuni�ciu b��dnych
% detekcji w funkcji delete_wrong_T_detection()
% signal - sygna� EKG z wyj�cia modu�u ECG_BASELINE
% t - wektor czasu

% Wyj�cia:
% Zastepczy_nieparzysty - u�redniony zast�pczy za�amek T odpowiadaj�cy
% nieparzystym uderzeniom serca
% Zastepczy_parzysty - u�redniony zast�pczy za�amek T odpowiadaj�cy
% parzystym uderzeniom serca

% Wyznaczenie minimalnej liczby pr�bek pomi�dzy QRSend i Tpeak
% oraz mi�dzy Tpeak i Tend.
[ STp_min, TpTe_min ] = sample_counter( QRSends_T, Tends_T, Tpeaks );

Tablica_nieparzyste = [];
Tablica_parzyste = [];
Tablica_nieparzyste_t = [];
Tablica_parzyste_t = [];
K = length(Tpeaks);
for i=1:round(K/2)
    % Wyr�wnanie za�amk�w T do punkt�w Tpeaks oraz podzia� na za�amki
    % o numerach nieparzystych i parzystych.
    Tablica_nieparzyste(i, :) = signal(Tpeaks(2*i-1)-STp_min:Tpeaks(2*i-1)+TpTe_min);
    Tablica_parzyste(i, :) = signal(Tpeaks(2*i)-STp_min:Tpeaks(2*i)+TpTe_min);
    Tablica_nieparzyste_t(i, :) = t(Tpeaks(2*i-1)-STp_min:Tpeaks(2*i-1)+TpTe_min);
    Tablica_parzyste_t(i, :) = t(Tpeaks(2*i)-STp_min:Tpeaks(2*i)+TpTe_min);
end

figure(4)
plot(t, signal)
hold on
plot(t(QRSends_T), signal(QRSends_T),'.b','MarkerSize',10)
plot(t(Tends_T),signal(Tends_T),'.r','MarkerSize',10)
plot(Tablica_nieparzyste_t, Tablica_nieparzyste, '.m','MarkerSize',8)
plot(Tablica_parzyste_t, Tablica_parzyste, '.g','MarkerSize',8)
xlabel('Czas [s]')
ylabel('Amplituda [mV]')
legend('Sygna� EKG', 'QRS-end', 'T-end', 'Zalamki nieparzyste', 'Zalamki parzyste')
title('Podzia� za�amk�w T na nieparzyste i parzyste')

Zastepczy_nieparzysty = Tablica_nieparzyste(1,:);
Zastepczy_parzysty = Tablica_parzyste(1,:);
% Realizacja algorytmu ruchomej �redniej.
for i=2:K/2
    % Wyznaczenie r�nicy mi�dzy aktualnym za�amkiem zast�pczym a kolejnym
    % za�amkiem T w sygnale (osobno dla nieparzystych i parzystych).
    % W literaturze zasugerowano dzielenie r�nicy przez warto�� "8", kt�ra
    % zosta�a dobrana do�wiadczalnie.
    delta_nieparzysty = (Tablica_nieparzyste(i,:) - Zastepczy_nieparzysty)/8;
    delta_parzysty = (Tablica_parzyste(i,:) - Zastepczy_parzysty)/8;
    % Modyfikacja zast�pczego za�amka o wyznaczon� warto�� delta (osobno
    % dla nieparzystych i parzystych).
    Zastepczy_nieparzysty = Zastepczy_nieparzysty + delta_nieparzysty;
    Zastepczy_parzysty = Zastepczy_parzysty + delta_parzysty;
end

disp('Warto�� alternansu wyznaczona metod� ruchomej �redniej');
[alt, i] = max(abs(Zastepczy_nieparzysty - Zastepczy_parzysty));
alt

t_zastepcze = t(1:STp_min+TpTe_min+1);
figure(5)
plot(t_zastepcze, Zastepczy_nieparzysty, 'k', 'LineWidth', 3)
hold on
plot(t_zastepcze, Zastepczy_parzysty, 'm', 'LineWidth', 3)
xlabel('Czas [s]')
ylabel('Amplituda [mV]')
legend('Zast�pczy  nieparzysty za�amek T', 'Zast�pczy  parzysty za�amek T')
title('Por�wnanie zast�pczego nieparzystego i parzystego za�amka T')
txt = ['alternans = ' num2str(round(alt*1000)) ' uV'];
tx = t_zastepcze(length(t_zastepcze)/2)
ty = Zastepczy_parzysty(round(length(Zastepczy_parzysty)/10))
text(tx, ty, txt,'FontSize',14, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'baseline')

end

