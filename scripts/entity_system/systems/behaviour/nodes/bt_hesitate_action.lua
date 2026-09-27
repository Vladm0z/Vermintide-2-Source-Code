-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_hesitate_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTHesitateAction = class(BTHesitateAction, BTNode)

BTHesitateAction.init = function (arg_1_0, ...)
	-- function 1
	BTHesitateAction.super.init(arg_1_0, ...)
end

BTHesitateAction.name = "BTHesitateAction"

local num = 5

if not script_data.ai_hesitation_debug then
	num = 26
end

local num_2 = 4
local num_3 = 4
local num_4 = 10
local num_5 = 0.3
local num_6 = 1.4
local sin = math.sin(math.pi / 3)
local flag = false
local num_7 = 1

BTHesitateAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	arg_2_2.navigation_extension:set_enabled(false)
	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_2_1, true)

	arg_2_2.hesitation = 0

	arg_2_2.locomotion_extension:use_lerp_rotation(true)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, true, false, true)
	LocomotionUtils.set_animation_rotation_scale(arg_2_1, 1)
	AiUtils.enter_combat(arg_2_1, arg_2_2)
	self:_select_new_hesitate_anim(arg_2_1, arg_2_2)

	arg_2_2.hesitate_wall = false
	arg_2_2.outnumber_multiplier = 1
	arg_2_2.outnumber_timer = arg_2_3 + 0.2 + Math.random() * 0.2
	arg_2_2.hesitating = true
	arg_2_2.hesitate_timer = nil
	arg_2_2.do_wall_check = action_data.do_wall_check
	arg_2_2.anim_cb_rotation_start = false
	arg_2_2.move_animation_name = nil

	if not (not (Math.random() > 0.5) or arg_2_2.taunt_unit) then
		arg_2_2.oh_shit_proximity_panic_override = true
	else
		arg_2_2.oh_shit_proximity_panic_override = false
	end

	arg_2_2.active_node = self
	arg_2_2.move_state = "idle"
	arg_2_2.spawn_to_running = nil
end

BTHesitateAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
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

	if not arg_3_2.taunt_unit then
		arg_3_2.taunt_hesitate_finished = true
		arg_3_2.no_taunt_hesitate = nil
	end
end

local tbl = {}

BTHesitateAction.anim_cb_hesitate_finished = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	arg_4_2.hesitate_finished = true
end

BTHesitateAction.set_unit_wall_hesitation = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local hesitate_wall_position = arg_5_2.hesitate_wall_position

	hesitate_wall_position = not hesitate_wall_position and arg_5_2.hesitate_wall_position:unbox()

	if not hesitate_wall_position and not hesitate_wall_rotation then
		local flat = Vector3.flat(hesitate_wall_position - arg_5_3)

		if Vector3.dot(flat, Quaternion.forward(hesitate_wall_rotation)) >= 0.05 then
			locomotion_extension:set_wanted_velocity_flat(flat * 2)
		else
			arg_5_2.hesitate_wall_position = nil

			LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, true)
		end
	end
end

BTHesitateAction.wall_check = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local get_data = World.get_data(arg_6_2.world, "physics_world")
	local num = arg_6_3 + Vector3(0, 0, 1)
	local num_2 = 1.5
	local immediate_raycast, var_6_4, var_6_5, var_6_6 = PhysicsWorld.immediate_raycast(get_data, num, arg_6_4, num_2, "closest", "types", "statics", "collision_filter", "filter_ai_line_of_sight_check")

	arg_6_2.do_wall_check = false

	if not (not immediate_raycast and not flag and not (Vector3.dot(var_6_6, -arg_6_4) < sin)) then
		local immediate_raycast_2, var_6_8, var_6_9, var_6_10 = PhysicsWorld.immediate_raycast(get_data, num, -var_6_6, num_2, "closest", "types", "statics", "collision_filter", "filter_ai_line_of_sight_check")

		if not immediate_raycast_2 then
			immediate_raycast = immediate_raycast_2
			var_6_4 = var_6_8
			var_6_5 = var_6_9
			var_6_6 = var_6_10
		end
	end

	if not immediate_raycast then
		Managers.state.network:anim_event(arg_6_1, "hesitate_wall")

		arg_6_2.hesitate_wall = true
		arg_6_2.hesitate_wall_rotation = QuaternionBox(Quaternion.look(Vector3.flat(var_6_6), Vector3.up()))

		local num_3 = 1.2

		if var_6_5 < num_3 then
			arg_6_2.hesitate_wall_position = Vector3Box(var_6_4 + var_6_6 * num_3)

			LocomotionUtils.set_animation_driven_movement(arg_6_1, false)
		end
	elseif arg_6_2.last_hesitate_anim == "hesitate_bwd" then
		self:_select_new_hesitate_anim(arg_6_1, arg_6_2)
	end
end

BTHesitateAction.calculate_outnumber_multiplier = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	local distance_squared = Vector3.distance_squared(arg_7_6, arg_7_5)
	local num = num_2 / math.max(distance_squared - num_3, 1) * arg_7_4 + arg_7_4
	local var_7_2

	if not arg_7_2.taunt_unit then
		var_7_2 = 1
	elseif arg_7_3 < arg_7_2.outnumber_timer then
		arg_7_2.outnumber_timer = arg_7_3 + 0.2 + Math.random() * 0.2

		local broadphase = arg_7_2.group_blackboard.broadphase

		table.clear(tbl)
		Broadphase.query(broadphase, arg_7_5, num_4, tbl)

		local num_5 = 0

		for i = 1, #tbl do
			local var_7_5 = tbl[i]
			local blackboard = ScriptUnit.extension(var_7_5, "ai_system"):blackboard()

			if blackboard.confirmed_player_sighting or not blackboard.hesitating then
				num_5 = num_5 + 1
			end
		end

		local num_6 = 0
		local ENEMY_PLAYER_AND_BOT_POSITIONS = arg_7_2.side.ENEMY_PLAYER_AND_BOT_POSITIONS

		for j = 1, #ENEMY_PLAYER_AND_BOT_POSITIONS do
			if Vector3.distance_squared(arg_7_6, arg_7_5) < 36 then
				arg_7_2.oh_shit_proximity_panic_override = true
				arg_7_2.is_within_proximity = true
			end

			local distance = Vector3.distance(arg_7_6, ENEMY_PLAYER_AND_BOT_POSITIONS[j])

			if distance < 100 then
				num_6 = num_6 + 1
			elseif distance < 225 then
				num_6 = num_6 + math.auto_lerp(10, 15, 1, 0, distance)^2
			end
		end

		var_7_2 = 1.25 * (num_5 / math.max(num_6, 1))
		arg_7_2.outnumber_multiplier = var_7_2

		if num_6 < num_5 then
			arg_7_2.oh_shit_proximity_panic_override = true
		end
	else
		var_7_2 = arg_7_2.outnumber_multiplier
	end

	return var_7_2, num
end

BTHesitateAction.start_move_animation = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local action = arg_8_2.action
	local target_unit = arg_8_2.target_unit

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_8_1, true)
	arg_8_2.locomotion_extension:use_lerp_rotation(false)
	LocomotionUtils.set_animation_driven_movement(arg_8_1, true, false, false)

	local get_start_move_animation = AiAnimUtils.get_start_move_animation(arg_8_1, arg_8_3, arg_8_2.action.start_anims_name)

	assert(get_start_move_animation, "Move animation was nil!  Have you added start_anims_name entry to breeds?")
	Managers.state.network:anim_event(arg_8_1, get_start_move_animation)

	arg_8_2.move_animation_name = get_start_move_animation
	arg_8_2.anim_locked = 0
	arg_8_2.spawn_to_running = true

	local fwd = action.start_anims_name.fwd
	local flag = false

	if type(fwd) == "table" then
		for k, v in pairs(fwd) do
			if v == get_start_move_animation then
				flag = true
			end
		end
	else
		flag = get_start_move_animation == fwd
	end

	arg_8_2.navigation_extension:set_enabled(true)

	arg_8_2.hesitate_fwd = flag
end

BTHesitateAction.run = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local ai_hesitation_debug = script_data.ai_hesitation_debug
	local action = arg_9_2.action

	arg_9_2.target_unit = nil

	local target_unit = arg_9_2.target_unit

	target_unit = not target_unit and Unit.alive(arg_9_2.target_unit)

	local is_within_proximity = arg_9_2.is_within_proximity

	if not is_within_proximity then
		is_within_proximity = arg_9_2.hesitate_finished
		is_within_proximity = is_within_proximity or not arg_9_2.previous_attacker or not not arg_9_2.taunt_unit or not target_unit
	end

	local confirmed_player_sighting = arg_9_2.confirmed_player_sighting

	if not confirmed_player_sighting then
		confirmed_player_sighting = arg_9_2.no_hesitation
		confirmed_player_sighting = confirmed_player_sighting or is_within_proximity
	end

	if not confirmed_player_sighting then
		local hesitate_timer = arg_9_2.hesitate_timer

		hesitate_timer = not hesitate_timer and arg_9_3 > arg_9_2.hesitate_timer

		local anim_cb_move

		if not hesitate_timer then
			anim_cb_move = arg_9_2.anim_cb_move

			if not anim_cb_move then
				-- Nothing
			end
		end

		anim_cb_move = is_within_proximity

		::label_9_0::

		if not anim_cb_move then
			arg_9_2.spawn_to_running = arg_9_2.anim_cb_move

			return "done"
		elseif not arg_9_2.hesitate_timer then
			arg_9_2.hesitate_timer = arg_9_3 + math.lerp(num_5, num_6, Math.random())

			return "running"
		end
	end

	local var_9_7 = POSITION_LOOKUP[arg_9_1]
	local breed = arg_9_2.breed
	local locomotion_extension = arg_9_2.locomotion_extension
	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_9_1, arg_9_2.target_unit)
	local hesitate_wall_rotation = arg_9_2.hesitate_wall_rotation

	hesitate_wall_rotation = not hesitate_wall_rotation and arg_9_2.hesitate_wall_rotation:unbox()

	if not hesitate_wall_rotation then
		rotation_towards_unit_flat = Quaternion.lerp(rotation_towards_unit_flat, hesitate_wall_rotation, num_7)
	end

	locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)

	if not arg_9_2.do_wall_check then
		self:set_unit_wall_hesitation(arg_9_1, arg_9_2, var_9_7)
	end

	local var_9_12 = POSITION_LOOKUP[arg_9_2.target_unit]
	local calculate_outnumber_multiplier, var_9_14 = self:calculate_outnumber_multiplier(arg_9_1, arg_9_2, arg_9_3, arg_9_4, var_9_7, var_9_12)
	local num_2 = arg_9_2.hesitation + var_9_14 * arg_9_2.outnumber_multiplier
	local oh_shit_proximity_panic_override = arg_9_2.oh_shit_proximity_panic_override

	oh_shit_proximity_panic_override = oh_shit_proximity_panic_override or arg_9_2.taunt_unit

	local hesitation_timer = breed.hesitation_timer

	hesitation_timer = hesitation_timer or num

	if not (hesitation_timer < num_2 or oh_shit_proximity_panic_override) then
		local move_animation_name = arg_9_2.move_animation_name

		move_animation_name = not move_animation_name and true

		if not move_animation_name then
			local broadphase = arg_9_2.group_blackboard.broadphase

			AiUtils.alert_nearby_friends_of_enemy(arg_9_1, broadphase, arg_9_2.target_unit)
			self:start_move_animation(arg_9_1, arg_9_2, var_9_12)
		elseif not oh_shit_proximity_panic_override then
			Managers.state.network:anim_event(arg_9_1, "move_fwd")

			arg_9_2.move_state = "moving"

			return "done"
		end

		if not arg_9_2.anim_cb_rotation_start then
			if not arg_9_2.hesitate_fwd then
				local locomotion_extension_2 = arg_9_2.locomotion_extension

				locomotion_extension_2:use_lerp_rotation(true)
				LocomotionUtils.set_animation_driven_movement(arg_9_1, false)

				local rotation_towards_unit_flat_2 = LocomotionUtils.rotation_towards_unit_flat(arg_9_1, arg_9_2.target_unit)

				locomotion_extension_2:set_wanted_rotation(rotation_towards_unit_flat_2)
			elseif not arg_9_2.move_animation_name then
				arg_9_2.anim_cb_rotation_start = false

				local get_animation_rotation_scale = AiAnimUtils.get_animation_rotation_scale(arg_9_1, var_9_12, arg_9_2.move_animation_name, action.start_anims_data)

				LocomotionUtils.set_animation_rotation_scale(arg_9_1, get_animation_rotation_scale)
			end
		end

		local anim_cb_move_2 = arg_9_2.anim_cb_move

		if not anim_cb_move_2 then
			anim_cb_move_2 = arg_9_2.hesitate_finished
			anim_cb_move_2 = not anim_cb_move_2 and not oh_shit_proximity_panic_override
		end

		if not anim_cb_move_2 then
			if not arg_9_2.anim_cb_move then
				arg_9_2.move_state = "moving"
			end

			return "done"
		else
			return "running"
		end
	else
		arg_9_2.hesitation = num_2

		local nav_world = arg_9_2.nav_world
		local num_3 = -Quaternion.forward(rotation_towards_unit_flat)

		if not (not arg_9_2.do_wall_check and GwNavQueries.raycango(nav_world, var_9_7, var_9_7 + 0.5 * num_3)) then
			self:wall_check(arg_9_1, arg_9_2, var_9_7, num_3)
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

BTHesitateAction._select_new_hesitate_anim = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local var_10_0

	if not arg_10_2.do_wall_check then
		var_10_0 = "hesitate"
	elseif arg_10_2.last_hesitate_anim == "hesitate_bwd" then
		var_10_0 = not (Math.random() > 0.3333333333333333) or not "hesitate" or "hesitate_bwd"
	else
		var_10_0 = not (Math.random() > 0.3333333333333333) or not "hesitate_bwd" or "hesitate"
	end

	local BTHesitationVariations = arg_10_2.breed.BTHesitationVariations

	BTHesitationVariations = BTHesitationVariations or BTHesitationVariations

	local var_10_2 = BTHesitationVariations[var_10_0]
	local var_10_3 = var_10_2[Math.random(1, #var_10_2)]

	Managers.state.network:anim_event(arg_10_1, var_10_3)

	arg_10_2.last_hesitate_anim = var_10_0
end
