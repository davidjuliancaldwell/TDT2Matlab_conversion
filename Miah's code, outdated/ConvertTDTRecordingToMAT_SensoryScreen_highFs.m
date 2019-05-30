% This script will convert TDT Recordings from SensoryScreen_highFs script
% to a Mat file with a Wave.data file rather than the 4 separated ECO#
% structs.

% This highFs circuit uses 4 separate stream stores for the ECoG data to
% sample the data at a higher rate (using the 4 DSPs), but to use these
% SensoryScreen mat data files with preexisting code for stim data we want
% a Wave struct rather than the ECO# structs.

% First convert the TDT recording to a MAT file
ConvertTDTRecordingToMAT

% Now open the newly created .mat file
mat_file = [outpath '\' blockname];
load(mat_file)

% Check that the ECO# structs all have the same Fs
if(isequal(ECO1.info.SamplingRateHz, ECO2.info.SamplingRateHz, ECO3.info.SamplingRateHz, ECO4.info.SamplingRateHz))
    % If they do then concatenate the ECO# structs
    Wave.info = ECO1.info;
    Wave.info.EventCode = 'Wave';
    numChannels = length(ECO1.info.ChannelNumbers)+length(ECO2.info.ChannelNumbers)+length(ECO3.info.ChannelNumbers)+length(ECO4.info.ChannelNumbers);
    Wave.info.ChannelNumbers = 1:numChannels;
    Wave.data = [ECO1.data ECO2.data ECO3.data ECO4.data];   
    
    % Save the new Wave struct (overwrite the old mat file with the ECO# structs)
    save(mat_file, 'Wave', 'Sing', 'Stim', 'Stm0');
else
    error('The ECO# sampling rates are not equal. Not concatinating them into one larger matrix.')
end
    