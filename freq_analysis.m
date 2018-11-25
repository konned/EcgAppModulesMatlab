function [TP,HF,LF,VLF,ULF,LFHF] = analysis(syg,ULF,VLF,LF,HF)

%calkowita moc widma
TP=sum(abs(syg));
%moc widma w zakresie wysokich czestotliwosci
HF=sum(abs(syg(LF:HF)));
%moc widma w zakresie niskich czestotliwosci
LF=sum(abs(syg(VLF:LF)));
%moc widma w zakresie bardzo niskich czestotliwosci
VLF=sum(abs(syg(ULF:VLF)));
%moc widma w zakresie bardzo niskich czestotliwosci
ULF=sum(abs(syg(1:ULF)));
%stosunek mocy widm
LFHF=LF/HF;

end