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
      ["luabehave.parser.line"] = "src/luabehave/parser/line.lua",
   }
}

