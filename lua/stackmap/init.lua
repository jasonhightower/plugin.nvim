-- to reload a package you can call
-- lua package.loaded["<module name">] = nil
-- ie: lua package.loaded["stackmap.util"] = nil
-- next require will reload the file
-- TODO: setup a keymap to set all plugin packages to nil in order to force a reload

local M = {}

M.setup = function()
end

local find_mapping = function(maps, lhs)
    for _, value in ipairs(maps) do
        if value.lhs == lhs then
            return value
        end
    end
end

M.push = function(name, mode, mappings)
    local maps = vim.api.nvim_get_keymap(mode)

    local existing_maps = {}
    for lhs, _ in pairs(mappings) do
        local existing = find_mapping(maps, lhs)
        if existing then
            existing_maps[lhs] = existing
        end
    end

    M._stack[name] = M._stack[name] or {}
    M._stack[name][mode] = {
        existing = existing_maps,
        mappings = mappings,
    }

    for lhs, rhs in pairs(mappings) do
        vim.keymap.set(mode, lhs, rhs)
    end
end

M._stack = {}

M.pop = function(name, mode)
    local state = M._stack[name][mode]
    M._stack[name][mode] = nil

    for lhs, _ in pairs(state.mappings) do
        if state.existing[lhs] then
            local original = state.existing[lhs]
            vim.keymap.set(mode, lhs, original.rhs)
            -- TODO handle the options
        else
            vim.keymap.del(mode, lhs)
        end
    end

end

M._clear = function()
    M._stack = {}
end

M.push('debug_mode', 'n', {
    [" tt"] = "echo 'Hello'",
    [" sz"] ="echo 'Goodbye'",
})


return M
