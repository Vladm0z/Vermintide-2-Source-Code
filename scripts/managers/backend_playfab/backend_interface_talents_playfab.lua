-- chunkname: @scripts/managers/backend_playfab/backend_interface_talents_playfab.lua

BackendInterfaceTalentsPlayfab = class(BackendInterfaceTalentsPlayfab)

function BackendInterfaceTalentsPlayfab.init(arg_1_0, arg_1_1)
	arg_1_0._backend_mirror = arg_1_1
	arg_1_0._talents = {}
	arg_1_0._default_loadouts_talents = {}
	arg_1_0._career_loadouts_talents = {}
	arg_1_0._default_talents_overrides = {}
	arg_1_0._selected_career_custom_talents = {}
	arg_1_0._bot_talents = {}

	arg_1_0:_refresh()
end

function BackendInterfaceTalentsPlayfab._refresh(arg_2_0)
	if not DEDICATED_SERVER then
		arg_2_0:_refresh_default_loadouts_talents()
		arg_2_0:_refresh_career_loadouts_talents()
		arg_2_0:_setup_default_overrides()
	end

	arg_2_0:_refresh_talents()

	if not DEDICATED_SERVER then
		arg_2_0:refresh_bot_talents()
	end
end

function BackendInterfaceTalentsPlayfab._refresh_talents(arg_3_0)
	local var_3_0 = arg_3_0._talents
	local var_3_1 = arg_3_0._backend_mirror

	for iter_3_0, iter_3_1 in pairs(CareerSettings) do
		if iter_3_1.playfab_name then
			local var_3_2 = var_3_1:get_character_data(iter_3_0, "talents")

			if var_3_2 then
				local var_3_3 = string.split_deprecated(var_3_2, ",")

				for iter_3_2 = 1, #var_3_3 do
					var_3_3[iter_3_2] = tonumber(var_3_3[iter_3_2])
				end

				arg_3_0:_validate_talents(iter_3_0, var_3_3, iter_3_1.talent_tree_index)

				var_3_0[iter_3_0] = var_3_3
			end
		end
	end

	arg_3_0._dirty = false
end

local var_0_0 = {}

function BackendInterfaceTalentsPlayfab.refresh_bot_talents(arg_4_0)
	arg_4_0._bot_talents = table.clone(arg_4_0._talents)

	local var_4_0 = arg_4_0._bot_talents
	local var_4_1 = arg_4_0._backend_mirror
	local var_4_2 = (PlayerData.loadout_selection or var_0_0).bot_equipment or var_0_0
	local var_4_3 = Managers.mechanism:current_mechanism_name()
	local var_4_4 = InventorySettings.bot_loadout_allowed_mechanisms[var_4_3]

	for iter_4_0, iter_4_1 in pairs(CareerSettings) do
		if iter_4_1.playfab_name then
			local var_4_5 = var_4_4 and var_4_2[iter_4_0]

			if var_4_5 then
				local var_4_6 = var_4_1:get_character_data(iter_4_0, "talents", var_4_5)

				if var_4_6 then
					local var_4_7 = string.split_deprecated(var_4_6, ",")

					for iter_4_2 = 1, #var_4_7 do
						var_4_7[iter_4_2] = tonumber(var_4_7[iter_4_2])
					end

					arg_4_0:_validate_talents(iter_4_0, var_4_7, iter_4_1.talent_tree_index, var_4_5)

					var_4_0[iter_4_0] = var_4_7
				end
			end
		end
	end

	print("[BackendInterfaceItemPlayfab] Refreshing bot loadout")
end

function BackendInterfaceTalentsPlayfab._refresh_default_loadouts_talents(arg_5_0)
	local var_5_0 = arg_5_0._default_loadouts_talents
	local var_5_1 = arg_5_0._backend_mirror
	local var_5_2 = true

	table.clear(var_5_0)

	for iter_5_0, iter_5_1 in pairs(CareerSettings) do
		if iter_5_1.playfab_name then
			local var_5_3 = var_5_1:get_default_loadouts(iter_5_0)

			var_5_0[iter_5_0] = var_5_0[iter_5_0] or {}

			if var_5_3 then
				local var_5_4 = var_5_0[iter_5_0]

				for iter_5_2 = 1, #var_5_3 do
					local var_5_5 = var_5_3[iter_5_2].talents

					if var_5_5 then
						local var_5_6 = string.split_deprecated(var_5_5, ",")

						for iter_5_3 = 1, #var_5_6 do
							var_5_6[iter_5_3] = tonumber(var_5_6[iter_5_3])
						end

						arg_5_0:_validate_talents(iter_5_0, var_5_6, iter_5_1.talent_tree_index, var_5_2)

						var_5_4[iter_5_2] = var_5_6
					else
						var_5_4[iter_5_2] = {
							0,
							0,
							0,
							0,
							0,
							0
						}
					end
				end
			end
		end
	end

	arg_5_0._dirty = false
end

function BackendInterfaceTalentsPlayfab._refresh_career_loadouts_talents(arg_6_0)
	local var_6_0 = arg_6_0._career_loadouts_talents
	local var_6_1 = arg_6_0._backend_mirror
	local var_6_2 = true

	table.clear(var_6_0)

	for iter_6_0, iter_6_1 in pairs(CareerSettings) do
		if iter_6_1.playfab_name then
			local var_6_3, var_6_4 = var_6_1:get_career_loadouts(iter_6_0)

			arg_6_0._selected_career_custom_talents[iter_6_0] = var_6_3

			if var_6_4 then
				var_6_0[iter_6_0] = var_6_0[iter_6_0] or {}

				local var_6_5 = var_6_0[iter_6_0]

				for iter_6_2 = 1, #var_6_4 do
					local var_6_6 = var_6_4[iter_6_2].talents

					if var_6_6 then
						local var_6_7 = string.split_deprecated(var_6_6, ",")

						for iter_6_3 = 1, #var_6_7 do
							var_6_7[iter_6_3] = tonumber(var_6_7[iter_6_3])
						end

						arg_6_0:_validate_talents(iter_6_0, var_6_7, iter_6_1.talent_tree_index, var_6_2)

						var_6_5[iter_6_2] = var_6_7
					else
						var_6_5[iter_6_2] = {
							0,
							0,
							0,
							0,
							0,
							0
						}
					end
				end
			end
		end
	end

	arg_6_0._dirty = false
end

function BackendInterfaceTalentsPlayfab._setup_default_overrides(arg_7_0)
	local var_7_0 = Managers.mechanism:current_mechanism_name()
	local var_7_1 = PlayerData.loadout_selection and PlayerData.loadout_selection[var_7_0] or {}

	table.clear(arg_7_0._default_talents_overrides)

	if not var_7_1 then
		return
	end

	local var_7_2 = Managers.state.game_mode and Managers.state.game_mode:game_mode_key()

	if not var_7_2 or not InventorySettings.default_loadout_allowed_game_modes[var_7_2] then
		return
	end

	for iter_7_0, iter_7_1 in pairs(CareerSettings) do
		local var_7_3 = var_7_1[iter_7_0] or 1

		if var_7_3 and InventorySettings.loadouts[var_7_3].loadout_type == "default" then
			arg_7_0:set_default_override(iter_7_0, var_7_3)
		end
	end
end

function BackendInterfaceTalentsPlayfab.set_default_override(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._default_loadouts_talents[arg_8_1]

	arg_8_0._default_talents_overrides[arg_8_1] = var_8_0 and var_8_0[arg_8_2]
end

function BackendInterfaceTalentsPlayfab._validate_talents(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = PROFILES_BY_CAREER_NAMES[arg_9_1]

	if not var_9_0 then
		return
	end

	local var_9_1 = var_9_0.display_name
	local var_9_2 = arg_9_0._backend_mirror:get_read_only_data(var_9_1 .. "_experience")
	local var_9_3 = ExperienceSettings.get_level(var_9_2)
	local var_9_4 = PlayerUtils.get_talent_overrides_by_career(arg_9_1)
	local var_9_5 = TalentTrees[var_9_1]
	local var_9_6 = var_9_5 and var_9_5[arg_9_3]
	local var_9_7 = false

	for iter_9_0 = 1, #arg_9_2 do
		local var_9_8 = arg_9_2[iter_9_0]

		if var_9_8 > 0 then
			if not ProgressionUnlocks.is_unlocked("talent_point_" .. iter_9_0, var_9_3) then
				arg_9_2[iter_9_0] = 0
				var_9_7 = true
			elseif var_9_4 and var_9_6 and var_9_4[var_9_6[iter_9_0][var_9_8]] == false then
				arg_9_2[iter_9_0] = 0
				var_9_7 = true
			end
		end
	end

	if var_9_7 and not arg_9_4 then
		arg_9_0:set_talents(arg_9_1, arg_9_2, arg_9_5)
	end
end

function BackendInterfaceTalentsPlayfab.ready(arg_10_0)
	return true
end

function BackendInterfaceTalentsPlayfab.update(arg_11_0, arg_11_1)
	return
end

function BackendInterfaceTalentsPlayfab.make_dirty(arg_12_0)
	arg_12_0._dirty = true
end

function BackendInterfaceTalentsPlayfab.get_talent_ids(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = CareerSettings[arg_13_1]
	local var_13_1 = var_13_0.profile_name
	local var_13_2 = var_13_0.talent_tree_index
	local var_13_3 = var_13_2 and TalentTrees[var_13_1][var_13_2]
	local var_13_4 = {}
	local var_13_5 = Managers.state.game_mode and Managers.state.game_mode:game_mode_key()
	local var_13_6 = InventorySettings.bot_loadout_allowed_game_modes[var_13_5]
	local var_13_7 = InventorySettings.default_loadout_allowed_game_modes[var_13_5]
	local var_13_8 = var_13_6 and arg_13_0:get_bot_talents(arg_13_1)
	local var_13_9 = var_13_7 and arg_13_0:get_default_talents(arg_13_1)
	local var_13_10 = var_13_7 and var_13_9 and var_13_9[1]
	local var_13_11 = arg_13_0:get_talents(arg_13_1)
	local var_13_12 = var_13_6 and arg_13_3 and var_13_8 or arg_13_3 and var_13_7 and var_13_10 or arg_13_2 or var_13_11

	if var_13_12 then
		for iter_13_0 = 1, #var_13_12 do
			local var_13_13 = var_13_12[iter_13_0]

			if var_13_13 ~= 0 then
				local var_13_14 = var_13_3[iter_13_0][var_13_13]
				local var_13_15 = TalentIDLookup[var_13_14]

				if var_13_15 and var_13_15.talent_id then
					var_13_4[#var_13_4 + 1] = var_13_15.talent_id
				end
			end
		end
	end

	return var_13_4
end

function BackendInterfaceTalentsPlayfab.get_talent_tree(arg_14_0, arg_14_1)
	local var_14_0 = CareerSettings[arg_14_1]
	local var_14_1 = var_14_0.profile_name
	local var_14_2 = var_14_0.talent_tree_index

	return var_14_2 and TalentTrees[var_14_1][var_14_2]
end

function BackendInterfaceTalentsPlayfab.set_talents(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = ""

	for iter_15_0 = 1, #arg_15_2 do
		local var_15_1 = arg_15_2[iter_15_0]

		if iter_15_0 == #arg_15_2 then
			var_15_0 = var_15_0 .. var_15_1
		else
			var_15_0 = var_15_0 .. var_15_1 .. ","
		end
	end

	arg_15_0._backend_mirror:set_character_data(arg_15_1, "talents", var_15_0, false, arg_15_3)

	arg_15_0._dirty = true
end

function BackendInterfaceTalentsPlayfab.get_talents(arg_16_0, arg_16_1)
	if arg_16_0._dirty then
		arg_16_0:_refresh()
	end

	local var_16_0 = table.clone(arg_16_0._talents)

	for iter_16_0, iter_16_1 in pairs(arg_16_0._default_talents_overrides) do
		var_16_0[iter_16_0] = iter_16_1
	end

	return var_16_0[arg_16_1]
end

function BackendInterfaceTalentsPlayfab.get_bot_talents(arg_17_0, arg_17_1)
	if arg_17_0._dirty then
		arg_17_0:_refresh()
	end

	return arg_17_0._bot_talents[arg_17_1]
end

function BackendInterfaceTalentsPlayfab.get_default_talents(arg_18_0, arg_18_1)
	if arg_18_0._dirty then
		arg_18_0:_refresh()
	end

	return arg_18_0._default_loadouts_talents[arg_18_1]
end

function BackendInterfaceTalentsPlayfab.get_career_talents(arg_19_0, arg_19_1)
	if arg_19_0._dirty then
		arg_19_0:_refresh()
	end

	return arg_19_0._career_loadouts_talents[arg_19_1]
end

function BackendInterfaceTalentsPlayfab.get_career_talent_ids(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = CareerSettings[arg_20_1]
	local var_20_1 = var_20_0.profile_name
	local var_20_2 = var_20_0.talent_tree_index
	local var_20_3 = var_20_2 and TalentTrees[var_20_1][var_20_2]
	local var_20_4 = {}
	local var_20_5 = arg_20_0:get_career_talents(arg_20_1)[arg_20_2]

	if var_20_5 then
		for iter_20_0 = 1, #var_20_5 do
			local var_20_6 = var_20_5[iter_20_0]

			if var_20_6 ~= 0 then
				local var_20_7 = var_20_3[iter_20_0][var_20_6]
				local var_20_8 = TalentIDLookup[var_20_7]

				if var_20_8 and var_20_8.talent_id then
					var_20_4[#var_20_4 + 1] = var_20_8.talent_id
				end
			end
		end
	end

	return var_20_4
end
