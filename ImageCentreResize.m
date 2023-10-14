% To find the beam centre on captured images and resize the image before
% calculating the orientation of petals
% Written By Zhenyu Wan (z.wan.1@research.gla.ac.uk)
% length unit: m

close all
clear

%% Input Parameter
CutN = 250;   % pixel numbers of clipping
N = 1000;     % resized pixel numbers

FeaturePoints = 2;  % number of feature points (ex. the petals)
Select = 0;         % 1 for self-choosing regions; 0 for not
Threshold = 200;    % remove the background noise under the threshold
Ibindex = 100;       % for 'bwareaopen' function

AdjX = 0;           % additional centre adjustment (pixels)
AdjY = 0;           % additional centre adjustment (pixels)

%% Preparing
ImageAddress = '.\';
SaveAddress = '.\';
ImageName = 'Example-OriginalImage.png';
SaveName = 'Example-CentreResizedImage.png';
ImageRead = strcat(ImageAddress,ImageName);
InitialImg = imread(ImageRead);

%% Find beam centre
% Imaging processing for removing outer rings
Ib = imadjust(InitialImg,[Threshold/255 1],[0 1],0.2);
Ib(Ib<Threshold) = 0;

Ib = imbinarize(Ib);      % Binaryzation
Ib = bwareaopen(Ib,Ibindex);  % remove light areas with pixel numbers below Ibindex

if Select == 1
    Ib = bwselect(Ib); imshow(Ib);
end
Ib = imfill(Ib,'holes');      % fill hole space

% find centroid of each petal area
Centroid = regionprops(Ib, 'Centroid');
if size(Centroid,1) == FeaturePoints
   Petals = cat(1,Centroid.Centroid);
else
    disp('Check the Threshold or FeaturePoints and rerun program');
end
BeamCentre = mean(Petals,1);

figure('color','w','position',[100 100 600 600]);
subplot(2,1,1)
imagesc(InitialImg);
colormap gray; axis image; axis off;
subplot(2,1,2)
imagesc(Ib);
hold on
plot(Petals(:,1),Petals(:,2),'r.','MarkerSize',10);
plot(BeamCentre(1),BeamCentre(2),'r.','MarkerSize',10);
colormap gray; axis image; axis off;
hold off

%% Image cut
BeamCentre = round(BeamCentre)+[AdjY AdjX];
OutputImg = InitialImg(BeamCentre(2)-CutN/2:BeamCentre(2)+CutN/2-1,BeamCentre(1)-CutN/2:BeamCentre(1)+CutN/2-1); % image cut
if N ~= CutN
    OutputImg = imresize(OutputImg,[N N]);
end

% Image processing ------------------------------
% (1) DCT low-pass spatial frequency filtering
HighRate = 1/12;
LowRate = 1/5000;
OutputImgAdj = Image_SpatialFrequencyFiltering(OutputImg,HighRate,LowRate);
% (2) gray scale adjust with gray contrast enhancement (imadjust)
OutputImgAdj = im2double(OutputImgAdj)/255;
OutputImgAdj = imadjust(OutputImgAdj,[0.04 1],[0 1],1);

figure('color','w','position',[800 50 300 700]);
subplot(2,1,1)
imagesc(OutputImg); colormap gray; axis image; axis off;
subplot(2,1,2)
imagesc(OutputImgAdj); colormap gray; axis image; axis off;

filename = strcat(SaveAddress,SaveName);
imwrite(OutputImgAdj,filename,'png');

function Image_Filtered = Image_SpatialFrequencyFiltering(Image_2D,HighRate,LowRate)
    % To make spatial-frequency filtering to an 2D image
    % Image_2D: input Image (M*N matrix)
    % HighRate: spatial-frequency upper limit rate (takes 0~1)
    % LowRate: spatial-frequency lower limit rate (takes 0~1) (LowRate<HighRate)
    % Image_Filtered: output image after spatial-frequency filtering
    DCT_Image_2D = dct2(Image_2D);     % Discrete Cosine Transformation
    [m,n] = size(DCT_Image_2D);        % size of image
    Filter = zeros(m,n);
    Filter(1+floor(m*LowRate):ceil(m*HighRate),1+floor(n*LowRate):ceil(n*HighRate)) = 1;
    DCT_Image_2D_filtering = DCT_Image_2D.*Filter;
    Image_Filtered = idct2(DCT_Image_2D_filtering);
end