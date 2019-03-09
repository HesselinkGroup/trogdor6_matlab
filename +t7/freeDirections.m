function freeDirections(varargin)
% Deprecated.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

import t7.*
sim = simulation();

X.YeeBounds = [0 0 0 0 0 0];
X.Directions = [0 0 0];
X = t7.parseargs(X, varargin{:});

if ~validateRect(X.YeeBounds)
    error('Invalid rectangle.');
end

for nn = 1:length(sim.Grid.Assembly)
if strcmp(sim.Grid.Assembly{nn}.type, 'Mesh')
    for vv = 1:length(sim.Grid.Assembly{nn}.vertices)
        if all(sim.Grid.Assembly{nn}.vertices(vv,:) >= X.YeeBounds(1:3)) &&...
            all(sim.Grid.Assembly{nn}.vertices(vv,:) <= X.YeeBounds(4:6))
            sim.Grid.Assembly{nn}.vertexFreeDirections(vv,:) = X.Directions;
        end
    end
end
end