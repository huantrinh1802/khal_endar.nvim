# Khal in Neovim

## Description

The plugin allow you to view and interact with calendar events via Khal without ever leaving the comfort of Neovim text

## Screenshots

## Features

- View `khal calendar` and `khal list` with colours supported
  - Add relative dates and named dates support
- Interface for `ikhal`

## Dependencies

- [khal](https://khal.readthedocs.io/en/latest/) (hard required)
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)
  - For all UIs in the plugin
- [colorizer](https://github.com/chrisbra/Colorizer)
  - Provide colours for `khal` ANSI colors output

## Work Well With

- [vdirsyncer](https://vdirsyncer.pimutils.org/en/stable/tutorial.html)

## Installation

```lua
{
    "huantrinh1802/khal_endar.nvim/",
    version = "*",
    dependencies = { "MunifTanjim/nui.nvim", "chrisbra/Colorizer" },
    config = function()
    -- Require
      require("khal_endar").setup()
    -- Optional
      vim.api.nvim_set_keymap("n", "<leader>ki", "<cmd>KLInteract<cr>", { desc = "[K]hal [I]interact", noremap = true, silent = true })
  },
```

## Commands

- `:KLInteract`: View and interact with events
- `:KLShow`: equivalent to `khal calendar`
  - Accept argurments:
    - `nil`: use `2week` as default
    - Dates range: `2021-01-01 2021-01-31`
    - Period window: `quarter`    
    - Relative dates: `2week` 
- `:KLList`: equivalent to `khal list`
- `:KLRun`: allow you to run `khal [COMMAND]` within neovim

## Dates

- The following is applicable to `KLShow` and `KLList`
    - Relative dates in the form of `1d[ays]`, `1w[eeks]`, `1m[onths]`, `1y[ears]`
    - Period window: `year`, `quarter`, `month`, `week`, `day`

## License

This plugin is licensed under the MIT License. See the LICENSE file for more
 details.

## Issues

If you encounter any issues or have suggestions for improvements, please open
 an issue on the GitHub repository.

## Contributors

- Ben Trinh <huantrinh1802@gmail.com>

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W4VVT9J)

Thank you for using the Neovim Lua Plugin! If you find it helpful, please consider
 starring the repository.

