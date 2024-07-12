function coinClass = classifier(features)
    % classifier - Classify a circular object based on its features
    %
    %   Input:
    %       features - An array of features representing the circular
    %       object [diameter, hue, saturationDifference, avgerageHue, avgerageSaturation]
    %
    %   Output:
    %       coinClass - The assigned class for the coin (0 to 6) corresponding to 'not a coin', 5 cents, 
    %       10 cents, 20 cents, 50 cents, 1 euro and 2 euros coins

    % Extract the individual features from the array of features
    diameter = features(1); hue = features(2); saturationDifference = features(3);
    averageHue = features(4); averageSaturation = features(5);

    if averageSaturation <= 0.0040895
        if saturationDifference <= -0.1257248
            coinClass = 5;
        else % if saturationDifference > -0.1257248
            coinClass = 0;
        end
    else % if averageSaturation > 0.0040895
        if hue <= 0.0996791
            if averageHue <= 0.0012046
                coinClass = 1;
            else % if averageHue > 0.0012046
                if diameter <= 25.5000496
                    coinClass = 5;
                else % if diameter > 25.5000496
                    coinClass = 6;
                end
            end
        else % if hue > 0.0996791
            if diameter <= 24.0393009
                if diameter <= 21.2246885
                    coinClass = 2;
                else % if diameter > 21.2246885
                    coinClass = 3;
                end
            else % if diameter > 24.0393009
                if hue <= 0.1166754
                    coinClass = 4;
                else % if hue > 0.1166754
                    coinClass = 0;
                end
            end
        end
    end
end



