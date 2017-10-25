%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script para hacer un ajuste gaussiano a un pico del espectro (Genie2000)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Lee el archivo .CNF grabado con el multicanal y realiza un ajuste gaussiano
%  al pico de energía completa. De este ajuste se obtienen dos datos de interés:
%     1) Canal en donde se produce el máximo (valor medio de la gaussiana)
%     2) Ancho del pico (a partir de la desviación estandar)
%
% El ajuste se hace de forma artesanal, mirando el espectro y decidiendo en qué
% regiones se lo desea hacer.
%
% Los parámetros que deberán cambiarse dependiendo del espectro leido son:
%
% archivos           -> Nombre del archivo
% canal_i            -> Canal inicial para el ajuste      
% canal_f            -> Canal final para el ajuste
% parametros_ini     -> Parámetros iniciales del ajuste
% nprom              -> Número de canales que se van a agrupar  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

% Permite saber si se está corriendo el script en Octave o en Matlab
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

% Si se corre en Octave, se necesita cargar el paquete optim
% (que se asume ya está instalado)
if isOctave; pkg load optim; end
          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lectura del espectro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Nombre del archivo del espectro que se leerá
archivos = {'M99.CNF',...
            };

% Se lee el archivo
[cuentas,canales] = lee_cnf(archivos{1},8192,'no');

% Tiempo (vivo) durante el cual se tomó el espectro
t=300; % [s]
% Se pasa a tasa de cuentas
cuentas_tasa = cuentas/t; % [cps]

% Se agrupan canales para mejorar la estadística
nprom = 2;
[cuentas_tasa_agrup, canales]=resampleo(cuentas_tasa,nprom,1/nprom,'dt');
canales = canales + 1; % El primer canal es el #1

% Se grafica el espectro
figure
plot(canales,cuentas_tasa_agrup);
legend(archivos);
grid on
xlabel('Canales');ylabel('Tasa de cuentas [cps]');
ylim([0 6]); % Ajustar como mejor convenga

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ajuste Gaussiano del pico de energía completa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Región en donde se hará el ajuste (parte derecha del pico de energía completa)
% Dependerá de cuántos canales se hayan agrupado
canal_i = 1460; % Canal inicial
canal_f = 1580; % Canal final

% Define la región de ajuste
ind = canales( (canales>=canal_i) & (canales<=canal_f));
x_slice = canales(ind);
y_slice = cuentas_tasa_agrup(ind);

% Parametros iniciales del ajuste
parametros_ini=[100,1500,10]; % Dependera del agrupamiento

% Función para el ajuste (Gaussiana)
% par(1) -> normalización
% par(2) -> valor medio de la gaussiana
% par(3) -> desviación estandar de la gaussiana
gaussian = @(x,par) (par(1)*exp(-((x-par(2))/par(3)).^2));

if isOctave
  % Ajuste con Octave
  [f,p,cvg,iter,corp,covp]=leasqr(x_slice,y_slice,parametros_ini,gaussian,.00001,29);
  y_ajustado = gaussian(x_slice,p);
else
  % Ajuste con Matlab
  gaussian_m = @(par,x) gaussian(x,par); % En Matlab debe invertirse el orden
  [p,R,J,covp] = nlinfit(x_slice,y_slice,gaussian_m,parametros_ini);
  y_ajustado = gaussian_m(p,x_slice);
end

% Desviación estandar de los parámetros ajustados a partir de la matriz
% de covarianza del ajuste (covp)
p_std = sqrt(diag(covp));

% Gráfico del ajuste
hold on
plot(x_slice,y_ajustado,'r','linewidth',1.5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cálculo de la resolución del detector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usar la matriz de covarianza para propagar errores
FWHM = 2*sqrt(2*log(2))*p(3);
pico = p(2);
resolucion = 100*FWHM/pico;

fprintf('Maximo [canal] = %.1f \n', pico);
fprintf('FWHM [canal] = %.1f \n',FWHM);
fprintf('Resolucion =  %.2f %%  \n',resolucion)
