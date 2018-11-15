% Funkcja liczaca wartosc fluktuacji F sygnalu X w zaleznosci od delta_m
function [F] = f_HFV_DFA(tk,x,delta_m)
%calkowanie
x_mean = mean(x);
y = cumsum(x-x_mean);
K=length(y);
proste=[];

% dopasowanie prostych, osobno dla kazdego okienka (dlatego i jest co 
% delta_m)
for i = 1:delta_m:K-mod(K,delta_m)-delta_m % minus mod bo zostaje niepe³ne
    % okienko na koñcu sygna³u
    % -delta_m bo dodajemy zaraz do indeksu delta_m ¿eby liczyæ prost¹ dla
    % d³ugoœci okna
    % wywolujemy funkcje wspolczynniki_HRV_DFA zeby policzyc a i b 
    % metoda najmniejszych kwadratow
 result = wspolczynniki_HRV_DFA(tk(i:(i+delta_m-1)), ...
     y(i:(i+delta_m-1)),delta_m);
 b = result(1,1);
 a = result(2,1);
 %wyd³u¿amy wektor 'proste' o kolejne dofitowanie
 proste = [proste, a .* tk(i:(i+delta_m-1)) + b]; 
 
end
% tu pokazujemy jak ladnie proste dofitowuja calke
% mozna sobie to odkomentowac, ale wtedy w mainie trzeba zmienic
% delta_m na jedna wartosc, zeby pokazalo jeden wykres a nie milion
% figure
% plot(y(1:K-mod(K,delta_m)-delta_m))
% hold on
% plot(proste(1:K-mod(K,delta_m)-delta_m), ...
% 'Marker', 'o', 'MarkerSize', 1, 'LineStyle','none')
% title("Dopasowanie prostych na sca³kowanym sygnale, \Deltam=64");
% ylabel("Wartoœæ ca³ki");
% xlabel("Numer próbki");
sum=0;
for i=1:K-mod(K,delta_m)-delta_m
    sum = sum+ (y(i)-proste(i))^2; % sum to suma we wzorze na F, obliczam
    % ja osobno dla wiekszej przejrzystosci 
end
    % ostateczny wzor na fluktuacje
F = sqrt(sum/(K-mod(K,delta_m)-delta_m));


end
