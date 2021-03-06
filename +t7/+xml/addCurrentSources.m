% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

function addCurrentSources(sim, gridXML, doc, mode)
global TROG_XML_COUNT___;

directory = sim.directoryString;

for ss = 1:length(sim.Grid.CurrentSources)
    src = sim.Grid.CurrentSources{ss};
    
    if ~isempty(src.mode) && ~strcmpi(src.mode, mode)
        continue;
    end
    
    t7.xml.addCurrentSource(src, sim, gridXML, doc);
end




