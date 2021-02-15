% Esercizio 7.
% Per il processo dell'Esercizio 1, si progetti un regolatore con 
% retroazione di stato e osservatore che soddisfi le seguenti specifiche:
% 1) guadagno statico pari a 2;
% 2) Ta5=1.5s;
% 3) s%<=10%.
% Si verifichino le prestazioni utilizzando SIMULINK.
clear;close all;clc;

%tf_s=tf(20,[1 11 10 0]);  
 %sys_s=ss(tf_s);
% A=sys_s.a;B=sys_s.b;C=sys_s.c;D=sys_s.d;
 A=[0 1 0;0 0 1;0 -10 -11]';
 C=[0;0;1]';B=[20 0 0]';D=0;
sys_s=ss(A,B,C,D);
k_d=2;
zita=0.6;
wn=3/(zita*1.5);
a=-zita*wn;
b=wn*sqrt(1-zita^2);

lam_ds1=a+1i;
lam_ds2=lam_ds1';
lam_ds3=a*10;
lam_ds=[lam_ds1,lam_ds2,lam_ds3];

K=-acker(A,B,lam_ds);
sys_sc=ss(A+B*K,B,C,D);
k_F=dcgain(sys_sc);
k_w=k_d/k_F;
sys_sc_ff=ss(A+B*K,B*k_w,C,D);
step(sys_sc_ff);

%%% Osservatore
lam_o=a*10;
%    Scelgo gli autovalori dell'osservatore una decade più a sinistra degli
%    autovalori del sistema controllato.
H=-acker(A',C',[lam_o lam_o lam_o*10])';