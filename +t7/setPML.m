function setPML(varargin)
%setPML Adjust the depth and variable parameters of the CFS-RIPML for a grid or
%   for a particular material
%
%   setPML('Depth', [10 10 0 10 10 0]) will add 10 cells of PML to the current
%       grid on the -X, -Y, +X and +Y sides
%   setPML('Sigma', '(d^4)*0.8*4/(((mu0/eps0)^0.5)*dx') will cause the PML to
%       use a fourth-power scaling for the conductivity, where the variable 'd'
%       varies from 0 at the inside edge of the PML to 1 at the deepest point,
%       and 'dx' takes on the value of dx for +X and -X PML, dy for +Y and -Y,
%       and dz for +Z and -Z.
%   setPML('Kappa', '5') will cause the PML to use a fixed real stretch factor
%       of 5.
%   setPML('Alpha', '0') will turn off the CFS-RIPML's complex frequency
%   shift.
%
%   Named parameters may be combined, so 'Sigma', 'Alpha', 'Kappa' and 'Depth'
%   may be set all at once.
%
%   The default PML parameters in Trogdor 6 are:
%
%     sigma = '(d^3)*0.8*4/(((mu0/eps0)^0.5)*dx)'
%     alpha = '(1-d)*3e8*eps0/L'
%     kappa = '1 + (5-1)*(d^3)'
%
%   Sigma and kappa are taken from Taflove's suggested values.
%   Alpha is chosen so that wavelengths larger than the simulation space
%   are assumed to be evanescent.
%
%   Variables permitted in the expressions for sigma, alpha and kappa are:
%       d       distance into the PML, from 0 to 1 (so 1 is the outside of
%               the grid)
%       dx      the cell size in the direction of attenuation
%       L       diagonal extent of the entire simulation
%       mu0     permeability of free space
%       eps0    permittivity of free space
%        

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

import t7.*

sim = simulation();
%grid = sim.CurrentGrid;

X.Depth = [];
X.Kappa = '';
X.Alpha = '';
X.Sigma = '';
X = t7.parseargs(X, varargin{:});

if length(X.Depth) ~= 0
    if length(X.Depth) ~= 6
        error('PML depth must be a length-six array of integers.');
    end
    
    sim.Grid.PML = X.Depth;
end

if any(X.Depth < 0)
    error('PML depths must all be nonnegative integers.');
end

if ~isempty(X.Depth)
    error('PML depth must be set in trogdorBegin()');
end

if length(X.Kappa) ~= 0
    sim.Grid.PMLParams.kappa = X.Kappa;
end

if length(X.Sigma) ~= 0
    sim.Grid.PMLParams.sigma = X.Sigma;
end

if length(X.Alpha) ~= 0
    sim.Grid.PMLParams.alpha = X.Alpha;
end
