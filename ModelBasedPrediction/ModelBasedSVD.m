clear;
close all;
% Parameter Values
singularValueThreshold = 0.7;
predThreshold = 3.6;
customerId = 192;
modelNumber = 1; %0 - Average Value based %1 - Incremental SVD based
iterCount = 100; %Used by Incremental SVD
NumNearestNeighbor = 20;
knnDistanceMeasure = 'cosine';

X = ConvertUDataToMatrix();
if (modelNumber == 0)
    [Pred, ~] = AverageValueBasedMatrixCompletion(X',singularValueThreshold);
    Pred = Pred';
    AveragePerCustomer = mean(Pred,2);
else
    [Pred, AveragePerCustomer] = IncrementalLowRankCompletion(X,iterCount,singularValueThreshold);
end

%Error
index_nonzero = find(X~=0);
error = norm(X(index_nonzero) - Pred(index_nonzero))/norm(X(index_nonzero));
%Prediction
fprintf('Prediction Based Recommendation - \n');
if (predThreshold > AveragePerCustomer(customerId))
    possibleRecommendation = Pred(customerId,:)>predThreshold;
    removeRecommendation = X(customerId,:)~=0;
    possibleRecommendation(removeRecommendation) = 0;
    moviesUnSorted = Pred(customerId,possibleRecommendation);
    [SortedMovies, Index] = sort(moviesUnSorted,'descend');
    if (size(SortedMovies,2) == 0)
        fprintf('No movies beyond the threshold\n');
    else
        fprintf('Top 5 movies are - ');
        Index(1,1:5)
    end
else
    fprintf('Average Values for this customer have been high and it is difficult to comeup with a prediction using this technique\n');    
end

fprintf('*********************************\n');
%Nearest Neighbor
[U S V] = svd(Pred,'econ');
Sk = TopKEigenValues(diag(S),singularValueThreshold);
k = sum(Sk~=0);
Uk = U(:,1:k);
Sk = diag(Sk);
Sk = Sk(1:k,1:k);
NNMatrix = Uk*(Sk.^0.5);
Mdl = KDTreeSearcher(NNMatrix);
[n,d] = knnsearch(Mdl,NNMatrix(customerId,:),'k',NumNearestNeighbor+1);
n = n(1,2:NumNearestNeighbor+1); %As the first column is the customer himself
HighRatedMoviesOfNeighbors = X(n,:);
meanRating = mean(HighRatedMoviesOfNeighbors);
removeRecommendation = X(customerId,:)~=0;
meanRating(removeRecommendation) = 0;
[SortedMovies, Index] = sort(meanRating,'descend');
fprintf('Recommendation Based on Nearest Neighbor Search - \n');
Index(1,1:5)