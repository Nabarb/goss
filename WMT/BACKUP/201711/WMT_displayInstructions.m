function WMT_displayInstructions(phase, task)
% function WMT_displayInstructions displays task instructions according to
% input parameters. Instructions are maintained until the user presses a
% key or a timeout has elapsed.
%
% phase: text indicating the experimental phase whose instructions will be
% displayed
% task: number indicating the memory task (2 or 3 back)
%
% Marianna Semprini
% IIT, October 2017

timeout = 60;
switch phase
    case 'conclusion'
        message = {'CONGRATULAZIONI!'; 'HAI APPENA CONCLUSO QUESTA FASE SPERIMENTALE CON SUCCESSO!'};
        timeout = 5;
        
    case 'resting state'
        message = {'CERCA DI NON PENSARE A NULLA IN PARTICOLARE E CONCENTRA LO SGUARDO SULLA CROCE CHE VEDRAI APPARIRE AL CENTRO DELLO SCHERMO'; ' '; 'QUANDO SEI PRONTO PREMI LA BARRA SPAZIATRICE PER INIZIARE LA FASE SPERIMENTALE.'};
        
    otherwise
        switch task
            case 2
                message = {'INIZIA ORA UN ESERCIZIO DI MEMORIA.'; 'SULLO SCHERMO VERRANO VISUALIZZATE UNA ALLA VOLTA ALCUNE LETTERE IN SEQUENZA E IL TUO COMPITO CONSISTE NEL RICONOSCERE SE UNA DATA LETTERA ERA STATA PRESENTATA {\color{red}DUE} VOLTE PRIMA.'; 'SE TI APPARE UNA LETTERA UGUALE ALLA {\color{red}PENULTIMA} LETTERA VISUALIZZATA PRECEDENTEMENTE, PREMI LA BARRA SPAZIATRICE, ALTRIMENTI NON FARE NULLA.'; ''; 'QUANDO SEI SEI PRONTO PREMI LA BARRA SPAZIATRICE PER INIZIARE LA FASE SPERIMENTALE.'};
            case 3
                message = {'INIZIA ORA UN ESERCIZIO DI MEMORIA.'; 'SULLO SCHERMO VERRANO VISUALIZZATE UNA ALLA VOLTA ALCUNE LETTERE IN SEQUENZA E IL TUO COMPITO CONSISTE NEL RICONOSCERE SE UNA DATA LETTERA ERA STATA PRESENTATA {\color{red}TRE} VOLTE PRIMA.'; 'SE TI APPARE UNA LETTERA UGUALE ALLA {\color{red}TERZULTIMA} LETTERA VISUALIZZATA PRECEDENTEMENTE, PREMI LA BARRA SPAZIATRICE, ALTRIMENTI NON FARE NULLA.'; ''; 'QUANDO SEI SEI PRONTO PREMI LA BARRA SPAZIATRICE PER INIZIARE LA FASE SPERIMENTALE.'};
        end
end

f = figure(1000);
set(gcf,'color','w','units','normalized','outerposition',[0 0 1 1]);
set(gcf,'toolbar','none','menubar','none','dockcontrols','off','numbertitle','off','resize','off');
annotation(gcf,'textbox',[0.1 0.1 0.8 0.8],'String',message, 'FontSize',40,'color','k','edgecolor','w');
drawnow;

WMT_getkey_old(timeout);
close(f);