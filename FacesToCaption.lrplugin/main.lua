local LrTasks = import("LrTasks")
local LrApplication = import("LrApplication")
local LrLogger = import("LrLogger")
local LrDialogs = import("LrDialogs")
local FacesToCaption = import("./FacesToCaption")

local logger = LrLogger("FacesToCaptionPlugin")
logger:enable("print")

LrTasks.startAsyncTask(function ()
    local catalog = LrApplication.activeCatalog()
    local photo = catalog:getTargetPhoto()
    if photo == nil then
        LrDialogs.message("Faces to Caption", "Please select a photo before running Faces to Caption.")
    else
        catalog:withWriteAccessDo("Write Faces to Caption", function () 
            FacesToCaption(photo.getFormattedMetadata('path'), logger.quickf('info'))
        end)
    end
end)
