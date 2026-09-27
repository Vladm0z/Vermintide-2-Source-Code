-- chunkname: @scripts/settings/twitch_vote_templates_items.lua

local TwitchSettings = TwitchSettings

local function fn(arg_1_0, ...)
	-- function 1
	if not DEBUG_TWITCH then
		print("[Twitch] " .. string.format(arg_1_0, ...))
	end
end

local function fn_2(self)
	-- function 2
	local human_and_bot_players = Managers.player:human_and_bot_players()
	local validation_data = self.validation_data

	if not validation_data then
		local tbl = {}
		local tbl_2 = {
			true,
			true,
			true,
			true,
			true
		}

		for k, v in pairs(human_and_bot_players) do
			local profile_index = v:profile_index()

			tbl_2[profile_index] = nil
			tbl[k] = {
				name = v:name(),
				option = profile_index
			}
		end

		self.validation_data = tbl
		self.unused_variables = tbl_2
	else
		local flag = false

		for k_2, v_2 in pairs(validation_data) do
			if not (not human_and_bot_players[k_2] and not human_and_bot_players[k_2] and human_and_bot_players[k_2]:name() == v_2.name) then
				local var_2_6 = fn
				local format = string.format
				local str = "[TWITCH VOTE DATA VALIDATION] Resetting %q since a bot/player has been removed or replaced (%q ~= %q or id: %q is missing)"
				local var_2_9 = tostring(v_2.variable)
				local tostring = tostring
				local name

				if not human_and_bot_players[k_2] then
					name = human_and_bot_players[k_2]:name()

					if not name then
						-- Nothing
					end
				end

				name = nil

				::label_2_0::

				var_2_6(format(str, var_2_9, tostring(name), tostring(v_2.name), k_2))

				self.options[v_2.option] = 0
				flag = true
			end
		end

		for k_3, v_3 in pairs(self.unused_variables) do
			self.options[k_3] = 0
		end

		if not flag then
			self.validation_data = nil
		end
	end
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local owner = Managers.player:owner(arg_3_1)

	if not owner and not not owner.remote then
		local network_transmit = Managers.state.network.network_transmit
		local extension = ScriptUnit.extension(arg_3_1, "inventory_system")
		local extension_2 = ScriptUnit.extension(arg_3_1, "career_system")
		local var_3_4 = AllPickups[arg_3_2]
		local slot_name = var_3_4.slot_name
		local item_name = var_3_4.item_name
		local get_slot_data = extension:get_slot_data(slot_name)
		local can_store_additional_item = extension:can_store_additional_item(slot_name)
		local has_additional_items = extension:has_additional_items(slot_name)

		if not (not get_slot_data and can_store_additional_item) then
			local item_data = get_slot_data.item_data
			local get_item_template = BackendUtils.get_item_template(item_data)
			local var_3_12

			if get_item_template.name == "wpn_side_objective_tome_01" then
				var_3_12 = "tome"
			elseif get_item_template.name == "wpn_grimoire_01" then
				var_3_12 = "grimoire"
			end

			if not var_3_12 then
				local str = "dropped"
				local var_3_14 = NetworkLookup.pickup_names[var_3_12]
				local var_3_15 = NetworkLookup.pickup_spawn_types[str]
				local var_3_16 = POSITION_LOOKUP[arg_3_1]
				local local_rotation = Unit.local_rotation(arg_3_1, 0)

				network_transmit:send_rpc_server("rpc_spawn_pickup", var_3_14, var_3_16, local_rotation, var_3_15)
			end
		end

		local var_3_18 = ItemMasterList[item_name]
		local var_3_19
		local tbl = {}

		if not can_store_additional_item and not get_slot_data then
			extension:store_additional_item(slot_name, var_3_18)
		elseif not has_additional_items and not get_slot_data then
			local has_droppable_item, var_3_22, var_3_23 = extension:has_droppable_item(slot_name)

			if not var_3_22 then
				extension:remove_additional_item(slot_name, var_3_23)
				extension:store_additional_item(slot_name, var_3_18)
			else
				extension:destroy_slot(slot_name)
				extension:add_equipment(slot_name, var_3_18, var_3_19, tbl)
			end
		else
			extension:destroy_slot(slot_name)
			extension:add_equipment(slot_name, var_3_18, var_3_19, tbl)
		end

		local go_id = Managers.state.unit_storage:go_id(arg_3_1)
		local var_3_25 = NetworkLookup.equipment_slots[slot_name]
		local var_3_26 = NetworkLookup.item_names[item_name]
		local var_3_27 = NetworkLookup.weapon_skins["n/a"]

		if not arg_3_0 then
			network_transmit:send_rpc_clients("rpc_add_equipment", go_id, var_3_25, var_3_26, var_3_27)
		else
			network_transmit:send_rpc_server("rpc_add_equipment", go_id, var_3_25, var_3_26, var_3_27)
		end

		if extension:get_wielded_slot_name() == slot_name then
			CharacterStateHelper.stop_weapon_actions(extension, "picked_up_object")
			CharacterStateHelper.stop_career_abilities(extension_2, "picked_up_object")
			extension:wield(slot_name)
		end
	end
end

local TwitchVoteTemplates = TwitchVoteTemplates

TwitchVoteTemplates = TwitchVoteTemplates or {}
TwitchVoteTemplates = TwitchVoteTemplates
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
	condition_func = function ()
		-- function 4
		return not not TwitchSettings.disable_giving_items or not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_5_0, arg_5_1)
		-- function 5
		local display_name = SPProfiles[arg_5_1].display_name
		local human_and_bot_players = Managers.player:human_and_bot_players()

		for k, v in pairs(human_and_bot_players) do
			local profile_index = v:profile_index()
			local var_5_3 = SPProfiles[profile_index]

			if var_5_3.display_name == display_name then
				fn(string.format("[TWITCH VOTE] giving first aid kit to  %s", Localize(var_5_3.character_name)))

				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					fn_3(arg_5_0, player_unit, "first_aid_kit")
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
	condition_func = function ()
		-- function 6
		return not not TwitchSettings.disable_giving_items or not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_7_0, arg_7_1)
		-- function 7
		local display_name = SPProfiles[arg_7_1].display_name
		local human_and_bot_players = Managers.player:human_and_bot_players()

		for k, v in pairs(human_and_bot_players) do
			local profile_index = v:profile_index()
			local var_7_3 = SPProfiles[profile_index]

			if var_7_3.display_name == display_name then
				fn(string.format("[TWITCH VOTE] giving health potion to  %s", Localize(var_7_3.character_name)))

				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					fn_3(arg_7_0, player_unit, "healing_draught")
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
	condition_func = function ()
		-- function 8
		return not not TwitchSettings.disable_giving_items or not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_9_0, arg_9_1)
		-- function 9
		local display_name = SPProfiles[arg_9_1].display_name
		local human_and_bot_players = Managers.player:human_and_bot_players()

		for k, v in pairs(human_and_bot_players) do
			local profile_index = v:profile_index()
			local var_9_3 = SPProfiles[profile_index]

			if var_9_3.display_name == display_name then
				fn(string.format("[TWITCH VOTE] giving damage boost potion to  %s", Localize(var_9_3.character_name)))

				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					fn_3(arg_9_0, player_unit, "damage_boost_potion")
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
	condition_func = function ()
		-- function 10
		return not not TwitchSettings.disable_giving_items or not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_11_0, arg_11_1)
		-- function 11
		local display_name = SPProfiles[arg_11_1].display_name
		local human_and_bot_players = Managers.player:human_and_bot_players()

		for k, v in pairs(human_and_bot_players) do
			local profile_index = v:profile_index()
			local var_11_3 = SPProfiles[profile_index]

			if var_11_3.display_name == display_name then
				fn(string.format("[TWITCH VOTE] giving speed boost potion to  %s", Localize(var_11_3.character_name)))

				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					fn_3(arg_11_0, player_unit, "speed_boost_potion")
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
	condition_func = function ()
		-- function 12
		return not not TwitchSettings.disable_giving_items or not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_13_0, arg_13_1)
		-- function 13
		local display_name = SPProfiles[arg_13_1].display_name
		local human_and_bot_players = Managers.player:human_and_bot_players()

		for k, v in pairs(human_and_bot_players) do
			local profile_index = v:profile_index()
			local var_13_3 = SPProfiles[profile_index]

			if var_13_3.display_name == display_name then
				fn(string.format("[TWITCH VOTE] giving cooldown reduction potion to  %s", Localize(var_13_3.character_name)))

				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					fn_3(arg_13_0, player_unit, "cooldown_reduction_potion")
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
	condition_func = function ()
		-- function 14
		return not not TwitchSettings.disable_giving_items or not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_15_0, arg_15_1)
		-- function 15
		local display_name = SPProfiles[arg_15_1].display_name
		local human_and_bot_players = Managers.player:human_and_bot_players()

		for k, v in pairs(human_and_bot_players) do
			local profile_index = v:profile_index()
			local var_15_3 = SPProfiles[profile_index]

			if var_15_3.display_name == display_name then
				fn(string.format("[TWITCH VOTE] giving frag grenade t1 to  %s", Localize(var_15_3.character_name)))

				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					fn_3(arg_15_0, player_unit, "frag_grenade_t1")
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
	condition_func = function ()
		-- function 16
		return not not TwitchSettings.disable_giving_items or not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_17_0, arg_17_1)
		-- function 17
		local display_name = SPProfiles[arg_17_1].display_name
		local human_and_bot_players = Managers.player:human_and_bot_players()

		for k, v in pairs(human_and_bot_players) do
			local profile_index = v:profile_index()
			local var_17_3 = SPProfiles[profile_index]

			if var_17_3.display_name == display_name then
				fn(string.format("[TWITCH VOTE] giving fire grenade t1 to  %s", Localize(var_17_3.character_name)))

				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					fn_3(arg_17_0, player_unit, "fire_grenade_t1")
				end

				break
			end
		end
	end
}
