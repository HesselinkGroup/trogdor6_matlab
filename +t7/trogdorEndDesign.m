function designObject = trogdorEndDesign(varargin)
% designObject = trogdorEndDesign(varargin)
%
% Tag     simulation tag for output and sim directories

X.Tag = '';
X = t7.parseargs(X, varargin{:});

simObject = t7.simulation();

designObject = t7.adjoint.DesignObject(simObject, X.Tag);

TROGDOR_SIMULATION = [];

%t7.TrogdorSimulation.clear();

