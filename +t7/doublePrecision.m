function doublePrecision
% doublePrecision() sets simulation to use double-precision input and
% output files.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

sim = t7.simulation();
sim.Precision = 'float64';
