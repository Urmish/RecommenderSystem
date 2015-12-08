function [ P, Qt ] = LatentMatrixFactorization(R, P, Q, K)
Q = Q';
steps=5000;
alpha=0.0002;
beta=0.02;
for step = 1:steps
    for i = 1:size(R,1)
        for j=1:size(R(i,:),2)
            if R(i,j) > 0
                eij = R(i,j) - dot(P(i,:),Q(:,j));
                for k=1:K
                    P(i,k) = P(i,k) + alpha * (2 * eij * Q(k,j) - beta * P(i,k));
                    Q(k,j) = Q(k,j) + alpha * (2 * eij * P(i,k) - beta * Q(k,j));
                end
            end
        end
    end
    eR = P*Q;
    e = 0;
    for i=1:size(R, 1)
        for j=1:size(R(i,:),2)
            if R(i,j) > 0
                e = e + (R(i,j) - P(i,:)*Q(:,j))^2;
                for k=1:K
                    e = e + (beta/2) * (P(i,k)^2) + (Q(k,j)^2);
                end
            end
        end
    end
    if e < 0.001
        break;
    end
    Qt = Q'
end