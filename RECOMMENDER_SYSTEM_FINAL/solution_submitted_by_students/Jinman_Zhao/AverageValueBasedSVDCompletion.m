function completion = AverageValueBasedSVDCompletion(X, k)
    [m n] = size(X);
    % fill zero with column average
    X_ranked = X ~= 0;
    col_avg = sum(X, 1) ./ sum(X_ranked, 1);
    X_filled = X + (1 - X_ranked) .* repmat(col_avg, m, 1);
    % mean center each row
    row_avg = sum(X, 2) ./ sum(X_ranked, 2);
    X_norm = X_filled - repmat(row_avg, 1, n);
    % factor
    [U S V] = svd(X_norm);
    P_norm = U(:,1:k)*S(1:k,1:k)*V(:,1:k)';
    % add average back
    completion = P_norm + repmat(row_avg, 1, n);
end