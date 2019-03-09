function xyzt = fieldOffset(fieldString)
% xyzt = fieldOffset(fieldString) gets the space-time offset of a field in
% the Yee scheme.
%
% Example:
%
% fieldOffset('ex') returns [0.5, 0, 0, 0] because the Ex field is located
% at [0.5*dx, 0, 0] inside the Yee cell and at offset 0*dt in time
%
% fieldOffset('hx') returns [0, 0.5, 0.5, 0.5] because the Hx field is
% located at [0, 0.5*dy, 0.5*dz] inside the Yee cell and at offset 0.5*dt
% in time.
%

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

xzyt = [0 0 0 0];

switch fieldString
    case {'ex', 'exx'}
        xyzt = [0.5 0 0 0];
    case {'ey', 'eyy'}
        xyzt = [0 0.5 0 0];
    case {'ez', 'ezz'}
        xyzt = [0 0 0.5 0];
    case {'hx', 'hxx'}
        xyzt = [0 0.5 0.5 0.5];
    case {'hy', 'hyy'}
        xyzt = [0.5 0 0.5 0.5];
    case {'hz', 'hzz'}
        xyzt = [0.5 0.5 0 0.5];
    case {'dx', 'dxx'}
        xyzt = [0.5 0 0 0];
    case {'dy', 'dyy'}
        xyzt = [0 0.5 0 0];
    case {'dz', 'dzz'}
        xyzt = [0 0 0.5 0];
    case {'bx', 'bxx'}
        xyzt = [0 0.5 0.5 0.5];
    case {'by', 'byy'}
        xyzt = [0.5 0 0.5 0.5];
    case {'bz', 'bzz'}
        xyzt = [0.5 0.5 0 0.5];
    case {'jx', 'jex'}
        xyzt = [0.5 0 0 -0.5];
    case {'jy', 'jey'}
        xyzt = [0 0.5 0 -0.5];
    case {'jz', 'jez'}
        xyzt = [0 0 0.5 -0.5];
    case {'mx', 'mhx'}
        xyzt = [0 0.5 0.5 0];
    case {'my', 'mhy'}
        xyzt = [0.5 0 0.5 0];
    case {'mz', 'mhz'}
        xyzt = [0.5 0.5 0 0];
end
