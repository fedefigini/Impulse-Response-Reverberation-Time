function [tercios,octavas] = impulseResponse(filename)

    h = ReverbTime; 

    h.easterEgg(filename);

    [y,Fs] = audioread(filename);
    
    y = h.multi2mono(y);
    
    [yftercio, yfoctava] = h.filtrar(y,Fs);
    
    tercios.t30=zeros(1,size(yftercio,1));  
    tercios.t20=zeros(1,size(yftercio,1));    
    tercios.edt=zeros(1,size(yftercio,1));
    
    tercios.t30r2=zeros(1,size(yftercio,1));  
    tercios.t20r2=zeros(1,size(yftercio,1));    
    tercios.edtr2=zeros(1,size(yftercio,1));
    
    tercios.d50=zeros(1,size(yftercio,1));
    
    octavas.t30=zeros(1,size(yfoctava,1));  
    octavas.t20=zeros(1,size(yfoctava,1));    
    octavas.edt=zeros(1,size(yfoctava,1));
    
    octavas.t30r2=zeros(1,size(yfoctava,1));  
    octavas.t20r2=zeros(1,size(yfoctava,1));    
    octavas.edtr2=zeros(1,size(yfoctava,1));
    
    octavas.d50=zeros(1,size(yfoctava,1));
    
    %TERCIOS
    for i=1:size(yftercio,1)
        
        yf = yftercio(i,:);
        
        tercios.d50(i)=sum(yf(1:0.05*Fs).^2)/sum(yf.^2);
        
        [yfenv, ~, ~] = h.suavizado(yf,5001,Fs);
        
        [x0, x5, x10, x25, x35] = h.dropIndexes(yfenv);

        [t30slope, t30intercept, t30r2] = h.regresionLineal((x5:x35),yfenv(x5:x35));
        [t20slope, t20intercept, t20r2] = h.regresionLineal((x5:x25),yfenv(x5:x25));
        [edtslope, edtintercept, edtr2] = h.regresionLineal((x0:x10),yfenv(x0:x10));

        tercios.t30(i) = (-60-t30intercept)/(t30slope*Fs);
        tercios.t20(i) = (-60-t20intercept)/(t20slope*Fs);
        tercios.edt(i) = (-60-edtintercept)/(edtslope*Fs);
    
        tercios.t30r2(i) = t30r2;
        tercios.t20r2(i) = t20r2;
        tercios.edtr2(i) = edtr2;
        
    end
    
    %OCTAVAS
    for i=1:size(yfoctava,1)
        
        yf = yfoctava(i,:);
        
        octavas.d50(i)=sum(yf(1:0.05*Fs).^2)/sum(yf.^2);
        
        [yfenv, ymm, yh] = h.suavizado(yf,5001,Fs);
        
         if i==6
            octavas.yfenv = yfenv;
            octavas.ymm = ymm;
            octavas.yh = yh;
         end
        
        
        [x0, x5 ,x10, x25, x35] = h.dropIndexes(yfenv);

        [t30slope, t30intercept, t30r2] = h.regresionLineal((x5:x35), yfenv(x5:x35));
        [t20slope, t20intercept, t20r2] = h.regresionLineal((x5:x25), yfenv(x5:x25));
        [edtslope, edtintercept, edtr2] = h.regresionLineal((x0:x10), yfenv(x0:x10));

        octavas.t30(i) = (-60-t30intercept)/(t30slope*Fs);
        octavas.t20(i) = (-60-t20intercept)/(t20slope*Fs);
        octavas.edt(i) = (-60-edtintercept)/(edtslope*Fs);
    
        octavas.t30r2(i) = t30r2;
        octavas.t20r2(i) = t20r2;
        octavas.edtr2(i) = edtr2;
        
    end
   
    Tabla(tercios, octavas, Fs);
    
end