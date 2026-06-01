ACTION=${1-'-d'}

# attach mode for systemd
if [ "$ACTION" == "-a" ]; then
  exec qs -p "$SRC"
else
  exec qs -p "$SRC" "$ACTION"
fi
