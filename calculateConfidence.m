%calculate confidence
%once called, calculates first the accumulative confidence and keeps it
%like tracklet for each detection inside that tracklet.
mkdir(confPath);
for foldnum = 1:inLength
    %***********for each folder in the Input%*********
    foldName = cell2mat(inList(foldnum)); 
    currentConfPath = strcat(confPath,foldName);
    mkdir(currentConfPath);
    
    %***********get the image information*************
    imgPath = strcat(inPath,foldName,'/','data/');
    imgDir = dir(strcat(imgPath,'*.jpg'));
    imgLength = length(imgDir);%
    i=0;%
    
    %***********read the seed for this folder*********
%     currentSeedPath = strcat(seedPath,foldName,'/seed.mat');
%     seedDir = load(currentSeedPath);
%     seedList = fieldnames(seedDir);%name list of generated seeds
%     ls=length(seedList);%number of generated seeds
    
    %***********read the tracklet path for this folder
    currentTrPath = strcat(trPath,foldName);
    trDir = dir(strcat(currentTrPath,'/*.mat'));
    trLength = length (trDir);
    %check list of tracklets in this foldpath, and make their correspondant
    %confidence mat
    for k = 1:trLength
        currentTrName = trDir(k).name;
        tracklet = load([currentTrPath '/' currentTrName]);
        tracklet = orderfields(tracklet);
        trkFieldName = fieldnames(tracklet);
        trkSize = length(trkFieldName); 

        maxScore = 0;
        totalScore = 0;

        path = ('output/cropped/');
        clear SS;
        
        seedImgName = [currentTrName(1:end-6) '.jpg'];
        a = imread([imgPath seedImgName]);
        currentSeedName = ['I_' currentTrName(1:end-6)];
        bbx = getfield(tracklet,{},currentSeedName,{});
        bbx = [bbx.x,bbx.y,bbx.w,bbx.h];
        imSave = imcrop(a,bbx);
%         imshow(imSave);
        sims=size(imSave);
        if ((sims(1,1)<65) || (sims(1,2)<65))
            imSave = imresize(imSave,1.5);
        end
        img1 = [path '1.jpg'];
        imwrite(imSave,img1)
        
        for i = 1:trkSize
            s1 = cell2mat(trkFieldName(i));% image name in mat file
            imgName = [s1(3:end) '.jpg'];
            a = imread([imgPath,imgName]);
            bbx = getfield(tracklet,{},s1,{});
            bbx = [bbx.x,bbx.y,bbx.w,bbx.h];
            imSave = imcrop(a,bbx);
            sims=size(imSave);
                if ((sims(1,1)<65) || (sims(1,2)<65))
                    imSave = imresize(imSave,1.5);
                end
            img2 = [path '2.jpg'];
            imwrite(imSave,img2)

            score = deep_matching(img1,img2);
            
            trkImage = s1;               
            SS.(trkImage).affinity = score;%falta normalizacion
        end
    seedNameConf = strcat(confPath, foldName,'/',currentTrName);
    save(seedNameConf, '-struct', 'SS');%check seedNameSave
    end
end
