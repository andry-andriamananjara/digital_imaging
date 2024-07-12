function [coins] = estim_coins(measurement, bias, dark, flat)
    % estim_coins - Estimate the counts of different coin classes in an image.
    %
    % Inputs:
    %   measurement - Input image for coin detection
    %   bias - Mean of bias images
    %   dark - Mean of dark images corrected for bias
    %   flat - Normalized flat field image
    %
    % Outputs:
    %   coins - Array containing the counts of each coin class (1 to 6)
    %   corresponding to 5 cents, 10 cents, 20 cents, 50 cents, 1 euro and
    %   2 euros coins
    
    % Rescale the input images
    measurement = rescale(measurement); dark = rescale(dark); flat = rescale(flat); bias = rescale(bias);

    % Detect checkerboard points using MATLAB's detectCheckerboardPoints
    % function
    [checkerboardPoints, boardSize] = detectCheckerboardPoints(measurement, 'PartialDetections', false);
    
    % Calibrate intensity using bias, dark and flat field images
    calibratedImage = calibrateIntensity(measurement, bias, dark, flat, checkerboardPoints, boardSize);
    
    % Detect circular objects in the calibrated image
    [centers, radii] = detectCircularObjects(calibratedImage, checkerboardPoints, boardSize);
    
    % Calculate the scaling factor to help in determining the real world sizes of objects 
    scale = calculateScale(checkerboardPoints, boardSize);

    % Initialize array to store counts for each coin class
    coins = zeros(1, 6);

    % Determine the number of selected circular objects
    n = size(centers, 1);

    % Iterate through detected objects and classify each
    for j = 1:n
        % Extract features for the current circular object
        features = extractColorAndSizeFeatures(centers(j, :), radii(j), calibratedImage, scale);
        
        % classify the current circular object
        coinClass = classifier(features);
     
        % Check if coinClass is not zero [not a coin] and increment the corresponding element in coins
        if coinClass > 0
            coins(coinClass) = coins(coinClass) + 1;
        end
    end
end
