% Esercizio 8.
% Si risolva l?esercizio precedente mediante un regolatore e un osservatore 
% digitale, scegliendo un tempo di campionamento pari a 1/10 del tempo di 
% assestamento. Si verifichino le prestazioni utilizzando SIMULINK.
clear;close all;clc;

% tf_s=tf(20,[1 11 10 0]);  
%  sys_s=ss(tf_s);
% A=sys_s.a;B=sys_s.b;C=sys_s.c;D=sys_s.d;
% A=[0 1 0;0 0 1;0 -10 -11];
% B=[0;0;1];C=[20 0 0];D=0;
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


T=1.5/10;
sys_z=c2d(sys_s,T,'zoh');
Astar=sys_z.A;Bstar=sys_z.B;Cstar=sys_z.C;Dstar=sys_z.D;
lam_dz=exp(lam_ds*T);
Kstar=-acker(Astar,Bstar,lam_dz);
sys_zc=ss(Astar+Bstar*Kstar,Bstar,Cstar,Dstar,T);
k_Fstar=dcgain(sys_zc);
k_wstar=k_d/k_Fstar;
sys_zc_ff=ss(Astar+Bstar*Kstar,Bstar*k_wstar,Cstar,Dstar,T);
step(sys_zc_ff);


lam_o=a*10;
H=-acker(A',C',[lam_o lam_o lam_o*10])';

%%% Osservatore
lam_o=a*10;
lam_do=[lam_o lam_o lam_o*10];
lam_do_star=exp(lam_do*T);
%    Scelgo gli autovalori dell'osservatore una decade più a sinistra degli
%    autovalori del sistema controllato.
Hstar=-acker(Astar',Cstar',lam_do_star)';
