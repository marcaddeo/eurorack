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
    docker run --privileged --rm -v $(pwd):/workdir -e PYTHONPATH=/workdir archont94/mutable-env:latest bash -c "cd /workdir && make {{ args }}"

flash module="plaits":
    afplay build/{{ module }}/{{ module }}.wav

upload:
    openocd -s /opt/local/share/openocd/scripts/ -f interface/stlink-v2.cfg -f target/stm32f3x.cfg -c "init" -c "halt" -c "sleep 200" \
        -c "flash erase_address 0x08000000 32768" \
        -c "reset halt" \
        -c "flash write_image erase build/plaits/plaits_bootloader_combo.bin 0x08000000" \
        -c "verify_image build/plaits/plaits_bootloader_combo.bin 0x08000000" \
        -c "sleep 200" -c "reset run" -c "shutdown"

debug-server:
    openocd \
        -s /opt/local/share/openocd/scripts/ \
        -f interface/stlink-v2.cfg \
        -f target/stm32f3x.cfg \
        -c "init;reset;halt" \

debug-client:
    arm-none-eabi-gdb --eval-command="target remote localhost:3333" build/plaits/plaits.elf
