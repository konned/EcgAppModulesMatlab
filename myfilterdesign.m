function [hw] = myfilterdesign(typ_filtra, fs, fc, M, typ_okna)

    f_c = fc/fs/2;
    N = 2*M+1;

    t1 = -M:-1;
    t0 = 0;
    t2 = 1:M;
    t = [t1 t0 t2];

    switch typ_filtra
        case 1
            h1 = 2.*f_c.*pi.*sinc(t1.*2.*f_c*pi);
            h0 = 2.*f_c;
            h2 = 2.*f_c.*pi.*sinc(t2.*2.*f_c*pi);
        case 2
            h1 = -2.*f_c.*pi.*sinc(t1.*2.*f_c*pi);
            h0 = 1-2.*f_c;
            h2 = -2.*f_c.*pi.*sinc(t2.*2.*f_c*pi);
    end
    h = [h1 h0 h2];

    n = 0:N-1;
    switch typ_okna
        case 1
            okno = ones(1,N);
        case 2
            okno = 1-(2.*(abs(n-(N-1)./2))./(N-1));
        case 3
            okno = 0.54-0.46.*cos(2.*pi.*n./(N-1));
        case 4
            okno = 0.42-0.5.*cos(2.*pi.*n./(N-1))+0.08.*cos(4.*pi.*n/(N-1));
    end

    hw = h.*okno;
end
