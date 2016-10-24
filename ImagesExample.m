function ImagesExample()
    %# read images in a cell array
%     imgs = cell(6,1);
path = 'G:\pedestrian_tracking\CT_code_v2\output-pic\4\output-pic - Copy';
d = dir(path);
lr=length(d)-2;

isfo = [d(:).isdir];
nameFolds = {d(isfo).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

    for i=1:lr
        folderName = nameFolds{i};
        path2 = strcat(path,'\',folderName);
        addpath(path2);%? to be removed?
        list = dir (path2);
        
        le = length(list)-2;
        for j=1:le
        imgs{i,j} = imread(list(j+2).name);
        imgs2{i,j} = (list(j+2).name);
        end
        rmpath(path2)%?
    end
    %# show them in subplots
    n = 0;
    figure(1)
    lr = size(imgs,1);
    le = size(imgs,2);
%     le1=le+20;% 20 must be changable(variable)
    for k=1:lr
       firstnum=str2double(strrep((imgs2{k,1}),'.jpg',''));
       % put the number of first image
       diffnum=firstnum-1025;
       n=n+diffnum;
       le1=le-diffnum;
        for h=1:le1
            n=n+1;
            subplot(lr,le,n);
            hi = imshow(imgs{k,h});
%           title(num2str(n));
            set(hi, 'ButtonDownFcn',{@callback,k,h})
        end
%         n = (k)*(le1)+(k);
    end
    
%     %# mouse-click callback function
    function callback(o, e, idx1,idx2)
        %# show selected image in a new figure
        figure(2), imshow(imgs{idx1,idx2})
%         title(num2str(idx))
    end
end