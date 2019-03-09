function n = numFramesAvailable(obj)
% n = obj.numFramesAvailable() returns the number of completely-written
% timesteps or frequency steps in the output file.  During a long-running
% simulation, earlier timesteps may be written to the disk and available
% for visualization or analysis before the entire simulation has completed.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

if ~exist(obj.FileName, 'file')
    n = 0;
else
    fileStruct = dir(obj.FileName);
    
    if (fileStruct.bytes == 0)
        n = 0;
    else
        n = floor(fileStruct.bytes / obj.BytesPerValue / obj.FrameSize);
    end
    
    %{
    %determine size of file in bytes (this is gross; Matlab's fault!!! lame API)
    d = dir;
    for nn = 1:length(d)
        if strcmp(d(nn).name, obj.FileName)
            n = floor( d(nn).bytes / obj.BytesPerValue / obj.FrameSize );
        end
    end
    %}
end

assert(~isnan(n))
assert(~isinf(n))