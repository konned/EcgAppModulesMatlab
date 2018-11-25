close all
clear all
clc


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

%usuniecie stalej sk³adowej
stala = mean(RRintervals); 
RRintervals = RRintervals - stala;

%przeprobkowanie tachogramu
t = linspace(0, time(end), length(time));
RRintervals_new = spline(time, RRintervals, t);

figure
plot(t,RRintervals_new,'.-'); axis tight; 
title('Zmiennoœæ interwa³ów RR - probkowany jednorodnie'); xlabel('Czas [s]'); ylabel('D³ugoœæ trwania interwa³u RR [s]');

%periodogramy
[P1,f_plot1]=periodogram(RRintervals, time);
figure
plot(f_plot1, P1)
title('Periodogram - tachogram probkowany niejednorodnie'); xlabel('Czestotliwosc [Hz]'); ylabel('Moc P(f)');

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
[an_TP,an_HF,an_LF,an_VLF,an_ULF,an_LFHF] = freq_analysis(RRintervals_new,ULF,VLF,LF,HF);