local table_parser = require("luabehave.parser.table")


local path_to_examples = "spec/examples/parser/table"

local keywords = {
    table_name = "~|",
    table_header = "!|",
    table_row = "|",
    comments = {"#", "--"},
}

describe("parse tables from examples", function()
    it("should parse a table from example file", function()
        local test_amount = 5

        for i = 1,test_amount do
            local file_name = ("good_%03d"):format(i)
            local file_path = ("%s/%s"):format(path_to_examples, file_name)
            local file = io.open(file_path..".txt", "r")
            assert.is_not_nil(file, ("Failed to open file %s.txt"):format(file_path))
            local table_context = {}
            for line in file:lines() do
                    local ret_value, result = table_parser.parse(table_context, line, keywords)
                    assert.are.same(1, ret_value, ("Failed to parse file %s.txt: %s\nLine: '%s'"):format(file_path, result, line))
            end
            file:close()

            local expected_result = dofile(file_path .. "_expected.lua")
            assert.are.same(expected_result, table_context, ("Failed to parse file %s.txt"):format(file_path))
        end


    end)
    it("should fail to parse a table from example file", function()
        local test_amount = 9

        for i = 1,test_amount do
            local file_name = ("bad_%03d"):format(i)
            local file_path = ("%s/%s"):format(path_to_examples, file_name)
            local file = io.open(file_path..".txt", "r")
            assert.is_not_nil(file, ("Failed to open file %s.txt"):format(file_path))
            local table_context = {}
            local ret_value, result
            for line in file:lines() do
                ret_value, result = table_parser.parse(table_context, line, keywords)
                if ret_value ~= 1 then
                    break
                end
            end
            file:close()
            local expected_result = dofile(file_path .. "_expected.lua")

            assert.are.same(expected_result.code, ret_value, ("Expected to fail parsing file %s.txt"):format(file_path))
            assert.are.same(expected_result.msg, result, ("File parsing should be failed %s.txt"):format(file_path))
        end

    end)

end)

describe("Get parsed table from parser content", function()
    it("should return an empty table from empty table context", function()
        local table_context = {
            rows = {}
        }
        local expected_result = {}
        local result = table_parser.get(table_context)
        assert.are.same(expected_result, result)
    end)
    it("should return a key with an empty headers as a keys from table context with only headers", function()
        local table_context = {
            name = "table_name",
            headers = {"header1", "header2"},
            rows = {}
        }
        local expected_result = {
            table_name = {
                header1 = {},
                header2 = {},
            },
        }
        local result = table_parser.get(table_context)
        assert.are.same(expected_result, result)
    end)
    it("should return an empty headers as a keys from table context with only headers", function()
        local table_context = {
            headers = {"header1", "header2"},
            rows = {}
        }
        local expected_result = {
            header1 = {},
            header2 = {},
        }
        local result = table_parser.get(table_context)
        assert.are.same(expected_result, result)
    end)
    it("should return an empty table map from single row with empty headers", function()
        local table_context = {
            rows = {
                {"val1", "val2"},
            }
        }
        local expected_result = {"val1", "val2"}
        local result = table_parser.get(table_context)
        assert.are.same(expected_result, result)
    end)
    it("should return an empty table map from single row with empty headers", function()
        local table_context = {
            rows = {
                {"val1", "val2"},
                {"val3", "val4"},
            }
        }
        local expected_result = {
                {"val1", "val2"},
                {"val3", "val4"},
        }
        local result = table_parser.get(table_context)
        assert.are.same(expected_result, result)
    end)
    it("should return a table map from single row", function()
        local table_context = {
            headers = {"header1", "header2"},
            rows = {
                {"val1", "val2"},
            }
        }
        local expected_result = {
            header1 = "val1",
            header2 = "val2",
        }
        local result = table_parser.get(table_context)
        assert.are.same(expected_result, result)
    end)
    it("should return a table map from single row with extra elements", function()
        local table_context = {
            headers = {"header1", "header2"},
            rows = {
                {"val1", "val2", "val3"},
            }
        }
        local expected_result = {
            header1 = "val1",
            header2 = "val2",
            "val3"
        }
        local result = table_parser.get(table_context)
        assert.are.same(expected_result, result)
    end)
    it("should return a list of table maps from multiple rows", function()
        local table_context = {
            headers = {"header1", "header2"},
            rows = {
                {"val1", "val2"},
                {"val3", "val4"},
            }
        }
        local expected_result = {
            {header1 = "val1", header2 = "val2"},
            {header1 = "val3", header2 = "val4"},
        }
        local result = table_parser.get(table_context)
        assert.are.same(expected_result, result)
    end)
    it("should return a list of table maps  rows with different element count", function()
        local table_context = {
            headers = {"header1", "header2"},
            rows = {
                {"val1", "val2"},
                {"val3", "val4", "val5"},
            }
        }
        local expected_result = {
            { header1 = "val1", header2 = "val2" },
            { header1 = "val3", header2 = "val4", "val5" },
        }
        local result = table_parser.get(table_context)
        assert.are.same(expected_result, result)
    end)
    it("should return a list of table maps  rows with different header count", function()
        local table_context = {
            headers = {"header1", "header2", "header3"},
            rows = {
                {"val1", "val2"},
                {"val3", "val4", "val5"},
            }
        }
        local expected_result = {
            { header1 = "val1", header2 = "val2" },
            { header1 = "val3", header2 = "val4", header3 = "val5" },
        }
        local result = table_parser.get(table_context)
        assert.are.same(expected_result, result)
    end)
    it("should return a key with table name from table context", function()
        local table_context = {
            name = "table_name",
            headers = {"header1", "header2", "header3"},
            rows = {
                {"val1", "val2"},
                {"val3", "val4", "val5"},
            }
        }
        local expected_result = {
            table_name = {
                { header1 = "val1", header2 = "val2" },
                { header1 = "val3", header2 = "val4", header3 = "val5" },
            }
        }
        local result = table_parser.get(table_context)
        assert.are.same(expected_result, result)
    end)
    it("should return a key with table name from table context", function()
        local table_context = {
            name = "table_name",
            rows = {}
        }
        local expected_result = {
            table_name = {}
        }
        local result = table_parser.get(table_context)
        assert.are.same(expected_result, result)
    end)
end)
