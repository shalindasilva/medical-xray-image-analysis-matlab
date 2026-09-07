clc;
clear;
close all;

% Load X-ray image
I = imread("data/chest_xray.jpeg");

% Display image
figure;
imshow(I);
title("Original Chest X-Ray");

info = imfinfo("data/chest_xray.jpeg");
disp(info);

if size(I,3) == 3
    grayImage = rgb2gray(I);
else
    grayImage = I;
end

figure;
imshow(grayImage);
title("Grayscale X-Ray");

figure;
imhist(grayImage);
title("Histogram of Original X-Ray");

enhancedImage = imadjust(grayImage);
figure;
imshow(enhancedImage);
title("Contrast Enhanced X-Ray");

claheImage = adapthisteq(grayImage);
figure;
imshow(claheImage);
title("CLAHE Enhanced X-Ray");

filteredImage = imgaussfilt(claheImage, 1);
figure;
imshow(filteredImage);
title("Noise Reduced X-Ray");

edges = edge(filteredImage, "Canny");
figure;
imshow(edges);
title("Canny Edge Detection");

binaryImage = imbinarize(filteredImage);
figure;
imshow(binaryImage);
title("Binary Image");

binaryClean = bwareaopen(binaryImage, 50);
figure;
imshow(binaryClean);
title("Cleaned Binary Image");


stats = regionprops(binaryClean, ...
    "Area", "Centroid", "BoundingBox");

disp(stats);

figure;
imshow(grayImage);
title("Detected Regions");
hold on;

figure;
imshow(grayImage);
title("Largest Detected Region");
hold on;

if ~isempty(stats)

    areas = [stats.Area];
    [largestArea, index] = max(areas);

    rectangle("Position", stats(index).BoundingBox, ...
        "EdgeColor", "r", ...
        "LineWidth", 2);

    plot(stats(index).Centroid(1), ...
        stats(index).Centroid(2), ...
        "r+", "MarkerSize", 12, "LineWidth", 2);

end

hold off;

hold off;

if ~isempty(stats)

    areas = [stats.Area];

    [largestArea, index] = max(areas);

    largestRegion = stats(index);

    fprintf("Largest detected region: %.2f pixels\n", largestArea);
    fprintf("Centroid: (%.2f, %.2f)\n", ...
        largestRegion.Centroid(1), ...
        largestRegion.Centroid(2));

end

imwrite(enhancedImage, ...
    "results/enhanced_xray.jpeg");

imwrite(edges, ...
    "results/edge_detection.jpeg");

imwrite(binaryClean, ...
    "results/segmented_xray.jpeg");

figure;

subplot(2,3,1);
imshow(grayImage);
title("Original");

subplot(2,3,2);
imshow(claheImage);
title("CLAHE");

subplot(2,3,3);
imshow(filteredImage);
title("Filtered");

subplot(2,3,4);
imshow(edges);
title("Canny Edges");

subplot(2,3,5);
imshow(binaryClean);
title("Segmentation");

subplot(2,3,6);
imshow(grayImage);
title("Detected Regions");
hold on;

for k = 1:length(stats)
    rectangle("Position", stats(k).BoundingBox, ...
        "EdgeColor", "r");
end

hold off;