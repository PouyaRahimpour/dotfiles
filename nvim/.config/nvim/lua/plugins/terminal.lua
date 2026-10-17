return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("pouya.toggleterm").setup()
        end,
    },
}
