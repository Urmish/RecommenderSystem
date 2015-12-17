function f = functions_(),
    f.predict_ratings_for_user = @predict_ratings_for_user;
end

function K_reco = predict_ratings_for_user(i, R, threshold),
    % Lets calculate prediction for Kim
    % Calculate PC similarity for Kim
    X = R*1.0;
    [Y,PS] = removerows(X,'ind',[i]);
    [K_sim, normX] = PCSimVecMatrix((X(i,:))', Y);

    % Sort the similarities
    % K_simsort = sort(K_sim)

    % Let's pick users with similarity greater than 0.8
    K_simusers = find(K_sim > threshold);

    % Calculate ratings for unrated movies
    K = X(i,:); % Kim's row
    [m n] = size(K);
    K_unrated = zeros(1,n); % unrated
    K_unrated(K == 0) = 1; % where haven't we rated?

    wtsum = sumabs(K_sim(K_simusers,:));

    % K_usergen = X(K_simusers,:) .* repmat(K_sim(K_simusers,:),1,n);
    % use normalized ratings to generate predicted ratings
    K_usergen = normX(K_simusers,:) .* repmat(K_sim(K_simusers,:),1,n);

    % sum the columns to get final prediction for each movie
    K_usergen = sum(K_usergen,1)/wtsum;

    K_ratedmean = sum(K)/nnz(K);

    % generate ratings for the movie not rated by Kim. Pick the one with
    % highest predicted rating
    K_reco = K_usergen.*K_unrated;
    [val, movie] = max(K_reco);
    K_bestrating = val + K_ratedmean;
end
