%% to read in old file formats, resave under different name, for comparison to new methods
Sing2 = Sing;
Butt2 = Butt;
ECO12 = ECO1;
ECO22 = ECO2;
ECO32 = ECO3;
Stim2 = Stim;
Tone2 = Tone;
Valu2 = Valu;

clear Sing Butt ECO1 ECO2 ECO3 Stim Tone Valu

%% check that all epoch onset and offset timing is the same
len = length(fieldnames(data.epocs));

% structfun(size, data.epocs)

names = fieldnames(data.epocs);
onsets = cell(size(1,len));
offsets = cell(size(1,len));
% onsets = zeros(size(1,len));
% offsets = zeros(size(1,len));
for i=1:len
    storeName = char(names(i));
    onsets{i} = data.epocs.(storeName).onset;
    offsets{i} = data.epocs.(storeName).offset;
end

% make matrix (leave Ticks (#1) out)
onsetsMat = cell2mat(onsets(2:end))';
offsetsMat = cell2mat(offsets(2:end))';

% check if they're equal by finding unique
isequal(onsetsMat(1,:), unique(onsetsMat, 'rows', 'stable'))
isequal(offsetsMat(1,:), unique(offsetsMat, 'rows', 'stable'))