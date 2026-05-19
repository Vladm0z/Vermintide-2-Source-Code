-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_hesitate_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTHesitateAction = class(BTHesitateAction, BTNode)

function BTHesitateAction.init(arg_1_0, ...)
	BTHesitateAction.super.init(arg_1_0, ...)
end

BTHesitateAction.name = "BTHesitateAction"

local var_0_0 = 5

if script_data.ai_hesitation_debug then
	var_0_0 = 26
end

local var_0_1 = 4
local var_0_2 = 4
local var_0_3 = 10
local var_0_4 = 0.3
local var_0_5 = 1.4
local var_0_6 = math.sin(math.pi / 3)
local var_0_7 = false
local var_0_8 = 1

function BTHesitateAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0

	arg_2_2.navigation_extension:set_enabled(false)
	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_2_1, true)

	arg_2_2.hesitation = 0

	arg_2_2.locomotion_extension:use_lerp_rotation(true)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, true, false, true)
	LocomotionUtils.set_animation_rotation_scale(arg_2_1, 1)
	AiUtils.enter_combat(arg_2_1, arg_2_2)
	arg_2_0:_select_new_hesitate_anim(arg_2_1, arg_2_2)

	arg_2_2.hesitate_wall = false
	arg_2_2.outnumber_multiplier = 1
	arg_2_2.outnumber_timer = arg_2_3 + 0.2 + Math.random() * 0.2
	arg_2_2.hesitating = true
	arg_2_2.hesitate_timer = nil
	arg_2_2.do_wall_check = var_2_0.do_wall_check
	arg_2_2.anim_cb_rotation_start = false
	arg_2_2.move_animation_name = nil

	if Math.random() > 0.5 and not arg_2_2.taunt_unit then
		arg_2_2.oh_shit_proximity_panic_override = true
	else
		arg_2_2.oh_shit_proximity_panic_override = false
	end

	arg_2_2.active_node = arg_2_0
	arg_2_2.move_state = "idle"
	arg_2_2.spawn_to_running = nil
end

function BTHesitateAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if not arg_3_5 then
		arg_3_2.locomotion_extension:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_3_1, false)
		LocomotionUtils.set_animation_rotation_scale(arg_3_1, 1)
	end

	AiUtils.activate_unit(arg_3_2)
	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.do_wall_check = nil
	arg_3_2.hesitate_wall = nil
	arg_3_2.hesitate_wall_rotation = nil
	arg_3_2.hesitate_wall_position = nil
	arg_3_2.last_hesitate_anim = nil
	arg_3_2.active_node = nil
	arg_3_2.outnumber_multiplier = nil
	arg_3_2.outnumber_timer = nil
	arg_3_2.oh_shit_proximity_panic_override = false
	arg_3_2.move_animation_name = nil
	arg_3_2.hesitating = false
	arg_3_2.hesitate_finished = nil
	arg_3_2.hesitate_fwd = nil

	if arg_3_2.taunt_unit then
		arg_3_2.taunt_hesitate_finished = true
		arg_3_2.no_taunt_hesitate = nil
	end
end

local var_0_9 = {}

function BTHesitateAction.anim_cb_hesitate_finished(arg_4_0, arg_4_1, arg_4_2)
	arg_4_2.hesitate_finished = true
end

function BTHesitateAction.set_unit_wall_hesitation(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_2.hesitate_wall_position and arg_5_2.hesitate_wall_position:unbox()

	if var_5_0 and hesitate_wall_rotation then
		local var_5_1 = Vector3.flat(var_5_0 - arg_5_3)

		if Vector3.dot(var_5_1, Quaternion.forward(hesitate_wall_rotation)) >= 0.05 then
			locomotion_extension:set_wanted_velocity_flat(var_5_1 * 2)
		else
			arg_5_2.hesitate_wall_position = nil

			LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, true)
		end
	end
end

function BTHesitateAction.wall_check(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = World.get_data(arg_6_2.world, "physics_world")
	local var_6_1 = arg_6_3 + Vector3(0, 0, 1)
	local var_6_2 = 1.5
	local var_6_3, var_6_4, var_6_5, var_6_6 = PhysicsWorld.immediate_raycast(var_6_0, var_6_1, arg_6_4, var_6_2, "closest", "types", "statics", "collision_filter", "filter_ai_line_of_sight_check")

	arg_6_2.do_wall_check = false

	if var_6_3 and (not var_0_7 or Vector3.dot(var_6_6, -arg_6_4) < var_0_6) then
		local var_6_7, var_6_8, var_6_9, var_6_10 = PhysicsWorld.immediate_raycast(var_6_0, var_6_1, -var_6_6, var_6_2, "closest", "types", "statics", "collision_filter", "filter_ai_line_of_sight_check")

		if var_6_7 then
			var_6_3 = var_6_7
			var_6_4 = var_6_8
			var_6_5 = var_6_9
			var_6_6 = var_6_10
		end
	end

	if var_6_3 then
		Managers.state.network:anim_event(arg_6_1, "hesitate_wall")

		arg_6_2.hesitate_wall = true
		arg_6_2.hesitate_wall_rotation = QuaternionBox(Quaternion.look(Vector3.flat(var_6_6), Vector3.up()))

		local var_6_11 = 1.2

		if var_6_5 < var_6_11 then
			arg_6_2.hesitate_wall_position = Vector3Box(var_6_4 + var_6_6 * var_6_11)

			LocomotionUtils.set_animation_driven_movement(arg_6_1, false)
		end
	elseif arg_6_2.last_hesitate_anim == "hesitate_bwd" then
		arg_6_0:_select_new_hesitate_anim(arg_6_1, arg_6_2)
	end
end

function BTHesitateAction.calculate_outnumber_multiplier(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0 = Vector3.distance_squared(arg_7_6, arg_7_5)
	local var_7_1 = var_0_1 / math.max(var_7_0 - var_0_2, 1) * arg_7_4 + arg_7_4
	local var_7_2

	if arg_7_2.taunt_unit then
		var_7_2 = 1
	elseif arg_7_3 < arg_7_2.outnumber_timer then
		arg_7_2.outnumber_timer = arg_7_3 + 0.2 + Math.random() * 0.2

		local var_7_3 = arg_7_2.group_blackboard.broadphase

		table.clear(var_0_9)
		Broadphase.query(var_7_3, arg_7_5, var_0_3, var_0_9)

		local var_7_4 = 0

		for iter_7_0 = 1, #var_0_9 do
			local var_7_5 = var_0_9[iter_7_0]
			local var_7_6 = ScriptUnit.extension(var_7_5, "ai_system"):blackboard()

			if var_7_6.confirmed_player_sighting or var_7_6.hesitating then
				var_7_4 = var_7_4 + 1
			end
		end

		local var_7_7 = 0
		local var_7_8 = arg_7_2.side.ENEMY_PLAYER_AND_BOT_POSITIONS

		for iter_7_1 = 1, #var_7_8 do
			if Vector3.distance_squared(arg_7_6, arg_7_5) < 36 then
				arg_7_2.oh_shit_proximity_panic_override = true
				arg_7_2.is_within_proximity = true
			end

			local var_7_9 = Vector3.distance(arg_7_6, var_7_8[iter_7_1])

			if var_7_9 < 100 then
				var_7_7 = var_7_7 + 1
			elseif var_7_9 < 225 then
				var_7_7 = var_7_7 + math.auto_lerp(10, 15, 1, 0, var_7_9)^2
			end
		end

		var_7_2 = 1.25 * (var_7_4 / math.max(var_7_7, 1))
		arg_7_2.outnumber_multiplier = var_7_2

		if var_7_7 < var_7_4 then
			arg_7_2.oh_shit_proximity_panic_override = true
		end
	else
		var_7_2 = arg_7_2.outnumber_multiplier
	end

	return var_7_2, var_7_1
end

function BTHesitateAction.start_move_animation(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_2.action
	local var_8_1 = arg_8_2.target_unit

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_8_1, true)
	arg_8_2.locomotion_extension:use_lerp_rotation(false)
	LocomotionUtils.set_animation_driven_movement(arg_8_1, true, false, false)

	local var_8_2 = AiAnimUtils.get_start_move_animation(arg_8_1, arg_8_3, arg_8_2.action.start_anims_name)

	assert(var_8_2, "Move animation was nil!  Have you added start_anims_name entry to breeds?")
	Managers.state.network:anim_event(arg_8_1, var_8_2)

	arg_8_2.move_animation_name = var_8_2
	arg_8_2.anim_locked = 0
	arg_8_2.spawn_to_running = true

	local var_8_3 = var_8_0.start_anims_name.fwd
	local var_8_4 = false

	if type(var_8_3) == "table" then
		for iter_8_0, iter_8_1 in pairs(var_8_3) do
			if iter_8_1 == var_8_2 then
				var_8_4 = true
			end
		end
	else
		var_8_4 = var_8_2 == var_8_3
	end

	arg_8_2.navigation_extension:set_enabled(true)

	arg_8_2.hesitate_fwd = var_8_4
end

function BTHesitateAction.run(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = script_data.ai_hesitation_debug
	local var_9_1 = arg_9_2.action

	arg_9_2.target_unit = nil

	local var_9_2 = arg_9_2.target_unit and Unit.alive(arg_9_2.target_unit)
	local var_9_3 = arg_9_2.is_within_proximity or arg_9_2.hesitate_finished or arg_9_2.previous_attacker and not arg_9_2.taunt_unit or not var_9_2

	if arg_9_2.confirmed_player_sighting or arg_9_2.no_hesitation or var_9_3 then
		if arg_9_2.hesitate_timer and arg_9_3 > arg_9_2.hesitate_timer and arg_9_2.anim_cb_move or var_9_3 then
			arg_9_2.spawn_to_running = arg_9_2.anim_cb_move

			return "done"
		elseif not arg_9_2.hesitate_timer then
			arg_9_2.hesitate_timer = arg_9_3 + math.lerp(var_0_4, var_0_5, Math.random())

			return "running"
		end
	end

	local var_9_4 = POSITION_LOOKUP[arg_9_1]
	local var_9_5 = arg_9_2.breed
	local var_9_6 = arg_9_2.locomotion_extension
	local var_9_7 = LocomotionUtils.rotation_towards_unit_flat(arg_9_1, arg_9_2.target_unit)
	local var_9_8 = arg_9_2.hesitate_wall_rotation and arg_9_2.hesitate_wall_rotation:unbox()

	if var_9_8 then
		var_9_7 = Quaternion.lerp(var_9_7, var_9_8, var_0_8)
	end

	var_9_6:set_wanted_rotation(var_9_7)

	if arg_9_2.do_wall_check then
		arg_9_0:set_unit_wall_hesitation(arg_9_1, arg_9_2, var_9_4)
	end

	local var_9_9 = POSITION_LOOKUP[arg_9_2.target_unit]
	local var_9_10, var_9_11 = arg_9_0:calculate_outnumber_multiplier(arg_9_1, arg_9_2, arg_9_3, arg_9_4, var_9_4, var_9_9)
	local var_9_12 = arg_9_2.hesitation + var_9_11 * arg_9_2.outnumber_multiplier
	local var_9_13 = arg_9_2.oh_shit_proximity_panic_override or arg_9_2.taunt_unit

	if var_9_12 > (var_9_5.hesitation_timer or var_0_0) or var_9_13 then
		if not (arg_9_2.move_animation_name and true) then
			local var_9_14 = arg_9_2.group_blackboard.broadphase

			AiUtils.alert_nearby_friends_of_enemy(arg_9_1, var_9_14, arg_9_2.target_unit)
			arg_9_0:start_move_animation(arg_9_1, arg_9_2, var_9_9)
		elseif not var_9_13 then
			Managers.state.network:anim_event(arg_9_1, "move_fwd")

			arg_9_2.move_state = "moving"

			return "done"
		end

		if arg_9_2.anim_cb_rotation_start then
			if arg_9_2.hesitate_fwd then
				local var_9_15 = arg_9_2.locomotion_extension

				var_9_15:use_lerp_rotation(true)
				LocomotionUtils.set_animation_driven_movement(arg_9_1, false)

				local var_9_16 = LocomotionUtils.rotation_towards_unit_flat(arg_9_1, arg_9_2.target_unit)

				var_9_15:set_wanted_rotation(var_9_16)
			elseif arg_9_2.move_animation_name then
				arg_9_2.anim_cb_rotation_start = false

				local var_9_17 = AiAnimUtils.get_animation_rotation_scale(arg_9_1, var_9_9, arg_9_2.move_animation_name, var_9_1.start_anims_data)

				LocomotionUtils.set_animation_rotation_scale(arg_9_1, var_9_17)
			end
		end

		if arg_9_2.anim_cb_move or arg_9_2.hesitate_finished and not var_9_13 then
			if arg_9_2.anim_cb_move then
				arg_9_2.move_state = "moving"
			end

			return "done"
		else
			return "running"
		end
	else
		arg_9_2.hesitation = var_9_12

		local var_9_18 = arg_9_2.nav_world
		local var_9_19 = -Quaternion.forward(var_9_7)

		if arg_9_2.do_wall_check and not GwNavQueries.raycango(var_9_18, var_9_4, var_9_4 + 0.5 * var_9_19) then
			arg_9_0:wall_check(arg_9_1, arg_9_2, var_9_4, var_9_19)
		end

		return "running"
	end
end

BTHesitationVariations = {
	hesitate = {
		"hesitate"
	},
	hesitate_bwd = {
		"hesitate_bwd_2",
		"hesitate_bwd_3",
		"hesitate_bwd_4",
		"hesitate_bwd_5",
		"hesitate_bwd_6",
		"hesitate_bwd"
	}
}

function BTHesitateAction._select_new_hesitate_anim(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0

	if not arg_10_2.do_wall_check then
		var_10_0 = "hesitate"
	elseif arg_10_2.last_hesitate_anim == "hesitate_bwd" then
		var_10_0 = Math.random() > 0.3333333333333333 and "hesitate" or "hesitate_bwd"
	else
		var_10_0 = Math.random() > 0.3333333333333333 and "hesitate_bwd" or "hesitate"
	end

	local var_10_1 = (arg_10_2.breed.BTHesitationVariations or BTHesitationVariations)[var_10_0]
	local var_10_2 = var_10_1[Math.random(1, #var_10_1)]

	Managers.state.network:anim_event(arg_10_1, var_10_2)

	arg_10_2.last_hesitate_anim = var_10_0
end
