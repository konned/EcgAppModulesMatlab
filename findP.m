function [Ponsets, Pends] = findP (signal, Rpeaks, QRSonsets, QRSends, fs)

    % Sprawdzenie, czy sygnal jest "odwrocony"
    if (signal(Rpeaks(1)) < 0)
           signal = -signal;
    end
    
    % Wyciecie odcinkow QRS
    signal = removeQRS (signal, QRSonsets, QRSends, fs);
    
    signal = differentiation(signal)';          % Rozniczkowanie
    h_w_d = myfilterdesign(1, fs, 15, 20, 2);   % Filtracja dolnoprzep.
    signal = myfilter(signal, h_w_d);

    Ponsets = [];
    Pends = [];
    noOfSamples = floor(0.25/(1/fs));       % Max. dlugosc odcinka PQ
    
    for i = 1 : length(QRSonsets)
        % Szukanie P-end
        % Szukane jest minimum pochodnej, znajdujace sie na lewo 
        % od punktu QRS-onset
        startPoint = QRSonsets(i) - noOfSamples; % Punkt startowy
        if (startPoint < 1) 
            startPoint = 1;
        end
        endPoint = QRSonsets(i);                 % Punkt koncowy
        [minVal, minPos] = min(signal(startPoint:endPoint));
        minPos = minPos + startPoint;

        % Szukany jest punkt za znalezionym minimum, w ktorym wartosc
        % pochodnej jest wieksza od zadanej wartosci. Jest to p. P-end
        lookingForZero = true;
        j = minPos;
        while (lookingForZero)
            if (signal(j) >= -0.0003) 
                lookingForZero = false;
                % Sprawdzenie, czy p. P-end znajduje sie przez QRS-onset
                if (j >= QRSonsets(i) | abs(QRSonsets(i)-j)<10)
                    Pends(end+1) = QRSonsets(i) - 10;
                else
                    Pends(end+1) = j;
                end
            end
            j = j+1;
        end

        % Szukanie P-onset
        % Szukane jest maksimum pochodnej, znajdujace sie przez wczesniej
        % znalezionym minimum
        endPoint = minPos;
        [maxVal, maxPos] = max(signal(startPoint:endPoint));
        maxPos = maxPos + startPoint;

        % Szukany jest punkt przed znalezionym maksimum, w ktorym wartosc
        % pochodnej jest mniejsza od zadanej wartosci. Jest to p. P-onset
        lookingForZero = true;
        j = maxPos;
        while (lookingForZero)
            if (signal(j) <= 0.0003) 
                lookingForZero = false;
                Ponsets(end+1) = j;
            end
            j = j-1;
        end
    end
end