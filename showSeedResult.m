% To show the seeds, tracklets or prototypes.

foldName = 'example';
inPath = 'input/';
outPath = 'output/';
imgPath = strcat(inPath,foldName,'/data/');%BE CAREFULL 512 TO data
imgDir = dir([imgPath '*.jpg']);
imgLength = length(imgDir);
% seedPath = (strcat(outPath,'seed/',foldName,'/seed.mat'));
%seedPath = (strcat(outPath,'tracklet/',foldName,'/184218-1.mat'));
 seedPath = (strcat(outPath,'prototype/',foldName,'/pr3.mat'));
% seedPath = ('/media/HDD_2TB/maya/outputAux/SPT/1/SPT-1.mat');
 
% seedPath = ('output/seed/1/seed.mat');
seedList = load(seedPath);
% GTPath = strcat(inPath,foldName,'/GT1.mat');
% GTList = load(GTPath);
    
for imgnum = 1:imgLength
    imgName = imgDir(imgnum).name;
    im = imread([imgPath imgName]);
    imgNameF = strcat('I_',strrep(imgName,'.jpg',''));
    seed = []; GT = [];
    if isfield(seedList,imgNameF)
        seed = getfield(seedList,{},imgNameF,{});
        ls = length(seed);
    end
%     if isfield(GTList,imgNameF)
%         GT = getfield(GTList,{},imgNameF,{});
%     end

    imshow(im);

    if ~isempty(seed)
    hold on        
    for n=1:length(seed)
        seedi = [seed(n).x,seed(n).y,seed(n).w,seed(n).h];
        rectangle('position',seedi,'EdgeColor','r');
                    imSave = imcrop(im,seedi);
                    filename = (['output/cropped/' imgName]);
%                     imwrite(imSave,filename);
    end    
    end      

%     if ~isempty(GT)
%         GT = [GT.bbx(1),GT.bbx(2),GT.bbx(3),GT.bbx(4)];
%         rectangle('position',GT,'EdgeColor','g');
%     end
    fprintf('press any key to continue...\n') ;
    pause
    hold off
end
