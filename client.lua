local model_type = { "col", "txd", "dff" }
function loadSAESModelsLua()
    local file = fileOpen("modelsTable.lua")
    local content = fileRead(file, fileGetSize(file))
    fileClose(file)
    
    loadstring(content)()
end

function startModels( )
	for modelID, v in pairs( modelTable ) do
		for i=1, #model_type do
			local modelType = model_type[ i ]
			local fileName = v[ modelType ]
			if fileName then
				local fileDirectory = fileName.."."..modelType;
				if fileExists(fileDirectory) then
					replaceModel( fileDirectory, modelID, modelType );
				end
			end
		end

	end
end

function replaceModel( fileDirectory, modelID, modelType )
	if modelType == "col" then
		local col = engineLoadCOL( fileDirectory );
		return engineReplaceCOL( col, modelID );
	elseif modelType == "txd" then
		local txd =	engineLoadTXD ( fileDirectory );
		return engineImportTXD( txd, modelID );
	elseif modelType == "dff" then
		local dff = engineLoadDFF( fileDirectory, 0 );
		return engineReplaceModel( dff, modelID, modelTable[modelID].alphaTransparency or false );
	end
end

function init()
    loadSAESModelsLua()
    startModels( )
end
init()