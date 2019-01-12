function [Rpeaks] = findR (signal, fs)

    % Przetwarzanie sygnalu
    f_g = 5;    % Filtracja gornoprzepustowa
    M = 30;
    h_w_g = myfilterdesign(2, fs, f_g, M, 2);
    signal = myfilter(signal, h_w_g); 

    signal = differentiation(signal);   % Rozniczkowanie
    signal = signal .^2;                % Potegowanie
    
    W = floor(0.025*fs);
    if (rem(W,2) == 0)
        W = ceil(0.025*fs);
    end
    signal = integration(signal, 2*W + 1);   % Calkowanie
    figure, plot(signal)

    % Wyszukiwanie pikow
    thres = max(signal)/15;
    [peakValue, peakNumber] = findPeak(signal,thres);

    max_value = peakValue(1);
    max_number = peakNumber(1);
    nrOfSamples = 0.2 * fs;
    
    Rpeaks = [];

    % Ponowne wyszukiwanie maksimow lokalnych z zalozeniem,
    % ze odleglosc pomiedzy kolejnymi maksimami jest nie mniejsza niz 0.2s
    if (length(peakValue) > 1) % jezeli znaleziono wiecej niz jedno maksimum
        for i = 2 : length(peakValue)
            % Sprawdzenie czy obecna probka jest wieksza od tymczasowego
            % maksimum oraz czy odleglosc pomiedzy nimi jest mniejsza od 0.2s
            if((peakValue(i) > max_value) & ((peakNumber(i) - max_number) < nrOfSamples))
                max_value = peakValue(i);
                max_number = peakNumber(i);    
            % Jesli odleglosc od poprzedniego maksimum jest wieksza od 0.2s,
            % wartosc ostatniego maksimum jest zapisywana i rozpoczyna sie
            % wyszukiwanie nowego
            elseif (peakNumber(i) - max_number >= nrOfSamples)
                Rpeaks(end+1) = max_number;
                max_value = peakValue(i);
                max_number = peakNumber(i);
            end
            if (i == length(peakValue) & Rpeaks(end) ~= max_number) 
                Rpeaks(end+1) = max_number; 
            end
        end
    else
        Rpeaks = peakNumber;
    end
    
    % Przesuniecie o 9 probek (dlugosc filtra FIR)
    Rpeaks = Rpeaks - W;
end