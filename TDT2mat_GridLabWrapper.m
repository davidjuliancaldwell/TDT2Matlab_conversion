%% This is a wrapper fro TDT's function TDT2mat.m, to convert their output to
% the output that we're used to using. It is called by both the
% ConvertTDTRecordingToMAT_v2 script and the
% ConvertTDTRecordingToMAT_v2_loop script

% written 07/24/18
% Jenny Cronin 

% Call TDT's function to convert all data to Matlab
data = TDT2mat(tankpath, blockname);

%% Start variable name conversion to our variable naming system:
Info = data.info; % includes all info about the timing of this file
eventnames = {'Info'}; % this will include all of the variables that we want to save later

%% Convert streams
% data is stored as samples x channels
if ~isempty(data.streams)
    type = 'streams';
    subStruct = data.streams;
    changeStructNames
end

%% Convert scalars
% data is stored as samples x channels
if ~isempty(data.scalars)
    type = 'scalars';
    subStruct = data.scalars;
    changeStructNames
end

%% Convert epocs
% data is stored as triggered samples x 1
if ~isempty(data.epocs)
    type = 'epocs'; % Note that TDT calls this type Strobe+, but saves it under data.epocs, so here it is saved as type 'epoc'
    subStruct = data.epocs;
    changeStructNames
end

%% Convert snips
% data is stored as samples x channels x epochs (where epochs have channels
% mixed in) 
% dataRAW is stored as epochs x samples (where epochs have
% channels mixed in and can be sorted out using the chan parameter, but
% this was already taken care of in changeStructNames.m)
if ~isempty(data.snips)
    type = 'snips';
    subStruct = data.snips;
    changeStructNames
end