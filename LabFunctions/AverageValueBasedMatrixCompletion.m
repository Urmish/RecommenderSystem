function [ o_Pred,o_AveragePerCustomer ] = AverageValueBasedMatrixCompletion( i_matrix,i_singularValueThreshold )
%AVERAGEVALUEBASEDMATRIXCOMPLETION Average Value based Matrix Completion
%   Detailed explanation goes here

m_XComplete = FillZeroEntryWithAverageInARow(i_matrix);
o_AveragePerCustomer = sum(m_XComplete,2)./sum(m_XComplete~=0,2);
m_AveragePerCustomerMatrix = repmat(o_AveragePerCustomer,[1 size(m_XComplete, 2)]);
m_XNormalized = m_XComplete - m_AveragePerCustomerMatrix;
[m_U m_S m_V] = svd(m_XNormalized,'econ');
m_g = diag(m_S);
m_h = m_g/m_g(1);
m_ind = (m_h>=i_singularValueThreshold);
m_g(~m_ind) = 0;
m_PredNorm = m_U*diag(m_g)*(m_V');
o_Pred = m_PredNorm+m_AveragePerCustomerMatrix;

end

