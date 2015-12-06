fid = fopen('Data/u1.base','r');
InputText=textscan(fid,'%d\t%d\t%d\t%d');
m = length(unique(InputText{1})); %m is the number of users, InputText{1} is the list of users
n = length(unique(InputText{2})); %n is the number of movies, InputText{2} is the list of movies rated
X = zeros(m,n);
for i=1:length(InputText{1})
    X(InputText{1}(i),InputText{2}(i)) = InputText{3}(i);
end
fclose(fid);

fid = fopen('Data/u1.test','r');
InputText=textscan(fid,'%d\t%d\t%d\t%d');
m = length(unique(InputText{1})); %m is the number of users, InputText{1} is the list of users
n = length(unique(InputText{2})); %n is the number of movies, InputText{2} is the list of movies rated
X_test = zeros(m,n);
for i=1:length(InputText{1})
    X_test(InputText{1}(i),InputText{2}(i)) = InputText{3}(i);
end
fclose(fid);
[m n] = size(X);
[mt nt] = size(X_test);
X_test = [X_test zeros(mt,n - nt)];
X_test = [X_test; zeros(m-mt,n)];

MAX_KNN = 10;
STEP_KNN = 5;
avg_rmse = zeros(1,MAX_KNN/STEP_KNN + 1);
START_USER = 1;
END_USER = 1;

count = 1;
for knn=1:STEP_KNN:MAX_KNN
    rmse = zeros(1,END_USER - START_USER + 1);
    for id = START_USER:END_USER; % let's predict for user1
        
%         X_rated_or_not = X;
%         X_rated_or_not(X~=0) = 1;
%         X_ratings_per_row = [];
%         X_ratings_per_row = sum(X_rated_or_not,2);
%         X_ratings_per_row(id);
%         
%         
%         Xtest_rated_or_not = X_test;
%         Xtest_rated_or_not(X_test~=0) = 1;
%         Xtest_ratings_per_row = [];
%         Xtest_ratings_per_row = sum(Xtest_rated_or_not,2);
%         Xtest_ratings_per_row(id);
%         
%         X(1,1:10);
%         X_test(1,1:10);
%         sumabs(X_rated_or_not(id,:) - Xtest_rated_or_not(id,:));
%         
        [Y,PS] = removerows(X,'ind',id);
        [K_sim, normX] = PCSimVecMatrix((X(id,:))', Y);
        
        % Let's pick users with similarity greater than 0.8
        % K_simusers = find(K_sim > 0.80);
        [sortedX,sortingIndices] = sort(K_sim,'descend');
        sortedX(1:knn);
        K_simusers = sortingIndices(1:knn);
        % maxValues = sortedX(1:50)
        % Calculate ratings for unrated movies
        K = X(id,:);
        [m n] = size(K);
        K_unrated = zeros(1,n);
        K_unrated(K == 0) = 1;
        
        wtsum = sumabs(K_sim(K_simusers,:));
        % K_usergen = X(K_simusers,:) .* repmat(K_sim(K_simusers,:),1,n);
        K_usergen = normX(K_simusers,:) .* repmat(K_sim(K_simusers,:),1,n);
        % sum the columns
        K_usergen = sum(K_usergen,1)/wtsum;
        K_ratedmean = sum(K)/nnz(K);
        
        K_reco = K_usergen.*K_unrated;
        [val, movie] = max(K_reco);
        K_bestrating = val + K_ratedmean;
        
        [tval, tmovie] = max(X_test(id,:));
        % X_test(id,6)
        % K_reco(6) + K_ratedmean
        test_indices = find(X_test(id,:) > 0);
        zero_ratings = zeros(1,1682);
        zero_ratings(test_indices) = 1;
        num_test_movies = sum(zero_ratings);
        reco_ratings = (K_reco + K_ratedmean) .* zero_ratings;
        % nnz(reco_ratings);
        error = norm((reco_ratings - X_test(id,:)),2);
        if (num_test_movies == 0)
            display(['zero test movies for id ' num2str(id)])
            rmse(id - START_USER + 1) = 0;
        else
            rmse(id - START_USER + 1) = error/num_test_movies;
        end
    end
    knn
    avg_rmse(count) = mean(rmse);
    count = count + 1;
end