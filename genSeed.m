
% This code is to generate seeds for all the sequence of images inside the
% data folder in the distinctive folders inside the input.

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

inDir = dir(inPath);
isDir = [inDir(:).isdir];
inList = {inDir(isDir).name}';
inList(ismember(inList,{'.','..'})) = [];
inLength = length(inList);

mkdir(seedPath);

for foldnum = 1:inLength
    clear S
    flag = 0;
    foldName = cell2mat(inList(foldnum));
    foldName
    currentSeedPath = [seedPath,foldName];
    mkdir(currentSeedPath);
    imgPath = [inPath,foldName,'/','data'];
    imgDir = dir([imgPath,'/','*.jpg']);
    imgLength = length(imgDir);
    counter=0;
    
    init = [];
    for i = 1:imgLength 
        imgName = imgDir(i).name;
        fprintf('testing: %d/%d\n', i, imgLength);
        im = imread([imgPath '/' imgName]);

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
        counter = counter+1;
        imgName = strrep(strcat('I_',imgName),'.jpg','');%to be checked
        seedName = [currentSeedPath,'/seed.mat'];
        S.(imgName) = init;
            if counter == 1
            save(seedName, '-struct', 'S');
            end
        save(seedName, '-struct', 'S','-append');
            close all;
    end
end
