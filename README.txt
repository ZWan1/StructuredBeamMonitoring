# Longitudinally scanning and monitoring structured beams - MATLAB Codes

------- Description:
* This repository contains code for the paper ''The lagging propagation phase of spatially structured beams'' by Zhenyu Wan, Ziyi Tang and Jian Wang.

* The codes can be used to implement data collection and processing, where devices in the experiments are controlled to scan the 3D profile of the structured beams including an SLM (to create structured beams), a moving stage (to scan longitudinally), and a CCD (to observe).

------- Statement:
The following codes are provided in the spirit of reproducible research. We make our code available to the public for academic purposes.

------- Contact:
Questions can be addressed to Zhenyu Wan (z.wan.1@research.gla.ac.uk) and Ziyi Tang (1270989697@qq.com).

----------------------------------------------
Description of files in this folder
----------------------------------------------
Two main programs in data collection:

''Measure_Picturetool.m'': image acquisition with the moving stage at different locations.

''Measure_Videotool.m'': video acquisition with the moving stage through a certain distance.

Subfunctions that can be involved:

////Moving Stage Control

Detailed documents on MATLAB ActiveX control can be access on Mathworks website
http://www.mathworks.com/access/helpdesk/help/techdoc/matlab_external/bqdwu3j.html 

Three relevant subfunctions:

''APT_GUI.m'': create the GUI to connect and controll the Thorlabs moving stage (DDS300/M).

"MoveCompleteHandler.m": events to display "Moving Completed" after the movement is completed.

"IsMoving.m": reads the status about moving states and return the status (1-moving, 0-moving completed).

////Hologram Create and SLM Control

Three relevant subfunctions:

"HoloeyeSLM_BesselBeam.m": to create hologram patterns of Bessel Beam for uploading on SLM (Holoeye)

"image_load.m": reads images in the specified folder and handles image size.

"Send_function.m": is involved at the end of the image_load.m for loading the desired image to the second screen of the computer, e.g. SLM.

////Codes about Camera (CCD)

The codes for camera controlling is created by the "Image Acquisition" APP in Matlab, which can connect to the camera and take photos. For example,"vid = videoinput('gige', 1, 'Mono8'); src = getselectedsource(vid);" digitize camera parameters through variables in MATLAB.

------------------------------------------------
Two main programs in data processing:

''ImageCentreResize.m'': To find the beam centre on captured images and resize the image before calculating the orientation of petals. ("Example-OriginalImage.png" is an example for running this code)

''PetalsOrientExtract.m'': To extract orientation of petal-like beams.
