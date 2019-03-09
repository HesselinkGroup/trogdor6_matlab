function yees = yeeCells(obj, varargin)
% yee = obj.yeeCells()  Returns the indices of yeeCells from the output
% file.
%
% Each Region in the output file saves fields within a rectangle of points,
% ordered like ndgrid(ix, iy, iz), where ix, iy and iz are 1d arrays.
% yeeCells() returns ix, iy and iz.
%
% For single-Region output files: returns [ix, iy, iz].
%
% For multi-Region output files: returns { [ix1, iy1, iz1], [ix2, iy2,
% iz2], ...} by default.
%
% obj.yeeCells('Regions', 'Together') will unroll and concatenate all
% points into 1d arrays.  Equivalent to 
%    ixx, iyy, izz = ndgrid(ix, iy, iz)
% for each Region, then returning
%    [ [ixx1(:), ixx2(:), ...], [iyy1(:), iyy2(:), ...], [izz1(:), izz2(:),
%    ...] ].
% 
% obj.yeeCells('Regions', 'Separate') uses the default behavior.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

X.Regions = 'Separate'; % Separate or Together
X.Region = [];
X = t7.parseargs(X, varargin{:});

validateArguments(obj, X);

if isempty(X.Region)
    X.Region = 1;
end

yees = cell(1,3);
if strcmpi(X.Regions, 'Separate')
    for xyz = 1:3
        yees{xyz} = obj.Regions.YeeCells(X.Region,xyz) : ...
            obj.Regions.Stride(X.Region,xyz) : ...
            obj.Regions.YeeCells(X.Region, xyz+3);
    end
elseif strcmpi(X.Regions, 'Together')
    
    for rr = 1:obj.numRegions()
        [ii, jj, kk] = unrollRegion(obj.Regions.YeeCells(rr,:));
        yees{1} = [yees{1}, ii];
        yees{2} = [yees{2}, jj];
        yees{3} = [yees{3}, kk];
    end
end


function validateArguments(obj, X)

if ~strcmpi(X.Regions, 'Separate') && ~strcmpi(X.Regions, 'Together')
    error('Regions must be Separate or Together');
end

if strcmpi(X.Regions, 'Separate')
    if obj.numRegions() > 1 && isempty(X.Region)
        error('More than one region is present in this file.  Please select one using the Region argument.');
    end
end

function [ii, jj, kk] = unrollRegion(yeeCells)

ii = [];
jj = [];
kk = [];

allX = yeeCells(1):yeeCells(4);

for zz = yeeCells(3):yeeCells(6)
for yy = yeeCells(2):yeeCells(5)
    ii = [ii, allX];
    jj = [jj, yy*ones(size(allX))];
    kk = [kk, zz*ones(size(allX))];
end
end
