# Grade-Analyzer
## Abstract

Often, people only receive our grades and final scores. This tool offers a simple solution by generating key metrics about the user's grades and providing visual plots to enhance understanding and analysis.

By adding the user's information in a ``.jl`` file, just like ``random_data.jl`` shown in the ``example`` folder, a simple command like ``julia grade-analyzer.jl user_data.jl`` will allow ``Julia`` to automatically generate all the plots and metrics, as demonstrated in the ``example`` folder.

## Example Output

After running the command:

```bash
julia grade-analyzer.jl user_data.jl
```

the output in the terminal will be:

```
==================== Grade Analysis ====================
>>> Running grades by period...
>>> Running grade distribution...
>>> Running grade information...
>>> Running average grade by period...
========================= Done =========================
```

following this, the corresponding ``.png`` and ``.txt`` files will be generated and saved in the directory where the ``Julia`` command was executed.
