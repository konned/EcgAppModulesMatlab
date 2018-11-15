% funkcja liczaca wspolczynniki a i b dofitowanej prostej do
% sygnalu  ym(tm) 
function result = wspolczynniki_HRV_DFA(tm,ym,delta_m)
% obliczam elementy macierzy zgodnie z instrukcja laboratoryjna
M = delta_m;
YM_sum2 = sum(tm.*ym);
TM_sum = sum(tm);
TM_sumkw = sum(tm.^2);
YM_sum = sum(ym);
Macierz2 = [YM_sum; YM_sum2];
% mnozenie inv ponizszej macierzy razy Ma2 nie dziala, musialam 
% liczyc recznie 
% Macierz1 = [M TM_sum; TM_sum TM_sumkw]; 
% wyznacznik razy transponowana macierz dopelnien = inwersja macierzy
inv_Macierz1 = 1/(M*TM_sumkw-TM_sum*TM_sum) *...
    transpose([TM_sumkw -TM_sum; -TM_sum M]);
% result to tablica dwoch elementow
result = inv_Macierz1 * Macierz2;