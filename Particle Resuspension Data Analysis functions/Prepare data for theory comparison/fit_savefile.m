function fit_savefile(varargin)
% varargin: globtdb,filepath,state
%state represents the way this function has been called
% 0: from current database (deafault)
% 1: from load database - save to another file
globtdb = varargin{1};
filepath = varargin{2};
state = 0;
if (nargin > 2)
    state = varargin{3};
end %if
for i=1:size(globtdb,1)
    tdb = globtdb{i,1};
    filename = ['fit_', globtdb{i,2}, '.mat'];
    ffile = [filepath, filesep, filename];
    if (state == 1) && (exist(ffile,'file') == 2)
        filename = ['fit_', globtdb{i,2}, '_modified.mat'];
    end %if
    ffile = [filepath, filesep, filename];
    save(ffile,'tdb','-mat')
end %i
