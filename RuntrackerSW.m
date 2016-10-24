clear S;
addpath('../SparseFlow')
%variables
thresh = -10;
%----------------------------------
mkdir(trPath);

for foldnum = 1:inLength
    foldName = cell2mat(inList(foldnum));
    currentTrPath = strcat(trPath,foldName);
    mkdir(currentTrPath);
    imgPath = strcat(inPath,foldName,'/','data/');
    imgDir = dir(strcat(imgPath,'*.jpg'));
    imgLength = length(imgDir);%
    i=0;%
    currentSeedPath = strcat(seedPath,foldName,'/seed.mat');
    seedDir = load(currentSeedPath);
    seedList = fieldnames(seedDir);%name list of generated seeds
    ls=length(seedList);%number of generated seeds

    for seedNum = 1:ls      
        clear S;
        
        seedName = cell2mat(seedList(seedNum));
        seedOName = strrep(seedName,'I_','');

        %usamos imgnum para hacer FW y BW tracking
        imgnum = find(strcmp({imgDir.name},strcat(seedOName,'.jpg')));% OJO

        init = getfield(seedDir,{1},seedName,{':'});
        numDet = length(init);% up to here
        imgName = strcat(imgPath,seedOName,'.jpg');
            try
                imgSeed = imread(imgName);
            catch err
                imgName= strcat(imgPath,seedOName,'.JPG');
                imgSeed = imread(imgName);
            end
            
        % crop and save original image
        for count=1:numDet
        %make the primary tracklet file with the corresponding seed       
            imSave = imcrop(imgSeed,[init(count).x init(count).y init(count).w init(count).h]);
            a = size(imSave);
            if (a(1)<65 || a(2)<65)
                imSave = imresize(imSave, 1.5);
            end
            
            saveName= ('output/cropped/1.jpg');
            imwrite(imSave,saveName)
   
            initstat_f = init(count);% forward tracking
            initstat_b = init(count);% backward tracking
        
            countStr=num2str(count);
            seedNameSave = strcat(currentTrPath,'/',seedOName,'-',countStr,'.mat');
            S.(seedName)=initstat_f;
            save(seedNameSave, '-struct', 'S');

            initstate=initstat_f;

            run('forwardDMSW');

            if imgnum > 1
                initstate = initstat_b;
                run('backwardDMSW');
            end
        end
    end
end
