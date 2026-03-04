-- chunkname: @scripts/settings/twitch_vote_templates_items.lua

local var_0_0 = TwitchSettings

local function var_0_1(arg_1_0, ...)
	if DEBUG_TWITCH then
		print("[Twitch] " .. string.format(arg_1_0, ...))
	end
end

local function var_0_2(arg_2_0)
	local var_2_0 = Managers.player:human_and_bot_players()
	local var_2_1 = arg_2_0.validation_data

	if not var_2_1 then
		local var_2_2 = {}
		local var_2_3 = {
			true,
			true,
			true,
			true,
			true
		}

		for iter_2_0, iter_2_1 in pairs(var_2_0) do
			local var_2_4 = iter_2_1:profile_index()

			var_2_3[var_2_4] = nil
			var_2_2[iter_2_0] = {
				name = iter_2_1:name(),
				option = var_2_4
			}
		end

		arg_2_0.validation_data = var_2_2
		arg_2_0.unused_variables = var_2_3
	else
		local var_2_5 = false

		for iter_2_2, iter_2_3 in pairs(var_2_1) do
			if not var_2_0[iter_2_2] or var_2_0[iter_2_2] and var_2_0[iter_2_2]:name() ~= iter_2_3.name then
				var_0_1(string.format("[TWITCH VOTE DATA VALIDATION] Resetting %q since a bot/player has been removed or replaced (%q ~= %q or id: %q is missing)", tostring(iter_2_3.variable), tostring(var_2_0[iter_2_2] and var_2_0[iter_2_2]:name() or nil), tostring(iter_2_3.name), iter_2_2))

				arg_2_0.options[iter_2_3.option] = 0
				var_2_5 = true
			end
		end

		for iter_2_4, iter_2_5 in pairs(arg_2_0.unused_variables) do
			arg_2_0.options[iter_2_4] = 0
		end

		if var_2_5 then
			arg_2_0.validation_data = nil
		end
	end
end

local function var_0_3(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = Managers.player:owner(arg_3_1)

	if var_3_0 and not var_3_0.remote then
		local var_3_1 = Managers.state.network.network_transmit
		local var_3_2 = ScriptUnit.extension(arg_3_1, "inventory_system")
		local var_3_3 = ScriptUnit.extension(arg_3_1, "career_system")
		local var_3_4 = AllPickups[arg_3_2]
		local var_3_5 = var_3_4.slot_name
		local var_3_6 = var_3_4.item_name
		local var_3_7 = var_3_2:get_slot_data(var_3_5)
		local var_3_8 = var_3_2:can_store_additional_item(var_3_5)
		local var_3_9 = var_3_2:has_additional_items(var_3_5)

		if var_3_7 and not var_3_8 then
			local var_3_10 = var_3_7.item_data
			local var_3_11 = BackendUtils.get_item_template(var_3_10)
			local var_3_12

			if var_3_11.name == "wpn_side_objective_tome_01" then
				var_3_12 = "tome"
			elseif var_3_11.name == "wpn_grimoire_01" then
				var_3_12 = "grimoire"
			end

			if var_3_12 then
				local var_3_13 = "dropped"
				local var_3_14 = NetworkLookup.pickup_names[var_3_12]
				local var_3_15 = NetworkLookup.pickup_spawn_types[var_3_13]
				local var_3_16 = POSITION_LOOKUP[arg_3_1]
				local var_3_17 = Unit.local_rotation(arg_3_1, 0)

				var_3_1:send_rpc_server("rpc_spawn_pickup", var_3_14, var_3_16, var_3_17, var_3_15)
			end
		end

		local var_3_18 = ItemMasterList[var_3_6]
		local var_3_19
		local var_3_20 = {}

		if var_3_8 and var_3_7 then
			var_3_2:store_additional_item(var_3_5, var_3_18)
		elseif var_3_9 and var_3_7 then
			local var_3_21, var_3_22, var_3_23 = var_3_2:has_droppable_item(var_3_5)

			if var_3_22 then
				var_3_2:remove_additional_item(var_3_5, var_3_23)
				var_3_2:store_additional_item(var_3_5, var_3_18)
			else
				var_3_2:destroy_slot(var_3_5)
				var_3_2:add_equipment(var_3_5, var_3_18, var_3_19, var_3_20)
			end
		else
			var_3_2:destroy_slot(var_3_5)
			var_3_2:add_equipment(var_3_5, var_3_18, var_3_19, var_3_20)
		end

		local var_3_24 = Managers.state.unit_storage:go_id(arg_3_1)
		local var_3_25 = NetworkLookup.equipment_slots[var_3_5]
		local var_3_26 = NetworkLookup.item_names[var_3_6]
		local var_3_27 = NetworkLookup.weapon_skins["n/a"]

		if arg_3_0 then
			var_3_1:send_rpc_clients("rpc_add_equipment", var_3_24, var_3_25, var_3_26, var_3_27)
		else
			var_3_1:send_rpc_server("rpc_add_equipment", var_3_24, var_3_25, var_3_26, var_3_27)
		end

		if var_3_2:get_wielded_slot_name() == var_3_5 then
			CharacterStateHelper.stop_weapon_actions(var_3_2, "picked_up_object")
			CharacterStateHelper.stop_career_abilities(var_3_3, "picked_up_object")
			var_3_2:wield(var_3_5)
		end
	end
end

TwitchVoteTemplates = TwitchVoteTemplates or {}
TwitchVoteTemplates.twitch_give_first_aid_kit = {
	cost = -100,
	use_frame_texture = true,
	texture_id = "twitch_icon_medical_supplies",
	multiple_choice = true,
	text = "twitch_give_first_aid_kit_one",
	texture_size = {
		70,
		70
	},
	condition_func = function()
		return not var_0_0.disable_giving_items and not var_0_0.disable_positive_votes
	end,
	on_success = function(arg_5_0, arg_5_1)
		local var_5_0 = SPProfiles[arg_5_1].display_name
		local var_5_1 = Managers.player:human_and_bot_players()

		for iter_5_0, iter_5_1 in pairs(var_5_1) do
			local var_5_2 = iter_5_1:profile_index()
			local var_5_3 = SPProfiles[var_5_2]

			if var_5_3.display_name == var_5_0 then
				var_0_1(string.format("[TWITCH VOTE] giving first aid kit to  %s", Localize(var_5_3.character_name)))

				local var_5_4 = iter_5_1.player_unit

				if Unit.alive(var_5_4) then
					var_0_3(arg_5_0, var_5_4, "first_aid_kit")
				end

				break
			end
		end
	end
}
TwitchVoteTemplates.twitch_give_healing_draught = {
	cost = -100,
	use_frame_texture = true,
	texture_id = "twitch_icon_healing_draught",
	multiple_choice = true,
	text = "twitch_give_healing_draught_one",
	texture_size = {
		70,
		70
	},
	condition_func = function()
		return not var_0_0.disable_giving_items and not var_0_0.disable_positive_votes
	end,
	on_success = function(arg_7_0, arg_7_1)
		local var_7_0 = SPProfiles[arg_7_1].display_name
		local var_7_1 = Managers.player:human_and_bot_players()

		for iter_7_0, iter_7_1 in pairs(var_7_1) do
			local var_7_2 = iter_7_1:profile_index()
			local var_7_3 = SPProfiles[var_7_2]

			if var_7_3.display_name == var_7_0 then
				var_0_1(string.format("[TWITCH VOTE] giving health potion to  %s", Localize(var_7_3.character_name)))

				local var_7_4 = iter_7_1.player_unit

				if Unit.alive(var_7_4) then
					var_0_3(arg_7_0, var_7_4, "healing_draught")
				end

				break
			end
		end
	end
}
TwitchVoteTemplates.twitch_give_damage_boost_potion = {
	cost = -50,
	use_frame_texture = true,
	texture_id = "twitch_icon_potion_of_strength",
	multiple_choice = true,
	text = "twitch_give_damage_boost_potion_one",
	texture_size = {
		70,
		70
	},
	condition_func = function()
		return not var_0_0.disable_giving_items and not var_0_0.disable_positive_votes
	end,
	on_success = function(arg_9_0, arg_9_1)
		local var_9_0 = SPProfiles[arg_9_1].display_name
		local var_9_1 = Managers.player:human_and_bot_players()

		for iter_9_0, iter_9_1 in pairs(var_9_1) do
			local var_9_2 = iter_9_1:profile_index()
			local var_9_3 = SPProfiles[var_9_2]

			if var_9_3.display_name == var_9_0 then
				var_0_1(string.format("[TWITCH VOTE] giving damage boost potion to  %s", Localize(var_9_3.character_name)))

				local var_9_4 = iter_9_1.player_unit

				if Unit.alive(var_9_4) then
					var_0_3(arg_9_0, var_9_4, "damage_boost_potion")
				end

				break
			end
		end
	end
}
TwitchVoteTemplates.twitch_give_speed_boost_potion = {
	cost = -50,
	use_frame_texture = true,
	texture_id = "twitch_icon_potion_of_speed",
	multiple_choice = true,
	text = "twitch_give_speed_boost_potion_one",
	texture_size = {
		70,
		70
	},
	condition_func = function()
		return not var_0_0.disable_giving_items and not var_0_0.disable_positive_votes
	end,
	on_success = function(arg_11_0, arg_11_1)
		local var_11_0 = SPProfiles[arg_11_1].display_name
		local var_11_1 = Managers.player:human_and_bot_players()

		for iter_11_0, iter_11_1 in pairs(var_11_1) do
			local var_11_2 = iter_11_1:profile_index()
			local var_11_3 = SPProfiles[var_11_2]

			if var_11_3.display_name == var_11_0 then
				var_0_1(string.format("[TWITCH VOTE] giving speed boost potion to  %s", Localize(var_11_3.character_name)))

				local var_11_4 = iter_11_1.player_unit

				if Unit.alive(var_11_4) then
					var_0_3(arg_11_0, var_11_4, "speed_boost_potion")
				end

				break
			end
		end
	end
}
TwitchVoteTemplates.twitch_give_cooldown_reduction_potion = {
	cost = -50,
	use_frame_texture = true,
	texture_id = "twitch_icon_potion_of_concentration",
	multiple_choice = true,
	text = "twitch_give_cooldown_reduction_potion_one",
	texture_size = {
		70,
		70
	},
	condition_func = function()
		return not var_0_0.disable_giving_items and not var_0_0.disable_positive_votes
	end,
	on_success = function(arg_13_0, arg_13_1)
		local var_13_0 = SPProfiles[arg_13_1].display_name
		local var_13_1 = Managers.player:human_and_bot_players()

		for iter_13_0, iter_13_1 in pairs(var_13_1) do
			local var_13_2 = iter_13_1:profile_index()
			local var_13_3 = SPProfiles[var_13_2]

			if var_13_3.display_name == var_13_0 then
				var_0_1(string.format("[TWITCH VOTE] giving cooldown reduction potion to  %s", Localize(var_13_3.character_name)))

				local var_13_4 = iter_13_1.player_unit

				if Unit.alive(var_13_4) then
					var_0_3(arg_13_0, var_13_4, "cooldown_reduction_potion")
				end

				break
			end
		end
	end
}
TwitchVoteTemplates.twitch_give_frag_grenade_t1 = {
	cost = -100,
	use_frame_texture = true,
	texture_id = "twitch_icon_bomb",
	multiple_choice = true,
	text = "twitch_give_frag_grenade_t1_one",
	texture_size = {
		70,
		70
	},
	condition_func = function()
		return not var_0_0.disable_giving_items and not var_0_0.disable_positive_votes
	end,
	on_success = function(arg_15_0, arg_15_1)
		local var_15_0 = SPProfiles[arg_15_1].display_name
		local var_15_1 = Managers.player:human_and_bot_players()

		for iter_15_0, iter_15_1 in pairs(var_15_1) do
			local var_15_2 = iter_15_1:profile_index()
			local var_15_3 = SPProfiles[var_15_2]

			if var_15_3.display_name == var_15_0 then
				var_0_1(string.format("[TWITCH VOTE] giving frag grenade t1 to  %s", Localize(var_15_3.character_name)))

				local var_15_4 = iter_15_1.player_unit

				if Unit.alive(var_15_4) then
					var_0_3(arg_15_0, var_15_4, "frag_grenade_t1")
				end

				break
			end
		end
	end
}
TwitchVoteTemplates.twitch_give_fire_grenade_t1 = {
	cost = -100,
	use_frame_texture = true,
	texture_id = "twitch_icon_incediary_bomb",
	multiple_choice = true,
	text = "twitch_give_fire_grenade_t1_one",
	texture_size = {
		70,
		70
	},
	condition_func = function()
		return not var_0_0.disable_giving_items and not var_0_0.disable_positive_votes
	end,
	on_success = function(arg_17_0, arg_17_1)
		local var_17_0 = SPProfiles[arg_17_1].display_name
		local var_17_1 = Managers.player:human_and_bot_players()

		for iter_17_0, iter_17_1 in pairs(var_17_1) do
			local var_17_2 = iter_17_1:profile_index()
			local var_17_3 = SPProfiles[var_17_2]

			if var_17_3.display_name == var_17_0 then
				var_0_1(string.format("[TWITCH VOTE] giving fire grenade t1 to  %s", Localize(var_17_3.character_name)))

				local var_17_4 = iter_17_1.player_unit

				if Unit.alive(var_17_4) then
					var_0_3(arg_17_0, var_17_4, "fire_grenade_t1")
				end

				break
			end
		end
	end
}
