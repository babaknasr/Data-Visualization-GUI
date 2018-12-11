% Convert free-stream velocity to shear velocity
% us = fit_free2shear(uf,ref,parameters,fluidproperty)
function us = fit_free2shear(varargin)
uf = varargin{1};
ref = varargin{2};
parameters = varargin{3};
if (nargin > 3)
    nu = varargin{4}(1);
else
    nu = 1.5e-05; % air
end %if
switch ref
    case {'Ibrahim(2003)','Schlichting(1979)'} % !!! It is not Schlichting(1979) !!!
        us = .0375.*uf + .0387;
    case 'Braaten(1994)'
        us = .0479 + .0256.*uf;
    case 'Davies(1972)'
        Dh = parameters(1);
        us = (nu./(Dh.*uf)).^(1/8) .* uf/5;
    case 'Dean(1978)'   %2D channel flow (when w/h>7)
        h = parameters(1);
        Re = uf*h/nu;
        us = uf.*sqrt(.0365./Re.^(1/4));
    case {'Blasius(1913)','Matsusaka(1996)'}  % Originally it's Blasius Eq.
        % 3e3 < Re < 1e5
        Dh = parameters(1);
        Re = uf*Dh/nu;
        Cf = .0791*Re.^(-1/4);
        us = uf.*sqrt(Cf/2);
%         us = (.0396*(nu/Dh)^(1/4)*uf^(7/4))^.5;
		
		
%----- Extra equations
    case 'Schlichting(1979)2'
        l = parameters(1);
%         l = 1;
        Re = uf.*l/nu;
        Cf = .0592.*Re.^(-1/5);
        us = uf.*(Cf./2).^.5;
    case 'Schlichting(1979)3'
        l = parameters(1);
%         l = 1;
        Re = uf.*l/nu;
        Cf = (2.*log10(Re) - .65).^(-2.3);
        us = uf.*(Cf./2).^.5;
    case 'Prandtl(1927)' %  5e5< Re <1e7
        l = parameters(1);
        Re = uf.*l/nu;
        Cf = .074.*Re.^(-1/5);
        us = uf.*(Cf./2).^.5;
        
end %switch
