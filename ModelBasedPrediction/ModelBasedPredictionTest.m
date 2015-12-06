function [o_recPred, o_recNN, o_predMatrix,o_AveragePerCustomer  ] = ModelBasedPredictionTest(i_testdata,i_singularValueThreshold,i_predThreshold,i_customerId, i_modelNumber, i_iterCount, i_NumNearestNeighbor, i_knnDistanceMeasure, i_predMatrix, i_AveragePerCustomer, i_usePredMatrix, i_printMovieNames)
%MODELBASEDPREDICTIONTEST Runs model based SVD to return predictions
% Parameter Values - Input
%i_testdata
%i_singularValueThreshold = Singular values lower than this value
%multiplied by maximum sigma value are discarded
%i_predThreshold = Prediction threshold to say which movies are good.
%Movies above this are considered good
%i_customerId = Customer Id for which predictions are to be generated
%i_modelNumber = %0 - Average Value based %1 - Incremental SVD based
%i_iterCount = %Used by Incremental SVD. Number of iterations
%i_NumNearestNeighbor = NN for knn search;
%i_knnDistanceMeasure = Distance measure used by knn search, example 'cosine';
%i_predMatrix = Prediction Matrix used in the code, this matrix is only
%used if i_usePredMatrix is set
%i_AveragePerCustomer = Average Rating Per Customer, this matrix is only
%used if i_usePredMatrix is set
%i_usePredMatrix = Set to 0 if you do not have predMatrix and
%AveragePerCustomer, Else set to one.
%i_printMovieNames - 0 - Do not Print Recommended Movie Names. 1 - Print
%Movie Names

% Parameter Values - Output
% o_recPred - Recommendation based on Prediction
% o_recNN - Recommendation based on NN
% o_predMatrix - Prediction Matrix generated
% o_AveragePerCustomer - Average Ratings for Current Train Dataset

X = ConvertUDataToMatrix(i_testdata);
IDtoM = GetMovieNameDatabase();
if (i_usePredMatrix == 0)
    if (i_modelNumber == 0)
        size(X')
        [Pred ~] = AverageValueBasedMatrixCompletion(X',i_singularValueThreshold);
        Pred = Pred';
        AveragePerCustomer = mean(Pred,2);
    else
        [Pred, AveragePerCustomer] = IncrementalLowRankCompletion(X,i_iterCount,i_singularValueThreshold);
    end
else
    Pred = i_predMatrix;
    AveragePerCustomer = i_AveragePerCustomer;
end
o_predMatrix = Pred;
o_AveragePerCustomer = AveragePerCustomer;
%Error
index_nonzero = find(X~=0);
error = norm(X(index_nonzero) - Pred(index_nonzero))/norm(X(index_nonzero));
%Prediction
if (i_printMovieNames == 1)
    PrintOutMoivesOfAUser(IDtoM,X(i_customerId,:),0);
    fprintf('Prediction Based Recommendation - \n');
end

if (i_predThreshold > AveragePerCustomer(i_customerId))
    possibleRecommendation = Pred(i_customerId,:)>i_predThreshold;
    removeRecommendation = X(i_customerId,:)~=0;
    possibleRecommendation(removeRecommendation) = 0;
    moviesUnSorted = Pred(i_customerId,possibleRecommendation);
    [SortedMovies, Index] = sort(moviesUnSorted,'descend');
    o_recPred = Pred(i_customerId,:);
    if (size(SortedMovies,2) == 0)
         if (i_printMovieNames == 1)
            fprintf('No movies beyond the threshold\n');
         end
    else
        if (i_printMovieNames == 1)
            fprintf('Top 5 movies are - ');
            PrintOutMoivesOfAUser(IDtoM,Index(1,1:5),1);
        end
    end
else
    if (i_printMovieNames == 1)
        fprintf('Average Values for this customer have been high and it is difficult to comeup with a prediction using this technique\n');    
    end
end

fprintf('*********************************\n');
%Nearest Neighbor
[U S V] = svd(Pred,'econ');
Sk = TopKEigenValues(diag(S),i_singularValueThreshold);
k = sum(Sk~=0);
Sk = diag(Sk);
NNMatrix = U*Sk*V';
[K_sim, normX] = PCSimVecMatrix(NNMatrix(i_customerId,:)',NNMatrix);
K_sim = K_sim(2:end,:);
[nn_weights,nn_sortId] = sort(K_sim,'descend');
nnBasedRatings = normX(nn_sortId(1:i_NumNearestNeighbor)',:).*repmat(nn_weights(1:i_NumNearestNeighbor,:),1,1682);
meanRatingNN = mean(nnBasedRatings);
[SortedMovies, Index] = sort(meanRatingNN,'descend');
if (i_printMovieNames == 1)
    fprintf('Recommendation Based on Nearest Neighbor Search - \n');
    PrintOutMoivesOfAUser(IDtoM,Index(1,1:5),1);
end
o_recNN = meanRatingNN;
end