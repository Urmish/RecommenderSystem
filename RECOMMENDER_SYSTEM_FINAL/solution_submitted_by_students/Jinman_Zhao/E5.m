X = [5 1 0 2 2; 1 5 2 5 5; 2 0 3 5 4; 4 3 5 3 0; 1 4 0 5 0];
K = X(5,:);
Y = X(1:4,:);
[m,n] = size(X);
[PC, normX] = PCSimVecMatrix(K', X);
normK = normX(5,:);
normY = normX(1:4,:);
indSim = find(abs(PC(1:4))>0.8);

K_unrated = K == 0;
Y_rated = Y ~= 0;
wtsum = sum(Y_rated(indSim,:) .* repmat(abs(PC(indSim)),1,n), 1);
K_usergen = sum(normY(indSim,:) .* repmat(PC(indSim),1,n), 1) ./ wtsum;

K_reco = K_usergen .* K_unrated
[val, movie] = max(K_reco)
K_bestrating = val + K_ratedmean