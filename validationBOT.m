%validation
%used for BOT
% clear all
clc

foldName = '28';
outPath = '.\output\';
inPath = '.\input\';
curInPath = strcat(inPath,foldName,'\');
botPath = strcat (outPath,'bot\');
curBotPath = strcat (botPath,foldName,'\');

bot = load([curBotPath,'botFinal.mat']);
botInfo = {bot.track};
botInfo = vertcat(botInfo{:});
noEmptyIndex = ~cellfun(@isempty,botInfo);       %# Find indices of empty cells
% botInfo(emptyIndex) = {'nan'};

trPath = strcat(outPath,'tracklet\');
curTrPath = strcat(trPath,foldName,'\');
trList = dir(strcat(curTrPath,'*.mat'));
trLength = length(trList);

imgPath = strcat(curInPath,'data\');
imgList = dir(strcat(imgPath,'*.jpg'));
imgLength = length(imgList);
imgList = cell2mat({imgList.name}');
imgListLength = length(imgList);

nBot = max(find(noEmptyIndex(:,1)));

MOTPall=0; MOTPSumAll=0;
MOTAall=0; MOTASumAll=0;
FPall=0; FPSumAll =0;
FNall=0; FNSumAll=0;
IDSall=0; IDSSumAll=0;
GTAux = 0;

for k=1:nBot
    botList = botInfo(k,:);
    nTracklet = max(find(noEmptyIndex(k,:)));

    sumMOTP = 0;
    sumMOTA = 0;
    sumFP = 0;
    sumFN = 0;
    sumIDS = 0;
    
    kstr=num2str(k);
    if k>2
        kstr = '2';
    end

    gtPath = (['.\input\' foldName '\GT' kstr '.mat']);
    gtList = load(gtPath);
    GT = length (fieldnames(gtList));
    if strcmp (kstr,'1') && nBot>1
        kstrAux = '2';
        gtPathAux = (['.\input\' foldName '\GT' kstrAux '.mat']);
        gtListAux = load(gtPathAux);
        GTAux = length (fieldnames(gtListAux));
    elseif strcmp (kstr,'2') && nBot>1
        kstrAux = '1';
        gtPathAux = (['.\input\' foldName '\GT' kstrAux '.mat']);
        gtListAux = load(gtPathAux);
        GTAux = length (fieldnames(gtListAux));
    end
    GTAll = GT+GTAux;
    
    for i=1:nTracklet%trLength is the number of rows in the final image
        
        FN = 0;
        FP = 0;
        IDS = 0;
        count = 0;
        simSum = 0;
        
        inTrName = botInfo{k,i};%tracklet name
        inTrPath = strcat(curTrPath, inTrName);
        inTrList = load(inTrPath);
        inTrList = orderfields(inTrList);
        inTrListi = fieldnames(inTrList);
        inTrLength = length(inTrListi);

        for j=1:inTrLength% number of columns
            trFrName = cell2mat(inTrListi(j));%frame Name
            b = getfield(inTrList,{},trFrName,{});
            b = [b.x b.y b.w b.h];
            w2 = b(3);
            h2 = b(4);
            area2= w2*h2;
            if isfield(gtList,trFrName)
                a = getfield(gtList,{1},trFrName,{1});
                a = [a.bbx(1),a.bbx(2),a.bbx(3),a.bbx(4)];
                w1= a(3);
                h1= a(4);
                area1= w1*h1;
   
                int_area = rectint(a,b);
                similarity = double(int_area) / double(area1+area2-int_area); %MOTP in this frame
                if similarity >0
                    simSum = simSum + similarity;
                    count = count+1;
                else    
                    FP = FP+1;
                    FN = FN+1;%this means absence and wrong presence
                    %to compute IDS
                    if strcmp (kstr,'1') && nBot>1
                        kstrAux = '2';
                        gtPathAux = (['.\input\' foldName '\GT' kstrAux '.mat']);
                        gtListAux = load(gtPathAux);
                        if isfield(gtListAux,trFrName)
                            a = getfield(gtListAux,{1},trFrName,{1});
                            a = [a.bbx(1),a.bbx(2),a.bbx(3),a.bbx(4)];  
                            int_area = rectint(a,b);
                            if int_area >0
                            IDS = IDS+1;
                            end
                        end
                    elseif strcmp (kstr,'2') && nBot>1
                        kstrAux = '1';
                        gtPathAux = (['.\input\' foldName '\GT' kstrAux '.mat']);
                        gtListAux = load(gtPathAux);
                        if isfield(gtListAux,trFrName)
                            a = getfield(gtListAux,{1},trFrName,{1});
                            a = [a.bbx(1),a.bbx(2),a.bbx(3),a.bbx(4)];  
                            int_area = rectint(a,b);
                            if int_area >0
                            IDS = IDS+1;
                            end
                        end
                    end
                    %to compute IDS
                end  
            elseif ~isfield(gtList,trFrName)
                FP = FP+1;
            end
            
        end%for every frame
        MOTP = simSum/count;
        if isnan(MOTP)
            MOTP = 0;
        end
        MOTA = 1- ((FP+FN+IDS) / GTAll);
       
        sumMOTP = sumMOTP + MOTP;
        sumMOTA = sumMOTA + MOTA;
        sumFP = sumFP + FP;
        sumFN = sumFN + FN;
        sumIDS = sumIDS + IDS;
    end%for every tracklet

    MOTPFinal = sumMOTP / nTracklet; MOTPSumAll = MOTPSumAll + MOTPFinal;
    MOTAFinal = sumMOTA / nTracklet; MOTASumAll = MOTASumAll + MOTAFinal;
    FPFinal = sumFP / (nTracklet*inTrLength); FPSumAll = FPSumAll+FPFinal;
    FNFinal = sumFN / (nTracklet*inTrLength); FNSumAll = FNSumAll + FNFinal;
    IDSFinal = sumIDS / (nTracklet*inTrLength); IDSSumAll = IDSSumAll+IDSFinal;
end
MOTPall = MOTPSumAll / nBot
MOTAall = MOTASumAll /nBot
FPall = FPSumAll / nBot
FNall = FNSumAll / nBot
IDSall = IDSSumAll / nBot
GTAll
