function y = evalMaterial(numer, denom, z)
% y = evalMaterial(numer, denom, z) gets the frequency-domain response of
% a material with the given numerator and denominator coefficients.
%
% Set z = exp(1i*omega*t).

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

y = polyval(numer, z)./polyval(denom, z);
