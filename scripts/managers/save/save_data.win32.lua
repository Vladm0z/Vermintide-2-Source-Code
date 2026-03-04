-- chunkname: @scripts/managers/save/save_data.win32.lua

require("scripts/settings/player_data")

local var_0_0 = rawget(_G, "Steam")
local var_0_1 = var_0_0 and var_0_0.branch_name and var_0_0.branch_name()

if var_0_1 and var_0_1 ~= "public" then
	SaveFileName = "save_data_" .. tostring(var_0_1)
else
	SaveFileName = "save_data"
end

SaveData = SaveData or {
	profiles_version = 45,
	player_data_version = 8,
	talents_version = 1,
	save_loaded = false,
	video_version = 1,
	version = 7
}

function populate_save_data(arg_1_0)
	local var_1_0 = SaveData.version == arg_1_0.version

	if var_1_0 then
		if SaveData.profiles_version ~= arg_1_0.profiles_version then
			arg_1_0.profiles = nil

			print("Wrong profiles_version for save file, saved: ", arg_1_0.profiles_version, " current: ", SaveData.profiles_version)

			arg_1_0.profiles_version = SaveData.profiles_version
		end

		if SaveData.player_data_version ~= arg_1_0.player_data_version then
			arg_1_0.player_data = nil

			print("Wrong player_data_version for save file, saved: ", arg_1_0.player_data_version, " current: ", SaveData.player_data_version)

			arg_1_0.player_data_version = SaveData.player_data_version
		end

		if SaveData.video_version ~= arg_1_0.video_version then
			print("User haven't seen the latest video yet - Show instead of loading screen")

			arg_1_0.video_version = SaveData.video_version
		end

		if SaveData.talents_version ~= arg_1_0.talents_version then
			arg_1_0.talents = nil

			print("Wrong talents_version for save file, saved: ", arg_1_0.talents_version, " current: ", SaveData.talents_version)

			arg_1_0.talents_version = SaveData.talents_version
		end

		if not arg_1_0.backend_profile_hash then
			arg_1_0.backend_profile_hash = SaveData.backend_profile_hash
		end

		SaveData = arg_1_0
	else
		print("Wrong version for save file, saved: ", arg_1_0.version, " current: ", SaveData.version)
	end

	local var_1_1
	local var_1_2 = (script_data.use_local_backend or not rawget(_G, "Steam")) and "local_save" or Steam.user_id()

	populate_player_data_from_save(SaveData, var_1_2, var_1_0)

	SaveData.save_loaded = true
end
