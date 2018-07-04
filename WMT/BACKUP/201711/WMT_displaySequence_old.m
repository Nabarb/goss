function [pressTime, seqCompleted] = WMT_displaySequence_old(sequence, stimulus, trialTime, ITI, session)
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

% %%%%% code to avoid figure resize or minimize
% jFrame = get(f,'JavaFrame');
% warning('off', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
% jWindow = jFrame.getFigurePanelContainer.getTopLevelAncestor; drawnow
% jWindow.setEnabled(false);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
pressTime = nan(1,numel(sequence));
try
    for ii = 1:numel(sequence)
        pause(ITI-trialTime);
        tic;
        figure(f);
        annotation(gcf,'textbox',[0.35 1 0.05 0.05],'String',sequence(ii), 'FontSize',500,'color','w','edgecolor','k'); 
        state = [1,1,stimulus(ii),0];
        outputSingleScan(session,state); 
        pause(trialTime);
% % %         [~, pressTime(ii)] = WMT_getkey(session, state,trialTime);
% %         [~, pressTime(ii)] = WMT_getkey_old(trialTime);
% %         figure(f);
% %         
% %         uiwait(f,trialTime-toc)
% % %         while toc<trialTime
% % %             % wait
% % %             uiwait(f,trialTime-toc)
% % %         end
        clf;
        outputSingleScan(session,[1,0,0,0]); 
    end
    close(f);
    seqCompleted = 1;
    outputSingleScan(session,[0,0,0,0]);
catch
    errordlg('session stopped!');
end