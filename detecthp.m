function index = detecthp(cel)
index = 0;
hp = hiddenprop();
for i=1:length(hp)
    if (strcmpi(cel,hp{i}) == 1)
        index = i;
        return
    end %if
end %i
