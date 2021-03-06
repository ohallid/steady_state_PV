% far-field vertical cross sections 

pi      = 3.1417;
g       = 9.81;

T       = 3600;             %   secs. Heating cut-off time
Nc      = 30;               %   Number of contours in display
Scalar  = 10;                %   20 Mode scaling with height : after SDG remark
sigma   = 1;
N1      = 0.01;             %   Based on dry lapse rate of 10 deg per km (notes)
%N2      = 0.01;
HV_bar  = 1.0;              %   relative visualisation height
Ht_bar  = 1.0;              %   relative heating height
%R_spec  = 8.314/28.0013E-3; %   SPECIFIC gas constant based upon nitrogen
theta_0 = 273;

%
%%%
%
HL_bar  = 1.0;               %   Relative lid height
HV_bar  = 1.0;
mmax    = Scalar * HL_bar;  %   max number of modes scales with lid height
f       = 0.0001;
[xx, zz, pp, vv, bb, ss, rho_var, dx, dz, x, c1, s1 ] = Harness2 ( HL_bar , HV_bar, Ht_bar, T, mmax, sigma, N1, f );
pp1_right = pp;
vv1_right = - vv;
bb1_right = bb;

pp1_left  = fliplr(pp); 
vv1_left  = fliplr(vv); 
bb1_left  = fliplr(bb); 

pp1_total = horzcat(pp1_left,pp1_right);
vv1_total = horzcat(vv1_left,vv1_right);
bb1_total = horzcat(bb1_left,bb1_right);

% calculate PV' from expression in paper.
z_trop  = [0:dx:Ht_bar];
[xx_trop,zz_trop] = meshgrid(x,z_trop); 
scaled_PV_trop = f * T * pi / Ht_bar / N1 / N1 .* exp( - xx_trop .* xx_trop ./ 2);
scaled_PV_trop = scaled_PV_trop .* cos( pi .* zz_trop ./ Ht_bar);

z_strat = [Ht_bar:dz:HL_bar];
[xx_strat,zz_strat] = meshgrid(x,z_strat); 
scaled_PV_strat = zz_strat;

scaled_PV = [scaled_PV_trop;scaled_PV_strat];
scaled_PV = scaled_PV_trop + 2 .* f .* bb1_right ./ g;

% format
PV1_right  = scaled_PV;
PV1_left   = fliplr(scaled_PV);
PV1_total  = horzcat(PV1_left,PV1_right);

% remove scaling
rho_var_right  = rho_var;
rho_var_left   = fliplr(rho_var);
rho_var_total  = horzcat(rho_var_left,rho_var_right); 
PV1_total      = rho_var_total .* PV1_total ./ theta_0;

%
%%%
%
HL_bar  = 15;               %   Relative lid height
HV_bar  = 2;
f       = 0.0001;
mmax    = Scalar * HL_bar;  %   max number of modes scales with lid height
[xx, zz, pp, vv, bb, ss, rho_var, dx, dz, x, c1, s1 ] = Harness2 ( HL_bar , HV_bar, Ht_bar, T, mmax, sigma, N1, f );
pp2_right = pp;
vv2_right = - vv;
bb2_right = bb;

pp2_left  = fliplr(pp); 
vv2_left  = fliplr(vv); 
bb2_left  = fliplr(bb); 

pp2_total = horzcat(pp2_left,pp2_right);
vv2_total = horzcat(vv2_left,vv2_right);
bb2_total = horzcat(bb2_left,bb2_right);

% calculate PV' from expression in paper.
z_trop  = [0:dx:Ht_bar];
[xx_trop,zz_trop] = meshgrid(x,z_trop); 
scaled_PV_trop = f * T * pi / Ht_bar / N1 / N1 .* exp( - xx_trop .* xx_trop ./ 2);
scaled_PV_trop = scaled_PV_trop .* cos( pi .* zz_trop ./ Ht_bar);

z_strat = [Ht_bar+dz:dz:HV_bar];
[xx_strat,zz_strat] = meshgrid(x,z_strat); 
scaled_PV_strat = zz_strat - zz_strat;

scaled_PV_2 = [scaled_PV_trop;scaled_PV_strat];
scaled_PV_2 = scaled_PV_2 + 2 .* f .* bb2_right ./ g;


% format
PV2_right  = scaled_PV_2;
PV2_left   = fliplr(scaled_PV_2);
PV2_total  = horzcat(PV2_left,PV2_right);

% remove scaling
rho_var_right  = rho_var;
rho_var_left   = fliplr(rho_var);
rho_var_total  = horzcat(rho_var_left,rho_var_right); 
PV2_total      = rho_var_total .* PV2_total ./ theta_0;

%
%%%
%




figure(1)
h(1) = subplot(4,1,1);
imagesc(pp1_total)
colormap(redblue(20))
set(gca,'ydir','normal')
ylim([0 200])
set(gca,'ytick',[0:50:200],'yticklabel',[0:5:20])
ylabel('z(km)')
set(gca,'xtick',[0:2500:10000],'xticklabel',[-500:250:500])
xlabel('x(km)')
%xlim([3000 7000])
caxis([-30 30])
grid on
text(1000, 150, 'p','backgroundcolor','w','edgecolor','k')


h(2) = subplot(4,1,2);
imagesc(vv1_total)
colormap(redblue(20))
set(gca,'ydir','normal')
ylim([0 200])
set(gca,'ytick',[0:50:200],'yticklabel',[0:5:20])
ylabel('z(km)')
set(gca,'xtick',[0:2500:10000],'xticklabel',[-500:250:500])
xlabel('x(km)')
%xlim([3000 7000])
caxis([-100 100])
grid on
text(1000, 150, 'v','backgroundcolor','w','edgecolor','k')


h(3) = subplot(4,1,3);
imagesc(bb1_total)
colormap(redblue(20))
set(gca,'ydir','normal')
ylim([0 200])
set(gca,'ytick',[0:50:200],'yticklabel',[0:5:20])
ylabel('z(km)')
set(gca,'xtick',[0:2500:10000],'xticklabel',[-500:250:500])
xlabel('x(km)')
%xlim([3000 7000])
caxis([-100 100])
grid on
text(1000, 150, 'b','backgroundcolor','w','edgecolor','k')


h(4) = subplot(4,1,4);
imagesc(PV1_total)
colormap(redblue(20))
set(gca,'ydir','normal')
ylim([0 200])
set(gca,'ytick',[0:50:200],'yticklabel',[0:5:20])
ylabel('z(km)')
set(gca,'xtick',[0:2500:10000],'xticklabel',[-500:250:500])
xlabel('x(km)')
%xlim([3000 7000])
caxis([-40 40])
grid on
text(1000, 150, 'PV','backgroundcolor','w','edgecolor','k')

%%%%

figure(2)
h(1) = subplot(4,2,1);
imagesc(pp1_total)
colormap(redblue(20))
set(gca,'ydir','normal')
ylim([0 200])
set(gca,'ytick',[0:50:200],'yticklabel',[0:5:20])
ylabel('z(km)')
set(gca,'xtick',[0:2500:10000],'xticklabel',[-500:250:500])
xlabel('x(km)')
%xlim([3000 7000])
caxis([-30 30])
grid on
text(1000, 150, 'p','backgroundcolor','w','edgecolor','k')


h(3) = subplot(4,2,3);
imagesc(vv1_total)
colormap(redblue(20))
set(gca,'ydir','normal')
ylim([0 200])
set(gca,'ytick',[0:50:200],'yticklabel',[0:5:20])
ylabel('z(km)')
set(gca,'xtick',[0:2500:10000],'xticklabel',[-500:250:500])
xlabel('x(km)')
%xlim([3000 7000])
caxis([-100 100])
grid on
text(1000, 150, 'v','backgroundcolor','w','edgecolor','k')


h(5) = subplot(4,2,5);
imagesc(bb1_total)
colormap(redblue(20))
set(gca,'ydir','normal')
ylim([0 200])
set(gca,'ytick',[0:50:200],'yticklabel',[0:5:20])
ylabel('z(km)')
set(gca,'xtick',[0:2500:10000],'xticklabel',[-500:250:500])
xlabel('x(km)')
%xlim([3000 7000])
caxis([-100 100])
grid on
text(1000, 150, 'b','backgroundcolor','w','edgecolor','k')


h(7) = subplot(4,2,7);
imagesc(PV1_total)
colormap(redblue(20))
set(gca,'ydir','normal')
ylim([0 200])
set(gca,'ytick',[0:50:200],'yticklabel',[0:5:20])
ylabel('z(km)')
set(gca,'xtick',[0:2500:10000],'xticklabel',[-500:250:500])
xlabel('x(km)')
%xlim([3000 7000])
caxis([-40 40])
grid on
text(1000, 150, 'PV','backgroundcolor','w','edgecolor','k')



h(2) = subplot(4,2,2);
imagesc(pp2_total / HL_bar )
colormap(redblue(20))
set(gca,'ydir','normal')
ylim([0 200])
set(gca,'ytick',[0:50:200],'yticklabel',[0:5:20])
ylabel('z(km)')
set(gca,'xtick',[0:2500:10000],'xticklabel',[-500:250:500])
xlabel('x(km)')
%xlim([3000 7000])
caxis([-30 30])
grid on
text(1000, 150, 'p','backgroundcolor','w','edgecolor','k')


h(4) = subplot(4,2,4);
imagesc(vv2_total / HL_bar)
colormap(redblue(20))
set(gca,'ydir','normal')
ylim([0 200])
set(gca,'ytick',[0:50:200],'yticklabel',[0:5:20])
ylabel('z(km)')
set(gca,'xtick',[0:2500:10000],'xticklabel',[-500:250:500])
xlabel('x(km)')
%xlim([3000 7000])
caxis([-100 100])
grid on
text(1000, 150, 'v','backgroundcolor','w','edgecolor','k')


h(6) = subplot(4,2,6);
imagesc(bb2_total / HL_bar)
colormap(redblue(20))
set(gca,'ydir','normal')
ylim([0 200])
set(gca,'ytick',[0:50:200],'yticklabel',[0:5:20])
ylabel('z(km)')
set(gca,'xtick',[0:2500:10000],'xticklabel',[-500:250:500])
xlabel('x(km)')
%xlim([3000 7000])
caxis([-100 100])
grid on
text(1000, 150, 'b','backgroundcolor','w','edgecolor','k')


h(8) = subplot(4,2,8);
imagesc(PV2_total)
colormap(redblue(20))
set(gca,'ydir','normal')
ylim([0 200])
set(gca,'ytick',[0:50:200],'yticklabel',[0:5:20])
ylabel('z(km)')
set(gca,'xtick',[0:2500:10000],'xticklabel',[-500:250:500])
xlabel('x(km)')
%xlim([3000 7000])
caxis([-40 40])
grid on
text(1000, 150, 'PV','backgroundcolor','w','edgecolor','k')

