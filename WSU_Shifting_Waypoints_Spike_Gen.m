clear;

%rng(3);
rng(8);
% spoofspoofLevelArray: The degree of agreessiveness in drone GPS spoofing. Values indicate the magnitude by which the way points are continuously
% shifted towards the target direction the enemy wants the drone to go. The direction itself is randomly chosen at the begining of each simulation.
% The drone only has access to its own intentional acceleration (can not see acceleration due to wind/other effects). The drone can only learn about
% its operation in the normal condition with no interference. However it must detect deviation in all directions equally well without experiencing them.
% spoofLevelArray = [0 3 9 27 81]; 

% spoofLevelArray = [0 4 16 64 256]; 
spoofLevelArray = [0 3 9 27 81]; 

nSample =  1e4;%1e4;%1e4;%1e4; % number of time samples over entire flight path.
nSim =20;       % number of simulations of flight paths for each GPS spoof level condition

nSpoofLevel = numel(spoofLevelArray);

sig1 = nan(nSample,nSim,nSpoofLevel,'single');           % these are the continuous value signals we need to analyse 
sig2= nan(nSample,nSim,nSpoofLevel,'single');          % the must be converted to spikes somehow. probably 20 level encodings captures the most info
    
for iLevel = 1:nSpoofLevel
    for iSim = 1:nSim
         % magnitude of spoofing stays the same for each level but the direction of enemy base can be anywhere
        spoofLevel = spoofLevelArray(iLevel);        
        
        heading = randn(2,1);    
        heading = heading / norm(heading) * spoofLevel ;  % make magnitude of each simulation equal to the other of the same level

        %%% Make the path Resemble WSU letters. 
        xWay = [0 0 100 200 200 500 450 350 300 300 500 500 450 350 300 600 600 800 800];
        yWay = [0 -300 -200 -300 0 -33 0 0 -33 -133 -166 -266 -300 -300 -266 0 -300 -300 0];
        
        %%% Easy 
%         xWay = [0  0  50    50   100  100  150 ]; %true way points around the border of some facility
%         yWay = [0 100 100   200  200  150   0];
        %%% Medium difficulty
        %xWay = [0  0     50    50  80     0    0   90  100  100  150 ]; % True way points around the perimeter of some facility.
        %yWay = [0 100   100   200  200    250  300 300 200  150   0];   % The drone is tasked with guarding this perimeter
        
        %%% Make the path more diffuclt
        %xWay = [    25    25   175   275   290   260   190   440   405   420   490   570   580   535   460   380   380   790   790   930   660   570   570];
        %yWay = -[    25   385   375   300   190    85    30    25    75   155   190   245   310   370   380   355   400   400    10    10    10    40    10];
        
        nWay = numel(xWay);
        iWayArray = circshift(1:nWay,-1);         % Drone starts at waypoint 1 and its target is now waypoint two (circshift)
        iWay = iWayArray(1);
        
        d     = 5;         % Distance threshold to the waypoint at which the drone feels it has reached the waypoint
        aMax  =  100;     % maximum (intentional) acceleration. with Wind this can be exceeded.
        vDamp = 0.7;   % Velocity damping factor simulates air resistance.
        gain = 0.15;
        
        % initial states of the drone
        x = 0;     % position
        y = 0;
        vx = 0;    % velocity
        vy = 0;
        ax = 0;    % acceleration  (this is the input to the SNN)
        ay = 0;  
          
        xRec  = nan(nSample,1); %position and time recordings we assume these may be getting spoofed so we can't rely on any of them them
        yRec  = nan(nSample,1);        
        tRec  = nan(nSample,1);
        
        ayRec = nan(nSample,1);  % our own acceleration cannot be spoofed we can detect this locally so it's our only signal
        axRec = nan(nSample,1);
        
        windPower = .1;        % add some wind/turbulance to the acceleration at every time step to create unknown drift
 
        for ii = 1:nSample
            % if close switch to the next way point
            distance = sqrt((x-xWay(iWay))^2  +      (y-yWay(iWay))^2) ;
            if    distance      < d
                iWayArray = circshift(iWayArray,-1);
                iWay = iWayArray(1);
                 % add spoofing to the waypoint to guide the drone to enemy capture point
                xWay = xWay+heading(1); 
                yWay = yWay+heading(2);
            end
            % accelerate toward xWay yWay. Drone only has access to this signal
            ax =   max(min(xWay(iWay)-x,aMax),-aMax)*gain;
            ay =   max(min(yWay(iWay)-y,aMax),-aMax)*gain;
            
            %%%%%%%% Generate unknown acceleration due to wind. Drone can not access this signal.
            aWindx = randn*windPower;
            aWindy = randn*windPower;
            
            %%%%%%%% Calculate new velicity based on:
            %%%%%%%%     Previous velocity + intentional acceleration + unknown wind acceleration
            %%%%%%%%     Dampen velocity over time to simulate air resistance
            vx = (vx + ax + aWindx)*vDamp;
            vy = (vy + ay + aWindy)*vDamp;
            %%%%%%%% Calculate new position
            x  = x + vx;
            y  = y + vy;
            
            %%%%%%%%% Record states for display 
            axRec(ii) = ax;    %% Drone only has access to this (intentional acceleration)
            ayRec(ii) = ay;    %% Drone only has access to this (intentional acceleration)
            xRec(ii) = x;
            yRec(ii) = y;            
            tRec(ii) = ii;            
            
        end        
        if iSim == 1%iLevel % just show the first simulation for each spoof level
            figure(23534)
            subplot(2,nSpoofLevel,iLevel)
            plot3(xRec,yRec,tRec,'.-');
            xlabel('x');ylabel('y');zlabel('time');
            grid on; box on;
            if iLevel == ceil(nSpoofLevel/2)
                title(['Drone Path Over Entire Simulation GPS Spoof Level (Shifting):' newline  num2str(iLevel-1) newline ])
            else
                title([newline num2str(iLevel-1)])
            end
          set(gca,'fontsize',12)
            %title('drone x-y position over time')
            view(0,90)
            axis equal
            
            qq = 450; % five laps
            subplot(2,nSpoofLevel,nSpoofLevel+iLevel)
            plot3(xRec(1:qq),yRec(1:qq),tRec(1:qq),'.-');
            xlabel('x');ylabel('y');zlabel('time');
            grid on; box on;
            if iLevel == ceil(nSpoofLevel/2)
                title(['Drone Path Over Five Patrol Laps:' newline newline newline num2str(iLevel-1)])
            else
                title(num2str(iLevel-1))
            end
          set(gca,'fontsize',12)
            axis equal
            view(25,30);
            

            
        end
        % record signals for training single layer ODESA during flight. We can only train an ODESA network on nSim level = 0 trials.
        % The aim is to detect the non-zero spoof levels ideally the very lowest non zero one (level = 3) but we want to see at which spoof level we can detect it.                        
        sig1(:,iSim,iLevel) =  axRec; 
        sig2(:,iSim,iLevel) =  ayRec;

    end
end

%%
rr = 280;%450/5*2.8;
figure(164); clf;
for iLevel = 1:nSpoofLevel
    subplot(nSpoofLevel,1,iLevel);hold on;
    plot(sig1(1:rr,1,iLevel),'.-'); 
    plot(sig2(1:rr,1,iLevel),'.-'); 
    legend("Acceleration on X axis", "Acceleration on Y axis");
    grid on;  box on;
    if iLevel==1
        title(['Drone Path Over Three Patrol Laps' newline 'Spoof Level (Shift):' newline num2str(iLevel-1)])
    else
        title(num2str(iLevel-1))
    end
    
    
    if iLevel==3
        ylabel(' Intentional Drone Acceleration (m/s^2)')
    end
    
    if iLevel==nSpoofLevel
        xlabel('Time (s)')
    else
        xticklabels({})
    end
     ylim([-16 16])
     xlim([1 rr])
   set(gca,'fontsize',11)
end
%%
%%% The following plots show that the data isnt easy to separate these should be plotted together in the paper
 figure(1634564); clf;
for iLevel = 1:nSpoofLevel
    subplot(nSpoofLevel,1,iLevel);
    hold on;
    uuu = sig1(:,:,iLevel);
    histogram(uuu(:),100);
    grid on; box on;
    if iLevel==1
        title(['Histogram of Intentional Drone Acceleration in x Direction' newline 'Spoof Level('  num2str((iLevel-1)) ')  Shift = ' num2str(spoofLevelArray(iLevel)) ' m/waypoint'])
    else
         title(['Spoof Level('  num2str((iLevel-1)) ')  Shift = ' num2str(spoofLevelArray(iLevel)) ' m/waypoint']) 
    end
    
      
    if iLevel==3
        ylabel('Frequency')
    end
    
    if iLevel==nSpoofLevel
        xlabel('m/s^2')
    else
        xticklabels({})
    end
set(gca,'fontsize',12)
  xlim([-16 16])
end
  
 figure(2634564); clf;
for iLevel = 1:nSpoofLevel
    subplot(nSpoofLevel,1,iLevel);
    hold on;
    uuu = sig2(:,:,iLevel);
    histogram(uuu(:),100);
    grid on; box on;
    if iLevel==1
        title(['Histogram of Intentional Drone Acceleration in y Direction' newline 'Spoof Level('  num2str((iLevel-1)) ')  Shift = ' num2str(spoofLevelArray(iLevel)) ' m/waypoint'])
    else
         title(['Spoof Level('  num2str((iLevel-1)) ')  Shift = ' num2str(spoofLevelArray(iLevel)) ' m/waypoint']) 
    end
    
      
    if iLevel==3
        ylabel('Frequency')
    end
    
    if iLevel==nSpoofLevel
        xlabel('m/s^2')
    else
        xticklabels({})
    end
set(gca,'fontsize',12)
  xlim([-16 16])
end
       




%% Make events/spikes from our two intentional acceleration signal
% Possible event encoding:
% 
kk = 5;% this is the scale factor 
e1 = round(max(min(sig1*kk,kk*2),-2*kk));
e2 = round(max(min(sig2*kk,kk*2),-2*kk)); nUniqueChannels = numel(unique(e1(:)));


            

nChannel = 2*(kk*4+1);
unique(e1(:))';

uniqueCh1 = unique(e1(:))'+kk*2+1;
uniqueCh1 + nChannel/2 ;


eT_bad= []; % original data not for Ali
for iLevel = 1:nSpoofLevel
    for iSim = 1:nSim
        idx = 0;
        for ii = 2 : (nSample)
            idx         = idx + 1;
            eT_bad(iSim,iLevel).y(idx)    = e1(ii,iSim,iLevel)+ceil(nChannel/4);
            eT_bad(iSim,iLevel).ts(idx)   = ii;
            
            idx         = idx + 1;
            eT_bad(iSim,iLevel).y(idx)    = e2(ii,iSim,iLevel)+nChannel/2+ceil(nChannel/4);
            eT_bad(iSim,iLevel).ts(idx)   = ii;
        end
        
    end
end

eT= [];  
%%%%% data sparsified for Ali -----------------------------------------------------
%%%%% 1. no repeat events on the same channel 
%%%%% 2. minimum of four time steps between two events on the same channel
%%%%% 3. minimum of two time steps between ANY two events on ANY channel
for iLevel = 1:nSpoofLevel
    for iSim = 1:nSim
        idx = 0;
        for ii = 2 : (nSample)
            if e1(ii,iSim,iLevel)~=e1(ii-1,iSim,iLevel)
                idx         = idx + 1;
                eT(iSim,iLevel).y(idx)    = e1(ii,iSim,iLevel)+ceil(nChannel/4);
                eT(iSim,iLevel).ts(idx)   = 4*ii;
            end
            if e2(ii,iSim,iLevel)~=e2(ii-1,iSim,iLevel)
                idx         = idx + 1;
                eT(iSim,iLevel).y(idx)    = e2(ii,iSim,iLevel)+nChannel/2+ceil(nChannel/4);
                eT(iSim,iLevel).ts(idx)   = 4*(ii+0.5);
            end
            
        end
        
    end
end
%%% this plot is just for Ali to look at not to be published
figure(234645); clf; hold on;
plot(eT_bad(1,1).ts,'.-')
plot(eT(1,1).ts,'.-')
grid on; title('comparison of data for not for Ali (eT0) and for Ali (eT)')



% Show a typical example of spike patterns for each spoof case.
% Note that here we are looking at only the first sim for each case. In fact we train on all non-spoof sims and test on all the spoof sims.
figure(534531); clf;
pp = 300;
for jLevel = 1:nSpoofLevel
    subplot(5,1,jLevel); hold on;
    plot(eT(1,jLevel).ts(1:pp),eT(1,jLevel).y(1:pp),'.')
    grid on; box on;
    if jLevel==1
        title(['Spike Pattern for Drone Path Over Three Patrol Laps' newline 'Spoof Level (Shift):' newline num2str(jLevel-1)])
    else
        title(num2str(jLevel-1))
    end
    if jLevel==nSpoofLevel
        xlabel('Time (s)')
    else
        xticklabels({})
    end
    ylabel('Event Channel')
    ax(jLevel) = gca;
    xlim([1 eT(1,jLevel).ts(pp)])
    set(gca,'fontsize',11)
    ylim([0 nChannel+1])
end
%linkaxes(ax,'xy')
xlim([1 eT(1,jLevel).ts(pp)])




%% Check That Data Is Not Easy
meanD = nan(nChannel,nSim,nSpoofLevel);
for jLevel = 1:nSpoofLevel
    for jSim = 1:nSim
        
        yy = eT(jSim,jLevel).y;
        tt = eT(jSim,jLevel).ts;
        
        nEvent     = numel(tt);
        T          = nan(1,nChannel);
        eventCount = zeros(1,nChannel);
        D       = nan(1000,nChannel);
        
        
        for idx = 1:nEvent
            t = eT(jSim,jLevel).ts(idx);
            y = eT(jSim,jLevel).y(idx);
            eventCount(y) = eventCount(y) +1;
            if eventCount(y)>1
                D(eventCount(y)-1,y) =  t - T(y);
            end
            T(y) = t;
        end
        meanD(:,jSim,jLevel) = nanmean(D)';
    end
end

figure(645)
for jLevel = 1:nSpoofLevel
    subplot(1,nSpoofLevel,jLevel)
    imagesc(log10(meanD(:,:,jLevel)));
    caxis([1.5 4.5])
    
    set(gca,'fontsize',12)
    
    
    if jLevel == 1
        ylabel('Channel')
    else
        yticklabels({});
    end
    if jLevel == ceil(nSpoofLevel/2)
        xlabel('Simulation Index')
        title(['Mean Inter Spike Interval as a Function of Spoof Level:' newline num2str(jLevel)])
    else
        title([newline num2str(jLevel)])
    end
    if jLevel == nSpoofLevel
        originalSizeLast = get(gca, 'Position');
        hcb = colorbar;
        ylabel(hcb, 'Log10 (Mean Inter Spike Interval Per Channel)')        
      set(gca,'fontsize',12)
        set(gca, 'Position',originalSizeLast);
    end
end

figure(644); clf;
for jLevel = 1:nSpoofLevel
    mm = nanmean(meanD(:,:,jLevel),2);
    ss = nanstd(meanD(:,:,jLevel),1,2);
    subplot(nSpoofLevel,2,jLevel*2-1); hold on;
    plot(log10(mm),'.-');
    %plot(log10(ss),'o-');
    ylim([1.5 4.5])
    xlim([0 nChannel+1])
  
    grid on; box on;
    if jLevel == 1
        %legend({'mean','std'})
        title(['Mean Inter Spike Interval as a Function of Spoof Level:' newline num2str(jLevel-1)])
    else
        title( num2str(jLevel-1))
    end
    if jLevel == ceil(nSpoofLevel/2)
        ylabel(['Log10 (Mean Inter Spike Interval Per Channel)' newline])
    end
    if jLevel == nSpoofLevel
        xlabel('Channel');
    else
        xticklabels({});
    end
 set(gca,'fontsize',12)
    
    
    
    subplot(nSpoofLevel,2,jLevel*2); hold on;    
    plot(log10(ss),'.-');
    ylim([-1. 4.5])
    
    xlim([0 nChannel+1])
    
    grid on; box on;
    if jLevel == 1
        %legend({'mean','std'})
        title(['Std Inter Spike Interval as a Function of Spoof Level:' newline num2str(jLevel-1)])
    else
        title( num2str(jLevel-1))
    end
    if jLevel == ceil(nSpoofLevel/2)
        ylabel(['Log10(Std Dev Inter Spike Interval Per Channel)' newline])
    end
    if jLevel == nSpoofLevel
        xlabel('Channel');
    else
        xticklabels({});
    end
   set(gca,'fontsize',12)

    
    
    
    
    
end



%% % train
tau = 256;%32;128;                  % time surface decay
nBit = 8;
nNeuron = 8;
range = 2^nBit-1;
T = linspace(-1000,0,1000);
t = 0;
 % Look at different kernels
yExp = exp((T-t)/tau);
yLin = max((T-t)/tau/2,-1)+1;
yLinInt = round((max((T-t)/tau/2,-1)+1)*range)/range;
figure(5346345); clf; hold on;
plot(-T,yExp); 
plot(-T,yLin); 
plot(-T,yLinInt,'.-');
grid on; box on;
legend('Expon','Linear','Lin-Integer(4-bit)')
title('comparison of kernels linear 4-bit is best')


eta = 0.001;
thresholdFall = 0.0005;
w = rand(nChannel,nNeuron);  % neuron weights

thresh = 0.9 + 0.05*rand(1,nNeuron);
nEpochTrain = 100;
nEvent = numel(eT(1,1).ts);
TH = nan(nEvent*nEpochTrain,nNeuron,'single'); % keep a record of the thresholds for plotting
O = zeros(nEvent*nEpochTrain,nNeuron,'single'); % keep a record of the output for plotting
for iEpoch = 1:nEpochTrain
    T = zeros(1,nChannel)-1e99;
    for idx = 1:nEvent
        
        t = eT(1,1).ts(idx);
        y = eT(1,1).y(idx);
        T(y) = t;
        
        %ctx             = exp((T-t)/tau);  %% should use linear decay
        ctx             =  round((max((T-t)/tau/2,-1)+1)*range)/range;  % 4 bit linear decay is better than exponential
        %ctx             = ctx/norm(ctx);   % removing normalization
        dotProds = ctx*w;
        [C,winnerNeuron ]       = max(dotProds.*(dotProds > thresh));
        if all(C==0)
            thresh = thresh - thresholdFall;  % example value of  thresholdFall  is 0.002
        else
            w(:,winnerNeuron)           = w(:,winnerNeuron) + eta*(ctx(:)-w(:,winnerNeuron));  % example value of  eta  is 0.001            
            %w = round(w*256)/256;
            w = round(w*2^12)/2^12;
            %w(:,winnerNeuron)           = w(:,winnerNeuron)./norm(w(:,winnerNeuron));
            thresh(winnerNeuron)        = thresh(winnerNeuron) + eta *(C-thresh(winnerNeuron)); % same eta as weight update eta
            
            O(idx+nEvent*(iEpoch-1),winnerNeuron)         = 1;
        end
        TH(idx+nEvent*(iEpoch-1),:)        = thresh;
    end
end

figure(5345341);clf ;
subplot(2,1,1);
plot(movmean(TH,1000 ),'.-');
grid on;
%xlabel('Event Index')
ylabel('Neuronal Threshold')
title('Evolution of Thresholds During Training');
set(gca,'fontsize',13);
xlim([1 size(TH,1)]);
subplot(2,1,2);
plot(mean(movmean(O,1000),2)*nNeuron,'.-');
grid on;
xlabel('Event Index')
ylabel('# Output Spike/# Input Spike')
title('Network Missed Spike Rate During Training');
set(gca,'fontsize',13)
ylim([0 1]);
xlim([1 size(TH,1)]);

% figure(52534)
% plot((w+(1:nNeuron)*0.5)*9/5,'.-')
% grid on;
% xlabel('channel')
% ylabel('neuron index')
% title('neuron weights after training')
% set(gca,'fontsize',13)
% drawnow

figure(52534)
imagesc(w');
hcb = colorbar;
ylabel(hcb, 'Neuron Weight')
xlabel('Channel')
ylabel('Neuron Index')
title('Neuron Weights After Training')
set(gca,'fontsize',13)
axis equal
ylim([0.5 nNeuron+0.5])
xlim([0.5 nChannel+0.5])
drawnow


% Test on all simulation gather stats
finalEventRate = nan(nSim,nSpoofLevel);
for iLevel = 1:nSpoofLevel
    for iSim = 1:nSim
        nEvent = numel(eT(iSim,iLevel).ts);
        endEventIndex = ceil((nEvent*0.9:nEvent));
        O_TEST = zeros(nEvent,nNeuron,'single');
        T = zeros(1,nChannel)-1e99;
        for idx = 1:nEvent
            
            t = eT(iSim,iLevel).ts(idx);
            y = eT(iSim,iLevel).y(idx);
            T(y) = t;
            
            %ctx             = exp((T-t)/tau);
            ctx             = round((max((T-t)/tau/2,-1)+1)*range)/range;  % 4 bit linear decay is better than exponential
            %ctx             = ctx/norm(ctx);
            dotProds = ctx*w;
            [C,winnerNeuron ]       = max(dotProds.*(dotProds > thresh));
            if all(C==0)
                % do nothing
            else
                O_TEST(idx,winnerNeuron)         = 1;
            end
        end
        finalEventRate(iSim,iLevel) = mean(mean(O_TEST(endEventIndex,:)))*nNeuron;
    end
end



figure(89652);clf;
boxplot(1-finalEventRate);
grid on;
set(gca,'fontsize',13)
xlabel('GPS Spoof Level (Shift)')
xticklabels([0 1 2 3 4])
ylabel('Network Miss Rate')
title('SNN Activation as a Function of GPS Shifting')

drawnow

%% Test on a single simulation (just for plotting)
figure(5345342);clf
for iLevel = 1:nSpoofLevel
    iSim = 1;
    nEvent = numel(eT(iSim,iLevel).ts);
    O_TEST = zeros(nEvent,nNeuron,'single');
    dotProdArray_TEST= nan(nEvent,nNeuron,'single');
    
    T = zeros(1,nChannel)-1e99;
    for idx = 1:nEvent
        
        t = eT(iSim,iLevel).ts(idx);
        y = eT(iSim,iLevel).y(idx);
        T(y) = t;
        
        %ctx             = exp((T-t)/tau);
        ctx             =  round((max((T-t)/tau/2,-1)+1)*range)/range;  % 4 bit linear decay is better than exponential
        %ctx             = ctx/norm(ctx);
        dotProds = ctx*w;
        dotProdArray_TEST(idx,:) = dotProds;
        [C,winnerNeuron ]       = max(dotProds.*(dotProds > thresh));
        if all(C==0)
            % do nothing
        else
            O_TEST(idx,winnerNeuron)         = 1;
        end
    end
    
    
    subplot(2,nSpoofLevel,iLevel);
    plot(movmean(dotProdArray_TEST,1000 ),'.');
    grid on;
    if iLevel == 1
        ylabel('Membrane Potential')
    end
    if iLevel== ceil(nSpoofLevel/2)
        title(['Membrane Potential During Testing. GPS Spoof Level:' newline num2str(iLevel-1)]);
    else
        title([newline num2str((iLevel-1))]);
    end
        
      xlim([1 size(O_TEST,1)]);
    set(gca,'fontsize',13)
%     ylim([1.5 4])
     
    subplot(2,nSpoofLevel,iLevel+nSpoofLevel);
    plot(mean(movmean(O_TEST,1000),2)*nNeuron,'.');
    grid on;
    xlabel('Event Index')
    if iLevel == 1
        ylabel('Output Spike / Input Spike')
    end
      if iLevel== ceil(nSpoofLevel/2)
        title(['Output Spike Rate During Testing. GPS Spoof Level:' newline num2str(iLevel-1)]);
    else
        title([newline num2str((iLevel-1))]);
      end
    
      xlim([1 size(O_TEST,1)]);

    set(gca,'fontsize',13)
    ylim([0 1])
    
    drawnow
end


%% Ali Spike Generation Code


nEvent = numel(eT(1,1).ts);
em = zeros(1,nChannel);

for idx = 1:nEvent
    t = eT(1,1).ts(idx);
    y = eT(1,1).y(idx);
    %T(y) = t;
    em(t)=y;
end

fileID = fopen('newexp1.csv','w');
maxTimeSteps = size(em,2);
for jj=1:maxTimeSteps   
    fprintf(fileID, '%d\n', em(jj));
end  
fclose(fileID);


nEvent = numel(eT(1,2).ts);
em = zeros(1,nChannel);

for idx = 1:nEvent
    t = eT(1,2).ts(idx);
    y = eT(1,2).y(idx);
    %T(y) = t;
    em(t)=y;
end

fileID = fopen('newexp2.csv','w');

maxTimeSteps = size(em,2);
for jj=1:maxTimeSteps    
    fprintf(fileID, '%d\n', em(jj));
end  
fclose(fileID);
%%%%%%%%%%%%
nEvent = numel(eT(1,3).ts);
em = zeros(1,nChannel);

for idx = 1:nEvent
    t = eT(1,3).ts(idx);
    y = eT(1,3).y(idx);
    %T(y) = t;
    em(t)=y;
end
fileID = fopen('newexp3.csv','w');

maxTimeSteps = size(em,2);
for jj=1:maxTimeSteps     
    fprintf(fileID, '%d\n', em(jj));
end  
fclose(fileID);

%%%%%%%%%%%%
nEvent = numel(eT(1,4).ts);
em = zeros(1,nChannel);

for idx = 1:nEvent
    t = eT(1,4).ts(idx);
    y = eT(1,4).y(idx);
    em(t)=y;
end
fileID = fopen('newexp4.csv','w');

maxTimeSteps = size(em,2);
for jj=1:maxTimeSteps     
    fprintf(fileID, '%d\n', em(jj));
end  
fclose(fileID);






