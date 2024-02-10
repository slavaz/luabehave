local default_loader = {
    name = function() return 'default' end,
    help = require('luabehave.loader.default.help'),

    load_steps = require('luabehave.loader.default.steps'),
    load_stories = require('luabehave.loader.default.stories'),
}

return default_loader
