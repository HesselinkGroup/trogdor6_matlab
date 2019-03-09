classdef DesignObject < handle
% DesignObject  Parameterizable Trogdor simulation.
%
% This is produced by trogdorEndDesign().
    
% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

    properties
        Sim
        XML
    end
    
    
    methods
        function obj = DesignObject(sim, tag)
            
            if ~exist('tag', 'var')
                tag = '';
            end
            obj.Sim = sim;
            
            if ~isempty(tag)
                obj.Sim.Directory = ['sim_', tag];
                obj.Sim.OutputDirectory = ['output_', tag];
            else
                obj.Sim.Directory = 'sim';
                obj.Sim.OutputDirectory = 'output';
            end
            
            obj.XML = 'params.xml';
        end
        
        function writeSimulation(obj, designParameters, mode)
            % obj.writeSimulation(p, mode)  Save simulation setup files
            %
            % Create simulation file directory ('sim' by default) and save
            % the simulation XML file and source current binary and spec
            % files within.
            %
            % Create output directory for Trogdor output files.
            import com.mathworks.xml.XMLUtils.*;
            
            if ~strcmpi(mode, 'forward') && ~strcmpi(mode, 'adjoint')
                error('Mode must be forward or adjoint');
            end
            
            if ~isempty(obj.Sim.Directory) && ~exist(obj.Sim.Directory, 'dir')
                try mkdir(obj.Sim.Directory)
                catch exception
                    error('Could not create helper directory!');
                end
            end

            if ~isempty(obj.Sim.OutputDirectory) && ~exist(obj.Sim.OutputDirectory, 'dir')
                try mkdir(obj.Sim.OutputDirectory)
                catch exception
                    error('Could not create output directory!');
                end
            end
            
            doc = t7.xml.generateXML(obj.Sim, designParameters, mode);
            xmlwrite([obj.Sim.Directory, filesep, obj.XML], doc);
        end
        
        function applyParameters(obj, designParameters)
            % obj.applyParameters(p)  Instantiate the faces and vertices
            % of all structures in the simulation, as functions of the
            % design parameters p.
            obj.Sim.Grid.Meshes = obj.Sim.Grid.NodeGroup.meshes(designParameters);
        end
        
        function f = evaluateForward(obj)
            % f = obj.evaluateForward()  Calculate the value of the objective
            % function, after Trogdor has run the forward calculation.
            f = 0;
            
            for mm = 1:numel(obj.Sim.Grid.Measurements)
                meas = obj.Sim.Grid.Measurements{mm};
            
                fname = [obj.Sim.OutputDirectory filesep meas.filename];
            
                f = f + t7.adjoint.evalQuadraticFormFile(fname, meas.filters, meas.kernel);
            end
        end
        
        function [f, dfdp, dfdv, dvdp] = evaluate(obj, designParameters)
            % [f, dfdp, dfdv, dvdp] = obj.evaluate(p)  Instantiate a
            % simulation with the given design parameters, and return the
            % value of the objective function and three Jacobians:
            %
            %   f      value of objective function
            %   dfdp   sensitivity of f to design parameters p
            %   dfdv   sensitivity of f to mesh vertices
            %   dvdp   sensitivity of mesh vertices to design parameters
            %
            % This function will try to call Trogdor.  This relies on
            % having the right path to Trogdor.
            
            [dfdp, dfdv, dvdp] = t7.adjoint.calculateAdjointSensitivity(...
                obj.Sim.Grid.NodeGroup, designParameters, ...
                obj.Sim.OutputDirectory);
                
            for mm = 1:numel(obj.Sim.Grid.Measurements)
                meas = obj.Sim.Grid.Measurements{mm};
                
                fname = [obj.Sim.OutputDirectory filesep meas.filename];
                
                f_ = t7.adjoint.evalQuadraticFormFile(fname, meas.filters, meas.kernel);
                
                if mm == 1
                    f = f_;
                else
                    f = f + f_;
                end
            end
        end
        
    end
    
end