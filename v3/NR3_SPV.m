function [ c1, Nfound ] = NR3_SPV(HL_bar , Ht_bar, mmax, N1, N2)

% Requires an estimate of the period of the cotangent term in the secular
% equation to be input by inspecting data : see parameter xmax

root2   = sqrt(2.0);
pi      = 3.141592653589793;
g       = 9.81;                              % ms^{-2}        
ratio   = Ht_bar / HL_bar;
scaleht1= g / N1 / N1 / 1e4;                 % units of Ht_bar
scaleht2= g / N2 / N2 / 1e4;
ratiop1 = Ht_bar  / scaleht1;
ratiop2 = Ht_bar  / scaleht2;
ratiopp1= scaleht1 / HL_bar;
ratiopp2= scaleht2 / HL_bar;

% xmin   = 0.5 / N2 / ratiopp2;
xmin   = max ( 0.5 / N2 / ratiopp2, 0.5 / N1 / ratiopp1 );

Deltax = pi / N1;                      % See document
xmax   = mmax * Deltax;                % No strict upper bound on x note. 
dx     = ( xmax - xmin ) / 5e6
x      = [xmin:dx:xmax];
N      = round( 5e6 );

% Seeding using parity criterion
Hkn        = ( N1 * N1 .* x .* x - 0.25 / ratiopp1 / ratiopp1 ) .^ 0.5;
Hknp       = ( N2 * N2 .* x .* x - 0.25 / ratiopp2 / ratiopp2 ) .^ 0.5;
phin       = atan  ( 2 * ratiopp1 * Hkn );
phinp      = atan( ( 2 * ratiopp2 * Hknp - tan( Hknp ) ) ./ ( 2 * ratiopp2 * Hknp .* tan( Hknp ) + 1 ) );
% phinp      = atan ( 2 * ratiopp2 * Hknp ) - Hknp;
fx         = N1 * N1 * Hknp ./ tan ( Hknp * ratio + phinp ) - N2 * N2 * Hkn ./ tan ( Hkn * ratio + phin )...
             - ( N1 * N1 * ratiopp1 - N2 * N2 * ratiopp2 ) / 2 / ratiopp1 / ratiopp2;
index      = 0;
% Hx1(index) = xmin;
for n=1:N
    if ( fx(n)*fx(n+1) < 0 ) && ( abs(fx(n)) < 5 / HL_bar ) && ( abs(fx(n+1)) < 5 / HL_bar ) 
        % Bisect interval
        [ x1p, x2p ] = Bisect_interval ( x(n), x(n+1), fx(n), fx(n+1), HL_bar, Ht_bar, N1, N2 );
        index        = index + 1;
        Hx1(index)   = 0.5 * (x1p + x2p);
        % Hx1(index)   = 0.5 * ( x(n) + x(n+1) );
    end
end

figure(1)
l  = length(Hx1);
y1 = zeros(l);
plot(x, fx );
xlabel('x H = H / c_n');
ylabel('f( x H )');
title('Secular equation with base state of density and N^2 variation showing soln.')
ylim([-0.1 0.1]);
xlim([xmin xmax])
hold on
plot(Hx1 ,y1,'c*');
grid on
pause;

% debugging 
% Nfound      = length(Hx1)+1;
% Hx1(Nfound) = 4.1727e+03
% c1      = 1 ./ Hx1;

Nfound    = length(Hx1);
c1        = 1 ./ Hx1;

return
