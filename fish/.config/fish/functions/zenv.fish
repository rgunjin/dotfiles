function zenv --description 'Zephyr dev environment'
    source ~/zephyrproject/.venv/bin/activate.fish
    set -gx ZEPHYR_BASE ~/zephyrproject/zephyr
    set -gx ZEPHYR_TOOLCHAIN_VARIANT zephyr
    set -gx ZEPHYR_SDK_INSTALL_DIR /opt/zephyr-sdk-1.0.1
    echo "zephyr "(git -C $ZEPHYR_BASE describe --tags)" | sdk 1.0.1"
end
