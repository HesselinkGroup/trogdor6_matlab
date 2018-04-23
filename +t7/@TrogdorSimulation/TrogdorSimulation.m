classdef TrogdorSimulation < handle
    
    properties
        Materials = {};
        Grid = t7.TrogdorGrid;
        ElectromagneticMode = '3d'
        TimeHarmonic = []
        Dxyz = 0
        Dt = 0
        NumT = 0
        NumCells = [1 1 1];
        NonPMLBounds = [];
        OuterBounds = [];
        Precision = 'float64';
        Directory = '';
        OutputDirectory = '';
    end
    
    methods
        function obj = TrogdorSimulation()
            obj.Grid = t7.TrogdorGrid;
        end
        
        function str = directoryString(obj)
            if isempty(obj.Directory)
                str = '';
            else
                str = [obj.Directory, filesep()];
            end
        end
        
        function str = outputDirectoryString(obj)
            if isempty(obj.OutputDirectory)
                str = '';
            else
                str = [obj.OutputDirectory, filesep()];
            end
        end
        
        timesteps = timeToTimesteps(obj, timeBounds, fieldTokens);
        yeeCells = boundsToYee(obj, bounds, fieldTokens); 
        y = yeeCells(obj, bounds);
        v = extendIntoPML(obj, verts);
    end
    
end
