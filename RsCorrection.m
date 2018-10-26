function [dataCorrected] = RsCorrection(data, Rs, Cm, Vhold, Vrev, SR, fraction)


% Traynelis SF (1998) Software-based correction of single compartment series resistance errors. J Neurosci Methods 86:25–34.

dataRaw = data;

nPoints = length(data);
si = 1/SR;



tauLag = si*u.s;
fc = (1/(2*pi*tauLag))/u.Hz;
filterfactor = (1-exp(-2*pi*si*fc));

Vlast = Vhold-data(1)*Rs;

denominator = Vlast-Vrev;

if denominator ~= 0 
    fracCorr = fraction*(1-(Vhold-Vrev)/denominator);
else
    fracCorr = 0;
end
data(1) = data(1)*(1-fracCorr);


for i=2:nPoints-1
   Vthis = Vhold - data(i,iTrace)*Rs;
   if Vthis ~= Vrev
       fracCorr = fraction*(1-(Vhold-Vrev)/(Vthis-Vrev));
   else
       fracCorr = 0;
   end
       Icap = Cm*(Vthis-Vlast)/si;
       Icap = Icap*filterfactor;
       data(i-1) = data(i-1)-(fraction*Icap);
       data(i-1) = data(i-1)*(1-fracCorr);
       Vlast = Vthis;
end


dataCorrected = data;
   
            
        
end






