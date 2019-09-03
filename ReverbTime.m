function reverb = ReverbTime
    
    reverb.multi2mono = @multi2mono;
    reverb.impulse = @impulse;
    reverb.filtrar = @filtrar;
    reverb.suavizado = @suavizado;
    reverb.dropIndexes = @dropIndexes;
    reverb.regresionLineal = @regresionLineal;
    reverb.easterEgg = @easterEgg;
    
end

function ym = multi2mono(y)

    n = size(y,2);                          %Checkeo si es mono o no

    if(n>1)
        ym=(1/n)*sum(y,2);                  %Si lo es, sumo todos los canales                               
    else
        ym=y;                               %Sino la devuelvo tal cual                               
    end
    
end

function h = impulse(x,y)

    X=fft(x);
    Y=fft(y);
    
    H=Y/X;
    h=ifft(H);

end

function [filtradaTercio, filtradaOctava] = filtrar(y,Fs) 
%% Filtro por Tercio de Octava

    bancoTercio = cell(1,31);
    filtradaTercio = zeros(31,length(y));

    anchoFiltro = '1/3 octave';
    N = 8;
    
    F0Tercio = [20,25,31.5,40,50,63,80,100,125,160,200,250,315,...
                400,500,630,800,1e3,1250,1600,2e3,2500,3150,4e3,...
                5e3,6e3,8e3,10e3,12e3,16e3,20e3];
    
    iFinalTercio = length(F0Tercio);
            
        for i = 1:iFinalTercio
     
            bancoTercio{i} = octaveFilter('FilterOrder', N, ...
            'CenterFrequency', F0Tercio(i), 'Bandwidth', anchoFiltro, 'SampleRate', Fs);
    
            filtroTercio = bancoTercio{i};
    
            filtradaTercio(i,:) = filtroTercio(y); % Señal filtrada por tercio sin normalizar
        end

%% Filtrado por Octava

    bancoOctava = cell(1,10);
    filtradaOctava = zeros(10,length(y));

    anchoFiltro = '1 octave';
    N = 6;
    
    F0Octava = [31.25,62.5,125,250,500,1e3,2e3,4e3,8e3,16e3];
    
    iFinalOctava = length(F0Octava);
        
        for i = 1:iFinalOctava
     
            bancoOctava{i} = octaveFilter('FilterOrder', N, ...
            'CenterFrequency', F0Octava(i), 'Bandwidth', anchoFiltro, 'SampleRate', Fs);
    
            filtroOctava = bancoOctava{i};
    
            filtradaOctava(i,:) = filtroOctava(y); % Señal filtrada por octava sin normalizar

        end
        
end

function [ys,ymm,yh] = suavizado(y,n,Fs)

    yh = abs(hilbert(y));                                                  %Hilbert
    
    ymm=zeros(1,length(yh)-n);                                             
    ymm(1)=(1/n)*sum(yh(1:n));
    for i=2:(length(yh)-n)       
        ymm(i)=ymm(i-1)+(1/n)*(yh(i+n)-yh(i-1));                           %Media Movil
    end    
%    ymm=ymm(1:(length(ymm)-n));
    
%    ymm=abs(ymm);
    
    ymmcorrida=ymm;
    c=round(0.666*Fs);
    ymmcorrida(1:(length(ymm)-c))=ymm((c+1):length(ymm));
    td=find(ymmcorrida>=ymm,1); 
    ys(td:-1:1)=(cumsum(ymm(td:-1:1))/sum(ymm(1:td)));                     %Schroeder
    ys=ys(1:td);    
       
%     ys(td:-1:1) = cumsum(ys(td:-1:1).^2);                                %Otro Schroeder
    
    yh=20*log10(yh/max(yh));
    ymm=20*log10(ymm/max(ymm));
    ys=20*log10(ys/max(ys));                                               %Paso a logarítmico
    
end

function [x0,x5,x10,x25,x35] = dropIndexes(y)

    x0=find(y<=0,1);                                                       %Busco el pico para EDT
    x5=find(y<=-5,1);                                                      %Busco la caída de 5dB para T20 y T30
    x10=find(y<=-10,1);                                                    %Busco la caída de 10dB para EDT
    x25=find(y<=-25,1);                                                    %Busco la caída de 25dB para T20
    x35=find(y<=-35,1);                                                    %Busco la caída de 35dB para T30

end

function [slope, intercept, r2] = regresionLineal(x,y)

% Calculo de recta de regresion lineal, pendiente y ordenada.
    
    X = [ones(length(x),1) x'];
    Y = y';

    A = X'*X;
    B = X'*Y; 

    [b,~] = linsolve(A,B); % Resolucion de sistema lineal
    slope = b(2); % Pendiente regresion lineal
    intercept = b(1); % Ordenada al origen regresion lineal

% Calculo de coeficiente de determinacion (r)     

    xRaya = mean(x); 
    yRaya = mean(y); 
    n = length(x); 

    xyRaya = xRaya.*yRaya;

    sumX2 = sum(x.^2); 
    sumY2 = sum(y.^2); 
    sumXY = sum(x.*y); 

    r = (sumXY - n*xyRaya) / ...  
        sqrt((sumX2 - n*(xRaya^2))*(sumY2 - n*(yRaya^2)));

    r2 = r^2; % Porcentaje de variabilidad

end

function easterEgg(y)

    if(strcmp(y,'laDifa'))
        web('https://www.youtube.com/watch?v=dQw4w9WgXcQ','-browser');    
        error('You have been rickrolled');
    end
    
end