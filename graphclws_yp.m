function [cp,lp,wp,sp] = graphclws_yp(mode,jj)
%
% For varying plot type between color (c), line (l), line width(w) and symbols (s). In the
% function, there is 4 colors, 4 lines, and 5 symbols including 'none'. Can
% be used directly in graph1d_jd.m
%
% input: 
%
%   - mode: output order, 'clws' or any order between c, l and s letters. 
%   (default = 'clws')
%   - jj: increment [1]
%   (default = 1)
%
% Output:
%
%   cp: color or line or symbol or width depending of mode (default color)
%   lp: color or line or symbol or width depending of mode (default line)
%   wp: color or line or symbol or width depending of mode (default line width)
%   sp: color or line or symbol or width depending of mode (default symbol)
%
% by Yves Peysson (CEA/IRFM) (yves.peysson@cea.fr) and Joan Decker (EPFL/SPC) (joan.decker @epfl.ch)%
%
%jj
if nargin == 0,
    mode = 'clws';
    jj = 1;
end
%
if nargin == 1,
    jj = 1;
end
%
if strcmp(mode,'clws'),
    cplot = {'r','k','b','g'};
    lplot = {'-',':','--',':'};
    wplot = {0.5,2};
    splot = {'none','+','x','o','*'};
end
%
if strcmp(mode,'sclw'),
    cplot = {'none','+','x','o','*'};
    lplot = {'r','k','b','g'};
    wplot = {'-',':','--',':'};
    splot = {0.5,2};
end
%
if strcmp(mode,'wscl'),
    cplot = {0.5,2};
    lplot = {'none','+','x','o','*'};
    wplot = {'r','k','b','g'};
    splot = {'-',':','--',':'};
end
%
if strcmp(mode,'lwsc'),
    cplot = {'-',':','--',':'};
    lplot = {0.5,2};
    wplot = {'none','+','x','o','*'};
    splot = {'r','k','b','g'};
end
%
if strcmp(mode,'lcws'),
    cplot = {'-',':','--',':'};
    lplot = {'r','k','b','g'};
    wplot = {0.5,2};
    splot = {'none','+','x','o','*'};
end
%
if strcmp(mode,'slcw'),
    cplot = {'none','+','x','o','*'};
    lplot = {'-',':','--',':'};
    wplot = {'r','k','b','g'};
    splot = {0.5,2};
end
%
if strcmp(mode,'wslc'),
    cplot = {0.5,2};
    lplot = {'none','+','x','o','*'};
    wplot = {'-',':','--',':'};
    splot = {'r','k','b','g'};
end
%
if strcmp(mode,'cwsl'),
    cplot = {'r','k','b','g'};
    lplot = {0.5,2};
    wplot = {'none','+','x','o','*'};
    splot = {'-',':','--',':'};
end
%
if strcmp(mode,'cwls'),
    cplot = {'r','k','b','g'};
    lplot = {0.5,2};
    wplot = {'-',':','--',':'};
    splot = {'none','+','x','o','*'};
end
%
if strcmp(mode,'scwl'),
    cplot = {'none','+','x','o','*'};
    lplot = {'r','k','b','g'};
    wplot = {0.5,2};
    splot = {'-',':','--',':'};
end
%
if strcmp(mode,'lscw'),
    cplot = {'-',':','--',':'};
    lplot = {'none','+','x','o','*'};
    wplot = {'r','k','b','g'};
    splot = {0.5,2};
end
%
if strcmp(mode,'wlsc'),
    cplot = {0.5,2};
    lplot = {'-',':','--',':'};
    wplot = {'none','+','x','o','*'};
    splot = {'r','k','b','g'};
end
%
if strcmp(mode,'clsw'),
    cplot = {'r','k','b','g'};
    lplot = {'-',':','--',':'};
    wplot = {'none','+','x','o','*'};
    splot = {0.5,2};
end
%
if strcmp(mode,'wcls'),
    cplot = {0.5,2};
    lplot = {'r','k','b','g'};
    wplot = {'-',':','--',':'};
    splot = {'none','+','x','o','*'};
end
%
if strcmp(mode,'swcl'),
    cplot = {'none','+','x','o','*'};
    lplot = {0.5,2};
    wplot = {'r','k','b','g'};
    splot = {'-',':','--',':'};
end
%
if strcmp(mode,'lswc'),
    cplot = {'-',':','--',':'};
    lplot = {'none','+','x','o','*'};
    wplot = {0.5,2};
    splot = {'r','k','b','g'};
end
%
nc = mod(jj-1,length(cplot))+1;%color
nl = mod((jj-mod(jj-1,length(cplot))-1)/length(cplot)+1-1,length(lplot))+1;%line
nw = mod((jj-mod(jj-1,length(cplot)*length(lplot))-1)/length(cplot)/length(lplot)+1-1,length(wplot))+1;%width
ns = mod((jj-mod(jj-1,length(cplot)*length(lplot)*length(wplot))-1)/length(cplot)/length(lplot)/length(wplot)+1-1,length(splot))+1;%symbol
%
cp = cplot{nc};
lp = lplot{nl};
wp = wplot{ns};
sp = splot{nw};
