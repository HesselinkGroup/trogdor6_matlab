function designObject = trogdorEndDesign(varargin)
% designObject = trogdorEndDesign() finishes construction of
% parameterizable simulation object.
%
% designObject = trogdorEndDesign('Tag', 'a_tag') will tag the output and 
% simulation directories with the given string.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential


X.Tag = '';
X = t7.parseargs(X, varargin{:});

simObject = t7.simulation();

designObject = t7.adjoint.DesignObject(simObject, X.Tag);

TROGDOR_SIMULATION = [];

%t7.TrogdorSimulation.clear();

