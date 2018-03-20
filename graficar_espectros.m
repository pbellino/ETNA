%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script para graficar espectros del Genie2000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all
clc
% Lista con todos los nombres de los espectros que se quieren graficar
archivos = {'He3_1600.CNF',...
            'BF3_2000.CNF',...
            };

% Cantidad de canales utilizados (por hardware)
nchan = 1*4096;

% Tiempo que duró la adquisición
% Si son distintos, hacer una lista. 
t=400;
% Colores para graficar
colores = {'b','r',' g','k','m','y','c'};
% Variables donde se guardaran los datos
cuentas={};canales={};cuentas_tasa={};cuentas_tasa_agrup={};
% Se agrupan canales para mejorar la estadística (nprom=1 es no agrupar)
nprom = 1;

figure
hold on
for i=1:length(archivos)
  % Se leen los espectros
  [cuentas{i},canales{i}] = lee_cnf(archivos{i},nchan,'no');
  % Se normaliza con el tiempo (vivo) de medición
  cuentas_tasa{i} = cuentas{i}/t;
  % Se agrupan canales 
  [cuentas_tasa_agrup{i}, canales{i}]=resampleo(cuentas_tasa{i},nprom,1/nprom,'dt');
  canales{i} = canales{i}+1; % El primer canal es el #1
  % Se grafica
  plot(canales{i},cuentas_tasa_agrup{i},colores{i});
 end
 hold off
 
h=legend(archivos);
% Evita que "_" sea tomado como subindice (latex)
set(h,'interpreter','none')
grid on
xlabel('Canales');ylabel('Tasa de cuentas [cps]');
xlim([0 2000])
ylim([0 6])

