function [Tends] = findT (signal, Rpeaks, QRSonsets, QRSends, Ponsets, fs)

    % Sprawdzenie, czy sygnal jest "odwrocony"
    if (signal(Rpeaks(1)) < 0)
           signal = -signal;
    end
    
    % Wyciecie odcinkow QRS
    signal = removeQRS (signal, QRSonsets, QRSends, fs);
    
    signal = differentiation(signal)';          % Rozniczkowanie
    h_w_d = myfilterdesign(1, fs, 15, 20, 2);   % Filtracja dolnoprzep.
    signal = myfilter(signal, h_w_d);
    
    Tends = [];
    
    for i = 1 : length(QRSends)
        % Poszukiwanie maksimum pochodnej wystepujacego miedzy punktem 
        % ORS-end a P-onset z nastepnego uderzenia
        if (QRSends(i) ~= length(signal))
            startPoint = QRSends(i) + 1;
        else
            startPoint = QRSends(i);
        end
        
        if (i == length(QRSends))
            endPoint = length(signal);
        else 
            endPoint = Ponsets(i+1) - 1;
        end
        if (startPoint < endPoint)
            [maxVal, maxPos] = max(signal(startPoint:endPoint));
            maxPos = maxPos + startPoint - 1;
        else 
            disp('a')
            continue;
        end
%         if (maxPos == length(signal))
%             continue;
%         end
        
        % Poszukiwanie minimum lokalnego wystepujacego bezposrednio po
        % wczesniej wyszukanym maksimum
        if (endPoint - maxPos < 2)
            continue;
        else
            [a, b] = findpeaks(-signal(maxPos:endPoint));
            if (length(b) ~= 0)
                minPos = b(1) + maxPos - 1;
            else
                Tends(end+1) = endPoint;
                disp('b')
                continue;
            end
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