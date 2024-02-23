local find_map = function(lhs)
    local maps = vim.api.nvim_get_keymap('n')
    for _, map in ipairs(maps) do
        if map.lhs == lhs then
            return map
        end
    end
end

local assert_mapping = function(lhs, rhs)
    local found = find_map(lhs)
    if rhs then
        assert.are.same(rhs, found.rhs)
    else
        assert.are.same(nil, found)
    end
end

describe("stackmap", function()

    before_each(function()
        pcall(vim.keymap.del, "n", "asdfasdf")
        pcall(vim.keymap.del, "n", "asdf_1")
        pcall(vim.keymap.del, "n", "asdf_2")
        require('stackmap')._clear()
    end)

    it("can be required", function()
        require("stackmap")
    end)

    it("can push a single mapping", function()
        local rhs = "echo 'this is a test'"
        require('stackmap').push('test1', 'n', {
            asdfasdf = rhs,
        })
        assert_mapping("asdfasdf", rhs)
    end)

    it("can push a multiple mapping", function()
        local rhs = "echo 'this is a test'"
        require('stackmap').push('test1', 'n', {
            ["asdf_1"] = rhs .. "1",
            ["asdf_2"] = rhs .. "2",
        })
        assert_mapping("asdf_1", rhs .. 1)
        assert_mapping("asdf_2", rhs .. 2)
    end)

    it("can delete mappings after pop: no existing", function()
        local rhs = "echo 'this is a test'"
        require('stackmap').push('test1', 'n', {
            asdfasdf = rhs,
        })

        require('stackmap').pop('test1', 'n')
        assert_mapping('asdfasdf', nil)
    end)

    it("can delete mappings after pop: yes existing", function()
        local existing_rhs = "echo 'existing'"
        vim.keymap.set('n', 'asdfasdf', existing_rhs)

        local rhs = "echo 'this is a test'"
        require('stackmap').push('test1', 'n', {
            asdfasdf = rhs,
        })

        require('stackmap').pop('test1', 'n')

        assert_mapping('asdfasdf', existing_rhs)
    end)
end)
