function [outData, idxMovableVertices] = readDeps_freq(fname)

if nargin < 1
    fname = 'Depsilon';
end

%fclose all
fid = fopen(fname, 'r');
if fid == -1
    error('Cannot open Depsilon');
end

outData = cell(0,3);

for tensor_ij = 0:2
    
    % Read TENS marker and (i,j)
    str = fread(fid, 4, 'char=>char')';
    
    if ~strcmp(str, 'TENS')
        error('Expected TENS marker');
    end
    
    ij = fread(fid, 2, 'uint32')';
    if any(ij ~= [tensor_ij tensor_ij])
        error('Expected tensor direction %i but got %i', tensor_ij, ij);
    end
    
    % Read vertices
    numVertices = fread(fid, 1, 'uint32');
    %fprintf('%i vertices coming up.\n', numVertices);
    
    done = 0;
    while ~done
        
        str = fread(fid, 4, 'char=>char')';
        if strcmp(str, 'TEND')
            done = 1;
            continue
        elseif ~strcmp(str, 'VERT')
            error('Expected VERT marker');
        end
        %if ~strcmp(str, 'VERT')
        %    error('Expected VER marker');
        %end
        
        vNum = fread(fid, 1, 'uint32');
        %if vNum ~= vert
        %    error('Expected vertex %i but got %i', vert, vNum);
        %end
        
        %fprintf('\tVertex %i\n', vNum);
        
        for freeDir = 0:2
            
            % For each free direction:
            str = fread(fid, 4, 'char=>char')';
            if ~strcmp(str, 'DIRE')
                error('Expected DIRE marker');
            end

            xyz = fread(fid, 1, 'uint32');
            if xyz ~= freeDir
                error('Expected vertex direction %i but got %i', ...
                    freeDir, xyz);
            end
            
            fprintf('\t\tDirection %i\n', xyz);
            
            depsDone = 0;
            while ~depsDone
                str = fread(fid, 4, 'char=>char')';
                str
                if strcmp(str, 'DEND')
                    depsDone = 1;
                    continue;
                elseif ~strcmp(str, 'DEPS')                
                    error('Expected DEPS marker');
                end
            
                numValues = fread(fid, 1, 'uint32');
                
                fprintf('reading %i vals\n', numValues);
                
                valsComplex = fread(fid, numValues*2, 'float64');
                vals = valsComplex(1:2:end) + 1i*valsComplex(2:2:end);

                outData{vNum+1, freeDir+1}.tensor{tensor_ij+1, tensor_ij+1} = vals;
            end
        end
    end
        
    %fprintf('Done with %i\n', tensor_ij);
    
end

fclose(fid);

% Figure out which vertices have data in them.
idxMovableVertices = [];
if exist('outData')
    for idxVert = 1:size(outData,1)
        movable = 0;
        for xyz = 1:size(outData,2)
            if ~isempty(outData{idxVert,xyz})
                movable = 1;
            end
        end
        if movable
            idxMovableVertices = [idxMovableVertices, idxVert];
        end
    end
end
