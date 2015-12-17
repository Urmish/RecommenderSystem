% Example to illustrate user-based similarity and
% recommendation

%           Matrix      Titanic     DieHard    ForrestGump     Wall-E
% John        5             1                       2             2
% Lucy        1             5           2           5             5
% Eric        2                         3           5             4
% Diane       4             3           5           3   

X = [5 1 0 2 2; 1 5 2 5 5; 2 0 3 5 4; 4 3 5 3 0];

% Want to generate rating for movie Titanic for Eric
% Find similarity of Eric with all others
E_Cossim = CosSimVecMatrix((X(3,:))', X)
E_PCsim = PCSimVecMatrix((X(3,:))', X)

% Cossim highest for Lucy 0.8064
% Cossim 2nd highest for Diane 0.6732

% E_PCsim highest for Lucy 0.9218
% E_PCsim 2nd highest for Diane -0.6592 Contrast

% Diane's mean is 3.75 Eric's mean is 3.5
% If you look at their normalized vectors
% Eric's ->     -1.5000         0   -0.5000    1.5000    0.5000
% Dian'es ->    0.2500   -0.7500    1.2500   -0.7500         0