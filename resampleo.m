function [nre, tre] = resampleo(n,k,dt,tipo)

% Agrupa intervalos del vector n correspondiente a la adquisición en modo
% pulso.
% ENTRADA:
%           n    Vector con las cuentas obtenidas en cada dt
%           k    Número de intervalos que se quieren agrupar
%          dt    Duración de cada intervalo temporal original [s]
%         tipo   Tipo de normalización:
%                       'cps' -> Para un contador. Queda nre expresado en [cps] (default)
%                       'dt'  -> Para un contador. Queda nre expresado en [cpdt]
%                  'promedio' -> Para un analógico. Toma el promedio de k puntos.                
% SALIDA:
%           nre  Nuevo vector con resampleado
%           tre  Nuevo vector temporal resampleado
n=n(:);

if nargin==3
    tipo='cps';
end

if k >= 1,
    njust = fix(length(n)/k);                  % Cantidad justa de intervalos que voy a construir
    c     = reshape(n(1:k*njust),k,njust);
    nre   = sum(c,1)';
end
dtre = dt*k;                % Nuevo dt resampleado
ktot = length(nre);         % Tamaño del vector resampleado
tre  = (0:ktot-1)'.*dtre;   % Vector temporal resampleado

switch tipo
    case 'cps'
    nre  = nre./dtre;           % Paso a cuentas por segundo
    case 'dt'
    % No se hace nada
    case 'promedio'
    nre = nre./k;
end

end
