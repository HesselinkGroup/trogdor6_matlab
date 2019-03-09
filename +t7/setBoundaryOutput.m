function setBoundaryOutput(varargin)
% setBoundaryOutput turns on field outputs for Yee cells intersected by
% material interfaces.
%
% setBoundaryOutput('Frequency', freq) turns on time-harmonic output mode.
% Only one frequency may be specified.


% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential



import t7.*;

sim = simulation();

X.Frequency = [];
X = t7.parseargs(X, varargin{:});

if length(X.Frequency) > 1
    error('Boundary output can only have one frequency');
end

sim.BoundaryOutput = struct('frequency', X.Frequency);


