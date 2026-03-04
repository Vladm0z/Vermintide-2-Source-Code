-- chunkname: @scripts/unit_extensions/default_player_unit/cosmetic/player_unit_cosmetic_extension.lua

require("scripts/helpers/cosmetic_utils")

PlayerUnitCosmeticExtension = class(PlayerUnitCosmeticExtension)

function PlayerUnitCosmeticExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._world = arg_1_1.world
	arg_1_0._unit = arg_1_2
	arg_1_0._profile = arg_1_3.profile
	arg_1_0._is_server = arg_1_3.is_server
	arg_1_0._player = arg_1_3.player
	arg_1_0._cosmetics = {}
	arg_1_0._skin_material_changes = {}
	arg_1_0._tp_mesh_visible = true
	arg_1_0._player_afk_data = {
		tickrate = 1,
		triggered = false,
		last_tick = 0,
		trigger_event_dt = 120,
		last_player_move_t = 0,
		last_player_pos = Vector3Box()
	}

	local var_1_0 = arg_1_3.skin_name
	local var_1_1 = arg_1_3.frame_name
	local var_1_2 = arg_1_3.profile

	fassert(var_1_0, "No skin name passed to CosmeticExtension, somthing went wrong!")

	local var_1_3 = Cosmetics[var_1_0]

	arg_1_0._cosmetics.skin = var_1_3

	CosmeticUtils.update_cosmetic_slot(arg_1_0._player, "slot_skin", var_1_0)

	local var_1_4 = arg_1_3.pose_name

	if var_1_4 then
		local var_1_5 = ItemMasterList[var_1_4]

		arg_1_0._cosmetics.weapon_pose = var_1_5

		CosmeticUtils.update_cosmetic_slot(arg_1_0._player, "slot_pose", var_1_4)
	end

	if var_1_1 then
		arg_1_0:set_equipped_frame(var_1_1)
	end

	local var_1_6 = arg_1_0._player and arg_1_0._player:career_index() or 1
	local var_1_7 = var_1_2.careers[var_1_6]

	arg_1_0:_init_mesh_attachment(arg_1_0._world, arg_1_2, var_1_0, var_1_2, var_1_7)
end

function PlayerUnitCosmeticExtension.destroy(arg_2_0)
	if arg_2_0._tp_unit_mesh then
		AttachmentUtils.unlink(arg_2_0._world, arg_2_0._tp_unit_mesh)
		Managers.state.unit_spawner:mark_for_deletion(arg_2_0._tp_unit_mesh)

		arg_2_0._tp_unit_mesh = nil
	end
end

function PlayerUnitCosmeticExtension.extensions_ready(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._status_extension = ScriptUnit.extension(arg_3_2, "status_system")
	arg_3_0._attachment_extension = ScriptUnit.extension(arg_3_2, "attachment_system")

	local var_3_0 = arg_3_0._profile.display_name
	local var_3_1 = arg_3_0._cosmetics.skin
	local var_3_2 = var_3_1.material_changes

	if var_3_2 then
		arg_3_0:change_skin_materials(var_3_2)
	end

	local var_3_3 = var_3_1.material_settings_name

	if var_3_3 then
		arg_3_0:change_skin_material_settings(var_3_3)
	end

	local var_3_4 = var_3_1.color_tint

	if var_3_4 then
		local var_3_5 = var_3_4.gradient_variation
		local var_3_6 = var_3_4.gradient_value

		CosmeticUtils.color_tint_unit(arg_3_2, var_3_0, var_3_5, var_3_6)
	end
end

function PlayerUnitCosmeticExtension.get_equipped_skin(arg_4_0)
	return arg_4_0._cosmetics.skin
end

function PlayerUnitCosmeticExtension.get_equipped_frame(arg_5_0)
	return arg_5_0._cosmetics.frame
end

function PlayerUnitCosmeticExtension.set_equipped_frame(arg_6_0, arg_6_1)
	arg_6_0._cosmetics.frame = Cosmetics[arg_6_1]
	arg_6_0._frame_name = arg_6_1

	CosmeticUtils.update_cosmetic_slot(arg_6_0._player, "slot_frame", arg_6_1)
end

function PlayerUnitCosmeticExtension.get_equipped_frame_name(arg_7_0)
	return arg_7_0._frame_name
end

function PlayerUnitCosmeticExtension.change_skin_materials(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._unit
	local var_8_1 = arg_8_0._tp_unit_mesh
	local var_8_2 = arg_8_1.third_person

	for iter_8_0, iter_8_1 in pairs(var_8_2) do
		Unit.set_material(var_8_1, iter_8_0, iter_8_1)
	end

	local var_8_3 = ScriptUnit.has_extension(var_8_0, "first_person_system")

	if var_8_3 then
		local var_8_4 = arg_8_1.first_person

		if var_8_4 then
			local var_8_5 = var_8_3:get_first_person_mesh_unit()

			for iter_8_2, iter_8_3 in pairs(var_8_4) do
				Unit.set_material(var_8_5, iter_8_2, iter_8_3)
			end
		end
	end
end

function PlayerUnitCosmeticExtension.change_skin_material_settings(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._unit
	local var_9_1 = arg_9_0._tp_unit_mesh

	CosmeticUtils.apply_material_settings(var_9_1, arg_9_1)

	local var_9_2 = ScriptUnit.has_extension(var_9_0, "first_person_system")

	if var_9_2 then
		local var_9_3 = var_9_2:get_first_person_mesh_unit()

		CosmeticUtils.apply_material_settings(var_9_3, arg_9_1)
	end
end

function PlayerUnitCosmeticExtension.always_hide_attachment_slot(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._cosmetics.skin

	if not var_10_0 then
		return false
	end

	local var_10_1 = var_10_0.always_hide_attachment_slots

	if not var_10_1 then
		return false
	end

	if not table.contains(var_10_1, arg_10_1) then
		return false
	end

	return true
end

function PlayerUnitCosmeticExtension.trigger_equip_events(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_1 == "slot_hat" then
		local var_11_0 = arg_11_0._cosmetics.skin.equip_hat_event or "using_skin_default"

		if var_11_0 then
			Unit.flow_event(arg_11_2, var_11_0)
		end
	end
end

function PlayerUnitCosmeticExtension.hot_join_sync(arg_12_0, arg_12_1)
	return
end

function PlayerUnitCosmeticExtension._init_mesh_attachment(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	local var_13_0 = Cosmetics[arg_13_3].third_person_attachment or arg_13_4.third_person_attachment
	local var_13_1 = var_13_0.unit
	local var_13_2 = var_13_0.attachment_node_linking
	local var_13_3 = Managers.state.unit_spawner:spawn_local_unit(var_13_1)

	arg_13_0._tp_unit_mesh = var_13_3

	Unit.set_flow_variable(arg_13_2, "lua_third_person_mesh_unit", var_13_3)
	AttachmentUtils.link(arg_13_1, arg_13_2, var_13_3, var_13_2)
	Unit.set_flow_variable(arg_13_2, "character_vo", arg_13_4.character_vo)
	Unit.set_flow_variable(arg_13_2, "sound_character", arg_13_5.sound_character)
	Unit.flow_event(arg_13_2, "character_vo_set")

	local var_13_4 = LevelHelper:current_level_settings().climate_type or "default"

	Unit.set_flow_variable(var_13_3, "climate_type", var_13_4)
	Unit.flow_event(var_13_3, "climate_type_set")

	local var_13_5 = Cosmetics[arg_13_3].equip_skin_event or "using_skin_default"

	Unit.flow_event(arg_13_2, var_13_5)

	if not arg_13_0._tp_mesh_visible then
		arg_13_0._tp_mesh_visible = true

		Unit.set_unit_visibility(arg_13_0._tp_unit_mesh, false)
	end

	if Unit.has_animation_state_machine(arg_13_0._tp_unit_mesh) and Unit.has_animation_event(arg_13_0._tp_unit_mesh, "enable") then
		Unit.animation_event(arg_13_0._tp_unit_mesh, "enable")
	end
end

function PlayerUnitCosmeticExtension.update(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	arg_14_0._queue_3p_event_name = nil

	if ALIVE[arg_14_1] then
		arg_14_0:_update_player_standing_still_events(arg_14_5)
	end
end

function PlayerUnitCosmeticExtension.get_third_person_mesh_unit(arg_15_0)
	return arg_15_0._tp_unit_mesh
end

function PlayerUnitCosmeticExtension.show_third_person_mesh(arg_16_0, arg_16_1)
	if arg_16_0._tp_mesh_visible ~= arg_16_1 then
		arg_16_0._tp_mesh_visible = arg_16_1

		if arg_16_0._tp_unit_mesh then
			Unit.set_unit_visibility(arg_16_0._tp_unit_mesh, arg_16_1)

			if arg_16_1 then
				Unit.flow_event(arg_16_0._unit, "lua_enter_third_person_camera")
				Unit.flow_event(arg_16_0._tp_unit_mesh, "lua_enter_third_person_camera")
			else
				Unit.flow_event(arg_16_0._unit, "lua_exit_third_person_camera")
				Unit.flow_event(arg_16_0._tp_unit_mesh, "lua_exit_third_person_camera")
			end
		end
	end
end

function PlayerUnitCosmeticExtension.queue_3p_emote(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0._queue_3p_event_name = arg_17_1
	arg_17_0._queue_3p_hide_weapons = arg_17_2
end

function PlayerUnitCosmeticExtension.get_queued_3p_emote(arg_18_0)
	return arg_18_0._queue_3p_event_name, arg_18_0._queue_3p_hide_weapons
end

function PlayerUnitCosmeticExtension.consume_queued_3p_emote(arg_19_0)
	arg_19_0._queue_3p_event_name = nil
end

function PlayerUnitCosmeticExtension.trigger_ability_activated_events(arg_20_0)
	local var_20_0 = arg_20_0._attachment_extension:get_slot_data("slot_hat")

	if var_20_0 then
		Unit.flow_event(var_20_0.unit, "ability_activated")
	end
end

function PlayerUnitCosmeticExtension._update_player_standing_still_events(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._unit
	local var_21_1 = arg_21_0._player_afk_data

	if arg_21_1 > var_21_1.last_tick + var_21_1.tickrate then
		local var_21_2 = var_21_1.last_player_pos:unbox()
		local var_21_3 = Unit.local_position(var_21_0, 0)

		if Vector3.distance_squared(var_21_2, var_21_3) > 0.1 then
			var_21_1.last_player_move_t = arg_21_1

			var_21_1.last_player_pos:store(var_21_3)

			if var_21_1.triggered then
				local var_21_4 = arg_21_0._attachment_extension:get_slot_data("slot_hat")

				if var_21_4 then
					Unit.flow_event(var_21_4.unit, "player_break_prolonged_standing_still")
				end
			end

			var_21_1.triggered = false
		elseif not var_21_1.triggered and arg_21_1 > var_21_1.last_player_move_t + var_21_1.trigger_event_dt and not arg_21_0._status_extension:is_disabled() then
			local var_21_5 = arg_21_0._attachment_extension:get_slot_data("slot_hat")

			if var_21_5 then
				Unit.flow_event(var_21_5.unit, "player_prolonged_standing_still")
			end

			var_21_1.triggered = true
		end

		var_21_1.last_tick = arg_21_1
	end
end
