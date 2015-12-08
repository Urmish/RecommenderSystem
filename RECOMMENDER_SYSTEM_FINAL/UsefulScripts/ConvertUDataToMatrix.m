function [ X ] = ConvertUDataToMatrix(i_filename)
%CONVERTUDATATOMATRIX - Converts i_filename to an mxn matrix where m is the
%number of users and n is the number of movies
% eg i_filename - 'Data/u.data'
fid = fopen(i_filename,'r');
InputText=textscan(fid,'%d\t%d\t%d\t%d');
m = max(unique(InputText{1})); %m is the number of users, InputText{1} is the list of users
%n = max(unique(InputText{2})); %n is the number of movies, InputText{2} is the list of movies rated
n = 1682;
X = zeros(m,n);
for i=1:length(InputText{1})
    X(InputText{1}(i),InputText{2}(i)) = InputText{3}(i);
end
fclose(fid);
end

