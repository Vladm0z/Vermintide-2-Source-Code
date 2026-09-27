-- chunkname: @scripts/managers/backend/backend_interface_profile_hash.lua

BackendInterfaceProfileHash = class(BackendInterfaceProfileHash)

BackendInterfaceProfileHash.init = function (arg_1_0)
	-- function 1
	return
end

BackendInterfaceProfileHash.on_authenticated = function (arg_2_0)
	-- function 2
	local get_hashed_profile_id = Backend.get_hashed_profile_id()

	if get_hashed_profile_id ~= SaveData.backend_profile_hash then
		SaveData.backend_profile_hash = get_hashed_profile_id

		if not SaveData.save_loaded then
			Managers.save:auto_save(SaveFileName, SaveData, nil)
		end
	end
end
