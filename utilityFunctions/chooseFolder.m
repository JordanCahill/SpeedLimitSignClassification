function imageDir = chooseFolder()
% CHOOSEDIRECTORY Allows the user to choose the folder to process
%                 Note: Must be under '.\Pictures\*'

fprintf('Choose one of the following folders to process:\n(Type exactly as it appears, case insensitive)\n\n');

% Get the name of all subfolders of '.\Pictures'
d = dir('.\Pictures\');
isub = [d(:).isdir]; %# returns logical vector
subfolders = {d(isub).name}';
subfolders(ismember(subfolders,{'.','..'})) = []; % Remove '.' and '..'

% print all folders for the user to choose
for i = 1:length(subfolders)
    disp(subfolders{i});
end

folder = input('\nName of Folder: ', 's');

imageDir = strcat('.\Pictures\', folder);  % Store directory of 'All' folder

if ~isdir(imageDir)  % Check folder exists and warn user if it doesn't
    warning('[Error reading images]: Folder does not exist: %s\n Did you type it correctly?\n', imageDir);
    imageDir = chooseFolder();
end

fprintf('\n');

end

