function [ QRSends_T, Tends_T ] = preprocessing_t_wave_alt( QRSends, Tends )
% Funkcja preprocessing_t_wave_alt() realizuje Wwstêpne przetwarzanie
% punktów charakterystycznych (QRSend i Tend) wykrytych w sygnale EKG.
% Funkcja zapewnia, ¿e pierwszym pkt. charakt. jest QRSend, a ostatnim Tend,
% ¿e liczba QRSend i Tend jest taka sama oraz, ¿e liczba pkt. charakt. jest parzysta.

% Wej¶cia:
% QRS_ends - zbiór próbek odpowiadaj±cych QRS_ends z wyj¶cia modu³u WAVES
% T_ends - zbiór próbek odpowiadaj±cych T_ends z wyj¶cia modu³u WAVES

% Wyj¶cia:
% QRSends_T - zbiór próbek odpowiadaj±cych QRSends po przetwarzaniu
% wstêpnym
% Tends_T - zbiór próbek odpowiadaj±cych Tends po przetwarzaniu
% wstêpnym

QRSends_T = QRSends;
Tends_T = Tends;

if(Tends_T(1) < QRSends_T(1)) % gdy sygnal zaczyna siê od Tend
    Tends_T(1) = []; % usuniêcie pierwszego Tend
end

if(QRSends_T(end)>Tends_T(end)) % gdy sygnal konczy siê na QRSend
    QRSends_T(end) = []; % usuniêcie ostatniego QRSend
end

% Wcze¶niejsze operacje powinny zapewniæ jednakow± liczbê QRSend i Tend.
% W przypadku wykrycia ró¿nicy wy¶wietlany jest komunikat.
% Gdy liczba QRSend jest równa liczbie Tend sprawdzenie, czy jest ona
% parzysta.
if(length(QRSends_T) ~= length(Tends_T)) %
    display('Ró¿na liczba QRSends i Tends');
else
    if(mod(length(QRSends_T), 2) ~= 0) % sprawdzenie czy liczba QRSend i Tend jest parzysta
        QRSends_T(end) = []; % usuniêcie ostatniego QRSend i Tend, gdy liczba ta jest nieparzysta
        Tends_T(end) = [];
    end
end

end

