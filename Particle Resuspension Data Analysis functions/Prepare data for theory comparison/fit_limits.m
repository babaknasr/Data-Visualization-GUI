function [mulimit, sigmalimit, mustep, sigmastep] = fit_limits(model,x,y)
nsteps = 200;
[x, indx] = sort(x);
y = y(indx);
switch model
    case {'gauss','Gauss','Gaussian','gaussian','log','Log','Lognormal','lognormal'}
        mu0 = x(find((abs(y-.5)) == min(abs(y-.5)),1));
        if (max(y) < .5) 
            mu0 = 25;
            sigmalimit = [.1, 50];
            mulimit = [(mu0-20), (mu0+20)];
        else
            pdfx(1) = y(1);
            sig = (x(1) - mu0)^2*pdfx(1);
            for i=2:length(y)
                %%%%%% Temporary change (Original: pdfx(i) = y(i) - y(i-1); );
%                 pdfx(i) = y(i) - y(i-1);
                pdfx(i) = abs(y(i) - y(i-1));
                sig = sig + (x(i) - mu0)^2*pdfx(i);
            end %i
            sigma0 = sqrt(sig);
            sigmalimit = [sigma0 - sigma0/2, sigma0 + sigma0/2];
            mulimit = [(mu0-sigma0), (mu0+sigma0)];
        end %if
        %%% use constant range for mu and sigma when the calculated one
        %%% does not work
% 		mulimit = [.01 3]
% 		sigmalimit = [.01 3]
        mustep = (mulimit(2) - mulimit(1))/nsteps;
        sigmastep = (sigmalimit(2) - sigmalimit(1))/nsteps;
    case {'Weibull','weibull'}
%         mu0 = x(find((abs(y-.5)) == min(abs(y-.5)),1));
%         if (max(y) < .5) 
%             mu0 = 25;
%             sigma0 = 10;
%             sigmalimit = [.5, 20];
%             mulimit = [(mu0-20), (mu0+20)];
%         else
%             pdfx(1) = y(1);
%             sig = (x(1) - mu0)^2*pdfx(1);
%             for i=2:length(y)
%                 pdfx(i) = y(i) - y(i-1);
%                 sig = sig + (x(i) - mu0)^2*pdfx(i);
%             end %i
%             sigma0 = sqrt(sig);
%             sigmalimit = [sigma0 - sigma0/2, sigma0 + sigma0/2];
%             mulimit = [(mu0-sigma0), (mu0+sigma0)];
%         end %if
%         syms lambda kk
%         [sol_lambda, sol_kk] = solve((lambda*gamma(1+1/kk) - mulimit(1)), (lambda^2*(gamma(1+2/kk)-(gamma(1+1/kk))^2) - sigmalimit(1)^2));
%         a0 = double(sol_lambda);
%         b0 = double(sol_kk);
%         [sol_lambda, sol_kk] = solve((lambda*gamma(1+1/kk) - mulimit(2)), (lambda^2*(gamma(1+2/kk)-(gamma(1+1/kk))^2) - sigmalimit(2)^2));
%         a1 = double(sol_lambda);
%         b1 = double(sol_kk);
%         mulimit = [a0, a1];
%         mulimit = sort(mulimit);
%         sigmalimit = [b0, b1];
%         sigmalimit = sort(sigmalimit);
        % Heare mu=a and sigma=b
        
        mulimit = [min(x), max(x)];
%         mulimit = [min(x)+(max(x)-min(x))/2, max(x)-(max(x)-min(x))/2];
% 		mulimits = [.1 50]
        sigmalimit = [.1, 50];
        mustep = (mulimit(2) - mulimit(1))/nsteps;
        sigmastep = (sigmalimit(2) - sigmalimit(1))/nsteps;
end %switch

