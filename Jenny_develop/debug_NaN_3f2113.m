%First instantiate a variable for the ActiveX wrapper interface
TTX = actxcontrol('TTank.X')

% Then connect to a server.
TTX.ConnectServer('Local', 'Me')

% Now open a tank for reading.
tank = 'C:\subjects\3f2113\data\3f2113_cp\3f2113_cp';
% tank = 'C:\subjects\96498c\data\d6\96498c_CoordinatePilot';
% tank = 'C:\subjects\3f2113\data\3f2113_cp';
% tank = 'C:\subjects\3f2113\data\d6\stimMoving\stimMoving';
% tank = 'C:\subjects\3f2113\data\d6\BetaStim\BetaStim';

TTX.OpenTank(tank, 'R')

% Select the block to access
TTX.SelectBlock('3f2113_coordinate-1')
% TTX.SelectBlock('96598c_CPT-1')
% TTX.SelectBlock('stimSpacing-1')
% TTX.SelectBlock('BetaPhase-1')


channels = 1:64;

if (TTX.SetGlobalV('Channel',channels(1)) ~= 1)
    error('unable to set channel');
end

t1=0.0;
t2=0.1;
if (TTX.SetGlobalV('T1', t1) ~= 1)
    error('unable to set T1');
end
if (TTX.SetGlobalV('T2', t2) ~= 1)
    error('unable to set T2');
end

% figure out how much memory to allocate in the activex control.
% right now we'll use brute force and allocate 1 GB
if (TTX.SetGlobalV('WavesMemLimit', 1024^3) ~= 1)
    error('unable to allocate extra memory for activex');
end

tempdata = TTX.ReadWavesV('Wave');
tempmeta = TTX.ParseEvInfoV(0,1,0);
tempbutn = TTX.ReadWavesV('Butn');


data = zeros(size(tempdata, 1), length(channels));
data(:, 1) = tempdata;
meta = zeros(size(tempmeta, 1), length(channels));
meta(:, 1) = tempmeta;

clear tempdata tempmeta;

for i = 2:length(channels)
    if (o.ttx.SetGlobalV('Channel',channels(i)) ~= 1)
        error('unable to set channel');
    end
    
    data(:, i) = o.ttx.ReadWavesV(event);
    
    % collect meta info
    meta(:, i) = o.ttx.ParseEvInfoV(0,1,0);
    
end

            




    

%% Get all of the Snips across all time for channel-1
% after this call they are stored localing within the ActiveX
% wrapper code.  N will equal the number of events read.
N = TTX.ReadEventsV(10000, 'Snip', 1, 0, 0.0, 0.0, 'ALL')

% To parse out elements of the returned data use the
% ParseEvV and ParseEvInfoV calls as follow.

% To get all waveform data for all the events read just call
% the first 0 is the index offset into the list returned above
% the second arg is the number you would like parsed out and returned
W = TTX.ParseEvV(0, N);

% To get other information about the record events returned call
% ParseEvInfoV.  This call has the same two parameters as ParseEvV
% with one more param to indicate which bit of information you
% want returned.  The following are valid values for the 3rd 
% parameter:
%   1  = Amount of waveform data in bytes
%   2  = Record Type (see TCommon.h)
%   3  = Event Code Value
%   4  = Channel No.
%   5  = Sorting No.
%   6  = Time Stamp
%   7  = Scalar Value (only valid if no data is attached)
%   8  = Data format code (see TCommon.h)
%   9  = Data sample rate in Hz. (not value unless data is attached)
%   10 = Not used returns 0.
%   0  = Returns all values above
TS = TTX.ParseEvInfoV(0, N, 6);

subplot(2,1,1); plot(W)
subplot(2,1,2); hist(TS, 30) % Create a subplot of both displays

% Any single value (in this case chan no.) can be returned like this:
chan = TTX.ParseEvInfoV(35, 0, 4)

% The same can be done to return single waveforms like:
onewave = TTX.ParseEvV(35, 0)

% Finally the ParseEvV call can be used to return the value(s)
% for a bunch of scalar events:
N = TTX.ReadEventsV(10000, 'Freq', 0, 0, 0.0, 0.0, 'ALL')
freqlist = TTX.ParseEvV(0, N);

% Or a single value can be returned:
onefreq = TTX.ParseEvV(3, 0)

% Close the tank when you're done
TTX.CloseTank

%Disconnect from the tank server
TTX.ReleaseServer