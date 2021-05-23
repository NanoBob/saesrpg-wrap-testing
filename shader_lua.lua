
local wrapTextures = {
	emap = true,
	main_wrap = true,
	combinetexpage128 = true,
	nrg50092body128 = true,
	leviathnbody8bit256 = true,
	tornado92body256b = true,
	sparrow92body128 = true,
	remapsavanna92body128 = true,
	sparrow92body128 = true,
	Shamalbody256 = true,
	remapslamvan92body128 = true,
	remapremington256body = true,
	rustler92body256 = true,
	rctiger92body128 = true,
	rcraider92texpage128 = true,
	rcgoblin92texpage128 = true,
	rcbaron92texpage64 = true,
	nevada92body256 = true,
	monstera92body256a = true,
	monsterb92body256a = true,
	maverick92body128 = true,
	hydrabody256 = true,
	hunterbody8bit256a = true,
	hotdog92body256 = true,
	fcr90092body128 = true,
	cropdustbody256 = true,
	cargobob92body256 = true,
	remapbroadway92body128 = true,
	remapblade92body128 = true,
	beagle256 = true,
	bf40092body128 = true,
	andromeda92body = true,
	andromeda92wing = true,
	dodo92body8bit256 = true,
	white1024 = true,
	chinookbody = true,
	remapsultanbody256 = true,
	dirt = true,
	polmavbody128a = true,
	hotknifebody128b = true,
	hotknifebody128a = true,
	farmtr1_92_128 = true,
	freibox92texpage256 = true,
	bagboxb128 = true,
	bagboxa128 = true,
	bagboxa32 = true,
    vehiclegrunge256 = true,
    remap_body = true
}

function downloadTexture(url, callback)
	if (isBrowserDomainBlocked(url, true)) then
		requestBrowserDomains({ url }, true, function(isAccepted)
			if (not isAccepted) then
				outputChatBox("Unable to whitelist texture download url", 255, 0, 0)
                return
			end
			downloadTexture(url, callback)
		end)
		return
	end
	fetchRemote(url, function(data, error)
		if (error ~= 0) then
			outputChatBox("Unable to download texture (" .. error .. ")", 255, 0, 0)
			return
		end
		local texture = dxCreateTexture(data)
		callback(texture)
	end)
end

function setShaderTexture(shader, texture)
	dxSetShaderValue (shader, "wrapTexture", texture)
end

function applyShaderToVehicle(shader, vehicle)
    local textures = engineGetModelTextureNames(getElementModel(vehicle))
	for _, texture in pairs(textures) do
        if (wrapTextures[texture]) then
		    engineApplyShaderToWorldTexture(shader, texture, vehicle)
        end
	end
end

function removeShaderFromVehicle(shader, vehicle)
    local textures = engineGetModelTextureNames(getElementModel(vehicle))
	for _, texture in pairs(textures) do
		engineRemoveShaderFromWorldTexture(shader, texture, vehicle)
	end
end

local shader = dxCreateShader("shader.fx")
local lastVehicle

function setShaderCommandHandler(command, url)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) then
		outputChatBox("You need to be in a vehicle to apply a shader", 255, 0, 0)
		return
	end

	if (lastVehicle) then
		removeShaderFromVehicle(shader, vehicle)
	end

	downloadTexture(url, function(texture)
		setShaderTexture(shader, texture)	
		applyShaderToVehicle(shader, vehicle)
		outputChatBox("Shader applied", 0, 255, 0)
	end)

	lastVehicle = vehicle
end
addCommandHandler("setShader", setShaderCommandHandler, false, false)