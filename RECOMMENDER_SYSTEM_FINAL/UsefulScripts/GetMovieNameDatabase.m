function [ o_MovieName ] = GetMovieNameDatabase()
%GETMOVIENAME Extracts Movie Name for each movie ID and returns an array
%with all movie names. To access the name of the ith movie do,
%o_MovieName(movieId);
m_fid = fopen('Data/u.item');
m_InputText=textscan(m_fid,'%d%s%*[^\n]','Delimiter','|');
fclose(m_fid);
o_MovieName = m_InputText{2};
end

