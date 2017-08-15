function [pp, vv, bb, ss, rho_var, zz, xx, c1, s1] = shell ()

%   To do
%   Fix heating to conserve total input with variable sigma
%   Isolate scale factor error

T       = 2000;             %   secs. Heating cut-off time
Nc      = 30;               %   Number of contours in display
Scalar  = 10;                %   20 Mode scaling with height : after SDG remark
sigma   = 1;
f       = 0.0001;
N1      = 0.01;             %   Based on dry lapse rate of 10 deg per km (notes)
N2      = 0.01;
HL_bar  = 10;               %   Relative lid height
HV_bar  = 5.0;              %   relative visualisation height
Ht_bar  = 1.0;              %   relative heating height
mmax    = Scalar * HL_bar;  %   max number of modes scales with lid height
R_spec  = 8.314/28.0013E-3; %   SPECIFIC gas constant based upon nitrogen

[xx, zz, pp, vv, bb, ss, rho_var, dx, dz, x, c1, s1 ] = Harness2 ( HL_bar , HV_bar, Ht_bar, T, mmax, sigma, N1, f );
Q_0       = 10^3;

% Response fields
figure ( 10 )
subplot(3,1,1)
contourf(xx,zz,pp,Nc);
colorbar
grid on
x = sprintf('p(x,z) structure at steady state.');
title(x);
xlabel('x / L');
ylabel('z / H_t');
subplot(3,1,2)
contourf(xx,zz,bb,Nc);
colorbar
grid on
x = sprintf('b(x,z) at steady state. ');
title(x);
xlabel('x / FWHM');
ylabel('z / H_t');
subplot(3,1,3)
contourf(xx,zz,vv,Nc);
colorbar
grid on
x = sprintf('v(x,t) structure at steady state.');
title(x);
xlabel('x/ L');
ylabel('z / H_t');

return 

