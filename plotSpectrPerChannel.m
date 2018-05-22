function F=plotSpectrPerChannel(S,fs)

[NComponent,Nsamples]=size(S);
NFFT=2^nextpow2(Nsamples);
F_=fft(S,NFFT,2);
f=linspace(0,fs/2,2^(nextpow2(Nsamples)-1));

F=abs(F_(:,1:end/2).^2);
% F=F_(:,f<80);
% f=f(f<80);

if nargout<1
    CompVec=reshape(repmat(1:NComponent+1,2,1),1,(NComponent+1)*2);
    figure
    [XX,YY]=meshgrid(f,CompVec(2:end));
    imagesc(f,1:NComponent,F)
%     mesh(XX, YY, [F(CompVec(1:end-2),:);zeros(1,length(F))]);
    caxis(caxis*.7e-1);
    view(0,90);
    ylim([1,NComponent+1])
    xlabel('freq');
    ylabel('#Compnent')
    yticks( 1.5:(NComponent+.5));
    lables=cell(1,NComponent);
    for i=1:NComponent,lables{i}=num2str(i);end
    yticklabels(lables);
end