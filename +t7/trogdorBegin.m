function trogdorBegin(varargin)
%trogdorBegin Begin Trogdor simulation description
%   trogdorBegin('Bounds', [0 0 0 100 100 100], 'NumCells', [20 20 20], 
%       'Duration', 100, 'Courant', 0.99, 'PML', [10 10 10 10 10 10]) declares a
%       simulation where each Yee cell has size [5 5 5] and the physical
%       duration of the simulation is at least 100 (in simulation units), with
%       ten cells of PML on all six sides.  The Courant parameter adjusts the
%       timestep based on the spatial step.
%
% Named parameters:
%     Bounds               outer boundary of simulation space in real
%                          coordinates, [x0 y0 z0 x1 y1 z1]
%     NumCells             Discretize Bounds into [Nx Ny Nz] Yee cells
%     MaxCellSize          Discretize Bounds with Yee cell size <=
%                          MaxCellSize = [dx dy dz].
%     Duration             duration of simulation in real time
%     Courant              Fraction of maximum possible timestep.  0.99 is
%                          recommended.
%     PML                  Number of cells of PML on each side of
%                          simulation bounds
%                          PML = [nLowX nLowY nLowZ nHighX nHighY nHighZ]
%     ElectromagneticMode  Limit the fields used in the calculation.
%                          1d, 2d, 3d, te2d, or tm2d.  (Default: 3d)

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential


import t7.*;

X.Bounds = [0 0 0 0 0 0];
X.NumCells = [1 1 1];
X.MaxCellSize = [Inf Inf Inf];
X.Duration = 1;
X.Courant = 0.99;
X.PML = [0 0 0 0 0 0];
X.ElectromagneticMode = '3d';

X = t7.parseargs(X, varargin{:});

validateArguments(X);

minNumCells = ceil((X.Bounds(4:6) - X.Bounds(1:3)) ./ X.MaxCellSize);
X.NumCells = max(X.NumCells, minNumCells);

assert(~any(isnan(X.NumCells)));
assert(~any(isinf(X.NumCells)));

dxyz = (X.Bounds(4:6) - X.Bounds(1:3)) ./ X.NumCells;
dxyz(dxyz == 0) = 1;

assert(numel(dxyz) == 3);

dimensions = [];
for xyz = 1:3
    if X.Bounds(xyz) < X.Bounds(xyz+3) && X.NumCells(xyz) > 1
        dimensions = [dimensions, xyz];
    end
end

outerBounds = X.Bounds + X.PML .* [-1 -1 -1 1 1 1] .* [dxyz dxyz];
totalCells = X.NumCells + X.PML(1:3) + X.PML(4:6);

dt = X.Courant * t7.courant(dxyz(dimensions));
numTimesteps = ceil(X.Duration / dt);

% Determine the actual outer bounds of the simulation

global TROGDOR_SIMULATION;
TROGDOR_SIMULATION = t7.TrogdorSimulation();
sim = TROGDOR_SIMULATION;

sim.ElectromagneticMode = X.ElectromagneticMode;
sim.Dxyz = dxyz;
sim.Dt = dt;
sim.NumT = numTimesteps;
sim.NumCells = totalCells;
sim.NonPMLBounds = X.Bounds;
sim.OuterBounds = outerBounds;
sim.Grid = TrogdorGrid();

assert(numel(sim.Dxyz) == 3);

%t7.addGrid('Main', [0, 0, 0, X.NumCells-1], X.Bounds(1:3));
%t7.addGrid('Main', [0, 0, 0, totalCells-1], outerBounds(1:3), X.PML);

sim.Grid.Name = 'Main';
sim.Grid.PML = X.PML;
sim.Grid.YeeCells = [0, 0, 0, totalCells-1];
sim.Grid.Origin = outerBounds(1:3);

function validateArguments(X)

% Grid must have positive number of cells
if any(X.NumCells < 1)
    error('All elements of NumCells must be at least 1.');
end

% PML can only be attached to non-small dimensions
for xyz = 1:3
    if X.Bounds(xyz+3) == X.Bounds(xyz) % singular dimension
        if X.PML(xyz+3) > 0 || X.PML(xyz) > 0
            error('PML cannot be added to the %s side of this lower-dimensional grid',...
                char('w'+xyz));
        end
    end
end

if (~strcmpi(X.ElectromagneticMode, '1d') && ...
   ~strcmpi(X.ElectromagneticMode, '2d') && ...
   ~strcmpi(X.ElectromagneticMode, 'te2d') && ...
   ~strcmpi(X.ElectromagneticMode, 'tm2d') && ...
   ~strcmpi(X.ElectromagneticMode, '3d'))
    error('ElectromagneticMode must be 1d, 2d, te2d, tm2d or 3d');
end


