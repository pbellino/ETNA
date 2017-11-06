%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script para realizar la curva de conteo en función del voltaje
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Permite determinar la zona de plateau del detector.
% Se lee una lista de espectros y se los procesa de forma iterativa.
% Se debe indicar el canal Hd (nivel de discriminación) a partir del cual
% se realiza el conteo.
%
% Los parámetros que deberán cambiarse son:
%
% archivos       -> Nombre de los archivos
% voltajes       -> Voltajes de polarizaci´on (mismo orden que en "archivos") 
% Hd             -> Canal a partir de donde se realiza el conteo (discriminador)
% nchan          -> Cantidad de canales utilizados (hardware)
% nprom          -> Número de canales que se van a agrupar   
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lectura de los espectros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Lista con todos los nombres de los espectros que se quieren graficar
archivos = {'M98.CNF',...
            'M99.CNF',...
            };

% Cantidad de canales utilizados (por hardware)
nchan = 2*4096;

% Tiempo que duró la adquisición
t=400.*ones(length(archivos),1); % Si son todos iguales
% Colores para graficar
colores = {'b','r',' g','k','m','c','y','b','r','g','k','m','c','y','b','r','g','k','m'};
% Variables donde se guardaran los datos
cuentas={};canales={};cuentas_tasa={};cuentas_tasa_agrup={};
% Se agrupan canales para mejorar la estadística (nprom=1 es no agrupar)
nprom = 4;

% Canal a partir del cual se comenzará a contar los pulsos
% Es el equivalente al nivel del discriminador
% Se divide por nprom para que sea independiente del agrupamiento
Hd =240/nprom;
cuentas_tot=[];

figure
hold on
for i=1:length(archivos)
  % Se leen los espectros
  [cuentas{i},canales{i}] = lee_cnf(archivos{i},nchan,'no');
  % Se normaliza con el tiempo (vivo) de medición
  cuentas_tasa{i} = cuentas{i}/t(i);
  % Se agrupan canales 
  [cuentas_tasa_agrup{i}, canales{i}]=resampleo(cuentas_tasa{i},nprom,1/nprom,'dt');
  canales{i}=canales{i}+1; % El primer canal es el #1
  % Se grafica
  plot(canales{i},cuentas_tasa_agrup{i},colores{i});
  cuentas_tot(i) = sum(cuentas_tasa_agrup{i}(Hd:end));
 end
 hold off
legend(archivos);
grid on
xlabel('Canales');ylabel('Tasa de cuentas [cps]');
ylim([0 15])
 

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualización del conteo en el espectro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% A modo de ejemplo, sombreo el area de contaje para el primer espectro
figure
plot(canales{1},cuentas_tasa_agrup{1},colores{1});
hold on
area(canales{1}(Hd:end),cuentas_tasa_agrup{1}(Hd:end),'facecolor','r')
title(['Tasa de cuentas discriminadas:', num2str(cuentas_tot(1)),' cps']);
grid on
xlabel('Canales');ylabel('Tasa de cuentas [cps]');
ylim([0 15])
legend(archivos{1})
hold off
%----------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gráfico de la curva cuentas vs voltaje
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Finalmente se debe graficar la tasa de cuentas discriminadas para cada
% voltaje aplicado.
% Deben estar en el mismo orden en que se definieron los nombres en "archivos"
voltajes = [1150,1200];

figure
plot(voltajes,cuentas_tot,'s','markerfacecolor','k')
xlabel('Voltaje [V]');
ylabel('Tasa de cuentas [cps]');
xlim([min(voltajes)*0.95,max(voltajes)*1.05])
title(['Curva de plateau con la discriminación en el canal Hd = ', num2str(Hd)])
grid on
