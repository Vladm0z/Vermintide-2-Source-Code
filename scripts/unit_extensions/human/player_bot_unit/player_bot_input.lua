-- chunkname: @scripts/unit_extensions/human/player_bot_unit/player_bot_input.lua

require("scripts/unit_extensions/generic/generic_state_machine")

PlayerBotInput = class(PlayerBotInput)

local var_0_0 = POSITION_LOOKUP

PlayerBotInput.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.move = {
		x = 0,
		y = 0
	}
	arg_1_0.look = {
		x = 0,
		y = 0
	}
	arg_1_0._aim_target = Vector3Box(0, 0, 0)
	arg_1_0._aim_rotation = QuaternionBox(0, 0, 0)
	arg_1_0._aiming = false
	arg_1_0._soft_aiming = false
	arg_1_0._charge_shot = false
	arg_1_0._charge_shot_held = false
	arg_1_0._fire_hold = false
	arg_1_0._fire = false
	arg_1_0._fire_held = false
	arg_1_0._defend = false
	arg_1_0._defend_held = false
	arg_1_0._melee_push = false
	arg_1_0._hold_attack = false
	arg_1_0._tap_attack = false
	arg_1_0._tap_attack_released = true
	arg_1_0._interact = false
	arg_1_0._interact_held = false
	arg_1_0._activate_ability = false
	arg_1_0._activate_ability_held = false
	arg_1_0._cancel_held_ability = false
	arg_1_0._weapon_reload = false
	arg_1_0._dodge = false
	arg_1_0._bot_in_attract_mode_focus = false
	arg_1_0._avoiding_aoe_threat = false
	arg_1_0.double_tap_dodge = false
	arg_1_0.minimum_dodge_input = 0
	arg_1_0._input = {}
	arg_1_0._look_at_player = nil
	arg_1_0._look_at_player_rotation_allowed = false
	arg_1_0._world = arg_1_1.world
	arg_1_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0._game = Managers.state.network:game()
end

PlayerBotInput.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = ScriptUnit.extension

	arg_2_0._navigation_extension = var_2_0(arg_2_2, "ai_navigation_system")
	arg_2_0._status_extension = var_2_0(arg_2_2, "status_system")
	arg_2_0._first_person_extension = var_2_0(arg_2_2, "first_person_system")
	arg_2_0._ai_bot_group_extension = var_2_0(arg_2_2, "ai_bot_group_system")
	arg_2_0._locomotion_extension = var_2_0(arg_2_2, "locomotion_system")
	arg_2_0._ai_bot_group_system = Managers.state.entity:system("ai_bot_group_system")
end

PlayerBotInput.destroy = function (arg_3_0)
	return
end

PlayerBotInput.reset = function (arg_4_0)
	return
end

PlayerBotInput.pre_update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = var_0_0[arg_5_1]
	local var_5_1, var_5_2 = GwNavQueries.triangle_from_position(arg_5_0._nav_world, var_5_0, 1.1, 0.5)

	arg_5_0._position_on_navmesh = var_5_1 and Vector3(var_5_0.x, var_5_0.y, var_5_2) or var_5_0
end

PlayerBotInput.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	table.clear(arg_6_0._input)
	arg_6_0:_update_movement(arg_6_3, arg_6_5)
	arg_6_0:_update_actions()
end

PlayerBotInput._update_actions = function (arg_7_0)
	local var_7_0 = arg_7_0._input

	if arg_7_0._fire_hold then
		arg_7_0._fire_hold = false
		var_7_0.action_one_hold = true

		if not arg_7_0._fire_held then
			var_7_0.action_one = true
			arg_7_0._fire_held = true
		end
	elseif arg_7_0._fire_held then
		arg_7_0._fire_held = false
		var_7_0.action_one_release = true
	elseif arg_7_0._fire then
		arg_7_0._fire = false
		var_7_0.action_one = true
	end

	if arg_7_0._melee_push then
		arg_7_0._melee_push = false
		arg_7_0._defend = false

		if arg_7_0._defend_held then
			var_7_0.action_one = true
		else
			arg_7_0._defend_held = true
			var_7_0.action_two = true
		end

		var_7_0.action_two_hold = true
	elseif arg_7_0._defend then
		arg_7_0._defend = false

		if not arg_7_0._defend_held then
			arg_7_0._defend_held = true
			var_7_0.action_two = true
		end

		var_7_0.action_two_hold = true
	elseif arg_7_0._defend_held then
		arg_7_0._defend_held = false
		var_7_0.action_two_release = true
	end

	if arg_7_0._cancel_held_ability then
		arg_7_0._cancel_held_ability = false
		arg_7_0._activate_ability = false
		arg_7_0._activate_ability_held = false
		var_7_0.action_two = true
	end

	if arg_7_0._activate_ability then
		arg_7_0._activate_ability = false

		if not arg_7_0._activate_ability_held then
			arg_7_0._activate_ability_held = true
			var_7_0.action_career = true
		end

		var_7_0.action_career_hold = true
	elseif arg_7_0._activate_ability_held then
		arg_7_0._activate_ability_held = false
		var_7_0.action_career_release = true
	end

	if arg_7_0._weapon_reload then
		arg_7_0._weapon_reload = false
		var_7_0.weapon_reload = true
		var_7_0.weapon_reload_hold = true
	end

	if arg_7_0._hold_attack then
		var_7_0.action_one = true
		var_7_0.action_one_hold = true
		arg_7_0._hold_attack = false
		arg_7_0._attack_held = true
	elseif arg_7_0._attack_held then
		arg_7_0._attack_held = false
		var_7_0.action_one_release = true
	elseif not arg_7_0._tap_attack_released then
		arg_7_0._tap_attack_released = true
		var_7_0.action_one_release = true
	elseif arg_7_0._tap_attack then
		arg_7_0._tap_attack_released = false
		arg_7_0._tap_attack = false
		var_7_0.action_one = true
	end

	if arg_7_0._charge_shot then
		arg_7_0._charge_shot = false
		var_7_0.action_two_hold = true

		if not arg_7_0._charge_shot_held then
			var_7_0.action_two = true
			arg_7_0._charge_shot_held = true
		end
	elseif arg_7_0._charge_shot_held then
		arg_7_0._charge_shot_held = false
		var_7_0.action_two_release = true
	end

	if arg_7_0._interact then
		arg_7_0._interact = false

		if not arg_7_0._interact_held then
			arg_7_0._interact_held = true
			var_7_0[InteractionHelper.interaction_action_names(arg_7_0.unit)] = true
		end

		var_7_0.interacting = true
	elseif arg_7_0._interact_held then
		arg_7_0._interact_held = false
	end

	local var_7_1 = arg_7_0._slot_to_wield

	if var_7_1 then
		arg_7_0._slot_to_wield = nil

		local var_7_2 = InventorySettings.slots
		local var_7_3 = #var_7_2
		local var_7_4

		for iter_7_0 = 1, var_7_3 do
			local var_7_5 = var_7_2[iter_7_0]

			if var_7_5.name == var_7_1 then
				var_7_4 = var_7_5.wield_input
			end
		end

		var_7_0[var_7_4] = true
	end

	if arg_7_0._dodge then
		var_7_0.dodge = true
		var_7_0.dodge_hold = true
		arg_7_0._dodge = false
	end
end

PlayerBotInput._update_debug_text = function (arg_8_0, arg_8_1, arg_8_2)
	if script_data.debug_unit ~= arg_8_1 or not script_data.ai_bots_input_debug then
		return
	end

	table.dump(arg_8_2, nil, nil, Debug.text)
end

PlayerBotInput.set_aim_position = function (arg_9_0, arg_9_1)
	arg_9_0._aim_target:store(arg_9_1)
end

PlayerBotInput.set_aim_rotation = function (arg_10_0, arg_10_1)
	arg_10_0._aim_rotation:store(arg_10_1)
end

PlayerBotInput.set_aiming = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_0._aiming = arg_11_1
	arg_11_0._aim_with_rotation = arg_11_3 and arg_11_1 or false

	if arg_11_1 and arg_11_2 then
		arg_11_0._soft_aiming = true
	else
		arg_11_0._soft_aiming = false
	end
end

PlayerBotInput.set_look_at_player = function (arg_12_0, arg_12_1, arg_12_2)
	arg_12_0._look_at_player = arg_12_1
	arg_12_0._look_at_player_rotation_allowed = not not arg_12_2
end

PlayerBotInput.defend = function (arg_13_0)
	arg_13_0._defend = true
end

PlayerBotInput.activate_ability = function (arg_14_0)
	arg_14_0._activate_ability = true
	arg_14_0._cancel_held_ability = false
end

PlayerBotInput.cancel_ability = function (arg_15_0)
	arg_15_0._cancel_held_ability = true
	arg_15_0._activate_ability = false
	arg_15_0._activate_ability_held = false
end

PlayerBotInput.release_ability_hold = function (arg_16_0)
	arg_16_0._activate_ability_held = true
end

PlayerBotInput.melee_push = function (arg_17_0)
	arg_17_0._melee_push = true
end

PlayerBotInput.hold_attack = function (arg_18_0)
	arg_18_0._hold_attack = true
end

PlayerBotInput.tap_attack = function (arg_19_0)
	arg_19_0._tap_attack = true
end

PlayerBotInput.charge_shot = function (arg_20_0)
	arg_20_0._charge_shot = true
end

PlayerBotInput.fire = function (arg_21_0)
	arg_21_0._fire = true
end

PlayerBotInput.fire_hold = function (arg_22_0)
	arg_22_0._fire_hold = true
end

PlayerBotInput.interact = function (arg_23_0)
	arg_23_0._interact = true
end

PlayerBotInput.weapon_reload = function (arg_24_0)
	arg_24_0._weapon_reload = true
end

PlayerBotInput.dodge = function (arg_25_0)
	arg_25_0._dodge = true
end

PlayerBotInput.wield = function (arg_26_0, arg_26_1)
	arg_26_0._slot_to_wield = arg_26_1
end

local var_0_1 = Quaternion.look
local var_0_2 = Quaternion.multiply
local var_0_3 = 0.010000000000000002
local var_0_4 = 99.995
local var_0_5 = 5e-05

PlayerBotInput._update_wanted_rotation_for_attract_mode = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	local var_27_0
	local var_27_1 = arg_27_0._navigation_extension
	local var_27_2 = arg_27_0._position_on_navmesh
	local var_27_3 = Vector3.up()
	local var_27_4

	if arg_27_3 and arg_27_4 then
		local var_27_5 = arg_27_3 - var_0_0[arg_27_0.unit]
		local var_27_6 = Quaternion.up(Unit.local_rotation(arg_27_5, 0))
		local var_27_7 = var_27_5.z

		if math.abs(var_27_7) < 0.05 then
			var_27_4 = arg_27_2
		elseif var_27_7 < 0 then
			var_27_4 = var_0_1(-var_27_6, var_27_3)
		else
			var_27_4 = var_0_1(var_27_6, var_27_3)
		end
	elseif arg_27_0._aiming and arg_27_0._aim_with_rotation then
		var_27_4 = Quaternion.lerp(arg_27_2, arg_27_0._aim_rotation:unbox(), math.min(arg_27_1 * 2, 1))

		Debug.text("AIMING W ROT")
	elseif arg_27_0._aiming and arg_27_0._soft_aiming then
		local var_27_8 = arg_27_0._aim_target:unbox() - arg_27_6

		var_27_4 = Quaternion.lerp(arg_27_2, var_0_1(var_27_8, var_27_3), math.min(arg_27_1 * 2, 1))

		Debug.text("SOFT AIMING")
	elseif arg_27_0._aiming then
		var_27_4 = var_0_1(arg_27_0._aim_target:unbox() - arg_27_6, var_27_3)
		var_27_4 = Quaternion.lerp(arg_27_2, var_27_4, math.min(arg_27_1 * 2, 1))

		Debug.text("AIMING")
	elseif arg_27_3 then
		Debug.text("CURRENT GOAL")

		local var_27_9 = arg_27_3 - var_27_2

		if var_27_1:is_in_transition() then
			var_27_0 = var_27_1:transition_requires_jump(var_27_2, Vector3.normalize(var_27_9))
			var_27_4 = var_0_1(var_27_9, var_27_3)
		else
			var_27_4 = Quaternion.lerp(arg_27_2, var_0_1(var_27_9, var_27_3), math.min(arg_27_1 * 2, 1))
		end
	else
		Debug.text("DEFAULT")

		var_27_4 = Quaternion.lerp(arg_27_2, Unit.local_rotation(arg_27_0.unit, 0), math.min(arg_27_1 * 1, 1))
	end

	return var_27_4, var_27_0
end

PlayerBotInput.set_bot_in_attract_mode_focus = function (arg_28_0, arg_28_1)
	arg_28_0._bot_in_attract_mode_focus = arg_28_1
end

local var_0_6 = 0.2
local var_0_7 = var_0_6 + 0.3
local var_0_8 = var_0_6^2
local var_0_9 = var_0_7^2

PlayerBotInput._obstacle_check = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	local var_29_0 = World.get_data(arg_29_0._world, "physics_world")
	local var_29_1 = "filter_ai_line_of_sight_check"
	local var_29_2 = 0.25
	local var_29_3 = 0.05
	local var_29_4 = 0.4
	local var_29_5 = math.abs(math.min(0.5, Vector3.length(arg_29_3) - var_29_3))
	local var_29_6
	local var_29_7
	local var_29_8

	if arg_29_2 > var_0_8 then
		var_29_6 = 0.4
		var_29_7 = 0.55
		var_29_8 = (0.8 - var_29_6) * 0.5
	else
		var_29_6 = 0.8
		var_29_7 = 0.1
		var_29_8 = 0
	end

	local var_29_9 = var_29_4 * 0.5
	local var_29_10 = var_29_5 * 0.5
	local var_29_11 = var_29_6 * 0.5
	local var_29_12 = 0.25 + var_29_8
	local var_29_13 = var_29_10 + var_29_7
	local var_29_14 = arg_29_1 + arg_29_4 * (var_29_10 + var_29_2) + Vector3(0, 0, 0.4 + var_29_11)
	local var_29_15 = var_29_14 + arg_29_4 * (var_29_13 - var_29_10) + Vector3(0, 0, var_29_12 + var_29_11)
	local var_29_16 = Vector3(var_29_9, var_29_10, var_29_11)
	local var_29_17 = Vector3(var_29_9, var_29_13, var_29_12)
	local var_29_18 = var_0_1(arg_29_4, arg_29_5)
	local var_29_19, var_29_20 = PhysicsWorld.immediate_overlap(var_29_0, "shape", "oobb", "position", var_29_14, "rotation", var_29_18, "size", var_29_16, "types", "statics", "collision_filter", var_29_1)
	local var_29_21 = var_29_20 > 0
	local var_29_22, var_29_23 = PhysicsWorld.immediate_overlap(var_29_0, "shape", "oobb", "position", var_29_15, "rotation", var_29_18, "size", var_29_17, "types", "statics", "collision_filter", var_29_1)
	local var_29_24 = var_29_23 > 0

	return var_29_21, var_29_24
end

PlayerBotInput._update_movement = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0.unit
	local var_30_1 = arg_30_0._navigation_extension
	local var_30_2 = var_30_1:current_goal()
	local var_30_3 = var_0_0[var_30_0]
	local var_30_4 = arg_30_0._position_on_navmesh
	local var_30_5 = arg_30_0._first_person_extension
	local var_30_6 = var_30_5:current_rotation()
	local var_30_7 = var_30_5:current_camera_position()
	local var_30_8
	local var_30_9 = arg_30_0._status_extension
	local var_30_10, var_30_11 = var_30_9:get_is_on_ladder()
	local var_30_12
	local var_30_13 = ALIVE[arg_30_0._look_at_player] and arg_30_0._look_at_player or nil
	local var_30_14 = var_30_13 and ScriptUnit.extension(var_30_13, "locomotion_system").has_moved_from_start_position
	local var_30_15 = Managers.state.entity:system("cutscene_system"):has_intro_cutscene_finished_playing()
	local var_30_16 = Vector3.up()

	if arg_30_0._bot_in_attract_mode_focus then
		var_30_8, var_30_12 = arg_30_0:_update_wanted_rotation_for_attract_mode(arg_30_1, var_30_6, var_30_2, var_30_10, var_30_11, var_30_7)
	elseif var_30_2 and var_30_10 then
		local var_30_17 = var_30_2 - var_30_3
		local var_30_18 = Quaternion.up(Unit.local_rotation(var_30_11, 0))
		local var_30_19 = var_30_17.z

		if math.abs(var_30_19) < 0.05 then
			var_30_8 = var_30_6
		elseif var_30_19 < 0 then
			var_30_8 = var_0_1(-var_30_18, var_30_16)
		else
			var_30_8 = var_0_1(var_30_18, var_30_16)
		end
	elseif arg_30_0._aiming and arg_30_0._aim_with_rotation then
		var_30_8 = arg_30_0._aim_rotation:unbox()
	elseif arg_30_0._aiming and arg_30_0._soft_aiming then
		local var_30_20 = arg_30_0._aim_target:unbox() - var_30_7

		var_30_8 = Quaternion.lerp(var_30_6, var_0_1(var_30_20, var_30_16), math.min(arg_30_1 * 5, 1))
	elseif arg_30_0._aiming then
		var_30_8 = var_0_1(arg_30_0._aim_target:unbox() - var_30_7, var_30_16)
	elseif var_30_13 and arg_30_0._game and (var_30_15 or var_30_14) and (not var_30_2 or not var_30_1:is_in_transition()) then
		local var_30_21 = Managers.state.network:unit_game_object_id(var_30_13)
		local var_30_22 = GameSession.game_object_field(arg_30_0._game, var_30_21, "aim_position") - var_30_7
		local var_30_23 = var_0_1(var_30_22, var_30_16)

		if not arg_30_0._look_at_player_rotation_allowed then
			local var_30_24 = Unit.local_rotation(var_30_0, 0)
			local var_30_25 = var_0_2(Quaternion.inverse(var_30_24), var_30_23)
			local var_30_26 = math.half_pi - 0.001
			local var_30_27 = math.clamp(Quaternion.yaw(var_30_25), -var_30_26, var_30_26)
			local var_30_28 = Quaternion.pitch(var_30_25)
			local var_30_29 = Quaternion(Vector3.up(), var_30_27)
			local var_30_30 = Quaternion(Vector3.right(), var_30_28)

			var_30_23 = var_0_2(var_30_24, var_0_2(var_30_29, var_30_30))
		end

		var_30_8 = Quaternion.lerp(var_30_6, var_30_23, math.min(arg_30_1 * 5, 1))
	elseif var_30_2 then
		local var_30_31 = var_30_2 - var_30_4

		if var_30_1:is_in_transition() then
			var_30_12 = var_30_1:transition_requires_jump(var_30_4, Vector3.normalize(var_30_31))
			var_30_8 = var_0_1(var_30_31, var_30_16)
		else
			var_30_8 = Quaternion.lerp(var_30_6, var_0_1(var_30_31, var_30_16), math.min(arg_30_1 * 2, 1))
		end
	else
		var_30_8 = Quaternion.lerp(var_30_6, Unit.local_rotation(var_30_0, 0), math.min(arg_30_1 * 2, 1))
	end

	local var_30_32 = var_0_2(Quaternion.inverse(var_30_6), var_30_8)
	local var_30_33 = Quaternion.forward(var_30_32)
	local var_30_34 = arg_30_0.look

	var_30_34.x = math.half_pi - math.atan2(var_30_33.y, var_30_33.x)
	var_30_34.y = math.asin(math.clamp(var_30_33.z, -1, 1))

	local var_30_35 = Unit.local_position(var_30_0, 0)

	arg_30_0._avoiding_aoe_threat = arg_30_0._ai_bot_group_system:is_inside_aoe_threat(var_30_35)

	if arg_30_0._avoiding_aoe_threat then
		var_30_2 = arg_30_0._ai_bot_group_extension.data.aoe_threat.escape_to:unbox()

		arg_30_0:dodge()
	end

	local var_30_36
	local var_30_37
	local var_30_38

	if var_30_2 then
		local var_30_39 = var_30_2 - var_30_4

		var_30_37 = Vector3.flat(var_30_39)
		var_30_38 = Vector3.normalize(var_30_37)

		if Vector3.length_squared(var_30_38) > 0 and not var_30_10 then
			local var_30_40 = arg_30_0._locomotion_extension:current_velocity()
			local var_30_41 = Vector3.length_squared(var_30_40)
			local var_30_42 = var_30_9:is_crouching()
			local var_30_43, var_30_44 = arg_30_0:_obstacle_check(var_30_3, var_30_41, var_30_39, var_30_38, var_30_16)

			if var_30_43 and not var_30_44 or var_30_12 then
				arg_30_0._input.jump_only = true
			elseif not var_30_43 and var_30_44 and (var_30_42 or var_30_41 <= var_0_9) then
				arg_30_0._input.crouching = true
			end
		end
	end

	local var_30_45 = arg_30_0.move

	if var_30_10 then
		if var_30_2 then
			var_30_45.x = 0
			var_30_45.y = 1
		else
			arg_30_0._input.jump_only = true
			var_30_45.x = 0
			var_30_45.y = 0
		end
	elseif not var_30_2 then
		var_30_45.x = 0
		var_30_45.y = 0
	else
		local var_30_46 = not arg_30_0._avoiding_aoe_threat and var_30_1:is_following_last_goal()
		local var_30_47 = 1

		if var_30_46 then
			local var_30_48 = Vector3.length_squared(var_30_37)

			if var_30_48 < var_0_3 then
				var_30_47 = var_0_4 * var_30_48 + var_0_5
			end
		end

		if arg_30_0._avoiding_aoe_threat and (not var_30_37 or Vector3.length_squared(var_30_37) < 0.0001) then
			if not var_30_1:destination_reached() then
				local function var_30_49()
					var_30_1:stop()
				end

				Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_30_49)
			end
		elseif not arg_30_0._avoiding_aoe_threat and arg_30_0._ai_bot_group_system:is_inside_aoe_threat(var_30_35 + var_30_38 * var_30_47) then
			var_30_45.x = 0
			var_30_45.y = 0
		else
			local var_30_50 = Vector3.flat(Quaternion.right(var_30_8))
			local var_30_51 = Vector3.flat(Quaternion.forward(var_30_8))

			var_30_45.x = var_30_47 * Vector3.dot(var_30_50, var_30_38)
			var_30_45.y = var_30_47 * Vector3.dot(var_30_51, var_30_38)
		end
	end
end

PlayerBotInput.is_input_blocked = function (arg_32_0)
	return false
end

PlayerBotInput.get = function (arg_33_0, arg_33_1)
	if arg_33_1 == "look" then
		return Vector3(arg_33_0.look.x, arg_33_0.look.y, 0)
	elseif arg_33_1 == "move_controller" then
		return Vector3(arg_33_0.move.x, arg_33_0.move.y, 0)
	elseif arg_33_0._input[arg_33_1] ~= nil then
		return arg_33_0._input[arg_33_1]
	end
end

PlayerBotInput.set_enabled = function (arg_34_0, arg_34_1)
	return
end

PlayerBotInput.get_buffer = function (arg_35_0, arg_35_1)
	return
end

PlayerBotInput.add_buffer = function (arg_36_0, arg_36_1)
	return
end

PlayerBotInput.reset_input_buffer = function (arg_37_0, arg_37_1)
	return
end

PlayerBotInput.clear_input_buffer = function (arg_38_0, arg_38_1)
	return
end

PlayerBotInput.reset_wield_switch_buffer = function (arg_39_0)
	return
end

PlayerBotInput.set_last_scroll_value = function (arg_40_0)
	return
end

PlayerBotInput.get_last_scroll_value = function (arg_41_0)
	return
end

PlayerBotInput.set_input_key_scale = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	return
end

PlayerBotInput.move = function (arg_43_0, arg_43_1)
	arg_43_0.move.x = arg_43_1.x
	arg_43_0.move.y = arg_43_1.y
end

PlayerBotInput.look = function (arg_44_0, arg_44_1)
	arg_44_0.look.x = arg_44_1.x
	arg_44_0.look.y = arg_44_1.y
end

PlayerBotInput.move_forward = function (arg_45_0)
	arg_45_0.move.x = 0
	arg_45_0.move.y = 1
end

PlayerBotInput.rotate_right = function (arg_46_0)
	arg_46_0.look.x = 0.1
	arg_46_0.look.y = 0
end

PlayerBotInput.not_moving = function (arg_47_0)
	return arg_47_0.move.x == 0 and arg_47_0.move.y == 0
end

PlayerBotInput.move_towards = function (arg_48_0, arg_48_1)
	arg_48_0.target_position = arg_48_1 and Vector3Box(arg_48_1) or nil
end

PlayerBotInput.get_wield_cooldown = function (arg_49_0)
	return false
end

PlayerBotInput.add_wield_cooldown = function (arg_50_0, arg_50_1)
	return
end

PlayerBotInput.released_input = function (arg_51_0, arg_51_1)
	return not arg_51_0._input[arg_51_1]
end

PlayerBotInput.released_softbutton_input = function (arg_52_0, arg_52_1, arg_52_2)
	return not arg_52_0._input[arg_52_1]
end

PlayerBotInput.add_stun_buffer = function (arg_53_0, arg_53_1)
	return
end

PlayerBotInput.reset_release_input = function (arg_54_0)
	return true
end

PlayerBotInput.reset_release_input_with_delay = function (arg_55_0)
	return true
end

PlayerBotInput.force_release_input = function (arg_56_0)
	return true
end

PlayerBotInput.avoiding_aoe_threat = function (arg_57_0)
	return arg_57_0._avoiding_aoe_threat
end
