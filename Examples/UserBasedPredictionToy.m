% Example to illustrate user-based and item-based similarity and
% recommendation

%           Matrix      Titanic     DieHard    ForrestGump     Wall-E
% John        5             1                       2             2
% Lucy        1             5           2           5             5
% Eric        2                         3           5             4
% Diane       4             3           5           3  
% Kim         1             4                       5

% Clearly Titanic, ForretGump, Wall-E are similar

X = [5 1 0 2 2; 1 5 2 5 5; 2 0 3 5 4; 4 3 5 3 0; 1 4 0 5 0];

% Lets calculate prediction for Kim
% Calculate PC similarity for Kim
[Y,PS] = removerows(X,'ind',[5]);
[K_sim, normX] = PCSimVecMatrix((X(5,:))', Y);

% Sort the similarities
% K_simsort = sort(K_sim)

% Let's pick users with similarity greater than 0.8
K_simusers = find(K_sim > 0.8);

% Calculate ratings for unrated movies
K = X(5,:);
[m n] = size(K);
K_unrated = zeros(1,n);
K_unrated(K == 0) = 1;

wtsum = sumabs(K_sim(K_simusers,:));

% K_usergen = X(K_simusers,:) .* repmat(K_sim(K_simusers,:),1,n);
% use normalized ratings to generate predicted ratings
K_usergen = normX(K_simusers,:) .* repmat(K_sim(K_simusers,:),1,n);

% sum the columns to get final prediction for each movie
K_usergen = sum(K_usergen,1)/wtsum;

K_ratedmean = sum(K)/nnz(K);

% generate ratings for the movie not rated by Kim. Pick the one with
% highest predicted rating
K_reco = K_usergen.*K_unrated
[val, movie] = max(K_reco)
K_bestrating = val + K_ratedmean
