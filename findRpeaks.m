function [ integrated_signal, R_idx ] = findRpeaks( signal )

% Ró¿niczkowanie
Diff = (1/8)*[1 2 0 -2 -1];
diff_signal = conv(signal, Diff, 'same');
figure, plot(diff_signal)

% Potêgowanie
square_signal = diff_signal .^2;
figure, plot(square_signal)

% Ca³kowanie
L = 30;
window = 1/10 * ones(1, L);
integrated_signal = conv(square_signal, window, 'same');
figure, plot(integrated_signal)

% Progowanie
threshold = 200;
[QRS, R_idx] = findpeaks(integrated_signal, 'MinPeakDistance', threshold);

end