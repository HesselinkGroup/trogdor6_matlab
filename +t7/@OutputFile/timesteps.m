function nn = timesteps(obj)
% obj.timesteps()  Return the timesteps saved by the output file.
%
% If a single duration (time interval) is saved, returns
% nFirst:period:nLast.
%
% If multiple durations are saved, returns cell array of timestep arrays, 
% one per Duration.
% 

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

nn = cell(size(obj.Durations));

for dd = 1:length(obj.Durations)
    nn{dd} = obj.Durations{dd}.First:obj.Durations{dd}.Period:obj.Durations{dd}.Last;
end

if length(nn) == 1
    nn = nn{1};
end