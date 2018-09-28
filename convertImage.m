pkg load image

% set parameters
d_x = 0.05;
d_y = 0.05;

% load image
pic_RGB = imread('.\images\casserole-dish-2776735_960_720.jpg');

figure(10) ;
imshow(pic_RGB);  % for check

% convert from RGB to XYZ
XYZ = rgb2xyz(pic_RGB);

% convert from XYZ to xyY
xyY = zeros(size(XYZ));
xyY(:, :, 1) = XYZ(:, :, 1) ./ sum(XYZ, 3);
xyY(:, :, 2) = XYZ(:, :, 2) ./ sum(XYZ, 3);
xyY(:, :, 3) = XYZ(:, :, 2);

% shift on CIE xy map
xyY1 = zeros(size(xyY));
xyY2 = zeros(size(xyY));

xyY1(:,:,1) = xyY(:,:,1) .+ d_x;
xyY1(:,:,2) = xyY(:,:,2) .- d_y;
xyY1(:,:,3) = xyY(:,:,3);

xyY2(:,:,1) = xyY(:,:,1) .- d_x;
xyY2(:,:,2) = xyY(:,:,2) .+ d_y;
xyY2(:,:,3) = xyY(:,:,3);

% convert from xyY to XYZ 
XYZ1 = zeros(size(xyY1));
XYZ2 = zeros(size(xyY2));

XYZ1(:,:,1) = xyY1(:,:,3) ./ xyY1(:,:,2) .* xyY1(:,:,1);
XYZ1(:,:,2) = xyY1(:,:,3);
XYZ1(:,:,3) = xyY1(:,:,3) ./ xyY1(:,:,2) .* (1 .- xyY1(:,:,1) .- xyY1(:,:,2));

XYZ2(:,:,1) = xyY2(:,:,3) ./ xyY2(:,:,2) .* xyY2(:,:,1);
XYZ2(:,:,2) = xyY2(:,:,3);
XYZ2(:,:,3) = xyY2(:,:,3) ./ xyY2(:,:,2) .* (1 .- xyY2(:,:,1) .- xyY2(:,:,2));

% convert from XYZ to RGB
RGB1 = xyz2rgb(XYZ1);
RGB2 = xyz2rgb(XYZ2);

figure(1)
imshow(RGB1); % for check
figure(2)
imshow(RGB2); % for check

% generata new image
imwrite(RGB1, '.\images\test01.jpg');
imwrite(RGB2, '.\images\test02.jpg');