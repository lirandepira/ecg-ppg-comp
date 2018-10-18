load VEP.mat
VEP=VEP-mean(VEP);
N=length(VEP);
samplingRate=128;
timeAxis=(0:N-1)*(1/samplingRate);
figure(1)
plot(timeAxis,VEP,'.-')
xlabel('time (s)')
ylabel('VEP (ms)')