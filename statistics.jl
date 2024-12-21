function weighted_mean(data, weights)
  @assert length(data) == length(weights)
  return dot(data, weights) / foldl(+, weights)
end

function sample_mode(data)
  freq = Dict()
  for val in data
    if haskey(freq, val)
      freq[val] += 1
    else
      freq[val] = 1
    end
  end
  max_freq = maximum(values(freq))
  modes = [key for (key, value) in freq if value == max_freq]

  return modes[1]
end

function weighted_std_dev(data, weights)
  mean_value = weighted_mean(data, weights)
  weighted_variance = sum(weights .* (data .- mean_value).^2) / sum(weights)
  return sqrt(weighted_variance)
end

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

function poly_reg(xs, ys, degree)
  coefficients = [x^(j - 1) for x in xs, j in 1:(degree + 1)] \ ys
  return (x) -> sum(coefficients[i] * x^(i - 1) for i in 1:length(coefficients))
end