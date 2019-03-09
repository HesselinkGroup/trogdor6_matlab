
function [data, positions] = readFrames(obj, varargin)
% [data, positions] outputFile.readFrames() reads data from the output file starting at the
% current file position.
%
% Returns: 
%    data        Array or cell array of field data.
%                If Regions == Together is given, data will be of size
%                [numPoints numFields numFrames].
%                If Regions == Separate is given, each region will be of 
%                size [Nx Ny Nz numFields numFrames].
%    positions   Cell array of positions of output fields
%
% Named arguments:
% 
%   Regions      If 'Together', concatenate fields from all Regions into 
%                one array.
%                If 'Separate', put each region into its own cell in data.
%                If 'Separate' and only one Region is in the file, then
%                data will be a single array, not a cell array.
%   Size         Resample to the given size
%   Times        Resample to the given time points
%   Positions    {x, y, z} 1d arrays, suitable for arguments to ndgrid.
%                The data will be resampled onto the points given by
%                ndgrid(x,y,z).
%   InterpolateSpace  Force spatial interpolation of fields in the rare
%                     case that Bounds was not specified in the file.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

X.NumFrames = obj.numFramesAvailable();
X.Regions = 'Separate';
X.Size = [];
X.Times = [];
X.Positions = [];
X.InterpolateSpace = [];

X = t7.parseargs(X, varargin{:});
if isempty(X.InterpolateSpace)
    X.InterpolateSpace = obj.hasBounds();
end

if obj.FileHandle == -1
    error('No data file is open.  Try open()?');
end

if ~isempty(X.Positions)
    if ~iscell(X.Positions)
        X.Positions = {X.Positions(:,1), X.Positions(:,2), X.Positions(:,3)};
    end
end

% Figure out whether to interpolate in space and/or time.
% By default, as much interpolation as possible will be performed.
% The user can turn it off of course.

if X.InterpolateSpace
    if isempty(X.Positions)
        % fill in some natural sampling points.
        X.Positions = myNaturalSamplingPositions(obj, X.Size);
    end
elseif ~isempty(X.Positions)
    X.InterpolateSpace = true;
end

interpTime = ~isempty(X.Times);

if strcmp(X.Regions, 'Separate')
    if interpTime
        data = obj.readFrames_RegionsSeparate_InterpTime(X);
    else
        data = obj.readFrames_RegionsSeparate(X);
    end
else
    data = obj.readFrames_RegionsTogether(X.NumFrames);
end

if ~isempty(X.Positions)
    positions = X.Positions;
elseif nargout > 1
    if obj.numFields() == 1
        positions = obj.positions();
    else
        warning('There are multiple fields in this file.  Not computing positions.');
    end
end




function pos = myNaturalSamplingPositions(obj, numSamplesInRegions)

pos = cell(obj.numRegions, 3);

for rr = 1:obj.numRegions()
    
    if ~isempty(numSamplesInRegions)
        numSamples = numSamplesInRegions(rr,:);
    else
        numSamples = [];
    end
    
    positionsInRegion = naturalSamplingPositions(obj, obj.Regions.Bounds(rr,:), rr, ...
        numSamples);
    
    for xyz = 1:3
        pos{rr,xyz} = positionsInRegion{xyz};
    end
end

