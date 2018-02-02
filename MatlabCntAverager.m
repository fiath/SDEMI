function MatlabCntAverager(dataFile, eventFileDir, outputDir,updateProgress,numberOfChannels,avgDir,measurementID,splitFiles)

    from = -80;
    to = 80;
    range = to-from+1;
    window = [from,to];

    %numberOfChannels = 128;
    resolution = 2;
    samplingRate = 20000;

    file = dir(dataFile)
    samplesPerChannel = file.bytes/numberOfChannels/resolution

    %m = memmapfile(filePath, 'Format',{'int16', [numberOfChannels samplesPerChannel], 'x'});
    m = fopen(dataFile,'r');
%    tmp = zeros(numberOfChannels,range);
    %recordedData = m.Data.x;


    %eventFilePathTest = 'd:\test_cat\Data\depth_1\events\';
    numOfAllSpikes = 0;
    eventFiles = dir([ eventFileDir '*.ev2']);
    eventFileList = repmat(struct('dir',0,'spikes',[], 'spikeIndex',0,'data',[],'variance',[]),length(eventFiles),1);
    for i = 1:length(eventFileList)
        updateProgress(i/length(eventFileList)*1000,sprintf('Reading event file: %d\\%d',i,length(eventFileList)));
        fid = fopen([eventFileDir eventFiles(i).name]);
        eventFileList(i).dir = eventFiles(i);
        j = 0;
        while 1
            line = fgetl(fid);
            if ~ischar(line)
                break
            end
            s = sscanf(line,'%*f%u');
            j = j+1;
            eventFileList(i).spikes(j) = s(end);
        end
        if j~= 0
            eventFileList(i).spikeIndex = 1;
        end
        numOfAllSpikes = numOfAllSpikes + j;
        eventFileList(i).data = zeros(numberOfChannels,range);
 %       eventFileList(i).variance = zeros(numberOfChannels,range);
        fclose(fid);
    end
    
    fprintf('Opened files %d\n',length(eventFileList));
%     l1 = 0;
%     l2 = 0;

    % read spikes in
    processedSpikes = 0;
    currMill = 0;
    currEv = indexOfMin(eventFileList);
    while currEv ~= 0
        
        %if currEv == 1
        %    l1 = l1 + 1;
        %else
        %    l2 = l2 + 1;
        %end
        %fprintf('\rL1: %d | L2: %d',l1,l2);
        
        spikeIndex = eventFileList(currEv).spikeIndex;
        spike = eventFileList(currEv).spikes(spikeIndex);
        if spike + from  > 0 && spike + to <= samplesPerChannel
            fseek(m,2*(spike-1+from)*numberOfChannels,'bof');
            tmp = fread(m,[numberOfChannels,range],'int16');
            tmp = detrend(tmp','linear')';
            eventFileList(currEv).data = eventFileList(currEv).data + ...
                0.195*tmp./length(eventFileList(currEv).spikes);
        end
        % update used spike
        if  spikeIndex < length(eventFileList(currEv).spikes)
            eventFileList(currEv).spikeIndex = spikeIndex + 1;
        else
            eventFileList(currEv).spikeIndex = 0;
        end
        currEv = indexOfMin(eventFileList);
        processedSpikes = processedSpikes + 1;
        if processedSpikes*1000 >= (currMill + 1)*numOfAllSpikes
            %currMill = currMill+1;
            currMill = floor(processedSpikes*1000/numOfAllSpikes);
            updateProgress(currMill,sprintf('Processing spikes: %0.1f %%',currMill/10));
        end
    end
%     % Finished calculating the mean, calculate variance
%     % move backwards for cache efficiency
%     for i = 1:length(eventFileList)
%         len = length(eventFileList(i).spikes);
%         if len ~= 0
%             eventFileList(i).spikeIndex = len;
%         end
%     end
%     
%     % calculate variance
%     currEv = indexOfMax(eventFileList);
%     while currEv ~= 0
%         
%         %if currEv == 1
%         %    l1 = l1 + 1;
%         %else
%         %    l2 = l2 + 1;
%         %end
%         %fprintf('\rL1: %d | L2: %d',l1,l2);
%         
%         spikeIndex = eventFileList(currEv).spikeIndex;
%         spike = eventFileList(currEv).spikes(spikeIndex);
%         if spike + from  > 0 && spike + to <= samplesPerChannel
%             fseek(m,2*(spike-1+from)*numberOfChannels,'bof');
%             tmp = fread(m,[numberOfChannels,range],'int16');
%             tmp = detrend(tmp','linear')';
%             eventFileList(currEv).variance = eventFileList(currEv).variance + ...
%                 ((0.195*tmp - eventFileList(currEv).data).^2)./length(eventFileList(currEv).spikes);
%         end
%         % update used spike
%         if  spikeIndex > 1
%             eventFileList(currEv).spikeIndex = spikeIndex - 1;
%         else
%             eventFileList(currEv).spikeIndex = 0;
%         end
%         currEv = indexOfMax(eventFileList);
%     end
   

    % write to file
    for i = 1:length(eventFileList)
%         [~,cellID,~] = fileparts(eventFileList(i).dir.name);
%         if ~splitFiles
%             saveavg(eventFileList(i).data,eventFileList(i).variance,...
%                 from,to,samplingRate,[avgDir, measurementID, '_1_', cellID, '.avg']);
%         else
%            saveavg(eventFileList(i).data(1:64,:),eventFileList(i).variance(1:64,:),...
%                 from,to,samplingRate,[avgDir, measurementID, '_1_', cellID,'_t', '.avg']); 
%             saveavg(eventFileList(i).data(65:numberOfChannels,:),...
%                 eventFileList(i).variance(65:numberOfChannels,:),...
%                 from,to,samplingRate,[avgDir, measurementID, '_1_', cellID,'_b', '.avg']);
%         end
        
        meanSpikeWaveformDetrended = eventFileList(i).data;
        spikes = eventFileList(i).spikes;
        measurementLength = samplesPerChannel/samplingRate;
        save([outputDir eventFileList(i).dir.name '.mat'], 'meanSpikeWaveformDetrended',...
            'spikes','samplingRate','numberOfChannels','window','measurementLength');
        clear meanSpikeWaveformDetrended;
    end
   

    %clear m
    %close all
end

function argmin = indexOfMin(evFiles)
    argmin = 0;
    min = 0;
    for i = 1:length(evFiles)
        if evFiles(i).spikeIndex ~= 0 && (argmin == 0 || min > evFiles(i).spikes(evFiles(i).spikeIndex))
            argmin = i;
            min = evFiles(i).spikes(evFiles(i).spikeIndex);
        end
    end
    %fprintf('Argmin: %d\n',argmin);
end

function argmax = indexOfMax(evFiles)
    argmax = 0;
    max = 0;
    for i = 1:length(evFiles)
        if evFiles(i).spikeIndex ~= 0 && (argmax == 0 || max < evFiles(i).spikes(evFiles(i).spikeIndex))
            argmax = i;
            max = evFiles(i).spikes(evFiles(i).spikeIndex);
        end
    end
    %fprintf('Argmin: %d\n',argmin);
end







