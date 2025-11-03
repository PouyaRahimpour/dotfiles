--vim.cmd("TransparentEnable")
local colors = {
    "gruvbox",
    "base16-gruvbox-material-dark-medium",
    "darcula",
    "default",
    "rose-pine",
    "base16-chalk",
    "base16-monokai",
    "base16-gruvbox-dark-hard"
}

local color_num = 0

local function set_color(color)
    local stat_ok = pcall(vim.cmd, "colorscheme " .. color)
    if not stat_ok then
        vim.notify("Could not set colorscheme "..color.."!")
    else
        vim.cmd("color")
    end
end

local function next_color()
    local color = colors[color_num+1]
    set_color(color)
    color_num = (color_num+1)%(#colors)
end

vim.api.nvim_create_user_command(
    "Color",
    function()
        next_color()
    end,
    {}
)
next_color()

