function bbxch = bbxMain(imgnum, bboxDetection)

img_dir = dir('./data/*.jpg');
img = imread(img_dir(imgnum).name);

%Structs
subImage = imcrop(img, bboxDetection);
H = HOG_new(subImage);
H=H';
H = zscore(H);

    Image_red = mean(mean(subImage(:,:,1)));
    Image_green = mean(mean(subImage(:,:,2)));
    Image_blue = mean(mean(subImage(:,:,3)));
    
    RGB = [Image_red,Image_green,Image_blue];
    RGB = zscore(RGB);
    
    bbxch = struct('RGB', RGB, 'HOG', H);

end

