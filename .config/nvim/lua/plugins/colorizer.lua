return {
  "catgoose/nvim-colorizer.lua",
  opts = {
    user_default_options = {
      names = false,
      css = true,
      css_fn = true,
      tailwind = "both",
      sass = { enable = true, parsers = { "css" } },
      mode = "virtualtext",
      virtualtext_inline = "before",
    },
  },
}
