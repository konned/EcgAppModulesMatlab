function  [P,f]=periodogram(syg, t)

samples = length(syg)+1;
fs= 1/(t(2) - t(1));
f = 0:fs/2/(samples-1):fs/2;

size = length(f);
samples = samples - 1;
for i=1:1:size
    temp = 0;
    for k=1:1:samples
        temp = temp + (syg(k)*exp(-2*pi*1i*f(i)*t(k)));
    end
    result = abs(temp);
    result = result^2;
    P(i) = result/samples;

end


end
