{
  description = "An R Development Flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixgl.url = "github:nix-community/nixGL";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  
  outputs = { self, nixpkgs, flake-utils, nixgl, ... }:
    flake-utils.lib.eachDefaultSystem (system: 
      let pkgs = import (fetchTarball {url = "https://github.com/NixOS/nixpkgs/archive/057f9aecfb71c4437d2b27d3323df7f93c010b7e.tar.gz"; 
       sha256 = "1ndiv385w1qyb3b18vw13991fzb9wg4cl21wglk89grsfsnra41k";}) {
       system = "x86_64-linux";
       overlays = [ nixgl.overlay ];};
  git_archive_pkgs = [(pkgs.rPackages.buildRPackage {
    name = "tidyverse";
    src = pkgs.fetchgit {
      url = "https://github.com/tidyverse/tidyverse";
      branchName = "main";
      rev = "8ec2e1ffb739da925952b779925bb806bba8ff99";
      sha256 = "sha256-HTv0f3arq7KagwoKKnhEFT4NMA/LNd/zAmqabASy11g=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) broom conflicted cli dbplyr dplyr dtplyr forcats ggplot2 googledrive googlesheets4 haven hms httr jsonlite lubridate magrittr modelr pillar purrr ragg readr readxl reprex rlang rstudioapi rvest stringr tibble tidyr xml2;
    };
  })
(pkgs.rPackages.buildRPackage {
    name = "pROC";
    src = pkgs.fetchgit {
      url = "https://github.com/cran/pROC";
      branchName = "master";
      rev = "f47943152318bcc286cd3a0e1147c0fc8f3256a4";
      sha256 = "sha256-oPJg42M7X33HoiF+Qg5HXvZwg2paHIlJ4OQ/aLxXIoU=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) plyr Rcpp;
    };
  }) (pkgs.rPackages.buildRPackage {
    name = "haven";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/Archive/haven/haven_2.5.2.tar.gz";
      sha256 = "sha256-tXf6NY4yjh42YMjiy+WtI11Eo8gR+b3enplMqRx9ucU=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) cli forcats hms lifecycle readr rlang tibble tidyselect vctrs cpp11;
    };
    nativeBuildInputs = with pkgs; [pkg-config zlib];
  })
#(pkgs.rPackages.buildRPackage {
#    name = "RccpEigen";
#    src = pkgs.fetchzip {
#      url = "https://cran.r-project.org/src/contrib/Archive/RcppEigen/RcppEigen_0.3.4.0.1.tar.gz";
#      sha256 = "sha256-LZlaZE9WKo+5ydFm7Y8Q9O2sWW6on36gJLujkfn07Lg=";
#    };
#    propagatedBuildInputs = builtins.attrValues {
#      inherit (pkgs.rPackages) Rcpp Matrix inline tinytest pkgKitten microbenchmark;
#    };
#  })
#(pkgs.rPackages.buildRPackage {
#    name = "StanHeaders";
#    src = pkgs.fetchzip {
#      url = "https://cran.r-project.org/src/contrib/Archive/StanHeaders/StanHeaders_2.32.0.tar.gz";
#      sha256 = "sha256-6mI8cr0VrRyvPTsIQllTv1ab8yTPhozflwniANrIZgs=";
#    };
#    propagatedBuildInputs = builtins.attrValues {
#      inherit (pkgs.rPackages) RcppParallel knitr rmarkdown BH Matrix rstan withr RcppEigen;
#    };
#  })
#(pkgs.rPackages.buildRPackage {
#    name = "rstan";
#    src = pkgs.fetchzip {
#      url = "https://cran.r-project.org/src/contrib/Archive/rstan/rstan_2.32.5.tar.gz";
#      sha256 = "sha256-Zy07m5L9q0DTaWA4XrjP1dR7PN2dDtirJtvfBklFwUs=";
#    };
#    propagatedBuildInputs = builtins.attrValues {
#      inherit (pkgs.rPackages) inline gridExtra Rcpp RcppParallel loo pkgbuild QuickJSR ggplot2 RcppEigen BH StanHeaders;
#    };
#  })

(pkgs.rPackages.buildRPackage {
    name = "survminer";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/survminer_0.5.0.tar.gz";
      sha256 = "sha256-rQQ4EQNGLzfYufXxlzP3tUB27SAj4Ge46RUsTt2YQIU=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages)  ggplot2 ggpubr gridExtra magrittr maxstat scales survival broom dplyr tidyr survMisc purrr tibble rlang ggtext;
    };
  })
#(pkgs.rPackages.buildRPackage {
#    name = "semTools";
#    src = pkgs.fetchzip {
#      url = "https://cran.r-project.org/src/contrib/semTools_0.5-6.tar.gz";
#      sha256 = "sha256-7JXM/45egW1KxkzPFUDJ4syxmeHrMunQXvJLCSmR0qQ=";
#    };
#    propagatedBuildInputs = builtins.attrValues {
#      inherit (pkgs.rPackages) pbivnorm;
#    };
#  })
(pkgs.rPackages.buildRPackage {
    name = "lavaan";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/lavaan_0.6-19.tar.gz";
      sha256 = "sha256-I1Kbgg87Nhb0ZpX6WFTJLentbvnhhHjshhrmcEt7G4o=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) MASS mnormt pbivnorm numDeriv quadprog semTools;
    };
  })
(pkgs.rPackages.buildRPackage {
    name = "car";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/car_3.1-3.tar.gz";
      sha256 = "sha256-0pM9EDT15KD3D3Fu2OyYQiW4jW3debeVBoZb2T82ABw=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) carData abind Formula MASS mgcv nnet pbkrtest quantreg lme4 nlme scales;
    };
  })
(pkgs.rPackages.buildRPackage {
    name = "psych";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/Archive/psych/psych_2.3.3.tar.gz";
      sha256 = "sha256-0yY7iAHYnBh7AXruXN82ZFG/RLwmcLJVDYOvTaAfGDg=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) mnormt lattice nlme;
    };
  })
(pkgs.rPackages.buildRPackage {
    name = "DT";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/Archive/DT/DT_0.28.tar.gz";
      sha256 = "sha256-w7ggoa9gR1vamf7+rkorsZj8hvJ3Svx888eDC6EUGMM=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) htmltools htmlwidgets jsonlite magrittr crosstalk jquerylib promises;
    };
  })
 (pkgs.rPackages.buildRPackage {
    name = "pandoc";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/pandoc_0.2.0.tar.gz";
      sha256 = "sha256-QrpW4hR9uVvw3Xqf69wgjel3wqt3feaPvmf3rMRoNOM=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) fs rappdirs rlang;
    };
  })
(pkgs.rPackages.buildRPackage {
    name = "optmatch";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/optmatch_0.10.8.tar.gz";
      sha256 = "sha256-2Kyu9vzibtF9IN6/s0XcJjCrlJa9reCpb7OUJqwsdw0=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) Rcpp dplyr tibble rlemon;
    };
  })

(pkgs.rPackages.buildRPackage {
    name = "coda";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/coda_0.19-4.1.tar.gz";
      sha256 = "sha256-cMZPU1F22WmH1p8PkL02JCR8hVCMhIsrZHOG+r5C40A=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) lattice;
    };
  })
(pkgs.rPackages.buildRPackage {
    name = "rjags";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/rjags_4-16.tar.gz";
      sha256 = "sha256-Qg+vp0zDkfQXR4Er85ZILEjKNnpdngIzebYwaEYJQWI=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) coda;
      inherit (pkgs) jags;
    };
  })
#(pkgs.rPackages.buildRPackage {
#    name = "gt";
#    src = pkgs.fetchzip {
#      url = "https://cran.r-project.org/src/contrib/gt_0.10.0.tar.gz";
#      sha256 = "sha256-sBOuWiZH9VhARAlzvjgONUR/+/xoEJsAbmdK2AXk6mQ=";
#    };
#    propagatedBuildInputs = builtins.attrValues {
#      inherit (pkgs.rPackages) base64enc bigD bitops cli commonmark dplyr fs glue htmltools htmlwidgets juicyjuice magrittr markdown reactable rlang sass scales tibble tidyselect xml2;
#    };
#   })
 (pkgs.rPackages.buildRPackage {
    name = "gtExtras";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/gtExtras_0.5.0.tar.gz";
      sha256 = "sha256-7tHcXw5rYGw6HlsM1Zl/O5imfjBsQvLraGFbA0yJ35s=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) gt commonmark dplyr fontawesome ggplot2 glue htmltools paletteer rlang scales knitr cli;
    };
   })
(pkgs.rPackages.buildRPackage {
    name = "compareMCMCs";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/compareMCMCs_0.6.0.tar.gz";
      sha256 = "sha256-4zsxcm26YTMRM1oJpqfnr/TRzdCaGEuE1Yynd33oxD0=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) dplyr nimble R6 ggplot2 reshape2 xtable coda;
    };
 })
#(pkgs.rPackages.buildRPackage {
#    name = "gtsummary";
#    src = pkgs.fetchzip {
#      url = "https://cran.r-project.org/src/contrib/gtsummary_2.0.3.tar.gz";
#      sha256 = "sha256-2/HsuOeOwwVJvkJmidHlob+nFBqLQqsEPhcDYJD/Ngw=";
#    };
#    propagatedBuildInputs = builtins.attrValues {
#      inherit (pkgs.rPackages) broom broom_helpers cards cli dplyr forcats glue gt knitr lifecycle purrr rlang stringr tibble tidyr vctrs;
#    };
#   })
 (pkgs.rPackages.buildRPackage {
    name = "simcasual";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/simcausal_0.5.7.tar.gz";
      sha256 = "sha256-Q4T28EeAXj5dKhZvPqz5uhTGP72wRT1N/B1pMDRCzQI=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) data_table igraph stringr R6 assertthat Matrix copula RUnit ltmle knitr ggplot2 Hmisc mvtnorm bindata;
    };
   })
   (pkgs.rPackages.buildRPackage {
    name = "cutpointr";
    src = pkgs.fetchzip {
      url = "https://cran.r-project.org/src/contrib/cutpointr_1.1.2.tar.gz";
      sha256 = "sha256-Ks0ZWSCYyFrOhZY2QC+1TiVCVtTu4oNWJ4S3RiXL/68=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) gridExtra foreach dplyr tidyselect tidyr purrr tibble ggplot2 Rcpp rlang;
    };
   })
#   (pkgs.rPackages.buildRPackage {
#    name = "WRS2";
#    src = pkgs.fetchzip {
#      url = "https://cran.r-project.org/src/contrib/WRS2_1.1-5.tar.gz";
#      sha256 = "sha256-vZL1izWHKZSWr4OrR/qXnTFo/GsZEaMV1l4FduY29b8=";
#    };
#    propagatedBuildInputs = builtins.attrValues {
#      inherit (pkgs.rPackages) MASS reshape plyr;
#    };
#   })
   # (pkgs.rPackages.buildRPackage {
    # name = "arrow";
    # src = pkgs.fetchzip {
    #   url = "https://cran.r-project.org/src/contrib/Archive/arrow/arrow_14.0.0.tar.gz";
    #   sha256 = "sha256-7BiMxUCom0mbgv0mspgfv9Yb+AR5DMCGrEG4EO37r9o=";
    # };
    # propagatedBuildInputs = builtins.attrValues {
    #   inherit (pkgs.rPackages) assertthat bit64 glue purrr R6 rlang tidyselect vctrs cpp11;
    # };
   #})
#(pkgs.rPackages.buildRPackage {
#    name = "flextable";
#    src = pkgs.fetchzip {
#      url = "https://cran.r-project.org/src/contrib/flextable_0.9.4.tar.gz";
#      sha256 = "sha256-2lVvyMYr33pN6DiSHbdrpr/uYCNZvvj4JYAdmONpBpc=";
#    };
#    propagatedBuildInputs = builtins.attrValues {
#      inherit (pkgs.rPackages) rmarkdown knitr htmltools data_table rlang ragg officer gdtools xml2 uuid;
#    };
#  })
];
 tex = (pkgs.texlive.combine {
  inherit (pkgs.texlive) scheme-basic ;
});
 system_packages = builtins.attrValues {
  inherit (pkgs) R zlib pkg-config libcanberra-gtk3 libcanberra-gtk2 libcanberra;
};
 rstudio_pkgs = pkgs.rstudioWrapper.override {
  packages = [ git_archive_pkgs 
  ];
};
      in 
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = with pkgs;
   		[
          	   git_archive_pkgs
          	   system_packages
		   rstudio_pkgs
		   rPackages.rstan
		   rPackages.shinystan
		   rPackages.MatchIt
		   rPackages.survival
		   rPackages.nimble
		   rPackages.flextable
		   #rPackages.arrow
          	];
        };
      });
}
