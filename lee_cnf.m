function  [cuentas,canales] = lee_cnf(archivo,nchan_def,grafica)
% LEE_CNF - Lee los archivos binarios generados por el software Genie2000
%
% USO:
%      -- cuentas = lee_cnf(archivo,8192)
%      -- [cuentas,canales] = lee_cnf(archivo,8192)
%      -- cuentas = lee_cnf(archivo,"si")
%
% ENTRADAS:
%       archivo:   string con la ruta del archivo .CNF que se guiere leer
%       nchan_def: Cantidad de canales definidas en el multicanal. Es el número
%                  que se fija con el 'MCA Input Definition Editor' al definir
%                  el archivo del detector. Son la cantidad de canales que se
%                  utilizar para dividir los 10V. No es la que se especifica con
%                  el programa Genie2000. Éste tiene a nchan_def como máximo.
%                  IMPORTANTE: Esta variable sólo puede tomar los valores 4096
%                  ó 8192. Si se quiere otro número, se deberá buscar en el .CNF
%                  dónde comienzan los datos.
%       grafica:   (OPCIONAL) string para indicar si se quiere graficar. 
%                  En caso de ingresarse, debe ser "si" ó "no". Si no se ingresa
%                  se lo toma como "no".
%
% SALIDAS:
%       cuentas: cuentas en cada canal
%       canales: numero de canales
%
% DESCRIPCIÓN:
%
% Función para leer los archivos binarios guardados por el software Genie2000.
% Sólo lee la parte del archivo que contiene la información sobre las cuentas
% en cada canal. Se saltea toda la información extra que se encuentra en el 
% encabezado.
% Opcionalmente hace el gráfico de cuentas vs canales.
%
% 03.2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ------------------------------------------------------------------------------
% COMPROBACIÓN DE LAS ENTRADAS
% ------------------------------------------------------------------------------
if nargin < 1
  % Si no se ingresa ningún argumento de entrada
  error('Falta especificar el nombre del archivo')
elseif nargin == 1
  error ('Falta ingresar la cantidad de canales utilizada')
  % Si hay solo dos argumentos
elseif nargin == 2
  % Si se ingresa sólo dos, por default no se grafica.
  grafica = 'no';
  % Si hay solo dos argumentos
elseif nargin == 3
  % Se fija si son 'si' o 'no'
  if and(~strcmp(grafica,'no') , ~strcmp(grafica,'si') )
    error('El segundo argumento <grafica> sólo puede ser ''si'' o ''no''')
  end
end

% ------------------------------------------------------------------------------
% LECTURA DE DATOS
% ------------------------------------------------------------------------------
%
% Abre el archivo  
fid = fopen(archivo,'r','l');
% Lee el archivo completo
q   = fread(fid, inf,'int32');
fclose(fid);

% Se saltea el encabezado y se queda con los últimos puntos que corresponden 
% a los datos de los canales
%chan_ini = length(q)-nchan_def+1
if nchan_def==8192
  chan_ini = 7041;
elseif nchan_def==4096
  chan_ini = 6657;
else
  error('Falta calcular cómo leer archivo CNF en lee_cnf.m');
end
cuentas = q(chan_ini:end)';
%cuentas = q(7041:end)';
% Crea el vector para los canales
canales = 1:length(cuentas);

% ------------------------------------------------------------------------------
% GRÁFICO
% ------------------------------------------------------------------------------
%
% Si fue pedido, se hace el gráfico
if strcmp(grafica,'si')
  plot(canales,cuentas,'b.')
  xlabel('Canales');ylabel('Número de cuentas');
  grid on
  legend(archivo)
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
