R = [5 3 0 1;4 0 0 1;1 1 0 5;1 0 0 4;0 1 5 4]

N = size(R, 1);
M = size(R, 2);
K = 2;

P = rand(N,K);
Q = rand(M,K);

[nP, nQ] = LatentMatrixFactorization(R, P, Q, K);
nR = nP*nQ'