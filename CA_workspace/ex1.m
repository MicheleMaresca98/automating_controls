%   Esercizio 1.
% Per il processo con funzione di trasferimento:
% G(s) =       20 
%         s(s+1)(s+10)
% si progetti un regolatore con retroazione di stato che soddisfi le 
% specifiche:
% 1) Ta5?1s;
% 2) s% ? 10%.
% Si provi a risolvere l?esercizio senza l?ausilio del MATLAB.
clear all;close all;clc;

tf_ca=tf(20,[1 11 10 0]);                                                 % fdt di del sistema di partenza
%tf_ca_zpk=zpk(tf_ca);                                                    % fdt in forma zeri poli guadagno
ss_ca=ss(tf_ca);                                                          % ricavo le matrici A B C D del sistema, partendo dalla fdt
A=[-11 -2.5 0;4 0 0;0 0.25 0];
B=[4 0 0]';
C=[0 0 5];
D=0;
Mr=-ctrb(A,B);                                                            % Matrice di raggiungibilità
r=rank(Mr);                                                               % Test di raggiungibilità

% Scelta autovalori:
%     Specifiche: s%<=10% Ta5=1s
%     . s%<=10% ricaviamo guardando il grafico pagina 22 (slide6-scelta autovalori)
%         che zita>=0.6 allora lo scegliamo pari a 0.7
%     . Ta5=1s ricaviamo wn: Ta5=3/(zita*wn)=1 allora wn=3/zita=3/0.7=4.2857
%     Da questi ricaviao i poli complessi coniugati a+-ib:
%     a=-zita*wn e b=wn*radical(1-(zita)^2) e otteniamo cosi a=-2.99999 e b=3.060602
%     questi saranno i due poli dominante del sistema controllato.
%     Per il terzo autovalore si prende circa 10 volte -3 ovvero -30 cosi da essere dominato.

lam_d=[-2.99999+i*3.060602 -2.99999-i*3.060602 -30];                      % autovalori desiderati
K=-acker(A,B,lam_d);                                                      % guadagno di retroazione di stato

sys_cc=ss(A+B*K,B,C,D);
step(sys_cc);
