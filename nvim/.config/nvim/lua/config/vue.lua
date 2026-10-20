local M = {}

-- Check ancestor manifests too, since workspaces may declare Vue at the root.
function M.is_vue_project(bufnr)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  while dir do
    local manifest = dir .. "/package.json"
    if vim.fn.filereadable(manifest) == 1 then
      local ok, package = pcall(function()
        return vim.json.decode(table.concat(vim.fn.readfile(manifest), "\n"))
      end)
      if ok and type(package) == "table" then
        for _, field in ipairs({ "dependencies", "devDependencies", "peerDependencies", "optionalDependencies" }) do
          local dependencies = package[field]
          if type(dependencies) == "table" and (dependencies.vue or dependencies.nuxt or dependencies["@vue/compat"]) then
            return true
          end
        end
      end
    end

    if vim.uv.fs_stat(dir .. "/.git") then
      break
    end
    local parent = vim.fs.dirname(dir)
    if parent == dir then
      break
    end
    dir = parent
  end
  return false
end

function M.root_dir(bufnr, on_dir)
  if M.is_vue_project(bufnr) then
    local root = vim.fs.root(bufnr, { "package.json", "tsconfig.json", ".git" })
    if root then
      on_dir(root)
    end
  end
end

return M
