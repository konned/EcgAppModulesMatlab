function [w,y,e,W] = LMS(x,d,mu_step,M)
N = length(x); % number of data samples
y = zeros(N,1); % initialize filter output vector
w = zeros(M,1); % initialize filter coefficient vector
e = zeros(N,1); % initialize error vector
W = zeros(M,N); % filter coefficient matrix for coeff. history
for n = 1:N
  if n <= M % assume zero-samples for delayed data that isn't available
      k = n:-1:1;
      x1 = [x(k); zeros(M-numel(k),1)];
  else
      x1 = x(n:-1:n-M+1); % M samples of x in reverse order
  end
  y(n) = w'*x1; % filter output
  e(n) = d(n) - y(n); % error
  w = w + mu_step*e(n)'*x1; % update filter coefficients
  W(:,n) = w; % store current filter coefficients in matrix
end