clear all
close all
testX = ConvertUDataToMatrix('Data/u1.test'); %Load the test vector
testXValidUsers = sum(testX,2);
count=1;
size(testXValidUsers,1)
predMatrix = [];
customerAverage = [];
for i = 1:size(testXValidUsers,1)
    if(testXValidUsers(i,1) ~= 0)
        i_testdata = 'Data/u1.base'; %Path to training dataset
        i_singularValueThreshold = 0.03; %Singular Value threshold, singular values below this with respect to max singular values are trimmed
        i_predThreshold = 0.5; %Threshold above which movies are considered good
        i_customerId = i; %Customer for whom prediction is being generated
        i_modelNumber = 0; %Model 0 - Average Based, Model 1 - Incremental SVD
        i_iterCount = 100; %Number of iteration count for SVD approach
        i_NumNearestNeighbor = 1; %Recommendation based on NN approach
        i_knnDistanceMeasure = 'cosine'; %Similarity matrix for NN based prediction
        i_printMovieNames = 0;
        if (i==1)
            [x_pred,x_knn,predMatrix,customerAverage] = ModelBasedPredictionTest(i_testdata,i_singularValueThreshold,3.6,i_customerId, i_modelNumber, i_iterCount, i_NumNearestNeighbor, i_knnDistanceMeasure, predMatrix,customerAverage,0,i_printMovieNames);
        else
            [x_pred,x_knn,predMatrix,customerAverage] = ModelBasedPredictionTest(i_testdata,i_singularValueThreshold,3.6,i_customerId, i_modelNumber, i_iterCount, i_NumNearestNeighbor, i_knnDistanceMeasure, predMatrix,customerAverage,1,i_printMovieNames);
        end
        filled_ind = find(testX(i,:) ~= 0);
        rsePred(count) = norm(x_pred(1,filled_ind)-testX(i,filled_ind),2); %Root Square Error
        rseKnn(count) = norm(x_knn(1,filled_ind)-testX(i,filled_ind),2); %Root Square Error
        xaxis1(count) = count;
        [totalMoviesFlippedPred(count) totalMoviesInTest(count) goodMoviesFlipped(count) totalGoodMoviesInTest(count)]= StepErrorFunction(testX(i,:),x_pred(1,:),i_predThreshold);
        [totalMoviesFlippedKnn(count)  dummy                    goodMoviesFlippedKnn(count) dummy]= StepErrorFunction(testX(i,:),x_knn(1,:),i_predThreshold);
        topRankIntersectionErrorPred(count) = Top5Accuracy(testX(i,:),x_pred(1,:));
        topRankIntersectionErrorKnn(count) = Top5Accuracy(testX(i,:),x_knn(1,:));
        count=count+1
    end
end
figure(1)
hold on
scatter(xaxis1,rsePred);
hold on
title('RMSE Prediction');
figure(2)
hold on
scatter(xaxis1,totalMoviesFlippedPred);
hold on
title('Total Movies Flipped Pred');

figure(3)
hold on
scatter(xaxis1,rseKnn);
hold on
title('RMSE Knn Based');
figure(4)
hold on
scatter(xaxis1,totalMoviesFlippedKnn);
hold on
title('Total Movies Flipped Knn');

%For Ratings Based on Predictions
%Calculating RMSE by comparing with test vector
array1 = rsePred./totalMoviesInTest;
array1(isnan(array1)) = 0;
array1(isinf(array1)) = 0;
RMSEPred = sum(array1,2)/sum(array1~=0,2)

%Average Values of Flipped Ratings for Movies.
%Flipped ratings are ratings of movies that the predictor got wrong in a
%binary sense. If a movie rating is > average+threshold then it is
%considered good and if it is < average-threshold then it is considered
%bad. We subject the predictions to similar thresholding and calculated
%the sum of good movies in test that prediction got wrong added with sum of bad movies in test that prediction got wrong
%array2 = totalMoviesFlippedPred./totalMoviesInTest;
%array2(isnan(array2)) = 0;
%array2(isinf(array2)) = 0;
%MeanFlippedMoviesPred = sum(array2,2)/sum(array2~=0,2)
MeanFlippedMoviesPred = mean(totalMoviesFlippedPred)
mean(totalMoviesInTest)
RatioMeanFlippedMoviesPred = MeanFlippedMoviesPred/mean(totalMoviesInTest)

%Average Values of Flipped Ratings for Good Movies.
%Same as above, we only do the entire process for good movies in test
%vector
%array3 = goodMoviesFlipped./totalGoodMoviesInTest;
%array3(isnan(array3)) = 0;
%array3(isinf(array3)) = 0;
%MeanGoodMoviesFlippedPred = sum(array3,2)/sum(array3~=0,2)
MeanGoodMoviesFlippedPred = mean(goodMoviesFlipped)
mean(totalGoodMoviesInTest)
MeanRatioGoodMoviesFlippedPred = MeanGoodMoviesFlippedPred/mean(totalGoodMoviesInTest)


%Average Value of Top Rank Intersection
MeanTopRankIntersectionPred = mean(topRankIntersectionErrorPred)

%For Ratings Based on KNN on Prediction
%Calculating RMSE by comparing with test vector
array4 = rseKnn./totalMoviesInTest;
array4(isnan(array4)) = 0;
array4(isinf(array4)) = 0;
RMSEKnn = sum(array4,2)/sum(array4~=0,2) %Will be high as a lot of movies that the user has rated in test vector would not have been rated his/her neighbors

%Average Values of Flipped Ratings for Movies.
%Flipped ratings are ratings of movies that the predictor got wrong in a
%binary sense. If a movie rating is > average+threshold then it is
%considered good and if it is < average-threshold then it is considered
%bad. We subject the predictions to similar thresholding and calculated
%the sum of good movies in test that prediction got wrong added with sum of bad movies in test that prediction got wrong
%array5 = totalMoviesFlippedKnn./totalMoviesInTest;
%array5(isnan(array5)) = 0;
%array5(isinf(array5)) = 0;
%MeanFlippedMoviesKnn = sum(array5,2)/sum(array5~=0,2)
MeanFlippedMoviesKnn = mean(totalMoviesFlippedKnn)
mean(totalMoviesInTest)
RatioMeanFlippedMoviesKnn = MeanFlippedMoviesKnn/mean(totalMoviesInTest)

%Average Values of Flipped Ratings for Good Movies.
%Same as above, we only do the entire process for good movies in test
%vector
%array6 = goodMoviesFlippedKnn./totalGoodMoviesInTest;
%array6(isnan(array6)) = 0;
%array6(isinf(array6)) = 0;
%MeanGoodMoviesFlippedKnn = sum(array6,2)/sum(array6~=0,2)
MeanGoodMoviesFlippedKnn = mean(goodMoviesFlippedKnn)
mean(totalGoodMoviesInTest)
MeanRatioGoodMoviesFlippedKnn = MeanGoodMoviesFlippedKnn/mean(totalGoodMoviesInTest)

%Average Value of Top Rank Intersection
MeanTopRankIntersectionKnn = mean(topRankIntersectionErrorKnn)