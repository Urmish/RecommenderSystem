% Example to illustrate Matrix Completion

%           Matrix      Titanic     DieHard    ForrestGump     Wall-E
% John        5             1                       2             2
% Lucy        1             5           2           5             5
% Eric        2                         3           5             4
% Diane       4             3           5           3   
singularValueThreshold = 0.5;
iterationCount = 1000;
X = [5 1 0 2 2; 1 5 2 5 5; 2 0 3 5 4; 4 3 5 3 0];

%Incremental Low Rank Completion
[completion2 ~] = IncrementalLowRankCompletion(X,iterationCount,singularValueThreshold);
