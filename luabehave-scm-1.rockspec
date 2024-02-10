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
      ["luabehave.keywords.init"] = "src/luabehave/keywords/init.lua",
      ["luabehave.keywords.default.init"] = "src/luabehave/keywords/default/init.lua",
      ["luabehave.keywords.default.help"] = "src/luabehave/keywords/default/help.lua",
      ["luabehave.parser.init"] = "src/luabehave/parser/init.lua",
      ["luabehave.parser.default.init"] = "src/luabehave/parser/default/init.lua",
      ["luabehave.parser.default.comments"] = "src/luabehave/parser/default/comments.lua",
      ["luabehave.parser.default.help"] = "src/luabehave/parser/default/help.lua",
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

