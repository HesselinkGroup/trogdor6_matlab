function seekFrame(obj, frame)
% obj.seekFrame(frame) moves the OutputFile's internal file pointer to the
% start of the given timestep or frequency.
%
% outputFile.seekFrame(1) will go to the first frame in the file.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential


frameBytes = obj.FrameSize * obj.BytesPerValue;
fseek(obj.FileHandle, (frame-1)*frameBytes, 'bof');

