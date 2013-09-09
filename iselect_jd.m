function select = iselect_jd(s,titletext,h,style,presel)
    %
    % This function creates a button group for exclusive selection
    %
    % INPUTS :
    %   
    %       - s(j).text : text for selection j
    %       - s(j).info : help for selection j (optional)
    %   OR
    %       - s{j} : text for selection j 
    %
    %       - titletext : title for selection (optional)
    %
    %       - h (optional) : 
    %           o false : command line
    %           o true : in separate figure
    %           o handle : panel or figure handle for button group 
    %
    %       - style.position : position within parent handle h (optional)
    %       - style.fontname : name of font (optional)
    %       - style.fontsize : size of font (optional)
    %       - style.butheight : OK button height (optional)
    %       - style.butwidth : OK button width (optional)
    %       - style.buthsep : horizontal separation (optional)
    %       - style.butvsep : vertical separation (optional)
    %       
    %       - presel : pre-selected option (optional)
    %
    % OUTPUT : 
    %
    %       - select : index of selected option
    %
    if nargin < 4,
        style = struct;
    end
    %
    if nargin < 3 || ~isscalar(h) || (islogical(h) && ~h) || (~islogical(h) && ~ishandle(h))
        opt_gui = false;% command line
    else
        opt_gui = true;
        %
        if ishandle(h)
            newh = false;% existing handle
        else
            newh = true;% new fig
        end
    end
    %
    if nargin < 2,
        titletext = 'Please select one of the following :';
    end
    %
    if nargin < 1,
        error('Not enough arguments');
    end
    %
    if ~iscell(s) && (~isstruct(s) || (isstruct(s) && ~isfield(s,'text'))),
        error('wrong style for s');
    end
    %
    nb = length(s);
    %
    if nargin < 5 || ~isscalar(presel) || ~any(presel == 1:nb),
        presel = 1;
    end
    %
    if ~opt_gui,% command line
        %
        inputstr = [titletext,'\n'];
        %
        for j = 1:nb,
            %
            [bs,is] = getstr(s,j);
            %
            inputstr = [inputstr,'(',num2str(j),') ',bs,' [',is,']\n'];
            %
        end
        %
        select = input_dke_yp(inputstr,presel,1:nb,'Invalid selection.');    
        %
    else
        %
        if ~isfield(style,'fontname')
            style.fontname = 'fixedwidth';
        end
        %
        if ~isfield(style,'fontsize')
            style.fontsize = 10;
        end
        %
        if ~isfield(style,'butheight')
            style.butheight = 25;
        end
        %
        if ~isfield(style,'butwidth')
            style.butwidth = 60;
        end
        %
        if ~isfield(style,'buthsep')
            style.buthsep = 10;
        end
        %
        if ~isfield(style,'butvsep')
            style.butvsep = 10;
        end
        %
        if ~isfield(style,'position') || isnan(style.position),
            if ~isfield(style,'textwidth'),
                style.textwidth = 30*style.fontsize;
            end
            if ~isfield(style,'textheight'),
                style.textheight = 2*style.fontsize;
            end
            %
            width = style.textwidth + 3*style.buthsep + style.butwidth;
            height = (nb+1)*style.textheight + 3*style.butvsep;
            %
            style.position = [0,0,width,height];
            %
        end
        %
        width = style.position(3);
        height = style.position(4);
        %
        style.textwidth = width - style.butwidth - 3*style.buthsep;
        style.textheight = fix(height - 3*style.butvsep)/(nb+1);
        %
        if newh,
            h = figure('name','select','visible','on','menubar','none','numbertitle','off','resize','on','toolbar','none','units','pixels','position',style.position);
        end    
        %
        hpos = get(h,'position');
        %
        width = min([width,hpos(3)]);
        height = min([height,hpos(4)]);
        %
        style.position = [fix((hpos(3)-width)/2),fix((hpos(4)-height)/2),width,height];
        %
        p = uibuttongroup('Parent',h,'units','pixels','position',style.position);
        %
        title = uicontrol(p,'Style','text','String',titletext,'Position',[style.buthsep,height - style.buthsep - style.textheight,style.textwidth,style.textheight],'FontName',style.fontname,'FontUnits','pixels','FontSize',style.fontsize,'HorizontalAlignment','left');
        %
        b = NaN(1,nb);
        %
        for j = 1:nb,
            %
            [bs,is] = getstr(s,j);
            %
            b(j) = uicontrol('Parent',p,'Style','radiobutton','String',bs,'tooltipstring',is,'Position',[style.buthsep,height - 2*style.buthsep - (j+1)*style.textheight,style.textwidth,style.textheight],'FontName',style.fontname,'FontUnits','pixels','FontSize',style.fontsize);
            %
        end
        %
        ok = uicontrol(p,'Style','pushbutton','String','OK','Position',[2*style.buthsep + style.textwidth,style.buthsep,style.butwidth,style.butheight],'FontName',style.fontname,'FontSize',style.fontsize,'Enable','on','Callback','uiresume');
        %
        set(p,'SelectedObject',b(j));
        %
        uiwait;
        %
        select = find(b == get(p,'SelectedObject'));
        %
        if newh,
            delete(h);
        else
            delete(p);
        end
        %
    end
end
%
function [bs,is] = getstr(s,j)
    %
    if iscell(s) 
        if ischar(s{j}),
            bs = s{j};
            is = '';
        else
            error(['Warning : cell element # ',num2str(j),' ignored because not in string format.']);
        end
    else
        bs = s(j).text;
        if isfield(s,'info'),
            is = s(j).info;
        else
            is = '';
        end
    end        
    %
end
