function crosscorr = calcCrossCorr(fig,fileA,fileB,binsize,numOfBins)
%CALCCROSSCORR Summary of this function goes here
%   Detailed explanation goes here
    A = getSpikes(fig,fileA);
    B = getSpikes(fig,fileB);

    crosscorr = zeros(1,2*numOfBins+1);
    activeA = [];
    activeB = [];
    indexA = 0;
    indexB = 0;
    for i=1:(length(A)+length(B))
        if indexA<length(A) && (indexB==length(B) || A(indexA+1)<=B(indexB+1))
            % the next spike is from A
            indexA = indexA + 1;
            pos = A(indexA);
            activeB = activeB(activeB >= (pos - binsize*numOfBins));
            activeA = activeA(activeA >= (pos - binsize*numOfBins));
            dist = ceil((pos - activeB)/binsize);
            for j=1:length(dist)
                crosscorr(numOfBins - dist(j) + 1) = crosscorr(numOfBins - dist(j) + 1) + 1;
            end
            activeA = [activeA,pos];
        else
            % the next spike is from B
            indexB = indexB + 1;
            pos = B(indexB);
            activeB = activeB(activeB >= (pos - binsize*numOfBins));
            activeA = activeA(activeA >= (pos - binsize*numOfBins));
            dist = ceil((pos - activeA)/binsize);
            for j=1:length(dist)
                crosscorr(numOfBins + dist(j) + 1) = crosscorr(numOfBins + dist(j) + 1) + 1;
            end
            activeB = [activeB,pos];
        end
    end

end

