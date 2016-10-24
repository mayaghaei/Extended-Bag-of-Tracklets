function [ f ] = colorMatch( Img1,Img2 )

hst1 = im2hsvHist(Img1);
hst2 = im2hsvHist(Img2);

f = norm( hst1 - hst2 );

function hst = im2hsvHist( img )
% computes three channels histogram in HSV color space
n = 256; % number of bins per hist (per channel)
hsvImg = rgb2hsv( img );
hst = zeros(n,3);
    for ci = 1:3 
        hst(:,ci) = imhist( hsvImg(:,:,ci ) , n );
    end
hst = hst(:) ./ n; % to 3*n vector, normalize by n and not 3n
end

end


