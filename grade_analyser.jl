using Plots
using LinearAlgebra
include("statistics.jl")

function plot_grades_by_period!(data)
  plt = plot(size=(800, 800), label="Grades per semester", xlabel="Semester", ylabel="Grades", legend=:topright, xlims=(0.8, length(data)+0.5))

  x_vals = []
  y_vals = []
  labels = []

  for i in 1:length(data)
    period_data = data[i]
    disciplines, grades, _ = period_data

    for j in 1:length(disciplines)
      push!(x_vals, i)
      push!(y_vals, grades[j])
      push!(labels, disciplines[j])
    end
  end

  scatter!(x_vals, y_vals, label="", markersize=6, color=:blue)

  occupied_positions = Dict()

  for i in 1:length(labels)
    x_pos = x_vals[i]
    y_pos = y_vals[i]
    label = labels[i]

    if haskey(occupied_positions, (x_pos, y_pos))
      occupied_positions[(x_pos, y_pos)] += 0.1
      y_pos = occupied_positions[(x_pos, y_pos)]
    else
      occupied_positions[(x_pos, y_pos)] = y_pos
    end

    annotate!(x_pos + 0.05, y_pos, text(label, :left, 10))
  end

  savefig("output/grades_per_semester.png")
end

function plot_grade_distribution!(data; b=100)
  all_notes = Float64[]

  for period_data in data
    _, notes, _ = period_data
    append!(all_notes, notes)
  end

  plt = histogram(all_notes, bins=b, xlabel="Grades", ylabel="Frequency", title="Grades distribution", legend=false, color=:blue)
  savefig("output/grades_distribution.png")
end

function write_in_file_grade_info!(data, output_file)
  output_file = "output/" * replace(output_file, r"\.jl$" => "") * ".txt"

  all_notes = Float64[]
  all_disciplines = String[]
  all_weights = Float64[]

  for period_data in data
    disciplines, notes, weight = period_data
    append!(all_notes, notes)
    append!(all_disciplines, disciplines)
    append!(all_weights, weight)
  end

  num_disciplines = length(all_disciplines)
  avg_grade = weighted_mean(all_notes, all_weights)
  median = median_custom(all_notes)
  mode = sample_mode(all_notes)
  w_std_dev = weighted_std_dev(all_notes, all_weights)

  content = """
  +------------------------------+-----+
  |       Number of disciplines: | $num_disciplines
  |               Average grade: | $(round(avg_grade, digits=2))
  |                      Median: | $(round(median, digits=2))
  |                        Mode: | $(round(mode, digits=2))
  | Weighted standard deviation: | $(round(w_std_dev, digits=2))
  +------------------------------+-----+
  """

  open(output_file, "w") do file
    write(file, content)
  end
end

function plot_average_grade_by_period!(data; tendency=false, degree=2)
  period_averages = Float64[]
  n = collect(1:length(data))

  for period_data in data
    disciplines, notes, weights = period_data
    push!(period_averages, weighted_mean(notes, weights))
  end

  plt = scatter(n, period_averages, xlabel="Semester", ylabel="Average grade", title="Average grade by semester", legend=false, color=:blue)

  for i in 1:length(period_averages)
    annotate!(n[i], period_averages[i] + 0.05, text("s$i", 10, :center))
  end

  if tendency
    plot!(poly_reg(n, period_averages, degree))
  end

  savefig("output/average grade_by_semester.png")
end

function import_file_from_arg!(ARGS)
  if length(ARGS) == 0
    println("The data file is missing from the function call.")
    exit(1)
  end

  name = ARGS[1]

  if !endswith(name, ".jl")
    name *= ".jl"
  end

  if isfile(name)
    include(name)
  else
    println("File '$name' not found.")
    exit(1)
  end
end

function run_all_methods!(data, ARGS; tend=false, deg=2)
  print("\n==================== Grade Analysis ====================\n")

  print(">>> Running grades by period...\n")
  plot_grades_by_period!(data)

  print(">>> Running grade distribution...\n")
  plot_grade_distribution!(data)

  print(">>> Running grade information...\n")
  write_in_file_grade_info!(data, ARGS[1])

  print(">>> Running average grade by period...\n")
  plot_average_grade_by_period!(data, tendency=tend, degree=deg)

  print("========================= Done =========================\n")
end

import_file_from_arg!(ARGS)
mkpath("output")
run_all_methods!(data, ARGS, tend=true, deg=2)
