function [ o_matrix, o_occupation] = ImportUserInfo()
%IMPORTUSERINFO - Imports user_info csv which has the user id, age, sex,
%occupation and area code. Area Code is 0 if not known or different format
%Male - 0
%Female - 1
m_fid = fopen('Data/user_info.csv');
m_input = textscan(m_fid,'%d %d %d %s %d','Delimiter',',');
fclose(m_fid);
o_matrix = [m_input{2} m_input{3} m_input{5}]; %Has age, Sex and Area
o_occupation = m_input{4};
end

