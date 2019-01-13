clear all
close all
clc

load -ascii 100_V5.dat
syg_we = [X100_V5];
%syg_we = syg_we(1:10000);
%
fc1 = 15;
fc2 = 5;
fs = 360;

fc1 = fc1/(fs/2);
fc2 = fc2/(fs/2);

M = 25;
N = -M:M;

w = 0.54 - (0.46*cos((2*pi*(N+M))/(2*M)));

syg_wy = filtracja(syg_we, fc1, fc2, fs, N, M, w);

%ró¿niczkowanie
syg_diff = 1/8*[-1 -2 0 2 1];
syg_diff = conv(syg_wy, syg_diff, 'same');
% t = (0:1/fs:649999/fs)';
% syg_diff = diff(syg_wy)./diff(t);   

%potêgowanie
syg_sqrt = syg_diff.^2;

%ca³kowanie
B = 360*0.05;
syg_integral = 1/B*ones(1, B);
syg_integral = conv(syg_sqrt, syg_integral, 'same');

% figure (3)
% plot (syg_integral);


%%Progowanie ma na celu znalezienie punktów odpowiadaj¹cych za³amkom R. Nale¿y wzi¹æ pod uwagê to, ¿e odleg³oœæ miêdzy kolejnymi zespo³ami QRS
%%nie mo¿e byæ mniejsza ni¿ 200 ms, poniewa¿ jest to niemo¿liwe z fizjologicznego
%%punktu widzenia.

xsum = sum(syg_integral);
xmean = xsum/length(syg_integral);

threshold1 = xmean;
threshold2 = 0.2*fs;   %nie mo¿e byæ mniejsza ni¿ 200 ms
peak_x=[];
 peak_y=[];
 
j = 1;
for i = 3:length(syg_integral)
    if j == 1
        if (syg_integral(i) > syg_integral(i-1) && syg_integral(i) > syg_integral(i+1) && syg_integral(i+2) < syg_integral(i+1) && syg_integral(i+1) > threshold1)
            peak_x(j) = i;
            peak_y(j) = syg_integral(i);
            j = j+1;
        end
    else
      if (syg_integral(i) > syg_integral(i-1) && syg_integral(i) > syg_integral(i+1) && syg_integral(i+2) < syg_integral(i+1) && syg_integral(i+1) > threshold1)
        if ((i - peak_x(j-1))>threshold2)
            peak_x(j) = i;
            peak_y(j) = syg_integral(i);
            j = j + 1;
        end
      end
    end
end

figure
hold on
 plot(syg_integral); axis tight; title('Wyznaczone za³amki R'); xlabel('Próbki');  ylabel('Amplituda [mV]');
 plot( peak_x, peak_y, 'o', 'color', 'r') 
 dlmwrite('wyniki.txt',peak_x)
 
%Tworzenie tachogramu
size=length(peak_y);
RRintervals = zeros(1, size-1);

for i=1:1:size-1
    RRintervals(i)=peak_x(i+1)-peak_x(i);
end

for i=1:1:length(RRintervals)
    sum = 0;
    for j=1:1:length(RRintervals)
        sum = sum + RRintervals(j) ;
        if(i==j)
            break;
        end
    end
    time(i) = sum;
end

N=length(time);
N=N-1;
time = [0 time(1:N)];
time=time./360;            %w zalenzosci od czest probkowania
RRintervals=RRintervals./360;
figure
plot(time,RRintervals,'.-'); axis tight; 
%set(gca, 'XTick', 0:10:time(size-1)/1000);
title('Zmiennoœæ interwa³ów RR'); xlabel('Czas [s]'); ylabel('D³ugoœæ trwania interwa³u RR [s]');

%analiza czasowa
[RR, SDNN, RMSSD, NN50, pNN50] = time_analysis(RRintervals);

%przeprobkowanie tachogramu
t = linspace(0, time(end), length(time));
RRintervals_new = interp1(time,RRintervals,t,'nearest');      %interpolacja 

% usuniecie stalej sk³adowej
 RRintervals_new = RRintervals_new - RR;

figure
plot(t,RRintervals_new,'.-'); axis tight; 
title('Zmiennoœæ interwa³ów RR - probkowany jednorodnie'); xlabel('Czas [s]'); ylabel('D³ugoœæ trwania interwa³u RR [s]');

%periodogram
[P,f_plot]=periodogram(RRintervals_new, t);
figure
plot(f_plot, P)
title('Periodogram - tachogram probkowany jednorodnie'); xlabel('Czestotliwosc [Hz]'); ylabel('Moc P(f)');


for i=1:length(P)
   if f_plot(i)<=0.003
       ULF=i;
   elseif f_plot(i)<0.04
       VLF=i;
   elseif f_plot(i)<0.15
       LF=i;
   elseif f_plot(i)<0.4 
       HF=i;
   end
end

figure
plot(f_plot, P)
title('Zakresy parametrów analizy czestotliwosciowej'); xlabel('Czestotliwosc [Hz]'); ylabel('Moc P(f)');
hold on
plot(f_plot(1:ULF), P(1:ULF), 'r','LineWidth',2);
plot(f_plot((ULF):VLF), P((ULF):VLF), 'g','LineWidth',2)
plot(f_plot((VLF):LF), P((VLF):LF), 'y','LineWidth',2)
plot(f_plot((LF):HF), P((LF):HF), 'm','LineWidth',2)
legend('P(f)','ULF','VLF','LF','HF')
hold off

%analiza czestotliwosciowa
[an_TP,an_HF,an_LF,an_VLF,an_ULF,an_LFHF] = freq_analysis(P,ULF,VLF,LF,HF);

figure
semilogx(f_plot, P); axis tight; title('Periodogram z zakresami parametrów czêstotliwoœciowych')

