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
function angleInRadians = deg2rad(angleInDegrees)
% DEG2RAD Convert angles from degrees to radians.
%   DEG2RAD(X) converts angle units from degrees to radians for each
%   element of X.
%
%   See also RAD2DEG.
% Copyright 2015 The MathWorks, Inc.
%
% For use of this function with Matlab prior release R2015B because it was missing
%
if isfloat(angleInDegrees)
    angleInRadians = (pi/180) * angleInDegrees;
else
    error(message('MATLAB:deg2rad:nonFloatInput'))
end
