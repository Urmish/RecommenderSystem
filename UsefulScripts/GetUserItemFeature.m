function [ o_matrix ] = GetUserItemFeature(i_matrix,i_goodThreshold,i_badThreshold)
%GETUSERITENFEATURE Returns a matrix with all the features related to a
%user
%i_matrix - input matrix representing ratings of each user
% i_goodThreshold - Threshold for movies user likes
% i_badThreshold - Threshold for movies user hates

m_movieGenre = ImportItemCSV();
m_genrePerUser = zeros(size(i_matrix,1),size(m_movieGenre,2));
m_matrix = i_matrix;
m_matrix(m_matrix>0 & m_matrix<=i_badThreshold) = -1;
m_matrix(m_matrix>=i_goodThreshold) = 1;
m_matrix(m_matrix~=0 & m_matrix~=-1 & m_matrix~=1) = 0;
length(m_matrix~=0)
for i=1:size(m_matrix,1)
    m_k = find(m_matrix(i,:)~=0);
    for j = 1:length(m_k)
        m_genrePerUser(i,:) = m_genrePerUser(i,:) + m_matrix(i,m_k(j))*m_movieGenre(m_k(j),:);
    end
end
m_genrePerUser(m_genrePerUser>0) = 1;
m_genrePerUser(m_genrePerUser<0) = -1;

[m_userInfo ~] = ImportUserInfo();

o_matrix = [m_userInfo m_genrePerUser]; %Age,Sex,Area,Genre(4-23)

end

