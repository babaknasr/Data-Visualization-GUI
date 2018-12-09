function unit = punit(parameter)

[p, ~, u] = property();
for i=1:length(p)
    if (strcmp(parameter,p{i}) == 1)
        unit = u{i};
        break
    end %if
end %i