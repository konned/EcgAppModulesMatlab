% README
% W��czy� najpierw main ECG_BASELINE
% Potem main R_PEAKS_WAVES
% Potem dopiero ten plik
% Albowiem output Rpeaks modu�u R_PEAKS_WAVES jest
% inputem modu�u HRV_DFA
close all;

[alpha1, alpha2] = HRV_DFA(Rpeaks);