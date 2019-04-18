function croppedImage = cropImage(imageIn, x1, y1, x2, y2)
% CROPIMAGE Crops an image to a specific region of interest
%     x1: x-coordinate of first corner
%     y1: y-coordinate of first corner
%     x2: x-coordinate of second corner
%     y2: x-coordinate of second corner


% Get image dimensions
[h, w, ~] = size(imageIn);

if x1 == 0 || y1 == 0 || x2 == 0 || y2 == 0
    warning('[Error cropping image]: Chosen coordinates out of bounds - Indices start at 1 \n');
    return;
end

if x1 > w || x2 > w || y1 > h || y2 > h
    warning('[Error cropping image]: Chosen coordinates larger than image dimensions: (%d, %d)\n', w, h);
    return
end

croppedImage = imageIn(y1:y2, x1:x2, :);

end

