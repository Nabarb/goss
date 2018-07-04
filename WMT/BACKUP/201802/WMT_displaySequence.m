function [pressTime, seqCompleted] = WMT_displaySequence(sequence, stimulus, trialTime, ITI, sessionIN, sessionOUT)
% function WMT_displaySequence displays a sequence of letters according to input parameters.
%
% sequence: letters to be displayed
% trialTime: duration of letter display
% ITI: inter trial interval
%
% pressTime: array containing the time of key press
% seqCompleted: 1 if the sequence was correctly displayed, 0 if stopped
%
% Marianna Semprini
% IIT, October 2017

seqCompleted = 0;

f = figure(1000);
set(gcf,'color','k','units','normalized','outerposition',[0 0 1 1]);
set(gcf,'toolbar','none','menubar','none','dockcontrols','off','numbertitle','off','resize','off');

pressTime = nan(1,numel(sequence));
try
    pause(ITI-trialTime);
    for ii = 1:numel(sequence)
        sessionOUT.prepare;        
        state = [1,1,stimulus(ii)];
        outputSingleScan(sessionOUT,state);

        figure(f);
        annotation(gcf,'textbox',[0.35 1 0.05 0.05],'String',sequence(ii), 'FontSize',500,'color','w','edgecolor','k');
        tic;
        pause(0.005);
        while inputSingleScan(sessionIN) && toc<trialTime
        end
        pressTime(ii) = toc;
        if toc<trialTime%+0.001
            pause(trialTime-toc); %pause(0.005);
            clf;
            pause(ITI-trialTime);
        else
            clf; pause(0.005);
            while inputSingleScan(sessionIN) && toc<ITI
            end
            pressTime(ii) = toc;
            
            pause(ITI-toc); %pause(0.005);
        end
        outputSingleScan(sessionOUT,[1,0,0]);
    end
    toc
    close(f);
    seqCompleted = 1;
    outputSingleScan(sessionOUT,[0,0,0]);
catch
    errordlg('session stopped!');
end