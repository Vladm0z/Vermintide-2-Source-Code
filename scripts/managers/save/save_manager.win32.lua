-- chunkname: @scripts/managers/save/save_manager.win32.lua

require("scripts/managers/save/script_save_token")

SaveManager = class(SaveManager)

SaveManager.init = function (self, disable_cloud_save)
	-- function 1
	if not disable_cloud_save and rawget(_G, "Steam") and Cloud.enabled() then
		fassert(rawget(_G, "Steam"), "Steam is required for cloud saves")

		self._impl = Cloud
	else
		self._impl = SaveSystem
	end
end

SaveManager.auto_save = function (self, file_name, data, callback, force_local_save)
	-- function 2
	local SaveSystem

	if force_local_save then
		SaveSystem = SaveSystem

		if not SaveSystem then
			-- Nothing
		end
	end

	SaveSystem = self._impl

	local system = SaveSystem

	::label_2_0::

	local token = system.auto_save(file_name, data)
	local save_token = ScriptSaveToken:new(system, token)

	Managers.token:register_token(save_token, callback)

	return save_token
end

SaveManager.auto_load = function (self, file_name, callback, force_local_save)
	-- function 3
	local SaveSystem

	if force_local_save then
		SaveSystem = SaveSystem

		if not SaveSystem then
			-- Nothing
		end
	end

	SaveSystem = self._impl

	local system = SaveSystem

	::label_3_0::

	local token = system.auto_load(file_name)
	local save_token = ScriptSaveToken:new(system, token)

	Managers.token:register_token(save_token, callback)

	return save_token
end
