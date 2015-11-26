function o_SimilarityVec  = PCSimVec( i_Vec1, i_Vec2)                                                           
%Calculates Person Coefficient similarity between two vectors
%Completion
%   i_Vec1 - first input vector
%   i_Vec1 - second input vector
%   o_SimilarityVec - output the scalar value of similarity
    mean1 = mean(i_Vec1);
    mean2 = mean(i_Vec2);
    num1 = i_Vec1 - mean1;
    num2 = i_Vec2 - mean2;
    numerator = sum(num1.*num2);
    denominator = sqrt(sum(num1.^2) * sum(num2.^2));
    
    o_SimilarityVec = numerator/denominator;
end
