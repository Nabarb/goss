function f = WMT_displayFixationCross
% function WMT_displayFixationCross creates a tiny white cross on black
% background
%
% Marianna Semprini
% IIT, October 2017

f = figure(1000);
set(f,'color','k','units','normalized','outerposition',[0 0 1 1]);
set(f,'toolbar','none','menubar','none','dockcontrols','off','numbertitle','off','resize','off');
annotation(f,'textbox',[0.4 0.8 0.05 0.05],'String','+', 'FontSize',300,'color','w','edgecolor','k');
drawnow;