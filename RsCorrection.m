classdef RsCorrection
    
    % performs offline series resistance correction for recorded currents
    % Input:
    
    % - data = recorded current trace, can be single vector or multiple recordings as array or cell
    % - Rs = uncompensated series resistance (Rs) during the recording in Ohm, i.e. if the Rs during the experiment was 10 MOhm and online compensated by 50% by
    % the amplifier, the remaining uncompensated Rs will be 5 MOhm (5e6 Ohm = 5 MOhm)
    % - Cm = Membrane capacitance during the recording in Farad (e.g. 10e-12 F = 10 pF)
    % - Vhold = holding potential during the recording in Volts (e.g. -0.06 V =  -60 mV)
    % - Vrev = reversal potential of the recorded current in Volts (e.g. 0.01V = 10 mV)
    % - SR: Sampling rate during the recordings (in Hz)
    % - fraction: fraction of how much of the remaining Rs should be compensated [0-1] (e.g. 1 if all remaining Rs should be compensated)
    
    % Based on: "Traynelis SF (1998) Software-based correction of single
    % compartment series resistance errors. J Neurosci Methods 86:25�34."
    
    properties
        dataRaw
        dataCorrected
        options
        
    end
    
    
    methods
        function obj = RsCorrection(data, Rs, Cm, Vhold, Vrev, SR, varargin)
            
            % CHECK INPUTS
            checkData = @(n)validateattributes(cell2mat(n), {'numeric','DimensionedVariable','cell'},{'nonempty','nonnan'});
            checkNumericPos = @(n)validateattributes(n, {'numeric','DimensionedVariable'},{'nonnegative','nonnan','nonempty'});
            checkVoltage  = @(n)validateattributes(n, {'numeric','DimensionedVariable'},{'nonnan','nonempty'});
            
            P = inputParser;
            P.addRequired('data',checkData)
            P.addRequired('Rs',checkNumericPos)
            P.addRequired('Cm',checkNumericPos)
            
            P.addRequired('Vhold',checkVoltage)
            P.addRequired('Vrev',checkVoltage)
            P.addRequired('SR',checkNumericPos)
            
            P.addParameter('fraction',1,checkNumericPos)
            
            P.parse(data, Rs, Cm, Vhold, Vrev, SR, varargin{:});
            opt = P.Results;
            
            obj.options = opt;
            obj.dataRaw = data;
            
            
            
                       
            dataIsCell = iscell(data);
            
            
            if ~dataIsCell
                [~,dataDim] = max(size(data));
                data = num2cell(data,dataDim);
            end
            
            si = 1/SR;
            tauLag = si;
            fc = (1/(2*pi*tauLag));
            filterfactor = (1-exp(-2*pi*si*fc));
            
            for iTrace = 1:numel(data)
                nPoints = length(data{iTrace});
                
                Vlast = Vhold-data{iTrace}(1)*Rs; % initialize DC voltage at membrane
                denominator = Vlast-Vrev;
                
                if denominator ~= 0
                    fracCorr = opt.fraction*(1-(Vhold-Vrev)/denominator);
                else
                    fracCorr = 0;
                end
                data{iTrace}(1) = data{iTrace}(1)*(1-fracCorr); % DC correction for first data point
                
                
                for i=2:nPoints-1 % loop through all other points
                    Vthis = Vhold - data{iTrace}(i)*Rs;
                    if Vthis ~= Vrev
                        fracCorr = opt.fraction*(1-(Vhold-Vrev)/(Vthis-Vrev));
                    else
                        fracCorr = 0;
                    end
                    Icap = Cm*(Vthis-Vlast)/si;
                    Icap = Icap*filterfactor;
                    data{iTrace}(i-1) = data{iTrace}(i-1)-(opt.fraction*Icap);
                    data{iTrace}(i-1) = data{iTrace}(i-1)*(1-fracCorr);
                    Vlast = Vthis;
                end
                
                
            end
            
            if ~dataIsCell
                obj.dataCorrected = cell2mat(data);
            else 
                obj.dataCorrected = data;
            end
            
            
            
            
            
            
            
        end
    end
    
end


