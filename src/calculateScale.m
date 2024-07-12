function scale = calculateScale(checkerboardPoints, boardSize)
    % calculateScale - Calculates the scale factor for converting image-based
    % measurements to ground/real-world measurements.
    %
    %   Input:
    %   - checkerboardPoints: Detected points of the checkerboard in the image
    %   - boardSize: Size of the checkerboard in terms of rows and columns
    %
    %   Output:
    %   -scale: The scaling factor
    % Extract the number of rows and columns from the boardSize
    [rows, cols] = size(boardSize);
    % Check if the boardSize is valid (2x1 or 1x2 matrix)
    if ~(rows == 1 && cols == 2) && ~(rows == 2 && cols == 1)
        error('Invalid boardSize. It should be a 1x2 or 2x1 matrix.');
    end
    % Ground/Real-world measurements
    realPixelLength = 12.5;
    
    % Image-based measurements estimation
    [topLeft, topRight, bottomLeft, bottomRight] = detectCornerPoints(checkerboardPoints, boardSize);
    imagePixelLength = mean([sqrt(sum((topLeft - bottomLeft).^2)) / boardSize(1); sqrt(sum((topRight - bottomRight).^2)) / boardSize(1)]);
    
    % Scale estimation
    scale = realPixelLength/imagePixelLength;
end