local M = {}

local Terminal = nil
local cp_terminal = nil

local function shell_join(args)
    local escaped = {}
    for _, arg in ipairs(args) do
        escaped[#escaped + 1] = vim.fn.shellescape(tostring(arg))
    end
    return table.concat(escaped, " ")
end

local function get_cp_terminal()
    if cp_terminal and cp_terminal.job_id then
        local ok, result = pcall(vim.fn.jobwait, { cp_terminal.job_id }, 0)
        if ok and result[1] == -1 then
            return cp_terminal
        end
    end

    cp_terminal = Terminal:new({
        cmd = vim.o.shell,
        direction = "float",
        display_name = "CP",
        close_on_exit = false,
    })
    return cp_terminal
end

local function toggle_cp_terminal()
    local term = get_cp_terminal()
    term:toggle()
end

local function run_in_cp_terminal(command)
    local term = get_cp_terminal()
    if not term:is_open() then
        term:open()
    else
        term:focus()
    end

    if not term.job_id then
        vim.notify("Could not start the CP terminal.", vim.log.levels.ERROR)
        return
    end

    -- Send directly to the persistent shell. Avoid :TermExec's command-line
    -- parser, which is fragile when the shell command itself contains quotes.
    term:send(command, false)
end

local function compile_and_run_cpp()
    local source = vim.api.nvim_buf_get_name(0)
    if source == "" then
        vim.notify("Save the C++ file before compiling it.", vim.log.levels.WARN)
        return
    end

    -- Preserve the previous workflow: write the source before expansion/build.
    local ok, err = pcall(function() vim.cmd.write() end)
    if not ok then
        vim.notify("Could not save the current file: " .. tostring(err), vim.log.levels.ERROR)
        return
    end

    local cplib = vim.fn.expand("~/dev/cp/lib")
    local expander = cplib .. "/expander.py"
    local output = vim.fn.fnamemodify(source, ":r")
    local input = vim.fn.fnamemodify(source, ":h") .. "/inp"

    -- Expand before compiling, rather than running the expander inside the
    -- terminal. The expander edits the source file externally, so Neovim's
    -- already-loaded buffer would otherwise remain stale until a later check.
    if vim.fn.filereadable(expander) == 1 then
        local expansion_output = vim.fn.system({
            "python3", expander, "--lib", cplib, source,
        })
        if vim.v.shell_error ~= 0 then
            vim.notify(
                "AtCoder library expansion failed:\n" .. tostring(expansion_output),
                vim.log.levels.ERROR
            )
            return
        end

        -- The file was saved above, so force-reload is safe and makes the
        -- expanded code visible immediately in the current Neovim buffer.
        local view = vim.fn.winsaveview()
        local reload_ok, reload_err = pcall(function()
            vim.cmd("silent edit!")
        end)
        if not reload_ok then
            vim.notify(
                "Expansion succeeded, but reloading the source failed: " .. tostring(reload_err),
                vim.log.levels.ERROR
            )
            return
        end
        vim.fn.winrestview(view)
    end

    -- These are the custom flags from your original ToggleTerm mapping.
    local compile_args = {
        "g++", "-ggdb", "-DLOCAL",
        "-std=c++20", "-O2", "-Wall", "-Wextra",
        "-Wshadow", "-Wformat=2", "-Wfloat-equal", "-Wconversion",
        "-Wlogical-op", "-Wshift-overflow=2", "-Wduplicated-cond",
        "-Wcast-qual", "-Wcast-align", "-Wno-unused-result",
        "-Wno-sign-conversion", "-D_GLIBCXX_DEBUG", "-D_GLIBCXX_DEBUG_PEDANTIC",
        "-I" .. cplib,
        source, "-o", output,
    }

    local commands = {}
    commands[#commands + 1] = shell_join(compile_args)
    commands[#commands + 1] = "&&"

    -- Use the conventional per-source-directory ./inp when it exists. If it
    -- doesn't, leave stdin attached to the terminal instead of failing at < inp.
    local run_command = shell_join({ output })
    if vim.fn.filereadable(input) == 1 then
        run_command = run_command .. " < " .. vim.fn.shellescape(input)
    end
    commands[#commands + 1] = run_command

    run_in_cp_terminal(table.concat(commands, " "))
end

function M.setup()
    require("toggleterm").setup({
        size = 20,
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = false,
        -- The mapping is registered below so it always toggles the same
        -- persistent shell used by <leader>3 and <leader>4.
        insert_mappings = false,
        terminal_mappings = false,
        auto_scroll = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
            border = "curved",
            winblend = 0,
            highlights = {
                border = "Normal",
                background = "Normal",
            },
        },
    })

    -- Resolve the class after the plugin is loaded by lazy.nvim.
    Terminal = require("toggleterm.terminal").Terminal

    local group = vim.api.nvim_create_augroup("PouyaToggleTermMappings", { clear = true })
    vim.api.nvim_create_autocmd("TermOpen", {
        group = group,
        pattern = "term://*toggleterm#*",
        callback = function(event)
            local opts = { buffer = event.buf, silent = true }
            vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
            vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
            vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
            vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
            vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
            vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
            vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
        end,
    })

    vim.keymap.set("n", "<leader>;", toggle_cp_terminal, {
        desc = "Toggle CP terminal",
    })
    vim.keymap.set("t", "<leader>;", toggle_cp_terminal, {
        desc = "Toggle CP terminal",
    })

    vim.keymap.set({ "n", "v" }, "<leader>3", compile_and_run_cpp, {
        desc = "Compile and run C++ (CP)",
    })
    vim.keymap.set({ "n", "v" }, "<leader>4", function()
        run_in_cp_terminal("python3 -m IPython")
    end, { desc = "Open IPython in CP terminal" })
end

return M
