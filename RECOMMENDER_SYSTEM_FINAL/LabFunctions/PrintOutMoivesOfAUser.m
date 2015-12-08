function [] = PrintOutMoivesOfAUser( i_MovieDatabase,i_userVector,i_mode )
%PRINTOUTMOIVESOFAUSER Prints out Names of the movies a user has viewed
%   i_MovieDatabase - Cell structure of names of movies sorted by id
%   i_userVector - Movies user has Rated, is an array of length 1682 or a
%   of arbitary length, depends on i_mode. Note, this requires a row vector
%   i_mode - 
%      0 - i_userVector is a vector of length 1682, with zeros being movie
%      not rated and ~=0 being movies rated
%      1 - i_userVector is a vector with movie ids
fprintf('************************\n');
fprintf('These are the Movies the user has rated\n');
fprintf('_______________________________________\n');
if (i_mode == 0)
    m_k = find(i_userVector~=0);
    for i=1:size(m_k,2)
        fprintf('%s\n',i_MovieDatabase{m_k(i)});
    end
else
    for i=1:size(i_userVector,2)
        fprintf('%s\n',i_MovieDatabase{i_userVector(i)});
    end
end
fprintf('************************\n');
end

