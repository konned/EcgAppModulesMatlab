%% Load signal, filter and count R-peaks
load -ascii 100_MLII.DAT

ecg = X100_MLII;
% figure, plot(signal);

fc1 = 8;
fc2 = 40;
fs = 360;   

% Tutaj s� moje funckje do filtracji i znajdowania R
% Mo�na przej�� do HRV podaj�c mu jako r_peaks - wektor z indeksami R-�w
filteredEcg = filterEcg(ecg, fc1, fc2, fs);
[sig, r_peaks] = findRpeaks(filteredEcg);

%% Get RR intervals and generate tachogram
r_peaks = r_peaks';

RRintervals = zeros(1, length(r_peaks));
RRintervals(1) = r_peaks(2) - r_peaks(1);
for i = 2:(length(r_peaks))
    RRintervals(i) = r_peaks(i) - r_peaks(i-1);
end


%% Remove around 20% of outliers

% Wyliczanie r�nic odleg�o�ci od �redniej odleg�o�ci RR
% Usuwanie RR najbardziej odbiegaj�cych od �redniej

out = [];
for i = 1 : length(RRintervals)
    if RRintervals(i)/fs < 0.6
       out = [out, i]; 
    end
end
RRintervals(out) = [];

sum = 0;
for i = 1:length(RRintervals)
    sum = sum + RRintervals(i);
end
average = sum/(length(RRintervals));

differences = [];
for i = 1:length(RRintervals)
    differences(i) = abs(RRintervals(i) - average);
end

% Usuwanie outliers�w bardziej pod cpp
% Usuwanie znacznie odbiegaj�cych - dowolna ilo�� zamiast konkretnego
% procenta pr�bek (lub thres = 50/fs = 0.14 s)
thres = 50;
RR_interv = RRintervals;
outliers = [];
for i = 1:length(RR_interv)
    if differences(i)>thres
        outliers = [outliers, i];
    end
end
RR_interv(outliers) = [];

% Alternatywna funckja do powy�szej
% Usuwanie ok. 10% warto�ci skrajnych
% Do dalszych oblicze� branych jest tylko 90% warto�ci

% RR_interv = RRintervals;
% percntiles = prctile(differences, 90);
% outlierIndex = differences > percntiles;
% RR_interv(outlierIndex) = [];

%% Generate histogram
minimum = (min(RR_interv))/fs;
maksimum = (max(RR_interv))/fs;

bin_width = 1/fs;
% nbins = (maksimum - minimum)/bin_width;

RRintervals_timedomain = RR_interv/fs;
edges = minimum : 1/fs : maksimum;
nbins = length(edges)-1;
hist = histogram(RRintervals_timedomain,nbins);
title('Histogram odleg�o�ci RR')
xlabel('Odleg�o�ci RR [s]')
ylabel('Cz�sto�� wyst�pie� w sygnale')

% probplot(RR_interv)

%% TINN w [ms]
TINN = (maksimum-minimum)*1000;

%% Indeks tr�jk�tny
ITI = length(RR_interv)/(max(hist.Values));

%% Wykres Poincare
RR = RR_interv/fs;
x = RR(1:(end-1));
y = RR(2:end);

figure, plot(x,y,'b.');
hold on;

% Wyrysowanie prostej y=x
prosta_min = min(x);
prosta_max = max(x);
X = prosta_min : 0.01 : prosta_max;
Y = X;
plot(X,Y)
title('Wykres Poincare dla odleg�o�ci RR')
xlabel('RR(i) [s]')
ylabel('RR(i+1) [s]')

%% Wsp�czynniki SD1 i SD2

% D�u�sza wersja - pod cpp
suma = 0;
for i = 1:length(RR)-1
    suma = suma + (RR(i)/sqrt(2) - ((RR(i+1))/sqrt(2)) )^2 ;
end
SD1 = sqrt(suma/(length(RR)-1));

%Kr�tsza wersja
% SD1 = std(x-y)/sqrt(2);
SD2 = std(x+y)/sqrt(2);


%% Fittowanie elipsy
% Centroid
suma_x = 0;
suma_y = 0;
for i = 1:length(x)
    suma_x = suma_x + x(i);
    suma_y = suma_y + y(i);
end

x_centre = suma_x/length(x);
y_centre = suma_y/length(y);
% y_centre = x_centre;

hold on; plot(x_centre, y_centre, 'go', 'LineWidth',2)

% K�t obr�cenia elipsy - 45 st. - zgodnie z prost� x=y
angle = pi/4;
rx = SD2; %promie� wzgl x
ry = SD1; %promie� wzgl y
N = 100;
th = [0 2*pi];
th = linspace(th(1),th(2),N);

% Wzory parametryczne na elips�
x_ellipse = x_centre + rx*cos(th)*cos(angle) - ry*sin(th)*sin(angle);
y_ellipse = y_centre + rx*cos(th)*sin(angle) + ry*sin(th)*cos(angle);
hold on; plot(x_ellipse, y_ellipse,'r', 'LineWidth',1.5)

%% Wy�wietlanie SD1 i SD2
ang_SD2 = pi/4;
th_SD2 = pi;
% Wyliczenie punktu ko�cowego prostej zaznaczaj�cej SD1
SD2_endX = x_centre + rx*cos(th_SD2)*cos(ang_SD2) - ry*sin(th_SD2)*sin(ang_SD2);

SD2_x = linspace(SD2_endX, x_centre);
SD2_y = SD2_x;
SD2_plotting = plot(SD2_x, SD2_y,'k','LineWidth',2)
hold on;

ang_SD1 = pi/4;
th_SD1 = pi/2;
SD1_endX = x_centre + rx*cos(th_SD1)*cos(ang_SD1) - ry*sin(th_SD1)*sin(ang_SD1);
SD1_endY = y_centre + rx*cos(th_SD1)*sin(ang_SD1) + ry*sin(th_SD1)*cos(ang_SD1);
SD1_x = linspace(SD1_endX, x_centre);
SD1_y = linspace(SD1_endY, y_centre);

SD1_plotting = plot(SD1_x, SD1_y,'m','LineWidth',2)
% legend('RR','y=x','centroid','elipsa','SD2','SD1')

hold on
M1 = 'SD1';
M2 = 'SD2';
legend([SD1_plotting; SD2_plotting], M1, M2);
