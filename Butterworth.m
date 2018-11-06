function Butterworth(t,syg_po_filtracji)


% IIR Butterworth highpass filter, cutoff 0.5 Hz
b = [0.995566972017647 -1.991133944035294 0.995566972017647];
a = [1 -1.991114292201654 0.991153595868935];
% Create filtered signal by ‘filter’ command
%yf1 = filter(b,a,syg_po_filtracji);

% Filter online-implementation
yf(1)=b(1)*syg_po_filtracji(1);
yf(2)=-a(2)*yf(1)+b(1)*syg_po_filtracji(2)+b(2)*syg_po_filtracji(1);
for n=3:length(syg_po_filtracji);
yf(n)=-a(2)*yf(n-1)-a(3)*yf(n-2)+b(1)*syg_po_filtracji(n)+b(2)*syg_po_filtracji(n-1)+b(3)*syg_po_filtracji(n-2);
end
figure;
subplot(211);plot(t,syg_po_filtracji);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Original')
subplot(212);plot(t,yf);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Removing baseline wander - Butterworth filter') 

