describe("Tests for #luabehave.run", function()
    it("should fail if some error was raised in 'finder' submodule while searching stories", function()
        local run = require("luabehave.run")
        local application_context = {
            finder = {
                search_stories = function() return false, "An error from search_stories" end,
                search_steps = function() return true, {} end
            },
            reporter = {
                init = function() end,
            }
        }
        local result, message = run(application_context)
        assert.is_false(result)
        assert.is_equal("An error from search_stories", message)
    end)
    it("should fail if no stories were found", function()
        local run = require("luabehave.run")
        local application_context = {
            finder = {
                search_stories = function() return true, {} end,
                search_steps = function() return true, {} end
            },
            reporter = {
                init = function() end,
            }
        }
        local result, message = run(application_context)
        assert.is_false(result)
        assert.is_equal("No stories found", message)
    end)
    it("should fail if some error was raised in 'finder' submodule while searching steps", function()
        local run = require("luabehave.run")
        local application_context = {
            finder = {
                search_stories = function() return true, { {}, {} } end,
                search_steps = function() return false, "An error from search_steps" end
            },
            reporter = {
                init = function() end,
            }
        }
        local result, message = run(application_context)
        assert.is_false(result)
        assert.is_equal("An error from search_steps", message)
    end)
    it("should fail if some error was raised in 'loader' submodule while loading stories", function()
        local run = require("luabehave.run")
        local application_context = {
            finder = {
                search_stories = function() return true, { {}, {} } end,
                search_steps = function() return true, { {}, {} } end
            },
            loader = {
                load_stories = function() return false, "An error from load_stories" end,
                load_steps = function() return true, {} end
            },
            reporter = {
                init = function() end,
            }
        }
        local result, message = run(application_context)
        assert.is_false(result)
        assert.is_equal("An error from load_stories", message)
    end)
    it("should fail if some error was raised in 'loader' submodule while loading steps", function()
        local run = require("luabehave.run")
        local application_context = {
            finder = {
                search_stories = function() return true, { {}, {} } end,
                search_steps = function() return true, { {}, {} } end
            },
            loader = {
                load_stories = function() return true, { {}, {} } end,
                load_steps = function() return false, "An error from load_steps" end
            },
            reporter = {
                init = function() end,
            }
        }
        local result, message = run(application_context)
        assert.is_false(result)
        assert.is_equal("An error from load_steps", message)
    end)
    it("should fail if some error was raised in 'planner' submodule while preparing plan", function()
        local run = require("luabehave.run")
        local application_context = {
            finder = {
                search_stories = function() return true, { {}, {} } end,
                search_steps = function() return true, { {}, {} } end
            },
            loader = {
                load_stories = function() return true, { {}, {} } end,
                load_steps = function() return true, {} end
            },
            planner = {
                prepare_plan = function() return false, "An error from prepare_plan" end
            },
            reporter = {
                init = function() end,
            }
        }
        local result, message = run(application_context)
        assert.is_false(result)
        assert.is_equal("An error from prepare_plan", message)
    end)
    it("should run the stories and show the summary", function()
        local run = require("luabehave.run")
        local runner_run_func = spy.new(function() end)
        local reporter_show_summary_func = spy.new(function() end)
        local application_context = {
            finder = {
                search_stories = function() return true, { {}, {} } end,
                search_steps = function() return true, { {}, {} } end
            },
            loader = {
                load_stories = function() return true, { {}, {} } end,
                load_steps = function() return true, {} end
            },
            planner = {
                prepare_plan = function() return true, {} end
            },
            reporter = {
                init = function() end,
                show_summary = reporter_show_summary_func
            },
            runner = {
                run = runner_run_func
            }
        }
        local result, message = run(application_context)
        assert.is_true(result)
        assert.is_nil(message)
        assert.spy(runner_run_func).was_called(1)
        assert.spy(reporter_show_summary_func).was_called(1)
    end)
end)
