local util = require("lspconfig.util")

return {
  -- Do not treat every Git repository as a Tailwind v4 project.
  root_dir = function(bufnr, on_dir)
    local root_files = {}
    local fname = vim.api.nvim_buf_get_name(bufnr)
    root_files = util.insert_package_json(root_files, "tailwindcss", fname)
    root_files = util.root_markers_with_field(root_files, { "mix.lock", "Gemfile.lock" }, "tailwind", fname)
    local root_file = vim.fs.find(root_files, { path = fname, upward = true })[1]

    if root_file then
      on_dir(vim.fs.dirname(root_file))
    end
  end,
  settings = {
    tailwindCSS = {
      classFunctions = { "clsx", "cn", "cva", "tw[cx]?(\\.\\w+)?" },
    },
  },
}
