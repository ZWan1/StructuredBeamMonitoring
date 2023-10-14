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

%% camera setting
vid = videoinput('gige', 1, 'Mono8');  % control camera through a gige connection
src = getselectedsource(vid);
src.AcquisitionFrameRateAbs = 5;
src.ExposureTimeAbs = 135;
vid.FramesPerTrigger = 1;
% src.AcquisitionFrameCount = 100;
% src.PacketSize = 8000;
% vid.ROIPosition = [772 291 540 540];

%% Main
%    h.SetAbsMovePos(0,300);
%    h.MoveAbsolute(0,1==0);

k = 30;
j = 3;
for m = 1:j
    measure_number=m;
    src.ExposureTimeAbs = 500-(m-1)*20;
    
    for n=0:k
       
        h.SetAbsMovePos(0,300-10*n);
        h.MoveAbsolute(0,1==0);
    %      pause(0.5);
        % camera
        start(vid);
        im=getdata(vid);
        
        Save_pic_address = '.\';
        Save_picname=strcat(num2str(src.ExposureTimeAbs),'-z');
        Save_unit = 'cm';
        Save_picname= strcat(Save_picname,num2str(n),Save_unit);
        Savename = strcat(Save_pic_address,Save_picname);
        Save_Format = '.png';
        Save_address=strcat(Savename,Save_Format); 
        imwrite(im,Save_address);
        eval(['Save_picname', '=', 'im',';']);
        save(Savename,'Save_picname')
    
    end
    
    h.SetAbsMovePos(0,300);   % reset position
    h.MoveAbsolute(0,1==0);
    pause(7);
end
