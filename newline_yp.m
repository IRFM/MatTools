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
function a = newline_yp
%
% newline function for old matlab before R2016b
%
[matlab_version,matlab_release,flag_toolbox] = matversion_yp;
%
if ~strcmp(matlab_release,'R2016b')
    %
    year_release = str2num(matlab_release(2:end-1));
    %
    if year_release < 2016
        %
        a = char(10);
        %
    elseif year_release == 2016 %R2016a
        %
        a = char(10);
        %
    elseif year_release > 2016
        %
        a = newline;
        %
    end
    %
else
    %
    a = newline;
    %
end

  











end