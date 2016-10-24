function data = normalize_data(data,type)
if ~exist('type','var')
    type = 'l2';
end
data = double(data);
smalleps = 0.0000001;
if strcmp(type,'l2') || strcmp(type,'L2')
    for i = 1:size(data,1)
        data(i,:) = data(i,:)/(norm(data(i,:))+smalleps);
    end;   
end

if strcmp(type,'l1') || strcmp(type,'L1')
    for i = 1:size(data,1)
        data(i,:) = data(i,:)/(norm(data(i,:))+smalleps);
    end;   
    data = data./repmat(sum(data,2)+smalleps,1,size(data,2));
end