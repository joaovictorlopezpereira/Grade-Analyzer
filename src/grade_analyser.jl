using Plots
using LinearAlgebra
include("statistics.jl")

# Asserts that the given file is in the correct format and returns the data
function assert_and_import_file_from_arg(ARGS)
  if length(ARGS) == 0
    print("\nThe data file is missing from the function call!\n")
    print("============================== Exit ==============================\n")
    exit(1)
  end

  name = endswith(ARGS[1], ".jl") ? ARGS[1] : ARGS[1] * ".jl"

  if isfile(name)
    return include(name)
  else
    print("\nFile '$name' not found!\n")
    print("============================== Exit ==============================\n")
    exit(1)
  end
end

# Verifies if any of the given data is missing
function assert_data(data)
  for i in eachindex(data)
    @assert length(data[i]) == 3 "The data on period $i is missing one of the 3 required information (name, grade, weight)."

    @assert length(data[i][1]) == length(data[i][2]) && length(data[i][2]) == length(data[i][3]) "There's data missing on the period $i."
  end
end

# Plots the grade by period
function plot_grades_by_period!(data)
  plt = plot(size=(800, 800), label="Grades per Period", xlabel="Period", ylabel="Grades", legend=:topright, xlims=(0.8, length(data)+0.5))

  x_vals = []
  y_vals = []
  labels = []

  for i in eachindex(data)
    period_data = data[i]
    disciplines, grades, _ = period_data

    for j in eachindex(disciplines)
      push!(x_vals, i)
      push!(y_vals, grades[j])
      push!(labels, disciplines[j])
    end
  end

  scatter!(plt, x_vals, y_vals, label="", markersize=6, color=:blue)

  occupied_positions = Dict()

  for i in eachindex(labels)
    x_pos = x_vals[i]
    y_pos = y_vals[i]
    label = labels[i]

    if haskey(occupied_positions, (x_pos, y_pos))
      occupied_positions[(x_pos, y_pos)] += 0.1
      y_pos = occupied_positions[(x_pos, y_pos)]
    else
      occupied_positions[(x_pos, y_pos)] = y_pos
    end

    annotate!(plt, x_pos + 0.125, y_pos, text(label, :left, 10))
  end

  savefig("output/grades_per_period.png")
end

# Plots the grade distribution by using a histogram
function plot_grade_distribution!(data; b=100)
  notes, _, _ = get_notes_disciplines_weights(data)

  histogram(notes, bins=b, xlabel="Grades", ylabel="Frequency", title="Grades Distribution", legend=false, color=:blue, size=(800, 800))
  savefig("output/grades_distribution.png")
end

# Plots the average grade by period
function plot_average_grade_by_period!(data; tendency=false, degree=2)
  period_averages = Float64[]
  n = collect(1:length(data))

  for period_data in data
    _, notes, weights = period_data
    push!(period_averages, weighted_mean(notes, weights))
  end

  plt = scatter(n, period_averages, xlabel="Period", ylabel="Average Grade", title="Average Grade by Period", legend=false, color=:blue)

  for i in eachindex(period_averages)
    annotate!(plt, n[i], period_averages[i] + 0.05, text("s$i", 10, :center))
  end

  if tendency
    plot!(poly_reg(n, period_averages, degree))
  end

  savefig("output/average grade_by_period.png")
end

# Writes in a file some statistics
function write_in_file_grade_info!(data, output_file)
  output_file = "output/statistics_" * replace(output_file, r"\.jl$" => "") * ".txt"

  notes, disciplines, weights = get_notes_disciplines_weights(data)

  content = """
  +------------------------------+-----+
  |       Number of disciplines: | $(length(disciplines))
  |               Average grade: | $(round(weighted_mean(notes, weights), digits=2))
  |                      Median: | $(round(median_custom(notes), digits=2))
  |                        Mode: | $(round(sample_mode(notes), digits=2))
  | Weighted standard deviation: | $(round(weighted_std_dev(notes, weights), digits=2))
  +------------------------------+-----+
  """

  open(output_file, "w") do file
    write(file, content)
  end
end

# Gets all notes, disciplines and weights from the data
function get_notes_disciplines_weights(data)
  notes = Float64[]
  disciplines = String[]
  weights = Float64[]

  for period_data in data
    d, n, w = period_data
    append!(notes, n)
    append!(disciplines, d)
    append!(weights, w)
  end

  return notes, disciplines, weights
end

# Runs all the methods
function run_all_methods!(ARGS; tend=false, deg=2)
  print("\n========================= Grade Analyser =========================\n")
  print(">>> Importing file from the user input...                 ",)
  data = assert_and_import_file_from_arg(ARGS)
  print(" Done!\n")

  prints = [
    ">>> Making sure that the data is in the correct format... ",
    ">>> Setting up the output folder...                       ",
    ">>> Computing grades by period...                         ",
    ">>> Computing grade distribution...                       ",
    ">>> Computing average grade by period...                  ",
    ">>> Computing grade information...                        "
  ]
  methods = [
    () -> assert_data(data),
    () -> mkpath("output"),
    () -> plot_grades_by_period!(data),
    () -> plot_grade_distribution!(data),
    () -> plot_average_grade_by_period!(data, tendency=tend, degree=deg),
    () -> write_in_file_grade_info!(data, ARGS[1])
  ]

  for i in eachindex(methods)
    print(prints[i])
    methods[i]()
    print(" Done!\n")
  end

  print("============================== Done ==============================\n")
end

run_all_methods!(ARGS, tend=true, deg=1)