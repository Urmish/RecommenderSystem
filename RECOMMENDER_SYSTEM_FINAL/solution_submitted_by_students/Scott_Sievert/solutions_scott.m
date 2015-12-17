% Feedback
% * Include the Netflix Problem in introduction -- it's a famous recommender
%   system problem! There's even [a wiki article] about the Netflix problem!
% * Intuiton behind PC/CV ratings. Why is this used?
% * Include data as .mat file, not csv. UPDATE: include how to read .test
% * latex quotes are ``this is a quote". Also, \usepackage{hyperref}
% * "If you have an intuitive answer to Exercise 4" ... "should make sense".
%   *Why* does this equation make sense? Give an explanation for why you should
%   have an intuitive answer! This is teaching -- I don't know this stuff.
% * Nice job on including examples.
% * Documentation wasn't clear on PCSimVecMatrix; I didn't know it could return
%   two values. It returns the matrix with the average values removed... that
%   woulda been nice to know (I couldn't find this in your documentation in
%   Appendix B).
% * use \textrm{in math mode} to get rid of highlighted text (ie, as w/ "Error")
% * use \texttt{to get monospaced text} appropriate for code/filenames/etc
% * I know what the SVD is -- I took this course too.
%
% [a wiki article]:https://en.wikipedia.org/wiki/Netflix_Prize

%% Questions I have:
% * Why don't we try to find a few representative users for each new user? There
%   might be an issue with not every movie being recommended, but I would have
%   like to see *why* that won't work.
% * Why don't we remove the mean *before* finding similar users? This would
%   remove any bias that may be present because of a users tendency to rate
%   movies higher than someone else.

clc; clear all; close all;
addpath('./LabFunctions/');
addpath('./Data/');

%% Exercise 1
% Eric has rating most similar to Lucy. Maybe he'll like the movie "Titanic" as
% well

%% Exercise 2
U = [5 1 0 2 2; 1 5 2 5 5; 2 0 3 5 4; 4 3 5 3 0];

CV = CosSimVecMatrix(U(3, :)', U);
% CV = [0.6535 0.8064 1.0000 0.6732]

%% Exercise 3
PC = PCSimVecMatrix(U(3, :)', U);
% PC = [-0.8389 0.9218 1.0000 -0.6592]

%% Exercise 4
% * This formula finds the average of users in the same group, that are "close
%   enough" to the user we're looking at.
% * What if there are no nearest neighbors to average over?
% * It doesn't use the vector full information -- if someone rated movies
%   *exactly* the same, but one user left one rating out their rating is
%   probably the same. This method doesn't use that information.

%% Exercise 5
% ratings
R = [5 1 0 2 2; 1 5 2 5 5; 2 0 3 5 4; 4 3 5 3 0; 1 4 0 5 0];
X = 1*R;

% nearest neighbors are rows 2 and 3 (or "Lucy" and "Eric")
S = PCSimVecMatrix(R(end, :)', R);

% subtracting the mean rating for each user
T = 0*R;
for i=1:5,
    T(i, :) = R(i, :) - sum(R(i, :)) / size(R, 2);
    assert(abs(sum(T(i, :))) < 1e-10, 'Each row of T should be zero mean')
end

% normalized ratings: see how far away from the mean they are, average those
% those together
% This feels wrong. Shouldn't we be comparing their mean ratings?
for i=[2, 3, 5],
    r1 = (S(i)*T(3, i) + S(3)*T(2, i)) / (S(2) + S(3));
    r1 = r1 + mean(R(5, :));
    R(5, i) = r1;
end

% This woulda been nice to know...
[~, X_zero_mean] = PCSimVecMatrix(R(end, :)', R);

% I looked at the example file, UserBasedPredictionToy.m. There, you're not
% subtracting off the mean (UPDATE: yes it is, but it's hidden in
% PCSimVecMatrix... *sigh*). That makes more intuitive sense; I get why we're
% doing that (to remove user calibration issues) but I don't understand why we
% don't find the nearest neighbors with looking at the matrix after
% normaliztion. (UPDATE: yes, they are calculating the scores with the user
% average in mind to remove "calibration" issues. I'm pretty sure PCSimVecMatrix
% does not calculate the nearest neighbors based on the mean removed values;
% there's still calibration issues here?).
%
% This script does the same process: predicts that the new users ratings will be
% close to the nearest neighbors, when the mean is removed. I still think the
% example should find the nearest neighbors with the mean removed, eliminating
% the effect of the mean.

%% Exercise 6
% RMSE: np.sqrt((x_hat - x)**2)
% TFRM: | S \union S_hat | / |S_test|
% NMNP:

%clc; clear all; close all;
addpath('LabFunctions');
addpath('UsefulScripts'); % should really be in LabFunctions...
fn = functions_();

% This is just a function for the code from problem 5 (copy and pasted from your
% example for ease). It has been updated for the values in Table 4.
X_train = ConvertUDataToMatrix('u1.test'); % We're going to train with this data
X_test = ConvertUDataToMatrix('u1.base'); % and test with this data

N = 0;
thresholds = 0.5:0.05:1;
errors = [];
for neighbor_threshold=thresholds,
    neighbor_threshold = 0.95;
    for i = 1:size(X, 1),
        ratings = fn.predict_ratings_for_user(i, X_train, neighbor_threshold);

        % The indices where our test user rated the movies.
        rated = abs(X_test(i, :)) > 1e-6;
        N = N + size(rated, 1);

        % For RMS loss. We could use other methods (NMNP, NFP, etc) but then we
        % should wrap this value to a function call.
        error_ = sum((ratings(rated) - X_test(i, rated)) .^ 2);
    end
    errors = [errors sqrt(error_ / N)];
end

% Plotting this error, we see that our error goes down monotonically. The
% smaller our neighborhood size is, the better we do. This makes sense
% intuitively; the more similar our neighbors are, the better we do. At some
% point (not shown on plot?) our error should increase.
figure; hold on
plot(thresholds, errors)

%% Exercise 7
% This sparsity model with correlated variables is an active area of
%research.  If the correlated variables play a role, it tries to preserve that.
%See [1] for more detail.
%
% (ToyExampleModelSVDMotivation.m looked at). You're just approximating X by a
% rank 1 matrix. I can see where low-rank would be useful. Also, of course I
% know what the SVD is -- I took this course too!
%
% [1]:Sparse Estimation with Strongly Correlated Variables using Ordered
% Weighted l1 Regularization, http://nowak.ece.wisc.edu/OWL_v7.pdf,

%% Exercie 8
% The example in ToyExampleModelSVDMotivation2 does not do a good job of
% prediction -- it predicts 1's and 2's, not 3's and 4's like expected (and the
% other ratings were). It doesn't even get the ground truth predictions right
% (the user rated 4 and we *know* that).
%
% By setting some of the singular values to 0, we are taking some energy out of
% our input matrix. What paper/source is this based off of?

%% Exercise 9
close all;
X = [5 1 0 2 2; 1 5 2 5 5; 2 0 3 5 4; 4 3 5 3 0; 1 4 0 5 0];
R = X * 1.0;
means = repmat(mean(R, 2), 1, 5);
i = R == 0;
R(i) = R(i) + means(i);

R_norm = R - repmat(mean(R, 2), 1, 5);
[U S V] = svd(R_norm);
% For this toy matrix we're not justified in doing this
S(3:end, 3:end) = 0;

Pred_norm = U * S * V;
Pred_norm = Pred_norm + repmat(mean(R, 2), 1, 5);

%% Exercise 10
% Why are we predicting with the SVD? Didn't we learn smarter method the last
% day off class? Even if we didn't know that, couldn't we solve Lasso for each
% individual user?
%
% This method doesn't perform the best, even with the truncation method in the
% example script.
X = [5 1 0 2 2; 1 5 2 5 5; 2 0 3 5 4; 4 3 5 3 0];
i = X ~= 0;
known = X(i);
k = 2;
for j=1:100,
    [U, S, V] = svd(X);
    S(S < 0.5) = 0;
    X = U * S * V;
    X(i) = known;
end

%% Exercise 11
X_train = ConvertUDataToMatrix('u1.test'); % We're going to train with this data
X_test = ConvertUDataToMatrix('u1.base'); % and test with this data

[R1, avg] = IncrementalLowRankCompletion(X_train, 100, 0.5);
[R2, avg] = AverageValueBasedMatrixCompletion(X_train, 0.5);
