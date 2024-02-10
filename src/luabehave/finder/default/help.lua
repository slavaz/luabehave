return function(_)
    return [[
The default search submodule searches the local file system for stories and step definitions.
The default search submodule searches for files with story definitions with the extension specified in the 'story.extention' argument (default: '.story') in the directory and all subdirectories specified in 'story.path' argument (default: 'bdd/stories').
The default search submodule searches for files with step definitions with the extension specified in the 'step.extention' argument (default: '.lua') in the directory and all subdirectories specified in the 'step.path' argument (default: 'bdd/steps').
The default search submodule uses the following arguments:
    [--finder.default.story.extention=<.ext>]
      the file extension for story files (default: '.story')
    [--finder.default.story.path=<path>]
      the directory where story files are located (default: 'bdd/stories')
    [--finder.default.step.extention=<.ext>]
      the file extension for step files (default: '.lua')
    [--finder.default.step.path=<path>]
      the directory where step files are located (default: 'bdd/steps')
]]
end
