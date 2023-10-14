function Send_function(cmaps,z)
%  send a hologram pattern to SLM

% close(1)
scrsz = get(0,'ScreenSize'); % getting the screensize of the 1 screen

% Defining figure position to be sent to SLM 
f1 = figure(1);
set(f1,'Position',[scrsz(3)+1 20 1920 1080],'MenuBar','none','ToolBar','none','resize','off') %fullscreen SLM
% set(f1,'Position',[scrsz(3)-50 15 1920 1080],'MenuBar','none','ToolBar','none','resize','off')

% sending z to SLM screen with a Grey colormap
image(z)
colormap(cmaps)

%eleminating superflous feature of the image
axis off 
set(gca,'position',[0 0 1 1],'Visible','off')

end