%% ConvertTDTRecordingToMAT_v2_loop
% written 04/17/17
% Jeneva Cronin and David Caldwell

%% This script replaces ConvertTDTRecordingToMAT_loop
% It is a wrapper for TDT's function TDT2mat.m, as well as our
% ConvertTDTRecordingToMat_v2, to convert their output to the output
% that we're used to using for a batch of files

% Background:
% ConvertTDTRecordingToMAT_loop was originally written by Jenny Cronin.

% this script collects all of the records in a tdt data tank and converts
% it to a mat file
if (exist('myGetenv', 'file'))
    start = myGetenv('subject_dir');
    if (isempty(start))
        start = pwd;
    end
else
    start = pwd;
end

rawpath = uigetdir(start, 'select a TDT data BLOCK (i.e., not just the tank, but a block within the tank)');
[tankpath, blockname, ext] = fileparts(rawpath);
outpath = uigetdir(tankpath, 'select an output directory for MAT file');

experiment = split(blockname,'-');
rawpath_gen = split(rawpath,'-');

startTrial = input('Trial number to start conversion with:\n');
endTrial = input('Trial number to end conversion with:\n');
disp(['Converting trials ', num2str(startTrial), ' to ', num2str(endTrial)])

for i = startTrial:endTrial
    disp(['Converting trial #', num2str(i), '...'])
    blockname = strcat(experiment{1},'-',num2str(i));
    
    TDT2mat_GridLabWrapper    
        
    % Save to output file
    save(fullfile(outpath, [blockname '.mat']), '-v7.3', eventnames{:});
    
    clearvars -except tankpath blockname numtrials experiment outpath
end