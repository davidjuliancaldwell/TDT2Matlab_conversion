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

for i=1:2
    tankpath = 'C:\Subjects\b9b6d\b9b6d_motorScreen';
    blockname = strcat('motorScreen-', num2str(i));
    outpath = 'C:\Subjects\b9b6d\ConvertedMatlabFiles\motor_screen';
    mTDT2MAT(tankpath, blockname, outpath);
end





