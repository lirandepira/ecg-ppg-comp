load FAsignal.mat
samplingRate=128;
gain=1e-3; % mV / ADCunit
% we want the signal in mV:
FAsignal=FAsignal*gain;
N=length(FAsignal);
timeAxis=(0:1/samplingRate:(N-1)*1/samplingRate);
plot(timeAxis,FAsignal,'.-')
figure (1)
xlabel('time (minutes)')
ylabel('RR interval (ms)')