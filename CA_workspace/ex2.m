%   Esercizio 2.
% Per il processo dell?Esercizio 1 si progetti un regolatore con 
% retroazione di stato e assegnamento del guadagno che soddisfi le seguenti 
% specifiche:
% 1) errore a regime nullo per un ingresso a gradino;
% 2) guadagno statico pari a 2;
% 3) Ta5?0.5s;
% 4) s% ? 20%.
% Si utilizzi uno schema di controllo privo di azione integrale.

clear all;close all;clc;

tf_ca=tf(20,[1 11 10 0]);                                                 % fdt di del sistema di partenza
%tf_ca_zpk=zpk(tf_ca);                                                    % fdt in forma zeri poli guadagno
ss_ca=ss(tf_ca);                                                          % ricavo le matrici A B C D del sistema, partendo dalla fdt
A=[-11 -2.5 0;4 0 0;0 0.25 0];
B=[4 0 0]';
C=[0 0 5];
D=0;
Mr=-ctrb(A,B);                                                            % Matrice di raggiungibilità
r=rank(Mr);   

%   s%<20% <-> zita<=0.5 ->zita=0.5
%   Ta5=0.5 Ta5=3/(zita*wn)=0.5 <-> 3/(0.5*wn)=0.5 <-> wn=12
%   a=-wn*zita b=wn*radical(1-zita^2)
%   Il terzo autovalore lo prendo 10 volte la parte reale dei precedenti in
%   maniera tale che sia dominato.

wn=12;zita=0.5;a=-wn*zita; b=wn*sqrt(1-zita^2);
lam_d=[a+i*b a-i*b a*10];
k_d=2;

K=-acker(A,B,lam_d);
ss_cc=ss(A+B*K,B,C,D);

k_F=dcgain(ss_cc);
k_w=k_d/k_F;
ss_cc_ff=ss(A+B*K,B*k_w,C,D);
step(ss_cc_ff);
