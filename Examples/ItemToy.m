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
% Kim rates Titanic and ForrestGump highly
K = X(5,:);
K = K';

prediction = zeros(1,5);

% Calculate the similarity of DieHard
id = 3;
K_D = removerows(K, 'ind', id);
[D_sim, normXt] = PCSimVecMatrix(X(:,id), Y);

% Let's pick movies with similarity greater than 0.5 and predict
D_sim(D_sim < 0.5) = 0;
D_rating = sum(D_sim.*K_D)/norm(D_sim,1);
prediction(id) = D_rating;

% Calculate the similarity of Wall-E
id = 5;
K_W = removerows(K, 'ind', id);
[W_sim, normXt] = PCSimVecMatrix(X(:,id), Y);

% Let's pick movies with similarity greater than 0.5 and predict
W_sim(W_sim < 0.5) = 0;
W_rating = sum(W_sim.*K_W)/norm(W_sim,1);
prediction(id) = W_rating;

% final recommendation
[val, movie] = max(prediction)


