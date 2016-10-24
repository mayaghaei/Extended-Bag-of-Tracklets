% function [track]=BOT()
%%
%Last version of making a BOT out of tracklets. 
%recieving all the tracklets of a sequence, starts from the first one and
%adds next tracklet in the list gradually based on those which has the higher likelihood
%to the first tracklet. next tracklets also will be just compared to the
%first tracklet. among the tracklets which has the seed in a common frame
%just the one with higher likelihood will be added to the tracklet.
%%
% clear all

%Initials
threshold=0.15;

for foldnum = 1:inLength
    foldName = cell2mat(inList(foldnum));
% foldName = '38';
    clear track
    currentTrPath = strcat(trPath,foldName);
    trDir = dir(strcat(currentTrPath,'/*.mat'));
    trLength = length (trDir);
    
    x=0;

    % foldName = '28';

    tr_path = strcat(trPath,foldName);%tracklet path-set
    t_path_d = dir([tr_path '/*.mat']);
    lt=length(t_path_d);%number of all the tracklets
    track{lt,lt}=[];
    nameTrks = {t_path_d.name}';
    nameTrksOri = nameTrks;
    % nameTrks(ismember(nameTrks,{'.','..'})) = [];

while ~isempty(nameTrks)%array which contain name of the tracklets
    flag=0;
    y=0;
    trkName = nameTrks(1);
    x = x+1;% bag-of-tracklet Index
    y = y+1;% tracklet Index in the bag-of-tracklet
    track{x,y} = cell2mat(trkName);%BOT initialization
    nameTrks(ismember(nameTrks,trkName)) = [];%remove the assigned tracklet from the array of tracklets
    lt = lt-1;
    
    trkNameStr = cell2mat(trkName);
    pathTrkFst = [tr_path '/' trkNameStr];
    listAux = load (pathTrkFst);
    trkListAux = fieldnames(listAux);
    le2 = length(trkListAux);%length of current tracklet in the bag to be compared with remaining tracklets
    
    vectName = []; vectScore=[]; vectIndex=[];
    %Compare rest of the tracklets with what is already assigned to a BOT
    for i = 1:lt        
        final_score = 0;
        simSum = 0;
        count=0;
        
        trackName = nameTrks{i-flag}; %current tracklet
        % - flag is set to stay in the right position in the array when an element gets eliminated
        path = [tr_path '/' trackName];
        list = load (path);
        trkList = fieldnames(list);
        le1 = length(trkList);%length of current tracklet to be compared
        
        for j = 1:le1
            s1 = cell2mat(trkList(j)); %s1 = s1{1}; 
            for k = 1:le2
                s2 =cell2mat(trkListAux(k)); %s2 = s2{1};
                if strcmp(s1,s2)
                    %compare them
                    w1= getfield(list,{1},s1,{1},'w');
                    h1= getfield(list,{1},s1,{1},'h');
                    area1= w1*h1;
                    w2= getfield(listAux,{1},s2,{1},'w');
                    h2= getfield(listAux,{1},s2,{1},'h');
                    area2= w2*h2;
                    a=getfield(list,{1},s1,{1});
                        a=[a.x,a.y,a.w,a.h];
                    b=getfield(listAux,{1},s2,{1});
                        b=[b.x,b.y,b.w,b.h];
                    int_area = rectint(a,b);
                    similarity = double(int_area) / double(area1+area2-int_area);
                    simSum = simSum + similarity;
                    count = count+1;
                end
            end
        end
        score = simSum / count;
        ids = strfind(vectName,trackName(1:end-6));
        if (score>threshold && isempty(ids))%check here
        vectScore = [vectScore,score];
        vectName = [vectName,trackName];
        vectIndex = [vectIndex,i];
        end
    end
    nameTrksOri = nameTrks;
    for m = 1:length(vectScore)
        maxIdx = find(vectScore == max(vectScore));
        y = y+1;
        selTrName = nameTrksOri(vectIndex(maxIdx));
        track{x,y} = cell2mat(selTrName);
        vectScore(maxIdx)=0; %[];
        vectIndex(maxIdx)=0; %[];
        nameTrks(ismember(nameTrks,selTrName)) = [];
        lt=lt-1;
    end
    flag=flag+1;
end
        saveDir = [botPath foldName '/'];
        mkdir (saveDir);
        botNameSave = [saveDir 'bot.mat'];
        save(botNameSave, 'track');
end
