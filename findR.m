function [peakS, peakT, peakV] = findR (t, signal, fs)
%     peakT - probki czasu zalamkow R
%     peakV - amplotudy zalamkow R 
%     peakS - numery probek zalamkow R
%     t - wektor czasu sygnalu EKG
%     signal - sygnal EKG po calkowaniu

    % Przetwarzanie sygnalu
    f_g = 5;    % Filtracja gornoprzepustowa
    M = 30;
    h_w_g = myfilterdesign(2, fs, f_g, M, 2);
    signal = myfilter(signal, h_w_g); 
    
    signal = differentiation(signal);   % Rozniczkowanie
    signal = signal .^2;                % Potegowanie
    signal = integration(signal, 19);   % Calkowanie

    % Wyszukiwanie maksimow lokalnych w sygnale
    [A,B] = findpeaks(signal);
    thres = max(A)/10;
    C = find(A>thres);
    peak_value = zeros(1,length(C));
    peak_number = zeros(1,length(C));
    for i=1 : length(C)
        peak_value(i) = A(C(i));
        peak_number(i) = B(C(i));
    end
    peak_time = 1/fs .* (peak_number - 1);

    max_value = peak_value(1);
    max_time = peak_time(1);
    peakT = [];
    peakV = [];
    % Ponowne wyszukiwanie maksimow lokalnych z zalozeniem,
    % ze odleglosc pomiedzy kolejnymi maksimami jest nie mniejsza niz 0.2s
    for i = 2 : length(peak_value)
        % Sprawdzenie czy obecna probka jest wieksza od tymczasowego
        % maksimum oraz czy odleglosc pomiedzy nimi jest mniejsza od 0.2s
        if((peak_value(i) > max_value) & ((peak_time(i) - max_time) < 0.2))
            max_value = peak_value(i);
            max_time = peak_time(i);
        end
        % Jesli odleglosc od poprzedniego maksimum jest wieksza od 0.2s,
        % wartosc ostatniego maksimum jest zapisywana i rozpoczyna sie
        % wyszukiwanie nowego
        if (peak_time(i) - max_time >= 0.2)
            peakT(end+1) = max_time;
            peakV(end+1) = max_value;
            max_value = peak_value(i);
            max_time = peak_time(i);
        end
        if ((i == length(peak_value)) & (peakT(end) ~= max_time))
            peakT(end+1) = max_time;
            peakV(end+1) = max_value;
        end
    end

    c = ismember(round(t,4), round(peakT,4));
    peakS = find(c);
    
    % Przesuniecie o 9 probek (dlugosc filtra FIR)
    peakS = peakS - 9;
end