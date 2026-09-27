-- chunkname: @scripts/unit_extensions/human/player_bot_unit/player_bot_input.lua

require("scripts/unit_extensions/generic/generic_state_machine")

PlayerBotInput = class(PlayerBotInput)

local POSITION_LOOKUP = POSITION_LOOKUP

PlayerBotInput.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.move = {
		x = 0,
		y = 0
	}
	self.look = {
		x = 0,
		y = 0
	}
	self._aim_target = Vector3Box(0, 0, 0)
	self._aim_rotation = QuaternionBox(0, 0, 0)
	self._aiming = false
	self._soft_aiming = false
	self._charge_shot = false
	self._charge_shot_held = false
	self._fire_hold = false
	self._fire = false
	self._fire_held = false
	self._defend = false
	self._defend_held = false
	self._melee_push = false
	self._hold_attack = false
	self._tap_attack = false
	self._tap_attack_released = true
	self._interact = false
	self._interact_held = false
	self._activate_ability = false
	self._activate_ability_held = false
	self._cancel_held_ability = false
	self._weapon_reload = false
	self._dodge = false
	self._bot_in_attract_mode_focus = false
	self._avoiding_aoe_threat = false
	self.double_tap_dodge = false
	self.minimum_dodge_input = 0
	self._input = {}
	self._look_at_player = nil
	self._look_at_player_rotation_allowed = false
	self._world = arg_1_1.world
	self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self._game = Managers.state.network:game()
end

PlayerBotInput.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	local extension = ScriptUnit.extension

	self._navigation_extension = extension(arg_2_2, "ai_navigation_system")
	self._status_extension = extension(arg_2_2, "status_system")
	self._first_person_extension = extension(arg_2_2, "first_person_system")
	self._ai_bot_group_extension = extension(arg_2_2, "ai_bot_group_system")
	self._locomotion_extension = extension(arg_2_2, "locomotion_system")
	self._ai_bot_group_system = Managers.state.entity:system("ai_bot_group_system")
end

PlayerBotInput.destroy = function (arg_3_0)
	-- function 3
	return
end

PlayerBotInput.reset = function (arg_4_0)
	-- function 4
	return
end

PlayerBotInput.pre_update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local triangle_from_position, var_5_2 = GwNavQueries.triangle_from_position(self._nav_world, var_5_0, 1.1, 0.5)
	local var_5_3

	if not triangle_from_position then
		var_5_3 = Vector3(var_5_0.x, var_5_0.y, var_5_2)

		if not var_5_3 then
			-- Nothing
		end
	end

	var_5_3 = var_5_0

	::label_5_0::

	self._position_on_navmesh = var_5_3
end

PlayerBotInput.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	table.clear(self._input)
	self:_update_movement(arg_6_3, arg_6_5)
	self:_update_actions()
end

PlayerBotInput._update_actions = function (self)
	-- function 7
	local _input = self._input

	if not self._fire_hold then
		self._fire_hold = false
		_input.action_one_hold = true

		if not self._fire_held then
			_input.action_one = true
			self._fire_held = true
		end
	elseif not self._fire_held then
		self._fire_held = false
		_input.action_one_release = true
	elseif not self._fire then
		self._fire = false
		_input.action_one = true
	end

	if not self._melee_push then
		self._melee_push = false
		self._defend = false

		if not self._defend_held then
			_input.action_one = true
		else
			self._defend_held = true
			_input.action_two = true
		end

		_input.action_two_hold = true
	elseif not self._defend then
		self._defend = false

		if not self._defend_held then
			self._defend_held = true
			_input.action_two = true
		end

		_input.action_two_hold = true
	elseif not self._defend_held then
		self._defend_held = false
		_input.action_two_release = true
	end

	if not self._cancel_held_ability then
		self._cancel_held_ability = false
		self._activate_ability = false
		self._activate_ability_held = false
		_input.action_two = true
	end

	if not self._activate_ability then
		self._activate_ability = false

		if not self._activate_ability_held then
			self._activate_ability_held = true
			_input.action_career = true
		end

		_input.action_career_hold = true
	elseif not self._activate_ability_held then
		self._activate_ability_held = false
		_input.action_career_release = true
	end

	if not self._weapon_reload then
		self._weapon_reload = false
		_input.weapon_reload = true
		_input.weapon_reload_hold = true
	end

	if not self._hold_attack then
		_input.action_one = true
		_input.action_one_hold = true
		self._hold_attack = false
		self._attack_held = true
	elseif not self._attack_held then
		self._attack_held = false
		_input.action_one_release = true
	elseif not self._tap_attack_released then
		self._tap_attack_released = true
		_input.action_one_release = true
	elseif not self._tap_attack then
		self._tap_attack_released = false
		self._tap_attack = false
		_input.action_one = true
	end

	if not self._charge_shot then
		self._charge_shot = false
		_input.action_two_hold = true

		if not self._charge_shot_held then
			_input.action_two = true
			self._charge_shot_held = true
		end
	elseif not self._charge_shot_held then
		self._charge_shot_held = false
		_input.action_two_release = true
	end

	if not self._interact then
		self._interact = false

		if not self._interact_held then
			self._interact_held = true
			_input[InteractionHelper.interaction_action_names(self.unit)] = true
		end

		_input.interacting = true
	elseif not self._interact_held then
		self._interact_held = false
	end

	local _slot_to_wield = self._slot_to_wield

	if not _slot_to_wield then
		self._slot_to_wield = nil

		local slots = InventorySettings.slots
		local count = #slots
		local var_7_4

		for i = 1, count do
			local var_7_5 = slots[i]

			if var_7_5.name == _slot_to_wield then
				var_7_4 = var_7_5.wield_input
			end
		end

		_input[var_7_4] = true
	end

	if not self._dodge then
		_input.dodge = true
		_input.dodge_hold = true
		self._dodge = false
	end
end

PlayerBotInput._update_debug_text = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	if not (script_data.debug_unit ~= arg_8_1 or script_data.ai_bots_input_debug) then
		return
	end

	table.dump(arg_8_2, nil, nil, Debug.text)
end

PlayerBotInput.set_aim_position = function (self, arg_9_1)
	-- function 9
	self._aim_target:store(arg_9_1)
end

PlayerBotInput.set_aim_rotation = function (self, arg_10_1)
	-- function 10
	self._aim_rotation:store(arg_10_1)
end

PlayerBotInput.set_aiming = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	self._aiming = arg_11_1
	self._aim_with_rotation = not arg_11_3 and arg_11_1 and false

	if not arg_11_1 and not arg_11_2 then
		self._soft_aiming = true
	else
		self._soft_aiming = false
	end
end

PlayerBotInput.set_look_at_player = function (self, arg_12_1, arg_12_2)
	-- function 12
	self._look_at_player = arg_12_1
	self._look_at_player_rotation_allowed = not not arg_12_2
end

PlayerBotInput.defend = function (self)
	-- function 13
	self._defend = true
end

PlayerBotInput.activate_ability = function (self)
	-- function 14
	self._activate_ability = true
	self._cancel_held_ability = false
end

PlayerBotInput.cancel_ability = function (self)
	-- function 15
	self._cancel_held_ability = true
	self._activate_ability = false
	self._activate_ability_held = false
end

PlayerBotInput.release_ability_hold = function (self)
	-- function 16
	self._activate_ability_held = true
end

PlayerBotInput.melee_push = function (self)
	-- function 17
	self._melee_push = true
end

PlayerBotInput.hold_attack = function (self)
	-- function 18
	self._hold_attack = true
end

PlayerBotInput.tap_attack = function (self)
	-- function 19
	self._tap_attack = true
end

PlayerBotInput.charge_shot = function (self)
	-- function 20
	self._charge_shot = true
end

PlayerBotInput.fire = function (self)
	-- function 21
	self._fire = true
end

PlayerBotInput.fire_hold = function (self)
	-- function 22
	self._fire_hold = true
end

PlayerBotInput.interact = function (self)
	-- function 23
	self._interact = true
end

PlayerBotInput.weapon_reload = function (self)
	-- function 24
	self._weapon_reload = true
end

PlayerBotInput.dodge = function (self)
	-- function 25
	self._dodge = true
end

PlayerBotInput.wield = function (self, arg_26_1)
	-- function 26
	self._slot_to_wield = arg_26_1
end

local look = Quaternion.look
local multiply = Quaternion.multiply
local num = 0.010000000000000002
local num_2 = 99.995
local num_3 = 5e-05

PlayerBotInput._update_wanted_rotation_for_attract_mode = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	-- function 27
	local var_27_0
	local _navigation_extension = self._navigation_extension
	local _position_on_navmesh = self._position_on_navmesh
	local up = Vector3.up()
	local var_27_4

	if not arg_27_3 and not arg_27_4 then
		local num = arg_27_3 - POSITION_LOOKUP[self.unit]
		local up_2 = Quaternion.up(Unit.local_rotation(arg_27_5, 0))
		local z = num.z

		if math.abs(z) < 0.05 then
			var_27_4 = arg_27_2
		elseif z < 0 then
			var_27_4 = look(-up_2, up)
		else
			var_27_4 = look(up_2, up)
		end
	elseif not self._aiming and not self._aim_with_rotation then
		var_27_4 = Quaternion.lerp(arg_27_2, self._aim_rotation:unbox(), math.min(arg_27_1 * 2, 1))

		Debug.text("AIMING W ROT")
	elseif not self._aiming and not self._soft_aiming then
		local num_2 = self._aim_target:unbox() - arg_27_6

		var_27_4 = Quaternion.lerp(arg_27_2, look(num_2, up), math.min(arg_27_1 * 2, 1))

		Debug.text("SOFT AIMING")
	elseif not self._aiming then
		var_27_4 = look(self._aim_target:unbox() - arg_27_6, up)
		var_27_4 = Quaternion.lerp(arg_27_2, var_27_4, math.min(arg_27_1 * 2, 1))

		Debug.text("AIMING")
	elseif not arg_27_3 then
		Debug.text("CURRENT GOAL")

		local num_3 = arg_27_3 - _position_on_navmesh

		if not _navigation_extension:is_in_transition() then
			var_27_0 = _navigation_extension:transition_requires_jump(_position_on_navmesh, Vector3.normalize(num_3))
			var_27_4 = look(num_3, up)
		else
			var_27_4 = Quaternion.lerp(arg_27_2, look(num_3, up), math.min(arg_27_1 * 2, 1))
		end
	else
		Debug.text("DEFAULT")

		var_27_4 = Quaternion.lerp(arg_27_2, Unit.local_rotation(self.unit, 0), math.min(arg_27_1 * 1, 1))
	end

	return var_27_4, var_27_0
end

PlayerBotInput.set_bot_in_attract_mode_focus = function (self, arg_28_1)
	-- function 28
	self._bot_in_attract_mode_focus = arg_28_1
end

local num_4 = 0.2
local num_5 = num_4 + 0.3
local num_6 = num_4^2
local num_7 = num_5^2

PlayerBotInput._obstacle_check = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	-- function 29
	local get_data = World.get_data(self._world, "physics_world")
	local str = "filter_ai_line_of_sight_check"
	local num = 0.25
	local num_2 = 0.05
	local num_3 = 0.4
	local abs = math.abs(math.min(0.5, Vector3.length(arg_29_3) - num_2))
	local var_29_6
	local var_29_7
	local var_29_8

	if arg_29_2 > num_6 then
		var_29_6 = 0.4
		var_29_7 = 0.55
		var_29_8 = (0.8 - var_29_6) * 0.5
	else
		var_29_6 = 0.8
		var_29_7 = 0.1
		var_29_8 = 0
	end

	local num_4 = num_3 * 0.5
	local num_5 = abs * 0.5
	local num_7 = var_29_6 * 0.5
	local num_8 = 0.25 + var_29_8
	local num_9 = num_5 + var_29_7
	local num_10 = arg_29_1 + arg_29_4 * (num_5 + num) + Vector3(0, 0, 0.4 + num_7)
	local num_11 = num_10 + arg_29_4 * (num_9 - num_5) + Vector3(0, 0, num_8 + num_7)
	local var_29_16 = Vector3(num_4, num_5, num_7)
	local var_29_17 = Vector3(num_4, num_9, num_8)
	local var_29_18 = look(arg_29_4, arg_29_5)
	local immediate_overlap, var_29_20 = PhysicsWorld.immediate_overlap(get_data, "shape", "oobb", "position", num_10, "rotation", var_29_18, "size", var_29_16, "types", "statics", "collision_filter", str)
	local flag = var_29_20 > 0
	local immediate_overlap_2, var_29_23 = PhysicsWorld.immediate_overlap(get_data, "shape", "oobb", "position", num_11, "rotation", var_29_18, "size", var_29_17, "types", "statics", "collision_filter", str)
	local flag_2 = var_29_23 > 0

	return flag, flag_2
end

PlayerBotInput._update_movement = function (self, arg_30_1, arg_30_2)
	-- function 30
	local unit = self.unit
	local _navigation_extension = self._navigation_extension
	local current_goal = _navigation_extension:current_goal()
	local var_30_3 = POSITION_LOOKUP[unit]
	local _position_on_navmesh = self._position_on_navmesh
	local _first_person_extension = self._first_person_extension
	local current_rotation = _first_person_extension:current_rotation()
	local current_camera_position = _first_person_extension:current_camera_position()
	local var_30_8
	local _status_extension = self._status_extension
	local get_is_on_ladder, var_30_11 = _status_extension:get_is_on_ladder()
	local var_30_12
	local _look_at_player

	if not ALIVE[self._look_at_player] then
		_look_at_player = self._look_at_player

		if not _look_at_player then
			-- Nothing
		end
	end

	_look_at_player = nil

	::label_30_0::

	local flag = not _look_at_player and ScriptUnit.extension(_look_at_player, "locomotion_system").has_moved_from_start_position
	local has_intro_cutscene_finished_playing = Managers.state.entity:system("cutscene_system"):has_intro_cutscene_finished_playing()
	local up = Vector3.up()

	if not self._bot_in_attract_mode_focus then
		var_30_8, var_30_12 = self:_update_wanted_rotation_for_attract_mode(arg_30_1, current_rotation, current_goal, get_is_on_ladder, var_30_11, current_camera_position)
	elseif not current_goal and not get_is_on_ladder then
		local num_4 = current_goal - var_30_3
		local up_2 = Quaternion.up(Unit.local_rotation(var_30_11, 0))
		local z = num_4.z

		if math.abs(z) < 0.05 then
			var_30_8 = current_rotation
		elseif z < 0 then
			var_30_8 = look(-up_2, up)
		else
			var_30_8 = look(up_2, up)
		end
	elseif not self._aiming and not self._aim_with_rotation then
		var_30_8 = self._aim_rotation:unbox()
	elseif not self._aiming and not self._soft_aiming then
		local num_5 = self._aim_target:unbox() - current_camera_position

		var_30_8 = Quaternion.lerp(current_rotation, look(num_5, up), math.min(arg_30_1 * 5, 1))
	elseif not self._aiming then
		var_30_8 = look(self._aim_target:unbox() - current_camera_position, up)
	elseif not (not _look_at_player and not self._game and has_intro_cutscene_finished_playing and not flag and not current_goal and _navigation_extension:is_in_transition()) then
		local unit_game_object_id = Managers.state.network:unit_game_object_id(_look_at_player)
		local num_6 = GameSession.game_object_field(self._game, unit_game_object_id, "aim_position") - current_camera_position
		local var_30_23 = look(num_6, up)

		if not self._look_at_player_rotation_allowed then
			local local_rotation = Unit.local_rotation(unit, 0)
			local var_30_25 = multiply(Quaternion.inverse(local_rotation), var_30_23)
			local num_8 = math.half_pi - 0.001
			local clamp = math.clamp(Quaternion.yaw(var_30_25), -num_8, num_8)
			local pitch = Quaternion.pitch(var_30_25)
			local var_30_29 = Quaternion(Vector3.up(), clamp)
			local var_30_30 = Quaternion(Vector3.right(), pitch)

			var_30_23 = multiply(local_rotation, multiply(var_30_29, var_30_30))
		end

		var_30_8 = Quaternion.lerp(current_rotation, var_30_23, math.min(arg_30_1 * 5, 1))
	elseif not current_goal then
		local num_9 = current_goal - _position_on_navmesh

		if not _navigation_extension:is_in_transition() then
			var_30_12 = _navigation_extension:transition_requires_jump(_position_on_navmesh, Vector3.normalize(num_9))
			var_30_8 = look(num_9, up)
		else
			var_30_8 = Quaternion.lerp(current_rotation, look(num_9, up), math.min(arg_30_1 * 2, 1))
		end
	else
		var_30_8 = Quaternion.lerp(current_rotation, Unit.local_rotation(unit, 0), math.min(arg_30_1 * 2, 1))
	end

	local var_30_32 = multiply(Quaternion.inverse(current_rotation), var_30_8)
	local forward = Quaternion.forward(var_30_32)
	local look_2 = self.look

	look_2.x = math.half_pi - math.atan2(forward.y, forward.x)
	look_2.y = math.asin(math.clamp(forward.z, -1, 1))

	local local_position = Unit.local_position(unit, 0)

	self._avoiding_aoe_threat = self._ai_bot_group_system:is_inside_aoe_threat(local_position)

	if not self._avoiding_aoe_threat then
		current_goal = self._ai_bot_group_extension.data.aoe_threat.escape_to:unbox()

		self:dodge()
	end

	local var_30_36
	local var_30_37
	local var_30_38

	if not current_goal then
		local num_10 = current_goal - _position_on_navmesh

		var_30_37 = Vector3.flat(num_10)
		var_30_38 = Vector3.normalize(var_30_37)

		if not (not (Vector3.length_squared(var_30_38) > 0) or get_is_on_ladder) then
			local current_velocity = self._locomotion_extension:current_velocity()
			local length_squared = Vector3.length_squared(current_velocity)
			local is_crouching = _status_extension:is_crouching()
			local _obstacle_check, var_30_44 = self:_obstacle_check(var_30_3, length_squared, num_10, var_30_38, up)

			if not _obstacle_check and var_30_44 and not var_30_12 then
				self._input.jump_only = true
			elseif not ((_obstacle_check or not var_30_44) and is_crouching or not (length_squared <= num_7)) then
				self._input.crouching = true
			end
		end
	end

	local move = self.move

	if not get_is_on_ladder then
		if not current_goal then
			move.x = 0
			move.y = 1
		else
			self._input.jump_only = true
			move.x = 0
			move.y = 0
		end
	elseif not current_goal then
		move.x = 0
		move.y = 0
	else
		local flag_2 = not not self._avoiding_aoe_threat or _navigation_extension:is_following_last_goal()
		local num_11 = 1

		if not flag_2 then
			local length_squared_2 = Vector3.length_squared(var_30_37)

			if length_squared_2 < num then
				num_11 = num_2 * length_squared_2 + num_3
			end
		end

		if not (not self._avoiding_aoe_threat and not var_30_37 and not (Vector3.length_squared(var_30_37) < 0.0001)) then
			if not _navigation_extension:destination_reached() then
				local function fn()
					-- function 31
					_navigation_extension:stop()
				end

				Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn)
			end
		elseif self._avoiding_aoe_threat or not self._ai_bot_group_system:is_inside_aoe_threat(local_position + var_30_38 * num_11) then
			move.x = 0
			move.y = 0
		else
			local flat = Vector3.flat(Quaternion.right(var_30_8))
			local flat_2 = Vector3.flat(Quaternion.forward(var_30_8))

			move.x = num_11 * Vector3.dot(flat, var_30_38)
			move.y = num_11 * Vector3.dot(flat_2, var_30_38)
		end
	end
end

PlayerBotInput.is_input_blocked = function (arg_32_0)
	-- function 32
	return false
end

PlayerBotInput.get = function (self, arg_33_1)
	-- function 33
	if arg_33_1 == "look" then
		return Vector3(self.look.x, self.look.y, 0)
	elseif arg_33_1 == "move_controller" then
		return Vector3(self.move.x, self.move.y, 0)
	elseif self._input[arg_33_1] ~= nil then
		return self._input[arg_33_1]
	end
end

PlayerBotInput.set_enabled = function (arg_34_0, arg_34_1)
	-- function 34
	return
end

PlayerBotInput.get_buffer = function (arg_35_0, arg_35_1)
	-- function 35
	return
end

PlayerBotInput.add_buffer = function (arg_36_0, arg_36_1)
	-- function 36
	return
end

PlayerBotInput.reset_input_buffer = function (arg_37_0, arg_37_1)
	-- function 37
	return
end

PlayerBotInput.clear_input_buffer = function (arg_38_0, arg_38_1)
	-- function 38
	return
end

PlayerBotInput.reset_wield_switch_buffer = function (arg_39_0)
	-- function 39
	return
end

PlayerBotInput.set_last_scroll_value = function (arg_40_0)
	-- function 40
	return
end

PlayerBotInput.get_last_scroll_value = function (arg_41_0)
	-- function 41
	return
end

PlayerBotInput.set_input_key_scale = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	return
end

PlayerBotInput.move = function (arg_43_0, arg_43_1)
	-- function 43
	arg_43_0.move.x = arg_43_1.x
	arg_43_0.move.y = arg_43_1.y
end

PlayerBotInput.look = function (arg_44_0, arg_44_1)
	-- function 44
	arg_44_0.look.x = arg_44_1.x
	arg_44_0.look.y = arg_44_1.y
end

PlayerBotInput.move_forward = function (arg_45_0)
	-- function 45
	arg_45_0.move.x = 0
	arg_45_0.move.y = 1
end

PlayerBotInput.rotate_right = function (arg_46_0)
	-- function 46
	arg_46_0.look.x = 0.1
	arg_46_0.look.y = 0
end

PlayerBotInput.not_moving = function (self)
	-- function 47
	return self.move.x ~= 0 or self.move.y == 0
end

PlayerBotInput.move_towards = function (self, arg_48_1)
	-- function 48
	local var_48_0

	if not arg_48_1 then
		var_48_0 = Vector3Box(arg_48_1)

		if not var_48_0 then
			-- Nothing
		end
	end

	var_48_0 = nil

	::label_48_0::

	self.target_position = var_48_0
end

PlayerBotInput.get_wield_cooldown = function (arg_49_0)
	-- function 49
	return false
end

PlayerBotInput.add_wield_cooldown = function (arg_50_0, arg_50_1)
	-- function 50
	return
end

PlayerBotInput.released_input = function (self, arg_51_1)
	-- function 51
	return not self._input[arg_51_1]
end

PlayerBotInput.released_softbutton_input = function (self, arg_52_1, arg_52_2)
	-- function 52
	return not self._input[arg_52_1]
end

PlayerBotInput.add_stun_buffer = function (arg_53_0, arg_53_1)
	-- function 53
	return
end

PlayerBotInput.reset_release_input = function (arg_54_0)
	-- function 54
	return true
end

PlayerBotInput.reset_release_input_with_delay = function (arg_55_0)
	-- function 55
	return true
end

PlayerBotInput.force_release_input = function (arg_56_0)
	-- function 56
	return true
end

PlayerBotInput.avoiding_aoe_threat = function (self)
	-- function 57
	return self._avoiding_aoe_threat
end
