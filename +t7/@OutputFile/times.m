function tt = times(obj, varargin)
% tt = obj.times(fieldIdx)  Return the time points for the fieldIdx-th
% field saved in the output file.  ONLY WORKS FOR ONE FIELD AT A TIME.
%
% Example: assume OutputFile saved Ex and Hy.
%
% obj.times(1) returns the time points for Ex samples
% obj.times(2) returns the time points for Hy samples
%
% obj.times() is equivalent to obj.times(1).

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential


X.Field = [];
X = t7.parseargs(X, varargin{:});
validateArguments(obj, X);

if isempty(X.Field)
    X.Field = 1;
end

nn = obj.timesteps();
if ~iscell(nn)
    nn = {nn};
end
offset = obj.Fields{X.Field}.Offset(4);

tt = [];
for dd = 1:length(obj.Durations)
    tt = [tt, obj.Dt*(nn{dd} + offset)];
end


function validateArguments(obj, X)

if obj.numFields() > 1 && isempty(X.Field)
    error('More than one field is present in this file.  Please provide a Field.');
end

