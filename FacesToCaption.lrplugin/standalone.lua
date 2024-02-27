local FacesToCaption = require("FacesToCaption")

local file = arg[1]
if file == nil then
    print("Error: No file specified.")
else
    FacesToCaption(file,  print)
end
