import sys
from io import StringIO
from invoke import task, Result, Context
from shlex import quote


EMPTY_ERROR = "no server running on /tmp/tmux-1000/default"


def cmd_echo(txt, opts=""):
    opts = " " if not opts else f" {args} "
    return f'''echo{opts}"{txt}"'''


def cmd_tmux_dispmsg(fmt_str, opts=""):
    """Get stdout from tmux display-message

    Examples:
    ```
    $ tmux display-message -p "#{window_index}::{#pane_index}"
    >> 1::2
    $ tmux display-message -t x:1 -p "{#pane_index}"
    >> 2
    ```

    Call command without target (-t) to ensure we get
    current session/window/pane.
    """
    # pad opts if not empty
    opts = " " if not opts else f" {opts} "
    return f'''tmux display-message{opts}"{fmt_str}"'''


def cmd_tmux_viewpane(target):
    """Capture {lines} of tmux stdout of buffer."""
    # grep .   # to remove empty lines
    # lines+2 # to acount for next empty input lines
    cmds = [
        f'''tmux capture-pane -p -t {target}''',
    ]
    return " ".join(cmds)


def cmd_tmux_sendkeys(send_cmd, wait=False, opts=""):
    """Send keys to tmux target.

    ```
    # target specific pane
    $ tmux send-keys -t x:1.1 "echo hello" ENTER
    # target last active pane
    $ tmux send-keys -t ! "echo hello" ENTER
    ```
    """
    wait_cmd = "tmux wait-for -S wsig" if wait else ""
    send_cmd = "; ".join([send_cmd, wait_cmd])
    send_cmd = quote(send_cmd)
    opts = " " if not opts else f" {opts} "
    send_cmd = f'''tmux send-keys{opts}{send_cmd} ENTER;\n'''
    if wait:
        send_cmd += '''tmux wait-for wsig'''
    return send_cmd


def cmd_list_tmux_ids():
    """Get all tmux ids.

    ```
    $ tmux list-panes -aF "#{session_name}:#{window_index}.#{pane_index}"
    >> x:1.1
       x:1.2
       y:1.1
    ```
    """
    return "tmux list-panes -aF " + \
           "'#{session_name}:#{window_index}.#{pane_index}'"


@task
def list_ids(ctx, debug=False):
    """List all tmux ids."""

    list_cmd = cmd_list_tmux_ids()
    if debug:
        print(list_cmd)
        return ''

    try:
        res = ctx.run(list_cmd, hide=True)
        stdout = res.stdout.strip()
    except Exception as e:
        stdout = ""

    print(stdout)

@task
def num_ids(ctx, debug=False):
    """Get number of tmux ids.

    Equivalent to"
    $ tmuxutil list-ids | wc -words
    """

    # Assign str to stdout
    sys.stdout = result = StringIO()
    _ = list_ids(ctx, debug=False)
    result_str, sys.stdout = result.getvalue(), sys.__stdout__
    if debug:
        print('list-ids\n', result_str)
        return

    res = ctx.run(f'''echo "{result_str}" | wc --words''',
                  hide=True)
    _num_ids = int(res.stdout.strip())
    # Count
    print(_num_ids)


@task
def pane_id(ctx, target="", debug=False):
    """Get target pane index."""

    # Get current session, window, pane name as stdout str
    pane_id_str = "#{pane_index}"
    opts = f"-t {target} -p" if target else "-p"
    tmux_cmd = cmd_tmux_dispmsg(pane_id_str, opts=opts)

    if debug:

        print(f"run_cmd: {tmux_cmd}")

    else:

        res = ctx.run(tmux_cmd, hide=True)
        _pane_id = res.stdout.strip() # -> x
        print(_pane_id)


@task
def window_id(ctx, target="", debug=False):
    """Get target pane index."""

    # Get current session, window, pane name as stdout str
    pane_id_str = "#{window_index}"
    opts = f"-t {target} -p" if target else "-p"
    tmux_cmd = cmd_tmux_dispmsg(pane_id_str, opts=opts)

    if debug:

        print(f"run_cmd: {tmux_cmd}")

    else:

        res = ctx.run(tmux_cmd, hide=True)
        _pane_id = res.stdout.strip() # -> x
        print(_pane_id)


@task
def session_id(ctx, target="", debug=False):
    """Get target pane index."""

    # Get current session, window, pane name as stdout str
    pane_id_str = "#{session_name}"
    opts = f"-t {target} -p" if target else "-p"
    tmux_cmd = cmd_tmux_dispmsg(pane_id_str, opts=opts)

    if debug:

        print(f"run_cmd: {tmux_cmd}")

    else:

        res = ctx.run(tmux_cmd, hide=True)
        _pane_id = res.stdout.strip() # -> x
        print(_pane_id)



@task
def tmux_id(ctx, target="", debug=False):
    """Get current session:window.pane.

    Format:
        x:1.1 -> '{session_name}:{window_index}.{pane_index}'
        i.e. session x w/ a window w/ two panes: x:1.1, x:1.2
             session y w/ 2 windows, w/ 1 pane: y:1.1, y:1.2, y:2.1

    Ref: https://man7.org/linux/man-pages/man1/tmux.1.html#FORMATS
    """

    # Get current session, window, pane name as stdout str
    tmux_id_str = "#{session_name}:#{window_index}.#{pane_index}"
    opts = f"-t {target} -p" if target else "-p"
    tmux_cmd = cmd_tmux_dispmsg(tmux_id_str, opts)

    if debug:

        print(f"run_cmd: {tmux_cmd}")

    else:

        res = ctx.run(tmux_cmd, hide=True)
        active_id = res.stdout.strip() # -> x
        print(active_id)

@task
def view_cmd(ctx, target="x:1.2"):
    """View output in current session for given target."""
    # Depreciate
    _send_cmd = cmd_tmux_viewpane(target)
    res = ctx.run(_send_cmd, hide=True, timeout=15)
    print(res.stdout.strip())


@task
def send_keys(ctx, target="x:1.2", send_msg="echo 'test'", wait=False):
    """Run command in target session, output in current session."""

    _send_cmd = cmd_tmux_sendkeys(send_msg, wait=wait, opts=f'-t {target}')
    res = ctx.run(_send_cmd, echo_stdin=True, hide=True, timeout=15)
    # print(res.stdout.strip())

