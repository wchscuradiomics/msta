function filters = contourfilters()

dbs = joinfname('db',1:10); % 1:45
coifs = joinfname('coif',1:5);
syms = joinfname('sym',2:10); % 2:45
fks = { 'fk4', 'fk6', 'fk8', 'fk14', 'fk22'}';
biors = {'bior1.1', 'bior1.3', 'bior1.5',...
  'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8',...
  'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7',...
  'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8'}';
rbios = {'rbio1.1', 'rbio1.3', 'rbio1.5',...
  'rbio2.2', 'rbio2.4', 'rbio2.6', 'rbio2.8',...
  'rbio3.1', 'rbio3.3', 'rbio3.5', 'rbio3.7',...
  'rbio3.9', 'rbio4.4', 'rbio5.5', 'rbio6.8'}';
fnames = [dbs;coifs;syms;fks;'dmey';biors;rbios;];
% pfilters = [{'9-7';'5-3';'Burt';'pkva'};
% fnames2filters(fnames,'pfilter')];
pfilters = [{'9-7';'5-3';'Burt';'pkva'}; fnames];
fnames = {'haar', '5-3', 'cd', '9-7'}';
% dfilters = ['pkva6'; 'pkva8'; 'pkva12'; 'pkva';
% fnames2filters(fnames,'dfilter')];
dfilters = ['pkva6'; 'pkva8'; 'pkva12'; 'pkva';  fnames];
filters = meshgridVectors({pfilters,dfilters});
end

function fnames = joinfname(prefix,series)
fnames = cell(length(series),1);
for i=1:length(series)
  fnames{i} = [prefix num2str(series(i))];
end
end

function filters = fnames2filters(fnames,tag)
filters = cell(length(fnames),1);
parfor i=1:length(fnames)
  if strcmpi(tag,'pfilter')
    filters{i} = wfilters(fnames{i}, 'l');
  elseif strcmpi(tag,'dfilter')
    filters{i} = dfilters(fnames{i}, 'd');
  end
end
end