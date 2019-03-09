function valid = validateRect(rect)
% Internal function.
%
% Returns 1 if the rect has size [1 6] and satisfies rect(4:6) >= rect(1:3).

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential


valid = 1;
if ~isnumeric(rect) || any(size(rect) ~= [1 6])
    valid = 0;
elseif any(rect(1:3) > rect(4:6))
    valid = 0;
%elseif any(rect ~= round(rect))
%    valid = 0;
end
