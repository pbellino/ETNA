%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script para obtener un espectro restándole el fondo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all
clc
% Lista con todos los nombres de los espectros que se quieren graficar
archivos = {'M98.CNF',... % Espectro medido con la fuente y fondo
            'M99.CNF',... % Espectro medido del fondo (M99.CNF no es fondo)
            };
 
% Cantidad de canales utilizados (por hardware)
nchan = 2*4096;

% Tiempo que duró la adquisición
t_con_fondo=400;  %  Espectro con fondo
t_solo_fondo=400; %  Espectro sólo del fondo

t = [t_con_fondo, t_solo_fondo];
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
  cuentas_tasa{i} = cuentas{i}/t(i);
  % Se agrupan canales 
  [cuentas_tasa_agrup{i}, canales{i}]=resampleo(cuentas_tasa{i},nprom,1/nprom,'dt');
  canales{i} = canales{i}+1; % El primer canal es el #1
  % Se grafica
  plot(canales{i},cuentas_tasa_agrup{i},colores{i});
 end
 % Resta el fondo
 cuentas_tasa_agrup_sin_fondo = cuentas_tasa_agrup{1}-cuentas_tasa_agrup{2};
 % Grafica el espectro con el fondo ya restado
 plot(canales{1},cuentas_tasa_agrup_sin_fondo,colores{3})
 hold off
 
legend({'Espectro con fondo', 'Fondo', 'Espectro sin fondo'});
grid on
xlabel('Canales');ylabel('Tasa de cuentas [cps]');
ylim([0 4])


