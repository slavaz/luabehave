local utils = {}

function utils.add_to_table(table, element)
    table[#table + 1] = element
end

function utils.is_table_empty(tbl)
    return next(tbl) == nil
end

function utils.merge(table1, table2)
    local merged_table = {}
    for k, v in pairs(table1) do
        merged_table[k] = v
    end
    for k, v in pairs(table2) do
        merged_table[k] = v
    end
    return merged_table
end

function utils.table_intersection(table1, table2)
    local intersection = {}
    for k, _ in pairs(table1) do
        if table2[k] then
            intersection[k] = true
        end
    end
    return intersection
end
function utils.get_table_keys(t)
    local ret = {}
    for k, _ in pairs(t) do
        ret[#ret + 1] = k
    end
    return ret
end

function utils.get_table_values(t)
    local ret = {}
    for _, k in pairs(t) do
        ret[k] = true
    end
    return ret
end
function utils.trim(s)
    return s:gsub("^%s*(.-)%s*$", "%1")
end

function utils.startswith(s, prefix)
    return s:sub(1, #prefix) == prefix
end

function utils.split_by_comma(line)
    local result = {}
    for word in line:gmatch("[^,]+") do
        result[#result + 1] = utils.trim(word)
    end
    return result
end

function utils.get_submodule(args, args_key, factory_help_func, submodules, default_key)
    local submodule = submodules[args[args_key]] or submodules[default_key]
    local submodule_help = submodule.help
    submodule.help = function(args)
        return factory_help_func(args) .. "\n" .. submodule.name() .. "\n" ..
            submodule_help(args)
    end
    return submodule
end

return utils
