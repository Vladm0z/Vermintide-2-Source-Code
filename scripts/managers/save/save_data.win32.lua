-- chunkname: @scripts/managers/save/save_data.win32.lua

require("scripts/settings/player_data")

local var_0_0 = rawget(_G, "Steam")

if not var_0_0 then
	-- Nothing
end

::label_0_0::

local branch_name = var_0_0.branch_name

branch_name = not branch_name and var_0_0.branch_name()

::label_0_1::

if not (not branch_name and branch_name == "public") then
	SaveFileName = "save_data_" .. tostring(branch_name)
else
	SaveFileName = "save_data"
end

local SaveData = SaveData

SaveData = SaveData or {
	profiles_version = 45,
	player_data_version = 8,
	talents_version = 1,
	save_loaded = false,
	video_version = 1,
	version = 7
}
SaveData = SaveData

function populate_save_data(self)
	-- function 1
	local flag = SaveData.version == self.version

	if not flag then
		if SaveData.profiles_version ~= self.profiles_version then
			self.profiles = nil

			print("Wrong profiles_version for save file, saved: ", self.profiles_version, " current: ", SaveData.profiles_version)

			self.profiles_version = SaveData.profiles_version
		end

		if SaveData.player_data_version ~= self.player_data_version then
			self.player_data = nil

			print("Wrong player_data_version for save file, saved: ", self.player_data_version, " current: ", SaveData.player_data_version)

			self.player_data_version = SaveData.player_data_version
		end

		if SaveData.video_version ~= self.video_version then
			print("User haven't seen the latest video yet - Show instead of loading screen")

			self.video_version = SaveData.video_version
		end

		if SaveData.talents_version ~= self.talents_version then
			self.talents = nil

			print("Wrong talents_version for save file, saved: ", self.talents_version, " current: ", SaveData.talents_version)

			self.talents_version = SaveData.talents_version
		end

		if not self.backend_profile_hash then
			self.backend_profile_hash = SaveData.backend_profile_hash
		end

		SaveData = self
	else
		print("Wrong version for save file, saved: ", self.version, " current: ", SaveData.version)
	end

	local var_1_1
	local flag_2

	flag_2 = script_data.use_local_backend or not rawget(_G, "Steam") or "local_save" or Steam.user_id()

	populate_player_data_from_save(SaveData, flag_2, flag)

	SaveData.save_loaded = true
end
