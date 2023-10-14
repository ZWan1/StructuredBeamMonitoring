% To create hologram patterns of Bessel Beam for uploading on SLM (Holoeye)
% Written By Zhenyu Wan (z.wan.1@research.gla.ac.uk)
% length unit: m

clear;
close all;

%% Input parameters
H = 1080;          % x pixel number
V = 1080;          % y pixel number
pixel_size = 8e-6; % pixel size

lambda = 532e-9;   % wavelength
d_grating = 6*8e-6;     % grating period
grating = 1;            % 1-have grating; 0-no grating
G_tha = -1;             % grating direction: right 1   left -1

% aberration compensation of SLM (a simplified compensation)
Compensate = 1;          % 1 for compensate with digital cylindrical lens; 2 for with digital lens; 0 for without both
f = 12.2;                % focal distance of compensated lens
RotatingAngle = pi*0.38; % Orientation of cylindrical lens

w0 = 2.5e-3;             % waist of Gaussian profile (to limit the beam size)
L = [1];                 % OAM orders
Alpha = [0.001];         % cone angle (Unit: radian) (=kr/k0)
A = [1];                 % weight of each component
InitialPhase =[0]*pi;    % initial phase of each component

%% Main
% Coordinates and Grids
y = linspace(-(V/2),(V/2)-1,V)*pixel_size; % Scales the hologram in the V direction
x = linspace(-(H/2),(H/2)-1,H)*pixel_size; % Scales the hologran in the H direction
[X,Y] = meshgrid(x,y);
phi = angle(X+1i*Y);
rho = sqrt(X.^2+Y.^2);

% Field creation
k0 = 2*pi/lambda;
Ln = length(L);
A = sqrt(A./Ln);                     % normalization
SuperposedField = zeros(V,H);
for m = 1:Ln
    alpha = Alpha(m);
    n = L(m);
    kr = alpha*k0;
    E_Bessel = A(m).*exp(1i*(-n*phi+kr*rho)+1i*InitialPhase(m));   % Bessel
    SuperposedField = SuperposedField + E_Bessel;
end

% compensating the SLM aberration
XR = cos(RotatingAngle)*X-sin(RotatingAngle)*Y; % rotating coordinates for cylindrical lens
if Compensate == 1  % cylindrical lens (gradient along X with rotating angle)
    Lens = exp(1i*k0/(2*f)*(XR.^2));
    SuperposedField = SuperposedField.*Lens; % compensate with cylindrical lens
end
if Compensate == 2  % digital lens
    Lens = exp(1i*k0/(2*f)*(X.^2+Y.^2));
    SuperposedField = SuperposedField.*Lens; % compensate with lens
end

% Add grating
phase = angle(SuperposedField);
THA = asin(lambda/d_grating)*G_tha;          % 1-order diffractive angle
if grating == 1
    PhaseTerm = mod(phase+2*pi/lambda*sin(THA)*X,2*pi);    % Add grating
else
    PhaseTerm = mod(phase,2*pi);    % Non-grating
end

GaussianProfile = exp(-rho.^2/w0^2);
PhaseTerm = PhaseTerm.*GaussianProfile;
SLM_pattern = PhaseTerm/2/pi*255;   % 0-255 corresponds to 0-2pi modulation

figure
imagesc(SLM_pattern);
axis square;
axis xy;
colorbar;
cmap=linspace(0/255,255/255,256);
cmaps=[cmap' cmap' cmap'];
colormap(cmaps);

%% Saving
n_l = length(L);
SavingAddress ='.\';
filename = strcat(SavingAddress,'BG-w',num2str(w0*1e3),'mm');
for n = 1:n_l
    if L(n) >= 0
        sign = '+'; TC = abs(L(n));
    else
        sign = '-'; TC = L(n);
    end
    filename = strcat(filename,'_l',sign,num2str(TC),'Alpha',num2str(Alpha(n)));
end

if grating == 1
    filename = strcat(filename,'_d',num2str(d_grating*1e6),'um_','forked',num2str(G_tha),'.bmp');
else
    filename = strcat(filename,'NonGrating.bmp');
end
imwrite(SLM_pattern,cmaps,filename,'bmp');
