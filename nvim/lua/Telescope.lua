require("telescope").load_extension("emoji")
require("telescope").load_extension("pathogen")

require('telescope').setup {
    defaults = {
        prompt_prefix = '>>> ',
        sorting_strategy = 'ascending',
        layout_strategy = 'horizontal',
        layout_config = {
            prompt_position = 'top',
        },
    },
}
