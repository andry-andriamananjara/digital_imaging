function calibratedImage = calibrateIntensity(measurement, meanBias, meanDark, normFlat, checkerboardPoints, boardSize)
    % calibrateIntensity - Calibrates the intensity of a given measurement image using bias, dark, and flat field images.
    %
    % Inputs:
    %   measurement - Original measurement image.
    %   meanBias - Mean intensity of the bias image.
    %   meanDark - Mean intensity of the dark image.
    %   normFlat - Normalized flat field image.
    %   checkerboardPoints - Detected checkerboard points.
    %   boardSize - Size of the checkerboard.
    %
    % Output:
    %   calibratedImage - Calibrated intensity image.
    % Replace checkerboard points in the normalized flat field image with background intensity 
    normFlatWithoutCheckerboard = replaceCheckerboardWithBackgroundIntensity(normFlat, checkerboardPoints, boardSize);
    
    % Calibrate the intensity using the provided formula in exercise
    % session
    calibratedImage = ((measurement - meanBias - meanDark) ./ normFlatWithoutCheckerboard);
end