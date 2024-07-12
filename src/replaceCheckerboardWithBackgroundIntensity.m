function maskedImage = replaceCheckerboardWithBackgroundIntensity(image, checkerboardPoints, boardSize)
    % replaceCheckerboardWithBackgroundIntensity Replaces a checkerboard region in an image with the mean intensity of the background.
    %
    %   Inputs:
    %       image - Image containing the checkerboard
    %       checkerboardPoints - Detected points of the checkerboard
    %       boardSize - Size of the checkerboard 
    %
    %   Output:
    %       maskedImage - Image with the checkerboard region replaced by the mean intensity of the background

    % Detect corner points of the checkerboard
    [topLeft, topRight, bottomLeft, bottomRight] = detectCornerPoints(checkerboardPoints, boardSize);
    
    % Specify the region by defining a polygon based on corner points
    Polygon = [topLeft; bottomLeft; bottomRight; topRight];

    % Calculate the mean intensity of the entire image
    meanImageIntensity = mean2(image(1:5, 1:5, :));
    
    % Create a 2D binary mask for the specified region
    regionMask2D = poly2mask(Polygon(:, 1), Polygon(:, 2), size(image, 1), size(image, 2));
    
    % Replicate the 2D mask to make it 3D for color images
    regionMask3D = repmat(regionMask2D, [1, 1, size(image, 3)]);

    % Create a copy of the original image to apply the mask
    maskedImage = image;

    % Replace values in the specified region with the mean intensity value
    maskedImage(regionMask3D) = meanImageIntensity;
    
end