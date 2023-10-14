%  Load holograms to SLM; camera capturing; Moving stage controller.
%  Written by: Ziyi Tang (1270989697@qq.com)

close all;
clear; clc;

%% Connect to Thorlab DDS300/M stage
global h;
h=APT_GUI;
pause(15); 

%% First load SLM pattern image
Initial_data_address = '.\';
name = 'BG-w2.5mm_l+1Alpha0.001_d48um_forked-1';
Format = '.bmp';
image_load(Initial_data_address,name,Format);

%% camera video setting
vid = videoinput('gige', 1, 'Mono8');
src = getselectedsource(vid);
src.AcquisitionFrameRateAbs = 5;
src.ExposureTimeAbs = 75;
vid.FramesPerTrigger = 100;
src.AcquisitionFrameCount = 100;
src.PacketSize = 8000;
vid.ROIPosition = [772 291 540 540];

%%
   h.SetAbsMovePos(0,250);
   h.MoveAbsolute(0,1==0);

%% Measurement1 Operation
   
%     pause(1);
    % camera
    preview(vid);
    pause(1);
    start(vid);
    
    h.SetAbsMovePos(0,50);
    h.MoveAbsolute(0,1==0);
    
    pause(21);
    stoppreview(vid);
    
    diskLogger = VideoWriter('.\', 'Grayscale AVI');
    diskLogger.FrameRate = 20;

    open(diskLogger);
    data = getdata(vid, vid.FramesAvailable);
    numFrames = size(data, 4);
    for ii = 1:numFrames
    writeVideo(diskLogger, data(:,:,:,ii));
    end
    close(diskLogger);
    
    pause(2);
    
    h.SetAbsMovePos(0,250);
    h.MoveAbsolute(0,1==0);
