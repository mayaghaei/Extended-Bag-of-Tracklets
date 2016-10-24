
%Runs the tracking using "sparse-matching" for all the detected seeds, in 
%each sequence specified in different "data" folders in input
%----------------------------------
mkdir(trPath);

for foldnum = 1:inLength
    foldName = cell2mat(inList(foldnum));
    currentTrPath = strcat(trPath,foldName);
    mkdir(currentTrPath);
    imgPath = strcat(inPath,foldName,'/','data/');
    imgDir = dir(strcat(imgPath,'*',imgType));
    imgLength = length(imgDir);
    % load seed data
    currentSeedPath = strcat(seedPath,foldName,'/seed.mat');
    seedDir = load(currentSeedPath);
    seedList = fieldnames(seedDir);%name list of generated seeds
    ls = length(seedList);%number of generated seeds

    for seedNum = 1:ls
        clear S;
        
        seedName = cell2mat(seedList(seedNum));
        seedOName = strrep(seedName,'I_','');

        %We use imgnum for FW and BW tracking
        imgnum = find(strcmp({imgDir.name},strcat(seedOName,imgType)));

        init = getfield(seedDir,{1},seedName,{':'});%coordination of seed
        numDet = length(init);% number of seeds in this frame
        imgName = strcat(imgPath,seedOName,imgType);
        imgSeed = imread(imgName);
        
        % crop reference image (seed)
        for count=1:numDet%for each seed...
            %make the primary tracklet file with the corresponding seed
            xx1 = init(count).x; xx2 = xx1 + init(count).w - 1;
            yy1 = init(count).y; yy2 = yy1 + init(count).h - 1;
            Img1 = imgSeed (yy1:yy2, xx1:xx2, :);%seed

            initstate = init(count);

            countStr = num2str(count);
            seedNameSave = strcat(currentTrPath,'/',seedOName,'-',countStr,'.mat');
            S.(seedName) = initstate;
            save(seedNameSave, '-struct', 'S');
            %propagation
            propagation(imgnum+1,1,imgLength,imgPath,imgDir,seedDir,Img1,initstate,colorThr,seedNameSave);%propagate seed FORWARD

            if imgnum > 1
                propagation(imgnum-1,-1,1,imgPath,imgDir,seedDir,Img1,initstate,colorThr,seedNameSave);%OJO the initstate doesnt change after function
            end
        end
    end
end
