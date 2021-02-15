clear;close all;clc;
R=1;L=0.1;
J=10;b=1;k=0.1;
A=[-R/L -k/L 0;k/J -b/J 0;0 1 0];
B=[1/L;0;0];
C=[0 0 1];
D=0;

motore_sys=ss(A,B,C,D);

s=20;Ta5=3;
k_d=2;
zita=0.45;
wn=3/(zita*Ta5);

lam_d1=-zita*wn+1i*wn*sqrt(1-zita^2);
lam_d2=lam_d1';
lam_d3=-zita*wn*10;
lam_d=[lam_d1 lam_d2 lam_d3];

K=-acker(A,B,lam_d);
motore_cc=ss(A+B*K,B,C,D);

k_F=dcgain(motore_cc);
k_w=k_d/k_F;
motore_ff=ss(A+B*K,B*k_w,C,D);

figure(1);step(motore_ff);

T=Ta5/10;

motore_sysstar=c2d(motore_sys,T,'zoh');
Astar=motore_sysstar.A;Bstar=motore_sysstar.B;
Cstar=motore_sysstar.C;Dstar=motore_sysstar.D;
lam_dstar=exp(lam_d*T);
Kstar=-acker(Astar,Bstar,lam_dstar);
motore_ccstar=ss(Astar+Bstar*Kstar,Bstar,Cstar,Dstar,T);
k_Fstar=dcgain(motore_ccstar);
k_wstar=k_d/k_F;
motore_ffstar=ss(Astar+Bstar*Kstar,Bstar*k_wstar,Cstar,Dstar,T);
figure(2);step(motore_ffstar);

%%% Progetto integratore
At=[A zeros(3,1);-C 0];
Bt=[B;0];
lam_d_i=[lam_d -zita*wn*8];
Kt=-acker(At,Bt,lam_d_i);
k_x=Kt(1:3);
k_i=Kt(4);

lam_d_istar=exp(lam_d_i*T);
Atstar=[Astar zeros(3,1);-Cstar 1];
Btstar=[Bstar;0];
Ktstar=-acker(Atstar,Btstar,lam_d_istar);
k_xstar=Ktstar(1:3);
k_istar=T*Ktstar(4);

%%% Progetto osservatore
lam_o1=-zita*wn*10;
lam_o2=-zita*wn*8;
H=-acker(A',C',[lam_o1 lam_o2 lam_o1])';


