function addBoundaryOutput(doc, sim)

root = doc.getDocumentElement;

if isempty(sim.BoundaryOutput)
    return;
end

boundaryXML = doc.createElement('BoundaryOutput');

if isfield(sim.BoundaryOutput, 'frequency')
for ff = 1:numel(sim.BoundaryOutput.frequency)
    frqXML = doc.createElement('Frequency');
    frqXML.setAttribute('omega', num2str(sim.BoundaryOutput.frequency(ff), 14));
    
    boundaryXML.appendChild(frqXML);
end
end


root.appendChild(boundaryXML);
