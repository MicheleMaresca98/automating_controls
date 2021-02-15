% Esercizio 4.
% Per il processo dell’Esercizio 1, si progetti un regolatore analogico con
% retroazione di stato e
% assegnamento del guadagno che soddisfi le seguenti specifiche:
% 1) errore a regime nullo in presenza di un disturbo a gradino in ingresso 
% al processo;
% 2) Ta5=2 s;
% 3) s% <= 20%.
clear;close all;clc;
tf_s=tf(20,[1 11 10 0]);  
sys_s=ss(tf_s);
A=sys_s.A;B=sys_s.B;C=sys_s.C;D=sys_s.D;
zita=0.5;
wn=3/(2*zita);
a=-zita*wn;
b=wn*sqrt(1-(zita)^2);
lam_d1=a+1i*b;
lam_d2=lam_d1';
lam_d3=a*10;
lam_d4=a*8;
lam_d=[lam_d1 lam_d2 lam_d3];
k_d=2;
K=-acker(A,B,lam_d);
sys_sc=ss(A+B*K,B,C,D);
k_F=dcgain(sys_sc);
k_w=k_d/k_F;
sys_sc_ff=ss(A+B*K,B*k_w,C,D);
step(sys_sc_ff);

%%% Schema con integratore per avere errore a regime nullo in presenza di
%%% disturbo a gradino.

At=[A,zeros(3,1);-C 0];Bt=[B;0];
lam_dt=[lam_d,lam_d4];
Kt=-acker(At,Bt,lam_dt);
k_x=Kt(1:3);
k_i=Kt(4);
