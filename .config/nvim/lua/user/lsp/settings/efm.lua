return {
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      sh = {
        {
          formatCommand = "shfmt -ci -s -bn",
          formatStdin = true,
        },
        {
          lintCommand = "shellcheck -f gcc -x",
          lintSource = "shellcheck",
          lintFormats = {
            "%f:%l:%c: %trror: %m",
            "%f:%l:%c: %tarning: %m",
            "%f:%l:%c: %tote: %m",
          },
        },
      },
    },
  },
  filetypes = {
    "sh",
  },
}
