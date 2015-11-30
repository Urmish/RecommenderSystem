clear all
close all
testX = ConvertUDataToMatrix('Data/u1.test');
testXValidUsers = sum(testX,2);
count=1;
size(testXValidUsers,1)
for i = 1:size(testXValidUsers,1)
%for i = 1:30
    if(testXValidUsers(i,1) ~= 0)
        i_testdata = 'Data/u1.base';
        i_singularValueThreshold = 0.3;
        i_predThreshold = 3.6;
        i_customerId = i;
        i_modelNumber = 1;
        i_iterCount = 100;
        i_NumNearestNeighbor = 20;
        i_knnDistanceMeasure = 'cosine';
        [x_pred,y_knn] = ModelBasedPredictionTest(i_testdata,i_singularValueThreshold,i_predThreshold,i_customerId, i_modelNumber, i_iterCount, i_NumNearestNeighbor, i_knnDistanceMeasure);
        filled_ind = find(testX(i,:) ~= 0);
        yaxis(count) = norm(x_pred(1,filled_ind)-testX(i,filled_ind),2);
        xaxis1(count) = count;
        [yaxis2(count) totalMoviesInTest(count)]= StepErrorFunction(testX(i,:),x_pred(1,:),0.5);
        count=count+1
    end
end
figure(1)
hold on
scatter(xaxis1,yaxis);
figure(2)
hold on
scatter(xaxis1,yaxis2);
mean1 = mean(yaxis./totalMoviesInTest)
mean2 = mean(yaxis2./totalMoviesInTest)
%Mean of 30 people for Model 0
%1. 0.4725
%2. 0.5625