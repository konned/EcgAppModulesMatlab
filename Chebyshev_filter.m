function [syg_cheb] = Chebyshev_filter (Fn, Wp, Ws, Rp, Rs, t, syg_po_filtracji)

% Stopband Ripple (dB)
[n,Ws] = cheb2ord(Wp, Ws, Rp, Rs);                      % Chebyshev Type II Order
[b,a] = cheby2(n, Rs, Ws);                              % Transfer Function Coefficients
%[sos,g] = tf2sos(b,a);                                  % SEcond-Order-Section For STability
syg_cheb = filtfilt(b,a, syg_po_filtracji);
figure 
subplot(211);plot(t,syg_po_filtracji);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Original'); axis ([0 10 -0.5 0.5]);
subplot(212);plot(t,syg_cheb);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Removing baseline wander Chebyshev filter'); axis ([0 10 -0.5 0.5]);
  end
