function nt = numTimesteps()
% nt = numTimesteps() returns the number of timesteps in the simulation
% under construction.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

sim = t7.simulation();
nt = sim.NumT;