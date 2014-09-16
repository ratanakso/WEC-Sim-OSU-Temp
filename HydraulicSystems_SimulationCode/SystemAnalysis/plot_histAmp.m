function stats = plot_histAmp(nameSys, sys, p)

% xlimit = p.xlimit; 
ylimit = p.ylimit; 
sigScale = p.sigScale;
titleStr = p.titleStr; 
sysStr = p.sysStr; 
nameSig = p.nameSig; 
xlab = p.xlab; 
xUpLim = p.xUpLim; 
nameSys = p.nameSys;

for i = 1:length(nameSys)
    
ti = 600; 
tf = sys(i,2).out.simData.time(end); 
timeTemp = sys(i,2).out.simData.time; 
[time, tind] = getTwindow(timeTemp, ti, tf);

% nBins = linspace(0,3.0,120);
[sig{i}, exttime{i}] = sig2ext(sys(i,2).out.simData.(nameSig{i}), time);
sig{i} = sig{i}*sigScale;
end

nBins = 90;
% Rainflow Counting
for i = 1:length(sig)
    ext = sig2ext(sig{:,i});
    rftemp = rainflow(ext);
    rfmax(:,i) = max(rftemp(1,:));
    
    stats.(nameSys{i}).maxLoad = max(rfmax(:,i)); 
% maxSig(:,i) = max(rfmax); 
% bins(:,i) = linspace(0, maxSig(:,i), nBins);
end    

maxSig = max(rfmax); 
bins = linspace(0, maxSig, nBins);



for i = 1:length(sig)
    ext = sig2ext(sig{:,i});
    rf = rainflow(ext);
    [n1(:,i), x1(:,i)] = rfhist(rf, bins);
    n(:,i) = n1(:,i); 
    x(:,i) = x1(:,i); 
    nsum = sum(n(:,i)); 
    n(:,i) = n(:,i)/nsum;
    
    stats.(nameSys{i}).avgLoad = sum(x(:,i).*n(:,i));
    stats.(nameSys{i}).totCycles = nsum;
    stats.(nameSys{i}).peak2avg = stats.(nameSys{i}).maxLoad/stats.(nameSys{i}).avgLoad;
%     avgLoadMat = ones(size(x,1),1)*avgLoad;
%     x(:,i) = x(:,i)/avgLoad;
end

figure
for i = 1:length(sig)
    
subplot(2,1,i)
bar(x(:,i), n(:,i), 'r','Barwidth', 1)
hy = ylabel('Cycle Probability');
% hx = xlabel('$$\frac{F}{F_{avg}}$$', 'interpreter', 'latex','fontsize', 14);
hx = xlabel(xlab);
ht = title([titleStr{i} ' -- ' sysStr{i}]);
hl = legend('dummy'); 
ylim(ylimit)
% ylim([0,800])
xlim([-(x(2,1) -x(1,1))/2, maxSig(:,i)])
grid on
prettyPlot(hx,hy,ht,hl);
delete(hl);

end

set(gcf, 'Outerposition', [-1220 331  729  713])
p1 = get(gca,'Position');

