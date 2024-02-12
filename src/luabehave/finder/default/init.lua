local default_finder = {
    name = function() return 'default' end,

    search_steps = require('luabehave.finder.default.steps'),
    search_stories = require('luabehave.finder.default.stories'),
}



return default_finder
