function [ STp_min, TpTe_min ] = sample_counter( QRSends_T, Tends_T, Tpeaks )
% Funkcja sample_counter() wyznacza minimaln� liczb� pr�bek pomi�dzy QRSend
% i Tpeak oraz mi�dzy Tpeak i Tend.

% Wej�cie:
% QRSends_T - zbi�r pr�bek odpowiadaj�cych QRSends po przetwarzaniu
% wst�pnym
% Tends_T - zbi�r pr�bek odpowiadaj�cych Tends po przetwarzaniu
% wst�pnym
% Tpeaks - zbi�r pr�bek odpowiadaj�cych Tpeaks wyznaczonych w funkcji
% t_peaks()

% Wyj�cie:
% STp_min - minimaln� liczb� pr�bek pomi�dzy QRSend i Tpeak
% TpTe_min - minimaln� liczb� pr�bek pomi�dzy Tpeak i Tend

% wyznaczenie liczby pr�bek mi�dzy QRSends i Tpeaks
STp = Tpeaks - QRSends_T;
% wyznaczenie liczby pr�bek mi�dzy Tpeaks i Tends
TpTe = Tends_T - Tpeaks;
% Wyznaczenie minimalnej liczby pr�bek pomi�dzy QRSend i Tpeak. Otrzymana
% warto�c jest dodatkowo dzielona przez "2", aby zapewni� przybli�enie
% symetrii za�amka T wzgl�dem Tpeak (zwykle liczba pr�bek mi�dzy
% QRSend a Tpeak jest wi�ksza ni� mi�dzy Tpeak a Tend) oraz wy��czy�
% z analizy pr�bki sygna�u tu� za punktem QRSend, co mo�e powodowa� b��dy
% analizy za�amka T.
STp_min = round(min(STp)/2);
% Wyznaczenie minimalnej liczby pr�bek pomi�dzy Tpeak i Tend.
TpTe_min = min(TpTe);

end

