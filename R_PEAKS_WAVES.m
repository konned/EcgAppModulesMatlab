%% Wybor filtra 
clear all 
close all
clc

load 105.mat

% signal = syg_Butterworth;
% signal = syg_Chebyshev;
% signal = syg_Keiser;
% signal = syg_LMS;
% signal = syg_MovingAverage;
% signal = syg_SavitzkyGolay;

%% Detekcja zalamkow R oraz p. QRS-onset, QRS-end, P-onset, P-end, T-end

tic
[Rpeaks] = findR (signal, fs);
[QRSonsets, QRSends] = findQRS (signal, Rpeaks);
[Ponsets, Pends] = findP (signal, Rpeaks, QRSonsets, QRSends, fs);
[Tends] = findT (signal, Rpeaks, QRSonsets, QRSends, Ponsets, fs);
toc

fprintf('Rpeaks: %d\nQRSonsets: %d\nQRSends: %d\nPonsets: %d\nPends: %d\nTends: %d\n',...
    length(Rpeaks),length(QRSonsets),length(QRSends),length(Ponsets),length(Pends),length(Tends))

%%
figure
plot(t, signal)
hold on
plot(t(Rpeaks), signal(Rpeaks),'o','MarkerSize',5,'MarkerEdgeColor',...
    'red','MarkerFaceColor','red')
plot(t(QRSonsets), signal(QRSonsets),'o','MarkerFaceColor',...
    [1, 0.788, 0.058],'MarkerEdgeColor',[1, 0.788, 0.058],'MarkerSize',5)
plot(t(QRSends), signal(QRSends),'o','MarkerFaceColor',...
    [0.2, 0.058, 1],'MarkerEdgeColor',[0.2, 0.058, 1],'MarkerSize',5)
plot(t(Ponsets),signal(Ponsets),'o','MarkerSize',5,'MarkerEdgeColor',...
    [1, 0.058, 0.588],'MarkerFaceColor',[1, 0.058, 0.588])
plot(t(Pends),signal(Pends),'o','MarkerSize',5,'MarkerEdgeColor',...
    [0.215, 0.882, 0.262],'MarkerFaceColor',[0.215, 0.882, 0.262])
plot(t(Tends),signal(Tends),'o','MarkerSize',5,'MarkerEdgeColor',...
    [0.721, 0.098, 0.396],'MarkerFaceColor',[0.721, 0.098, 0.396])
xlabel('Czas [s]')
ylabel('Amplituda [mV]')
legend('Sygna³ EKG','Za³amek R','QRS-onset','QRS-end','P-onset','P-end',...
    'T-end')
title('Oznaczenie punktow charakterystycznych sygnalu EKG')