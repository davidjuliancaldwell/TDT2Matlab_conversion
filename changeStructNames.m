% Written 04/13/17, J Cronin

% This script will change struct names returned by TDT's TDT2mat function
% and convert them to struct names/organizations that we've been using

names = fieldnames(subStruct);
len = length(names);

% loop through all of the stores in this data type
for i=1:len
    storeName = char(names(i));
    newStruct.info.EventType = type;
    newStruct.info.EventCode = storeName;
    
    switch type
        case 'streams'
            newStruct.data = double(subStruct.(storeName).data');
            newStruct.info.ChannelNumbers = [1:size(newStruct.data,2)];
            newStruct.info.SamplingRateHz = subStruct.(storeName).fs;
            
        case 'scalars'
            newStruct.data = double(subStruct.(storeName).data');
            newStruct.info.ChannelNumbers = [1:size(newStruct.data,2)];
            newStruct.info.ts = subStruct.(storeName).ts';
            
            % use timing array to establish an approximate sampling rate, if
            % it's reasonable, otherwise give warning and return NaN
            dx = diff(subStruct.(storeName).ts);            
            if std(dx)<1e-5 % reasonable error, so use time to calculate fs
                newStruct.info.SamplingRateHz = 1/mean(dx);
            else
                warning('Too much variation in timing data, so cannot estimate sampling rate for this scalar store. Returning NaN. Use ts for timing vector')
                newStruct.info.SamplingRateHz = NaN;
            end
            
        case 'epocs'
            newStruct.data = double(subStruct.(storeName).data);
            newStruct.onset = subStruct.(storeName).onset;
            newStruct.offset = subStruct.(storeName).offset;
        
        case 'snips'
            newStruct.dataRAW = double(subStruct.(storeName).data); % this is the original/raw data, in epochs x samples
            newStruct.chan = subStruct.(storeName).chan;
            newStruct.sortcode = subStruct.(storeName).sortcode;
            newStruct.info.SamplingRateHz = subStruct.(storeName).fs; 
            newStruct.info.ts = subStruct.(storeName).ts;
            newStruct.info.sortname = subStruct.(storeName).sortname; 
            
            % Now use the chan variable to separate out the channels and
            % create a data matrix with samples x channels x epochs
            for chans=1:max(newStruct.chan)
                temp(:,:,chans) = newStruct.dataRAW(newStruct.chan==chans,:); % epochs x samples (epochs have channels mixed in)
            end
            newStruct.data = permute(temp , [2 3 1]);
            clear temp
            
    end
    
    v = genvarname(storeName); % create a new variable name based on the store name
    eval([v '= newStruct;']); % save the newStruct to this new varible name struct
    eventnames = vertcat(eventnames, v); % Add the new variable to the list of variables to save
    clear newStruct
        
end
