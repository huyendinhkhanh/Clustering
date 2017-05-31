% Function pca
function F = mypca(X,number)
  m = mean(X);
  st = std(X, 1);

  sz = size(X);
  % sz(1): number of observations
  % sz(2): number of features

  % normed PCA
  Xhat = zeros(sz);
  for i=1:sz(2)
    Xhat(:,i) = (X(:, i) - m(i))/(sqrt(sz(1))*st(i));
  end

  % correlation matrix
  V = Xhat' * Xhat;

  %eigenvalues
  [eivec, eival] = eig(V);

  % display the eigenvalues accumulation and %
  % sz(2) == number of eigenvalues of V
  eigenInfo = zeros(sz(2), number);
  sum_eival = sum(diag(eival));
  acc_eival = 0;
  for i=sz(2):-1:1
    acc_eival = acc_eival + eival(i, i);

    % eigenvalues, accumulate, %
    eigenInfo(sz(2)-i+1, : ) = [eival(i, i), acc_eival, acc_eival/sum_eival];
  end

  %eigenvectors
  eivec2 = zeros(size(eivec));
  for i=1:size(eivec, 2)
    eivec2(:, i) = eivec(:, size(eivec, 2) - i + 1);
  end
  eivec = eivec2;

  % Ask for number of new coordinates
  dim = 3;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %The new observations
  F = Xhat*eivec(:, 1:dim);
end
