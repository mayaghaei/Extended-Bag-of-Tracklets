%% SparseFlow codes by Radu Timofte
%
% This code is provided for research purposes and personal use.
%
% Please refer to:
% R. Timofte and L.Van Gool,
% "SparseFlow: Sparse Matching for Small to Large Displacement Optical Flow",
% WACV, 2015
% 
% latest changes:
%   09.03.2015, updated, cleaned up
%   25.03.2014, written



addpath SparseFlow/
addpath Kovesi/

%start_spams;

close all
warning off;

% root_dir = '/scratch/timofter/Flow/';
root_dir = '/pedestrian_tracking/SparseFlow/';

tag = 'testSF'; %tag sparseflow
maxNonzeros = 14;
useL2norm = 1;
visualize = 0;
prune_ratio = 0.7;
thresholdscores = 0.5;

listfiles = textread([root_dir 'MPI_Sintel/test/final/listfiles2.txt'],'%s');


sFiles = size(listfiles,1);

nSetting = 0;
records =[];
tolerance_precision = 5;


% Harris corner parameters
sigma = 1;   
radius = 2;
threshold = 1;  

% patch features
use_color = 1;
blocksize = 13;
alphacolor = 0.33;
alphacoord = 0.01;

% multiple scales
num_scales = 2;                            
scale_factor = 0.5;


    starttime = tic;

    nSetting = nSetting+1;
    
    fprintf('\nSetting %d\n',nSetting);   
    
    S = [];   
    S.selected = [1:1:sFiles];
    S.listfiles = listfiles;
    S.sigma = sigma;
    S.radius = radius;
    S.threshold = threshold;
    S.alphacoord = alphacoord;
    S.blocksize = blocksize;
    S.tolerance_precision = tolerance_precision;

    fprintf('sigma=%.1f, radius=%.1f, threshold=%.2f, alphacolor=%.3f, alphacoord=%.2f blocksize=%d\n', ...
        sigma, radius, threshold, alphacolor, alphacoord, blocksize);                    
    for iFile = 1:sFiles
        stime = tic;
        fprintf('.%d/%d:',iFile,sFiles);                        
        
        path_img = [root_dir 'MPI_Sintel/test/final/' listfiles{iFile}];                        
                
        nImage = sscanf(listfiles{iFile}(end-7:end-3),'%d');
        path_flow = [root_dir 'MPI_Sintel/test/sparseflow/final/' listfiles{iFile}(1:end-8) sprintf(['%04d.flo'], nImage)];                        
        
        [path_flow_dir, fname, fext]=fileparts(path_flow);
        if ~exist(path_flow_dir,'file')
            mkdir(path_flow_dir);
        end
        
        path_flow_sparsedeep = [root_dir 'MPI_Sintel/test/sparsedeepflow/final/' listfiles{iFile}(1:end-8) sprintf(['%04d.flo'], nImage)];
        
        [path_flow_dir, fname, fext]=fileparts(path_flow_sparsedeep);
        if ~exist(path_flow_dir,'file')
            mkdir(path_flow_dir);
        end                
        
        path_matches = [root_dir 'MPI_Sintel/test/sparseflow/finalm/' listfiles{iFile}(1:end-8) sprintf(['%04d_%03d_' tag '.txt'], nImage, nSetting)];                        
        [path_matches_dir, fname, fext]=fileparts(path_matches);
        
        if ~exist(path_matches_dir,'file')
            mkdir(path_matches_dir);
        end
        
        posb = strfind(path_matches,'/');
        path_matches_deep = [root_dir 'ICCV2013_DeepMatching_SintelTest/final/' listfiles{iFile}(1:end-8) sprintf(['%04d.match'], nImage)];        
        
        path_matches_sparsedeep = [root_dir 'MPI_Sintel/test/sparsedeepflow/finalm/' listfiles{iFile}(1:end-8) sprintf(['%04d_%03d_' tag '.txt'], nImage, nSetting)];
        [path_matches_dir, fname, fext]=fileparts(path_matches_sparsedeep);
        
        if ~exist(path_matches_dir,'file')
            mkdir(path_matches_dir);
        end

        
        path_img1 = [root_dir 'MPI_Sintel/test/final/' listfiles{iFile}(1:end-8) sprintf('%04d.png', nImage)];
        nImage = nImage+1;
        path_img2 = [root_dir 'MPI_Sintel/test/final/' listfiles{iFile}(1:end-8) sprintf('%04d.png', nImage)];                                                                        

        % read pair of images        
        I1 = imread(path_img1);
        I2 = imread(path_img2);
        orig_size = [size(I1,1) size(I1,2)];
        norm_size = orig_size;
        ss = orig_size./norm_size;
        gridsize = 15;
        gr = []; for i=round(gridsize/2):gridsize:norm_size(1), for j=round(gridsize/2):gridsize:norm_size(2), gr = [gr; [j i]]; end; end
        
        %if ~exist(path_matches,'file')                            

                            num_scales = 2;                            
                            scale_factor = 0.5;
                            tic;
                            disp('Extract correspondences...');
                            [pts1, pts2, scores] = extract_correspondences2(I1, I2, sigma, threshold, radius, blocksize, alphacolor, alphacoord, use_color, useL2norm, num_scales, scale_factor);
                            toc

                            if ~isempty(pts1)
                                MM = [pts1 pts2 scores];         
                            else
                                MM = [];
                            end
    %                         as = pruneMatches([[1:size(MM,1)]' [1:size(MM,1)]'], ...
    %                              MM(:,1:2),MM(:,3:4),prune_ratio*min(norm_size)); 
    %                         MM = MM(as(:,1),:);   
                            MM2 = MM;
                            if ~isempty(MM2)
                                MM2(:,1:4) = round(MM2(:,1:4));
                            end
                            if ~exist(path_matches,'file')                            
                                dlmwrite(path_matches, MM2, 'delimiter', ' ');
                            end

%                         else
%                             MM = textread(path_matches);
%                         end                                                

        if ~exist(path_flow,'file')
            disp('Variational SparseFlow computation...');
            tic;system(['./fastdeepflow-static ' path_img1 ' ' path_img2 ' ' path_flow ' -sintel -matchf ' path_matches]);toc
        end

        %Fs_sparse = readFlowFile(path_flow);
        
        fprintf('%d sparse matches\n',size(MM,1));
        
                        if isempty(pts1)
                            S.density(iFile) = 0;
                        else
                            PDx = pdist2(pts1(:,1),gr(:,1));
                            PDy = pdist2(pts1(:,2),gr(:,2));
                            PDx = PDx <= gridsize/2;
                            PDy = PDy <= gridsize/2;
                            PD = PDx & PDy;
                            mmS = max(PD);
                            S.density(iFile) = mean(mmS);                                                                         
                        end      
                        
        tt2 = textread(path_matches);
        tt2(:,6) = 0;
        dlmwrite(['tempoS' tag '.match'], tt2, 'delimiter', ' ');
        disp('Rescoring matches for SparseFlowFused...');
        tic; system(['cat tempoS' tag '.match | python rescore.py ' path_img1 ' ' path_img2 ' > tempooS' tag '.match']);toc                        
        
        MM = textread(['tempooS' tag '.match']);

        copyfile(path_matches_deep,path_matches_sparsedeep);
                            
        if ~isempty(MM)
            MM(:,1) = MM(:,1)*0.5;
            MM(:,3) = MM(:,3)*0.5;
            MM(:,2) = MM(:,2)*0.58716;
            MM(:,4) = MM(:,4)*0.58716;

            MM(:,1:4) = round(MM(:,1:4));

            fid = fopen(path_matches_sparsedeep,'a');
            for k=1:size(MM,1)
                fprintf(fid,'%d %d %d %d %.6f\n',MM(k,1),MM(k,2),MM(k,3),MM(k,4),MM(k,5));
            end
            fclose(fid);
        end
        if ~exist(path_flow_sparsedeep,'file')
            disp('Variational SparseFlowFused computation...');
            tic;system(['./fastdeepflow-static ' path_img1 ' ' path_img2 ' ' path_flow_sparsedeep ' -sintel -match ' path_matches_sparsedeep ]);toc                                               
        end
        
        
        TT = textread(path_matches_deep,'%s');
        
        if isempty(TT)
            mm = [];
        else
            mm = zeros(size(TT,1)/5,2);        
            for t=1:size(mm,1)
                mm(t,1) = str2double(TT{(t-1)*5+1});
                mm(t,2) = str2double(TT{(t-1)*5+2});
            end
        end        
                        %mm = textread(path_matches_deep);    
                        
        S.nMatches(iFile) = size(pts1,1);
        S.nMatchesDeep(iFile) = size(mm,1);
        S.nMatchesSparseDeep(iFile) = S.nMatches(iFile)+S.nMatchesDeep(iFile);
        
                        if size(mm,1) == 0
                            S.densityDeep(iFile) = 0;
                            S.densitySparseDeep(iFile) = S.density;
                        else
                            mm(:,1) = mm(:,1)*norm_size(2)/512;
                            mm(:,2) = mm(:,2)*norm_size(1)/256;
                            
                            PDx = pdist2(mm(:,1),gr(:,1));
                            PDy = pdist2(mm(:,2),gr(:,2));
                            PDx = PDx <= gridsize/2;
                            PDy = PDy <= gridsize/2;
                            PD = PDx & PDy;
                            mm = max(PD);
                            S.densityDeep(iFile) = mean(mm);  
                            
                            if isempty(pts1)
                                S.densitySparseDeep(iFile) = S.densityDeep(iFile);
                            else
                                mmS = max(mm, mmS);
                                S.densitySparseDeep(iFile) = mean(mmS);
                            end
                        end
        
        

        if visualize==1                            
            II = [I1 I2];
            figure(20);imshow(flowToColor(readFlowFile(path_flow)));
            figure(30);imshow(flowToColor(readFlowFile(path_flow_sparsedeep)));
            figure(10);imshow(II);
            if size(MM,1) > 0
                MM(:,1) = MM(:,1)/0.5;
                MM(:,3) = MM(:,3)/0.5;
                MM(:,2) = MM(:,2)/0.58716;
                MM(:,4) = MM(:,4)/0.58716;
                MM(:,3) = MM(:,3)+size(I1,2);
                fidx = find(MM(:,1) < size(I1,2)/2 & MM(:,2) < size(I1,1)/2);
                hold on; plot(MM(fidx,1)', MM(fidx,2)','rx');
                hold on; plot(MM(fidx,3)', MM(fidx,4)','rx');
                fidx = find(MM(:,1) >= size(I1,2)/2 & MM(:,2) < size(I1,1)/2);
                hold on; plot(MM(fidx,1)', MM(fidx,2)','bx');
                hold on; plot(MM(fidx,3)', MM(fidx,4)','bx');
                fidx = find(MM(:,1) >= size(I1,2)/2 & MM(:,2) >= size(I1,1)/2);
                hold on; plot(MM(fidx,1)', MM(fidx,2)','mx');
                hold on; plot(MM(fidx,3)', MM(fidx,4)','mx');
                fidx = find(MM(:,1) < size(I1,2)/2 & MM(:,2) >= size(I1,1)/2);
                hold on; plot(MM(fidx,1)', MM(fidx,2)','yx');
                hold on; plot(MM(fidx,3)', MM(fidx,4)','yx');
                drawnow;
            end
            pause;
        end                        

        if mod(iFile,10)==0
            save(['SparseFlow_Sintel_test_final_records_S_' tag],'S');                            
        end
        S.time(iFile) = toc(stime);
    end
    S.time = toc(starttime);
    toc(starttime)
    records = [records S];
    save(['SparseFlow_Sintel_test_final_records' tag],'records');