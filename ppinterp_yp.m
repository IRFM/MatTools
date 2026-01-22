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
function [pp] = ppinterp_yp(X,V, orig_size_v, method)
%
if ~strcmp(method,'csape')
    %
    %PPINTERP ppform interpretation.
    n = size(V,1);
    ds = 1;
    prodDs = 1;
    if ~isvector(V)
        ds = orig_size_v(2:end);
        prodDs = size(V,2);
    end
    

    switch method(1)
        case 'n' % nearest
            breaks = [X(1); ...
                (X(1:end-1)+X(2:end))/2; ...
                X(end)].';
            coefs = V.';
            pp = mkpp(breaks,coefs,ds);
        case 'l' % linear
            breaks = X.';
            page1 = (diff(V)./repmat(diff(X),[1, prodDs])).';
            page2 = (reshape(V(1:end-1,:),[n-1, prodDs])).';
            coefs = cat(3,page1,page2);
            pp = mkpp(breaks,coefs,ds);
        case 'm' % makima
            pp = makima(X.',reshape(V.',[ds, n]));
        case 'p' % pchip and cubic
            pp = pchip(X.',reshape(V.',[ds, n]));
        case 's' % spline
            pp = spline(X.',reshape(V.',[ds, n]));
        case 'c' % v5cubic
            b = diff(X);
            if norm(diff(b),Inf) <= eps(norm(X,Inf))
                % data are equally spaced
                a = repmat(b,[1 prodDs]).';
                yReorg = [3*V(1,:)-3*V(2,:)+V(3,:); ...
                    V; ...
                    3*V(n,:)-3*V(n-1,:)+V(n-2,:)];
                y1 = yReorg(1:end-3,:).';
                y2 = yReorg(2:end-2,:).';
                y3 = yReorg(3:end-1,:).';
                y4 = yReorg(4:end,:).';
                breaks = X.';
                page1 = (-y1+3*y2-3*y3+y4)./(2*a.^3);
                page2 = (2*y1-5*y2+4*y3-y4)./(2*a.^2);
                page3 = (-y1+y3)./(2*a);
                page4 = y2;
                coefs = cat(3,page1,page2,page3,page4);
                pp = mkpp(breaks,coefs,ds);
            else
                % data are not equally spaced
                pp = spline(X.',reshape(V.',[ds, n]));
            end
        otherwise
            error('Unknown interpolation method.');
    end
    %
    pp.orient = 'first';
else
    pp = csape(X,V0);
    pp.orient = 'first';
    disp(mode)
end


