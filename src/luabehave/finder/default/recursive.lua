local utils = require('luabehave.utils')
local lfs = require('lfs')

local function recursive_search_stories(base_path, file_extention, files, seen)
    if not files then files = {} end
    if not seen then seen = {} end

    if seen[base_path] then return files end
    seen[base_path] = true

    for file in lfs.dir(base_path) do
        if file ~= "." and file ~= ".." then
            local path = base_path .. "/" .. file
            local attr = lfs.attributes(path)
            if attr.mode == "directory" then
                recursive_search_stories(path, file_extention, files, seen)
            end
            if file:sub(- #file_extention) == file_extention then
                if not files[file] then
                    files[path] = true
                end
            end
        end
    end
    return files
end

return function(_, story_path, story_extention)
    return true, utils.get_table_keys(recursive_search_stories(story_path, story_extention))
end
