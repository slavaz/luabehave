local parse_table_line = require("luabehave.parser.table_line")

local function got_error(error_msg)
    return ("Expected line to be parsed successfully but got error: %s"):format(tostring(error_msg))
end

local function got_success(result)
    return ("Expected line to fail parsing but got success: %s"):format(tostring(result))
end

local keywords = {
    table_row = "|",
    escape = "\\",
    spaces = {" ", "\t"},
}

describe("parse_table_line", function()
    it("should parse a valid table line with multiple arguments", function()
        local line = "|arg1|arg2|arg3|arg4|arg5|"
        local success, result = parse_table_line(line, keywords)
        assert.is_true(success, got_error(result))
        assert.is_table(result)
        assert.are.same({"arg1", "arg2", "arg3", "arg4", "arg5"}, result)
    end)

    it("should parse a valid table line with leading and trailing spaces", function()
        local line = "|  arg1  |  arg2  |  arg3    |"
        local success, result = parse_table_line(line, keywords)
        assert.is_true(success, got_error(result))
        assert.is_table(result)
        assert.are.same({"  arg1  ", "  arg2  ", "  arg3    "}, result)
    end)

    it("should parse a valid table line with special characters", function()
        local line = "|arg1|ar!@#$%^&*(g2|ar%^&*()g3|arg4|arg5|arg6|arg7|arg8|arg9|arg10|"
        local success, result = parse_table_line(line, keywords)
        assert.is_true(success, got_error(result))
        assert.is_table(result)
        assert.are.same({"arg1", "ar!@#$%^&*(g2", "ar%^&*()g3", "arg4", "arg5", "arg6", "arg7", "arg8", "arg9", "arg10"}, result)
    end)

    it("should parse a valid table line with empty ceil", function()
        local line = "|arg1|arg2||arg3|"
        local success, result = parse_table_line(line, keywords)
        assert.is_true(success, got_error(result))
        assert.is_table(result)
        assert.are.same({"arg1", "arg2", "", "arg3",}, result)

    end)
    it("should  parse a valid table escaped delimiter", function()
        local line = "|arg1|arg2\\||arg3|"
        local success, result = parse_table_line(line, keywords)
        assert.is_true(success, got_error(result))
        assert.is_table(result)
        assert.are.same({"arg1", "arg2|", "arg3",}, result)
    end)
    it("should  parse empty table row", function()
        local line = "||"
        local success, result = parse_table_line(line, keywords)
        assert.is_true(success, got_error(result))
        assert.is_table(result)
        assert.are.same({"",}, result)
    end)
    it("should  parse with different keywords", function()
        local line = "_some text\t_   \t\t\t some #_another text_"
        local lkeywords = {
            table_row = "_",
            escape = "#",
            spaces = {" "},
        }
        local success, result = parse_table_line(line, lkeywords)
        assert.is_true(success, got_error(result))
        assert.is_table(result)
        assert.are.same({"some text\t","   \t\t\t some _another text"}, result)
    end)

    it("Miltiple ceils should failed", function()
        local line = "|arg1|arg2"
        local success, result = parse_table_line(line, keywords)
        assert.is_false(success, got_success(result))
        assert.is_string(result)
        assert.are.same("Unexpected end of line. Check the closing delimiter.", result)
    end)
        it("One ceil should failed", function()
        local line = "|arg1"
        local success, result = parse_table_line(line, keywords)
        assert.is_false(success, got_success(result))
        assert.is_string(result)
        assert.are.same("Unexpected end of line. Check the closing delimiter.", result)
    end)
end)
