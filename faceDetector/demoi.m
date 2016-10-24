% compile.m should work for Linux and Mac.
% To Windows users:
% If you are using a Windows machine, please use the basic convolution (fconv.cc).
% This can be done by commenting out line 13 and uncommenting line 15 in
% compile.m
% compile;

% load and visualize model
% Pre-trained model with 146 parts. Works best for faces larger than 80*80
load face_p146_small.mat

% % Pre-trained model with 99 parts. Works best for faces larger than 150*150
% load face_p99.mat

% % Pre-trained model with 1050 parts. Give best performance on localization, but very slow
% load multipie_independent.mat

% disp('Model visualization');
% visualizemodel(model,1:13);
% disp('press any key to continue');
% pause;


% 5 levels for each octave
model.interval = 5;
% set up the threshold
model.thresh = min(-0.8, model.thresh);

% define the mapping from view-specific mixture id to viewpoint
if length(model.components)==13 
%     posemap = 90:-15:-90;
    posemap = -90:15:90;
elseif length(model.components)==18
    posemap = [90:-15:15 0 0 0 0 0 0 -15:-15:-90];
else
    error('Can not recognize this model');
end

% ims = dir('images/*.jpg');
ims = dir('G:/pedestrian_tracking/NarrativeDB/group/9/correlation200 - Copy/*.jpg');
for i = 1:length(ims),
    fprintf('testing: %d/%d\n', i, length(ims));
%     im = imread(['images/' ims(i).name]);
    im = imread(['G:/pedestrian_tracking/NarrativeDB/group/9/correlation200 - Copy/' ims(i).name]);
    imSize = size(im);
    clf; imagesc(im); axis image; axis off; drawnow;
    
    tic;
    bs = detect(im, model, model.thresh);
    bs = clipboxes(im, bs);
    bs = nms_face(bs,0.3);
    dettime = toc;
    
    %maya
    x = []; y = []; w = []; h = [];
    for k = 1:length(bs)
        x(k) = min(bs(k).xy(:,1));
        y(k) = min(bs(k).xy(:,2));
        w(k) = max(bs(k).xy(:,3)) - min(bs(k).xy(:,1));
        h(k) = max(bs(k).xy(:,4)) - min(bs(k).xy(:,2));
    end
    n = length(bs);

    features{1,i}(1,1)=1;
    features{1,i}(1,2)=imSize(1)/2;
    features{1,i}(1,3)=imSize(2)-10;
    features{1,i}(1,4)=4.7124;
    
    for j = 1:n
        features{1,i}(j+1,1)=j+1;
        features{1,i}(j+1,2)=x(j)+(w(j)/2);
        features{1,i}(j+1,3)=y(j)+(h(j)/2);
        features{1,i}(j+1,4)=degtorad(posemap(bs(j).c)+90);
    end
    %for the first person taking the camera

    timestamp(i)=i;
    FoV=[0,0,450,400];
    %maya
    
    % show highest scoring one
%     figure,showboxes(im, bs(1),posemap),title('Highest scoring detection');
    % show all
%     figure,showboxes(im, bs,posemap),title('All detections above the threshold');
    
%     fprintf('Detection took %.1f seconds\n',dettime);
%     disp('press any key to continue');
%     pause;
    close all;
end
save('G:/pedestrian_tracking/NarrativeDB/group/9/correlation200 - Copy/features.mat','FoV','features','timestamp');
disp('done!');
