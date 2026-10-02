return {
  "catgoose/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    options = {
      parsers = {
        css = true,
        tailwind = { enable = true },
      },
      display = {
        mode = "virtualtext",
        virtualtext = { char = "󰝤", position = "before" },
      },
    },
  },
}
