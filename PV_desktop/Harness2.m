function [xx, zz, pp, vv, bb, ss, rho_var, dx, dz, x, c1, s1 ] = Harness2 ( HL_bar , HV_bar, Ht_bar, T, mmax, sigma, N1, f )

root2   = sqrt(2.0);
pi      = 3.141592653589793;
g       = 9.81;                              % ms^{-2}        
ratio   = Ht_bar / HL_bar;
scaleht1= g / N1 / N1 / 1e4;                 % units of Ht_bar
ratiop1 = Ht_bar  / scaleht1;
ratiopp1= scaleht1 / HL_bar;

i        = complex(0,1);
% dx       = 0.025;              % x-step
% dz       = 0.015;              % z-step
% x        = [0:dx:10 ];         % x = 10 equivalent to 10 * \sigma (FWHM, PB F(x) )
% z        = [0:dz:HV_bar ];

dx       = 0.01;               % x-step
dz       = 0.01;              % z-step
x        = [0:dx:50 ];         % x = 10 equivalent to 10 * \sigma (FWHM, PB F(x) )
z        = [0:dz:HV_bar ];
[xx,zz]  = meshgrid( x, z);

rhos1    = 1.0;
rho_vert = rhos1 * exp ( - z ./ scaleht1 );
rho_var  = rho_vert' * ones( size(x) );

m1       = [1:1:mmax];
c1       = ( m1 .* m1 * pi * pi / N1 / N1 + 0.25 / ratiopp1 / ratiopp1 ) .^ -0.5; % c_n_bar = ( c_n / HL_bar ) of document.
Hkn1    = ( N1 * N1 ./ c1 ./ c1 - 0.25 / ratiopp1 / ratiopp1 ) .^ 0.5;
phin    = atan ( 0.5 ./ Hkn1 / ratiopp1  );
A1      = root2 * sqrt( rhos1 ); % For all modes
           
% Heating coefficients
w1      = ( exp ( -i * Hkn1 * ratio - 0.5 * ratiop1 ) + 1 ) ./ ( i * pi / ratio - i * Hkn1 - 0.5 / ratiopp1 );
w2      = ( exp (  i * Hkn1 * ratio - 0.5 * ratiop1 ) + 1 ) ./ ( i * pi / ratio + i * Hkn1 - 0.5 / ratiopp1 );
s1      = 0.5 * c1 * A1 / N1 * exp ( - 0.5 * ratiop1 ) .* ( real (w1) - real (w2) );
s1      = HL_bar * s1; % compensate for dimensionless c1. 

% debugging : eigenspectrum and auxilliary variables
figure(20)
subplot(3,1,1)
scatter(m1,phin);
grid on
title('\phi_n.')
subplot(3,1,2);
scatter(m1,c1);
grid on
title('Eigenvalues : c_n.')
subplot(3,1,3);
scatter(m1,s1);
grid on
title('Co-efficients : \sigma_n.')
pause;

% Response fields
pp = M2p_Zn   (s1(1), HL_bar, c1(1), A1, x, z, T, f, Ht_bar, sigma, N1 );
vv = M2v_Zn   (s1(1), HL_bar, c1(1), A1, x, z, T, f, Ht_bar, sigma, N1 );
bb = M2b_dZndz(s1(1), HL_bar, c1(1), A1, x, z, T, f, Ht_bar, sigma, N1 );
ss = M2s_dZndz(s1(1), HL_bar, c1(1), A1, x, z, T, f, Ht_bar, sigma, N1 );
for mz = 2: mmax
    pp = pp + M2p_Zn   (s1(mz), HL_bar, c1(mz), A1, x, z, T, f, Ht_bar, sigma, N1 );
    vv = vv + M2v_Zn   (s1(mz), HL_bar, c1(mz), A1, x, z, T, f, Ht_bar, sigma, N1 );
    bb = bb + M2b_dZndz(s1(mz), HL_bar, c1(mz), A1, x, z, T, f, Ht_bar, sigma, N1 );
    ss = ss + M2s_dZndz(s1(mz), HL_bar, c1(mz), A1, x, z, T, f, Ht_bar, sigma, N1 );
    mz
end
ss = ss ./ rho_var;
vv = vv ./ rho_var;
bb = bb ./ rho_var;

% Reconstruct heating profile as check of closure of set of wave speed
figure(50)
plot(z,ss(:,1));
hold on
xlim([0 HV_bar]);
grid on;
title('Test : reconstructed heating function.');

return 