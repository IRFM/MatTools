function [flag] = make_pfiles(rootDir,targetDir,tarmode)
%MatTools - Build protected files from M-files
%
% List all the files and directories recursively in a directory (with the full path)
%
% INPUTS: 
%
%   - dirName: directory path [string]
%   - extName: file extension [string]
%
% OUTPUTS:
%
%   - fileList: A list all the files (with the full path)
%   - dirList: A list all the directories (with the full path)
%
dirinit = pwd;
%
[listFile,listDir] = get_all_filesname_yp(rootDir,'.m');
%
if strcmp(targetDir,'.') || strcmp(targetDir,'..'),
    cd(targetDir);
elseif isempty(targetDir),
     cd(rootDir);
else
    %
   if ~exist(targetDir,'dir'),
       mkdir(targetDir);
   end
   %
   cd(targetDir);
end
%
for ii = 1:length(listFile), 
    pcode(listFile{ii});
end
%
if tarmode,
    %
    [listFile,listDir] = get_all_filesname_yp(targetDir,'.p');
    %
    tar(tarfilename,listFile);
    %
end
%
cd(dirinit);
