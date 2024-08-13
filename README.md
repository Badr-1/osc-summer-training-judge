# OSC Summer Training Judge

To Expand on what I made for '23 Summer Training I wrote two scripts to automate the process for publishing tasks and testing answers

## [task-delivery](task-delivery.sh)

This script reads students repositories from [repos.csv](repos.csv) and clone them and uploading the The Task Directory to them.
The Initial Example here would be [Task-1](Task-1)

```bash
./task-delivery.sh $path_to_task
```

Each Task should only contains:
- [x] README.md: for description
- [x] validate.sh: for testing solution
- [x] solution.sh or any suitable files for students to deliver their task.

### Important Note
Created Tasks should be Testable, Some Tasks made on '23 Summer Training wasn't made to be tested via a script.

To use this judge you have to write a task that leaves a testable effect.


## [task-validation](task-validation.sh)

This script also reads students repositories from [repos.csv](repos.csv) and clone them and goes throgh given task and test it given Task Directory.

```bash
./task-validation.sh $path_to_task
```

