function [Tends] = findT (signal, Rpeaks, QRSonsets, QRSends, Ponsets, fs)

    % Sprawdzenie, czy sygnal jest "odwrocony"
    if (signal(Rpeaks(1)) < 0)
           signal = -signal;
    end
    
    % Wyciecie odcinkow QRS
    signal = removeQRS (signal, QRSonsets, QRSends, fs);
    
    % Dodanie/odjecie wartosci do poczatku i konca sygnalu
    % ze wzgledu na warunki brzegowe
    signal = [ones(100,1).*signal(1); signal; ones(100,1).*signal(end)];
    signal = differentiation(signal)';          % Rozniczkowanie
    signal = signal(101:end-100);

    h_w_d = myfilterdesign(1, fs, 15, 20, 2);   % Filtracja dolnoprzep.
    signal = myfilter(signal, h_w_d);
    
    Tends = [];
    
    for i = 1 : length(QRSends)
        % Poszukiwanie maksimum pochodnej wystepujacego miedzy punktem 
        % ORS-end a P-onset z nastepnego uderzenia
        startPoint = QRSends(i);
        if (i == length(QRSends))
            endPoint = length(signal);
        else 
            endPoint = Ponsets(i+1);
        end
        [maxVal, maxPos] = max(signal(startPoint:endPoint));
        maxPos = maxPos + startPoint;
        % Poszukiwanie minimum lokalnego wystepujacego bezposrednio po
        % wczesniej wyszukanym maksimum
        [a, b] = findpeaks(-signal(maxPos:endPoint));
        if (length(b) ~= 0)
            minPos = b(1) + maxPos;
        else
            continue
        end

        % Szukany jest punkt za znalezionym minimum, w ktorym wartosc
        % pochodnej jest wieksza od zadanej wartosci. Jest to p. T-end
        lookingForZero = true;
        j = minPos;
        while (lookingForZero)
            if (signal(j) >= -0.0005) 
                lookingForZero = false;
                if (i~= length(QRSends))
                    if (j >= Ponsets(i+1))
                        Tends(end+1) = Ponsets(i+1) - 10;
                    else
                        Tends(end+1) = j;
                    end
                else
                    Tends(end+1) = j;
                end

            end
            if (j<length(signal))
                j = j+1;
            else
                Tends(end+1) = j;
                break;
            end
        end
    end
end