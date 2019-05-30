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

for i=1:46
    tankpath = 'C:\subjects\2a8d14\data\d7\2a8d14_stimulationSpacing';
    blockname = strcat('stimSpacing_2a8d14-', num2str(i));
    outpath = 'C:\subjects\2a8d14\data\d7\Matlab';
    mTDT2MAT(tankpath, blockname, outpath);
    
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
    
end





