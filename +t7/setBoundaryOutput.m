% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

function setBoundaryOutput(varargin)

import t7.*;

sim = simulation();

X.Frequency = [];
X = t7.parseargs(X, varargin{:});

if length(X.Frequency) > 1
    error('Boundary output can only have one frequency');
end

sim.BoundaryOutput = struct('frequency', X.Frequency);


