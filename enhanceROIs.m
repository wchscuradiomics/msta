function EROIs = enhanceROIs(ROIs,M)

EROIs = cell(size(ROIs));

for i=1:length(ROIs)
  EROIs{i} = enhance(ROIs{i},M);
end