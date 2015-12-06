function [ o_eigenValuesColumn ] = TopKEigenValues( i_eigenValuesColumn, i_threshold )
%TOPKEIGENVALUES Returns the top k eien values where top is decided based
%on threshold
%i_eigenValuesColumn - Column vector with sorted eigen values
%o_eigenValuesColumn - Eigen Values below threshold are set to zero
m_h = i_eigenValuesColumn/i_eigenValuesColumn(1);
m_ind = (m_h>=i_threshold);
o_eigenValuesColumn = i_eigenValuesColumn;
o_eigenValuesColumn(~m_ind) = 0;
end

