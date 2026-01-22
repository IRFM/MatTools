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
function [nPfiles,nOtherfiles] = make_pfiles(rootDir,targetDir0,copymode,rejectedDir,rejectedFile,otherFile)
%MatTools - Build (un)protected files from M-files. Clean the folder
%
% List all the files and directories recursively in a directory (with the full path)
% Clean the target folder from CVS, SVN, Git and hidden files (.*), but keep the
% subfolder structure of rootDir. Overwrite is always active. 
%
% INPUTS: 
%
%   - rootDir: absolute path to the root directory which contains m-files [string]
%       default = pwd;
%   - targetDir : absolute path to the target directory which contains p-files. If isempty, create by default a compressed folder only (overwrite active) named rootDir_compressed [string]
%       default = rooDir;
%   - copymode : copy mode which depends of targetDir too
%                (0): targetDir is identical to rootDir without CVS, SVN and hidden files only
%            (-1/+1): force an uncompressed folder with (m/p)-files
%            (-2/+2): force a compressed folder with (m/p)-files
%       default = 1;
%   - rejectedDir : List of rejected children directories [cell]
%       default = '';
%   - rejectedFile : List of rejected files [cell]
%       default = '';
%   - otherFile : List of other files to be transfered [cell]
%       default = '';
%
% OUTPUTS:
%
%   - nPfiles: number of protected files created (m-files or p-files) [1,1]
%   - nOtherfiles: number of other files transfered [1,1]
%
% EXAMPLE:
%
%  make_pfiles('MatRemote','MatRemote_distribution',0,{'private','php'},'',{'.sh','.plist'})
%  make_pfiles('MatRemote','',0,{'private','php'},'',{'.sh','.plist'})
%  make_pfiles('MatRemote','',1,'','cleanbridge',{'.sh','.plist'})
%  make_pfiles('MatRemote','',1,'',{'remote_ASIPP_SHENMA','bridgeurl','bridge.php'},{'.sh','.plist','.php'})
%  make_pfiles('MatRemote','',0,'',{'remote_ASIPP_SHENMA','bridgeurl','bridge.php'},{'.sh','.plist','.php'})
%
if nargin == 0,
        %
        rootDir = pwd;
        targetDir0 = '';
        copymode = 1;
        rejectedDir = '';
        rejectedFile = '';
        otherFile = '';
        %
    elseif nargin == 1,
        %
        targetDir0 = '';
        copymode = 1;
        rejectedDir = '';
        rejectedFile = '';
        otherFile = '';
        %
    elseif nargin == 2,
        %
        copymode = 1;
        rejectedDir = '';
        rejectedFile = '';
        otherFile = '';
        %
    elseif nargin == 3,
        %
        rejectedDir = '';
        rejectedFile = '';
        otherFile = '';
        %
    elseif nargin == 4,
        %
        rejectedFile = '';
        otherFile = '';
        %
    elseif nargin == 5,
        %
        otherFile = '';
        %
    end
    %
    if isempty(rootDir),
        rootDir = pwd;
    else
        if ~exist(rootDir,'dir'),
            error('The path to the root folder is wrong')
        end  
    end
    %
    if strcmp(rootDir,pwd),
        ifilesep = strfind(rootDir,filesep);
        dirinit = rootDir(1:ifilesep(end));
    else
        dirinit = pwd;
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
    if copymode == 0,
        rejectedDir = {};
        rejectedFile = {};
        otherFile = '';
        disp(['Warning: copymode = 0, all extra options are disabled. Mirror copy of ''',rootDir,''' directory without CVS, SVN and hidden files (.git, ...).'])
    end
    %
    cd(dirinit);
    %
    [dummy,listDir] = get_all_filesname_yp(rootDir,'.m');
    %
    if abs(copymode) == 2,
        dirmode = ' compressed ';
        cmpmode = '.gz';
    else
        dirmode = ' ';
        cmpmode = '';
    end
    %
    if strcmp(targetDir0,'.') || strcmp(targetDir0,'..'),
        disp(['Warning: The name of the target directory must be explicitly given or empty (no ''.'' or ''..'').'])
        disp(['Warning: The',dirmode,'target directory is named ''',rootDir,'_protected',cmpmode,'''.'])
        targetDir0 = [rootDir,'_protected'];
    elseif isempty(targetDir0),
         disp(['Warning: The',dirmode,'target directory is named ''',rootDir,'_protected',cmpmode,'''.'])
         targetDir0 = [rootDir,'_protected'];
    elseif strcmp(rootDir,targetDir0),
         disp(['Warning: The',dirmode,'target directory is named ''',rootDir,'_protected',cmpmode,'''.'])
         targetDir0 = [rootDir,'_protected'];
    end
    %   
    iselectDir = 1;
    %
    targetDir = tempname(pwd);
    %
    while exist(targetDir,'dir'),
        targetDir = tempname(pwd);
    end
    %
    mkdir(targetDir);
    %
    listselectedchildrenDir = '';
    %
    for ii = 2:length(listDir),
        childrenTargetDir = [targetDir,'/',listDir{ii}(length(listDir{1})+2:end)];
        if isempty(strfind(childrenTargetDir,'CVS')) && ~strcmp(childrenTargetDir(1),'.'),%remove CVS and SVN directories, as well as all hidden directories for distribution (.git, ...)
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
    %
    nPfiles = 0;
    nOtherfiles = 0;
    %
    nPfiles = p_encode(dirinit,rootDir,targetDir,rejectedFile,copymode,nPfiles);
    %
    nOtherfiles = transfer(dirinit,rootDir,targetDir,rejectedFile,otherFile,nOtherfiles);
    %
    for ii = 1:length(listselectedchildrenDir),
        %
        childrenTargetDir = [targetDir,'/',listselectedchildrenDir{ii}];
        childrenRootDir = [rootDir,'/',listselectedchildrenDir{ii}];
        %
        nPfiles = p_encode(dirinit,childrenRootDir,childrenTargetDir,rejectedFile,copymode,nPfiles);
        %
        nOtherfiles = transfer(dirinit,childrenRootDir,childrenTargetDir,rejectedFile,otherFile,nOtherfiles);
    end
    %
    cd(dirinit);
    %
    if abs(copymode) <= 1,%uncompressed folder case
        %
        if ~exist(targetDir0),
            %
            deleteemptysubfolder(targetDir);
            %
            movefile(targetDir,targetDir0)
        else
            %
            [listFile0,listDir0] = get_all_filesname_yp(targetDir0);
            [listFile,listDir] = get_all_filesname_yp(targetDir);
            %
            checksubfolderconsistency(targetDir0,listDir0,targetDir,listDir);
            %
            for ilistFile = 1:length(listFile),
                fname = listFile{ilistFile}(length(targetDir)+1:end);
                copyfile(listFile{ilistFile},[targetDir0,fname])
            end
            %
            for ilistFile0 = 1:length(listFile0),
                fname0 = listFile0{ilistFile0}(length(targetDir0)+1:end);
                if ~exist([targetDir,fname0],'file'),
                    if exist(listFile0{ilistFile0},'file'),
                        delete([targetDir0,fname0]);
                    end
                end
            end            
            %
            deleteemptysubfolder(targetDir0);
            %
            rmdir(targetDir,'s');%clear tmp folder
            %
        end
        %
    elseif abs(copymode) == 2,%tar folder for backup or transfer
        %
        tar([targetDir0,'.gz'],targetDir);
        rmdir(targetDir,'s');%clear tmp folder
        %
    end
    %
    cd(dirinit);   
    %
end
%
function [nPfiles] = p_encode(dirinit,rootDir,targetDir,rejectedFile,copymode,nPfiles)
    %
    cd(dirinit);
    %
    [listMfile,dummy] = get_all_filesname_yp(rootDir,'.m',0);
    %
    cd(targetDir);
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
            %
           % if strcmp(listMfile{ii},'MatRemote/Bridge/bridge2remote.m'),keyboard,end
            if copymode > 0,
                pcode(listMfile{ii});
            else
                cd(dirinit);
                copyfile(listMfile{ii},targetDir);
            end
            %
            nPfiles = nPfiles + 1;
        end        
    end
end
%
function [nOtherfiles] = transfer(dirinit,rootDir,targetDir,rejectedFile,otherFile,nOtherfiles)
    %
    cd(dirinit);
    %
    if length(otherFile) > 0,
        [listOtherfile,dummy] = get_all_filesname_yp(rootDir,otherFile,0);
    else
        if iscell(otherFile),
            return;
        else
            [listOtherfile,dummy] = get_all_filesname_yp(rootDir,otherFile,0);
        end
    end
    %
    cd(targetDir);
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
            cd(dirinit);
            if ~strcmp(listOtherfile{ii},'.')
                copyfile(listOtherfile{ii},targetDir);
                nOtherfiles = nOtherfiles + 1;
            end
            %
        end
    end
end
%
function [listselectedchildrenDir] = deleteemptysubfolder(targetDir)
    %
    listselectedchildrenDirNew = '';
    %
    [dummy,listDir] = get_all_filesname_yp(targetDir);
    listselectedchildrenDir = listDir(2:end);
    %
    while 1,%clean empty subfolders in targetDir
        %
        jj = 1;
        %
        for ii = 1:length(listselectedchildrenDir),
            %
            childrenTargetDir = listselectedchildrenDir{ii};
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
end
%
function [listselectedchildrenDir] = checksubfolderconsistency(targetDir0,listDir0,targetDir,listDir)
    %
    for ilistDir = 2:length(listDir),
        dirname = listDir{ilistDir}(length(targetDir)+1:end);
        %
        if ~exist([targetDir0,dirname],'dir')
            mkdir([targetDir0,dirname]);
        end
        %
    end
    %
end
