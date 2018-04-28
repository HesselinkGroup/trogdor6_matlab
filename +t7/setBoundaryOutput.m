function setBoundaryOutput(varargin)

import t7.*;

sim = simulation();

X.Frequency = [];
X = t7.parseargs(X, varargin{:});

sim.BoundaryOutput = struct('frequency', X.Frequency);