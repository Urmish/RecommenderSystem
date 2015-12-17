% knn_threshold based using PC similarity and mean-centering
clear;

X = ConvertUDataToMatrix('Data/u2.base');

X_test = ConvertUDataToMatrix('Data/u2.test');

% fill the test matrix with zeros for unrated movies
% as well for users not there in test set
[m n] = size(X);
[mt nt] = size(X_test);
X_test = [X_test zeros(mt,n - nt)];
X_test = [X_test; zeros(m-mt,n)];

knn_threshold = 0.8
MAX_KNN = 100;
STEP_KNN = 10;
avg_error = [];
% avg_error = zeros(1,MAX_KNN/STEP_KNN + 1);
START_USER = 1;
END_USER = 462;

count = 1;
for knn_threshold=0.70:0.05:1
    rmse = zeros(1,END_USER - START_USER + 1);
    for id = START_USER:END_USER;
        
        % remove user of interest before finding similarity
        [Y,PS] = removerows(X,'ind',id);
        [K_sim, normX] = PCSimVecMatrix((X(id,:))', Y);
        
        % Let's pick users with similarity greater than threshold
        K_simusers = find(K_sim > knn_threshold);
        
        % Calculate ratings for unrated movies
        K = X(id,:);
        [m n] = size(K);
        K_unrated = zeros(1,n);
        K_unrated(K == 0) = 1;
        
        wtsum = sumabs(K_sim(K_simusers,:));
        
        % Multiply each rating of a user by his similarity weight
        K_usergen = normX(K_simusers,:) .* repmat(K_sim(K_simusers,:),1,n);
        % sum the columns i.e. for each movie get sum of weighted ratings
        K_usergen = sum(K_usergen,1)/wtsum;
        K_ratedmean = sum(K)/nnz(K);
        
        K_reco = K_usergen.*K_unrated;
        [val, movie] = max(K_reco);
        K_bestrating = val + K_ratedmean;
        
        [tval, tmovie] = max(X_test(id,:));
        
        % find movies for which rating present in test data
        test_indices = find(X_test(id,:) > 0);
        
        % zero ratings has 1s for movies rated in test data
        zero_ratings = zeros(1,1682);
        zero_ratings(test_indices) = 1;
        num_test_movies = sum(zero_ratings);
        reco_ratings = (K_reco + K_ratedmean) .* zero_ratings;
        
        % RMSE error
        error = norm((reco_ratings - X_test(id,:)),2) / num_test_movies;
        % Top 5 error
        % error = Top5Accuracy(reco_ratings, X_test(id,:));
        % Step Error Function
        % error = StepErrorFunction(X_test(id,:), reco_ratings, 0.5);
        % 
        
        if (num_test_movies == 0)
            display(['zero test movies for id ' num2str(id)])
            rmse(id - START_USER + 1) = 0;
        else
            rmse(id - START_USER + 1) = error/num_test_movies;
        end
    end
    knn_threshold
    % nan_indices = isnan(rmse);
    rmse(isnan(rmse)) = 0;
    avg_error(count) = mean(rmse);
    count = count + 1;
end