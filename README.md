# Grade-Analyzer
## Abstract

Often, people only receive their grades and final scores. This tool offers a simple solution by generating key metrics about the user's grades and providing visual plots to enhance understanding and analysis.

By adding the user's information in a ``.jl`` file, just like ``example_data.jl``, a simple command like

```bash
  julia grade-analyzer.jl example_data.jl
```

allows ``Julia`` to automatically generate all the plots and metrics, as demonstrated in the ``output`` folder.

## Example Output

After running the command:

```bash
julia grade-analyzer.jl example_data.jl
```

the output in the terminal will be:

```
==================== Grade Analyser ====================
>>> Importing file from the user input... Done!
>>> Making sure that the data is in the correct format... Done!
>>> Setting up the output folder... Done!
>>> Computing grades by period... Done!
>>> Computing grade distribution... Done!
>>> Computing average grade by period... Done!
>>> Computing grade information... Done!
========================= Done =========================
```

following this, the corresponding ``.png`` and ``.txt`` files will be generated and saved in the directory ``output`` automatically created in the directory where the ``Julia`` command was executed.
