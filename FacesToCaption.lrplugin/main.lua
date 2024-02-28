local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'
local FacesToCaption = require("FacesToCaption")

LrTasks.startAsyncTask(function()
    local catalog = LrApplication.activeCatalog()
    local photo = catalog:getTargetPhotos()
    if photo == nil then
        LrDialogs.message("Faces to Caption", "Please select a photo")
        return
    end
    local filename = photo:getFormattedMetadata("fileName")
    FacesToCaption(filename, print)
end)
