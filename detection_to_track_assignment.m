

function [assignments, unassignedTracks, unassignedDetections] = ...
    detection_to_track_assignment(imgnum, numtrack, numdet, initstateaux, init)

    costOfNonAssignment = 10;
    cost = zeros(numtrack, numdet);
    
    for t = 1:numtrack
        tImg=[initstateaux(t).x,initstateaux(t).y,initstateaux(t).w,initstateaux(t).h];
        tch(t) = bbxMain(imgnum, tImg);
        for d = 1:numdet
            imgnum = imgnum-1;
            dImg=[init(d).x,init(d).y,init(d).w,init(d).h];
            dch(d) = bbxMain(imgnum,dImg);
            
            cost(t,d) = (norm (tch(t).HOG-dch(d).HOG))* ...
            (norm (tch(t).RGB-dch(d).RGB));
            
            imgnum = imgnum+1;
        end
    end   

    % solve the assignment problem
    [assignments, unassignedTracks, unassignedDetections] = ...
        assignDetectionsToTracks(cost, costOfNonAssignment);
end
