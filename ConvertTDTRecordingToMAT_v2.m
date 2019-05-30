%% ConvertTDTRecordingToMAT_v2
% written 04/03/17 
% Jenny Cronin 

%% This script replaces ConvertTDTRecordingToMAT
% It is a wrapper for TDT's function TDT2mat.m, to convert their output to
% the output that we're used to using

% Background:
% ConvertTDTRecordingToMAT was originally written by Jeremiah Wander.
% That older version required subscripts: mTDT2MAT and TDT2mat which Miah
% wrote before TDT create good functions to do this data conversion. Miah's
% scripts didn't work on Epoch or Block Data Tanks, but TDT has since
% released a version of their TDT2mat.m function which does work on those
% data types. We're now using TDT's function, but need this wrapper to
% create data types (structures) like the ones that Miah originally created
% because all of our other scripts work on that. 

% TDT2mat.m returns a single struct (data) with substructs for each of the data
% types that a file includes. We open up those structs and return
% individual structs for each data stream from the RPvdsEx circuit.

if (exist('myGetenv', 'file'))
    start = myGetenv('subject_dir');    
    if (isempty(start))
        start = pwd;
    end
else
    start = pwd;
end

rawpath = uigetdir(start, 'select a TDT data BLOCK');
[tankpath, blockname] = fileparts(rawpath);
outpath = uigetdir(tankpath, 'select an output directory for MAT file');


TDT2mat_GridLabWrapper


%% Save to output file
save(fullfile(outpath, [blockname '.mat']), '-v7.3', eventnames{:});
    