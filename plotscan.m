function [] = plotscan(scandisplay)
%
data = scandisplay.data;
value = scandisplay.scan(scandisplay.iscan).value;
%
if length(scandisplay.scan(scandisplay.iscan).value) == 1,
    xlim = [scandisplay.scan(scandisplay.iscan).value-0.1,scandisplay.scan(scandisplay.iscan).value+0.1];
else
    xlim = [min(scandisplay.scan(scandisplay.iscan).value),max(scandisplay.scan(scandisplay.iscan).value)];
end
%
figure('Name',[scandisplay.ylabel,' = f(',scandisplay.scan(scandisplay.iscan ).label,')']),clf
%
if isfield(scandisplay,'y_axis')
    graph1D_jd(value,data,0,0,[scandisplay.scan(scandisplay.iscan).label,' (',scandisplay.scan(scandisplay.iscan).unit,')'],scandisplay.ylabel,scandisplay.title,NaN,xlim,scandisplay.y_axis,scandisplay.style,scandisplay.marker,scandisplay.color,scandisplay.width);
    scandisplay = rmfield(scandisplay,'y_axis');
else
    graph1D_jd(value,data,0,0,[scandisplay.scan(scandisplay.iscan).label,' (',scandisplay.scan(scandisplay.iscan).unit,')'],scandisplay.ylabel,scandisplay.title,NaN,xlim,NaN,scandisplay.style,scandisplay.marker,scandisplay.color,scandisplay.width);
end 
%
maxlegendscan = 0;
for jscan = 1:length(scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).value),
    legendscan{jscan} = [scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).label,' = ',num2str(scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).value(jscan)), ' (',scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).unit,')'];
    lengthlegendscan(jscan) = length(legendscan{jscan});
end
%
full_legend='';
for jscan = 1:length(scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).value),
    lengthchainblank = max(lengthlegendscan) - length(legendscan{jscan});
    chainblank = '';for ichainblank = 1:lengthchainblank,chainblank = [chainblank,' '];end
    legendscan{jscan} = [legendscan{jscan},chainblank];
    full_legend = [full_legend;legendscan{jscan}];
end
%
legend(full_legend);
%
print_jd(scandisplay.p_opt,[scandisplay.id_simul,'_J_Peak_profile'],[scandisplay.path_simul,'FIGURES','/']);
%
if isfield(scandisplay,'profile') && isfield(scandisplay.profile,'mode') && scandisplay.profile.mode,
    %
    for iscan = 1:length(scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).value),
         %
        figure('Name',[scandisplay.profile.ylabel,' @ ',scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).label,' = ',num2str(scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).value(iscan)),' ',scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).unit]),clf
        title = [scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).label,' = ',num2str(scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).value(iscan)),' (',scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).unit,')'];
        %
        ylim_min = Inf;
        ylim_max = -Inf;
        %
        legendscan = '';
        maxlegendscan = 0;
        full_legend='';
        %
        for jscan = 1:length(scandisplay.scan(scandisplay.iscan).value),
            %
            if scandisplay.iscan == 1,
                isim = iscan + (jscan-1)*length(scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).value);
            else
                isim = jscan + (iscan-1)*length(scandisplay.scan(scandisplay.iscan).value);
            end
            %
            %[iscan,jscan,isim]
            %
            if isstruct(scandisplay.procdata{isim}),
                ylim_min = min(ylim_min,min(scandisplay.procdata{isim}.radial.(scandisplay.profile.field)));
                ylim_max = max(ylim_max,max(scandisplay.procdata{isim}.radial.(scandisplay.profile.field)));
                %
               legendscan{jscan} = [scandisplay.scan(scandisplay.iscan).label,' = ',num2str(scandisplay.scan(scandisplay.iscan).value(jscan)), ' (',scandisplay.scan(scandisplay.iscan).unit,')'];
                if  maxlegendscan == 0,
                    lengthchainblank = 0;
                else   
                    lengthchainblank = maxlegendscan - length(legendscan{jscan});
                end
                %
                if lengthchainblank >= 0,
                    chainblank = '';for ichainblank = 1:lengthchainblank,chainblank = [chainblank,' '];end
                    legendscan{jscan} = [legendscan{jscan},chainblank];
                    full_legend = [full_legend;legendscan{jscan}];%add the new legend
                else
                    lengthchainblank = abs(maxlegendscan - length(legendscan{jscan}));
                    %
                    chainblank = '';for ichainblank = 1:lengthchainblank,chainblank = [chainblank,' '];end
                    mchainblank = char(ones(size(full_legend,1),1)*chainblank);
                    full_legend = [full_legend,mchainblank];%enlarge all existing legends  
                    full_legend = [full_legend;legendscan{jscan}];%add the new legend
                end
                %
                maxlegendscan = max(maxlegendscan,length(legendscan{jscan}));%upadate the fixed length of the legends
                %
            end
            %
        end
        %
        for jscan = 1:length(scandisplay.scan(scandisplay.iscan).value),
            %
            if scandisplay.iscan == 1,
                isim = iscan + (jscan-1)*length(scandisplay.scan(scandisplay.iscan + (-1)^(scandisplay.iscan+1)).value);
            else
                isim = jscan + (iscan-1)*length(scandisplay.scan(scandisplay.iscan).value);
            end
            %
            %[iscan,jscan,isim]
            %
            if isstruct(scandisplay.procdata{isim}),
                graph1D_jd(scandisplay.procdata{isim}.radial.xrhoG,scandisplay.procdata{isim}.radial.(scandisplay.profile.field),0,0,'r/a','J (MA/m^2)',title,NaN,[0,1],[ylim_min,ylim_max],'-',scandisplay.profile.markers{max(1,rem(jscan,length(scandisplay.profile.markers)))},scandisplay.profile.colors{max(1,rem(jscan,length(scandisplay.profile.colors)))},2);
            end
        end
        %
        legend(full_legend);
        %  
    end
end