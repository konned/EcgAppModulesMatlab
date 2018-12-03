% README
% W³¹czyæ najpierw main ECG_BASELINE
% Potem main R_PEAKS_WAVES
% Potem dopiero ten plik
% Albowiem output Rpeaks modu³u R_PEAKS_WAVES jest
% inputem modu³u HRV_DFA
close all;

[alpha1, alpha2] = HRV_DFA(Rpeaks);