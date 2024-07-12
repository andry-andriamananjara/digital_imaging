function [meanBias, meanDark, meanFlat] = imagesMeans(biasImagesFolder, darkImagesFolder, flatImagesFolder)
    % imagesMeans - Calculate mean bias, mean dark, and mean flat images.
    % 
    %   Inputs:
    %   - biasImagesFolder: Folder path containing bias images
    %   - darkImagesFolder: Folder path containing dark images
    %   - flatImagesFolder: Folder path containing flat images
    %
    %   Outputs:
    %   - meanBias: Mean bias images
    %   - meanDark: Mean of dark images corrected for bias
    %   - meanFlat: Normalized flat field image corrected for bias and dark


    % Bias
    %----------------------------------------------------------------------------------------------------------------------------------
    % Check whether folder exists
    if ~isfolder(biasImagesFolder)
      errorMessage = sprintf('Error: The following folder does not exist:\n%s', biasImagesFolder);
      uiwait(warndlg(errorMessage));
      return;
    end
    % Obtain a list of file information for all files with the extension '.JPG' 
    imageFiles = dir(fullfile(biasImagesFolder, '*.JPG'));  
    % Initialize variables for mean calculation
    sumImage = uint8(zeros(size(imread(fullfile(biasImagesFolder, imageFiles(1).name)))));
    numImages = 0;
    % Calculate the sum
    for i = 1:length(imageFiles)
        % Get the file path for each image
        filePath = fullfile(biasImagesFolder, imageFiles(i).name);
        % Read image
        currentImage = imread(filePath);
        % Add the current image to the sum
        sumImage = sumImage + currentImage;
        % Increment the count of images
        numImages = numImages + 1;
    end
    % Calculate the mean bias
    meanBias = sumImage ./ numImages;
    clearvars imageFiles sumImage numImages currentImage filePath;


    % Dark
    %----------------------------------------------------------------------------------------------------------------------------------
    % Check whether folder exists
    if ~isfolder(darkImagesFolder)
      errorMessage = sprintf('Error: The following folder does not exist:\n%s', darkImagesFolder);
      uiwait(warndlg(errorMessage));
      return;
    end
    % Obtain a list of file information for all files with the extension '.JPG' 
    imageFiles = dir(fullfile(darkImagesFolder, '*.JPG'));  
    % Initialize variables for mean calculation
    sumImage = uint8(zeros(size(imread(fullfile(darkImagesFolder, imageFiles(1).name)))));
    numImages = 0;
    % Calculate the sum 
    for i = 1:length(imageFiles)
        % Get the file path for each image
        filePath = fullfile(darkImagesFolder, imageFiles(i).name);
        % Read image
        currentImage = imread(filePath);
        % Subtract from mean bias
        currentImageUpdate = currentImage - meanBias;
        % Add the current image to the sum
        sumImage = sumImage + currentImageUpdate;
        % Increment the count of images
        numImages = numImages + 1;
    end
    % Calculate the mean dark image
    meanDark = sumImage ./ numImages;
    clearvars imageFiles sumImage numImages currentImage currentImageUpdate filePath;

    % Flat
    %----------------------------------------------------------------------------------------------------------------------------------
    % Check whether folder exists
    if ~isfolder(flatImagesFolder)
      errorMessage = sprintf('Error: The following folder does not exist:\n%s', flatImagesFolder);
      uiwait(warndlg(errorMessage));
      return;
    end
    % Obtain a list of file information for all files with the extension '.JPG' 
    imageFiles = dir(fullfile(flatImagesFolder, '*.JPG'));  
    % Initialize variables for mean calculation
    sumImage = uint8(zeros(size(imread(fullfile(flatImagesFolder, imageFiles(1).name)))));
    numImages = 0;
    % Calculate the sum 
    for i = 1:length(imageFiles)
        % Get the file path for each image
        filePath = fullfile(flatImagesFolder, imageFiles(i).name);
        % Read image
        currentImage = imread(filePath);
        % Subtract from mean bias and dark
        currentImageUpdate = currentImage - meanBias - meanDark;
        % Add the current image to the sum
        sumImage = sumImage + currentImageUpdate;
        % Increment the count of images
        numImages = numImages + 1;
    end
    % Calculate the mean flat image
    meanFlat = uint8(double(sumImage)./double(max(sumImage(:))));   
end
