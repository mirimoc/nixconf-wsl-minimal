-- Python plugin spec, gated by the Nix feature flag.
--
-- If home/python.nix is imported by home/home.nix, it writes
-- lua/config/features-python.lua which sets vim.g.enable_python = true.
-- Otherwise the flag stays nil and this file contributes no plugins.
if not vim.g.enable_python then
  return {}
end

return {
  { import = "lazyvim.plugins.extras.lang.python" },
}
