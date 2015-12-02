% Example to illustrate issues with user based systems
% WP - Writing Pad, NP - Note Pad
%          WP1 WP2 WP3 WP4 NP1 NP2 NP3 NP4
% Usr1     4   3   4    3
% Usr2             3    3   3   3
% Usr3                      4   3   4   3   
% Writing Pad and Note Pad are the same thing, clearly if a user likes one,
% he could like the other. Could 
X = [4 3 4 3 0 0 0 0; 0 0 3 3 3 3 0 0; 0 0 0 0 3 4 3 4];
[U S V] = svd(X); %svd again!!! Patience my fellow labmate, you shall soon uncover its secret. Just read through it for now.
S(3,3) = 0;
S(2,2) = 0;
XPrediction = U*S*V';
%New values for usr 1
%          WP1         WP2      WP3       WP4       NP1       NP2       NP3        NP4
%1.2294    1.2294    0.9221    2.2618    1.9544    1.9544    2.2618    0.9221    1.2294
%Now we could see that Usr1 will appreciate WP1 as much as NP1