function [mm] = M2b_dZndz(bm, HL_bar, c, A, x, z, T, f, Ht_bar, sigma, N1)
%
% For steady b field 
%
pi              = 3.141592653589793;
g               = 9.81;                            % ms^{-2}        
ratio           = Ht_bar / HL_bar;
scaleht1        = g / N1 / N1 / 1e4;               % units of Ht_bar
ratiop1         = Ht_bar  / scaleht1;
ratiopp1        = scaleht1 / HL_bar;

% x-variation
alpha_n            = f     * T * bm * sigma         *c / ( sigma * sigma * f * f - c * c );
beta_n             = f * f * T * bm * sigma * sigma    / ( sigma * sigma * f * f - c * c );
x_var              = - alpha_n * exp ( - f * abs(x) / c     ) ...
                     +  beta_n * exp ( -     abs(x) / sigma );             
% z_variation
Hkn1               = ( N1 * N1 / c / c - 0.25 / ratiopp1 / ratiopp1 )^ 0.5;
dZdz               = - A / HL_bar * N1 / c * exp ( - 0.5*z/scaleht1 ) .* sin ( Hkn1*z/HL_bar ) ;
z_var              = dZdz';

% modal response 
mm                 = z_var * x_var;

return 