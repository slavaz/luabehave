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
  'say >= 1.4-1',
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
      ["luabehave.parser.init"] = "src/luabehave/parser/init.lua",
      ["luabehave.parser.default.comments"] = "src/luabehave/parser/default/comments.lua",
      ["luabehave.parser.default.help"] = "src/luabehave/parser/default/help.lua",
      ["luabehave.parser.default.init"] = "src/luabehave/parser/default/init.lua",
      ["luabehave.parser.default.line"] = "src/luabehave/parser/default/line.lua",
      ["luabehave.parser.default.scenario"] = "src/luabehave/parser/default/scenario.lua",
      ["luabehave.parser.default.steps"] = "src/luabehave/parser/default/steps.lua",
      ["luabehave.parser.default.story"] = "src/luabehave/parser/default/story.lua",
      ["luabehave.parser.default.table"] = "src/luabehave/parser/default/table.lua",
      ["luabehave.parser.default.table_block"] = "src/luabehave/parser/default/table_block.lua",
      ["luabehave.parser.default.table_line"] = "src/luabehave/parser/default/table_line.lua",
      ["luabehave.parser.default.utils"] = "src/luabehave/parser/default/utils.lua",
   }
}

