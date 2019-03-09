function close(obj)
% obj.close() close the OutputFile's file handle.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential


if obj.FileHandle == -1
    error('No data file is open.');
end

returnVal = fclose(obj.FileHandle);

if returnVal ~= 0
    error('Could not close file!');
end

obj.FileHandle = -1;
obj.SavedFrame = [];