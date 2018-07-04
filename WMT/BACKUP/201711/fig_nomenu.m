function hFig = fig_nomenu

% Create a simple Matlab figure (visible, but outside monitor area)
hFig = figure(1000);
scrsz = get(groot,'ScreenSize');
set(gcf,'color','k','units','normalized','position',[0 0 scrsz(3) scrsz(4)]);
set(gcf,'toolbar','none','menubar','none','dockcontrols','off','numbertitle','off','resize','off');
hButton = uicontrol('String','Close', 'Position',[307,0,45,16]);
 
% Ensure that everything is rendered, otherwise the following will fail
drawnow;
 
% Get the underlying Java JFrame reference handle
mjf = get(handle(hFig), 'JavaFrame');
jWindow = mjf.fHG2Client.getWindow;  % or: mjf.getAxisComponent.getTopLevelAncestor
 
% Get the content pane's handle
mjc = jWindow.getContentPane;
mjr = jWindow.getRootPane;  % used for the offset below
 
% Create a new pure-Java undecorated JFrame
figTitle = jWindow.getTitle;
jFrame = javaObjectEDT(javax.swing.JFrame(figTitle));
jFrame.setUndecorated(true);
 
% Move the JFrame's on-screen location just on top of the original
jFrame.setLocation(mjc.getLocationOnScreen);
 
% Set the JFrame's size to the Matlab figure's content size
%jFrame.setSize(mjc.getSize);  % slightly incorrect by root-pane's offset
jFrame.setSize(mjc.getWidth+mjr.getX, mjc.getHeight+mjr.getY);
 
% Reparent (move) the contents from the Matlab JFrame to the new JFrame
jFrame.setContentPane(mjc);
 
% Make the new JFrame visible
jFrame.setVisible(true);
 
% Hide the Matlab figure by moving it off-screen
pos = get(hFig,'Position');
set(hFig, 'Position',[-1000,-1000,pos(3:4)]);
drawnow;