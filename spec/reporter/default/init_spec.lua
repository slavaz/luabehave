local package_name = "luabehave.reporter.default.init"

describe("Tests for #reporter.default.init", function()
    local assert_snapshot

    local spy_funcs = {
        collect_func = function() end,
        show_func = function() end,
        show_summary_func = function() end,
    }

    before_each(function()
        package.loaded["luabehave.reporter.default.collect"] = spy_funcs.collect_func
        package.loaded["luabehave.reporter.default.show"] = spy_funcs.show_func
        package.loaded["luabehave.reporter.default.show_summary"] = spy_funcs.show_summary_func
        assert_snapshot = assert:snapshot()
    end)

    after_each(function()
        assert_snapshot:revert()
        package.loaded["luabehave.reporter.default.collect"] = nil
        package.loaded["luabehave.reporter.default.show"] = nil
        package.loaded["luabehave.reporter.default.show_summary"] = nil
        package.loaded[package_name] = nil
    end)

    it("should return reporter object", function()
        local default_reporter = require(package_name)
        assert.is_table(default_reporter)
        assert.is_function(default_reporter.init)
        assert.is_function(default_reporter.collect)
        assert.is_function(default_reporter.show)
        assert.is_function(default_reporter.show_summary)
        assert.is_equal("default", default_reporter.name())
        assert.is_equal(spy_funcs.collect_func, default_reporter.collect)
        assert.is_equal(spy_funcs.show_func, default_reporter.show)
        assert.is_equal(spy_funcs.show_summary_func, default_reporter.show_summary)
    end)
end)
