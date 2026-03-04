-- chunkname: @scripts/settings/dlcs/morris/morris_interactions.lua

InteractionDefinitions.deus_access = InteractionDefinitions.deus_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.deus_access.config.swap_to_3p = false

function InteractionDefinitions.deus_access.client.stop(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	if arg_1_6 == InteractionResult.SUCCESS and not arg_1_3.is_husk then
		Managers.ui:handle_transition("start_game_view_force", {
			use_fade = true,
			menu_state_name = "play"
		})
	end
end

function InteractionDefinitions.deus_access.client.hud_description(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	return Unit.get_data(arg_2_0, "interaction_data", "hud_description"), "interaction_action_open"
end

function InteractionDefinitions.deus_access.client.can_interact(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = Unit.get_data(arg_3_1, "interaction_data", "active")
	local var_3_1 = Managers.matchmaking:is_game_matchmaking()

	return var_3_0 and not var_3_1
end

InteractionDefinitions.deus_weapon_chest = InteractionDefinitions.deus_weapon_chest or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.deus_weapon_chest.config.swap_to_3p = false

function InteractionDefinitions.deus_weapon_chest.client.stop(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	if arg_4_6 == InteractionResult.SUCCESS and not arg_4_3.is_husk then
		local var_4_0 = ScriptUnit.extension(arg_4_2, "pickup_system")

		if var_4_0:can_be_unlocked() then
			var_4_0:open_chest()
			ScriptUnit.extension(arg_4_1, "inventory_system"):check_and_drop_pickups("deus_weapon_chest")
		else
			Managers.state.event:trigger("chest_unlock_failed", var_4_0:get_chest_type())
		end
	end
end

function InteractionDefinitions.deus_weapon_chest.client.hud_description(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = ScriptUnit.extension(arg_5_0, "pickup_system")

	return Unit.get_data(arg_5_0, "interaction_data", "hud_description"), Unit.get_data(arg_5_0, "interaction_data", "hud_action"), var_5_0:get_chest_type()
end

function InteractionDefinitions.deus_weapon_chest.client.can_interact(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if Managers.mechanism:current_mechanism_name() ~= "deus" or Managers.mechanism:game_mechanism():get_state() ~= "ingame_deus" then
		return false
	end

	local var_6_0 = ScriptUnit.has_extension(arg_6_1, "pickup_system")

	return var_6_0 and var_6_0:can_interact()
end

InteractionDefinitions.deus_cursed_chest = InteractionDefinitions.deus_cursed_chest or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.deus_cursed_chest.config = {
	block_other_interactions = true,
	hud_verb = "player_interaction",
	hold = true,
	swap_to_3p = false,
	activate_block = true
}

function InteractionDefinitions.deus_cursed_chest.server.start(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = ScriptUnit.has_extension(arg_7_2, "deus_cursed_chest_system")

	if var_7_0 then
		local var_7_1 = var_7_0:get_interaction_length()

		arg_7_3.done_time = arg_7_5 + var_7_1
		arg_7_3.duration = var_7_1

		local var_7_2 = Unit.get_data(arg_7_2, "interaction_data", "apply_buff")

		if var_7_2 then
			arg_7_3.apply_buff = var_7_2
		end

		local var_7_3 = Unit.world_position(arg_7_1, 0) - Unit.world_position(arg_7_2, 0)

		arg_7_3.start_offset = Vector3Box(var_7_3)
	end
end

function InteractionDefinitions.deus_cursed_chest.server.stop(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	if arg_8_6 == InteractionResult.SUCCESS then
		local var_8_0 = ScriptUnit.has_extension(arg_8_2, "deus_cursed_chest_system")

		if var_8_0 then
			var_8_0:on_server_interact(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
		end
	end
end

function InteractionDefinitions.deus_cursed_chest.client.start(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = ScriptUnit.has_extension(arg_9_2, "deus_cursed_chest_system")

	if var_9_0 then
		arg_9_3.start_time = arg_9_5

		local var_9_1 = var_9_0:get_interaction_length()

		arg_9_3.duration = var_9_1

		local var_9_2 = Unit.get_data(arg_9_2, "interaction_data", "interactor_animation")
		local var_9_3 = Unit.get_data(arg_9_2, "interaction_data", "interactor_animation_time_variable")
		local var_9_4 = ScriptUnit.extension(arg_9_1, "inventory_system")
		local var_9_5 = ScriptUnit.extension(arg_9_1, "career_system")

		if var_9_2 then
			local var_9_6 = Unit.animation_find_variable(arg_9_1, var_9_3)

			Unit.animation_set_variable(arg_9_1, var_9_6, var_9_1)
			Unit.animation_event(arg_9_1, var_9_2)
		end

		local var_9_7 = Unit.get_data(arg_9_2, "interaction_data", "interactable_animation")
		local var_9_8 = Unit.get_data(arg_9_2, "interaction_data", "interactable_animation_time_variable")

		if var_9_7 then
			local var_9_9 = Unit.animation_find_variable(arg_9_2, var_9_8)

			Unit.animation_set_variable(arg_9_2, var_9_9, var_9_1)
			Unit.animation_event(arg_9_2, var_9_7)
		end

		CharacterStateHelper.stop_weapon_actions(var_9_4, "interacting")
		CharacterStateHelper.stop_career_abilities(var_9_5, "interacting")
		Unit.set_data(arg_9_2, "interaction_data", "being_used", true)
	end
end

function InteractionDefinitions.deus_cursed_chest.client.get_progress(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.duration or 0

	if var_10_0 == 0 then
		return 0
	end

	return arg_10_0.start_time == nil and 0 or math.min(1, (arg_10_2 - arg_10_0.start_time) / var_10_0)
end

function InteractionDefinitions.deus_cursed_chest.client.stop(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	if arg_11_6 == InteractionResult.SUCCESS and not arg_11_3.is_husk then
		local var_11_0 = ScriptUnit.has_extension(arg_11_2, "deus_cursed_chest_system")

		if var_11_0 then
			var_11_0:on_client_interact(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
		end
	end
end

function InteractionDefinitions.deus_cursed_chest.client.hud_description(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = ScriptUnit.has_extension(arg_12_0, "deus_cursed_chest_system")

	return Unit.get_data(arg_12_0, "interaction_data", "hud_description"), var_12_0:get_interaction_action()
end

function InteractionDefinitions.deus_cursed_chest.client.can_interact(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if Managers.mechanism:current_mechanism_name() ~= "deus" or Managers.mechanism:game_mechanism():get_state() ~= "ingame_deus" then
		return false
	end

	local var_13_0 = ScriptUnit.has_extension(arg_13_1, "deus_cursed_chest_system")

	return var_13_0 and var_13_0:can_interact()
end

InteractionDefinitions.deus_arena_interactable = InteractionDefinitions.deus_arena_interactable or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.deus_arena_interactable.config.swap_to_3p = false

function InteractionDefinitions.deus_arena_interactable.server.stop(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	if arg_14_6 == InteractionResult.SUCCESS then
		local var_14_0 = ScriptUnit.has_extension(arg_14_2, "deus_arena_interactable_system")

		if var_14_0 then
			var_14_0:on_server_interact(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
		end
	end
end

function InteractionDefinitions.deus_arena_interactable.client.stop(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
	if arg_15_6 == InteractionResult.SUCCESS and not arg_15_3.is_husk then
		local var_15_0 = ScriptUnit.has_extension(arg_15_2, "deus_arena_interactable_system")

		if var_15_0 then
			var_15_0:on_client_interact(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
		end
	end
end

function InteractionDefinitions.deus_arena_interactable.client.hud_description(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = ScriptUnit.has_extension(arg_16_0, "deus_arena_interactable_system")

	return var_16_0 and var_16_0:get_interact_hud_description() or "deus_altar_hud_desc", "interaction_action_open"
end

function InteractionDefinitions.deus_arena_interactable.client.can_interact(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if Managers.mechanism:current_mechanism_name() ~= "deus" or Managers.mechanism:game_mechanism():get_state() ~= "ingame_deus" then
		return false
	end

	local var_17_0 = ScriptUnit.has_extension(arg_17_1, "deus_arena_interactable_system")

	return var_17_0 and var_17_0:can_interact()
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
		start = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
			arg_18_3.done_time = arg_18_5 + arg_18_4.duration
		end,
		update = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
			if arg_19_6 > arg_19_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
			if arg_20_6 == InteractionResult.SUCCESS then
				local var_20_0 = POSITION_LOOKUP[arg_20_1]
				local var_20_1 = Unit.local_rotation(arg_20_1, 0)
				local var_20_2 = var_20_0 + Quaternion.forward(var_20_1) * arg_20_4.offset_flag
				local var_20_3 = Managers.state.entity:system("ai_system"):nav_world()
				local var_20_4
				local var_20_5 = 1
				local var_20_6 = 1
				local var_20_7, var_20_8 = GwNavQueries.triangle_from_position(var_20_3, var_20_2, var_20_5, var_20_6)

				if var_20_7 then
					Vector3.copy(var_20_2).z = var_20_8
				else
					local var_20_9 = 1
					local var_20_10 = 0.05
					local var_20_11

					var_20_11 = GwNavQueries.inside_position_from_outside_position(var_20_3, var_20_2, var_20_5, var_20_6, var_20_9, var_20_10) or Vector3.copy(var_20_2)
				end

				local var_20_12 = {
					buff_system = {
						initial_buff_names = {
							"deus_rally_flag_aoe_buff"
						}
					}
				}

				Managers.state.unit_spawner:spawn_network_unit("units/props/deus_rally_flag/deus_rally_flag", "buff_objective_unit", var_20_12, var_20_2, var_20_1)
			end
		end,
		can_interact = function(arg_21_0, arg_21_1)
			return true
		end
	},
	client = {
		start = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
			arg_22_3.start_time = arg_22_5

			local var_22_0 = Unit.animation_find_variable(arg_22_1, "interaction_duration")

			Unit.animation_set_variable(arg_22_1, var_22_0, arg_22_4.duration)
			Unit.animation_event(arg_22_1, "interaction_rally_flag")

			arg_22_3.item_slot_name = ScriptUnit.extension(arg_22_1, "inventory_system"):get_wielded_slot_name()
		end,
		update = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
			return
		end,
		stop = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
			arg_24_3.start_time = nil

			Unit.animation_event(arg_24_1, "interaction_end")

			local var_24_0 = Managers.player:unit_owner(arg_24_1)

			if not var_24_0 or var_24_0.remote then
				return
			end

			if arg_24_6 == InteractionResult.SUCCESS then
				local var_24_1 = ScriptUnit.extension(arg_24_1, "inventory_system")
				local var_24_2 = arg_24_3.item_slot_name

				if var_24_1:get_slot_data(var_24_2) then
					local var_24_3, var_24_4 = ScriptUnit.extension(arg_24_1, "buff_system"):apply_buffs_to_value(0, "not_consume_medpack")

					if var_24_4 then
						var_24_1:wield_previous_weapon()
					else
						var_24_1:get_item_slot_extension(var_24_2, "ammo_system"):use_ammo(1)
					end
				end
			end
		end,
		get_progress = function(arg_25_0, arg_25_1, arg_25_2)
			if arg_25_1.duration == 0 then
				return 0
			end

			return arg_25_0.start_time == nil and 0 or math.min(1, (arg_25_2 - arg_25_0.start_time) / arg_25_1.duration)
		end,
		can_interact = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
			return true
		end,
		hud_description = function(arg_27_0, arg_27_1, arg_27_2)
			return "deus_rally_flag", "interaction_action_deus_setup_rally_flag"
		end
	}
}
InteractionDefinitions.deus_debug_changelog = InteractionDefinitions.deus_debug_changelog or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.deus_debug_changelog.config.swap_to_3p = false

function InteractionDefinitions.deus_debug_changelog.client.stop(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
	if arg_28_6 == InteractionResult.SUCCESS and not arg_28_3.is_husk then
		Managers.ui:handle_transition("deus_debug_changelog_view", {})
	end
end

function InteractionDefinitions.deus_debug_changelog.client.hud_description(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	return Unit.get_data(arg_29_0, "interaction_data", "hud_description"), "interaction_action_open"
end

function InteractionDefinitions.deus_debug_changelog.client.can_interact(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	return Unit.get_data(arg_30_1, "interaction_data", "active")
end
