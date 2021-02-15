% Esercizio 5.
% Per il processo dell’Esercizio 1, si progetti un regolatore digitale con 
% retroazione di stato e assegnamento del guadagno che soddisfi le seguenti 
% specifiche:
% 1) errore a regime nullo in presenza di un disturbo a gradino in ingresso 
% al processo;
% 2) Ta5=2 s;
% 3) s%<=15%.
% Si utilizzi il metodo di progetto a tempo continuo scegliendo un tempo di 
% campionamento pari a
% 1/20 del tempo di assestamento e si verifichino le prestazioni utilizzando
% SIMULINK.
clear;close all;clc;
tf_c=tf(20,[1 11 10 0]); 
sys_c=ss(tf_c);
A=sys_c.A;B=sys_c.B;C=sys_c.C;D=sys_c.D;

%%% Scelta autovalori
zita=0.6;
wn=3/(2*zita);
a=-zita*wn;
b=wn*sqrt(1-zita^2);
lam_d1=a+1i*b;
lam_d2=lam_d1';
lam_d3=a*10;
lam_d=[lam_d1,lam_d2,lam_d3];

%%% Guadagno desiderato
k_d=2;


K=-acker(A,B,lam_d);
sys_c_con=ss(A+B*K,B,C,D);
k_F=dcgain(sys_c_con);
k_w=k_d/k_F;
sys_c_con_ff=ss(A+B*K,B*k_w,C,D);

%%% Tempo di campionamento
T=2/20;
sys_star=c2d(sys_c,T,'zoh');
Astar=sys_star.A;
Bstar=sys_star.B;
Cstar=sys_star.C;
Dstar=sys_star.D;

At=[Astar zeros(3,1);-Cstar 1];
Bt=[Bstar;0];

lam_d4=a*8;
lam_dt=[lam_d lam_d4];
lam_dt_star=exp(lam_dt*T);
Kt=-acker(At,Bt,lam_dt_star);
k_x=Kt(1:3);
k_i=T*Kt(4);