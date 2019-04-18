% FUNCTION: Enhances the image for classification by dynamically increasing the
% brightness and sharpness of the image, as well as the intensity of red
% pixels
function imgEnhanced = EnhanceImage(img)
    
    % Adaptively adjusting lighting values by checking if the mean pixel intensity 
    % value is below a specific threshold, and increasing the pixel intensity by a 
    % gamma value factor relative to the current intensity if needed
    imgGray = rgb2gray(img);
    intensity = mean(imgGray(:));
    gammafactor = 0.005;
    if intensity < 80
        img = imadjust(img, [], [], intensity * gammafactor);
    end
       
    % Sharpen Image
    img = imsharpen(img,'Radius',2,'Amount',1);   
    
    % Convert RGB image to HSV
    imageHSV = rgb2hsv(img);

    % Extract H, S and V channels
    hue = imageHSV(:, :, 1);
    sat = imageHSV(:, :, 2);
    val = imageHSV(:, :, 3);

    subplot(3,3,2);
    imshow(imageHSV);
    title('HSV Image');

    % Increase saturation value if needed
    if sat < 0.3
        sat = sat * 3.5;
    end  
    
    % Create HSV image with new saturaton value
    newimg = cat(3, hue, sat, val);

    % Convert back to RGB
    imgEnhanced = hsv2rgb(newimg);
    
    subplot(3,3,3);
    imshow(imgEnhanced);
    title('Enhanced Image');
    
end

