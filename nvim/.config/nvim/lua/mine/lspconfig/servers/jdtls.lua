-- jdtls is started by nvim-jdtls (plugins/coding/java.lua), not by mason-lspconfig.

-- JDK that runs jdtls itself (needs 21+); installed by install.sh into its own nix profile
local jdk21_home = vim.fn.expand("~/.local/state/nix/profiles/jdk21")

local function java_home(version)
    if vim.fn.executable("/usr/libexec/java_home") == 0 then
        return nil
    end
    local res = vim.system({ "/usr/libexec/java_home", "-v", version }):wait()
    if res.code ~= 0 then
        return nil
    end
    return vim.trim(res.stdout)
end

-- JDKs that projects can compile against, picked by the project's Maven source/target level
local runtimes = {}
for _, rt in ipairs({
    { name = "JavaSE-1.8", version = "1.8" },
    { name = "JavaSE-11", version = "11" },
    { name = "JavaSE-17", version = "17" },
}) do
    local path = java_home(rt.version)
    if path then
        table.insert(runtimes, { name = rt.name, path = path })
    end
end
if vim.fn.isdirectory(jdk21_home) == 1 then
    table.insert(runtimes, { name = "JavaSE-21", path = jdk21_home })
end

return {
    java_home = jdk21_home,
    settings = {
        java = {
            configuration = {
                runtimes = runtimes,
            },
            referencesCodeLens = {
                enabled = true,
            },
            implementationCodeLens = "all",
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
            },
        },
    },
}
