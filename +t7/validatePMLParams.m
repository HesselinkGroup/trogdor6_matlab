function valid = validatePMLParams(cellArray)
% Internal function.
%
% Checks that cellArray contains only named parameters 'kappa', 'alpha' and
% 'sigma'.  Some valid cell arrays are:
%
% {'kappa', 5, 'sigma', 2, 'alpha', 0}
% {'kappa', 1}
% {'alpha', 2, 'kappa', 1}
% 
% etc.  Returns 1 for valid, 0 for invalid.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

valid = 1;

X.kappa = '';
X.alpha = '';
X.sigma = '';
    
try
    X = parseargs(X, cellArray{:});
catch
    valid = 0;
end
