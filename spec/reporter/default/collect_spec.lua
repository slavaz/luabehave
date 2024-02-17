local package_name = "luabehave.reporter.default.collect"

describe("Tests for #reporter.default.collect", function()
    local assert_snapshot

    local spy_funcs = {
        context__add = spy.new(function() end),
    }

    before_each(function()
        assert_snapshot = assert:snapshot()
    end)

    after_each(function()
        assert_snapshot:revert()
        for k, v in pairs(spy_funcs) do v:clear() end
        package.loaded[package_name] = nil
        package.loaded["luabehave.reporter.default.context"] = nil
    end)

    it("should use existing context", function()
        local collect_func = require(package_name)
        local existing_context = { add = spy_funcs.context__add }
        local acxt = {
            reporter_context = existing_context,
        }
        collect_func(acxt, {})
        assert.spy(spy_funcs.context__add).was_called_with(existing_context, {})
        assert.is.equal(existing_context, acxt.reporter_context)
    end)

    it("Should init new context", function()
        local add_spy = spy.new(function()
            return { add = function() end }
        end)
        package.loaded["luabehave.reporter.default.context"] = add_spy
        local collect_func = require(package_name)
        local acxt = {}
        collect_func(acxt, {})
        assert.spy(add_spy).was_called(1)
    end)
end)
