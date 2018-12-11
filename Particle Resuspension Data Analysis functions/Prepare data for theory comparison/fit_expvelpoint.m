function [uth, uthd, uthu] = fit_expvelpoint(method,par)
c = .5;
u = .75;
l = .25;

switch method
    case 'Gaussian'
        uth = norminv(c,par(1),par(2));
        uthd = norminv(l,par(1),par(2));
        uthu = norminv(u,par(1),par(2));        
    case 'Lognormal'
        uth = logninv(c,par(1),par(2));
        uthd = logninv(l,par(1),par(2));
        uthu = logninv(u,par(1),par(2));
    case 'Weibull'
        uth = wblinv(c,par(1),par(2));
        uthd = wblinv(l,par(1),par(2));
        uthu = wblinv(u,par(1),par(2));
end %switch
% ler = uth - uthd;
% uer = uthu - uth;
