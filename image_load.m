function image_load(Initial_data_address,name,Format)

N = 1080; % re-size pixel numbers
dataname = strcat(Initial_data_address,name,Format);
InitialImg = imread(dataname);
% InitialImg = InitialImg(:,:,1); % For tif format

%% The image to be sent will be created as a matrix in the matlab workspace
% (the "z" matrix)
z=zeros(1080,1920); % note that the size fo the matrix has to be identical 
                    % to the SLM pixell extention
y = 1:1080;
x = 1:1920;

dx = N/2;
dy = N/2;

center_x = 960;
center_y = 540;

z((center_y-dy+1):(center_y+dy),(center_x-dx+1):(center_x+dx)) = InitialImg;

%%% define the grayscale matrix
% Grey_2=zeros(64,3);
% numscale=numel(Grey_2(:,1));
% for nn=1:numscale
% Grey_2(nn,:)=nn/numscale;
% end


% illustrative figure to be sent to the primary screen ()
figure(5)
set(gcf,'position',[480 270 960 540])

 
cmap=linspace(0/255,255/255,256);
cmaps=[cmap' cmap' cmap'];
image(z);
colormap(cmaps);
% title([num2str(dx) ',' num2str(Side_S)])
% colormap(Grey_2)

%% here the z matrix is sent to the 
%
Send_function(cmaps,z)

end