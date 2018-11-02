% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

function nn = timesteps(obj)

nn = cell(size(obj.Durations));

for dd = 1:length(obj.Durations)
    nn{dd} = obj.Durations{dd}.First:obj.Durations{dd}.Period:obj.Durations{dd}.Last;
end

if length(nn) == 1
    nn = nn{1};
end