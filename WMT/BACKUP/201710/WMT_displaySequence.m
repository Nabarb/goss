function [pressTime, seqCompleted] = WMT_displaySequence(sequence, trialTime, ITI)
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
    for ii = 1:numel(sequence)
        pause(ITI-trialTime);
        tic;
        figure(f);
        annotation(gcf,'textbox',[0.4 1 0.05 0.05],'String',sequence(ii), 'FontSize',500,'color','w','edgecolor','k');
        [~, pressTime(ii)] = WMT_getkey(trialTime);
        figure(f);
        while toc<trialTime
            % wait
        end
        clf;
    end
    close(f);
    seqCompleted = 1;
catch
    errordlg('session stopped!');
end