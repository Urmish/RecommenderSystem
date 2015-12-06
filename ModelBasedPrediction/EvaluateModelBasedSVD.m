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
        i_singularValueThreshold = 0.3; %Singular Value threshold, singular values below this with respect to max singular values are trimmed
        i_predThreshold = 3.6; %Threshold above which movies are considered good
        i_customerId = i; %Customer for whom prediction is being generated
        i_modelNumber = 0; %Model 0 - Average Based, Model 1 - Incremental SVD
        i_iterCount = 100; %Number of iteration count for SVD approach
        i_NumNearestNeighbor = 20; %Recommendation based on NN approach
        i_knnDistanceMeasure = 'cosine'; %Similarity matrix for NN based prediction
        if (i==1)
            [x_pred,y_knn,predMatrix,customerAverage] = ModelBasedPredictionTest(i_testdata,i_singularValueThreshold,i_predThreshold,i_customerId, i_modelNumber, i_iterCount, i_NumNearestNeighbor, i_knnDistanceMeasure, predMatrix,customerAverage,0);
        else
            [x_pred,y_knn,predMatrix,customerAverage] = ModelBasedPredictionTest(i_testdata,i_singularValueThreshold,i_predThreshold,i_customerId, i_modelNumber, i_iterCount, i_NumNearestNeighbor, i_knnDistanceMeasure, predMatrix,customerAverage,1);
        end
        filled_ind = find(testX(i,:) ~= 0);
        rse(count) = norm(x_pred(1,filled_ind)-testX(i,filled_ind),2); %Root Square Error
        xaxis1(count) = count;
        [totalMoviesFlipped(count) totalMoviesInTest(count) goodMoviesFlipped(count) totalGoodMoviesInTest(count)]= StepErrorFunction(testX(i,:),x_pred(1,:),0.5);
        topRankIntersection(count) = Top5Accuracy(testX(i,:),x_pred(1,:));
        count=count+1
    end
end
figure(1)
hold on
scatter(xaxis1,rse);
figure(2)
hold on
scatter(xaxis1,totalMoviesFlipped);

%Calculating RMSE by comparing with test vector
array1 = rse./totalMoviesInTest;
array1(isnan(array1)) = 0;
array1(isinf(array1)) = 0;
RMSE = sum(array1,2)/sum(array1~=0,2)

%Average Values of Flipped Ratings for Movies.
%Flipped ratings are ratings of movies that the predictor got wrong in a
%binary sense. If a movie rating is > average+threshold then it is
%considered good and if it is < average-threshold then it is considered
%bad. We subject the predictions to similar thresholding and calculated
%the sum of good movies in test that prediction got wrong added with sum of bad movies in test that prediction got wrong
array2 = totalMoviesFlipped./totalMoviesInTest;
array2(isnan(array2)) = 0;
array2(isinf(array2)) = 0;
MeanFlippedMovies = sum(array2,2)/sum(array2~=0,2)

%Average Values of Flipped Ratings for Good Movies.
%Same as above, we only do the entire process for good movies in test
%vector
array3 = goodMoviesFlipped./totalMoviesInTest3;
array3(isnan(array3)) = 0;
array3(isinf(array3)) = 0;
MeanGoodMoviesFlipped = sum(array3,2)/sum(array3~=0,2)

%Average Value of Top Rank Intersection
MeanTopRankIntersection = mean(topRankIntersection)