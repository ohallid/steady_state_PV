function [mm] = M2v_Zn(bm, HL_bar, c, A, x, z, T, f, Ht_bar, sigma, N1)
%
% For steady v field 
%
pi      = 3.141592653589793;
g       = 9.81;                            % ms^{-2}        
ratio   = Ht_bar / HL_bar;
scaleht1= g / N1 / N1 / 1e4;               % units of Ht_bar
ratiop1 = Ht_bar  / scaleht1;
ratiopp1= scaleht1 / HL_bar;

% x-variation
alpha_n              = f     * T * bm * sigma         *c / ( sigma * sigma * f * f - c * c );
beta_n               = f * f * T * bm * sigma * sigma    / ( sigma * sigma * f * f - c * c );
x_var                = - alpha_n * exp ( - f * abs(x) / c     ) ...
                       +  beta_n * exp ( -     abs(x) / sigma );
x_var                = diff ( x_var );
x_var(size(x_var)+1) = x_var ( size (x_var) );
x_var                = x_var / f;
           
% z_variation
Hkn1         = ( N1 * N1 / c / c - 0.25 / ratiopp1 / ratiopp1 ) .^ 0.5;
phin         = - atan ( 0.5 / Hkn1 / ratiopp1  );
Z            = A * cos ( Hkn1 * z / HL_bar + phin ) .* exp( - 0.5*z/scaleht1);
z_var        = Z';

% modal response 
mm           = z_var * x_var;

return 