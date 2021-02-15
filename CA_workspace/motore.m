clear;close all;clc;
 
motore_fdt=tf(0.1,[10 1 0]);

k_d=1;
Ta1=5;

zita=0.6;
wn=4.6/(zita*Ta1);
a=-zita*wn;
b=wn*sqrt(1-zita^2);


A=[-0.1 0;1 0]; B=[0.01;0]; C=[0 1]; D=0;

motore_sys=ss(A,B,C,D);

lam_d1=a+1i*b;
lam_d2=lam_d1';
lam_d=[lam_d1 lam_d2];

K=-acker(A,B,lam_d);
motore_sys_cc=ss(A+B*K,B,C,D);
k_F=dcgain(motore_sys_cc);
k_w=k_d/k_F;

motore_sys_cc_ff=ss(A+B*K,B*k_w,C,D);
step(motore_sys_cc_ff);

%%% Osservatore
lam_o=a*10;
H=-acker(A',C',[lam_o lam_o])';


