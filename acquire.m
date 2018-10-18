function y = acquire(ECG_signal)
v = VideoReader('ECG_signal.mp4');

if ischar(ECG_signal),
    display(['Loading file ' ECG_signal]);
    v = VideoReader(ECG_signal);
else
    v = ECG_signal;
end

numFrames = 400;

display(['Total frames: ' num2str(numFrames)]);

y = zeros(1, numFrames);
for i=1:numFrames,
    display(['Processing ' num2str(i) '/' num2str(numFrames)]);
    frame = readFrame(v, i);
    redPlane = frame(:, :, 1);
    y(i) = sum(sum(redPlane)) / (size(frame, 1) * size(frame, 2));   
end

display('Signal acquired.');
display(' ');
display(['Sampling rate is ' num2str(v.FrameRate) '. You can now run process(your_signal_variable, ' num2str(v.FrameRate) ')']);

end