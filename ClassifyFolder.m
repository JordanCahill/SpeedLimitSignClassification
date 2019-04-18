% FUNCTION: Detects and classifies the images in the folder specified by the 'target' parameter
% and prints the combined results to the command line.
%
% target: Name of the folder to classify - must be the speed limit on the sign
function ClassifyFolder(target, skipMissingDigits)
    
    groundTruth = str2double(target);   % Actual value on sign
    
    % Load directory
    targetFolder = strcat('images/', target);
    images = dir(fullfile(targetFolder,'*.jpg'));
    numImages = length(images);
    
    % Running counters
    TP = 0;                     % True Positives
    runningConfidence = 0;      % Max value from background subtraction

    for i = 1:numImages
        % Load images
        file = fullfile(targetFolder, images(i).name);
        image = imread(file);
        
        subplot(3,3,1);
        imshow(image);
        title('Original Image');

        sign = ExtractSign(image);  % Detect and extract sign
            
        [digit, found] = ExtractDigit(sign); % Detect and extract leading digit    
        
        % If set, program skips images where it thinks it could not detect a digit
        % [Used for debugging and performance testing]
        if skipMissingDigits == 1 && found == 0
            fprintf('Digit not found, skipping..\n');
            numImages = numImages - 1;
            continue;
        end

        % Classify the sign based on the leading digit
        [bestMatch, confidence] = CompareImages(digit);

        if bestMatch == groundTruth % Evaluate decision
            TP = TP + 1;   
            result = 'Correct';
        else
            result = 'Incorrect';
        end

        runningConfidence = runningConfidence + confidence;

        % Print results
        fprintf('%d: Image name: %s | Predicted: %d | Actual: %d | Confidence: %.2f%% | Result: %s\n', ...
            i, images(i).name, bestMatch, groundTruth, confidence, result);

    end

    % Calculate and print stats for the system
    fprintf('\nSystem Performance:\n');
    if skipMissingDigits == 1
        fprintf('Note: Skipped images where digits were not detected\n');
    end
    accuracy = TP/numImages*100;
    avgConfidence = runningConfidence/numImages;
    fprintf('Accuracy: %.2f%% (%d/%d)\n', accuracy, TP, numImages);
    fprintf('Mean Confidence: %.2f%%\n', avgConfidence);

end

