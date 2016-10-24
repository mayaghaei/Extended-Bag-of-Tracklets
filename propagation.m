function propagation( start,step,fin,imgPath,imgDir,seedDir,Img1,initstate,colorThr,seedNameSave)
% To propagate the seed over the sequence

for i = start:step:fin
    maxDMScore = 0;

    s = (imgDir(i).name);
    s = s(1:end-4);
    imgNamef = strcat('I_',s);
    
    imgName = strcat(imgPath,imgDir(i).name);
    img = imread(imgName);

    if isfield(seedDir,imgNamef)
        init_aux = getfield(seedDir,{1},imgNamef,{':'});
        init_aux_length = length(init_aux);
    else
        init_aux_length=0;
        init_aux = [];
    end

    wSize = [initstate.w,initstate.h];
    sampleImage = slidingWindow(img,wSize);
   %------------------------------------
%       add to all the sample images, the seeds in this frame
    for j=1:init_aux_length
       sampleImage.x = [sampleImage.x init_aux(j).x];
       sampleImage.y = [sampleImage.y init_aux(j).y];
       sampleImage.w = [sampleImage.w init_aux(j).w];
       sampleImage.h = [sampleImage.h init_aux(j).h];
    end
    index = [];
%      read, crop, resize, save sampleImages in the loop
    for k=1:length(sampleImage.x)
        xx1 = sampleImage.x(k); xx2 = xx1 + sampleImage.w(k)-1;
        yy1 = sampleImage.y(k); yy2 = yy1 + sampleImage.h(k)-1;
        Img2 = img (yy1:yy2, xx1:xx2, :);
        colorScore = colorMatch(Img1,Img2);
        if colorScore <= colorThr
            curDMScore = SparseMatching(Img1,Img2);
            if curDMScore < maxDMScore
               continue;
            else
               maxDMScore = curDMScore;
               index = k;
            end
        end
    end
    if isempty(index)
        index = 1;
    end
    initstate.x = sampleImage.x(index);
    initstate.y = sampleImage.y(index);
    initstate.w = sampleImage.w(index);
    initstate.h = sampleImage.h(index); 
    
    S.(imgNamef) = initstate;
    save(seedNameSave, '-struct', 'S','-append');
end
end

