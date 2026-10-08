local mason = vim.fn.stdpath("data") .. "/mason"

local function root_dir(path)
    return vim.fs.root(path, { { "mvnw", ".git" }, { "pom.xml", "build.gradle", "build.gradle.kts" } })
end

-- java-debug and java-test jars loaded into jdtls for nvim-dap debugging and test running
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

-- Run the current file's main class: a matching .vscode/launch.json entry (project vmArgs/env)
-- wins over the config nvim-jdtls generates; otherwise fall back to the dap picker.
local function run_main()
    local dap = require("dap")
    local class = vim.fn.expand("%:t:r")
    local function matches(cfg)
        return cfg.type == "java" and cfg.request == "launch" and type(cfg.mainClass) == "string"
            and (cfg.mainClass == class or vim.endswith(cfg.mainClass, "." .. class))
    end

    local ok, launch = pcall(require("dap.ext.vscode").getconfigs)
    for _, configs in ipairs({ ok and launch or {}, dap.configurations.java or {} }) do
        for _, cfg in ipairs(configs) do
            if matches(cfg) then
                dap.run(cfg)
                return
            end
        end
    end
    dap.continue()
end

-- dap.run_last() reuses the previous config as-is, so override noDebug on the rerun
local function run_last_test(no_debug)
    local dap = require("dap")
    local key = "mine.java_run_last"
    local applied = false
    dap.listeners.on_config[key] = function(config)
        dap.listeners.on_config[key] = nil
        applied = true
        if config.request ~= "launch" then
            return config
        end
        return vim.tbl_extend("force", config, { noDebug = no_debug })
    end
    dap.run_last()
    -- Nothing to rerun: drop the listener so it doesn't leak into the next run
    if not applied and not dap.session() then
        dap.listeners.on_config[key] = nil
    end
end

local function set_keymaps(bufnr)
    local jdtls = require("jdtls")
    local function opts(desc)
        return { silent = true, buffer = bufnr, desc = desc }
    end

    NNOREMAP("<leader>co", jdtls.organize_imports, opts("Organize imports"))
    NNOREMAP("gs", jdtls.super_implementation, opts("Go to super implementation"))
    NNOREMAP("gS", function() require("jdtls.tests").goto_subjects() end, opts("Go to test subject"))
    NNOREMAP("<leader>dm", run_main, opts("Run main class"))
    -- Override the global neotest keymaps (plugins/coding/neotest.lua) in Java buffers
    NNOREMAP("<leader>tt", function() require("jdtls.dap").test_class() end, opts("Run test class"))
    NNOREMAP("<leader>tT", function() require("jdtls.dap").pick_test() end, opts("Pick test to run"))
    NNOREMAP("<leader>tr", function()
        require("jdtls.dap").test_nearest_method({ config_overrides = { noDebug = true } })
    end, opts("Run nearest test"))
    NNOREMAP("<leader>td", function() require("jdtls.dap").test_nearest_method() end, opts("Debug nearest test"))
    NNOREMAP("<leader>tl", function() run_last_test(true) end, opts("Run last test"))
    NNOREMAP("<leader>tD", function() run_last_test(false) end, opts("Debug last test"))
end

local function setup_dap()
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()

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
                local root = root_dir(fname) or vim.fs.dirname(fname)
                local project = vim.fs.basename(root) .. "-" .. vim.fn.sha256(root):sub(1, 8)
                local cache = vim.fn.stdpath("cache") .. "/jdtls/" .. project

                local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
                require("jdtls").start_or_attach({
                    cmd = {
                        mason .. "/bin/jdtls",
                        "--jvm-arg=-javaagent:" .. mason .. "/share/jdtls/lombok.jar",
                        "-configuration", cache .. "/config",
                        "-data", cache .. "/workspace",
                    },
                    cmd_env = { JAVA_HOME = server.java_home },
                    root_dir = root,
                    settings = server.settings,
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
