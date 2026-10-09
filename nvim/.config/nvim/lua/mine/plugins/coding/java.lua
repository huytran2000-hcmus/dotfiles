local mason = vim.fn.stdpath("data") .. "/mason"

local function root_dir(path)
    return vim.fs.root(path, vim.lsp.config.jdtls.root_markers)
end

-- Eclipse formatter profile shared by a group of projects, kept outside this repo
-- (e.g. ~/zlp/.jdtls-format.xml). Projects without one use the jdtls default style.
local function format_settings_file(root)
    local found = vim.fs.find(".jdtls-format.xml", { path = root, upward = true })[1]
    if not found then
        return nil
    end
    local profile = table.concat(vim.fn.readfile(found), "\n"):match('<profile[^>]-name="([^"]+)"')
    return { url = found, profile = profile }
end

-- java-debug and java-test jars loaded into jdtls for nvim-dap debugging (also used by neotest-java)
-- and test navigation (gS)
local function bundles()
    local result = vim.fn.glob(mason .. "/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar", false, true)
    local excluded = {
        "com.microsoft.java.test.runner-jar-with-dependencies.jar",
        "jacocoagent.jar",
    }
    for _, jar in ipairs(vim.fn.glob(mason .. "/share/java-test/*.jar", false, true)) do
        if not vim.tbl_contains(excluded, vim.fs.basename(jar)) then
            table.insert(result, jar)
        end
    end
    return result
end

local function set_keymaps(bufnr)
    local jdtls = require("jdtls")
    local function opts(desc)
        return { silent = true, buffer = bufnr, desc = desc }
    end

    NNOREMAP("gs", jdtls.super_implementation, opts("Go to super implementation"))
    NNOREMAP("gS", function() require("jdtls.tests").goto_subjects() end, opts("Go to test subject"))
end

local function setup_dap()
    -- Main classes are discovered on demand by dap.continue() (jdtls provider)
    require("jdtls").setup_dap({ hotcodereplace = "auto" })

    local dap = require("dap")
    dap.configurations.java = dap.configurations.java or {}
    for _, cfg in ipairs(dap.configurations.java) do
        if cfg.name == "Debug (Attach) - Remote" then
            return
        end
    end
    table.insert(dap.configurations.java, {
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 5005,
    })
end

return {
    {
        -- https://github.com/mfussenegger/nvim-jdtls
        "mfussenegger/nvim-jdtls",
        ft = "java",
        -- Load the generic LSP on_attach keymaps/autoformat before jdtls attaches
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            local server = require(PREFIX .. "lspconfig.servers.jdtls")
            local init_bundles = bundles()

            local function start()
                local fname = vim.api.nvim_buf_get_name(0)
                -- jdt:// buffers (decompiled/library classes) reuse the client of the buffer they were opened from
                if fname == "" or vim.startswith(fname, "jdt://") then
                    return
                end
                local root = root_dir(fname) or vim.fs.dirname(fname)
                local project = vim.fs.basename(root) .. "-" .. vim.fn.sha256(root):sub(1, 8)
                local cache = vim.fn.stdpath("cache") .. "/jdtls/" .. project

                local cmd = { mason .. "/bin/jdtls" }
                local lombok = mason .. "/share/jdtls/lombok.jar"
                if vim.uv.fs_stat(lombok) then
                    table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok)
                end
                vim.list_extend(cmd, { "-configuration", cache .. "/config", "-data", cache .. "/workspace" })

                local settings = server.settings
                local format_file = format_settings_file(root)
                if format_file then
                    settings = vim.tbl_deep_extend("force", settings, {
                        java = { format = { settings = format_file } },
                    })
                end

                local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
                require("jdtls").start_or_attach({
                    cmd = cmd,
                    cmd_env = { JAVA_HOME = server.java_home },
                    root_dir = root,
                    settings = settings,
                    init_options = { bundles = init_bundles },
                    capabilities = has_cmp and cmp_nvim_lsp.default_capabilities() or nil,
                })
            end

            local group = vim.api.nvim_create_augroup("mine_jdtls", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = "java",
                callback = start,
            })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = group,
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client or client.name ~= "jdtls" then
                        return
                    end
                    set_keymaps(args.buf)
                    if #init_bundles > 0 then
                        setup_dap()
                    end
                end,
            })

            -- The FileType event that loaded this plugin has already fired
            start()
        end,
    },
}
