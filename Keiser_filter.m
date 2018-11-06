function Keiser_filter(Fn, fcuts, mags, devs, t, syg_po_filtracji)

[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,Fn);
n = n + rem(n,2);
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'scale');
% figure 
% plot(hh)
syg_Keiser = conv(syg_po_filtracji, hh, 'same');
figure
subplot(211);plot(t,syg_po_filtracji);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Original')
subplot(212);plot(t,syg_Keiser);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Removing baseline wander Keiser filter');