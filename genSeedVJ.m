%this code is to generate seeds for a sequence of Images.

addpath('data');
mkdir('output/seed');

i=0;
img_dir = dir('data/*.jpg');
l = length (img_dir);
err = [];
faceDetector = vision.CascadeObjectDetector();
for imgnum = 1:l

        img_name=img_dir(imgnum).name;
        im = imread(img_name);
        bbox = step(faceDetector, im);
        numdet = size (bbox,1);
    if numdet==0
        continue;
    end
    for j=1:numdet
        init(j).x = int64(bbox(j,1));
        init(j).y = int64(bbox(j,2));
        init(j).w = int64(bbox(j,3));
        init(j).h = int64(bbox(j,4));
    end
    i=i+1;
    imgName=strrep(strcat('I_',img_name),'.jpg','');
    seedPath=('output/seed/seed.mat');
    S.(imgName)=init;
    if i==1
        save(seedPath, '-struct', 'S');
    else
        save(seedPath, '-struct', 'S','-append');
    end
end