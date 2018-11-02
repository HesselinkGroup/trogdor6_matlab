function y = evalMaterial(numer, denom, z)
% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

y = polyval(numer, z)./polyval(denom, z);
