function [ STp_min, TpTe_min ] = sample_counter( QRSends_T, Tends_T, Tpeaks )
% Funkcja sample_counter() wyznacza minimaln± liczbê próbek pomiêdzy QRSend
% i Tpeak oraz miêdzy Tpeak i Tend.

% Wej¶cie:
% QRSends_T - zbiór próbek odpowiadaj±cych QRSends po przetwarzaniu
% wstêpnym
% Tends_T - zbiór próbek odpowiadaj±cych Tends po przetwarzaniu
% wstêpnym
% Tpeaks - zbiór próbek odpowiadaj±cych Tpeaks wyznaczonych w funkcji
% t_peaks()

% Wyj¶cie:
% STp_min - minimaln± liczbê próbek pomiêdzy QRSend i Tpeak
% TpTe_min - minimaln± liczbê próbek pomiêdzy Tpeak i Tend

% wyznaczenie liczby próbek miêdzy QRSends i Tpeaks
STp = Tpeaks - QRSends_T;
% wyznaczenie liczby próbek miêdzy Tpeaks i Tends
TpTe = Tends_T - Tpeaks;
% Wyznaczenie minimalnej liczby próbek pomiêdzy QRSend i Tpeak. Otrzymana
% warto¶c jest dodatkowo dzielona przez "2", aby zapewniæ przybli¿enie
% symetrii za³amka T wzglêdem Tpeak (zwykle liczba próbek miêdzy
% QRSend a Tpeak jest wiêksza ni¿ miêdzy Tpeak a Tend) oraz wy³±czyæ
% z analizy próbki sygna³u tu¿ za punktem QRSend, co mo¿e powodowa¿ b³êdy
% analizy za³amka T.
STp_min = round(min(STp)/2);
% Wyznaczenie minimalnej liczby próbek pomiêdzy Tpeak i Tend.
TpTe_min = min(TpTe);

end

