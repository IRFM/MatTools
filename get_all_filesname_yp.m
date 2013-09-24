function fileList = get_all_filesname_yp(dirName)
%LUKE - List all the files in a directory and all sub-directories (with the full path)
%
% List all the files in a directory and all sub-directories (with the full path)
%
% INPUTS: 
%
%   - dirName: directory path [string]
%
% OUTPUTS:
%
%   - fileList: A list all the files (with the full path)
%
% by Y.Peysson CEA-IRFM <yves.peysson@cea.fr> and Joan Decker CEA-IRFM (joan.decker@cea.fr)
%
if nargin == 0,
	dirName = pwd; 
end
%
dirData = dir(dirName);  
dirIndex = [dirData.isdir];
fileList = {dirData(~dirIndex).name}';
%
if ~isempty(fileList),
    fileList = cellfun(@(x) fullfile(dirName,x),fileList,'UniformOutput',false);% Prepend path to files
end
%
subDirs = {dirData(dirIndex).name};
validIndex = ~ismember(subDirs,{'.','..'});
%
for iDir = find(validIndex),
    nextDir = fullfile(dirName,subDirs{iDir});
    fileList = [fileList; get_all_filesname_yp(nextDir)];
end

