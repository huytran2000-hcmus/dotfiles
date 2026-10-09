-- jdtls is started by nvim-jdtls (plugins/coding/java.lua), not by mason-lspconfig.

-- JDKs installed by install.sh, one nix profile per version
local function jdk(version)
    return vim.fn.expand("~/.local/state/nix/profiles/jdk" .. version)
end

-- JDKs that projects can compile against, picked by the project's Maven source/target level
local runtimes = {}
for _, rt in ipairs({
    { name = "JavaSE-1.8", version = "8" },
    { name = "JavaSE-11", version = "11" },
    { name = "JavaSE-17", version = "17" },
    { name = "JavaSE-21", version = "21" },
}) do
    local path = jdk(rt.version)
    if vim.fn.isdirectory(path) == 1 then
        table.insert(runtimes, { name = rt.name, path = path })
    end
end

return {
    -- JDK that runs jdtls itself (needs 21+)
    java_home = jdk(21),
    settings = {
        java = {
            configuration = {
                runtimes = runtimes,
            },
            referencesCodeLens = {
                enabled = true,
            },
            implementationCodeLens = "all",
            format = {
                enabled = true,
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
            },
        },
    },
}
