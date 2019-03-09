function h = imagesc_centered(varargin)
% imagesc_centered() is a call to imagesc() followed by adjustment of the
% CLim to be symmetrical about zero.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

h = imagesc(varargin{:});
clims = get(gca, 'CLim');
clims = [-max(abs(clims)), max(abs(clims))];
set(gca, 'Clim', clims);