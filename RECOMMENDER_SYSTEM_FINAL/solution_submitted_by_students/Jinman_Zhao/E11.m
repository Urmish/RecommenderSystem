X = ConvertUDataToMatrix('Data/u1.base');
Xtest = ConvertUDataToMatrix('Data/u1.test');

threshold = 0.05;
n_iter = 100;
X_comp_isvd = IncrementalLowRankCompletion(X, n_iter, threshold);
X_comp_avsvd = AverageValueBasedMatrixCompletion(X, threshold);

icustomer = 100;
K = Xtest(icustumer,:);
ratings = K' * X_comp_isvd;
[sortedRatings, index] = sort(ratings, 'descend');

i5 = index(1:5)
K(i5)
ratings(i5)
