function [] = UniaxialConcrete_new()

global fc;    % concrete compression strength           : mp(1)
global epsc0; % strain at compression strength          : mp(2)
global fcu;   % stress at ultimate (crushing) strain    : mp(3)
global epscu; % ultimate (crushing) strain              : mp(4)
global rat;   % ratio between unloading slope at epscu and original slope : mp(5)
global ft;    % concrete tensile strength               : mp(6)
global Ets;   % tension stiffening slope                : mp(7)

fc = -24e6;    % concrete compression strength           : mp(1)
epsc0 = -0.002; % strain at compression strength          : mp(2)
fcu = -4.0e6;   % stress at ultimate (crushing) strain    : mp(3)
epscu = -0.005; % ultimate (crushing) strain              : mp(4)
rat = 0.1;   % ratio between unloading slope at epscu and original slope : mp(5)
ft = 4e6;    % concrete tensile strength               : mp(6)
Ets = 20000;   % tension stiffening slope                : mp(7)

load("matlab.mat")

% init
ecminP = 0.0;
deptP = 0.0;
ecmin = 0.0;
dept = 0.0;

epsP = 0.0;
sigP = 0.0;
eps = 0.0;
sig = 0.0;

sigVec = [];

for strain = strainVec'
    deps = strain - epsP;
    [eps, sig, ecmin, dept] = setTrialStrain(deps, epsP, sigP, ecminP, deptP);
    % axis([-7e-3, 1e-3, -25, 4]);
    plot([epsP, eps], [sigP, sig], '-')
    hold on;
    %pause(0.05);
    epsP = eps;
    sigP = sig;
    ecminP = ecmin;
    deptP = dept;
    sigVec = [sigVec;sig];
end

end

function [eps, sig, ecmin, dept] = setTrialStrain(deps, in_eps, in_sig, in_ecmin, in_dept)

global fc;    % concrete compression strength           : mp(1)
global epsc0; % strain at compression strength          : mp(2)
global fcu;   % stress at ultimate (crushing) strain    : mp(3)
global epscu; % ultimate (crushing) strain              : mp(4)
global rat;   % ratio between unloading slope at epscu and original slope : mp(5)
global ft;    % concrete tensile strength               : mp(6)
global Ets;   % tension stiffening slope                : mp(7)

ec0 = fc * 2. / epsc0;

% if the current strain is less than the smallest previous strain
% call the monotonic envelope in compression and reset minimum strain

in_eps = in_eps + deps;

eps = in_eps;
sig = in_sig;
ecmin = in_ecmin;
dept = in_dept;

if (in_eps < in_ecmin)
    [sig, e] = Compr_Envlp(in_eps);
    ecmin = in_eps;
    dept = in_dept;
else
    
    % else, if the current strain is between the minimum strain and ept
    % (which corresponds to zero stress) the material is in the unloading-
    % reloading branch and the stress remains between sigmin and sigmax
    
    % calculate strain-stress coordinates of point R that determines
    % the reloading slope according to Fig.2.11 in EERC Report
    % (corresponding equations are 2.31 and 2.32
    % the strain of point R is epsR and the stress is sigmR
    
    epsr = (fcu - rat * ec0 * epscu) / (ec0 * (1.0 - rat));
    sigmr = ec0 * epsr;
    
    % calculate the previous minimum stress sigmm from the minimum
    % previous strain ecmin and the monotonic envelope in compression
    
    sigmm = 0;
    dumy = 0;
    
    [sigmm, dumy] = Compr_Envlp(in_ecmin);
    
    % calculate current reloading slope Er (Eq. 2.35 in EERC Report)
    % calculate the intersection of the current reloading slope Er
    % with the zero stress axis (variable ept) (Eq. 2.36 in EERC Report)
    
    er = (sigmm - sigmr) / (in_ecmin - epsr);
    ept = in_ecmin - sigmm / er;
    
    if in_eps <= ept
        sigmin = sigmm + er * (in_eps - in_ecmin);
        sigmax = er * 0.5 * (in_eps - ept);
        sig = in_sig + ec0 * deps;
        if sig <= sigmin
            sig = sigmin;
        end
        if sig >= sigmax
            sig = sigmax;
        end
    else
        % else, if the current strain is between ept and epn
        % (which corresponds to maximum remaining tensile strength)
        % the response corresponds to the reloading branch in tension
        % Since it is not saved, calculate the maximum remaining tensile
        % strength sicn (Eq. 2.43 in EERC Report)
        
        % calculate first the strain at the peak of the tensile stress-strain
        % relation epn (Eq. 2.42 in EERC Report)
        
        epn = ept + in_dept;
        sicn = 0;
        if (in_eps <= epn)
            [sicn, e] = Tens_Envlp(in_dept);
            if abs(in_dept) < 1e-15
                e = sicn / in_dept;
            else
                e = ec0;
            end
            sig = e * (in_eps - ept);
        else
            % else, if the current strain is larger than epn the response
            % corresponds to the tensile envelope curve shifted by ept
            dept = in_eps - ept;
        end
    end
end

end

function [sigc, Ect] = Tens_Envlp(epsc)

global fc;    % concrete compression strength           : mp(1)
global epsc0; % strain at compression strength          : mp(2)
global ft;    % concrete tensile strength               : mp(6)
global Ets;   % tension stiffening slope                : mp(7)

Ec0 = 2.0*fc / epsc0;
eps0 = ft / Ec0;
epsu = ft*(1.0 / Ets + 1.0 / Ec0);

if (epsc <= eps0)
    sigc = epsc*Ec0;
    Ect = Ec0;
else
    if (epsc <= epsu)
        Ect = - Ets;
        sigc = ft - Ets*(epsc - eps0);
    else
        %      Ect  = 0.0
        Ect = 1.0e-15;
        sigc = 0.0;
    end
end

end

function [sigc, Ect] = Compr_Envlp(epsc)

global fc;    % concrete compression strength           : mp(1)
global epsc0; % strain at compression strength          : mp(2)
global fcu;   % stress at ultimate (crushing) strain    : mp(3)
global epscu; % ultimate (crushing) strain              : mp(4)

Ec0 = 2.0*fc / epsc0;
ratLocal = epsc / epsc0;

if (epsc >= epsc0)
    sigc = fc*ratLocal*(2.0 - ratLocal);
    Ect = Ec0*(1.0 - ratLocal);
else
    %   linear descending branch between epsc0 and epscu
    if (epsc > epscu)
        sigc = (fcu - fc)*(epsc - epsc0) / (epscu - epsc0) + fc;
        Ect = (fcu - fc) / (epscu - epsc0);
    else
        % flat friction branch for strains larger than epscu
        sigc = fcu;
        Ect = 1.0e-10;
    end
end

end