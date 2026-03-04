-- chunkname: @scripts/managers/backend_playfab/backend_interface_weaves_playfab.lua

require("scripts/settings/weaves/weave_loadout/weave_loadout_settings")
require("scripts/settings/equipment/power_level_settings")
require("scripts/helpers/weave_utils")

BackendInterfaceWeavesPlayFab = class(BackendInterfaceWeavesPlayFab)

local var_0_0 = {
	slot_pose = "items",
	slot_hat = "items",
	slot_skin = "items",
	slot_frame = "items",
	slot_melee = "weaves",
	slot_ranged = "weaves"
}

local function var_0_1(arg_1_0)
	local var_1_0 = PowerLevelFromMagicLevel

	return math.min(math.ceil(math.clamp(arg_1_0 * var_1_0.amulet_power_level_per_magic_level, 0, var_1_0.power_level_per_magic_level)), var_1_0.max_power_level)
end

BackendInterfaceWeavesPlayFab.init = function (arg_2_0, arg_2_1)
	arg_2_0._backend_mirror = arg_2_1
	arg_2_0._dirty_loadouts = {}

	local var_2_0 = arg_2_1:get_weaves_progression_settings()

	arg_2_0:_validate_backend_progression_settings(var_2_0)

	arg_2_0._progression_settings = var_2_0
	arg_2_0._forge_level = arg_2_1:get_read_only_data("weaves_forge_level")
	arg_2_0._loadouts = arg_2_0:_parse_loadouts()
	arg_2_0._career_progress = arg_2_0:_parse_career_progress()

	local var_2_1 = arg_2_1:get_all_inventory_items()

	for iter_2_0, iter_2_1 in pairs(var_2_1) do
		if iter_2_1.magic_level then
			iter_2_1.power_level = WeaveUtils.magic_level_to_power_level(iter_2_1.magic_level)
		end
	end

	local var_2_2 = {}

	for iter_2_2, iter_2_3 in pairs(var_0_0) do
		if iter_2_3 == "weaves" then
			var_2_2[iter_2_2] = true
		end
	end

	arg_2_0._valid_loadout_slots = var_2_2

	if not script_data.disable_weave_loadout then
		Managers.backend:add_loadout_interface_override("weave", var_0_0)
	end

	if not script_data.disable_weave_talents then
		Managers.backend:add_talents_interface_override("weave", "weaves")
	end

	Managers.backend:set_total_power_level_interface_for_game_mode("weave", "weaves")

	arg_2_0._last_id = 0
	arg_2_0._player_entry = {}
	arg_2_0._requesting_leaderboard = 0
	arg_2_0._leaderboard_entries = {}
	arg_2_0._leaderboard_player_rank_error = false
	arg_2_0._leaderboard_request_error = false
end

BackendInterfaceWeavesPlayFab._validate_backend_progression_settings = function (arg_3_0, arg_3_1)
	for iter_3_0, iter_3_1 in pairs(WeaveLoadoutSettings) do
		for iter_3_2, iter_3_3 in ipairs(iter_3_1.properties) do
			local var_3_0 = arg_3_1.properties[iter_3_3]

			if not var_3_0 or not var_3_0.mastery_costs or not var_3_0.required_forge_level then
				Application.warning("[BackendInterfaceWeavesPlayFab] Configuration not found or incomplete for property %q in weave_progression_settings", iter_3_3)
			end
		end

		for iter_3_4, iter_3_5 in ipairs(iter_3_1.traits) do
			local var_3_1 = arg_3_1.traits[iter_3_5]

			if not var_3_1 or not var_3_1.mastery_cost or not var_3_1.required_forge_level then
				Application.warning("[BackendInterfaceWeavesPlayFab] Configuration not found or incomplete for trait %q in weave_progression_settings", iter_3_5)
			end
		end

		for iter_3_6, iter_3_7 in ipairs(iter_3_1.talent_tree) do
			for iter_3_8, iter_3_9 in ipairs(iter_3_7) do
				local var_3_2 = arg_3_1.talents[iter_3_9]

				if not var_3_2 or not var_3_2.mastery_cost then
					Application.warning("[BackendInterfaceWeavesPlayFab] Configuration not found or incomplete for talent %q in weave_progression_settings", iter_3_9)
				end
			end
		end
	end

	for iter_3_10, iter_3_11 in pairs(ItemMasterList) do
		local var_3_3 = iter_3_11.rarity
		local var_3_4 = iter_3_11.slot_type

		if var_3_3 and var_3_3 == "magic" and var_3_4 and (var_3_4 == "melee" or var_3_4 == "ranged") and not arg_3_1.items[iter_3_10] then
			Application.warning("[BackendInterfaceWeavesPlayFab] Configuration not found or incomplete for item %q in weave_progression_settings", iter_3_10)
		end
	end
end

BackendInterfaceWeavesPlayFab._parse_loadouts = function (arg_4_0)
	local var_4_0 = {}

	for iter_4_0, iter_4_1 in pairs(CareerSettings) do
		if iter_4_1.playfab_name then
			if not iter_4_1.excluded_from_weave_loadouts then
				local var_4_1 = iter_4_1.is_dlc_unlocked()

				if var_4_1 == nil or var_4_1 then
					local var_4_2 = arg_4_0._backend_mirror:get_read_only_data("weaves_loadout_" .. iter_4_0)
					local var_4_3 = var_4_2 and cjson.decode(var_4_2)

					var_4_0[iter_4_0] = var_4_3

					arg_4_0:_validate_loadout(iter_4_0, var_4_3)
				end
			else
				Application.warning("[BackendInterfaceWeavesPlayFab] Career %q excluded from weaves", iter_4_0)
			end
		end
	end

	for iter_4_2, iter_4_3 in pairs(var_4_0) do
		for iter_4_4, iter_4_5 in pairs(iter_4_3.item_loadouts) do
			arg_4_0:_update_item_custom_data(iter_4_4, iter_4_5)
		end
	end

	return var_4_0
end

BackendInterfaceWeavesPlayFab._validate_loadout = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._dirty_loadouts

	if arg_5_2.properties then
		local var_5_1 = WeavePropertiesByCareer[arg_5_1]

		for iter_5_0, iter_5_1 in pairs(arg_5_2.properties) do
			if not var_5_1[iter_5_0] then
				print("[BackendInterfaceWeavesPlayFab] Loadout property not found in local settings, removing it from the loadout!", arg_5_1, iter_5_0)

				arg_5_2.properties[iter_5_0] = nil
				var_5_0[arg_5_1] = true
			end
		end
	end

	if arg_5_2.traits then
		local var_5_2 = WeaveTraitsByCareer[arg_5_1]

		for iter_5_2, iter_5_3 in pairs(arg_5_2.traits) do
			if not var_5_2[iter_5_2] then
				print("[BackendInterfaceWeavesPlayFab] Loadout trait not found in local settings, removing it from the loadout!", arg_5_1, iter_5_2)

				arg_5_2.traits[iter_5_2] = nil
				var_5_0[arg_5_1] = true
			end
		end
	end

	if arg_5_2.talents then
		local var_5_3 = WeaveTalentsByCareer[arg_5_1]

		for iter_5_4, iter_5_5 in pairs(arg_5_2.talents) do
			if not var_5_3[iter_5_4] then
				print("[BackendInterfaceWeavesPlayFab] Loadout talent not found in local settings, removing it from the loadout!", arg_5_1, iter_5_4)

				arg_5_2.talents[iter_5_4] = nil
				var_5_0[arg_5_1] = true
			end
		end
	end

	if arg_5_2.item_loadouts then
		local var_5_4 = arg_5_0._backend_mirror:get_all_inventory_items()

		for iter_5_6, iter_5_7 in pairs(arg_5_2.item_loadouts) do
			local var_5_5 = var_5_4[iter_5_6]

			if not var_5_5 or var_5_5.rarity ~= "magic" then
				print("[BackendInterfaceWeavesPlayFab] Loadout weapon not found in local settings, removing it from the loadout!", arg_5_1, iter_5_6)

				arg_5_2.item_loadouts[iter_5_6] = nil
			else
				arg_5_0:_validate_loadout(arg_5_1, iter_5_7)
			end
		end
	end
end

BackendInterfaceWeavesPlayFab._parse_career_progress = function (arg_6_0)
	local var_6_0 = arg_6_0._backend_mirror:get_read_only_data("weaves_career_progress")

	return (cjson.decode(var_6_0))
end

BackendInterfaceWeavesPlayFab._new_id = function (arg_7_0)
	arg_7_0._last_id = arg_7_0._last_id and arg_7_0._last_id + 1 or 1

	return arg_7_0._last_id
end

BackendInterfaceWeavesPlayFab._create_leaderboard_entry = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if not arg_8_1 then
		return {
			score = "-",
			name = "-",
			weave = "-",
			ranking = "-",
			local_player = false
		}
	end

	local var_8_0 = arg_8_1.Position + 1
	local var_8_1 = arg_8_1.Profile
	local var_8_2 = var_8_1.LinkedAccounts
	local var_8_3
	local var_8_4
	local var_8_5

	for iter_8_0 = 1, #var_8_2 do
		local var_8_6 = var_8_2[iter_8_0]

		if var_8_6.Platform == "Steam" then
			var_8_3 = var_8_6.Username
			var_8_5 = var_8_6.PlatformUserId
		elseif var_8_6.Platform == "XBoxLive" then
			var_8_3 = var_8_6.Username
			var_8_5 = var_8_6.PlatformUserId
		elseif var_8_6.Platform == "PSN" then
			var_8_3 = var_8_6.Username
			var_8_5 = var_8_6.PlatformUserId
		end
	end

	local var_8_7, var_8_8, var_8_9 = BackendUtils.convert_weave_score(arg_8_1.StatValue)
	local var_8_10 = var_8_1.PlayerId == arg_8_0._backend_mirror:get_playfab_id()

	if var_8_8 == arg_8_3 and var_8_7 == arg_8_2 then
		var_8_4 = ""
	end

	return {
		name = var_8_3,
		career_name = var_8_9,
		ranking = var_8_4 or var_8_0,
		real_ranking = var_8_0,
		weave = var_8_7,
		score = var_8_8,
		local_player = var_8_10,
		platform_user_id = var_8_5
	}
end

BackendInterfaceWeavesPlayFab._get_magic_inventory_item = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._backend_mirror:get_all_inventory_items()[arg_9_1]

	fassert(var_9_0, "[BackendInterfaceWeavesPlayFab] Item %q doesn't exist", tostring(arg_9_1))
	fassert(var_9_0.rarity == "magic", "[BackendInterfaceWeavesPlayFab] Item %q is not magic", tostring(arg_9_1))

	return var_9_0
end

BackendInterfaceWeavesPlayFab._update_item_custom_data = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0:_get_magic_inventory_item(arg_10_1)
	local var_10_1 = arg_10_0._progression_settings

	if arg_10_2.properties then
		if var_10_0.properties then
			table.clear(var_10_0.properties)
		else
			var_10_0.properties = {}
		end

		for iter_10_0, iter_10_1 in pairs(arg_10_2.properties) do
			local var_10_2 = #iter_10_1 / #arg_10_0:get_property_mastery_costs(iter_10_0)

			var_10_0.properties[iter_10_0] = var_10_2
		end
	else
		var_10_0.properties = nil
	end

	if arg_10_2.traits then
		if var_10_0.traits then
			table.clear(var_10_0.traits)
		else
			var_10_0.traits = {}
		end

		for iter_10_2, iter_10_3 in pairs(arg_10_2.traits) do
			var_10_0.traits[#var_10_0.traits + 1] = iter_10_2
		end
	else
		var_10_0.traits = nil
	end
end

BackendInterfaceWeavesPlayFab._get_loadout_mastery_cost = function (arg_11_0, arg_11_1)
	local var_11_0 = 0
	local var_11_1 = arg_11_0._progression_settings

	if arg_11_1.properties then
		for iter_11_0, iter_11_1 in pairs(arg_11_1.properties) do
			local var_11_2 = arg_11_0:get_property_mastery_costs(iter_11_0)

			for iter_11_2 = 1, #iter_11_1 do
				var_11_0 = var_11_0 + var_11_2[iter_11_2]
			end
		end
	end

	if arg_11_1.traits then
		for iter_11_3, iter_11_4 in pairs(arg_11_1.traits) do
			var_11_0 = var_11_0 + arg_11_0:get_trait_mastery_cost(iter_11_3)
		end
	end

	if arg_11_1.talents then
		for iter_11_5, iter_11_6 in pairs(arg_11_1.talents) do
			var_11_0 = var_11_0 + arg_11_0:get_talent_mastery_cost(iter_11_5)
		end
	end

	return var_11_0
end

BackendInterfaceWeavesPlayFab.ready = function (arg_12_0)
	return true
end

BackendInterfaceWeavesPlayFab.submit_scores = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = Managers.player:human_players()
	local var_13_1 = {}

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		local var_13_2 = iter_13_1:platform_id()

		if not IS_XB1 then
			var_13_2 = Application.hex64_to_dec(var_13_2)
		end

		local var_13_3 = iter_13_1:career_name()

		var_13_1[var_13_2] = BackendUtils.calculate_weave_score(arg_13_1, arg_13_2, var_13_3)
	end

	local var_13_4 = {
		FunctionName = "submitWeaveScore",
		FunctionParameter = {
			scores_by_platform_id = var_13_1,
			num_players = arg_13_3
		}
	}
	local var_13_5 = callback(arg_13_0, "submit_weave_score_request_cb")

	arg_13_0._backend_mirror:request_queue():enqueue(var_13_4, var_13_5, true)
end

BackendInterfaceWeavesPlayFab.submit_weave_score_request_cb = function (arg_14_0)
	return
end

BackendInterfaceWeavesPlayFab.request_player_rank = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = {
		MaxResultsCount = 1,
		StatisticName = arg_15_1,
		ProfileConstraints = {
			ShowLinkedAccounts = true
		}
	}

	if IS_XB1 then
		var_15_0.XboxToken = Managers.account:get_xsts_token()
	end

	local var_15_1 = callback(arg_15_0, "player_rank_request_cb")
	local var_15_2 = callback(arg_15_0, "player_rank_request_failed_cb", arg_15_3)
	local var_15_3 = arg_15_0._backend_mirror:request_queue()
	local var_15_4 = arg_15_2 == "friends" and "GetFriendLeaderboardAroundPlayer" or "GetLeaderboardAroundPlayer"

	var_15_3:enqueue_api_request(var_15_4, var_15_0, var_15_1, var_15_2)

	arg_15_0._requesting_leaderboard = arg_15_0._requesting_leaderboard + 1
end

BackendInterfaceWeavesPlayFab.player_rank_request_cb = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1.Leaderboard[1]

	if (var_16_0 and var_16_0.StatValue) == 0 then
		var_16_0 = nil
	end

	arg_16_0._player_entry, arg_16_0._requesting_leaderboard = arg_16_0:_create_leaderboard_entry(var_16_0), arg_16_0._requesting_leaderboard - 1
	arg_16_0._leaderboard_player_rank_error = false
end

BackendInterfaceWeavesPlayFab.request_leaderboard_around_player = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	local var_17_0 = {
		MaxResultsCount = arg_17_3 or 1,
		StatisticName = arg_17_1,
		ProfileConstraints = {
			ShowLinkedAccounts = true
		}
	}

	if IS_XB1 then
		var_17_0.XboxToken = Managers.account:get_xsts_token()
	end

	local var_17_1 = callback(arg_17_0, "request_leaderboard_around_player_cb")
	local var_17_2 = callback(arg_17_0, "request_leaderboard_failed_cb", arg_17_4)
	local var_17_3 = arg_17_0._backend_mirror:request_queue()
	local var_17_4 = arg_17_2 == "friends" and "GetFriendLeaderboardAroundPlayer" or "GetLeaderboardAroundPlayer"

	var_17_3:enqueue_api_request(var_17_4, var_17_0, var_17_1, var_17_2)

	arg_17_0._requesting_leaderboard = arg_17_0._requesting_leaderboard + 1
	arg_17_0._leaderboard_request_error = false
end

BackendInterfaceWeavesPlayFab.request_leaderboard_around_player_cb = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.Leaderboard

	table.clear(arg_18_0._leaderboard_entries)

	local var_18_1 = 1

	for iter_18_0 = 1, #var_18_0 do
		local var_18_2 = var_18_0[iter_18_0]
		local var_18_3

		if var_18_2.StatValue ~= 0 then
			local var_18_4 = var_18_1 > 1 and arg_18_0._leaderboard_entries[var_18_1 - 1].score
			local var_18_5 = var_18_1 > 1 and arg_18_0._leaderboard_entries[var_18_1 - 1].weave
			local var_18_6 = arg_18_0:_create_leaderboard_entry(var_18_2, var_18_5, var_18_4)

			arg_18_0._leaderboard_entries[var_18_1] = var_18_6
			var_18_1 = var_18_1 + 1
		end

		if var_18_2.Profile.PlayerId == arg_18_0._backend_mirror:get_playfab_id() then
			arg_18_0._player_entry = var_18_3
		end
	end

	arg_18_0._requesting_leaderboard = arg_18_0._requesting_leaderboard - 1
end

BackendInterfaceWeavesPlayFab.get_player_entry = function (arg_19_0)
	return arg_19_0._player_entry
end

BackendInterfaceWeavesPlayFab.request_leaderboard = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	local var_20_0 = {
		MaxResultsCount = 100,
		StatisticName = arg_20_1,
		ProfileConstraints = {
			ShowLinkedAccounts = true
		},
		StartPosition = arg_20_2
	}

	if IS_XB1 then
		var_20_0.XboxToken = Managers.account:get_xsts_token()
	end

	local var_20_1 = callback(arg_20_0, "leaderboard_request_cb")
	local var_20_2 = callback(arg_20_0, "request_leaderboard_failed_cb", arg_20_4)
	local var_20_3 = arg_20_0._backend_mirror:request_queue()
	local var_20_4 = arg_20_3 == "friends" and "GetFriendLeaderboard" or "GetLeaderboard"

	var_20_3:enqueue_api_request(var_20_4, var_20_0, var_20_1, var_20_2)

	arg_20_0._requesting_leaderboard = arg_20_0._requesting_leaderboard + 1
end

BackendInterfaceWeavesPlayFab.leaderboard_request_cb = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1.Leaderboard

	table.clear(arg_21_0._leaderboard_entries)

	for iter_21_0 = 1, #var_21_0 do
		local var_21_1 = var_21_0[iter_21_0]
		local var_21_2 = iter_21_0 > 1 and arg_21_0._leaderboard_entries[iter_21_0 - 1].score
		local var_21_3 = iter_21_0 > 1 and arg_21_0._leaderboard_entries[iter_21_0 - 1].weave
		local var_21_4 = arg_21_0:_create_leaderboard_entry(var_21_1, var_21_3, var_21_2)

		arg_21_0._leaderboard_entries[iter_21_0] = var_21_4
	end

	arg_21_0._requesting_leaderboard = arg_21_0._requesting_leaderboard - 1
	arg_21_0._leaderboard_request_error = false
end

BackendInterfaceWeavesPlayFab.is_requesting_leaderboard = function (arg_22_0)
	return arg_22_0._requesting_leaderboard > 0
end

BackendInterfaceWeavesPlayFab.get_leaderboard_entries = function (arg_23_0)
	return arg_23_0._leaderboard_entries
end

BackendInterfaceWeavesPlayFab.has_leaderboard_request_failed = function (arg_24_0)
	return arg_24_0._leaderboard_player_rank_error or arg_24_0._leaderboard_request_error
end

BackendInterfaceWeavesPlayFab.player_rank_request_failed_cb = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	arg_25_0._requesting_leaderboard = arg_25_0._requesting_leaderboard - 1
	arg_25_0._leaderboard_player_rank_error = true
	arg_25_0._player_entry = arg_25_0:_create_leaderboard_entry(nil)

	if arg_25_1 then
		arg_25_1(arg_25_2)
	end

	arg_25_3()
end

BackendInterfaceWeavesPlayFab.request_leaderboard_failed_cb = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	arg_26_0._requesting_leaderboard = arg_26_0._requesting_leaderboard - 1
	arg_26_0._leaderboard_request_error = true

	table.clear(arg_26_0._leaderboard_entries)

	if arg_26_1 then
		arg_26_1(arg_26_2)
	end

	arg_26_3()
end

BackendInterfaceWeavesPlayFab.get_mastery = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = WeaveMasterySettings
	local var_27_1 = arg_27_0._loadouts[arg_27_1]
	local var_27_2

	if arg_27_2 then
		var_27_1 = var_27_1.item_loadouts[arg_27_2]

		local var_27_3 = arg_27_0:get_item_magic_level(arg_27_2)

		var_27_2 = (var_27_3 - 1) * var_27_0.item_mastery_per_magic_level

		if var_27_3 >= arg_27_0:max_magic_level() then
			var_27_2 = var_27_3 * var_27_0.item_mastery_per_magic_level
		end
	else
		local var_27_4 = arg_27_0:get_career_magic_level(arg_27_1)

		var_27_2 = (var_27_4 - 1) * var_27_0.career_mastery_per_magic_level

		if var_27_4 >= arg_27_0:max_magic_level() then
			var_27_2 = var_27_4 * var_27_0.career_mastery_per_magic_level
		end
	end

	local var_27_5 = var_27_2 - (var_27_1 and arg_27_0:_get_loadout_mastery_cost(var_27_1) or 0)

	return var_27_2, var_27_5
end

BackendInterfaceWeavesPlayFab.get_essence = function (arg_28_0)
	return arg_28_0._backend_mirror:get_essence()
end

BackendInterfaceWeavesPlayFab.get_total_essence = function (arg_29_0)
	return arg_29_0._backend_mirror:get_total_essence()
end

BackendInterfaceWeavesPlayFab.get_maximum_essence = function (arg_30_0)
	return arg_30_0._backend_mirror:get_maximum_essence()
end

BackendInterfaceWeavesPlayFab.get_average_power_level = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._loadouts[arg_31_1]
	local var_31_1 = arg_31_0:_get_magic_inventory_item(var_31_0.slot_melee).power_level + arg_31_0:_get_magic_inventory_item(var_31_0.slot_ranged).power_level
	local var_31_2 = arg_31_0:get_career_power_level(arg_31_1)
	local var_31_3 = math.ceil(var_31_1 * 0.5)

	if var_31_2 then
		var_31_3 = var_31_3 + var_31_2
	end

	return var_31_3
end

BackendInterfaceWeavesPlayFab.get_total_magic_level = function (arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0:get_career_magic_level(arg_32_1)
	local var_32_1 = arg_32_0._loadouts[arg_32_1]

	return var_32_0 + arg_32_0:get_item_magic_level(var_32_1.slot_melee) + arg_32_0:get_item_magic_level(var_32_1.slot_ranged)
end

BackendInterfaceWeavesPlayFab.max_magic_level = function (arg_33_0)
	return #arg_33_0._progression_settings.magic_levels
end

BackendInterfaceWeavesPlayFab.get_career_power_level = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0:get_career_magic_level(arg_34_1)
	local var_34_1 = var_0_1(var_34_0)

	if var_34_1 == 0 then
		return nil
	end

	return var_34_1
end

BackendInterfaceWeavesPlayFab.get_career_magic_level = function (arg_35_0, arg_35_1)
	return arg_35_0._career_progress[arg_35_1].magic_level
end

BackendInterfaceWeavesPlayFab.career_upgrade_cost = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0:get_career_magic_level(arg_36_2)
	local var_36_1 = math.clamp(var_36_0 + arg_36_1, 1, arg_36_0:max_magic_level())

	if var_36_1 == var_36_0 then
		return nil, nil
	end

	local var_36_2 = 0

	for iter_36_0 = var_36_0 + 1, var_36_1 do
		var_36_2 = var_36_2 + arg_36_0._progression_settings.magic_levels[iter_36_0].essence_cost
	end

	return var_36_2, var_36_1
end

BackendInterfaceWeavesPlayFab.upgrade_career_magic_level = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0, var_37_1 = arg_37_0:career_upgrade_cost(arg_37_1, arg_37_2)

	if not var_37_0 then
		arg_37_3(false)

		return
	end

	local var_37_2 = {
		FunctionName = "upgradeCareerMagicLevel",
		FunctionParameter = {
			career_name = arg_37_2,
			new_magic_level = var_37_1,
			cost = var_37_0
		}
	}

	arg_37_0._backend_mirror:request_queue():enqueue(var_37_2, callback(arg_37_0, "upgrade_career_magic_level_cb", arg_37_3), true)
end

local var_0_2 = {
	"dr_ranger",
	"dr_slayer",
	"dr_ironbreaker",
	"dr_engineer",
	"we_waywatcher",
	"we_shade",
	"we_maidenguard",
	"es_huntsman",
	"es_mercenary",
	"es_knight",
	"es_questingknight",
	"bw_adept",
	"bw_scholar",
	"bw_unchained",
	"wh_captain",
	"wh_bountyhunter",
	"wh_zealot",
	"we_thornsister",
	"wh_priest",
	"bw_necromancer"
}

BackendInterfaceWeavesPlayFab.upgrade_career_magic_level_cb = function (arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_2.FunctionResult
	local var_38_1 = var_38_0.error_message

	if var_38_1 then
		print("[BackendInterfaceQuestsPlayfab] Error from backend when upgrading career magic level: ", tostring(var_38_1))

		if arg_38_1 then
			arg_38_1(false)
		end

		return
	end

	local var_38_2 = var_38_0.career_name
	local var_38_3 = var_38_0.new_magic_level
	local var_38_4 = var_38_0.new_essence

	if var_38_0.upgrade_all_career_magic_levels then
		for iter_38_0 = 1, #var_0_2 do
			local var_38_5 = var_0_2[iter_38_0]
			local var_38_6 = arg_38_0._career_progress[var_38_5]

			if var_38_6 then
				var_38_6.magic_level = var_38_3
			end
		end
	else
		local var_38_7 = arg_38_0._career_progress[var_38_2]

		if var_38_7 then
			var_38_7.magic_level = var_38_3
		end
	end

	arg_38_0._backend_mirror:set_essence(var_38_4)

	if arg_38_1 then
		arg_38_1(true)
	end
end

BackendInterfaceWeavesPlayFab.get_item_magic_level = function (arg_39_0, arg_39_1)
	return arg_39_0:_get_magic_inventory_item(arg_39_1).magic_level
end

BackendInterfaceWeavesPlayFab.get_item_power_level = function (arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0:get_item_magic_level(arg_40_1)

	return (WeaveUtils.magic_level_to_power_level(var_40_0))
end

BackendInterfaceWeavesPlayFab.magic_item_upgrade_cost = function (arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_0:get_item_magic_level(arg_41_2)
	local var_41_1 = math.clamp(var_41_0 + arg_41_1, 1, arg_41_0:max_magic_level())

	if var_41_1 == var_41_0 then
		return nil, nil
	end

	local var_41_2 = 0

	for iter_41_0 = var_41_0 + 1, var_41_1 do
		var_41_2 = var_41_2 + arg_41_0._progression_settings.magic_levels[iter_41_0].essence_cost
	end

	return var_41_2, var_41_1
end

BackendInterfaceWeavesPlayFab.upgrade_item_magic_level = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0, var_42_1 = arg_42_0:magic_item_upgrade_cost(arg_42_1, arg_42_2)

	if not var_42_0 then
		arg_42_3(false)

		return
	end

	local var_42_2 = {
		FunctionName = "upgradeItemMagicLevel",
		FunctionParameter = {
			item_backend_id = arg_42_2,
			new_magic_level = var_42_1,
			cost = var_42_0
		}
	}

	arg_42_0._backend_mirror:request_queue():enqueue(var_42_2, callback(arg_42_0, "upgrade_item_magic_level_cb", arg_42_3), true)
end

BackendInterfaceWeavesPlayFab.upgrade_item_magic_level_cb = function (arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_2.FunctionResult
	local var_43_1 = var_43_0.error_message

	if var_43_1 then
		print("[BackendInterfaceQuestsPlayfab] Error from backend when upgrading item magic level: ", tostring(var_43_1))

		if arg_43_1 then
			arg_43_1(false)
		end

		return
	end

	local var_43_2 = var_43_0.item_id
	local var_43_3 = var_43_0.essence_cost
	local var_43_4 = var_43_0.item_backend_id
	local var_43_5 = var_43_0.new_magic_level
	local var_43_6 = var_43_0.new_essence

	Managers.telemetry_events:magic_item_level_upgraded(var_43_2, var_43_3, var_43_5)

	local var_43_7 = arg_43_0._backend_mirror

	var_43_7:update_item_field(var_43_4, "magic_level", var_43_5)

	local var_43_8 = WeaveUtils.magic_level_to_power_level(var_43_5)

	var_43_7:update_item_field(var_43_4, "power_level", var_43_8)
	var_43_7:set_essence(var_43_6)

	if arg_43_1 then
		arg_43_1(true)
	end
end

BackendInterfaceWeavesPlayFab.magic_item_cost = function (arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0._progression_settings.items[arg_44_1]

	return var_44_0 and var_44_0.essence_cost
end

BackendInterfaceWeavesPlayFab.buy_magic_item = function (arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0:magic_item_cost(arg_45_1)

	if not var_45_0 then
		arg_45_2(false)

		return
	end

	local var_45_1 = {
		FunctionName = "buyMagicItem",
		FunctionParameter = {
			item_id = arg_45_1,
			cost = var_45_0
		}
	}

	arg_45_0._backend_mirror:request_queue():enqueue(var_45_1, callback(arg_45_0, "buy_magic_item_cb", arg_45_2), true)
end

BackendInterfaceWeavesPlayFab.buy_magic_item_cb = function (arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_2.FunctionResult
	local var_46_1 = var_46_0.error_message

	if var_46_1 then
		print("[BackendInterfaceQuestsPlayfab] Error from backend when buying magic item: ", tostring(var_46_1))

		if arg_46_1 then
			arg_46_1(false)
		end

		return
	end

	local var_46_2 = var_46_0.item_grant_results
	local var_46_3 = var_46_0.new_essence
	local var_46_4 = var_46_0.new_weapon_skins
	local var_46_5 = arg_46_0._backend_mirror

	for iter_46_0 = 1, #var_46_2 do
		local var_46_6 = var_46_2[iter_46_0]
		local var_46_7 = var_46_6.ItemInstanceId

		var_46_5:add_item(var_46_7, var_46_6)

		var_46_6.power_level = WeaveUtils.magic_level_to_power_level(var_46_6.CustomData.magic_level)
	end

	var_46_5:set_essence(var_46_3)

	if var_46_4 then
		for iter_46_1 = 1, #var_46_4 do
			local var_46_8 = var_46_4[iter_46_1]

			var_46_5:add_unlocked_weapon_skin(var_46_8)
		end
	end

	if arg_46_1 then
		arg_46_1(true)
	end
end

BackendInterfaceWeavesPlayFab.get_forge_level = function (arg_47_0)
	return arg_47_0._forge_level
end

BackendInterfaceWeavesPlayFab.forge_max_level = function (arg_48_0)
	return #arg_48_0._progression_settings.forge_levels
end

BackendInterfaceWeavesPlayFab.forge_magic_level_cap = function (arg_49_0)
	local var_49_0 = arg_49_0._forge_level

	return arg_49_0._progression_settings.forge_levels[var_49_0].magic_level_cap
end

BackendInterfaceWeavesPlayFab.forge_upgrade_cost = function (arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0._forge_level
	local var_50_1 = math.clamp(var_50_0 + arg_50_1, 1, arg_50_0:forge_max_level())

	if var_50_1 == var_50_0 then
		return nil, nil
	end

	local var_50_2 = 0

	for iter_50_0 = var_50_0 + 1, var_50_1 do
		var_50_2 = var_50_2 + arg_50_0._progression_settings.forge_levels[iter_50_0].essence_cost
	end

	return var_50_2, var_50_1
end

BackendInterfaceWeavesPlayFab.upgrade_forge = function (arg_51_0, arg_51_1, arg_51_2)
	local var_51_0, var_51_1 = arg_51_0:forge_upgrade_cost(arg_51_1)

	if not var_51_0 then
		arg_51_2(false)

		return
	end

	local var_51_2 = {
		FunctionName = "upgradeWeaveForge",
		FunctionParameter = {
			new_forge_level = var_51_1,
			cost = var_51_0
		}
	}

	arg_51_0._backend_mirror:request_queue():enqueue(var_51_2, callback(arg_51_0, "upgrade_forge_cb", arg_51_2), true)
end

BackendInterfaceWeavesPlayFab.upgrade_forge_cb = function (arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_2.FunctionResult
	local var_52_1 = var_52_0.error_message

	if var_52_1 then
		print("[BackendInterfaceQuestsPlayfab] Error from backend when upgrading the forge: ", tostring(var_52_1))

		if arg_52_1 then
			arg_52_1(false)
		end

		return
	end

	local var_52_2

	arg_52_0._forge_level, var_52_2 = var_52_0.new_forge_level, var_52_0.new_essence

	arg_52_0._backend_mirror:set_essence(var_52_2)

	if arg_52_1 then
		arg_52_1(true)
	end
end

BackendInterfaceWeavesPlayFab.get_property_mastery_costs = function (arg_53_0, arg_53_1)
	return arg_53_0._progression_settings.properties[arg_53_1].mastery_costs
end

BackendInterfaceWeavesPlayFab.get_property_required_forge_level = function (arg_54_0, arg_54_1)
	return arg_54_0._progression_settings.properties[arg_54_1].required_forge_level
end

BackendInterfaceWeavesPlayFab.set_loadout_property = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	local var_55_0 = WeavePropertiesByCareer[arg_55_1][arg_55_2]

	fassert(var_55_0, "[BackendInterfaceWeavesPlayFab] Property %q not found for %q", arg_55_2, arg_55_1)

	local var_55_1 = arg_55_0._loadouts[arg_55_1]

	if arg_55_4 then
		local var_55_2 = var_55_1.item_loadouts[arg_55_4]

		if not var_55_2 then
			var_55_2 = {
				properties = {},
				traits = {}
			}
			var_55_1.item_loadouts[arg_55_4] = var_55_2
		end

		var_55_1 = var_55_2
	end

	local var_55_3 = var_55_1.properties[arg_55_2]

	if not var_55_3 then
		var_55_3 = {}
		var_55_1.properties[arg_55_2] = var_55_3
	end

	for iter_55_0, iter_55_1 in pairs(var_55_1.properties) do
		if table.contains(iter_55_1, arg_55_3) then
			return
		end
	end

	local var_55_4 = arg_55_0:get_property_mastery_costs(arg_55_2)

	if #var_55_3 == #var_55_4 then
		return
	end

	var_55_3[#var_55_3 + 1] = arg_55_3

	if arg_55_4 then
		arg_55_0:_update_item_custom_data(arg_55_4, var_55_1)
	end

	arg_55_0._dirty_loadouts[arg_55_1] = true
end

BackendInterfaceWeavesPlayFab.remove_loadout_property = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	local var_56_0 = arg_56_0._loadouts[arg_56_1]

	if arg_56_4 then
		var_56_0 = var_56_0.item_loadouts[arg_56_4]
	end

	local var_56_1 = var_56_0.properties[arg_56_2]
	local var_56_2 = table.find(var_56_1, arg_56_3)

	table.remove(var_56_1, var_56_2)

	if #var_56_1 == 0 then
		var_56_0.properties[arg_56_2] = nil
	end

	if arg_56_4 then
		arg_56_0:_update_item_custom_data(arg_56_4, var_56_0)
	end

	arg_56_0._dirty_loadouts[arg_56_1] = true
end

BackendInterfaceWeavesPlayFab.get_loadout_properties = function (arg_57_0, arg_57_1, arg_57_2)
	local var_57_0 = arg_57_0._loadouts[arg_57_1]
	local var_57_1

	if arg_57_2 then
		local var_57_2 = var_57_0.item_loadouts[arg_57_2]

		var_57_1 = var_57_2 and var_57_2.properties or {}
	else
		var_57_1 = var_57_0.properties
	end

	return var_57_1
end

BackendInterfaceWeavesPlayFab.get_trait_mastery_cost = function (arg_58_0, arg_58_1)
	return arg_58_0._progression_settings.traits[arg_58_1].mastery_cost
end

BackendInterfaceWeavesPlayFab.get_trait_required_forge_level = function (arg_59_0, arg_59_1)
	return arg_59_0._progression_settings.traits[arg_59_1].required_forge_level
end

BackendInterfaceWeavesPlayFab.set_loadout_trait = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4)
	local var_60_0 = WeaveTraitsByCareer[arg_60_1][arg_60_2]

	fassert(var_60_0, "[BackendInterfaceWeavesPlayFab] Trait %q not allowed for %q", arg_60_2, arg_60_1)

	local var_60_1 = arg_60_0._loadouts[arg_60_1]

	if arg_60_4 then
		local var_60_2 = var_60_1.item_loadouts[arg_60_4]

		if not var_60_2 then
			var_60_2 = {
				properties = {},
				traits = {}
			}
			var_60_1.item_loadouts[arg_60_4] = var_60_2
		end

		var_60_1 = var_60_2
	end

	if var_60_1.traits[arg_60_2] then
		return
	end

	for iter_60_0, iter_60_1 in pairs(var_60_1.traits) do
		if iter_60_1 == arg_60_3 then
			return
		end
	end

	var_60_1.traits[arg_60_2] = arg_60_3

	if arg_60_4 then
		arg_60_0:_update_item_custom_data(arg_60_4, var_60_1)
	end

	arg_60_0._dirty_loadouts[arg_60_1] = true
end

BackendInterfaceWeavesPlayFab.remove_loadout_trait = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	local var_61_0 = arg_61_0._loadouts[arg_61_1]

	if arg_61_3 then
		var_61_0 = var_61_0.item_loadouts[arg_61_3]
	end

	var_61_0.traits[arg_61_2] = nil

	if arg_61_3 then
		arg_61_0:_update_item_custom_data(arg_61_3, var_61_0)
	end

	arg_61_0._dirty_loadouts[arg_61_1] = true
end

BackendInterfaceWeavesPlayFab.get_loadout_traits = function (arg_62_0, arg_62_1, arg_62_2)
	local var_62_0 = arg_62_0._loadouts[arg_62_1]
	local var_62_1

	if arg_62_2 then
		local var_62_2 = var_62_0.item_loadouts[arg_62_2]

		var_62_1 = var_62_2 and var_62_2.traits or {}
	else
		var_62_1 = var_62_0.traits
	end

	return var_62_1
end

BackendInterfaceWeavesPlayFab.apply_career_item_loadouts = function (arg_63_0, arg_63_1)
	if arg_63_1 then
		local var_63_0 = arg_63_0._loadouts[arg_63_1]
		local var_63_1 = var_63_0 and var_63_0.item_loadouts

		if var_63_1 then
			local var_63_2 = var_63_0.slot_melee

			if var_63_2 then
				local var_63_3 = var_63_1[var_63_2] or {}

				arg_63_0:_update_item_custom_data(var_63_2, var_63_3)
			end

			local var_63_4 = var_63_0.slot_ranged

			if var_63_4 then
				local var_63_5 = var_63_1[var_63_4] or {}

				arg_63_0:_update_item_custom_data(var_63_4, var_63_5)
			end
		end
	end
end

BackendInterfaceWeavesPlayFab.get_talent_mastery_cost = function (arg_64_0, arg_64_1)
	return arg_64_0._progression_settings.talents[arg_64_1].mastery_cost
end

BackendInterfaceWeavesPlayFab.get_talent_required_forge_level = function (arg_65_0, arg_65_1)
	return arg_65_0._progression_settings.talents[arg_65_1].required_forge_level
end

BackendInterfaceWeavesPlayFab.set_loadout_talent = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	local var_66_0 = WeaveTalentsByCareer[arg_66_1][arg_66_2]

	fassert(var_66_0, "[BackendInterfaceWeavesPlayFab] Talent %q not allowed for %q", arg_66_2, arg_66_1)

	local var_66_1 = var_66_0.tree_row
	local var_66_2 = arg_66_0._loadouts[arg_66_1].talents

	if var_66_2[arg_66_2] then
		return
	end

	for iter_66_0, iter_66_1 in pairs(var_66_2) do
		if iter_66_1 == arg_66_3 then
			return
		end

		if var_66_1 == WeaveTalentsByCareer[arg_66_1][iter_66_0].tree_row then
			return
		end
	end

	var_66_2[arg_66_2] = arg_66_3
	arg_66_0._dirty_loadouts[arg_66_1] = true
end

BackendInterfaceWeavesPlayFab.remove_loadout_talent = function (arg_67_0, arg_67_1, arg_67_2)
	local var_67_0 = arg_67_0._loadouts[arg_67_1].talents

	fassert(var_67_0[arg_67_2], "[BackendInterfaceWeavesPlayFab] Talent %q not found in loadout for %q", arg_67_2, arg_67_1)

	var_67_0[arg_67_2] = nil
	arg_67_0._dirty_loadouts[arg_67_1] = true
end

BackendInterfaceWeavesPlayFab.get_loadout_talents = function (arg_68_0, arg_68_1)
	return arg_68_0._loadouts[arg_68_1].talents
end

BackendInterfaceWeavesPlayFab.get_talent_ids = function (arg_69_0, arg_69_1)
	local var_69_0 = arg_69_0:get_talent_tree(arg_69_1)
	local var_69_1 = {}
	local var_69_2 = arg_69_0:get_talents(arg_69_1)

	if var_69_2 then
		for iter_69_0 = 1, #var_69_2 do
			local var_69_3 = var_69_2[iter_69_0]

			if var_69_3 ~= 0 then
				local var_69_4 = var_69_0[iter_69_0][var_69_3]
				local var_69_5 = TalentIDLookup[var_69_4]

				if var_69_5 and var_69_5.talent_id then
					var_69_1[#var_69_1 + 1] = var_69_5.talent_id
				end
			end
		end
	end

	return var_69_1
end

BackendInterfaceWeavesPlayFab.get_talent_tree = function (arg_70_0, arg_70_1)
	local var_70_0 = WeaveLoadoutSettings[arg_70_1]

	return var_70_0 and var_70_0.talent_tree
end

local var_0_3 = {}

BackendInterfaceWeavesPlayFab.get_talents = function (arg_71_0, arg_71_1)
	local var_71_0 = arg_71_0._loadouts[arg_71_1].talents
	local var_71_1 = arg_71_0:get_talent_tree(arg_71_1)

	table.clear(var_0_3)

	for iter_71_0 = 1, #var_71_1 do
		var_0_3[iter_71_0] = 0
	end

	for iter_71_1, iter_71_2 in pairs(var_71_0) do
		local var_71_2 = WeaveTalentsByCareer[arg_71_1][iter_71_1]
		local var_71_3 = var_71_2.tree_row
		local var_71_4 = var_71_2.tree_column

		var_0_3[var_71_3] = var_71_4
	end

	return var_0_3
end

BackendInterfaceWeavesPlayFab.get_total_power_level = function (arg_72_0, arg_72_1, arg_72_2)
	return arg_72_0:get_average_power_level(arg_72_2)
end

BackendInterfaceWeavesPlayFab.has_loadout_item_id = function (arg_73_0, arg_73_1, arg_73_2)
	local var_73_0 = arg_73_0._loadouts[arg_73_1]

	for iter_73_0, iter_73_1 in pairs(var_73_0) do
		if iter_73_1 == arg_73_2 then
			return true
		end
	end
end

BackendInterfaceWeavesPlayFab.get_loadout_item_id = function (arg_74_0, arg_74_1, arg_74_2)
	fassert(arg_74_0._valid_loadout_slots[arg_74_2], "[BackendInterfaceWeavesPlayFab] Loadout in slot %q shouldn't be fetched from the weaves interface", tostring(arg_74_2))

	return arg_74_0._loadouts[arg_74_1][arg_74_2]
end

BackendInterfaceWeavesPlayFab.set_loadout_item = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3)
	fassert(arg_75_0._valid_loadout_slots[arg_75_3], "[BackendInterfaceWeavesPlayFab] Loadout in slot %q shouldn't be set in the weaves interface", tostring(arg_75_3))

	local var_75_0 = arg_75_0._backend_mirror:get_all_inventory_items()
	local var_75_1

	if arg_75_1 then
		var_75_1 = var_75_0[arg_75_1]

		fassert(var_75_1, "[BackendInterfaceWeavesPlayFab] Item %q doesn't exist", tostring(arg_75_1))
	end

	if not var_75_1 then
		print("[BackendInterfaceWeavesPlayFab] Attempted to equip weapon that doesn't exist:", arg_75_1, arg_75_2, arg_75_3)

		return false
	end

	if var_75_1.rarity ~= "magic" then
		print("[BackendInterfaceWeavesPlayFab] Attempted to equip non magic weapon in weaves:", arg_75_1, arg_75_2, arg_75_3)

		return false
	end

	local var_75_2 = arg_75_0._loadouts[arg_75_2]

	if var_75_2[arg_75_3] ~= arg_75_1 then
		var_75_2[arg_75_3] = arg_75_1
		arg_75_0._dirty_loadouts[arg_75_2] = true
	end

	return true
end

BackendInterfaceWeavesPlayFab.get_dirty_user_data = function (arg_76_0)
	local var_76_0 = false
	local var_76_1 = {}
	local var_76_2 = arg_76_0._dirty_loadouts
	local var_76_3 = arg_76_0._loadouts

	for iter_76_0, iter_76_1 in pairs(var_76_2) do
		var_76_0 = true
		var_76_1.loadouts = var_76_1.loadouts or {}
		var_76_1.loadouts[iter_76_0] = table.clone(var_76_3[iter_76_0])
	end

	if var_76_0 then
		return var_76_1
	end
end

BackendInterfaceWeavesPlayFab.clear_dirty_user_data = function (arg_77_0)
	table.clear(arg_77_0._dirty_loadouts)
end
