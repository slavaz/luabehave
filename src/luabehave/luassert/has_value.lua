local say = require("say")
local assert = require("luassert")

-- Comparsion of unordered tables
local function has_value(_, arguments)
    local expected_value = arguments[1]
    local actual = arguments[2]

    if type(actual) ~= "table" then
        return false
    end

    for _, value in pairs(actual) do
        if value == expected_value then
            return true
        end
    end
    return false
end

say:set_namespace("en")
say:set(
    "assertion.has_value.positive",
    "Expected table to contain a value\nExpected value:\n%s\nActual table:\n%s"
)
say:set(
    "assertion.has_value.negative",
    "Expected table not to contain a value\nUnexpected value:\n%s\nActual table:\n%s"
)

assert:register("assertion", "has_value", has_value,
    "assertion.has_value.positive", "assertion.has_value.negative")
