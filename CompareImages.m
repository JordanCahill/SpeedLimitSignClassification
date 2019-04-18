% Uses background subtraction to compare the extracted digit with gold
% standard versions of each possible digit to obtain confidence values.
% The highest confidence value decides which value to classify the sign as.
%
% testImage: Image to compare to gold standards
% bestMatch: Value for the classified speed limit
% bestConfidence: Associated confidence level for decision
function [bestMatch, bestConfidence] = CompareImages(testImage)
    
    testImage = imresize(testImage, [170 130]); % Images must be same size
    
    % Load gold standard digits directory
    targetFolder = 'images/GoldDigits/';
    images = dir(fullfile(targetFolder,'*.png'));
    numImages = length(images);

    for i = 1:numImages % Iterate through each gold standard digit
        
        % Load gold standard images
        file = fullfile(targetFolder, images(i).name);
        goldImage = imread(file);
               
        subplot(3,3,9);
        imshow(goldImage);
        title('Gold Standard Digit');
        drawnow;
        
        % Subtract test image from gold standard image
        output = imsubtract(goldImage, testImage);
        
        % Calculate the confidence value (the percentage of black pixels 
        % in the binary image)
        confidence(i) = 100*(sum(output(:)==0)/numel(output(:)));
    end
    
    % The output image with the highest percentage of black pixels is 
    % classified as the best match
    [~, index] = max(confidence);
    bestConfidence = max(confidence);
    
    valueSet = {100 20 30 50 80}; % List of possible values
    
    bestMatch = valueSet{index};  % Return best value
    
end
