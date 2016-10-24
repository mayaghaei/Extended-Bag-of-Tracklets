% function [sum_scores] = deep_matching(ima1_name, ima2_name)
function [media] = deep_matching(ima1_name, ima2_name)
% ima1_name= '~/Desktop/PD/data/132822.jpg';
% ima2_name= '~/Desktop/PD/data/133329.jpg';
%construct the string adding the image names ima1_name and ima2_name
commandString = ['deepmatching/deepmatching-static', ' ',ima1_name, ' ', ima2_name, ' ', '-iccv_settings -v']
[status,result]= system(commandString)
k = strfind(result,'...');
if k>0
    result = result(k(end)+4:end-1);
    vecstring = strsplit(char(result),' ');
    %vecstring = (result);
    %extract scores
    scores_char = vecstring([5:5:end]);
    %compute the sum of the scores between the two image (or you can take the mean)
    sum_scores = 0;
    for i=1:length(scores_char)
        sum_scores = sum_scores + str2double(scores_char(i));
    end
    media = sum_scores / length(scores_char);%added
else
%     sum_scores =0;
    media =0;
end

end%end function
%try with 2 pairs of images and see how the score would change.
%first pair to be very similar, and the second pair to be very dissimilar.
%results to be discussed. longitud and occlusion of the tracklets also is
%needed to be computedima
