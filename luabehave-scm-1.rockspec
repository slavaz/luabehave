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
      ["luabehave.parser.comments"] = "src/luabehave/parser/comments.lua",
      ["luabehave.parser.init"] = "src/luabehave/parser/init.lua",
      ["luabehave.parser.keywords"] = "src/luabehave/parser/keywords.lua",
      ["luabehave.parser.line"] = "src/luabehave/parser/line.lua",
      ["luabehave.parser.scenario"] = "src/luabehave/parser/scenario.lua",
      ["luabehave.parser.steps"] = "src/luabehave/parser/steps.lua",
      ["luabehave.parser.story"] = "src/luabehave/parser/story.lua",
      ["luabehave.parser.table"] = "src/luabehave/parser/table.lua",
      ["luabehave.parser.table_block"] = "src/luabehave/parser/table_block.lua",
      ["luabehave.parser.table_line"] = "src/luabehave/parser/table_line.lua",
      ["luabehave.parser.utils"] = "src/luabehave/parser/utils.lua",
   }
}

