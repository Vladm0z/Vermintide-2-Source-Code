-- chunkname: @scripts/managers/backend/backend_interface_profile_hash.lua

BackendInterfaceProfileHash = class(BackendInterfaceProfileHash)

BackendInterfaceProfileHash.init = function (self)
	-- function 1
	return
end

BackendInterfaceProfileHash.on_authenticated = function (self)
	-- function 2
	local hash = Backend.get_hashed_profile_id()

	if hash ~= SaveData.backend_profile_hash then
		SaveData.backend_profile_hash = hash

		if SaveData.save_loaded then
			Managers.save:auto_save(SaveFileName, SaveData, nil)
		end
	end
end
