% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

function seekFrame(obj, frame)
% outputFile.seekFrame(1) will go to the first frame in the file.

frameBytes = obj.FrameSize * obj.BytesPerValue;
fseek(obj.FileHandle, (frame-1)*frameBytes, 'bof');

