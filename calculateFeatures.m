function calculateFeatures(in,out,features)
%CALCULATEFEATURES Summary of this function goes here
%   Detailed explanation goes here
    in = [in filesep];
    matList = dir([in '*.ev2.mat']);
    if isempty(matList)
        % directory contains no .mat files.
        return
    end
    
    clusterNames = cell(1,length(matList));
    featureNames = cell(1,size(features,1));
    featureArgs = cell(1,size(features,1));
    X = zeros(length(clusterNames),length(featureNames));
    
    % write out header in global file (names of features)
    currDate =  datestr(now,'yyyy_mm_dd_HH_MM_SS');
    sumName = ['summary_' currDate '.txt'];
    sid = fopen([out filesep sumName],'w');
    fprintf(sid,'Cluster\t');
    for f=1:size(features,1)-1
        fprintf(sid,[features{f,1}, '\t']);
    end
    fprintf(sid,[features{end,1}, '\n']);
    fprintf(sid,'Parameters\t');
    for f=1:size(features,1)
       featureNames{f} = features{f,1};
       argList = '';
       if ~isempty(features{f,2}.args)
           for arg=1:length(features{f,2}.args(2,:))-1
               argList = [argList,sprintf('%g',features{f,2}.args{2,arg}),','];
           end
           argList = [argList,sprintf('%g',features{f,2}.args{2,end})];
       end
       featureArgs{f} = argList;
       fprintf(sid,'%s',argList);
       if f== size(features,1)
           fprintf(sid,'\n');
       else
           fprintf(sid,'\t');
       end
    end
    
    
    for i = 1:length(matList)
       fprintf(sid,[matList(i).name,'\t']);
       clusterNames{i} = matList(i).name;
       matList(i).data = load([matList(i).folder filesep matList(i).name]);
       matList(i).data.sta = matList(i).data.meanSpikeWaveformDetrended;
       fid = fopen([out filesep matList(i).name(1:end-3) 'txt'],'w');
       for f = 1:size(features,1)
           fprintf(fid,[features{f,1}, '\t']);
           if isempty(features{f,2}.args)
               result = features{f,2}.callback(matList(i).data);
           else
               result = features{f,2}.callback(matList(i).data,features{f,2}.args{2,:});
               fprintf(fid,'(');
               for arg=1:length(features{f,2}.args(2,:))-1
                   fprintf(fid,'%g, ',features{f,2}.args{2,arg});
               end
               fprintf(fid,'%g)',features{f,2}.args{2,end});
           end
           fprintf(fid,['\t%g\n'],result);
           fprintf(sid,'%g',result);
           X(i,f) = result;
           if f==size(features,1)
               fprintf(sid,'\n');
           else
               fprintf(sid,'\t');
           end
       end
       fclose(fid);
    end
    
    fclose(sid);
    
    save([out filesep 'summary_' currDate '.mat'],'clusterNames','featureNames','featureArgs','X');
    
    Z = zscore(X);
    
    save([out filesep 'zscore_summary_' currDate '.mat'],'clusterNames','featureNames','featureArgs','Z');
    
    
    % save zscore as txt
    sid = fopen([out filesep 'zscore_summary_' currDate '.txt'],'w');
    
    fprintf(sid,'Cluster\t');
    for f=1:size(features,1)-1
        fprintf(sid,[featureNames{f}, '\t']);
    end
    fprintf(sid,[featureNames{end}, '\n']);
    fprintf(sid,'Parameters\t');
    for f=1:size(features,1)
       fprintf(sid,'%s',featureArgs{f});
       if f== size(features,1)
           fprintf(sid,'\n');
       else
           fprintf(sid,'\t');
       end
    end
    
    for i = 1:length(matList)
       fprintf(sid,[clusterNames{i},'\t']);
       for f = 1:size(features,1)
           fprintf(sid,'%g',Z(i,f));
           if f==size(features,1)
               fprintf(sid,'\n');
           else
               fprintf(sid,'\t');
           end
       end
    end
    
    fclose(sid);

end

