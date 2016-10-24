% function excludeUnBot(foldName)

threshold = 0.2;

for foldnum = 1:inLength%comment
    foldName = cell2mat(inList(foldnum));%comment

% foldName='new';%uncomment
flag=0;

curBotPath = [botPath foldName];

curTrPath = [trPath foldName '/'];

bot = load([curBotPath '/bot.mat']);
botInfo = {bot.track};
botInfo = vertcat(botInfo{:});
botFinal = botInfo;
noEmptyIndex = ~cellfun(@isempty,botInfo); 
nBot = max(find(noEmptyIndex(:,1)));
  
for k=1:nBot
    botList=botInfo(k,:);
    nTracklet = max(find(noEmptyIndex(k,:)));
    for i=1
%     for i=1:nTracklet%trLength is the number of rows in the final image
        inTrName = botInfo{k,i};%tracklet name
        inTrPath = strcat(curTrPath, inTrName);
        inTrList = load(inTrPath);
        inTrList = orderfields(inTrList);
        inTrListi = fieldnames(inTrList);
        inTrLength = length(inTrListi);
    end
    bagRatio = nTracklet/inTrLength; 
    if bagRatio < threshold
        botFinal(k-flag,:)=[];
        flag=flag+1;
    end
end
%Save botFinal
track = botFinal;
saveDir = [botPath foldName '/'];
mkdir (saveDir);
botNameSave = [saveDir 'botFinal.mat'];
save(botNameSave, 'track');
end
% end%function

