%% Load signal, filter and count R-peaks
load -ascii 228_V1.DAT

ecg = X228_V1;
% figure, plot(signal);

fc1 = 8;
fc2 = 40;
fs = 360;   

filteredEcg = filterEcg(ecg, fc1, fc2, fs);
[sig, r_peaks] = findRpeaks(filteredEcg);

%% Get RR intervals and generate tachogram
r_peaks = r_peaks';

RRintervals = zeros(1, length(r_peaks));
RRintervals(1) = r_peaks(2) - r_peaks(1);
for i = 2:(length(r_peaks))
    RRintervals(i) = r_peaks(i) - r_peaks(i-1);
end

for i = 1:1:length(RRintervals)
    sum = 0;
    for j = 1:1:length(RRintervals)
        sum = sum + RRintervals(j);
        if(i==j)
            break;
        end
    end
    time(i) = sum;
end
% figure, plot(time, RRintervals, 'b-o');


%% Remove around 20% of outliers

% Wyliczanie ró¿nic odleg³oœci od œredniej odleg³oœci RR
sum = 0;
for i = 1:length(RRintervals)
    sum = sum + RRintervals(i);
end
average = sum/(length(RRintervals));

differences = [];
for i = 1:length(RRintervals)
    differences(i) = abs(RRintervals(i) - average);
end

% Usuwanie ok. 10% wartoœci skrajnych
RR_interv = RRintervals;
percntiles = prctile(differences, 95);
outlierIndex = differences > percntiles;
RR_interv(outlierIndex) = [];

%% Generate histogram
minimum = (min(RR_interv))/fs;
maksimum = (max(RR_interv))/fs;

bin_width = 1/fs;
% nbins = (maksimum - minimum)/bin_width;

RRintervals_timedomain = RR_interv/fs;
edges = minimum : 1/fs : maksimum;
nbins = length(edges);
hist = histogram(RRintervals_timedomain,nbins)

% probplot(RR_interv)

%% TINN w [ms]
TINN = (maksimum-minimum)*1000;

%% Indeks trójk¹tny
ITI = nbins/(max(hist.Values));

%% Wykres Poincare
RR = RR_interv/fs;
x = RR(1:(end-1));
y = RR(2:end);

figure, plot(x,y,'*');
hold on;

% Wyrysowanie prostej y=x
X = [0.65 : 0.01 : 0.9];
Y = X;
plot(X,Y)


%% Wspó³czynniki SD1 i SD2

% D³u¿sza wersja
suma = 0;
for i = 1:length(RR)-1
    suma = suma + (RR(i)/sqrt(2) - ((RR(i+1))/sqrt(2)) )^2 ;
end
SD1 = sqrt(suma/(length(RR)-1));

%Krótsza wersja
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

hold on; plot(x_centre, y_centre, 'g*')

angle = pi/4;
rx = SD2; %promieñ wzgl x
ry = SD1; %promieñ wzgl y
N = 100;
th = [0 2*pi];
th = linspace(th(1),th(2),N);
x_ellipse = x_centre + rx*cos(th)*cos(angle) - ry*sin(th)*sin(angle);
y_ellipse = y_centre + rx*cos(th)*sin(angle) + ry*sin(th)*cos(angle);
hold on; plot(x_ellipse, y_ellipse,'r')

