% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

function close(obj)

if obj.FileHandle == -1
    error('No data file is open.');
end

returnVal = fclose(obj.FileHandle);

if returnVal ~= 0
    error('Could not close file!');
end

obj.FileHandle = -1;
obj.SavedFrame = [];