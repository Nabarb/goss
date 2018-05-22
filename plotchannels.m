function plotchannels(varargin)
%% Plots all channels in one graph
% usage: plotchannels(ax,X,T,varargs)
%       If ax is not specified, the plot is performed in a new figure
%       If T is not specified, the xaxis dispays the sample number
%     'ylim',[min(X,[],2) max(X,[],2)],...
%     'grid',[4 4],...
%     'N',16, ...
%     'Mode','together',... %together or subplot
%     'Events',[],...
%     'EventsLabel',{''}...
%      'labels' channels labels, default 1:N
%     'TrialsList',[],...
%     'SeparationFactor',1 ...  Distance between traces. The lower, the
%                               nearer the plots are
    
Params=struct( ...
    'grid',[4 4],...
    'N',16, ...
    'Mode','together',... %together or subplot
    'Events',[],...
    'EventsLabel',{''},...
    'TrialsList',[],...
    'SeparationFactor',1 ...
    );

NInputArgs = find(cellfun( @(x) ischar(x), varargin ),1)-1;
if isempty(NInputArgs)
    NInputArgs=nargin;
end
switch NInputArgs
    case 1
        if isobject(varargin{1}) && isgraphics(varargin{1},'axes')
            error('Input data must be a single matrix X or a pair X,Time');
        else
            X=varargin{1};
            Fig=figure('Color',[1 1 1]);
            ax1=axes(Fig);
            [M,N]=size(X);
            if N>M  % to get data matrix in standard form i.e. samples in rows(M), channels in columns(N)
                X = X';
                [M,N]=size(X);
            end
            Time=1:M;
            xlbl='Samples';
        end
    case 2
        if isobject(varargin{1}) && isgraphics(varargin{1},'axes')
            ax1=varargin{1};
            X=varargin{2};
            [M,N]=size(X);
            if N>M  % to get data matrix in standard form i.e. samples in rows(M), channels in columns(N)
                X = X';
                [M,N]=size(X);
            end
            Time=1:M;
            xlbl='Samples';
        else
            Fig=figure('Color',[1 1 1]);
            ax1=axes(Fig);
            X=varargin{1};
            [M,N]=size(X);
            if N>M  % to get data matrix in standard form i.e. samples in rows(M), channels in columns(N)
                X = X';
                [M,N]=size(X);
            end
            Time=varargin{2};
            xlbl='Time';
        end
    case 3
        ax1=varargin{1};
        X=varargin{2};
        [M,N]=size(X);
        if N>M  % to get data matrix in standard form i.e. samples in rows(M), channels in columns(N)
            X = X';
            [M,N]=size(X);
        end
        Time=varargin{3};
        xlbl='Time';
end

varargin=varargin(NInputArgs+1:end);

Params.ylim=[min(X,[],2) max(X,[],2)];
Params.labels=cellstr(num2str((1:N)'));

% load in user supplied options
Params=getopt(Params,varargin{:});

EventsColor=rand(3,length(unique(Params.EventsLabel)));

if strcmp(Params.Mode,'together')
    Separation=cumsum(ones(1,N)*abs(mean(max(X)-min(X)))*Params.SeparationFactor);
    XOFF=X+ones(M,1)*Separation;
    hold(ax1,'on')
    evline=[];
    EOTpos=Params.Events((ismember((Params.EventsLabel),'END_OF_TRIAL')))';
    ax2 = axes('Position',ax1.Position,...
        'XAxisLocation','top',...
        'YAxisLocation','left',...
        'XTick',[Time(1)-1 EOTpos(1:end-1)+1],...
        'YTick',[],...
        'XTickLabel',cellstr(num2str(Params.TrialsList')),...
        'XLim',ax1.XLim,...
        'Color','none'...
        );
        uistack(ax2,'bottom')
        hold(ax2,'on')

    % Plots a vertical line when an events occourres
    for i=1:length(Params.Events)
        T=Params.Events(i);
        Y=[3*max(max(abs(XOFF))) -3*max(max(abs(XOFF)))];
        EvNumber=ismember(unique(Params.EventsLabel),Params.EventsLabel(i));
        
        evline(i)=plot(ax2,[T T],Y,'--',...
            'Color',EventsColor(:,EvNumber));
        
    end
    plot(ax1,Time,XOFF);
    yticklabels(ax1,Params.labels)
    yticks(ax1,Separation);
    if ~isempty((Params.EventsLabel))
        [~,I]=unique(Params.EventsLabel);
        I=sort(I);
        legend(ax1,evline(I),Params.EventsLabel(I));
    end
    ylim(ax2,[0.8*min(min(XOFF)) 1.05*max(max(XOFF))]);
    ylim(ax1,[0.8*min(min(XOFF)) 1.05*max(max(XOFF))]);

    xlim(ax2,[Time(1) Time(end)])
    xlim(ax1,[Time(1) Time(end)])

    linkaxes([ax1 ax2]);
    hold(ax1,'off')
    hold(ax2,'off')
    xlabel(ax1,xlbl)
    set(ax1,'Color','None')

    
elseif strcmp(Params.Mode,'subplot')
    X=X';
    for j=1:round(size(X,1)/Params.N)
        figure
        for i=1:Params.N
            if ((i+(j-1)*Params.N)>size(X,1))||all(X(i+(j-1)*Params.N,:)==0)
                break;
            end
            subplot(Params.grid(1),round(Params.N/Params.grid(2)),i)
            plot((X(i+(j-1)*Params.N,:)));
            ylim(Params.ylim(i+(j-1)*Params.N,:))
            title(Params.labels{i+(j-1)*Params.N})
        end
    end
end

function properties = getopt(properties,varargin)
%GETOPT - Process paired optional arguments as 'prop1',val1,'prop2',val2,...
%
%   getopt(properties,varargin) returns a modified properties structure,
%   given an initial properties structure, and a list of paired arguments.
%   Each argumnet pair should be of the form property_name,val where
%   property_name is the name of one of the field in properties, and val is
%   the value to be assigned to that structure field.
%
%   No validation of the values is performed.
%%
% EXAMPLE:
%   properties = struct('zoom',1.0,'aspect',1.0,'gamma',1.0,'file',[],'bg',[]);
%   properties = getopt(properties,'aspect',0.76,'file','mydata.dat')
% would return:
%   properties =
%         zoom: 1
%       aspect: 0.7600
%        gamma: 1
%         file: 'mydata.dat'
%           bg: []
%
% Typical usage in a function:
%   properties = getopt(properties,varargin{:})

% Function from
% http://mathforum.org/epigone/comp.soft-sys.matlab/sloasmirsmon/bp0ndp$crq5@cui1.lmms.lmco.com

% dgleich
% 2003-11-19
% Added ability to pass a cell array of properties

if ~isempty(varargin) && (iscell(varargin{1}))
    varargin = varargin{1};
end;

% Process the properties (optional input arguments)
prop_names = fieldnames(properties);
TargetField = [];
for ii=1:length(varargin)
    arg = varargin{ii};
    if isempty(TargetField)
        if ~ischar(arg)
            error('Property names must be character strings');
        end
        %f = find(strcmp(prop_names, arg));
        if isempty(find(strcmp(prop_names, arg),1)) %length(f) == 0
            error('%s ',['invalid property ''',arg,'''; must be one of:'],prop_names{:});
        end
        TargetField = arg;
    else
        properties.(TargetField) = arg;
        TargetField = '';
    end
end
if ~isempty(TargetField)
    error('Property names and values must be specified in pairs.');
end