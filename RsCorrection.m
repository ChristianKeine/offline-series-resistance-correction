function [dataCorrected] = RsCorrection(data, Rs, Cm, Vhold, Vrev, SR, fraction)

% performs offline series resistance correction for recorded currents
% Input: 
% data = recorded current trace
% Rs = uncompensated series resistance (Rs) during the recording, i.e. if
% the Rs during the experiment was 10 MOhm and online compensated by 50% by
% the amplifier, the remaining uncompensated Rs will be 5 MOhm
% Cm = Membrane capacitance during the recording in Farad
% Vhold = holding potential during the recording in Volts (e.g. -0.06 V =
% -60 mV)
% Vrev = reversal potential of the recorded current in Volts (e.g. 0.01V =
% 10mV for AMPA mediated currents)
% SR: Sampling rate during the recordings (in Hz)
% fraction: fraction of how much of the remaining Rs should be compensated
% (e.g. 1 if all remaining Rs should be compensated)

% Based on: "Traynelis SF (1998) Software-based correction of single
% compartment series resistance errors. J Neurosci Methods 86:25–34."

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






