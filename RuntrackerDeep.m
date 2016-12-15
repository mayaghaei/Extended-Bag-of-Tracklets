
%Runs the tracking using "deep-matching" for all the detected seeds, in 
%each sequence specified in different "data" folders in input
%----------------------------------
mkdir(trPath);
mkdir(cropPath);

for foldnum = 1:inLength
    foldName = cell2mat(inList(foldnum));
    foldName
    currentTrPath = [trPath,foldName];
    mkdir(currentTrPath);
    imgPath = [inPath,foldName,'/','data/'];
    imgDir = dir([imgPath,'*',imgType]);
    imgLength = length(imgDir);
    % load seed data
    currentSeedPath = [seedPath,foldName,'/seed.mat'];
    seedDir = load(currentSeedPath);
    seedList = fieldnames(seedDir);%name list of generated seeds
    ls=length(seedList);%number of generated seeds

    for seedNum = 1:ls      
        clear S;
        
        seedName = cell2mat(seedList(seedNum));
        seedOName = strrep(seedName,'I_','');

        %We use imgnum for FW and BW tracking
        imgnum = find(strcmp({imgDir.name},strcat(seedOName,imgType)));

        init = getfield(seedDir,{1},seedName,{':'});%coordination of seed
        numDet = length(init);% number of seeds in this frame
        imgName = [imgPath,seedOName,imgType];
        imgSeed = imread(imgName);
            
        % crop and save reference image (seed)
        for count=1:numDet%for each seed...
            %make the primary tracklet file with the corresponding seed       
            Img1 = imcrop(imgSeed,[init(count).x init(count).y init(count).w init(count).h]);
		 Img1 = imresize(Img1,[128,128]);
                        
            saveName = ('output/cropped/1.jpg');
            imwrite(Img1,saveName)
            
            initstate = init(count);
        
            countStr = num2str(count);
            seedNameSave = [currentTrPath,'/',seedOName,'-',countStr,'.mat'];
            S.(seedName) = initstate;
            save(seedNameSave, '-struct', 'S');
            %propagation
            propagationDeep(imgnum+1,1,imgLength,imgPath,imgDir,seedDir,Img1,initstate,colorThr,seedNameSave);%propagate seed FORWARD

            if imgnum > 1
                propagationDeep(imgnum-1,-1,1,imgPath,imgDir,seedDir,Img1,initstate,colorThr,seedNameSave);%OJO the initstate doesnt change after function
            end
        end
    end
end
