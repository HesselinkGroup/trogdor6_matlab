function [starts, ends, lengths] = chunkTimesteps(nFirst, nLast, valuesPerTimestep, valuesPerChunk)
% [starts, ends, lengths] = chunkTimesteps(nFirst, nLast, valuesPerTimestep, valuesPerChunk)
%
% Divide the range of timesteps nFirst:nLast into chunks (sub-intervals) with
% a limited number of values per chunk.  This is used to reduce memory use
% when manipulating large data files.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential


chunkTimesteps = max(1, floor(valuesPerChunk / valuesPerTimestep));

starts = nFirst:chunkTimesteps:nLast;
ends = [starts(2:end)-1, nLast];
lengths = ends - starts + 1;



