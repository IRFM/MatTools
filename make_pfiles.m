function [nPfiles,nOtherfiles] = make_pfiles(rootDir,targetDir,tarmode,rejectedDir,rejectedFile,otherFile)
%MatTools - Build protected files from M-files
%
% List all the files and directories recursively in a directory (with the full path)
%
% INPUTS: 
%
%   - rootDir: path to the root directory which contains m-files [string]
%       default = pwd;
%   - targetDir : path to the target directory which contains p-files [string]
%       default = rooDir;
%   - tarmode : if 1, tar the folder which contains p-files. The tar file has the name of the target directory [1,1]
%       default = 0;
%   - rejectedDir : List of rejected children directories [cell]
%       default = '';
%   - rejectedFile : List of rejected files [cell]
%       default = '';
%   - otherFile : List of other files to be transfered [cell]
%       default = '';
%
% OUTPUTS:
%
%   - nPfiles: number of protected files created [1,1]
%   - nOtherfiles: number of other files transfered [1,1]
%
% EXAMPLE:
%
%  make_pfiles('MatRemote','',1,{'private','php'},'',{'.sh','.plist'})
%  make_pfiles('MatRemote','',1,'','cleanbridge',{'.sh','.plist'})
%  make_pfiles('MatRemote','',1,'',{'remote_ASIPP_SHENMA','bridgeurl','bridge.php'},{'.sh','.plist','.php'})
%
if nargin == 0,
    %
    rootDir = pwd;
    targetDir = rootDir;
    tarmode = 0;
    rejectedDir = '';
    rejectedFile = '';
    otherFile = '';
    %
elseif nargin == 1,
    %
    targetDir = rootDir;
    tarmode = 0;
    rejectedDir = '';
    rejectedFile = '';
    otherFile = '';
    %
elseif nargin == 2,
    tarmode = 0;
    rejectedDir = '';
    rejectedFile = '';
    otherFile = '';
    %
elseif nargin == 3,
    rejectedDir = '';
    rejectedFile = '';
    otherFile = '';
    %
elseif nargin == 4,
    rejectedFile = '';
    otherFile = '';
    %
elseif nargin == 5,
    otherFile = '';
    %
end
%
if ~isempty(rejectedDir) && ~iscell(rejectedDir),
    rejectedDir = {rejectedDir};
end
%
if ~isempty(rejectedFile) && ~iscell(rejectedFile),
    rejectedFile = {rejectedFile};
end
%
if ~isempty(otherFile) && ~iscell(otherFile),
    otherFile = {otherFile};
end
%
dirinit = pwd;
%
[dummy,listDir] = get_all_filesname_yp(rootDir,'.m');
%
if strcmp(targetDir,'.') || strcmp(targetDir,'..'),
    error(['Error: The name of the target directory must be explicitly given (no ''.'' or ''..'').'])
elseif isempty(targetDir),
     targetDir = [rootDir,'_protected'];
     disp(['Warning: The target directory is named ''',rootDir,'''_protected.'])
elseif strcmp(rootDir,targetDir),
     targetDir = [rootDir,'_protected'];
     disp(['Warning: The target directory is named ''',rootDir,'''_protected.'])
end
%   
iselectDir = 1;
%
if ~exist(targetDir,'dir'),%build the directory tree structure in targetDir
	mkdir(targetDir);
    %
    for ii = 2:length(listDir),
        childrenTargetDir = [targetDir,'/',listDir{ii}(length(listDir{1})+2:end)];
        if isempty(strfind(childrenTargetDir,'CVS')) && ~strcmp(childrenTargetDir(1),'.'),%remove CVS and SVN directories, as well as all hidden directories for distribution
            %
            flagchildrenTargetDir = 1;
            %
            for irejectedDir = 1:length(rejectedDir),
                if ~isempty(strfind(childrenTargetDir,rejectedDir{irejectedDir})),
                    flagchildrenTargetDir = 0;
                    break;
                end
            end
            %        
            if flagchildrenTargetDir,    
                mkdir(childrenTargetDir);
                listselectedchildrenDir{iselectDir} = [listDir{ii}(length(listDir{1})+2:end)];
                iselectDir = iselectDir + 1;
            end
        end
    end
else
    error(['Error: The target directory ''',targetDir,''' already exists.'])
end
%
cd(dirinit);
%
nPfiles = 0;
nOtherfiles = 0;
%
[listMfile,dummy] = get_all_filesname_yp(rootDir,'.m',0);
%
if length(otherFile) > 0,
    [listOtherfile,dummy] = get_all_filesname_yp(rootDir,otherFile,0);
end
%
cd(targetDir)
%
for ii = 1:length(listMfile),
    %
    flagMfile = 1; 
    %
    for irejectedFile = 1:length(rejectedFile),
        if ~isempty(strfind(listMfile{ii},rejectedFile{irejectedFile})),
            flagMfile = 0;
            break;
        end
    end
    %        
    if flagMfile,   
        pcode(listMfile{ii});
        nPfiles = nPfiles + 1;
    end        
end
%
cd(dirinit);
%
for ii = 1:length(listOtherfile),
    flagOtherfile = 1; 
    %
    for irejectedFile = 1:length(rejectedFile),
        if ~isempty(strfind(listOtherfile{ii},rejectedFile{irejectedFile})),
            flagOtherfile = 0;
            break;
        end
    end
    %        
    if flagOtherfile,   
        %
        copyfile(listOtherfile{ii},targetDir);
        nOtherfiles = nOtherfiles + 1;
        %
    end
end
%
for ii = 1:length(listselectedchildrenDir),
    %
    cd(dirinit);
    %
    childrenTargetDir = [targetDir,'/',listselectedchildrenDir{ii}];
    childrenRootDir = [rootDir,'/',listselectedchildrenDir{ii}];
    %
    [listMfile,dummy] = get_all_filesname_yp(childrenRootDir,'.m',0);
    %
    if length(otherFile) > 0,
        [listOtherfile,dummy] = get_all_filesname_yp(childrenRootDir,otherFile,0);
    end
    %
    cd(childrenTargetDir);
    %
    for ii = 1:length(listMfile),
        %
        flagMfile = 1; 
        %
        for irejectedFile = 1:length(rejectedFile),
            if ~isempty(strfind(listMfile{ii},rejectedFile{irejectedFile})),
                flagMfile = 0;
                break;
            end
        end
        %        
        if flagMfile,   
            pcode(listMfile{ii});
            nPfiles = nPfiles + 1;
        end        
    end
    %
    cd(dirinit);
    %
    for ii = 1:length(listOtherfile),
        %
        flagOtherfile = 1; 
        %
        for irejectedFile = 1:length(rejectedFile),
            if ~isempty(strfind(listOtherfile{ii},rejectedFile{irejectedFile})),
                flagOtherfile = 0;
                break;
            end
        end
        %        
        if flagOtherfile,   
            %
            copyfile(listOtherfile{ii},childrenTargetDir);
            nOtherfiles = nOtherfiles + 1;
            %
        end
    end
end
%
cd(dirinit);
%
while 1,%clean empty folders
    %
    jj = 1;
    %
    for ii = 1:length(listselectedchildrenDir),
        %
        childrenTargetDir = [targetDir,'/',listselectedchildrenDir{ii}];
        %
        if isempty(ls(childrenTargetDir)),
            rmdir(childrenTargetDir);
        else
            listselectedchildrenDirNew{jj} = listselectedchildrenDir{ii};
            jj = jj + 1;
        end
        %  
    end
    %
    if length(listselectedchildrenDirNew) == length(listselectedchildrenDir),
        break;
    else
        listselectedchildrenDir = listselectedchildrenDirNew;
        clear listselectedchildrenDirNew;
    end
end
%
if tarmode,%gzip folder for backup or transfer
    tar([targetDir,'.gz'],targetDir);
end
%
cd(dirinit);%clear protected folder
rmdir(targetDir,'s');

