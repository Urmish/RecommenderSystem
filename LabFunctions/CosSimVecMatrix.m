function o_SimilarityVecMatrix  = CosSimVecMatrix( i_Vec, i_Matrix)                                                           
%Calculates cosine similarity between a vector (column) and each of the rows of a
%matrix
%Completion
%   i_Vec - first input vector - a column vector
%   i_Matrix - input matrix
%   o_SimilarityVecMatrix - output the vector with similarity values
    [m,n] = size(i_Matrix);
    M1 = repmat(i_Vec', m,1);
        
    NormM2Rows = sqrt(sum(i_Matrix.^2,2));
    
    o_SimilarityVecMatrix = ((sum(M1.* i_Matrix,2))./NormM2Rows)/norm(i_Vec,2);
    
end
