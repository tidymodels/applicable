# bad args

    Code
      apd_similarity(tr_x, quantile = 2)
    Condition
      Error in `apd_similarity_bridge()`:
      ! The `quantile` argument should be NA or a single numeric value in [0, 1].

---

    Code
      apd_similarity(tr_x_sp)
    Condition
      Error in `apd_similarity()`:
      ! `x` is not of a recognized type.
      Only data.frame, matrix, recipe, and formula objects are allowed.
      A dgCMatrix was specified.

# printed output

    Code
      print(apd_similarity(tr_x))
    Output
      Applicability domain via similarity
      Reference data were 20 variables collected on 50 data points.
      New data summarized using the mean.

---

    Code
      print(apd_similarity(tr_x))
    Output
      Applicability domain via similarity
      Reference data were 20 variables collected on 50 data points.
      New data summarized using the mean.

---

    Code
      print(apd_similarity(tr_x))
    Output
      Applicability domain via similarity
      Reference data were 20 variables collected on 50 data points.
      New data summarized using the mean.

---

    Code
      print(apd_similarity(tr_x, quantile = 0.13))
    Output
      Applicability domain via similarity
      Reference data were 20 variables collected on 50 data points.
      New data summarized using the 13th percentile.

# apd_similarity fails when quantile is neither NA nor a number in [0, 1]

    Code
      apd_similarity(tr_x, quantile = -1)
    Condition
      Error in `apd_similarity_bridge()`:
      ! The `quantile` argument should be NA or a single numeric value in [0, 1].

---

    Code
      apd_similarity(tr_x, quantile = 3)
    Condition
      Error in `apd_similarity_bridge()`:
      ! The `quantile` argument should be NA or a single numeric value in [0, 1].

---

    Code
      apd_similarity(tr_x, quantile = "la")
    Condition
      Error in `apd_similarity_bridge()`:
      ! The `quantile` argument should be NA or a single numeric value in [0, 1].

# apd_similarity outputs warning with zero variance variables 

    Code
      apd_similarity(bad_data)
    Condition
      Warning:
      The following variables had zero variance and were removed: a, b, and d
    Output
      Applicability domain via similarity
      Reference data were 1 variables collected on 2 data points.
      New data summarized using the mean.

# apd_similarity fails when all the variables have zero variance

    Code
      apd_similarity(bad_data)
    Condition
      Error in `apd_similarity_bridge()`:
      ! All variables have a single unique value.

# apd_similarity fails data is not binary

    Code
      apd_similarity(bad_data)
    Condition
      Error in `apd_similarity_bridge()`:
      ! The following variables are not binary: b, and d

