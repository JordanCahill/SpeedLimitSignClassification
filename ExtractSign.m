% FUNCTION: Isolate red pixels within the image and use to crop the sign
%
% image: image to extract digit from
% signroi: cropped image of sign
function signroi = ExtractSign(image)  

    % Ensure images all same size
    image = imresize(image,[450 450]);

    % Enhance Image
    imageEnhanced = EnhanceImage(image);

    % Isolate areas with red pixels
    redBW = IsolateRed(imageEnhanced);
    
    subplot(3,3,4);
    imshow(redBW);
    title('Isolated Red Pixels');

    % Remove connected components less than 20 pixels in area
    redBW = bwareaopen(redBW, 20);

    % Obtain properties for connected components
    stats = regionprops('table', redBW, 'Centroid', 'Area', 'EquivDiameter'); 

    % Remove any regions less than 200 pixels in area
    toDelete = stats.Area < 200;
    stats(toDelete,:) = [];

    % Obtain region stats
    centroids = stats.Centroid;
    diameters = stats.EquivDiameter;
    radii = diameters/2;

    % Ensure circle encapsulates entire number
    if radii < 140
        radii = radii*1.1;
    end

    stats = sortrows(stats, 1, 'descend');

    % Obtain stats for region with greatest area
    if (height(stats) == 1)
        radius = radii;
        centroid = stats.Centroid(1,:);
    elseif (height(stats) > 1)
        radius = max(radii);
        centroid = stats.Centroid(1,:);
    else
        radius = 150;
        centroid = [240,240];
    end

    subplot(3,3,5);
    imshow(imageEnhanced);
    title('Detected Circles');
    hold on
    viscircles(centroids,radii);
    hold off 

    % (x,y) coordinates of centroid
    xcentroid = centroid(:,1);
    ycentroid = centroid(:,2);

    % Bounding box for the region of interest
    roix1 = abs(ceil(xcentroid - radius));
    roiy1 = abs(ceil(ycentroid - radius));
    roix2 = round(xcentroid + radius);
    roiy2 = round(ycentroid + radius);

    % Get image dimensions
    [h, w, ~] = size(image);
    
    % limit coordinates to within image boundaries
    if roix1 <= 0
        roix1 = 1;
    end
    if roiy1 <= 0
        roiy1 = 1;
    end
    if roix2 >= w 
        roix2 = w-1; 
    end
    if roiy2 >= w 
        roiy2 = w-1; 
    end

    signroi = cropImage(image, roix1, roiy1, roix2, roiy2); % Crop image

    subplot(3,3,6);
    imshow(signroi);
    title('Cropped to Sign');
end
