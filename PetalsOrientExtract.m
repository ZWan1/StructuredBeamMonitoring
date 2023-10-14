% To extract orientation of petal-like beams
% Written by£ºZhenyu Wan (z.wan.1@research.gla.ac.uk)

clear
close all

%% Input parameters
ImageAddress = '.\';
ImageName = 'Example-CentreResizedImage.png';

FeaturePoints = 2;  % number of feature points (ex. the petals)
Select = 0;         % 1 for self-choosing regions; 0 for not
Threshold = 200;    % remove the background noise under the threshold
Ibindex = 100;       % for 'bwareaopen' function

%% Main
ImageRead = strcat(ImageAddress,ImageName);
BeamPattern = imread(ImageRead);

% Imaging processing for removing outer rings
Ib = imadjust(BeamPattern,[Threshold/255 1],[0 1],0.2);
Ib(Ib<Threshold) = 0;

Ib = imbinarize(Ib);      % Binaryzation
Ib = bwareaopen(Ib,Ibindex);  % remove light areas with pixel numbers below Ibindex

if Select == 1
    Ib = bwselect(Ib); imshow(Ib);
end

% find centroid of each petal area
Centroid = regionprops(Ib, 'Centroid');
if size(Centroid,1) == FeaturePoints
   Petals = cat(1,Centroid.Centroid);
else
       Petals = cat(1,Centroid.Centroid);
    disp('Check the Threshold or FeaturePoints and rerun program');
end
BeamCentre = mean(Petals,1);

% calculate orientation of beam
if FeaturePoints == 2
    Orient = (Petals(1,2)-Petals(2,2))/(Petals(2,1)-Petals(1,1));
    Orient = atand(Orient);  % output -90~90
else
    Orient = zeros(FeaturePoints,1);
    for num = 1:FeaturePoints
        Orient(num) = (BeamCentre(2)-Petals(num,2))/(Petals(num,1)-BeamCentre(1));
    end
    Orient = atand(Orient);  % output -90~90
end

figure('color','w','position',[500 100 600 600]);
subplot(2,1,1)
imagesc(BeamPattern);
colormap gray; axis image; axis off;
subplot(2,1,2)
imagesc(Ib);
hold on
plot(Petals(:,1),Petals(:,2),'r.','MarkerSize',10);
plot(BeamCentre(1),BeamCentre(2),'r.','MarkerSize',10);
colormap gray; axis image; axis off;
