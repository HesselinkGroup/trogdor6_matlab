function setTimeHarmonic(varargin)
%setTimeHarmonic Turn on time-harmonic mode.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

import t7.*

sim = simulation();

X.Center = 0.0;
X.Sigma = 0.0;
X = t7.parseargs(X, varargin{:});


% Put error-checking here
if X.Center <= 0.0
    error('Center frequency must be positive');
end

% i am starting to wonder why i didn't try to usually use X directly...
sim.TimeHarmonic = struct('center', X.Center, 'sigma', X.Sigma);


