functions{
  // LINEAR PREDICTOR FOR THE LONGITUDINAL SUBMODEL
  vector linear_predictor(int[] ID, vector tt, real i_beta, real s_beta, matrix bi){
    int N = num_elements(tt);
    vector[N] out = i_beta + bi[ID,1] + s_beta * tt + rows_dot_product(bi[ID,2],tt);
    return out;
  } 
}

data{
  int N;
  int n;
  int<lower=0,upper=1> y[N];
  vector[N] tt;

  int<lower=1,upper=n> ID[N];
  vector[n] time;
  vector[n] status;
 
}

parameters{
  real i_beta;
  real s_beta;

  matrix[n,2] bi;
  cov_matrix[2] Sigma_bi;
  vector[2] alpha;
  real<lower=0> phi;
}

model{
  vector[N] linpred = linear_predictor(ID, tt, i_beta, s_beta, bi);
  vector[n] logHaz;
  vector[n] cumHaz;

  // LONGITUDINAL SUBMODEL
  target += bernoulli_logit_lpmf(y | linpred);

  // SURVIVAL SUBMODEL
  for(i in 1:n){
     // log-Hazard
     logHaz[i] = log(phi) + (phi-1)*log(time[i]) + alpha[1] * bi[i,1] + alpha[2] * bi[i,2];
     // Cumulative hazard H[t] = int_0^t h[u] du
     cumHaz[i] = (time[i]^phi) * exp(alpha[1] * bi[i,1] + alpha[2] * bi[i,2] );
     target += status[i] * logHaz[i] - cumHaz[i];
  }

  // PRIOR SPECIFICATION
  // Longitudinal fixed effects
  target += normal_lpdf(i_beta | 0, 100);
  target += normal_lpdf(s_beta | 0, 100);
   
  // Random-effects
  for(i in 1:n){ target += multi_normal_lpdf(bi[i,] | rep_vector(0,2), Sigma_bi); }

  // Random-effects variance-covariance matrix
  target += inv_wishart_lpdf(Sigma_bi | 3, diag_matrix(rep_vector(1,2)));


  // Association parameter
  target += normal_lpdf(alpha | 0, 100);

  // Shape parameter (Weibull hazard)
  target += cauchy_lpdf(phi | 0, 5);
}
