package.path = "../?.lua;" .. package.path

local parse_line = require("luabehave.parser.line")

local function got_error(error_msg)
    return ("Expected line to be parsed successfully but got error: %s"):format(tostring(error_msg))
end

local function got_success(result)
    return ("Expected line not to be parsed but got result: %s"):format(tostring(result))
end

local keywords = {
    open_bracket  = "{",
    close_bracket = "}",
    equal         = "=",
    escape        = "\\",
    spaces        = {" ", "\t"},
}

describe("line_parser", function()
    it("should parse a line with no special characters", function()
        local line = "This is a regular line"
        local is_success, result = parse_line(line, keywords)
        assert.is_true(is_success, got_error(result))

        assert.are.same(line, result.name)
        assert.are.same({}, result.args)
    end)
    it("should parse a line with a single argument", function()
        local line = "This is a line with a single argument: {arg1}"
        local is_success, result = parse_line(line, keywords)
        assert.is_true(is_success, got_error(result))

        assert.are.same("This is a line with a single argument: {arg1}", result.name)
        assert.are.same({ arg1 = "" }, result.args)
    end)
    it("should parse a line with a single argument and a value", function()
        local line = "This is a line with a single argument and a value: {arg1 = value}"
        local is_success, result = parse_line(line, keywords)
        assert.is_true(is_success, got_error(result))

        assert.are.same("This is a line with a single argument and a value: {arg1}", result.name)
        assert.are.same({ arg1 = " value" }, result.args)
    end)
    it("should parse a line with a single argument and a value with an escape character", function()
        local line = "This is a line with a single argument and a value with an escape character: {arg1 = \\}"
        local is_success, result = parse_line(line, keywords)
        assert.is_false(is_success, got_success(result))
    end)
    it("should parse a line with a single argument and a value with an escape character", function()
        local line = "This is a line with a single argument and a value with an escape character: {arg1 = \\}"
        local is_success, result = parse_line(line, keywords)
        assert.is_false(is_success, got_success(result))
    end)
    it("", function()
        local line = "^$^&*)(*^TGYHJIOIUYTRY&U*()*&^^%%RF^TYGHUJ{{HYBGU%)"
        local is_success, result = parse_line(line, keywords)
        assert.is_false(is_success, got_success(result))
    end)
    it("", function()
        local line = "^$^&*)(*^TGYHJIOIUYTRY&U*()*&^^%%RF^TYGHUJ{HYBGU%)}"
        local is_success, result = parse_line(line, keywords)
        assert.is_true(is_success, got_error(result))
        assert.are.same("^$^&*)(*^TGYHJIOIUYTRY&U*()*&^^%%RF^TYGHUJ{HYBGU%)}", result.name)
        assert.are.same({ ["HYBGU%)"] = ""  }, result.args)
    end)
    it("Should parse a line with complex definitions", function()
        local line = "{arg1 = \\}} {arg1=12345} and {ar\\}gv2} and {a\\=rg3=\\{\\\\\\\\=\\\\\\}}"
        local is_success, result = parse_line(line, keywords)
        assert.is_true(is_success, got_error(result))

        assert.are.same("{arg1} {arg1} and {ar}gv2} and {a=rg3}", result.name)
        assert.are.same({ arg1 = "12345", ["ar}gv2"] = "", ["a=rg3"] ="{\\\\=\\}",  }, result.args)
    end)
    it("Should parse a line with different keywords", function()
        local lkeywords = {
            open_bracket  = "<",
            close_bracket = ">",
            equal         = "~",
            escape        = "#",
            spaces        = {" "},
        }

        local line = "<arg1 ~ #>> <   arg1~12345> and <ar#>gv2\t> and <a#~rg3~#<####~###>>"
        local is_success, result = parse_line(line, lkeywords)
        assert.is_true(is_success, got_error(result))

        assert.are.same("<arg1> <arg1> and <ar>gv2\t> and <a~rg3>", result.name)
        assert.are.same({ arg1 = "12345", ["ar>gv2\t"] = "", ["a~rg3"] ="<##~#>",  }, result.args)
    end)
end)
