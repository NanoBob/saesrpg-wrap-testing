function loadSAESModelsLua()
    local file = fileOpen("models_client.lua")
    local content = fileRead(file, fileGetSize(file))
    fileClose(file)
    
    loadstring(content)()
end

function overwriteDownloadExport()
    exports.RPGfile = {
        downloadFile = function(this, filepath)
            return fileExists(filepath)
        end,
    }
end

function init()
    loadSAESModelsLua()
    overwriteDownloadExport()
    startModels()
end
init()