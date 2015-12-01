function [ o_percentageCorrect ] = Top5Accuracy( i_testVector,i_predVector )
%TOP5ACCURACY Returns how many movies are common between top 5 values of
%testVector and the top 5 values of predVector for the movies rated in test
%vector
%   Input -
%1. i_testVector - Vector extracted from test database, represents ground
%truth
%2. i_predVector - Prediction Vector generated using multitudes of methods
%described in the lab
if (sum(i_testVector,2)==0)
    o_percentageCorrect = 1;
end

ind = find(i_testVector~=0);
[useless sortedTestInd] = sort(i_testVector(ind),'descend');
[useless sortedPredInd] = sort(i_predVector(ind),'descend');
ind1 = ind(1,sortedTestInd)
ind2 = ind(1,sortedPredInd)
topK=5;
if (size(ind1,2) < topK)
    topK=size(ind1,2);
end
intersection = intersect(ind1(1:topK),ind2(1:topK));
if (size(intersection,2) == 0)
    o_percentageCorrect=0;
else
    intersection
    o_percentageCorrect = size(intersection,2)/topK;
end
end

