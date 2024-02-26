#!/usr/bin/env python

import sys
import subprocess as subproc
import shlex
from pathlib import Path
from importlib.util import find_spec
from typing_extensions import Annotated


DEVNULL = subproc.DEVNULL
SETORG_FP = str(Path(__file__).resolve())
SETORG_DP = str(Path(__file__).resolve().parent)
# Paths
USERHOME = Path("/home/saeranv").resolve()
USERBIN = USERHOME.joinpath("bin").resolve()
ZSHRC = USERHOME.joinpath(".zshrc").resolve()


if find_spec('typer') is None:
    _cmd = f'''/bin/bash -c "{sys.executable} -m pip install typer"'''
    print(f"Stdin:\n{_cmd}")
    _ = subproc.run(
        shlex.split(_cmd), shell=False,
        stdout=sys.stdout.fileno(), stderr=sys.stderr.fileno()
    )


import typer
app = typer.Typer()


@app.command()
def run_cmd(cmd:str, cwd:str=SETORG_DP) -> str:
    """Run a command and return the output as a string.

    ```python
        stdout, args = run_cmd("/bin/bash -c 'echo $PWD'")
        stdout: /mnt/c/Users/saera/master/orgctl/setup
        args: ['/bin/bash', '-c', 'echo $PWD']
    ```
    """


    # To pipe directly to terminal
    # stdout, stderr = sys.stdout.fileno(), sys.stdout.fileno()
    # To captured in subproc.PIPE for use as python var
    stdout, stderr = subproc.PIPE, subproc.STDOUT

    # Split command
    args = shlex.split(cmd)
    print(cmd)

    # Run
    proc = subproc.run(
        args,
        stdin=subproc.PIPE, # to communicate w/ process
        stdout=stdout, stderr=stderr,
        cwd=SETORG_DP,
        shell=False,  # False uses $SHELL env var, or else uses /bin/sh
    )

    stdout = proc.stdout.decode('utf-8')
    rcode = proc.returncode
    if rcode != 0:
        raise Exception(
            f"For cmd:\n {args}\nGot nonzero returncode:{rcode}"
        )

    if stdout:
        print(stdout)

    return stdout


@app.command()
def link_setorg(run:bool=False) -> None:
    """Set symlink for setorg.py in ~/bin/

    ```bash
    python $setup/setorg.py link_setorg --run
    ```
    """
    bin_dp = USERBIN
    setorg_ln = bin_dp.joinpath("setorg")
    cmds = []

    # Chmod
    cmds += [f'/bin/bash -c "chmod +x {SETORG_FP}"']

    # Check if exists
    if setorg_ln.exists():
        # print(f"Found, and removing existing symlink at {setorg_ln}.")
        # _ = setorg_ln.unlink()
        cmds += [f'/bin/bash -c "rm {setorg_ln}"']

    # print(f"Creating symlink at {setorg_ln}.")
    # setorg_ln.symlink_to(SETORG_FP)
    cmds += [f'/bin/bash -c "ln -sf {SETORG_FP} {setorg_ln}"']

    print(f"Commands run={run}:")
    _fn = run_cmd if run else print
    _ = [_fn(cmd) for cmd in cmds]


@app.command()
def install_starship(run:bool=False, skip_fonts:bool=True, skip_starship:bool=True) -> None:
    """Install starship prompt.

    # TODO: nerdfonts: https://gist.github.com/matthewjberger/7dd7e079f282f8138a9dc3b045ebefa0?permalink_comment_id=3839120#gistcomment-3839120
    # TODO: https://starship.rs/guide/#%F0%9F%9A%80-installation
    """

    cmds = []
    if not skip_fonts:
        print("Installing fonts")
        cmds += "sudo apt-get install fonts-firacode"
        # stdout, args = run_cmd(cmd)

    if not skip_starship:
        print("Installing starship")
        cmds += "sh -c \"$(curl -fsSL https://starship.rs/install.sh)\""
        # stdout, args = run_cmd(cmd)

    if not run:
        print(cmds, sep="\n")


@app.command()
def install_z(
    run:bool=False,
    skip_zdir:Annotated[bool, typer.Option(help="Skip z dir setup")]=True,
    skip_zshrc:Annotated[bool, typer.Option(help="Skip z.sh in .zshrc")]=True,
    skip_man:Annotated[bool, typer.Option(help="Skip z manpag")]=True
    ) -> None:
    """Install z .

    ref: https://github.com/rupa/z
    """

    z_gp = "https://github.com/rupa/z.git"
    z_dp = USERHOME.joinpath("z")
    z_fp = z_dp.joinpath("z.sh")
    z_mp = Path("/usr/share/man/man1/z.1")

    cmds = []

    if not skip_zdir:
        # Check and setup z dir
        if z_dp.exists():
            cmds += [f"rm -rf {z_dp}"]
        cmds += [f"mkdir -p {z_dp}"]
        cmds += [f"git clone {z_gp} {z_dp}"]

    if not skip_zshrc:
        # Check and setup z.sh in .zshrc
        with open(ZSHRC, "r") as f:
            is_zsh = any("z.sh" in x for x in f.readlines())
            print(f"z.sh in .zshrc: {is_zsh}")

        if run and (not is_zsh):
            with open(ZSHRC, "a") as f:
                f.write(f". {z_fp}\n")

    if not skip_man:
        # Check and setup z manpag
        if z_mp.exists():
            cmds += [f"rm -f {z_mp}"]
        cmds += [f'sudo cp "{z_dp}/z.1" "{z_mp}"']

    print(f"{len(cmds)} commands; run={run}\n")
    _fn = run_cmd if run else print
    _ = [_fn(cmd) for cmd in cmds]



# TODO: temp until I can figure out to use typer / use bash
# for env changes
@app.command()
def fp():"""$ realpath SETORG_FP"""; print(SETORG_FP)
@app.command()
def cat():"""$ cat SETORG_FP""";run_cmd(f"/bin/bash -c 'cat {SETORG_FP}'")


if __name__ == "__main__":

    app()



