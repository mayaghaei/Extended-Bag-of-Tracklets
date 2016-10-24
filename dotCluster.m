% to plot center of all detections on an image

dataDir = ('G:\pedestrian_tracking\CT_code_v2\save\group\1522-1560\data');
groupDir = ('G:\pedestrian_tracking\CT_code_v2\save\group\1522-1560\group');

img=dir(dataDir);
img = {img.name}';
img(ismember(img,{'.','..'})) = [];
li=length(img);

g = dir(groupDir);
lg=length(g)-2;
isfo = [g(:).isdir];
nameGroups = {g(isfo).name}';
nameGroups(ismember(nameGroups,{'.','..'})) = [];

for m = 1:li
    imgName=img(m);
    imRoot = strcat(dataDir,'\',imgName);
    I = imread(imRoot{1});
    imshow (I)
    hold on;
    matName=strrep(imgName, 'jpg', 'mat');
    
    for k = 1:lg
        groupName = nameGroups{k};
        d = dir(strcat(groupDir,'\',groupName));
        lr=length(d)-2;

        isfo = [d(:).isdir];
        nameFolds = {d(isfo).name}';
        nameFolds(ismember(nameFolds,{'.','..'})) = [];
        
%         colors =['r','b','g','y','m','k'];
%         c = ceil(6*(rand));
        
        for i=1:lr
            folderName = nameFolds{i};
            path = strcat(groupDir,'\',groupName,'\',folderName);

            list = dir (path);
            le = length(list)-2;
            
            for j = 1:le 
                if matName{1} == list(j+2).name
                load(strcat(path,'\',list(j+2).name));
                xx=f(1)+(f(3)/2);
                yy=f(2)+(f(4)/2);
                if k == 1
                    c='b';
                elseif k==2
                    c= 'r';
                elseif k==3
                    c='g';
                elseif k==4
                    c='y';
                elseif k==5
                    c='k';
                end
                scatter(xx,yy,30,c,'fill')
                hold on;
                pause;
                end
            end
        end
    end
    filename=strcat('G:/',imgName);
    saveas(gcf,filename{1})
end
