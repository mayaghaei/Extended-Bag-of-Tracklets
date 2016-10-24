function [track]=bagofTracklets()
%mkTracklet, compare tracklets and group similar tracklets in a
%bag-of-tracklets

%Initials
threshold=0.5;
x=0;

tr_path = ('.\output\tracklet');%tracklet path-set
t_path_d = dir('.\output\tracklet');
lt=length(t_path_d)-2;%number of all the tracklets
track{lt,lt}=[];
nameTrks = {t_path_d.name}';
nameTrks(ismember(nameTrks,{'.','..'})) = [];

while ~isempty(nameTrks)%array which contain name of the tracklets
    flag=0;
    y=0;
    trkName = nameTrks{1};
    x=x+1;% bag-of-tracklet Index
    y=y+1;% tracklet Index in the bag-of-tracklet
    track{x,y}=trkName;%BOT initialization
    nameTrks(ismember(nameTrks,{trkName})) = [];%remove the assigned tracklet from the array of tracklets
    lt=lt-1;

    %Compare rest of the tracklets with what is already assigned to a BOT
    for i = 1:lt
        
        final_score=0;
        
        trackName = nameTrks{i-flag}; %current tracklet
        % - flag is set to stay in the right position in the array when an element gets eliminated
        path = strcat(tr_path,'\',trackName);
        list = load (path);
        trkList = fieldnames(list);
        le1 = length(trkList);
        for ii = 1:y %BOT length up to here
            
            simSum = 0;
            count=0;
            
            pathTrk = strcat(tr_path,'\',track{x,ii});
            listAux = load (pathTrk);
            trkListAux = fieldnames(listAux);
            le2 = length(trkListAux);

            for j = 1:le1
                s1= trkList(j);
                s1=s1{1};
                for k = 1:le2
                    s2 =trkListAux(k);
                    s2=s2{1};
                    if strcmp(s1,s2)
                        %compare them
                        w1= getfield(list,{1},s1,{1},'w');
                        h1= getfield(list,{1},s1,{1},'h');
                        area1= w1*h1;
                        w2= getfield(listAux,{1},s2,{1},'w');
                        h2= getfield(listAux,{1},s2,{1},'h');
                        area2= w2*h2;
                        a=getfield(list,{1},s1,{1});
                            a=[a.x,a.y,a.w,a.h];
                        b=getfield(listAux,{1},s2,{1});
                            b=[b.x,b.y,b.w,b.h];
                        int_area = rectint(a,b);
                        similarity = double(int_area) / double(area1+area2-int_area);
                        simSum = simSum + similarity;
                        count = count+1;
                    end
                end
            end
            score = simSum / count;
            final_score = final_score + score;
        end%for y
            if (final_score / y) >= threshold
                % If tracklets are considered to be similar, lets update the BOT information
                y=y+1;
                track{x,y}=trackName;
                nameTrks(ismember(nameTrks,{trackName})) = [];
                lt=lt-1;
                flag=flag+1;
            end
    end
end
end