function Tabla(tercios, octavas, Fs)

    columnas = {'EDT';'T20';'T30';'D50'};

    filasOctava = {'31.25 Hz','62.5 Hz','125 Hz','250 Hz','500 Hz','1 kHz',...
             '2 kHz','4 kHz','8 kHz','16 kHz'};

    filasTercio = {'20 Hz','25 Hz','31,5 Hz','40 Hz','50 Hz','63 Hz','80 Hz',...
    '100 Hz','125 Hz','160 Hz','200 Hz','250 Hz','315 Hz',...
    '400 Hz','500 Hz','630 Hz','800 Hz','1 kHz','1250 Hz','1600 Hz',...
    '2 kHz','2500 Hz','3150 Hz','4 kHz','5 kHz','6 kHz','8 kHz','10 kHz',...
    '12 kHz','16 kHz','20 kHz'};

    fig = figure;

    % Tablas Freq
    
    uitable('Data',[octavas.edt',octavas.t20',octavas.t30',octavas.d50'],...
          'ColumnName',columnas,'RowName',filasOctava,'Units',...
          'Normalized', 'Position',[.54, .1,.381, .338]);

    uitable('Data',[tercios.edt',tercios.t20',tercios.t30',tercios.d50'],'ColumnName',columnas,...
        'RowName',filasTercio,'Units', 'Normalized', 'Position',[0.07, .1, .388, .338]);
    %
    
    th = 0:1/Fs:((length(octavas.yh)-1)/Fs);
    tmm =0:1/Fs:((length(octavas.ymm)-1)/Fs);
    tfenv =0:1/Fs:((length(octavas.yfenv)-1)/Fs);
    
    subplot(2,1,1);
     plot(th,octavas.yh); hold on;
     plot(tmm,octavas.ymm);hold on;
     plot(tfenv,octavas.yfenv);
     title 'Respuesta al impulso';ylabel 'Lp (dBFS)';xlabel 'Tiempo (s)';
    
    set(fig,'Resize','off','Position',[300,100,1024,600],...
        'NumberTitle','off','MenuBar','none','Name','ReverbTime');
    
    uicontrol('Style', 'text',...
       'Position', [180 270 200 20],'FontSize',10, 'String', 'TR por Tercio de Octava');
    uicontrol('Style', 'text',...
       'Position', [650 270 200 20],'FontSize',10, 'String', 'TR por Octava');
   
end



