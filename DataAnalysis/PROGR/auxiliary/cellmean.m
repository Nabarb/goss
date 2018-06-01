function M=cellmean(Cellvector,Distribution,NBins)
%% Performs a binned mean of cell arrays, arranged in a vector. 
% this is useful when a mean of vectors with different lenghts is needed.
% Input:
% Cellvector: 1xN vector of cells containing vectors of doubles
% Distribution: 1xN some sort of timestamps to order the values contained
% in cellvector
% NBins: number of bins fo the mean
limits=[min(cat(1,Distribution{:})) max(cat(1,Distribution{:}))];
        binsedges=linspace(limits(1),limits(2),NBins+1);
        M=zeros(1,NBins);
        for jj=length(Cellvector)            
            index=Distribution{jj}>binsedges(1:end-1) & ...
                Distribution{jj}<binsedges(2:end);
            for kk=1:NBins
                M(kk)=M(kk)+mean(Cellvector{jj}(index(:,kk)));
            end
            
        end
        M=M./jj;

end