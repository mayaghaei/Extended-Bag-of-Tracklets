tracklet=load ('output/tracklet/133401-2.mat');
imgPath=('data/');
trkFieldName=fieldnames(tracklet);
trkSize=length(trkFieldName);
path = ('output/cropped/');
mkdir(path);
totalScore=0;
%make a new carpet in output to save cropped images coming from each tracklet
%after having cropped images of each tracklet, need to write another loop
%to call deepmatching for each pair inside each carpet
if trkSize>=2
    for i=1:trkSize
        s1= trkFieldName(i);% image name in mat file
        s1=cell2mat(s1);
        imgName=strrep(s1,'I_','');
        imgName=strcat(imgName,'.jpg');
        a = imread(strcat(imgPath,imgName));
        bbx=getfield(tracklet,{},s1,{});
        bbx=[bbx.x,bbx.y,bbx.w,bbx.h];
        imSave=imcrop(a,bbx);
        filename=strcat('output/cropped/',imgName);
        imwrite(imSave,filename)
    end
    for j=3:trkSize-1
        imgList=dir(path);
        img1=strcat(path,imgList(j).name);
        img2=strcat(path,imgList(j+1).name);
        score=deep_matching(img1,img2);
        totalScore=totalScore+score;
    end
    trkAffScore=totalScore/trkSize;
end
