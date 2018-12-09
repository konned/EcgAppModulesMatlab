%% filtracja sygna³u
fs = 360;
[ signal ] = filter_t_wave_alt( fs, signal );

%% pre-processign
[ QRSends_T, Tends_T ] = preprocessing_t_wave_alt( QRSends, Tends );

%% wyszukanie Tpeaks
[ Tpeaks ] = t_peaks( QRSends_T, Tends_T, signal, t );

%% usuniêcie b³êdnych detekcji
[ QRSends_T, Tends_T, Tpeaks ] = delete_wrong_T_detection( QRSends_T, Tends_T, Tpeaks, signal, t );

%% algorytm ruchomej ¶redniej
[ Zastepczy_nieparzysty, Zastepczy_parzysty ] = moving_average( QRSends_T, Tends_T, Tpeaks, signal, t );