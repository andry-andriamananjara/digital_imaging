function features = extractColorAndSizeFeatures(center, radius, image, scale)
    % extractColorAndSizeFeatures - Extracts color and size features from the specified circular region in the image.
    %
    %   Input:
    %       center:   Center coordinates of the circular region [x, y].
    %       radius:   Radius of the circular region.
    %       image:    RGB image.
    %       scale:    Scaling factor for diameter calculation.
    %
    %   Output:
    %       features: Extracted features [diameter, hue, saturationDifference, averageHue, averageSaturation].
    
 
    % Convert image to HSV color space
    imageHsv = rgb2hsv(image);
    
    % Calculate diameter
    diameter = 2 * scale * radius;
    
    % Array to store hue and saturation values
    hues = zeros(size(image, 1), size(image, 2));
    sats = zeros(size(image, 1), size(image, 2));
    
    % Array to store saturation values for inner and outer regions of
    % interest
    satsInner = zeros(0, 1);
    satsOuter = zeros(0, 1);
    
    % Iterate over pixels and classify based on distance
    for y = 1:size(imageHsv, 1)
    for x = 1:size(imageHsv, 2)
      distance = (x - center(1))^2 + (y - center(2))^2;
    
      if distance <= radius^2
        % Calculate hue and saturation features
        hues(y, x) = imageHsv(y, x, 1);
        sats(y, x) = imageHsv(y, x, 2);
        % Calculate inner and outer saturation features
        if distance <= (0.70 * radius)^2
            satsInner(end + 1) = imageHsv(y, x, 2);
        elseif distance <= (0.90 * radius)^2
            satsOuter(end + 1) = imageHsv(y, x, 2);
        end
      end
    end
    end
    
    % Calculate hue feature
    hue = sum(bsxfun(@times, hues, sats)) / sum(sats);
    
    % Calculate saturation difference feature
    saturationDifference = mean(satsInner) - mean(satsOuter);
    
    % Calculate average hue and saturation features
    averageHue = mean(hues(:));
    averageSaturation = mean(sats(:));
    
    features = [diameter hue saturationDifference averageHue averageSaturation];
end
