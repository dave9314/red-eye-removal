% Improved Red-Eye Removal in MATLAB
clc; clear; close all;

% Read the image
I = imread('6.jpg');
I = im2double(I); % Convert to double for precise computation

% Extract RGB channels
red = I(:,:,1);
green = I(:,:,2);
blue = I(:,:,3);

% Define improved red-eye mask:
% 1. Red must be significantly higher than green and blue
% 2. Red must exceed a threshold
% 3. Avoid false positives by considering intensity contrast
red_threshold = 0.55; % Adjust based on image
mask = (red > red_threshold) & (red > 1.4 * green) & (red > 1.4 * blue) & (red - max(green, blue) > 0.15);

% Apply morphological operations to refine the mask
mask = bwareaopen(mask, 30); % Remove small regions
mask = imclose(mask, strel('disk', 3)); % Close small holes

% Replace excessive red with a more natural eye color
corrected_red = 0.5 * green + 0.5 * blue; % Blend green & blue for realistic eye color
red(mask) = corrected_red(mask);

% Reconstruct the corrected image
J = cat(3, red, green, blue);

% Display results
figure;
subplot(1,2,1); imshow(I); title('Original Image');
subplot(1,2,2); imshow(J); title('Red-Eye Corrected Image');

% Save the result
imwrite(J, 'output_image.jpg');
