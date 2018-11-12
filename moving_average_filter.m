function moving_average_filter(t, syg_po_filtracji, N)

%Srednia ruchoma sygnalu x
% N jest okresem usredniania, iloscia wspolczynnikow filtru
% x jest sygnalem analizowanym
% y jest wartoscia sredniej sygnalu x za okres N
q=0; % wartosc poczatkowa sumy q
M=length(syg_po_filtracji);
cirbuff=zeros(1,N); % bufor cykliczny
cirbuff_address=1; % adres bufora cyklicznego
for k=1:M
x_new =syg_po_filtracji(k); 
q = x_new + q - cirbuff(cirbuff_address);
if cirbuff_address <= N
    cirbuff(cirbuff_address) = x_new;
    cirbuff_address=cirbuff_address+1;
end

if cirbuff_address > N
    cirbuff_address = 1;
%     cirbuff(cirbuff_address) = x_new;
end
y(k)=q/N;
end

figure 
subplot(211);plot(t,syg_po_filtracji);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Original'); axis ([0 10 -0.5 0.5]);
subplot(212);plot(t,y);
xlabel('Time(sec)'); ylabel('ECG(mV)'); title('Removing baseline wander moving average filter'); axis ([0 10 -0.5 0.5]);