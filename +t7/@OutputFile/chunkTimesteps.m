function [starts, ends, lengths] = chunkTimesteps(nFirst, nLast, valuesPerTimestep, valuesPerChunk)
% [starts, ends, lengths] = chunkTimesteps(nFirst, nLast, valuesPerTimestep, valuesPerChunk)
%

chunkTimesteps = max(1, floor(valuesPerChunk / valuesPerTimestep));

starts = nFirst:chunkTimesteps:nLast;
ends = [starts(2:end)-1, nLast];
lengths = ends - starts + 1;



