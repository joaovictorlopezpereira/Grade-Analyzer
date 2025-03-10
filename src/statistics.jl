
# Computes the weighted mean
function weighted_mean(data, weights)
  return dot(data, weights) / foldl(+, weights)
end

# Computes the mode
function sample_mode(data)
  freq = Dict{eltype(data), Int}()
  max_key, max_freq = nothing, 0

  for val in data
    count = get!(freq, val, 0) + 1
    freq[val] = count
    if count > max_freq
      max_key, max_freq = val, count
    end
  end

  return max_key
end

# Computes the weighted standard deviation
function weighted_std_dev(data, weights)
  mean_value = weighted_mean(data, weights)
  weighted_variance = sum(weights .* (data .- mean_value).^2) / sum(weights)
  return sqrt(weighted_variance)
end

# Computes the median
function median_custom(data)
  sorted_data = sort(data)
  n = length(sorted_data)

  if n % 2 == 1
    return sorted_data[Int((n + 1) / 2)]
  else
    mid1 = sorted_data[Int(n / 2)]
    mid2 = sorted_data[Int(n / 2) + 1]
    return (mid1 + mid2) / 2
  end
end

# Computes the best polynomial function (Least Squares theory)
function poly_reg(xs, ys, degree)
  coefficients = [x^(j - 1) for x in xs, j in 1:(degree + 1)] \ ys
  return (x) -> sum(coefficients[i] * x^(i - 1) for i in eachindex(coefficients))
end