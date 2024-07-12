function [topLeft, topRight, bottomLeft, bottomRight] = detectCornerPoints(checkerboardPoints, boardSize)
    % detectCornerPoints - Estimate the outer corner points of a checkerboard.
    %
    %   Input:
    %       - checkerboardPoints: Detected checkerboard points (Nx2 matrix).
    %       - boardSize: Size of the checkerboard (1x2 or 2x1 matrix).
    %
    %   Output:
    %       - topLeft, topRight, bottomLeft, bottomRight: Estimated outer corner points.
    

    % Extract the number of rows and columns from the boardSize
    [rows, cols] = size(boardSize);

    % Check if the boardSize is valid (2x1 or 1x2 matrix)
    if ~(rows == 1 && cols == 2) && ~(rows == 2 && cols == 1)
        error('Invalid boardSize. It should be a 1x2 or 2x1 matrix.');
    end

    % Extract the height and width of the board and make adjustments since
    % the checkerboard points start and end points reflect the inner board corners
    heightAdjusted = boardSize(1) - 2;
    widthAdjusted = boardSize(2) - 2;

    % Extract the inner board corners
    innerTopLeft = checkerboardPoints(1, :);
    innerBottomLeft = checkerboardPoints(1 + heightAdjusted, :);
    innerTopRight = checkerboardPoints(end - heightAdjusted, :);
    innerBottomRight = checkerboardPoints(end, :);
    
    % Estimate outer board corners by making adjustments to the inner board corners
    topLeft = innerTopLeft + (innerTopLeft - innerTopRight)/widthAdjusted + (innerTopLeft - innerBottomLeft)/heightAdjusted;
    bottomLeft = innerBottomLeft + (innerBottomLeft - innerBottomRight)/widthAdjusted + (innerBottomLeft - innerTopLeft)/heightAdjusted;
    bottomRight = innerBottomRight + (innerBottomRight - innerBottomLeft)/widthAdjusted + (innerBottomRight - innerTopRight)/heightAdjusted;
    topRight = innerTopRight + (innerTopRight - innerTopLeft)/widthAdjusted + (innerTopRight - innerBottomRight)/heightAdjusted;

end