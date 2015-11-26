function o_SimilarityVec  = CosSimVec( i_Vec1, i_Vec2)                                                           
%Calculates cosine similarity between two vectors
%Completion
%   i_Vec1 - first input vector
%   i_Vec1 - second input vector
%   o_SimilarityVec - output the scalar value of similarity
    Vec1Norm = norm(i_Vec1,2);
    Vec2Norm = norm(i_Vec2,2);
    if (Vec1Norm == 0 || Vec2Norm == 0)
        g = sprintf('%d', i_Vec1);
        fprintf('Vec1 is: %s\n', g)
        g = sprintf('%d', i_Vec2);
        fprintf('Vec2 is: %s\n', g)
        error('CosSimVec has a vector with zero norm')
        return
    end
    o_SimilarityVec = (i_Vec1' * i_Vec2) / (Vec1Norm * Vec2Norm);
end
