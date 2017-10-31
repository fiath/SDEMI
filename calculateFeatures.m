function calculateFeatures(in,out,features)
%CALCULATEFEATURES Summary of this function goes here
%   Detailed explanation goes here
    in = [in '/'];
    matList = dir([in '*.mat']);
    if isempty(matList)
        % directory contains no .mat files.
        return
    end
    
    for i = 1:length(matList)
       matList(i).data = load([matList(i).folder '/' matList(i).name]);
       matList(i).data.sta = matList(i).data.meanSpikeWaveformDetrended;
       fid = fopen([out '/' matList(i).name(1:end-3) 'txt'],'w');
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
       end
       fclose(fid);
    end

end

