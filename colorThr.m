%auxilary script to experimentally decide which color threshold should be choosen

img = imread('input/2/data/161206.jpg');
imgAux = imread('input/2/data/161104.jpg');
%seed x=329 y=217 w=107 h=115
wSize = [107,115];
img1 = img(217:332,329:436,:);
topLeftRow = 1;
topLeftCol = 1;
[bottomRightRow,bottomRightCol,d] = size(img);

count = 1;
step = 10;
xend = bottomRightCol-wSize(1)-step-1;
yend = bottomRightRow-wSize(2)-step-1;
% this for loop scan the entire image and extract features for each sliding window
for y = topLeftCol:step:yend   
    for x = topLeftRow:step:xend
        bbox.x(count) = x;
        bbox.y(count) = y;
        bbox.w(count) = wSize(1);
        bbox.h(count) = wSize(2);        
        count = count+1;
        img2 = imgAux(y:y+wSize(2)-1, x:x+wSize(1)-1,:);
        subplot(1,2,1),imshow(img1)
        subplot(1,2,2),imshow(img2)
        score = colorMatch(img1,img2)
        pause;
    end
end

