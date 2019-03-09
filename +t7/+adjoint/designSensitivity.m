function [f, dfdp, dfdv] = designSensitivity(designObject, parameters, callback)
% [f dfdp dfdv] = designSensitivity(designObject, parameters, callback)
%
% Internal function

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential


%global fs;
%global ps;

designObject.applyParameters(parameters);
designObject.writeSimulation(parameters, 'forward');

tpath = t7.getTrogdorPath();
if ~exist(tpath)
    error('Cannot find trogdor executable at %s', tpath);
end

if strcmpi(computer, 'GLNXA64')
    snapdragon = ['env -u LD_LIBRARY_PATH ', tpath];
    %snapdragon = 'env -u LD_LIBRARY_PATH snapdragon';
    %meshboolean = 'env -u LD_LIBRARY_PATH meshboolean';
else
    snapdragon = tpath;
    %meshboolean = '/usr/local/bin/meshboolean';
end

% unixCall = sprintf('%s %s/params.xml %s/bparams.xml; %s --geometry --sensitivity --outputDirectory %s %s/bparams.xml > out.txt', ...
%     meshboolean, designObject.Sim.Directory, designObject.Sim.Directory, ...
%     snapdragon, designObject.Sim.OutputDirectory, ...
%     designObject.Sim.Directory);

unixCall = sprintf('%s --geometry --sensitivity --outputDirectory %s %s/params.xml > out.txt', ...
    snapdragon, designObject.Sim.OutputDirectory, designObject.Sim.Directory);

tic;
exitval = unix(unixCall);
t = toc;
%fprintf('Forward sim: %0.2f s\n', t);

if exitval
    warning('Unix is unhappy with forward sim');
    vertSize = numel(designObject.Sim.Grid.NodeGroup.vertices(parameters));
    f = -realmax;
    dfdp = zeros(1, length(parameters));
    dfdv = zeros(vertSize, length(parameters));
    return;
end

designObject.writeSimulation(parameters, 'adjoint');

% unixCall = sprintf('%s %s/params.xml %s/bparams.xml; %s --adjoint --sensitivity --outputDirectory %s %s/bparams.xml > out.txt', ...
%     meshboolean, designObject.Sim.Directory, designObject.Sim.Directory, ...
%     snapdragon, designObject.Sim.OutputDirectory, ...
%     designObject.Sim.Directory);

unixCall = sprintf('%s --adjoint --sensitivity --outputDirectory %s %s/params.xml > out.txt', ...
    snapdragon, designObject.Sim.OutputDirectory, designObject.Sim.Directory);

%unixCall = sprintf('%s --adjoint --booleans --sensitivity --outputDirectory %s %s/params.xml > out.txt', ...
%    snapdragon, designObject.Sim.OutputDirectory, ...
%    designObject.Sim.Directory);

tic;
exitval = unix(unixCall);
t = toc;
%fprintf('Adjoint sim: %0.2f s\n', t);

if exitval
    warning('Unix is unhappy with adjoint sim');
    vertSize = numel(designObject.Sim.Grid.NodeGroup.vertices(parameters));
    f = -realmax;
    dfdp = zeros(1, length(parameters));
    dfdv = zeros(vertSize, length(parameters));
    return;
end

[f, dfdp, dfdv] = designObject.evaluate(parameters);

if isnan(f) || any(isnan(dfdp)) || any(isnan(dfdv))
    keyboard
end

%fs(end+1) = f;
%ps(end+1) = parameters;

if nargin > 2
    callback(designObject, parameters, f, dfdp, dfdv);
end

% Change the signs here to increase rather than decrease the objective function
%dfdp = -dfdp;
%f = -f;
