function [pr, prvar] = theory_property()

prop = {'[Particle] Young Modulus (Pa)',                  'E1',           [];
        '[Particle] Poisson Ratio',                       'nu1',          [];
        '[Particle] Density (kg/m3)',                     'rho_p',        [];
        '[Substrate] Young Modulus (Pa)',                 'E2',           [];
        '[Substrate] Poisson Ratio',                      'nu2',          [];
        '[Contact] Surface Energy (J/m2)',                'Wa',           [];
        '[Contact] Hamaker Constant (J)',                 'A',            [];
        '[Contact] Minimum Separation Distance z0 (m)',   'z0',        4e-10;
        '[Contact] Static Friction Coefficient',          'mus',          [];
        '[Medium] Temperature (K)',                       'T',           298;
        '[Medium] Density {std. cond.} (kg/m3)',          'rho',       1.225;
        '[Medium] Dynamic Viscosity {std. cond.} (Pa.s)', 'mu',      1.79e-5;
        '[Medium] Gas mean-free path {std. cond.} (m)',   'lambda',  .066e-6};

pr = {};
prvar = {};
for i=1:size(prop,1)
    pr{i,1} = true;
    pr{i,2} = prop{i,1};
    pr{i,3} = prop{i,3};
    prvar{i} = prop{i,2};
end %i
