function  [P,f]=periodogram(syg, t)

samples = length(syg + 1);
fs= 1/(t(2) - t(1));
f = 0:fs/2/(samples-1):fs/2;


for k=1:samples
    P(k)= (1/samples)*(abs(sum(syg.*exp(-2*pi*1i*f(k).*t))).^2);
end

end
