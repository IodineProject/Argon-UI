local ArgonTypes = require("./Library.d")

return {
    Library = (require("./Library") :: any) :: ArgonTypes.Library,
    Types = ArgonTypes,
    SaveManager = require("./addons/SaveManager"),
    ThemeManager = require("./addons/ThemeManager"),
}
