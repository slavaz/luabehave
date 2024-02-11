local utils = {}

utils.RET_VALUES = {
    SUCCESS = 1,
    FAILURE = 2,
    SKIP = 3,
    PARSE_ERROR = 4,
    VALIDATION_ERROR = 5,
    LINE_VALIDATION_ERROR = 6,
}

utils.STORY_STATE = {
    STORY = 1,
    BACKGROUND = 2,
    SCENARIO = 4,
    SCENARIO_EXAMPLES = 8,
}

return utils
