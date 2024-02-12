local LEVELS = require('luabehave.output.levels')

local levels = {
    [LEVELS.TRACE] = 'TRACE',
    [LEVELS.DEBUG] = 'DEBUG',
    [LEVELS.INFO] = 'INFO',
    [LEVELS.WARNING] = 'WARNING',
    [LEVELS.ERROR] = 'ERROR',
}


local default_output = {
    name = function() return 'default' end,

    level = LEVELS.INFO,
}

function default_output.trace(msg)
    default_output.print(LEVELS.TRACE, msg)
end

function default_output.debug(msg)
    default_output.print(LEVELS.DEBUG, msg)
end

function default_output.info(msg)
    default_output.print(LEVELS.INFO, msg)
end

function default_output.warning(msg)
    default_output.print(LEVELS.WARNING, msg)
end

function default_output.error(msg)
    default_output.print(LEVELS.ERROR, msg)
end

function default_output.set_level(level)
    default_output.level = level
end

function default_output.print(level, msg)
    if default_output.level > level then return end
    print(("[%s]: %s"):format(levels[level], msg))
end

return default_output
