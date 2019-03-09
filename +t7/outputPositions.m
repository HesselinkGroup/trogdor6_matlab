function xyz = outputPositions(fileName, varargin)
%outputPositions Return the x, y and z coordinates from a Trogdor output
%file.
%
%   xyz = outputPositions('out') will return the positions at which
%   fields are measured in the output file called "out".
%
%   This is a convenience function wrapping OutputFile.positions().

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential


%   Example: 'out' contains the hz field in a rectangle in 2d.
%   
%   [x y] = outputPositions('out');
%   hz = spectrum('out', 'Frequency', 2*pi*3e8/500e-9); % extract 500 nm
%   figure;
%   imagesc(x, y, abs(hz)');
%   axis xy;
%

fi = t7.OutputFile(fileName);
xyz = fi.positions(varargin{:});
