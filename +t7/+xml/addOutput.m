% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

function addOutput(output, sim, gridXML, doc)

%directory = sim.outputDirectoryString;

elemXML = doc.createElement('FieldOutput');
elemXML.setAttribute('fields', output.fields);
%elemXML.setAttribute('file', [directory, output.filename]);
elemXML.setAttribute('file', output.filename);

if isfield(output, 'frequency') 
for ff = 1:numel(output.frequency)
    frqXML = doc.createElement('Frequency');
    frqXML.setAttribute('omega', num2str(output.frequency(ff), 14));
    
    elemXML.appendChild(frqXML);
end
end

% durations and regions.

for dd = 1:size(output.timesteps, 1)
    durXML = doc.createElement('Duration');
    durXML.setAttribute('firstTimestep', num2str(output.timesteps(dd,1)));
    durXML.setAttribute('lastTimestep', num2str(output.timesteps(dd,2)));
    durXML.setAttribute('period', num2str(output.period(dd)));
    
    if isfield(output, 'duration') && ~isempty(output.duration)
        durXML.setAttribute('duration', num2str(output.duration(dd,:)));
    end
    
    elemXML.appendChild(durXML);
end

for rr = 1:size(output.yeeCells, 1)
    regionXML = doc.createElement('Region');
    regionXML.setAttribute('yeeCells', ...
        sprintf('%i ', output.yeeCells(rr,:)));
    
    if size(output.bounds, 1) == size(output.yeeCells, 1)
        regionXML.setAttribute('bounds', sprintf('%i ', output.bounds(rr,:)));
    end
    
    elemXML.appendChild(regionXML);
end

gridXML.appendChild(elemXML);

