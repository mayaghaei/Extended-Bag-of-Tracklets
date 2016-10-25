% this code create final prototypes of a sequence by eliminating occluded
% frames from it.

for foldnum = 1:inLength
    foldName = cell2mat(inList(foldnum));
    GT = 1;
    clear affinity;
    clear affinity2;
    clear affinity3;
    currentTrPath = [trPath foldName];
    trDir = dir(strcat(currentTrPath,'/*.mat'));
    trLength = length (trDir);
    nameTrks = {trDir.name}';
    
    curBotPath = [botPath,foldName,'/'];
    bot = load([curBotPath,'botFinal.mat']);
    botInfo = {bot.track};
    botInfo = vertcat(botInfo{:});
    noEmptyIndex = ~cellfun(@isempty,botInfo);
    nBot = max(find(noEmptyIndex(:,1))); 
    curPrPath = [prPath,foldName,'/'];
    for k=1:nBot
        min_aff = 9999999;
        max_aff = -1;
        prNum = num2str(k);
        prototype = load([curPrPath 'pr' prNum '.mat']);
        botList=botInfo(k,:);
        nTracklet = max(find(noEmptyIndex(k,:)));
        for j=1:nTracklet
            trkName = botInfo{k,j};%tracklet name
            path = ['./output/confidence/' foldName '/' trkName];
            conf = load(path);
            conf = orderfields(conf);
            imgNameList = fieldnames(conf);
            trkSize = length(imgNameList);
            ii = 0;
            for i = 1:trkSize
                ii = ii+1;
                x(ii) = ii;
                y(ii) = occThr;
                imgName = cell2mat(imgNameList(i));
                affinity(j,ii) = (getfield(conf,{1},imgName,{1},'affinity'));
            end
        end
        min_aff = min(affinity(:));
        max_aff = max(affinity(:));
        for j=1:nTracklet
            affinity3(j,:) = (affinity(j,:) - min_aff)/(max_aff - min_aff);
        end

        meanVal=mean(affinity3);
        varVal=var(affinity3);
        medVal=median(affinity3); % if < y ~> occlusion
        [inda, indb] = find (medVal < occThr);
        %load prototype and delete these indexes and save again
        prFields = fieldnames(prototype);
        clear S
        S = rmfield(prototype,prFields(indb));
        seedNameSave = [curPrPath 'prFinal' prNum '.mat'];
        save(seedNameSave, '-struct', 'S');
    end
end
