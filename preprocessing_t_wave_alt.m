function [ QRSends_T, Tends_T ] = preprocessing_t_wave_alt( QRSends, Tends )
% Funkcja preprocessing_t_wave_alt() realizuje Wwst�pne przetwarzanie
% punkt�w charakterystycznych (QRSend i Tend) wykrytych w sygnale EKG.
% Funkcja zapewnia, �e pierwszym pkt. charakt. jest QRSend, a ostatnim Tend,
% �e liczba QRSend i Tend jest taka sama oraz, �e liczba pkt. charakt. jest parzysta.

% Wej�cia:
% QRS_ends - zbi�r pr�bek odpowiadaj�cych QRS_ends z wyj�cia modu�u WAVES
% T_ends - zbi�r pr�bek odpowiadaj�cych T_ends z wyj�cia modu�u WAVES

% Wyj�cia:
% QRSends_T - zbi�r pr�bek odpowiadaj�cych QRSends po przetwarzaniu
% wst�pnym
% Tends_T - zbi�r pr�bek odpowiadaj�cych Tends po przetwarzaniu
% wst�pnym

QRSends_T = QRSends;
Tends_T = Tends;

if(Tends_T(1) < QRSends_T(1)) % gdy sygnal zaczyna si�od Tend
    Tends_T(1) = []; % usuni�cie pierwszego Tend
end

if(QRSends_T(end)>Tends_T(end)) % gdy sygnal konczy si�na QRSend
    QRSends_T(end) = []; % usuni�cie ostatniego QRSend
end

% Wcze�niejsze operacje powinny zapewni� jednakow� liczb� QRSend i Tend.
% W przypadku wykrycia r�nicy wy�wietlany jest komunikat.
% Gdy liczba QRSend jest r�wna liczbie Tend sprawdzenie, czy jest ona
% parzysta.
if(length(QRSends_T) ~= length(Tends_T)) %
    display('R�na liczba QRSends i Tends');
else
    if(mod(length(QRSends_T), 2) ~= 0) % sprawdzenie czy liczba QRSend i Tend jest parzysta
        QRSends_T(end) = []; % usuni�cie ostatniego QRSend i Tend, gdy liczba ta jest nieparzysta
        Tends_T(end) = [];
    end
end

end

