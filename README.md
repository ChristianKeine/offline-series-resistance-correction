# Offline series resistance correction 
[![DOI](https://zenodo.org/badge/154884750.svg)](https://zenodo.org/badge/latestdoi/154884750)

[![View Offline series resistance correction on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://de.mathworks.com/matlabcentral/fileexchange/69249-offline-series-resistance-correction)

Matlab(tm) function to perform offline series resistance correction/compensation of recorded currents based on [*"Traynelis SF (1998) Software-based correction of single compartment series resistance errors. J Neurosci Methods 86:25–34."*](https://dx.doi.org/10.1016/S0165-0270(98)00140-X). 



During whole-cell voltage-clamp experiments, the resistance across the patch pipette (series resistance) can introduce considerable errors on the amplitude and kinetics of the recorded currents. While in most cases a large portion of this error can be corrected online by the patch-clamp amplifier, the remaining Rs can lead to erroneous estimation of currents. This is especially important if the amount of uncompensated Rs changes during the recording or differs between experiments. A simple software-based solution allows for the correction of the remaining Rs after the experiment for linear current-voltage relationships (e.g. AMPA-R mediated currents; see original publication for details).

### How to use:

#### Input arguments:

- **data:** trace of recorded currents, can be either single vector or multiple traces organized in an array or cell. When the input is an array, the function assumes that the shorter dimension represents the different trials/recordings, i.e. an array of the size 10,000x10 will be treated as 10 recordings with 10,000 data points each

- **Rs:** uncompensated series resistance during the recordings in Ohm, i.e. if an Rs of 10 MOhm during the recording was compensated 50% by the amplifier, the uncompensated Rs is 5 MOhm (= 5e6 Ohm)
- **Cm:** Membrane capacitance during the recording in Farad (e.g. 10 pF = 10e-12 F)
- **Vhold:** holding potential during the recording in Volts (e.g. -60 mV = 0.06 V)
- **Vrev:** reversal potential of the recorded current in Volts (e.g. 10 mV = 0.01 V)
- **SR:** sampling rate of the recording in Hz (e.g. 50 kHz = 50e3 Hz)
- **fractionV:** [optional, default=1]: fraction of voltage error to be compensated [0-1] (e.g. 1 if voltage error should be fully compensated)
- **fractionC:** [optional, default=1]: fraction of capacitative filtering error to be compensated [0-1] (e.g. 1 capacitative filtering error should be fully compensated)
- **fc:** [optional]: cutoff frequency for filter to smooth capacitative current correction (in Hz) (if omitted, fc is calculated from the sampling interval as fc = 1/(2 * pi * si))

To execute call function as `RsCorrection(data, Rs, Cm, Vhold, Vrev, SR, 'fractionV', 1, 'fractionC', 1, 'fc', 10e3)
	`

#### Output:

object containg the followin properties:
- **dataRaw:** unprocessed input data 
- **dataCorrected:** data trace after Rs correction, format is identical to input (i.e. array or cell)
- **options:** structure containing the input parameters Rs, Cm, Vhold, Vrev, SR and fractions
