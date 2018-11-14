function [signalWithoutQRS] = removeQRS (signal, QRSonset, QRSend, fs)
    for i = 1 : length(QRSonset)
        meanValue = (signal(QRSonset(i)) + signal(QRSend(i))) / 2;
        signal(QRSonset(i):QRSend(i)) = ones(1,QRSend(i)-QRSonset(i)+1) .* meanValue;
    end
    
    h_w_d = myfilterdesign(1, fs, 5, 20, 2);
    signalWithoutQRS = myfilter(signal, h_w_d);
end