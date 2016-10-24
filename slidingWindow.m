function bbox = slidingWindow(im,wSize)
%{
this function will take two parameters
    1.  im      --> Test Image
    2.  wSize  --> Size of the window, i.e. [24,32] 
%}

topLeftRow = 1;
topLeftCol = 1;
[bottomRightRow,bottomRightCol,d] = size(im);

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
    end
end
end