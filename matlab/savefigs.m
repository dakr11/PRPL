function savefigs(FolderName, varargin)

    mkdir(FolderName);
    
    FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
    for iFig = 1:length(FigList)
      FigHandle = FigList(iFig);
      FigName   = get(FigHandle, 'Name');
      set(0, 'CurrentFigure', FigHandle);
      
      if numel(varargin) == 1
          suffix = varargin{1};
          saveas(FigHandle, fullfile(FolderName,strcat(suffix, FigName, '.png')));
      else
          saveas(FigHandle, fullfile(FolderName,strcat(FigName, '.png')));  
      end
    end

end