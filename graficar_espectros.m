%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script para graficar espectros del Genie2000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all
clc
% Lista con todos los nombres de los espectros que se quieren graficar
archivos = {'M98.CNF',...
            'M99.CNF',...
            };
 
% Tiempo que duró la adquisición
% Si son distintos, hacer una lista. 
t=300;
% Colores para graficar
colores = {'b','r',' g','k','m','y','c'};
% Variables donde se guardaran los datos
cuentas={};canales={};cuentas_tasa={};cuentas_tasa_agrup={};
% Se agrupan canales para mejorar la estadística (nprom=1 es no agrupar)
nprom = 4;

figure
hold on
for i=1:length(archivos)
  % Se leen los espectros
  [cuentas{i},canales{i}] = lee_cnf(archivos{i},2*4096,'no');
  % Se normaliza con el tiempo (vivo) de medición
  cuentas_tasa{i} = cuentas{i}/t;
  % Se agrupan canales 
  [cuentas_tasa_agrup{i}, canales{i}]=resampleo(cuentas_tasa{i},nprom,1/nprom,'dt');
  canales{i} = canales{i}+1; % El primer canal es el #1
  % Se grafica
  plot(canales{i},cuentas_tasa_agrup{i},colores{i});
 end
 hold off
 
legend(archivos);
grid on
xlabel('Canales');ylabel('Tasa de cuentas [cps]');
ylim([0 20])


