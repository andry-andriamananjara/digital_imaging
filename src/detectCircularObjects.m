function [circleCenters, circleRadii] = detectCircularObjects(image, checkerboardPoints, boardSize, visualize)
    % detectCircularObjects - Detect circular objects in an image.
    %
    % Inputs:
    %   - image: Input image containing circular objects.
    %   - checkerboardPoints: Detected checkerboard points for background correction.
    %   - boardSize: Size of the checkerboard.
    %   - visualize: Optional flag for visualization (default is false).
    %
    % Outputs:
    %   - circleCenters: Coordinates of the detected circle centers.
    %   - circleRadii: Radii of the detected circular objects.
    
    % Check if the visualization flag is provided as an input argument
    if nargin > 3
      visualize = visualize;
    else
      visualize = false; % If no value is provided, set visualize to false by default
    end

    % Convert the image to grayscale
    grayImage = im2gray(image);
    
    % Apply small filtering to reduce any noise
    % grayImage = imfilter(grayImage, fspecial("average", [2, 2]));
    % grayImage = medfilt2(grayImage);

    % Edge detection
    % [~, threshold] = edge(grayImage, "canny");
    % fudgeFactor = 1.5;
    % imgedge = edge(grayImage, "canny", threshold*fudgeFactor);
    % figure; imshow(imgedge);

    % Dilate image to make the coin edges complete without holes
    % se_disk = strel('disk',4);
    % se_line1 = strel('line',3,100);
    % se_line2 = strel('line',3,100);
    % img_dilated = imdilate(imgedge, se_disk);
    % img_dilated = imdilate(img_dilated, [se_line1 se_line2]);
    % figure, imshow(img_dilated), title('dilate')

    % Replace checkerboard with mean image intensity
    checkerboardCorrected = replaceCheckerboardWithBackgroundIntensity(grayImage, checkerboardPoints, boardSize);

    % Perform Otsu's thresholding to binarize the image
    thresholdValue = graythresh(uint8(checkerboardCorrected));
    binaryImage = ~imbinarize(grayImage, thresholdValue);

    % Open and close the binary image using morphological operations
    closing = imclose(binaryImage, strel('disk', 8));
    opening = imopen(closing, strel('disk', 3));

    % Detect circles using `imfindcircles`
    [circleCenters, circleRadii] = imfindcircles(opening, [6 size(grayImage, 1)], 'ObjectPolarity', 'bright', 'Sensitivity', 0.95);
    
    % Visualize the image if visualize parameter set to true
    if visualize == true
        figure;
        imshow(grayImage);
        hold on;
        viscircles(circleCenters, circleRadii);
        hold off;
    end
end
