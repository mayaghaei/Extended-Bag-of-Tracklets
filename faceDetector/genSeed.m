
% This code is to generate seeds for all the sequence of images inside the
% data folder in the distinctive folders inside the input.

% be careful with commented codes, if wish to have faceDetector instead of
% body detector, just need to uncomment them, and comment thos indicated by
% % in the end of command
load face_p146_small.mat
model.interval = 5;
model.thresh = min(-0.8, model.thresh);
if length(model.components)==13 
    posemap = 90:-15:-90;
elseif length(model.components)==18
    posemap = [90:-15:15 0 0 0 0 0 0 -15:-15:-90];
else
    error('Can not recognize this model');
end
inPath = ('G:/pedestrian_tracking/PD/input/');
addpath(inPath);
inDir = dir(inPath);
isDir = [inDir(:).isdir];
inList = {inDir(isDir).name}';
inList(ismember(inList,{'.','..'})) = [];
inLength = length(inList);

seedPath = 'G:/pedestrian_tracking/PD/output/seed/';
mkdir(seedPath);

for foldnum = 1:inLength
    clear S
    flag = 0;
    foldName = cell2mat(inList(foldnum));
    foldName
    currentSeedPath = strcat(seedPath,foldName);
    mkdir(currentSeedPath);
    imgPath = strcat(inPath,foldName,'/','data');
    imgDir = dir(strcat(imgPath,'/','*.jpg'));
    imgLength = length(imgDir);
    counter=0;
    
    init = [];
    for i = 1:imgLength 
        imgName = imgDir(i).name;
        fprintf('testing: %d/%d\n', i, imgLength);
        im = imread([imgPath '/' imgName]);
%         imagesc(im); axis image; axis off; drawnow;
%     try
        bs = detect(im, model, model.thresh);
        bs = clipboxes(im, bs);
        bs = nms_face(bs,0.3);
    
        numdet = length(bs);
        
        if numdet==0
            continue;
        end
        init = [];
        for j=1:numdet
            init(j).x = int64(min(bs(j).xy(:,1)));
            init(j).y = int64(min(bs(j).xy(:,2)));
            init(j).w = int64(max(bs(j).xy(:,3)) - min(bs(j).xy(:,1)));
            init(j).h = int64(max(bs(j).xy(:,4)) - min(bs(j).xy(:,2)));
        end
%         imshow(im);
%         hold on
%         for n=1:length(init)
%         initShow = [init(n).x,init(n).y,init(n).w,init(n).h];
%         rectangle('position',initShow,'EdgeColor','r');
        fprintf('press any key to continue...\n') ;
%         end
%         pause
%         hold off
%             catch err%
%             continue;%
%         end%
        counter = counter+1;
        imgName = strrep(strcat('I_',imgName),'.jpg','');%to be checked
        seedName = strcat(currentSeedPath,'/seed.mat');
        S.(imgName) = init;
            if counter == 1
            save(seedName, '-struct', 'S');
            end
        save(seedName, '-struct', 'S','-append');
            close all;
    end
end