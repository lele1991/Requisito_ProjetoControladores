%%
clc; clear;
zeta = 0.5;
T = 0.2;
Ts = 2;

wn = 4/(Ts*zeta);
wd = wn*sqrt(1-zeta^2);
ws = 2*pi/T;
wswd = ws/wd;

modz = exp(-T*zeta*wn);
angz = 2*pi/wswd;           %rad
%polo dominante de malha fechada
z1 = (exp(-T*(zeta*wn + 1i*wd)))';
realz1 = real(z1);
imagz1 = imag(z1);

%% malha
gs = tf(1,[1 2 0]);
hs = tf(1);
gz = c2d(gs,T);
gzh = c2d(gs*hs,T);
polos = pole(gzh);
zeros = zero(gzh);

%% angulo
a = rad2deg(angle(z1 - zeros));
b = rad2deg(angle(z1 - polos(1)));
c = rad2deg(angle(z1 - polos(2)));
soma = a - b - c + 180;

%% cancelar o p�lo em 0.6703
beta_a =  soma + rad2deg(angle(+z1 + polos(2)));           
beta = -deg2rad(beta_a)*imag(z1);
alfa = polos(2);

%% K
gd = tf([1 -alfa], [1 -beta], T);          % polo cancelado/polo para compensar angulo
gftma = minreal(gd*gz);

syms z;
z = real(z1) + imag(z1)*1i;
k = 1/abs((0.01758*z + 0.01539)/(z^2 - 1.235*z + 0.2347));        % Substituir z em G
gd = gd*k;

ftmf = minreal(gd*gz/(1+gd*gz));
roots([1 -1.007 0.4339]);
figure(1)
step(ftmf)
stepinfo(ftmf)
figure(2)
rlocus(ftmf)
%%
syms z
z = realz1 + 1i*imagz1
f = (0.01758*z + 0.01539)/(z^2 - 1.67*z + 0.6703);
fz = subs(f, z);
teta = 180 - vpa(360-(angle(fz)*180/pi))
