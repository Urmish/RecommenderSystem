function [o_item] = ImportItemCSV()
%IMPORTITEMCSV Imports item_data.csv which has the information related to
%genre of movie and its year
%o_item is a number_of_movies*20 matrix. 1st column is the year the movie
%was released, 0000 for unknown origin while Next 19 column are for genre.
%a value of one in the column indicates that the movie is of that genre.

o_item = csvread('Data/item_data.csv');
o_item = o_item(:,2:end);

end

