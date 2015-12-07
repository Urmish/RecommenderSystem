function [o_SimilarityVec,normM]  = PCSimVecMatrix( i_Vec1, i_M)                                                           
% Calculates Person Coefficient similarity between a vector and rows of
% matrix i_M
% Completion
%   i_Vec1 - first input vector, a column vector
%   i_M - input matrix
%   o_SimilarityVecM - output the vector of similarities
    meanVec = sum(i_Vec1)/nnz(i_Vec1); % mean of all ratings excluding unrated items
    meanMrows = sum(i_M,2)./sum(i_M~=0,2);
    
    nonzeroM = i_M~= 0; % matrix of 1s for rated entries
    nonzeroVec = i_Vec1 ~= 0;
    
    %subtract mean of ratings per user
    normVec1 = i_Vec1 - meanVec*nonzeroVec;
    [m,n] = size(i_M);
    normM = i_M - repmat(meanMrows, 1, n).* nonzeroM;
    o_SimilarityVec = -99*ones(m,1);
    for i=1:m
        numerator = normM(i,:)*normVec1;
        
        vecindices = zeros(1,n);
        rowindices = zeros(1,n);
        vecindices(i_Vec1' ~= 0)  = 1;
        rowindices(i_M(i,:) ~= 0) = 1;
        finalindices = vecindices .* rowindices;% indices for items rated by both
        % denominator accounts for variance of only items rated by both
        denominator = norm(normVec1'.*finalindices,2) * norm(normM(i,:).*finalindices,2);
        if (denominator == 0)
            o_SimilarityVec(i,1) = 0; % do not have any movie rated by both
            % display(i)
            % warning('denominator is zero');
        % end
        else
            o_SimilarityVec(i,1) = numerator/denominator;
        end
    end
 end
