# tmux-monitor-scripts

Adds output of custom monitor scripts to your status line.

## Example

In your `~/.tmux/monitors/`:

```

```

In your tmux configuration:

```
set-option -g status-left ' %a %m-%d %H:%M | #{monitor_test}'

```

## TODO
* Implement options
    * Display format:
       * #{monitor_name}
       * #{monitor_output}
    * Monitor separator
