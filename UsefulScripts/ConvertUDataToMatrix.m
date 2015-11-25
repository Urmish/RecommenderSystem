function [ X ] = ConvertUDataToMatrix()
%CONVERTUDATATOMATRIX - Converts u.data to an mxn matrix where m is the
%number of users and n is the number of movies
fid = fopen('Data/u.data','r');
InputText=textscan(fid,'%d\t%d\t%d\t%d');
m = length(unique(InputText{1})); %m is the number of users, InputText{1} is the list of users
n = length(unique(InputText{2})); %n is the number of movies, InputText{2} is the list of movies rated
X = zeros(m,n);
for i=1:length(InputText{1})
    X(InputText{1}(i),InputText{2}(i)) = InputText{3}(i);
end
fclose(fid);
end

