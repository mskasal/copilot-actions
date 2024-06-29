" plugin/custom_action.vim
lua << EOF
print("Loading custom_action module...")
require('custom_action').setup()
print("Loaded custom_action module")
EOF
