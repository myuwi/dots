return {
  "laytan/cloak.nvim",
  opts = {
    cloak_length = 12,
    cloak_on_leave = true,
    patterns = {
      {
        file_pattern = ".env*",
        cloak_pattern = {
          "(#? ?)(.*KEY.*)=(.+)",
          "(#? ?)(.*TOKEN.*)=(.+)",
          "(#? ?)(.*SECRET.*)=(.+)",
          "(#? ?)(.*PASSWORD.*)=(.+)",
        },
        replace = "%1%2=",
      },
    },
  },
}
