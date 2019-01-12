function TABLE = learner(syg,fs)

TABLE = [];
a = 1;
b = length(syg);
%% Filtracja dolnoprzepustowa
fc1 = 34;
fc1 = fc1/(fs/2);

M = 25;
N = -M:M;

w = 0.54 - (0.46*cos((2*pi*(N+M))/(2*M)));

syg_po_filtracji = filtrdolno(syg, fc1, fs, N, M, w);

N=length(syg_po_filtracji); % data length
t = [0:N-1]/fs; % time array of the data


%% Usuwanie izolinii
N=length(syg_po_filtracji); % data length
t = [0:N-1]/fs; % time array of the data

%% Butterworth
n = 1;
Ws = 0.01;
[b,a] = butter(n, Ws, 'High');
signal = filter(b,a,syg_po_filtracji);
close all

%% Wstepne przygotowanie sygnalu poprzez usuniecie offset'u 
Average = mean(signal);
signal = signal - Average*ones(length(signal),1);

%% Podzial na grupy %%
[Rpeaks] = findR (t, signal, fs);
[QRSonsets, QRSends] = findQRS (t, signal, Rpeaks);
[Ponsets, Pends] = findP (signal, Rpeaks, QRSonsets, QRSends, fs);
%[Tends] = findT (signal, Rpeaks, QRSonsets, QRSends, Ponsets, fs);

%% Podzia³ na N przedzia³ów QRS %%
for i=1:1:length(Rpeaks)
    Wektor = signal(QRSonsets(i):QRSends(i));
    Odl(i) = QRSends(i) - QRSonsets(i);
    R_Odl(i) = Rpeaks(i) - QRSonsets(i);
    for j=1:1:length(Wektor)
    TrainingSet(i,j) = Wektor(j);
    end
end

for i=1:1:length(Rpeaks)
    t = 0:1/fs:length(TrainingSet(i,:))/fs;
    t(end) = [];
    t = t';
    PoleQRS(i) = abs(trapz(t,TrainingSet(i,:)));
    MAXIMUM(i) = max(TrainingSet(i,:));
    MINIMUM(i) = max(TrainingSet(i,:));
end

for i=1:1:length(Rpeaks)
    Q = QRSonsets(i);
    R = Rpeaks(i);
    S = QRSends(i);
    QR(i) = 0;
    RS(i) = 0;
    for j=1:1:R-Q-1
        QR(i) = QR(i) + sqrt((1/fs)^2 + (signal(Q+1)-signal(Q))^2);
    end
    for j=1:1:S-R-1
        RS(i) = RS(i) + sqrt((1/fs)^2 + (signal(R+1) - signal(R))^2);
    end
    
end

for i=1:1:length(Rpeaks)
    TBL(i,1) = PoleQRS(i);
    TBL(i,2) = MAXIMUM(i);
    TBL(i,3) = MINIMUM(i);
    TBL(i,4) = signal(Rpeaks(i));
    TBL(i,5) = QRSends(i) - QRSonsets(i);
    TBL(i,6) = QR(i);
    TBL(i,7) = RS(i);
end
    TABLE = [TABLE ; TBL];

end