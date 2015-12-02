% Example to illustrate issues with user based systems

%           DieHard1      DieHard2     DieHard3    DieHard4     
% John        4             4           
% Lucy        3             3           3           3
% Eric                                  4           4           

%Clearly, Eric and John could look like the kind of users who may enjoy
%watching the same kind of movie. Yet, they have no rating in common and
%would not end up as similar to each other.

X = [4 4 0 0 ;3 3 3 3;0 0 4 4];
[U S V] = svd(X); %We will get to what an SVD is at a later stage. Just assume it is something magical for now.
S(2,2) = 0;
XLowRank = U*S*V';
% Low Rank Approximation (XLowRank)
%      DieHard1  DieHard2  DieHard3  DieHard4     
% John 2.0000    2.0000    2.0000    2.0000
% Lucy 3.0000    3.0000    3.0000    3.0000
% Eric 2.0000    2.0000    2.0000    2.0000
%Now in this lower rank approximation, we can see that John and Eric are
%similar to each other. Lets get back to our Lab to see what exactly is
%happening here and how to achieve this