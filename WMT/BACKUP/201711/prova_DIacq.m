s = daq.createSession('ni');
addDigitalChannel(s,'Dev3','Port0/Line0','inputOnly');
ready = 1;
tic;
while ready
    [data,triggerTime] = inputSingleScan(s);
    if data==0
        ready = 0;
    end
end
pressTime = toc;
