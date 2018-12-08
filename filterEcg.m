function filteredEcg = filterEcg(ecg, fc1, fc2, fs)
% Parameters:
% -----------
% ecg : array of floats
%     ECG signal array.
% fc1 : float
%     Lower cutoff frequency (Hz).
% fc2 : float
%     Upper cutoff frequency (Hz).
% fs : float
%     Sampling frequency (Hz).
%     
% Returns:
% --------
% filtered_ecg : array of floats
%     Filtered ECG signal.

fs2=(fs/2);
fs2=double(fs2);
Wp = [fc1 fc2]/fs2;
Ws = [1 100]/fs2;
    Rp = fc1;
    Rs = fc2;
    [n,Wn] = buttord(Wp,Ws,Rp,Rs);
    [b,a] = butter(2,[fc1 fc2]./fs2); %filtr pasmowo - przepustowy => n=2
    
 filteredEcg = filtfilt(b,a,ecg);       
