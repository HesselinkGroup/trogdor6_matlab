function h = imagesc_centered(varargin)
% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

h = imagesc(varargin{:});
clims = get(gca, 'CLim');
clims = [-max(abs(clims)), max(abs(clims))];
set(gca, 'Clim', clims);