%this code is set to validate the results automatically by computing
%   FP > prototype SI groundtruth NO
%   FN > prototype NO groundtruth SI
%   IDS > prototype SI groundtruth SI intersection ZERO (in the end for MOTA it doesnt really matter if its IDS or FP)
%   MOTP > intersection over all
%   MOTA > 1 - ((FP+FN+IDS) / GT)

%used for prototype
clear variables

foldName = '27';
imgPath = (['.\input\' foldName '\data\']);
imgList = dir([imgPath '*.jpg']);
imgList = {imgList.name}';
imgListLength = length(imgList);

gtPath = (['.\input\' foldName '\GT1.mat']);
gtList = load(gtPath);
GT = length (fieldnames(gtList));

%
gtPathAux = (['.\input\' foldName '\GT2.mat']);
gtListAux = load(gtPathAux);
GTAux = length (fieldnames(gtListAux));
%

prPath = (['.\output\prototype\' foldName '\pr1.mat']);
prList = load(prPath);

FN = 0;
FP = 0;
IDS = 0;
count = 0;
simSum = 0;

for i = 1:imgListLength
    imgName = strrep(imgList(i),'.jpg','');
    imgNameStruct = cell2mat(strcat('I_',imgName));
    if isfield(prList,imgNameStruct)
        b = getfield(prList,{1},imgNameStruct,{1});
        b = [b.x,b.y,b.w,b.h];
        w2= getfield(prList,{1},imgNameStruct,{1},'w');
        h2= getfield(prList,{1},imgNameStruct,{1},'h');
        area2= w2*h2;                
        if isfield(gtList,imgNameStruct)
            a = getfield(gtList,{1},imgNameStruct,{1});
            a = [a.bbx(1),a.bbx(2),a.bbx(3),a.bbx(4)];
            w1= a(3);
            h1= a(4);
            area1= w1*h1;
            int_area = rectint(a,b);
            similarity = double(int_area) / double(area1+area2-int_area); %MOTP in this frame

            if similarity > 0.1
                simSum = simSum + similarity;
                count = count+1;
            else
                FP = FP+1;
                %
                if isfield(gtListAux,imgNameStruct)
                    a = getfield(gtListAux,{1},imgNameStruct,{1});
                    a = [a.bbx(1),a.bbx(2),a.bbx(3),a.bbx(4)];  
                    int_area = rectint(a,b);
                    if int_area >0
                    IDS = IDS+1;
                    end
                end
                %
            end
        else % if GT NO & PR SI
            FP = FP+1;
        end
    elseif isfield(gtList,imgNameStruct) && ~isfield(prList,imgNameStruct)
        FN = FN+1;
    end
end

MOTP = simSum/count;
MOTA = 1- ((FP+FN+IDS) / GT); 

MOTP
MOTA
FP
FN
IDS
GT
