function r = rectUnion(r1, r2)
% r = rectUnion(r1, r2) Calculate the axis-oriented rectangular hull
% of the input rects r1 and r2.
%
% rectUnion is a bit of a misnomer is this operation is not a set union.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

r = [min(r1(1:3), r2(1:3)), max(r1(4:6), r2(4:6))];