function [index, quantify] = detect(cel)
index = 0;
quantify = -1;
[p, q, ~] = property();
for i=1:length(p)
    if (strcmpi(cel,p{i}) == 1)
        index = i;
        quantify = q(i);
        return
    end %if
end %i

