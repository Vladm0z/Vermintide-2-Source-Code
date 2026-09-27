-- chunkname: @scripts/settings/dlcs/morris/morris_interactions.lua

local InteractionDefinitions = InteractionDefinitions
local deus_access = InteractionDefinitions.deus_access

deus_access = deus_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.deus_access = deus_access
InteractionDefinitions.deus_access.config.swap_to_3p = false

InteractionDefinitions.deus_access.client.stop = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	if not (arg_1_6 ~= InteractionResult.SUCCESS or arg_1_3.is_husk) then
		Managers.ui:handle_transition("start_game_view_force", {
			use_fade = true,
			menu_state_name = "play"
		})
	end
end

InteractionDefinitions.deus_access.client.hud_description = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	return Unit.get_data(arg_2_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.deus_access.client.can_interact = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local get_data = Unit.get_data(arg_3_1, "interaction_data", "active")
	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()

	return not get_data and not is_game_matchmaking
end

local InteractionDefinitions_2 = InteractionDefinitions
local deus_weapon_chest = InteractionDefinitions.deus_weapon_chest

deus_weapon_chest = deus_weapon_chest or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_2.deus_weapon_chest = deus_weapon_chest
InteractionDefinitions.deus_weapon_chest.config.swap_to_3p = false

InteractionDefinitions.deus_weapon_chest.client.stop = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	if not (arg_4_6 ~= InteractionResult.SUCCESS or arg_4_3.is_husk) then
		local extension = ScriptUnit.extension(arg_4_2, "pickup_system")

		if not extension:can_be_unlocked() then
			extension:open_chest()
			ScriptUnit.extension(arg_4_1, "inventory_system"):check_and_drop_pickups("deus_weapon_chest")
		else
			Managers.state.event:trigger("chest_unlock_failed", extension:get_chest_type())
		end
	end
end

InteractionDefinitions.deus_weapon_chest.client.hud_description = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local extension = ScriptUnit.extension(arg_5_0, "pickup_system")

	return Unit.get_data(arg_5_0, "interaction_data", "hud_description"), Unit.get_data(arg_5_0, "interaction_data", "hud_action"), extension:get_chest_type()
end

InteractionDefinitions.deus_weapon_chest.client.can_interact = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not (Managers.mechanism:current_mechanism_name() ~= "deus" or Managers.mechanism:game_mechanism():get_state() == "ingame_deus") then
		return false
	end

	local has_extension = ScriptUnit.has_extension(arg_6_1, "pickup_system")

	return not has_extension and has_extension:can_interact()
end

local InteractionDefinitions_3 = InteractionDefinitions
local deus_cursed_chest = InteractionDefinitions.deus_cursed_chest

deus_cursed_chest = deus_cursed_chest or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_3.deus_cursed_chest = deus_cursed_chest
InteractionDefinitions.deus_cursed_chest.config = {
	block_other_interactions = true,
	hud_verb = "player_interaction",
	hold = true,
	swap_to_3p = false,
	activate_block = true
}

InteractionDefinitions.deus_cursed_chest.server.start = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local has_extension = ScriptUnit.has_extension(arg_7_2, "deus_cursed_chest_system")

	if not has_extension then
		local get_interaction_length = has_extension:get_interaction_length()

		arg_7_3.done_time = arg_7_5 + get_interaction_length
		arg_7_3.duration = get_interaction_length

		local get_data = Unit.get_data(arg_7_2, "interaction_data", "apply_buff")

		if not get_data then
			arg_7_3.apply_buff = get_data
		end

		local num = Unit.world_position(arg_7_1, 0) - Unit.world_position(arg_7_2, 0)

		arg_7_3.start_offset = Vector3Box(num)
	end
end

InteractionDefinitions.deus_cursed_chest.server.stop = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	-- function 8
	if arg_8_6 == InteractionResult.SUCCESS then
		local has_extension = ScriptUnit.has_extension(arg_8_2, "deus_cursed_chest_system")

		if not has_extension then
			has_extension:on_server_interact(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
		end
	end
end

InteractionDefinitions.deus_cursed_chest.client.start = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local has_extension = ScriptUnit.has_extension(arg_9_2, "deus_cursed_chest_system")

	if not has_extension then
		arg_9_3.start_time = arg_9_5

		local get_interaction_length = has_extension:get_interaction_length()

		arg_9_3.duration = get_interaction_length

		local get_data = Unit.get_data(arg_9_2, "interaction_data", "interactor_animation")
		local get_data_2 = Unit.get_data(arg_9_2, "interaction_data", "interactor_animation_time_variable")
		local extension = ScriptUnit.extension(arg_9_1, "inventory_system")
		local extension_2 = ScriptUnit.extension(arg_9_1, "career_system")

		if not get_data then
			local animation_find_variable = Unit.animation_find_variable(arg_9_1, get_data_2)

			Unit.animation_set_variable(arg_9_1, animation_find_variable, get_interaction_length)
			Unit.animation_event(arg_9_1, get_data)
		end

		local get_data_3 = Unit.get_data(arg_9_2, "interaction_data", "interactable_animation")
		local get_data_4 = Unit.get_data(arg_9_2, "interaction_data", "interactable_animation_time_variable")

		if not get_data_3 then
			local animation_find_variable_2 = Unit.animation_find_variable(arg_9_2, get_data_4)

			Unit.animation_set_variable(arg_9_2, animation_find_variable_2, get_interaction_length)
			Unit.animation_event(arg_9_2, get_data_3)
		end

		CharacterStateHelper.stop_weapon_actions(extension, "interacting")
		CharacterStateHelper.stop_career_abilities(extension_2, "interacting")
		Unit.set_data(arg_9_2, "interaction_data", "being_used", true)
	end
end

InteractionDefinitions.deus_cursed_chest.client.get_progress = function (self, arg_10_1, arg_10_2)
	-- function 10
	local duration = self.duration

	duration = duration or 0

	if duration == 0 then
		return 0
	end

	local flag

	flag = self.start_time ~= nil or not 0 or math.min(1, (arg_10_2 - self.start_time) / duration)

	return flag
end

InteractionDefinitions.deus_cursed_chest.client.stop = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	-- function 11
	if not (arg_11_6 ~= InteractionResult.SUCCESS or arg_11_3.is_husk) then
		local has_extension = ScriptUnit.has_extension(arg_11_2, "deus_cursed_chest_system")

		if not has_extension then
			has_extension:on_client_interact(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
		end
	end
end

InteractionDefinitions.deus_cursed_chest.client.hud_description = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local has_extension = ScriptUnit.has_extension(arg_12_0, "deus_cursed_chest_system")

	return Unit.get_data(arg_12_0, "interaction_data", "hud_description"), has_extension:get_interaction_action()
end

InteractionDefinitions.deus_cursed_chest.client.can_interact = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not (Managers.mechanism:current_mechanism_name() ~= "deus" or Managers.mechanism:game_mechanism():get_state() == "ingame_deus") then
		return false
	end

	local has_extension = ScriptUnit.has_extension(arg_13_1, "deus_cursed_chest_system")

	return not has_extension and has_extension:can_interact()
end

local InteractionDefinitions_4 = InteractionDefinitions
local deus_arena_interactable = InteractionDefinitions.deus_arena_interactable

deus_arena_interactable = deus_arena_interactable or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_4.deus_arena_interactable = deus_arena_interactable
InteractionDefinitions.deus_arena_interactable.config.swap_to_3p = false

InteractionDefinitions.deus_arena_interactable.server.stop = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	-- function 14
	if arg_14_6 == InteractionResult.SUCCESS then
		local has_extension = ScriptUnit.has_extension(arg_14_2, "deus_arena_interactable_system")

		if not has_extension then
			has_extension:on_server_interact(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
		end
	end
end

InteractionDefinitions.deus_arena_interactable.client.stop = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
	-- function 15
	if not (arg_15_6 ~= InteractionResult.SUCCESS or arg_15_3.is_husk) then
		local has_extension = ScriptUnit.has_extension(arg_15_2, "deus_arena_interactable_system")

		if not has_extension then
			has_extension:on_client_interact(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
		end
	end
end

InteractionDefinitions.deus_arena_interactable.client.hud_description = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local has_extension = ScriptUnit.has_extension(arg_16_0, "deus_arena_interactable_system")
	local get_interact_hud_description

	if not has_extension then
		get_interact_hud_description = has_extension:get_interact_hud_description()

		if not get_interact_hud_description then
			-- Nothing
		end
	end

	get_interact_hud_description = "deus_altar_hud_desc"

	::label_16_0::

	return get_interact_hud_description, "interaction_action_open"
end

InteractionDefinitions.deus_arena_interactable.client.can_interact = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	if not (Managers.mechanism:current_mechanism_name() ~= "deus" or Managers.mechanism:game_mechanism():get_state() == "ingame_deus") then
		return false
	end

	local has_extension = ScriptUnit.has_extension(arg_17_1, "deus_arena_interactable_system")

	return not has_extension and has_extension:can_interact()
end

InteractionDefinitions.deus_setup_rally_flag = {
	config = {
		block_other_interactions = true,
		hud_verb = "setup",
		hold = true,
		swap_to_3p = true,
		offset_flag = 0.5,
		duration = 3,
		activate_block = true
	},
	server = {
		start = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
			-- function 18
			arg_18_3.done_time = arg_18_5 + arg_18_4.duration
		end,
		update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
			-- function 19
			if arg_19_6 > arg_19_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
			-- function 20
			if arg_20_6 == InteractionResult.SUCCESS then
				local var_20_0 = POSITION_LOOKUP[arg_20_1]
				local local_rotation = Unit.local_rotation(arg_20_1, 0)
				local num = var_20_0 + Quaternion.forward(local_rotation) * arg_20_4.offset_flag
				local nav_world = Managers.state.entity:system("ai_system"):nav_world()
				local var_20_4
				local num_2 = 1
				local num_3 = 1
				local triangle_from_position, var_20_8 = GwNavQueries.triangle_from_position(nav_world, num, num_2, num_3)

				if not triangle_from_position then
					Vector3.copy(num).z = var_20_8
				else
					local num_4 = 1
					local num_5 = 0.05
					local flag

					flag = GwNavQueries.inside_position_from_outside_position(nav_world, num, num_2, num_3, num_4, num_5) or Vector3.copy(num)
				end

				local tbl = {
					buff_system = {
						initial_buff_names = {
							"deus_rally_flag_aoe_buff"
						}
					}
				}

				Managers.state.unit_spawner:spawn_network_unit("units/props/deus_rally_flag/deus_rally_flag", "buff_objective_unit", tbl, num, local_rotation)
			end
		end,
		can_interact = function (arg_21_0, arg_21_1)
			-- function 21
			return true
		end
	},
	client = {
		start = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
			-- function 22
			arg_22_3.start_time = arg_22_5

			local animation_find_variable = Unit.animation_find_variable(arg_22_1, "interaction_duration")

			Unit.animation_set_variable(arg_22_1, animation_find_variable, arg_22_4.duration)
			Unit.animation_event(arg_22_1, "interaction_rally_flag")

			arg_22_3.item_slot_name = ScriptUnit.extension(arg_22_1, "inventory_system"):get_wielded_slot_name()
		end,
		update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
			-- function 23
			return
		end,
		stop = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
			-- function 24
			arg_24_3.start_time = nil

			Unit.animation_event(arg_24_1, "interaction_end")

			local unit_owner = Managers.player:unit_owner(arg_24_1)

			if not unit_owner and not unit_owner.remote then
				return
			end

			if arg_24_6 == InteractionResult.SUCCESS then
				local extension = ScriptUnit.extension(arg_24_1, "inventory_system")
				local item_slot_name = arg_24_3.item_slot_name

				if not extension:get_slot_data(item_slot_name) then
					local apply_buffs_to_value, var_24_4 = ScriptUnit.extension(arg_24_1, "buff_system"):apply_buffs_to_value(0, "not_consume_medpack")

					if not var_24_4 then
						extension:wield_previous_weapon()
					else
						extension:get_item_slot_extension(item_slot_name, "ammo_system"):use_ammo(1)
					end
				end
			end
		end,
		get_progress = function (self, arg_25_1, arg_25_2)
			-- function 25
			if arg_25_1.duration == 0 then
				return 0
			end

			local flag

			flag = self.start_time ~= nil or not 0 or math.min(1, (arg_25_2 - self.start_time) / arg_25_1.duration)

			return flag
		end,
		can_interact = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
			-- function 26
			return true
		end,
		hud_description = function (arg_27_0, arg_27_1, arg_27_2)
			-- function 27
			return "deus_rally_flag", "interaction_action_deus_setup_rally_flag"
		end
	}
}

local InteractionDefinitions_5 = InteractionDefinitions
local deus_debug_changelog = InteractionDefinitions.deus_debug_changelog

deus_debug_changelog = deus_debug_changelog or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_5.deus_debug_changelog = deus_debug_changelog
InteractionDefinitions.deus_debug_changelog.config.swap_to_3p = false

InteractionDefinitions.deus_debug_changelog.client.stop = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
	-- function 28
	if not (arg_28_6 ~= InteractionResult.SUCCESS or arg_28_3.is_husk) then
		Managers.ui:handle_transition("deus_debug_changelog_view", {})
	end
end

InteractionDefinitions.deus_debug_changelog.client.hud_description = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	-- function 29
	return Unit.get_data(arg_29_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.deus_debug_changelog.client.can_interact = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	return Unit.get_data(arg_30_1, "interaction_data", "active")
end
