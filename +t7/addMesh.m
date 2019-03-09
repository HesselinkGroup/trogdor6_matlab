function addMesh(mesh)
% addMesh(m) adds the parameterized t7.model.Mesh object to the simulation.
% Structures which touch the PML will be automatically extruded to the
% outer boundary of the PML.
%
% Mesh primitives in t7.model include Rect, Cylinder, Cone, Ellipsoid, 
% Extrude, ExtrudePath, FreeMesh, and Heightmap.
%
% Mesh transformations in t7.model include Rotate, Translate and ProcessMesh.
%
% Example:
%
% addMesh(model.Rect(@(p) [0, 0, 0, 1, 1, 1], 'Permittivity', 'Si');
%

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

import t7.*

sim = simulation();

if iscell(mesh)
    if numel(mesh) > 1
        error('Please add one mesh at a time');
    end
    
    mesh = mesh{1}; % now it's not a cell array!  :-D
end

if isa(mesh, 't7.model.Mesh')

    %if ~isempty(sim.CurrentGrid.ParameterizedMeshes)
    if ~isempty(sim.Grid.NodeGroup.children)
        error('Mixing meshes and parameterized meshes');
    end
    sim.Grid.Meshes{end+1} = mesh;
    
elseif isa(mesh, 't7.model.Node')

    if ~isempty(sim.Grid.Meshes)
        error('Mixing meshes and parameterized meshes');
    end
    sim.Grid.NodeGroup.children{end+1} = mesh;
    %sim.CurrentGrid.ParameterizedMeshes{end+1} = mesh;
    
end


%{
if nargin == 1
    if iscell(varargin{1})
        if numel(varargin{1}) > 1
            error('Please add one mesh at a time');
        else
            theMesh = varargin{1}{1};
        end
    else
        theMesh = varargin{1};
    end
    X.Vertices = theMesh.patchVertices;
    X.Faces = theMesh.faces;
    X.FreeDirections = theMesh.freeDirections();
    X.Permittivity = theMesh.permittivity;
    X.Permeability = theMesh.permeability;
else
    X.Vertices = [];
    X.Faces = [];
    X.FreeDirections = [];
    X.Permittivity = '';
    X.Permeability = '';
    X = t7.parseargs(X, varargin{:});
end

obj = struct;
obj.type = 'Mesh';

if ~isempty(X.Permittivity)
    obj.permittivity = X.Permittivity;
end

if ~isempty(X.Permeability)
    obj.permeability = X.Permeability;
end

obj.vertices = extendIntoPML(X.Vertices);

obj.faces = X.Faces-1;

if isempty(X.FreeDirections)
    obj.vertexFreeDirections = zeros(size(obj.vertices));
else
    obj.vertexFreeDirections = X.FreeDirections;
end

%patch('Vertices', obj.vertices, 'Faces', obj.faces+1, 'FaceColor', 'g', ...
%    'FaceAlpha', 0.3);
%pause(0.01);

sim.CurrentGrid.Assembly{end+1} = obj;

%}



%{
function v = extendIntoPML(vertices)

sim = t7.simulation();

if size(vertices, 2) ~= 3
    error('Vertex array must be Nx3');
end

v = vertices;

outerBounds = sim.OuterBounds;
innerBounds = sim.NonPMLBounds;

for xyz = 1:3
if innerBounds(xyz) ~= innerBounds(xyz+3)
    iFloor = vertices(:,xyz) <= innerBounds(xyz);
    iCeil = vertices(:,xyz) >= innerBounds(xyz+3);
    
    v(iFloor,xyz) = outerBounds(xyz);
    v(iCeil,xyz) = outerBounds(xyz+3);
end
end
%}






