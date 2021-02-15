% Esercizio 3.
% Per il processo dell’Esercizio 1, si progetti un regolatore digitale con 
% retroazione di stato e assegnamento del guadagno che soddisfi le seguenti 
% specifiche:
% 1) guadagno statico pari a 2;
% 2) Ta5=0.5 s;
% 3) s% <= 10%.
% Si utilizzi uno schema di controllo privo di azione integrale scegliendo 
% un tempo di campionamento
% pari a 1/+20 del tempo di assestamento.
clear;close all;clc;

tf_s=tf(20,[1 11 10 0]);  
sys_s=ss(tf_s);
A=sys_s.a;B=sys_s.b;C=sys_s.c;D=sys_s.d;
k_d=2;
zita=0.7;
wn=3/(zita*0.5);
a=-zita*wn;
b=wn*sqrt(1-zita^2);

lam_ds1=a+1i;
lam_ds2=lam_ds1';
lam_ds3=a*10;
lam_ds=[lam_ds1,lam_ds2,lam_ds3];

 % Se lo volessimo fare in continua:
K=-acker(A,B,lam_ds);
sys_sc=ss(A+B*K,B,C,D);
k_F=dcgain(sys_sc);
k_w=k_d/k_F;
sys_sc_ff=ss(A+B*K,B*k_w,C,D);
subplot(1,2,1);step(sys_sc_ff);

%   Inizio digitale:
T=0.5/20;
sys_z=c2d(sys_s,T,'zoh');
Astar=sys_z.A;Bstar=sys_z.B;Cstar=sys_z.C;Dstar=sys_z.d;
lam_dz=exp(lam_ds*T);
Kstar=-acker(Astar,Bstar,lam_dz);
sys_zc=ss(Astar+Bstar*Kstar,Bstar,Cstar,Dstar,T);
k_Fstar=dcgain(sys_zc);
k_wstar=k_d/k_Fstar;
sys_zc_ff=ss(Astar+Bstar*Kstar,Bstar*k_wstar,Cstar,Dstar,T);
subplot(1,2,2);step(sys_zc_ff);



