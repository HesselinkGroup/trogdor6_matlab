function [data, positions] = readOutputFile(fileName, varargin)
%readOutputFile Grab all the data from the named output file
%   alldat = readOutputFile(filename) is a shortcut for using OutputFile to
%   read the file.
%
% Named arguments:
%    Regions            'Separate' or 'Together' sets behavior for
%                       multi-region outputs
%    Positions          Cell array of x, y and z coordinates (1d arrays,
%                       like arguments to ndgrid)
%    Size               Resample to size Size = [Nx, Ny, Nz]
%    Times              Interpolate to Times = [t0, t1, t2]
%    InterpolateSpace   Set to true to force spatial interpolation (only
%                       necessary if the output had no Bounds attribute)

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

X.Regions = 'Separate';
X.Positions = [];
X.Size = [];
X.Times = [];
X.InterpolateSpace = [];
X = t7.parseargs(X, varargin{:});

file = t7.OutputFile(fileName);
%try
file.open();

if nargout > 1
    [data, positions] = file.readFrames(...
        'Regions', X.Regions, ...
        'Positions', X.Positions, ...
        'Times', X.Times, ...
        'Size', X.Size, ...
        'InterpolateSpace', X.InterpolateSpace);
else
    data = file.readFrames(...
        'Regions', X.Regions, ...
        'Positions', X.Positions, ...
        'Times', X.Times, ...
        'Size', X.Size, ...
        'InterpolateSpace', X.InterpolateSpace);
end
    
%end
file.close();



