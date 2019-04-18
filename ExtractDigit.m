% FUNCTION: Isolate black digits within the image and crop to the most
% significant digit on the sign
%
% image: image to extract digit from
% digitroi: cropped image of digit
% found: 1 if digit detected, else 0
function [digitroi, found] = ExtractDigit(image)

    refCoord = [80 130]; % Reference coordinate to compare each proposed region 
    
    % Convert to grayscale and increase contrast
    imgGray = rgb2gray(image); 
    imgGray = histeq(imgGray); 
    
    % Binarize and invert image
    mask = imbinarize(imgGray,0.3);
    mask = ~mask;
    
    subplot(3,3,7);
    imshow(mask);
    title('Isolated Black Pixels');
    
    % Obtain properties for connected components
    stats = regionprops('table', mask, 'Area', 'Centroid', 'BoundingBox'); 
    
    % Remove large and small components
    lowerAreaThresh = stats.Area < 3000;
    upperAreaThresh = stats.Area > 14000;
    toDelete = logical(lowerAreaThresh + upperAreaThresh);
    stats(toDelete,:) = [];
    
    if isempty(stats) || height(stats)==0
        % Case where no digit is found
        digitroi = mask;
        found = 0;
    else
        found = 1;
        closest = 650; % Running closest distance between region centroid and reference centroid
        BB = [];       % Bounding box of digit

        % Iterate through each bounding box and search for the centroid closest
        % to the reference centroid
        for i = 1:height(stats)
            dist = norm(refCoord-stats.Centroid(i));
            if dist < closest
                closest = dist;
                BB = stats.BoundingBox(i,:);
            end
        end

        % Obtain bounding box coordinates (ceil and floor to keep within image
        % boundaries)
        x1 = ceil(BB(1,1)); 
        y1 = ceil(BB(1,2));
        x2 = x1 + floor(BB(1,3)-1); 
        y2 = y1 + floor(BB(1,4)-1);

        digitroi = cropImage(mask, x1, y1, x2, y2); % Crop digit
    end
    
    subplot(3,3,8);
    imshow(digitroi);
    title('Extracted Digit');

end

