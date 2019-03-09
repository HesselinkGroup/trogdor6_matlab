function p = getTrogdorPath()
% p = getTrogdorPath()  Return path to trogdor executable
%
% If trogdorpath.m is in the MATLAB search path, it is executed to obtain
% the trogdor executable path.  Otherwise, '/usr/local/bin/trogdor' is
% used.

result = exist('trogdorpath.m');

if result == 2
    p = trogdorpath();
else
    p = '/usr/local/bin/trogdor7';
end
