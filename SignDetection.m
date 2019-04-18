% Author: Jordan Cahill
% Date: 17/04/2019
%
% Program used to detect and classify european speed limit signs. Signs can
% can contain the following values: 20, 30, 50, 80, 100
%
% The program contains two paths. One is by setting the folder variable to
% 'all' and running the script. The system will then attempt to classify
% all jpeg images in the "images/all" directory.
% The folder variable can also be set to a specific folder (E.g. '30'). This
% folder name must be the value of the speed limit and in the 'images' folder 
%
% Method:
%   1. Enhance Image - Increase red channel saturation, sharpness, brightness
%   2. Isolate red pixels
%   3. Detect red circle and crop to circle
%   4. Binarize and threshold image to obtain mask
%   5. Detect the most significant digit of the sign using regionprops
%   6. Crop digit
%   7. Subtract test digit from gold standard digits to obtain confidence levels
%   8. Classify based on confidence levels


addpath(genpath(pwd));          % Allow script to access methods in subdirectories
clearvars; close all; clc;      % Clear workspace

folder = '30';

if strcmp(folder,'all')
    ClassifyAll();
else
    ClassifyFolder(folder, 1);  % If second variable set to 1, system will 
end                             % skip images where it thinks it could not 
                                % detect a digit (for debugging and
                                % performance testing)


