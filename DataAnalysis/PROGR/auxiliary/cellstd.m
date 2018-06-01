function S=cellstd(Cellvector,Distribution,NBins)
%% Performs the binned std of cell arrays, arranged in a vector. 
% works like cellmean
% Input:
% Cellvector: 1xN vector of cells containing vectors of doubles
% Distribution: 1xN some sort of timestamps to order the values contained
% in cellvector
% NBins: number of bins fo the mean
        M=cellmean(Cellvector,Distribution,NBins);

        limits=[min(cat(1,Distribution{:})) max(cat(1,Distribution{:}))];
        binsedges=linspace(limits(1),limits(2),NBins+1);
        S=zeros(1,NBins);
        for jj=length(Cellvector)            
            index=Distribution{jj}>binsedges(1:end-1) & ...
                Distribution{jj}<binsedges(2:end);
            for kk=1:NBins
                S(kk)=S(kk)+abs(mean(Cellvector{jj}(index(:,kk)))-M(kk)).^2;
            end
            
        end
        S=sqrt(S./(jj-1));


end