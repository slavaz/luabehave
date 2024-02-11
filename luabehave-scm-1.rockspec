local package_name = "luabehave"
local package_version = "scm"
local rockspec_revision = "1"
local github_account_name = "slavaz"
local github_repo_name = package_name

rockspec_format = "3.0"
package = package_name
version = package_version .. "-" .. rockspec_revision

source = {
  url = "git+https://github.com/" .. github_account_name .. "/" .. github_repo_name .. ".git"
}

description = {
  summary = "BDD framework",
  detailed = [[
    A Lua framework that allows to run BDD-style user stories.
  ]],
  homepage="https://github.com/slavaz/luabehave",
  license = "MIT <http://opensource.org/licenses/MIT>",
}

dependencies = {
  'lua >= 5.1',
  'luassert >= 1.8.0',
}

test_dependencies = {
  "busted",
}

test = {
  type = "busted",
}

build = {
   type = "builtin",
   modules = {
      ["luabehave.luassert.has_value"] = "src/luabehave/luassert/has_value.lua",
      ["luabehave.finder.default.args"] = "src/luabehave/finder/default/args.lua",
      ["luabehave.finder.default.help"] = "src/luabehave/finder/default/help.lua",
      ["luabehave.finder.default.init"] = "src/luabehave/finder/default/init.lua",
      ["luabehave.finder.default.recursive"] = "src/luabehave/finder/default/recursive.lua",
      ["luabehave.finder.default.steps"] = "src/luabehave/finder/default/steps.lua",
      ["luabehave.finder.default.stories"] = "src/luabehave/finder/default/stories.lua",
      ["luabehave.finder.init"] = "src/luabehave/finder/init.lua",
      ["luabehave.keywords.default.help"] = "src/luabehave/keywords/default/help.lua",
      ["luabehave.keywords.default.init"] = "src/luabehave/keywords/default/init.lua",
      ["luabehave.keywords.init"] = "src/luabehave/keywords/init.lua",
      ["luabehave.loader.init"] = "src/luabehave/loader/init.lua",
      ["luabehave.loader.default.init"] = "src/luabehave/loader/default/init.lua",
      ["luabehave.loader.default.help"] = "src/luabehave/loader/default/help.lua",
      ["luabehave.loader.default.steps"] = "src/luabehave/loader/default/steps.lua",
      ["luabehave.loader.default.stories"] = "src/luabehave/loader/default/stories.lua",
      ["luabehave.output.init"] = "src/luabehave/output/init.lua",
      ["luabehave.output.levels"] = "src/luabehave/output/levels.lua",
      ["luabehave.output.default.init"] = "src/luabehave/output/default/init.lua",
      ["luabehave.output.default.help"] = "src/luabehave/output/default/help.lua",
      ["luabehave.parser.init"] = "src/luabehave/parser/init.lua",
      ["luabehave.parser.default.comments"] = "src/luabehave/parser/default/comments.lua",
      ["luabehave.parser.default.help"] = "src/luabehave/parser/default/help.lua",
      ["luabehave.parser.default.init"] = "src/luabehave/parser/default/init.lua",
      ["luabehave.parser.default.line"] = "src/luabehave/parser/default/line.lua",
      ["luabehave.parser.default.scenario"] = "src/luabehave/parser/default/scenario.lua",
      ["luabehave.parser.default.steps"] = "src/luabehave/parser/default/steps.lua",
      ["luabehave.parser.default.story"] = "src/luabehave/parser/default/story.lua",
      ["luabehave.parser.default.suite"] = "src/luabehave/parser/default/suite.lua",
      ["luabehave.parser.default.table"] = "src/luabehave/parser/default/table.lua",
      ["luabehave.parser.default.table_block"] = "src/luabehave/parser/default/table_block.lua",
      ["luabehave.parser.default.table_line"] = "src/luabehave/parser/default/table_line.lua",
      ["luabehave.parser.default.utils"] = "src/luabehave/parser/default/utils.lua",
      ["luabehave.planner.init"] = "src/luabehave/planner/init.lua",
      ["luabehave.planner.default.init"] = "src/luabehave/planner/default/init.lua",
      ["luabehave.planner.default.args"] = "src/luabehave/planner/default/args.lua",
      ["luabehave.planner.default.breadcrumbs"] = "src/luabehave/planner/default/breadcrumbs.lua",
      ["luabehave.planner.default.context"] = "src/luabehave/planner/default/context.lua",
      ["luabehave.planner.default.environment"] = "src/luabehave/planner/default/environment.lua",
      ["luabehave.planner.default.help"] = "src/luabehave/planner/default/help.lua",
      ["luabehave.planner.default.make_call"] = "src/luabehave/planner/default/make_call.lua",
      ["luabehave.planner.default.scenario"] = "src/luabehave/planner/default/scenario.lua",
      ["luabehave.planner.default.step"] = "src/luabehave/planner/default/step.lua",
      ["luabehave.planner.default.story"] = "src/luabehave/planner/default/story.lua",
      ["luabehave.planner.default.suite"] = "src/luabehave/planner/default/suite.lua",
      ["luabehave.planner.default.suite_list"] = "src/luabehave/planner/default/suite_list.lua",
      ["luabehave.reporter.init"] = "src/luabehave/reporter/init.lua",
      ["luabehave.reporter.default.init"] = "src/luabehave/reporter/default/init.lua",
      ["luabehave.reporter.default.collect"] = "src/luabehave/reporter/default/collect.lua",
      ["luabehave.reporter.default.help"] = "src/luabehave/reporter/default/help.lua",
      ["luabehave.reporter.default.show"] = "src/luabehave/reporter/default/show.lua",
      ["luabehave.runner.init"] = "src/luabehave/runner/init.lua",
      ["luabehave.runner.default.init"] = "src/luabehave/runner/default/init.lua",
      ["luabehave.utils"] = "src/luabehave/utils.lua",
   }
}
