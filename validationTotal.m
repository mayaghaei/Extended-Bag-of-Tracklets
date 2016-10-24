%this code is set to validate the results automatically by computing
%   FP > prototype SI groundtruth NO
%   FN > prototype NO groundtruth SI
%   IDS > prototype SI groundtruth SI intersection ZERO (in the end for MOTA it doesnt really matter if its IDS or FP)
%   MOTP > intersection over all
%   MOTA > 1 - ((FP+FN+IDS) / GT)

%used for CT
clear variables

foldName = 'new';
imgPath = (['.\input\' foldName '\data\']);
imgList = dir([imgPath '*.jpg']);
imgList = {imgList.name}';
imgListLength = length(imgList);

% gtPath = (['.\input\' foldName '\GT1.mat']);
% gtList = load(gtPath);
% GT = length (fieldnames(gtList));

% prPath = (['.\output\tracklet\' foldName]);
% prPath = (['.\outputCT\' foldName]);
prPath = (['.\output\prototype\' foldName]);

prListT = dir([prPath '\*.mat']);

sumMOTP = 0;
sumMOTA = 0;

for j =1:length(prListT)
prList = load([prPath '\' prListT(j).name]);

jstr=num2str(j);
if j>2
    jstr = '2';
end

gtPath = (['.\input\' foldName '\GT' jstr '.mat']);
gtList = load(gtPath);
GT = length (fieldnames(gtList));

FN = 0;
FP = 0;
IDS = 0;
count = 0;
simSum = 0;

for i = 1:imgListLength
    imgName = strrep(imgList(i),'.jpg','');
    imgNameStruct = cell2mat(strcat('I_',imgName));
    if isfield(gtList,imgNameStruct)
        a = getfield(gtList,{1},imgNameStruct,{1});
        a = [a.bbx(1),a.bbx(2),a.bbx(3),a.bbx(4)];
        w1= a(3);
        h1= a(4);
        area1= w1*h1;
        if isfield(prList,imgNameStruct)
            b = getfield(prList,{1},imgNameStruct,{1});
            b = [b.x,b.y,b.w,b.h];
            w2= getfield(prList,{1},imgNameStruct,{1},'w');
            h2= getfield(prList,{1},imgNameStruct,{1},'h');
            area2= w2*h2;            
            int_area = rectint(a,b);
            similarity = double(int_area) / double(area1+area2-int_area); %MOTP in this frame
            if similarity >0
                    simSum = simSum + similarity;
                    count = count+1;
                else    
                    FP = FP+1;
                    FN = FN+1;
            end
            %compute overlap MOTP
            %if overlap==0 > IDS=IDS+1
        else % if GT SI & PR NO
            FN = FN+1;
        end
    elseif ~isfield(gtList,imgNameStruct) && isfield(prList,imgNameStruct)
        FP = FP+1;
    end
end

MOTP = simSum/count;
if isnan(MOTP)
    MOTP = 0;
end
    sumMOTP = sumMOTP + MOTP;
MOTA = 1- ((FP+FN+IDS) / GT);
    sumMOTA = sumMOTA + MOTA;
end

MOTPFinal = sumMOTP / length(prListT)
MOTAFinal = sumMOTA / length(prListT)
FP
FN
IDS
GT
