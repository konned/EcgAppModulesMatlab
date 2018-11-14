function [QRSonset, QRSend] = findQRS (t, signal, Rpeaks)
    % signal - sygnal EKG 
    % Rpeaks - numery probek odpowiadajacych zalamkom R
    
    % Sprawdzenie, czy sygnal jest "odwrocony"
    if (signal(Rpeaks(1)) < 0)
           signal = -signal;
    end
       
    for i = 1 : length(Rpeaks)
       % Poszukiwanie QRS-onset
       % Idac w lewo, poszukiwane sa nastepujace po sobie minimum oraz
       % maksimum
       goLeft = true;
       decreasingL = false;
       firstMinReached = false;
       j = Rpeaks(i);
       while (goLeft)
           if (signal(j) > signal(j-1)) 
               decreasingL = true;
           end
           if (signal(j) < signal(j-1) & decreasingL == true) 
                firstMinReached = true;

           end
           if (firstMinReached == true & decreasingL == true & signal(j) > signal(j-1))
               QRSonset(i) = j; 
               goLeft = false;
           end
           j = j-1;
       end
       
       % Poszukiwanie QRS-end
       % Idac w prawo, poszukiwane sa nastepujace po sobie minimum oraz
       % maksimum
       goRight = true;
       decreasingR = false;
       firstMinReached = false;
       j = Rpeaks(i);
       while (goRight)
           if (signal(j) > signal(j+1)) 
               decreasingR = true;
           end
           if (signal(j) < signal(j+1) & decreasingR == true) 
               firstMinReached = true;
           end
           if (firstMinReached == true & decreasingR == true & signal(j) > signal(j+1))
               QRSend(i) = j; 
               goRight = false;
           end
           j = j+1;
       end
    end
end