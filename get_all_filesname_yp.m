% 
% /////////////////////////////////////////
%
% Software name : MatTools, part of LUKE
%
% Authors : Yves Savoye-Peysson and Joan Decker
%
% Copyright holders : Commissariat a l'Energie Atomique et aux Energies Alternatives (CEA), France
%
% CEA authorizes the use of the LUKE software under the CeCILL-C open source license https://cecill.info/licences/Licence_CeCILL-C_V1-en.html
%
% The terms and conditions of the CeCILL-C license are deemed to be accepted upon downloading the software and/or exercising any of the rights granted under the CeCILL-C license.
%
% /////////////////////////////////////////
%
function [varargout] = get_all_filesname_yp(dirName,extName,dirLevel,excludedName)
%MatTools - List all the files and directories recursively in a directory (with the full path)
%
% List all the files and directories recursively in a directory (with the full path)
%
% INPUTS: 
%
%   - dirName: directory path [string]
%   - extName: file extension [string or cell of strings]
%   - dirLevel: maximum directory level [1,1]
%   - excludedName: excluded names [cell of strings]
%
% OUTPUTS:
%
%   - fileList: A list all the files (with the full path)
%   - dirList: A list all the directories (with the full path)
%
% EXAMPLES
%
% [listFile,listDir] = get_all_filesname_yp('.')
% [listFile,listDir] = get_all_filesname_yp('RootDirName')
% [listFile,listDir] = get_all_filesname_yp('RootDirName','.*')
% [listFile,listDir] = get_all_filesname_yp('RootDirName','.m')
% [listFile,listDir] = get_all_filesname_yp('RootDirName',{'.m','.php'})
% [listFile,listDir] = get_all_filesname_yp('RootDirName','m*')
%
% by Y.Peysson CEA-IRFM <yves.peysson@cea.fr> and Joan Decker CEA-IRFM (joan.decker@cea.fr)
%
if nargin == 0,
	dirName = pwd; 
    extName = [];
    dirLevel = Inf;
    excludedName = [];
elseif nargin == 1,
    extName = [];
    dirLevel = Inf;
    excludedName = [];
elseif nargin == 2,
    dirLevel = Inf;
    excludedName = [];
end
%
if ~iscell(extName) && strcmpi(extName,'.*'),
   extName = [];
end
%
if ~iscell(excludedName),
    excludedName = {excludedName};
end
%
listFile = [];
listDir{1,1} = dirName;
indexDir(1) = 1;
%
stc = '';
%
if isempty(extName),
    %
    flag = 1;
    stc = '';
    %
elseif ~iscell(extName),
    %
    ii = strfind(extName,'*');
    %
    if length(ii) == 1 & ii == length(extName);
        flag = 2;
        stc = strrep(extName,'*','');
    else
        flag = 3;
        stc = extName;
    end
    %
elseif iscell(extName),
    %
    flag = 4;
    stc = extName;
    %
else
    %
    extName = [];
    flag = 1;
    stc = extName;
    %
end
%
level = 0;
%
while level <= dirLevel,
    index = find(indexDir);
    %
    if isempty(index),break;end
    index = index(1);
    %
    [listdir,listfile] = getdir(listDir{index},flag,stc,excludedName);
    %
    listFile = [listFile listfile];
    %
    indexDir(index) = 0;
    %
    nbdir = length(listdir);
    %
    if nbdir,
        %
        listDir = [listDir listdir];
        indexDir = [indexDir ones(1,nbdir)];
        %
    end
    %
    level = level + 1;
end
%
if ~nargout,
    for i = 1:length(listFile),
        fprintf('%s\n',listFile{i});
    end
else
    varargout{1} = listFile;
    varargout{2} = listDir;
end
%
return
%
function [listdir,listfile] = getdir(folder,flag,ext,excludedName)
    %
    S = dir(folder);
    %
    n = size(S,1);
    %
    listdir = cell(1,n);
    listfile = cell(1,n);
    %
    nd = 0;
    nf = 0;
    %
    for i = 1:n,
        %
        name = S(i).name;
        %
        if S(i).isdir,
            if strcmp(name,'.') || strcmp(name,'..') || strcmp(name,'CVS') || strcmp(name,'.git'),
                continue
            else
                flag_dir = 1;
                for ie = 1:length(excludedName),
                    if strcmp(name,excludedName{ie})
                        flag_dir = 0;
                        break
                    end
                end
                %
                if ~flag_dir,                
                    continue;
                end    
            end
            %
            if flag == 2 || flag == 3,
                nd = nd + 1;
                listdir{nd} = fullfile(folder,S(i).name);
            else
                listdir{i} = fullfile(folder,S(i).name);
            end
            %
        else
            if flag == 1,
                %
                listfile{i} = fullfile(folder,S(i).name);
                %
            elseif flag == 2,
                %
                ii = strfind(name,ext);
                %
                if isempty(ii) | ii ~= 1,continue;end
                %
                nf = nf+1;
                listfile{nf} = fullfile(folder,S(i).name);
                %
            elseif flag == 3,
                %
                [dummy,dummy,exteFile] = fileparts(name);
                %
                if strcmpi(exteFile,ext),
                    nf = nf+1;
                    listfile{nf} = fullfile(folder,S(i).name);
                end
                %
            elseif flag == 4,
                %
                [dummy,dummy,exteFile] = fileparts(name);
                %
                if isempty(exteFile),continue;end
                %
                if strmatch(lower(exteFile),ext,'exact'),
                    listfile{i} = fullfile(folder,S(i).name);
                end
                %
            end
        end
    end
    %
    if flag == 1 || flag == 4,
        %
        ind = find(cellfun('isempty',listdir));
        listdir(ind) = [];
        ind = find(cellfun('isempty',listfile));
        listfile(ind) = [];
        %
    elseif flag == 2 || flag == 3,
        %
        listdir(nd+1:end) = [];
        listfile(nf+1:end) = [];
        %
    end

return











