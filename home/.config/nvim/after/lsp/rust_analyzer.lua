return {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
      rustfmt = {
        extraArgs = { "+nightly" },
      },
    },
  },
}
