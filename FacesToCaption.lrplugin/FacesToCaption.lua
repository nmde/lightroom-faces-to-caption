function file_exists(fileName)
    local f = io.open(fileName, 'r')
    if f == nil then
        return false
    else
        io.close(f)
        return true
    end
end

function split(input, sep)
    local t = {}
    for str in string.gmatch(input, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function custom_sort(list,test)
    for k=1,#list-1 do
    for j=1,#list-k do
            if test(list[j],list[j+1]) then
                    holder = list[j]
                    list[j] = list[j+1]
                    list[j+1] = holder
            end
    end
    end
end

function sort_by_x(a, b)
    return a.x > b.x
end

local tempFile = "temp.txt"
local outputFile = "output.txt"
function FacesToCaption(fileName, log)
    function execute(command)
        log(command)
        os.execute(command)
    end

    if file_exists(tempFile) then
        os.remove(tempFile)
    end
    execute("exiftool  " .. fileName .. " >> " .. tempFile)
    local output = io.open(tempFile)
    local line = output:read()
    local people = {}
    while line do
        if string.sub(line, 0, 11) == "Region Name" then
            for i, name in pairs(split(string.sub(line, string.find(line, ':')+ 2, string.len(line)), ',')) do
                if people[i] == nil then
                    person = {}
                    person.x = 0
                    people[i] = person
                end
                people[i].name = string.gsub(name, '%s*(.*)', '%1')
            end
        elseif string.sub(line, 0, 13) == "Region Area X" then
            for i, x in pairs(split(string.sub(line, string.find(line, ':') + 2, string.len(line)), ',')) do
                if people[i] == nil then
                    person = {}
                    person.name = ''
                    people[i] = person
                end
                people[i].x = string.gsub(x, '%s*(.*)', '%1')
            end
        end
        line = output:read()
    end
    local caption = ""
    custom_sort(people, sort_by_x)
    for i, person in pairs(people) do
        log("Person: " .. person.name .. " (" .. person.x .. ")")
        caption = caption .. ', ' .. person.name
    end
    caption = string.sub(caption, 3, string.len(caption))
    execute("exiftool -overwrite_original -iptc:Caption-Abstract=\"" .. caption .. "\" -Description=\"" .. caption .. "\" "  .. fileName)
    execute("exiftool  " .. fileName .. " >> " .. outputFile)
    os.remove(tempFile)
end

return FacesToCaption
