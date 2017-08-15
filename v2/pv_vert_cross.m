% far-field vertical cross sections 


T       = 3600;             %   secs. Heating cut-off time
Nc      = 30;               %   Number of contours in display
Scalar  = 10;                %   20 Mode scaling with height : after SDG remark
sigma   = 1;
N1      = 0.01;             %   Based on dry lapse rate of 10 deg per km (notes)
%N2      = 0.01;
HL_bar  = 1.5;               %   Relative lid height
HV_bar  = 1.0;              %   relative visualisation height
Ht_bar  = 1.0;              %   relative heating height
mmax    = Scalar * HL_bar;  %   max number of modes scales with lid height
%R_spec  = 8.314/28.0013E-3; %   SPECIFIC gas constant based upon nitrogen

f       = 0.0001;
[xx, zz, pp, vv, bb, ss, rho_var, dx, dz, x, c1, s1 ] = Harness2 ( HL_bar , HV_bar, Ht_bar, T, mmax, sigma, N1, f );

figure(1)
h(1) = subplot(3,1,1)
imagesc(pp)
set(gca,'ydir','normal')
ylim([0 200])
xlim([3000 7000])
%caxis([-500 500])
grid on

h(2) = subplot(3,1,2)
imagesc(vv)
set(gca,'ydir','normal')
ylim([0 200])
xlim([3000 7000])
%caxis([-20000 20000])
grid on

h(3) = subplot(3,1,3)
imagesc(bb)
set(gca,'ydir','normal')
ylim([0 200])
xlim([3000 7000])
%caxis([-1500 1500])
grid on

%%%%
% 
% f       = 0.0001;
% [xx, zz, pp, vv, bb, ss, rho_var, dx, dz, x, c1, s1 ] = Harness2 ( HL_bar , HV_bar, Ht_bar, T, mmax, sigma, N1, f );
% 
% figure(2)
% h(1) = subplot(3,1,1)
% imagesc(pp)
% set(gca,'ydir','normal')
% ylim([0 200])
% xlim([3000 7000])
% caxis([-500 500])
% grid on
% 
% h(2) = subplot(3,1,2)
% imagesc(vv)
% set(gca,'ydir','normal')
% ylim([0 200])
% xlim([3000 7000])
% caxis([-20000 20000])
% grid on
% 
% h(3) = subplot(3,1,3)
% imagesc(bb)
% set(gca,'ydir','normal')
% ylim([0 200])
% xlim([3000 7000])
% caxis([-1500 1500])
% grid on
