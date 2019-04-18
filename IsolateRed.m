% FUNCTION: Used to isolate red pixels within the image by converting to
% HSV colorspace and thresholding the hue and saturation channels
%
% imageRGB: RGB image to isolate red pixels
% out: logical image (On: Red pixel, off: Non-red pixel)
function out = IsolateRed(imageRGB)

    % Convert RGB image to HSV
    imageHSV = rgb2hsv(imageRGB);

    % Separate channels
    hue = imageHSV(:, :, 1);
    sat = imageHSV(:, :, 2);
    val = imageHSV(:, :, 3);

    % Thresholds for 'H' channel - Red in the colorspace is roughly above 300
    % degrees and below 30 (Centered about 0 degrees)
    hMin = 300/360;
    hMax = 60/360;   
    
    % Thresholds for 'S' channel
    sMin = 0.45;
    sMax = 1.0;
    
    % Threshold image
    out = (hue >= hMin | hue <= hMax) &...
        (sat >= sMin & sat <= sMax);
end
