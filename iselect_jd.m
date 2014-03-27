function select = iselect_jd(s,titletext,h,style,presel,type)
    %
    % This function creates a button group or popupmenu for exclusive
    % selection, or an edit box for user input (see 'type')
    %
    % INPUTS :
    %   
    %       - s(j).text : text for selection j
    %       - s(j).info : help for selection j (optional)
    %   OR
    %       - s{j} : text for selection j 
    %   OR
    %       - {} : case of edit type
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
    %       - presel : pre-selected option (optional) : integer from 0:nb for buttongroup & popupmenu, string or numerical array for edit 
    %
    %       - type : type of GUI (optional) ex : buttongroup, popupmenu, edit
    %
    % OUTPUT : 
    %
    %       - select : index of selected option for buttongroup & popupmenu, string or numerical array for edit 
    %
    if nargin < 1,
        error('Not enough arguments');
    end
    %
    if nargin < 6 || ~ischar(type) || ~any(strcmp({'buttongroup','popupmenu','edit'},type)),
        if isempty(s),
            type = 'edit';
        else
            type = 'buttongroup';
        end
    end
    %
    if nargin < 4,
        style = struct;
    end
    %
    if nargin < 3 || ~isscalar(h) || (islogical(h) && ~h) || (~islogical(h) && (~ishandle(h) || h == 0))
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
        if strcmp(type,'edit'),
            titletext = 'Please provide input :';
        else
            titletext = 'Please select one of the following :';
        end
    end
    %
    if ~strcmp(type,'edit') && ~iscell(s) && (~isstruct(s) || (isstruct(s) && ~isfield(s,'text'))),
        error('wrong style for s in buttongroup or popupmenu type');
    elseif strcmp(type,'edit') && ~isempty(s),
        disp(['WARNING : First input argument ',inputname(1),' neglected in iselect_jd with type ''edit''']);
        s = {};
    end
    %
    nb = length(s);
    %
    if ~strcmp(type,'edit') && (nargin < 5 || ~isscalar(presel) || ~any(presel == 1:nb)),
        presel = 1;
    end
    %
    if ~opt_gui,% command line
        if ~strcmp(type,'edit'),
            %
            inputstr = [titletext,'\n'];
            %
            for j = 1:nb,
                %
                [bs,is] = getstr(s,j);
                %
                if ~isempty(is),
                    isstr = ['[',is,']'];
                else
                    isstr = '';
                end
                %
                inputstr = [inputstr,'(',num2str(j),') ',bs,' ',isstr,'\n'];
                %
            end
            %
            select = input_dke_yp(inputstr,presel,1:nb,'Invalid selection.');    
            %
        else
            %
            select = input_dke_yp(titletext,presel);
            %
        end
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
            if ~strcmp(type,'edit'),
                width = style.textwidth + 3*style.buthsep + style.butwidth;
            else
                width = style.textwidth + style.butwidth + style.longbutwidth + 4*style.buthsep;
            end
            %
            if strcmp(type,'buttongroup'),
                height = (nb+1)*style.textheight + 3*style.butvsep;
            else%if strcmp(type,'popupmenu'),
                height = style.textheight + 2*style.butvsep;
            end
            %
            style.position = [0,0,width,height];
            %
        end
        %
        width = style.position(3);
        height = style.position(4);
        %
        if ~strcmp(type,'edit'),
            style.textwidth = width - style.butwidth - 3*style.buthsep;
        else
            style.textwidth = width - style.butwidth - style.longbutwidth - 4*style.buthsep;
        end
        %
        if strcmp(type,'buttongroup'),
            style.textheight = fix(height - 3*style.butvsep)/(nb+1);
        elseif strcmp(type,'popupmenu'),
            style.textheight = height - 2*style.butvsep;
        end   
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
        if strcmp(type,'buttongroup'),
            p = uibuttongroup('Parent',h,'units','pixels','position',style.position);
            titleposition = [style.buthsep,height - style.buthsep - style.textheight,style.textwidth,style.textheight];
            %        
            b = NaN(1,nb);
        else
            p = uipanel('Parent',h,'Title','','units','pixels','Position',style.position);
            titleposition = [style.buthsep,height - style.buthsep - style.textheight + style.textheightcorr,style.textwidth,style.textheight];
            %
            str = cell(1,nb);
        end
        %
        title = uicontrol(p,'Style','text','String',titletext,'Position',titleposition,'FontName',style.fontname,'FontUnits','pixels','FontSize',style.fontsize,'HorizontalAlignment','left');
        %
        for j = 1:nb,
            %
            [bs,is] = getstr(s,j);
            %
            if strcmp(type,'buttongroup'),
                b(j) = uicontrol('Parent',p,'Style','radiobutton','String',bs,'tooltipstring',is,'Position',[style.buthsep,height - 2*style.buthsep - (j+1)*style.textheight,style.textwidth,style.textheight],'FontName',style.fontname,'FontUnits','pixels','FontSize',style.fontsize);
            else
                str{j} = bs;
            end
            %
        end
        %
        if strcmp(type,'buttongroup'),
            %
            ok = uicontrol(p,'Style','pushbutton','String','OK','Position',[2*style.buthsep + style.textwidth,style.buthsep,style.butwidth,style.butheight],'FontName',style.fontname,'FontSize',style.fontsize,'Enable','on','Callback','uiresume');
            %
            set(p,'SelectedObject',b(presel));
            %
            uiwait;
            %
            select = find(b == get(p,'SelectedObject'));
            %
        elseif strcmp(type,'popupmenu'),
            %
            b = uicontrol(p,'Style','popupmenu','String',str,'Value',presel,'Position',[2*style.buthsep + style.textwidth,style.buthsep,style.butwidth,style.butheight],'FontName',style.fontname,'FontUnits','pixels','FontSize',style.fontsize,'Callback','uiresume');
            %
            uiwait;
            %
            select = get(b,'Value');
            %
        else% edit
            %
            if isnumeric(presel),
                spresel = num2str(presel);
            else
                spresel = presel;
            end
            %
            b = uicontrol(p,'Style','edit','String',spresel,'Position',[2*style.buthsep + style.textwidth,style.buthsep,style.longbutwidth,style.butheight],'FontName',style.fontname,'FontUnits','pixels','FontSize',style.fontsize);
            ok = uicontrol(p,'Style','pushbutton','String','OK','Position',[3*style.buthsep + style.textwidth + style.longbutwidth,style.buthsep,style.butwidth,style.butheight],'FontName',style.fontname,'FontSize',style.fontsize,'Enable','on','Callback','uiresume');            
            %
            uiwait;
            %
            if isnumeric(presel),
                select = str2num(get(b,'String'));
            else
                select = get(b,'String');
            end
            %
        end
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
            bs = [' ',s{j}];
            is = '';
        else
            error(['Warning : cell element # ',num2str(j),' ignored because not in string format.']);
        end
    else
        bs = [' ',s(j).text];
        if isfield(s,'info'),
            is = s(j).info;
        else
            is = '';
        end
    end        
    %
end
