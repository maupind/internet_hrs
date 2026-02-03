functions {
  // LINEAR PREDICTOR FOR LONGITUDINAL SUBMODEL
  vector linear_predictor(array[] int ID, vector tt, matrix X1, 
                          real i_beta, real s_beta, vector beta, matrix bi) {
    int N = num_elements(tt);
    vector[N] out;
    out = i_beta + bi[ID, 1] + (s_beta + bi[ID, 2]) .* tt + X1 * beta;
    return out;
  }
}

data {
  int N;                     // total longitudinal observations (complete cases)
  int n;                     // number of subjects
  int nX1;                   // number of longitudinal covariates
  int nX2;                   // number of survival covariates
  array[N] int<lower=0, upper=1> y;   // observed binary outcome
  vector[N] tt;              // time since entry
  matrix[N, nX1] X1;         // longitudinal covariates
  array[N] int<lower=1, upper=n> ID;  // subject IDs
  vector[n] time;            // survival times
  array[n] int<lower=0, upper=1> status; // survival status
  matrix[n, nX2] X2;         // survival covariates
}

parameters {
  real i_beta;
  real s_beta;
  vector[nX1] beta;
  vector[nX2] gamma;
  vector[2] alpha;
  real<lower=0> phi;
  vector<lower=0>[2] sigma_bi;
  cholesky_factor_corr[2] L_bi;
  matrix[n, 2] z_bi;
}

transformed parameters {
    matrix[n, 2] bi;
  bi = z_bi * (diag_pre_multiply(sigma_bi, L_bi))';
}


model {
  vector[N] linpred = linear_predictor(ID, tt, X1, i_beta, s_beta, beta, bi);
  vector[n] logHaz;
  vector[n] cumHaz;
  to_vector(z_bi) ~ normal(0,1);

  // --- survival submodel ---
  for (i in 1:n) {
    logHaz[i] = log(phi)
                + (phi - 1) * log(time[i])
                + X2[i,] * gamma
                + alpha[1] * bi[i,1]
                + alpha[2] * bi[i,2];
    cumHaz[i] = pow(time[i], phi)
                * exp(X2[i,] * gamma + alpha[1] * bi[i,1] + alpha[2] * bi[i,2]);
    target += status[i] * logHaz[i] - cumHaz[i];
  }




  // --- longitudinal submodel (complete cases only) ---
  target += bernoulli_logit_lpmf(y | linpred);

  // --- priors ---
  i_beta ~ normal(0, 100);
  s_beta ~ normal(0, 100);
  beta ~ normal(0, 100);
  gamma ~ normal(0, 100);
  alpha ~ normal(0, 100);
  phi ~ lognormal(0, 0.5);
  sigma_bi ~ normal(0, 5); 
  L_bi ~ lkj_corr_cholesky(2);
}

//transformed parameters {
//  matrix[n,2] bi;
//  for (i in 1:n)
//    bi[i] = (diag_pre_multiply(sigma_bi, L_bi) * to_column_vector(z_bi[i]))';
//}
