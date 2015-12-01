function [ o_numberOfError,o_totalMovies,o_totalPositivesWrong,o_totalPositives ] = StepErrorFunction( i_input1,i_input2,i_threshold )
%STEPERRORFUNCTION - Takes 2 1x1682 arrays are ratings. These ratings are
%predictions or test ratings of users. This functions tries to establish
%whether the prediction of movies a user likes or dislikes were actually
%favourable and unfavourable rather than calculate the absolute difference
%in error.
%Input -
%1. i_input1 - Input vector 1 based on test data
%2. i_input2 - Input Vector 2 based on predicted data
%3. i_threshold - Threshold above and below zero which the user
%recommendations are considered favourable or unfavourable.

average1 = sum(i_input1,2)/sum(i_input1~=0,2);
if (isnan(average1))
    average1=0;
end
average2 = sum(i_input2,2)/sum(i_input2~=0,2);
if (isnan(average2))
    average2=0;
end
i_input1(i_input1 == 0) = average1;
i_input1 = i_input1-average1;
i_input2(i_input2 == 0) = average1;
i_input2 = i_input2-average2;

i_input1(i_input1>i_threshold) = 1;
i_input1(i_input1<-i_threshold) = -1;
i_input1(i_input1<=i_threshold & i_input1>=-i_threshold) = 0;
i_input2(i_input2>i_threshold) = 1;
i_input2(i_input2<-i_threshold) = -1;
i_input2(i_input2<=i_threshold & i_input2>=-i_threshold) = 0;
o_numberOfError = sum(i_input2(i_input1~=0) ~= i_input1(i_input1~=0),2);
o_totalMovies = sum(i_input1~=0,2);
o_totalPositivesWrong = sum(i_input2(i_input1>0) ~= i_input1(i_input1>00),2);
o_totalPositives = sum(i_input1>00,2);
end

