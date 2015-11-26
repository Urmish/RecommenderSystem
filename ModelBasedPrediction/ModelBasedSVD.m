clear;
close all;
% Parameter Values
singularValueThreshold = 0.8;
predThreshold = 3.5;
customerId = 192;
modelNumber = 0; %0 - Average Value based %1 - Incremental SVD based
iterCount = 100; %Used by Incremental SVD

X = ConvertUDataToMatrix();
if (modelNumber == 0)
    [Pred, AveragePerCustomer] = AverageValueBasedMatrixCompletion(X',singularValueThreshold);
    Pred = Pred';
    AveragePerCustomer = mean(Pred);
else
    [Pred, AveragePerCustomer] = IncrementalLowRankCompletion(X,iterCount,singularValueThreshold);
end

%Error
index_nonzero = find(X~=0);
error = norm(X(index_nonzero) - Pred(index_nonzero))/norm(X(index_nonzero));
%Prediction

if (predThreshold > AveragePerCustomer(customerId))
    possibleRecommendation = Pred(customerId,:)>predThreshold;
    removeRecommendation = X(customerId,:)~=0;
    possibleRecommendation(removeRecommendation) = 0;
    moviesUnSorted = Pred(customerId,possibleRecommendation);
    [SortedMovies, Index] = sort(moviesUnSorted);
    if (size(SortedMovies,2) == 0)
        fprintf('No movies beyond the threshold\n');
    else
        fprintf('Top 5 movies are - ');
        Index(1,5)
    end
else
    fprintf('Average Values for this customer have been high and it is difficult to comeup with a prediction using this technique\n');    
end

%Nearest Neighbor

