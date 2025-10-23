chooser := "grep -v choose | fzf --tmux"

# Display this list of available commands
@list:
    just --justfile "{{ source_file() }}" --list

alias c := choose
# Open an interactive chooser of available commands
[no-exit-message]
@choose:
    just --justfile "{{ source_file() }}" --chooser "{{ chooser }}" --choose 2>/dev/null

alias e := edit
# Edit the justfile
@edit:
    $EDITOR "{{ justfile() }}"

@make *args:
    docker run --rm -v $(pwd):/workdir -e PYTHONPATH=/workdir archont94/mutable-env:latest bash -c "cd /workdir && make {{ args }}"

flash module="plaits":
    afplay build/{{ module }}/{{ module }}.wav
