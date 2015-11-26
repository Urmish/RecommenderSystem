function [ o_matrix,o_AveragePerCustomer  ] = IncrementalLowRankCompletion( i_matrix, i_iterCount,i_threshold)
%INCREMENTALLOWRANKCOMPLETION - Incremental SVD algorithm for matrix
%Completion
%   i_matrix - Input Sparse Matrix
%   i_iterCount - Max Iteration Count
%   o_matrix - Output dense matrix
m_nextM = i_matrix;
for i=1:i_iterCount
    [m_U,m_D,m_V] = svd(m_nextM,'econ');
    m_g = diag(m_D);
    m_g = TopKEigenValues(m_g,i_threshold);
    m_nextM = m_U*diag(m_g)*(m_V');
    m_k = find(i_matrix);
    m_nextM(m_k) = i_matrix(m_k);
    %m_nextM = round(m_nextM);
end
o_matrix = m_nextM;
o_AveragePerCustomer = sum(o_matrix,2)./sum(o_matrix~=0,2);
end

