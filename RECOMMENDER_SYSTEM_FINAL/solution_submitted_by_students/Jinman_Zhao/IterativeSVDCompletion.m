function completion = IterativeSVDCompletion(X, n_iter, k)
    X_rated_ind = find(X==0);
    for t = 1:n_iter
        [U S V] = svd(X, 'econ');
        X_next = U(:,1:k)*S(1:k,1:k)*V(:,1:k)';
        X(X_rated_ind) = X_next(X_rated_ind);
    end
    completion = X;
end
