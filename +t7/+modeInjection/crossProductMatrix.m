function A = crossProductMatrix(v)
% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential


assert(numel(v) == 3);

A = [0, -v(3), v(2); v(3), 0, -v(1); -v(2), v(1), 0];

