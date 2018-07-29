function map = GuiSmaps(nAgents,val)
    if strcmp(val,'All Pairs')
        map = createMcomplete(nAgents,2);
    elseif strcmp(val,'Circle')
        map = createCircle(nAgents);
    elseif ~isempty(regexp(val,'Star', 'once'))
        map = createMstar(nAgents,str2num(val(1)));
    else
        map = createMcomplete(nAgents,str2num(val(1)));
    end
end