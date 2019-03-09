function open(obj)
% obj.open() opens the OutputFile's internal file handle.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

if obj.FileHandle ~= -1
    error('Data file is already open for reading.  Please call close().');
end

obj.FileHandle = fopen(obj.FileName);
if obj.FileHandle == -1
    error('Data file cannot be opened.');
end

obj.NextFrameNumber = 1;
%obj.Durations{1}.First+1;