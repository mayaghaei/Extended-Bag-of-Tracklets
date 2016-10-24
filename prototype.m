% function [proName]=prototype(track)

% this code is organized to compute the prototype for all the BOTs;
% exludeUnBot is called prior to start to exclude unreliable BOTs and the
% fuction can be run for reliable BOTs

% This function recieves as input botFinal (output of excludeUnBot)
% and return a prototype for each one, saved in the prototype folder

mkdir (prPath);
for foldnum = 2:inLength
    foldName = cell2mat(inList(foldnum));

%     foldName = 'new';

    currentTrPath = [trPath foldName];
    trDir = dir(strcat(currentTrPath,'/*.mat'));
    trLength = length (trDir);%not necessary
    nameTrks = {trDir.name}';
    seqLength = length(dir([inPath foldName '/data/*.jpg']));
    
    curBotPath = strcat (botPath,foldName,'/');
    bot = load([curBotPath,'botFinal.mat']);
    botInfo = {bot.track};
    botInfo = vertcat(botInfo{:});
    noEmptyIndex = ~cellfun(@isempty,botInfo);
    nBot = max(find(noEmptyIndex(:,1)));
    
    saveDir = [prPath foldName '/'];
    mkdir (saveDir);
    for i=1:nBot
        botList=botInfo(i,:);
        nTracklet = max(find(noEmptyIndex(i,:)));
        for j=1:seqLength
            count = 0;
            distVec = zeros(1,((nTracklet^2)-nTracklet)/2);
            for k=1:nTracklet
                trName = cell2mat(botInfo(i,k));
                list = load ([currentTrPath '/' trName]);
                trkList = orderfields(list);
                trkList = fieldnames(trkList);        
                curFrame = cell2mat(trkList(j));
                w1 = getfield(list,{1},curFrame,{1},'w');
                h1 = getfield(list,{1},curFrame,{1},'h');
                area1 = w1*h1;
                a = getfield(list,{1},curFrame,{1});
                a = [a.x,a.y,a.w,a.h];
                for kk = k+1:nTracklet
                    trNameAux = cell2mat(botInfo(i,kk));
                    listAux = load ([currentTrPath '/' trNameAux]);
                    trkListAux = orderfields(listAux);
                    trkListAux = fieldnames(trkListAux);        
                    curFrameAux = cell2mat(trkListAux(j));
                    w2 = getfield(listAux,{1},curFrameAux,{1},'w');
                    h2 = getfield(listAux,{1},curFrameAux,{1},'h');
                    area2 = w2*h2;
                    b = getfield(listAux,{1},curFrameAux,{1});
                    b = [b.x,b.y,b.w,b.h];
                    int_area = rectint(a,b);
                    int_area_per = double(int_area) / double(area1+area2-int_area);
                    count = count+1;
                    distVec(count) = int_area_per;%preallocation
                end
            end
            distMat=squareform(distVec);
%             [proVal,proIdx]=max(sum(D));
            SD = sum(distMat);
            proIdx = find (SD == max(SD));
            
            trName = cell2mat(botInfo(i,proIdx(1)));
            list = load ([currentTrPath '/' trName]);
            trkList = orderfields(list);
            trkList = fieldnames(trkList);        
            curFrame = cell2mat(trkList(j));
            a = getfield(list,{1},curFrame,{1});
            %save
            S.(curFrame)=a;
        end
        istr = num2str(i);
        seedNameSave = [saveDir 'pr' istr '.mat'];
        save(seedNameSave, '-struct', 'S');
    end
end
    
%         load this frame on these trackletand compare and choose the best
%         one and save it

    