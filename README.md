# red-eye-removal
# Improved Red-Eye Removal in MATLAB

This project provides an improved method for removing red-eye effects from digital images using MATLAB. The technique focuses on detecting and correcting excessive redness in the eye region without affecting natural eye colors or other parts of the image.

## Features

- Detects red-eye regions based on intensity and color ratios.
- Refines the detection mask using morphological operations.
- Replaces the red region with a natural-looking blend of green and blue channels.
- Preserves overall image quality.

## Requirements

- MATLAB (R2018 or later recommended)
- Image Processing Toolbox

## Usage

1. Place your target image in the same folder as the script and rename it to `6.jpg` (or change the filename in the code accordingly).
2. Run the script in MATLAB:

```matlab
clc; clear; close all;

% Read the image
I = imread('6.jpg');
I = im2double(I); % Convert to double for precise computation

% Extract RGB channels
red = I(:,:,1);
green = I(:,:,2);
blue = I(:,:,3);

% Define improved red-eye mask
red_threshold = 0.55; 
mask = (red > red_threshold) & (red > 1.4 * green) & (red > 1.4 * blue) & (red - max(green, blue) > 0.15);

% Refine mask using morphological operations
mask = bwareaopen(mask, 30);
mask = imclose(mask, strel('disk', 3));

% Correct the red-eye region
corrected_red = 0.5 * green + 0.5 * blue;
red(mask) = corrected_red(mask);

% Reconstruct and display the corrected image
J = cat(3, red, green, blue);

figure;
subplot(1,2,1); imshow(I); title('Original Image');
subplot(1,2,2); imshow(J); title('Red-Eye Corrected Image');

% Save the output
imwrite(J, 'output_image.jpg');
