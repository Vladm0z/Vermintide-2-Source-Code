-- chunkname: @scripts/managers/backend/backend_interface_profile_hash.lua

BackendInterfaceProfileHash = class(BackendInterfaceProfileHash)

function BackendInterfaceProfileHash.init(arg_1_0)
	return
end

function BackendInterfaceProfileHash.on_authenticated(arg_2_0)
	local var_2_0 = Backend.get_hashed_profile_id()

	if var_2_0 ~= SaveData.backend_profile_hash then
		SaveData.backend_profile_hash = var_2_0

		if SaveData.save_loaded then
			Managers.save:auto_save(SaveFileName, SaveData, nil)
		end
	end
end
