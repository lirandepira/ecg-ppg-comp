% Create an object to read the sample file, ECG_signal.mp4
video = VideoReader('ECG_signal.mp4');

%% Make 1D array with length equal to number of frames (time)

brightness = zeros(1, video.CurrentTime);
video_framerate = round( video.FrameRate); % note some places in the code must use integer value for framerate, others we directly use the unrounded frame rate

%%
v.CurrentTime = 10; % currentTime new for numberOfFrames
% Create an axes. Then, read video frames until no more frames are available to read.
currAxes = axes;
while hasFrame(video)
    vidFrame = readFrame(video);
    image(vidFrame, 'Parent', currAxes);
    currAxes.Visible = 'on';
    pause(1/video.FrameRate);
end

%% set region of interest for what you want to get average brightness of
rect = getrect;

xmin_pt = round(rect(1));
ymin_pt = round(rect(2)); 
section_width = round(rect(3)); 
section_height = round(rect(4));

%% select component of video (red green or blue)
component_selection = 1; % pick red , green, or blue

%% make 1D array of ROI averages
 for i = 1:video.currentTime,
     frame = readFrame(video, i);
     section_of_interest = frame(ymin_pt:ymin_pt+section_height,xmin_pt:xmin_pt+section_width,:);
     colorPlane = section_of_interest(:, :, component_selection);
     brightness(i) = sum(sum(colorPlane)) / (size(frame, 1) * size(frame, 2));
 end


%% Filter out non-physiological frequencies
BPM_L = 40;    % Heart rate lower limit [bpm]
BPM_H = 600;   % Heart rate higher limit [bpm] This is currently set high to investigate the signal

% Butterworth frequencies must be in [0, 1], where 1 corresponds to half the sampling rate
[b, a] = butter(2, [((BPM_L / 60) / video_framerate * 2), ((BPM_H / 60) / video_framerate * 2)]);
filtBrightness = filter(b, a, brightness);


%% Trim the video to exlude the time where the camera is stabilizing
FILTER_STABILIZATION_TIME = 3;    % [seconds]
filtBrightness = filtBrightness((video_framerate * FILTER_STABILIZATION_TIME + 1):size(filtBrightness, 2));

%% Do FFT on filtered/trimmed signal
fftMagnitude = abs(fft(filtBrightness));

%% Plot results

figure(1)
subplot(3,1,1)
plot([1:length(brightness)]/video.FrameRate,brightness)
xlabel('Time (seconds)')
ylabel('Color intensity')
title('original signal')

subplot(3,1,2)
plot([1:length(filtBrightness)]/video.FrameRate,filtBrightness)
xlabel('Time (seconds)')
ylabel('Color intensity')
title('after butterworth filter and trim')


freq_dimension = ((1:round(length(filtBrightness)))-1)*(video_framerate/length(filtBrightness));

subplot(3,1,3)
plot(freq_dimension,fftMagnitude)
axis([0,15,-inf,inf])
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
title('Fft of filtered signal')