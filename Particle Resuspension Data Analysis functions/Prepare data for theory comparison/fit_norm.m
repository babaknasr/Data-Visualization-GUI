function [fitpar, error] = fit_norm(model,parameters)

x = parameters.x;
y = parameters.y;
fitname = '';
switch model
    case {'gauss','Gauss','Gaussian','gaussian'}
        fitname = 'Gaussian';
    case {'log','Log','Lognormal','lognormal'}
        fitname = 'Lognormal';
    case {'Weibull','weibull'}
        fitname = 'Weibull';
end %switch

mulimit = parameters.mulimit;
sigmalimit = parameters.sigmalimit;
% if (isfield(parameters,'mustep') == 0)
%     mustep = .5;
% else
%     mustep = parameters.mustep;
% end %if
% if (isfield(parameters,'sigmastep') == 0)
%     sigmastep = .5;
% else
%     sigmastep = parameters.sigmastep;
% end %if
mustep = parameters.mustep;
sigmastep = parameters.sigmastep;
[x, indx] = sort(x);
y = y(indx);
mu = mulimit(1):mustep:mulimit(2);
sigma = sigmalimit(1):sigmastep:sigmalimit(2);
xgrid = linspace(min(x),max(x),1000);
k = 0;
wb = waitbar(0,['Fitting Comulative ' fitname ' Distribution, Please wait...']);
for i=1:length(mu)
    for j=1:length(sigma)
        k = k + 1;
        switch model
            case {'gauss','Gauss','Gaussian','gaussian'}
                p(:,k) = normcdf(xgrid,mu(i),sigma(j));
                mu_sigma(1,k) = mu(i);
                mu_sigma(2,k) = sigma(j);
            case {'log','Log','Lognormal','lognormal'}
                mul = log(mu(i)^2/sqrt(mu(i)^2+sigma(j)^2));
                sigmal = sqrt(log(1+sigma(j)^2/mu(i)^2));
                p(:,k) = logncdf(xgrid,mul,sigmal);
                mu_sigma(1,k) = mul;
                mu_sigma(2,k) = sigmal;
            case {'Weibull','weibull'}
%                 syms lambda kk
%                 [sol_lambda, sol_kk] = solve((lambda*gamma(1+1/kk) - mu(i)), (lambda^2*(gamma(1+2/kk)-(gamma(1+1/kk))^2) - sigma(j)^2));
%                 a = double(sol_lambda)
%                 b = double(sol_kk)
%                 p(:,k) = wblcdf(xgrid,a,b);
%                 mu_sigma(1,k) = a;
%                 mu_sigma(2,k) = b;
                p(:,k) = wblcdf(xgrid,mu(i),sigma(j));
                mu_sigma(1,k) = mu(i);
                mu_sigma(2,k) = sigma(j);
        end %switch
        er = [];
        for l=1:length(y)
            er(l) = y(l) - interp1(xgrid,p(:,k),x(l));
        end %l
        er1(k) = sum(abs(er));
        er2(k) = norm(er);
        waitbar(k/(length(mu)*length(sigma)),wb);
    end %j    
end %i
delete(wb)

%-------
% figure
% for i=1:size(p,2)
%     hold on
%     plot(xgrid,p(:,i))
% end %i
% hold off
%-------

ind = find(er2 == min(er2),1);
fitpar(1) = mu_sigma(1,ind);
fitpar(2) = mu_sigma(2,ind);
error.norm1 = er1/k;
error.norm2 = er2/k;


