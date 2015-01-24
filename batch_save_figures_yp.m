function [] = batch_save_figures_yp(folder,subfolder,figtype)
% MatTools - Batch save all open figures in a given folder at a given file format
%
% Batch save all open figures in a given folder at a given file format
%
% Input
%   - folder: main folder name where subfolders are placed [string]
%   - subfolder: sub folder name where the figures are placed [string]
%   - figtype: jpg, png, tiff
%
% Output: none
%
% By Yves Peysson (CEA-DRFC, yves.peysson@cea.fr) and Joan Decker (CEA-DRFC, joan.decker@epfl.ch)
%
if ~exist(folder), mkdir(folder);end
if ~exist([folder,'/',subfolder]), mkdir([folder,'/',subfolder]);end
h = findobj('type','figure');% find the handles of the opened figures
for k=1:numel(h),
  filename = ['fig_',int2str(k),'_',strrep(strrep(strrep(h(k).Name,' ',''),'\',''),'/','_p_'),'.',figtype];
  file = fullfile(folder,subfolder,filename);
  saveas(h(k),file)
end