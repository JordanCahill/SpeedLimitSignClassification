% Detects and classifies the images in the 'all' folder and prints the
% combined results to the command line.
function ClassifyAll()
    
    numFolders = 5;
    totalAccuracy = 0;
    totalNumImages = 0;
    totalConfidence = 0;

    % Key-value pairs to map the performance of each folder (to print later)
    accuracyForFolder = containers.Map('KeyType','char','ValueType','double');
    confidenceForFolder = containers.Map('KeyType','char','ValueType','double');

    for j = 1:numFolders % Loop through each folder loading directory and groundTruth value
        switch j
            case 1
                targetFolder = 'images/100/';
                groundTruth = 100;
            case 2
                targetFolder = 'images/20/';
                groundTruth = 20;
            case 3
                targetFolder = 'images/30/';
                groundTruth = 30;
            case 4
                targetFolder = 'images/50/';
                groundTruth = 50;
            case 5
                targetFolder = 'images/80/';
                groundTruth = 80;
        end
        
        images = dir(fullfile(targetFolder,'*.jpg'));
        numImages = length(images);
        
        
        % Running counters
        correctMatches = 0;			% Number of correctly identified signs
        runningConfidence = 0;      % Max value from background subtraction
        totalNumImages = totalNumImages + numImages;
        
        fprintf('\nProcessing target folder: %s\n', targetFolder);

        for i = 1:numImages
           
            % Load images
            file = fullfile(targetFolder, images(i).name);
            image = imread(file);
            
            subplot(3,3,1);
            imshow(image);
            title('Original Image');

            sign = ExtractSign(image);  % Detect and extract sign
            
            [digit, ~] = ExtractDigit(sign); % Detect and extract leading digit            
            
            % Classify the sign based on the leading digit
            [bestMatch, confidence] = CompareImages(digit);

            if bestMatch == groundTruth % Evaluate decision
                correctMatches = correctMatches + 1;   
                result = 'Correct';
            else
                result = 'Incorrect';
            end

            runningConfidence = runningConfidence + confidence;

            % Print results
            fprintf('%d: Image name: %s | Predicted: %d | Actual: %d | Confidence: %.2f%% | Result: %s\n', ...
                i, images(i).name, bestMatch, groundTruth, confidence, result);

        end

        % Calculate and print stats for the current folder
        accuracy = correctMatches/numImages*100;
        avgConfidence = runningConfidence/numImages;
        
        fprintf('\nStats for target folder: %s\n', targetFolder);
        fprintf('Accuracy: %.2f%% (%d/%d)\n', accuracy, correctMatches, numImages);
        fprintf('Mean Confidence: %.2f%%\n', avgConfidence);
        
        accuracyForFolder(targetFolder) = accuracy;
        confidenceForFolder(targetFolder) = avgConfidence;
        
        totalAccuracy = totalAccuracy + accuracy;
        totalConfidence = totalConfidence + avgConfidence;

    end

    % Calculate and print stats for the overall system
    totalAccuracyAvg = totalAccuracy/numFolders;
    totalConfidenceAvg = totalConfidence/numFolders;
    
    fprintf('\n\n\nOverall System Stats:\n\n');
    
    for k = keys(accuracyForFolder)
        folderKey = k{1};
        fprintf('Accuracy for target folder "%s": %.f%%.\n', ...
            folderKey, accuracyForFolder(folderKey));
        fprintf('Confidence for target folder "%s": %.f%%.\n\n', ...
            folderKey, confidenceForFolder(folderKey));
    end
    
    fprintf('Overall System Accuracy: %.2f%%\n', totalAccuracyAvg);
    fprintf('Overall System Confidence: %.2f%%\n', totalConfidenceAvg);

end

