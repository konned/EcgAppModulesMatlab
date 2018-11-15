%% OUTPUT:
% alpha: parametr alfa analizy dla krotkich okien
% alpha2: parametr alfa analizy dla dlugich okien
%% INPUT:
% DATA: numery probek wykrytych pikow R, tablica 1D
% delta_m_start: najmniejsze okienko delta_m
% delta_m_end: najwieksze okienko delta_m
function [alpha,alpha2] = HRV_DFA(DATA, delta_m_start, delta_m_end)
% delta_m_start i delta_m_end to parametry opcjonalne
switch nargin
    case 1
        delta_m_start = 4;
        delta_m_end = 64;
    case 2
        delta_m_end = delta_m_start + 64;
end
% WYZNACZANIE TACHOGRAMU
fs = 360;
hrv = DATA;
DATA = DATA/fs * 1000;% przeksztalcenie numerow probek na milisekundy
for i=1:(length(DATA)-1)
   hrv(i) = DATA(i+1) - DATA(i);
end
middle = floor(delta_m_end / 4);
%%%%% zakomentuj wszystko to co powyzej, i odkomentuj to co ponizej
%%%%% zeby sprawdzic dzialanie programu dla przykladowego
%%%%% TACHOGRAMU z basy physionet
% clear all
%close all
%delta_m_start = 4;
%delta_m_end = 64;
%middle = 12;
%wczytanie sygna³u
%hrv = load('nsr001.dat'); 
%hrv=hrv';
%%%%%%%%%%%%%%%%%%%

% tu jest parametr ktory wyznacza granice miedzy analiza dlugo- i 
% krotkoczasowa 

tk= cumsum(hrv); % dodajemy dlugosci HRV zeby stworzyc wektor czasu (os x)
x=hrv;
% tu wpisujemy ile chcemy miec blokow i jakie chcemy je miec
delta_m=delta_m_start:delta_m_end; 
F = [];
for k = 1 : length(delta_m) 
 % wywolywanie funkcji f do policzenia wartosci F
 F(k) = f_HRV_DFA(tk,x,delta_m(k));
 % parametr alfa dla kazdej delty
 alfa_p(k) = log10(F(k))/log10(delta_m(k)); 
end
%dopasowanie prostej do wyznaczenia alfa
fit = polyfit(log10(delta_m(1:middle)), log10(F(1:middle)),1);
% polyfit zwraca
% wspolczynniki a i b, takie ze dopasowana prosta to y = a * x + b
fitdata=fit(1).*(log10(delta_m(1:middle)))+fit(2);
alpha = fit(1);
fit2 = polyfit(log10(delta_m(middle:length(delta_m))), ...
    log10(F(middle:length(delta_m))),1);
fitdata2=fit2(1).*(log10(delta_m(middle:length(delta_m))))+fit2(2);
alpha2 = fit2(1);
figure
% ponizszy scatter przedstawia wartosc F dla kazdej delty osobno, dla
% krotkich okien
scatter(log10(delta_m(1:middle)),log10(F(1:middle)),20,'ko')
hold on
% ponizszy plot przedstawia dopasowana prosta, dla krotkich okien
plot(log10(delta_m(1:middle)),fitdata,'k-')
hold on
% ponizszy scatter przedstawia wartosc F dla kazdej delty osobno, dla
% dlugich okien
scatter(log10(delta_m(middle:length(delta_m))),...
    log10(F(middle:length(delta_m))),20,'rs')
hold on
% ponizszy plot przedstawia dopasowana prosta, dla dlugich okien
plot(log10(delta_m(middle:length(delta_m))),fitdata2,'r-')
title('Wykres analizy DFA dla sygna³u EKG');
legend(['F dla \Deltam<',num2str(middle)],...
    ['dopasowana prosta \Deltam<', num2str(middle)],...
    ['F dla \Deltam>',num2str(middle)],...
    ['dopasowana prosta \Deltam>',num2str(middle)], ...
    'Location', 'northwest')
xlabel('log_{10} (\Deltam)');
ylabel('log_{10} (F \Deltam)');
% tworzenie tabeli parametrow alfa, bo byla w specyfikacji dla modulu
f = figure;
uit = uitable(f);
uit.ColumnName = {'Alfa krotkoczasowe', 'Alfa dlugoczasowe'};
d = {alpha,alpha2};
uit.Data = d;
uit.Position = [20 20 258 78];
end