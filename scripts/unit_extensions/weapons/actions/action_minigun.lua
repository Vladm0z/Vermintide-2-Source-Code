-- chunkname: @scripts/unit_extensions/weapons/actions/action_minigun.lua

ActionMinigun = class(ActionMinigun, ActionRangedBase)

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local num = 1
local num_2 = 1.2
local num_3 = 3
local num_4 = 2
local num_5 = 6
local num_6 = 3
local num_7 = 10
local set_flow_variable = Unit.set_flow_variable
local flow_event = Unit.flow_event

ActionMinigun.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionMinigun.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self.buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self.ai_bot_group_system = Managers.state.entity:system("ai_bot_group_system")
	self._attack_speed_anim_var_3p = Unit.animation_find_variable(arg_1_4, "attack_speed")
	self._time_to_shoot = 0
	self._last_avoidance_t = 0
	self._free_ammo_t = 0
	self._ranged_attack = true
	self._num_extra_shots = 0
end

ActionMinigun.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local _time_to_shoot = self._time_to_shoot

	ActionMinigun.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local visual_heat_generation = arg_2_1.visual_heat_generation

	visual_heat_generation = visual_heat_generation or 0
	self._visual_heat_generation = visual_heat_generation

	local base_anim_speed = arg_2_1.base_anim_speed

	base_anim_speed = base_anim_speed or 1
	self._base_anim_speed = base_anim_speed
	self._shot_cost = arg_2_1.ammo_usage
	self._calculated_attack_speed = false
	self._initial_rounds_per_second = arg_2_1.initial_rounds_per_second
	self._max_rps = arg_2_1.max_rps
	self._rps_loss_per_second = arg_2_1.rps_loss_per_second
	self._rps_gain_per_shot = arg_2_1.rps_gain_per_shot
	self._projectiles_per_shot = arg_2_1.shot_count
	self._use_ability_as_ammo = arg_2_1.use_ability_as_ammo
	self._check_near_wall = arg_2_1.dont_shoot_near_wall
	self._near_wall = false

	local clamp = math.clamp(self.weapon_extension:get_custom_data("windup"), 0, 1)

	self._current_rps = math.lerp(self._initial_rounds_per_second, self._max_rps, clamp)
	self._attack_speed_mod = 1
	self._ammo_expended = 0
	self.extra_buff_shot = false

	self:_update_attack_speed(arg_2_2)

	self._time_to_shoot = math.max(_time_to_shoot, arg_2_2 - 1 / self._current_rps)
	self._first_shot = true

	local fire_loop_start = arg_2_1.fire_loop_start

	if not fire_loop_start then
		self.first_person_extension:play_hud_sound_event(fire_loop_start)
	end

	self:_play_vo()
end

ActionMinigun._update_attack_speed = function (self, arg_3_1)
	-- function 3
	if not self._calculated_attack_speed then
		self._attack_speed_mod = ActionUtils.get_action_time_scale(self.owner_unit, self.current_action)

		self:_update_animation_speed(self._current_rps * self._attack_speed_mod)

		self._calculated_attack_speed = true
	end
end

ActionMinigun._waiting_to_shoot = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_update_animation_speed(self._current_rps)

	if not self._check_near_wall then
		self:_update_near_wall()
	end

	if not self._near_wall then
		self._time_to_shoot = arg_4_2 - 1 / self._current_rps
	elseif not (self._near_wall or not (arg_4_2 >= self._time_to_shoot)) then
		self:_shoot(arg_4_1, arg_4_2)
	end
end

ActionMinigun.get_projectile_start_position_rotation = function (self)
	-- function 5
	local node = Unit.node(self.weapon_unit, "a_barrel")
	local world_rotation = Unit.world_rotation(self.weapon_unit, node)
	local forward = Quaternion.forward(world_rotation)
	local right = Quaternion.right(world_rotation)
	local num = Unit.world_position(self.weapon_unit, node) + forward * 0.4 + right * 0.1
	local camera_position_rotation, var_5_6 = self.first_person_extension:camera_position_rotation()
	local physics_world = World.physics_world(self.world)
	local forward_2 = Quaternion.forward(var_5_6)
	local var_5_9 = Managers.state.side.side_by_unit[self.owner_unit]
	local look_at_enemy_or_static_position = WeaponHelper:look_at_enemy_or_static_position(physics_world, camera_position_rotation, forward_2, var_5_9, 0.15, 100)
	local direction_length, var_5_12 = Vector3.direction_length(look_at_enemy_or_static_position - num)

	if var_5_12 < 2 then
		num = camera_position_rotation
		direction_length = Vector3.normalize(look_at_enemy_or_static_position - num)
	end

	local look = Quaternion.look(direction_length)

	return num, look
end

ActionMinigun._shoot = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_update_attack_speed(arg_6_2)
	self:_update_bot_avoidance(arg_6_2)

	local var_6_0

	if not self._use_ability_as_ammo then
		local current_ability_cooldown, var_6_2 = self.career_extension:current_ability_cooldown(1)

		var_6_0 = (var_6_2 - current_ability_cooldown) / self:_buffed_shot_cost()
	else
		var_6_0 = self.ammo_extension:ammo_count()
	end

	local num = self._current_rps * self._attack_speed_mod
	local min = math.min(num * (arg_6_2 - self._time_to_shoot), var_6_0)
	local floor = math.floor(min)

	if floor > 0 then
		local flag = true
		local _projectiles_per_shot = self._projectiles_per_shot
		local _update_extra_shots = self:_update_extra_shots(self.buff_extension, 0, flag)

		_update_extra_shots = _update_extra_shots or 0

		if _update_extra_shots > 0 then
			self.extra_buff_shot = true
			self._num_extra_shots = _update_extra_shots
			_projectiles_per_shot = _projectiles_per_shot + _update_extra_shots
		end

		self._current_rps = math.clamp(self._current_rps + self._rps_gain_per_shot * floor, self._initial_rounds_per_second, self._max_rps)
		self._time_last_fired = arg_6_2
		self._time_to_shoot = arg_6_2 - (min - floor) / num
		self._num_projectiles_per_shot = floor * _projectiles_per_shot
		self._state = "start_shooting"
		self._calculated_attack_speed = false
	end

	self._first_shot = false
end

ActionMinigun._shooting = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _num_projectiles_per_shot = self._num_projectiles_per_shot
	local _num_projectiles_spawned = self._num_projectiles_spawned
	local num = _num_projectiles_per_shot - _num_projectiles_spawned

	if not arg_7_2 then
		num = math.min(num, num_6)
	end

	self._num_projectiles_spawned = self:shoot(num, _num_projectiles_spawned, _num_projectiles_per_shot)

	if _num_projectiles_per_shot - self._num_projectiles_spawned <= 0 then
		self:_staggered_shot_done(arg_7_1)
	end
end

ActionMinigun._staggered_shot_done = function (self, arg_8_1)
	-- function 8
	local current_action = self.current_action
	local first_person_extension = self.first_person_extension

	if not current_action.apply_recoil then
		first_person_extension:apply_recoil()
	end

	if not current_action.recoil_settings then
		first_person_extension:play_camera_recoil(current_action.recoil_settings, arg_8_1)
	end

	flow_event(self.weapon_unit, "lua_finish_shooting")

	if not self:_has_ammo() then
		self._state = "waiting_to_shoot"
	else
		self._state = "finished_shooting"
	end
end

ActionMinigun._finished_shooting = function (self, arg_9_1)
	-- function 9
	self.weapon_extension:stop_action("action_complete")
end

ActionMinigun.finish = function (self, arg_10_1)
	-- function 10
	if not self._near_wall then
		self.first_person_extension:animation_set_variable("disable_shooting", 0)
		CharacterStateHelper.play_animation_event_first_person(self.first_person_extension, "near_wall_updated")
	end

	ActionMinigun.super.finish(self, arg_10_1)

	local _initial_rounds_per_second = self._initial_rounds_per_second
	local num = self._max_rps - _initial_rounds_per_second
	local clamp = math.clamp((self._current_rps - _initial_rounds_per_second) / num, 0, 1)

	self.weapon_extension:set_custom_data("windup", clamp)
end

ActionMinigun.proc_extra_shot = function (arg_11_0, arg_11_1)
	-- function 11
	return false
end

ActionMinigun.gen_num_shots = function (arg_12_0)
	-- function 12
	return 1, 1
end

ActionMinigun.apply_shot_cost = function (self, arg_13_1)
	-- function 13
	if not self._use_ability_as_ammo then
		return ActionMinigun.super.apply_shot_cost(self, arg_13_1)
	end

	self:_fake_activate_ability(arg_13_1)

	local _should_consume_ammo = self:_should_consume_ammo(arg_13_1)
	local buff_extension = self.buff_extension

	if not buff_extension and not buff_extension:has_buff_perk(scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.free_ability_engineer) then
		_should_consume_ammo = false
	end

	if not _should_consume_ammo then
		local _num_projectiles_per_shot = self._num_projectiles_per_shot

		if not self.extra_buff_shot then
			_num_projectiles_per_shot = math.max(_num_projectiles_per_shot - self._num_extra_shots, 1)
		end

		self.career_extension:reduce_activated_ability_cooldown(-self:_buffed_shot_cost() * _num_projectiles_per_shot)

		self.extra_buff_shot = false
		self._num_extra_shots = 0
	end
end

ActionMinigun._should_consume_ammo = function (self, arg_14_1)
	-- function 14
	return arg_14_1 > self._free_ammo_t
end

ActionMinigun._has_ammo = function (self)
	-- function 15
	if not self._use_ability_as_ammo then
		local current_ability_cooldown, var_15_1 = self.career_extension:current_ability_cooldown(1)

		return var_15_1 - current_ability_cooldown >= self:_buffed_shot_cost()
	else
		return self.ammo_extension:ammo_count() > 0
	end
end

ActionMinigun._play_vo = function (self)
	-- function 16
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end

ActionMinigun._play_vfx = function (arg_17_0)
	-- function 17
	return
end

ActionMinigun._update_animation_speed = function (self, arg_18_1)
	-- function 18
	local num = self._base_anim_speed * arg_18_1
	local clamp = math.clamp(num, NetworkConstants.animation_variable_float.min, NetworkConstants.animation_variable_float.max)

	self.first_person_extension:animation_set_variable("attack_speed", clamp)

	if not self._attack_speed_anim_var_3p then
		Managers.state.network:anim_set_variable_float(self.owner_unit, "attack_speed", clamp)
	end
end

ActionMinigun._update_bot_avoidance = function (self, arg_19_1)
	-- function 19
	if not (self.is_bot or not (arg_19_1 > self._last_avoidance_t + num)) then
		self._last_avoidance_t = arg_19_1

		local get_projectile_start_position_rotation, var_19_1 = self:get_projectile_start_position_rotation()
		local calculate_oobb, var_19_3, var_19_4 = AiUtils.calculate_oobb(num_5, get_projectile_start_position_rotation, var_19_1, num_4, num_3)

		if not self.is_server then
			self.ai_bot_group_system:queue_aoe_threat(calculate_oobb, "oobb", var_19_4, var_19_3, num_2, "Minigun")
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_bot_create_threat_oobb", calculate_oobb, var_19_3, var_19_4, num_2)
		end
	end
end

ActionMinigun._fake_activate_ability = function (self, arg_20_1)
	-- function 20
	local buff_extension = self.buff_extension

	if not buff_extension then
		local num = 1
		local flag = false

		self._ammo_expended = self._ammo_expended + self:_buffed_shot_cost() * self._num_projectiles_per_shot

		if not buff_extension:has_buff_perk(scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.free_ability) then
			self._free_ammo_t = arg_20_1 + num_7
			flag = true
		elseif self._ammo_expended > self.career_extension:get_max_ability_cooldown() / 2 then
			self._ammo_expended = 0
			flag = true
		end

		if not flag then
			buff_extension:trigger_procs("on_ability_activated", self.owner_unit, num)
			buff_extension:trigger_procs("on_ability_cooldown_started")

			local network = Managers.state.network
			local unit_game_object_id = network:unit_game_object_id(self.owner_unit)

			if not network:game() then
				if not self.is_server then
					network.network_transmit:send_rpc_clients("rpc_ability_activated", unit_game_object_id, num)
				else
					network.network_transmit:send_rpc_server("rpc_ability_activated", unit_game_object_id, num)
				end
			end
		end
	end
end

ActionMinigun._update_near_wall = function (self)
	-- function 21
	local first_person_extension = self.first_person_extension
	local current_position = first_person_extension:current_position()
	local current_rotation = first_person_extension:current_rotation()
	local str = "filter_in_line_of_sight_no_players_no_enemies"
	local num = 1.35
	local forward = Quaternion.forward(current_rotation)
	local physics_world = World.physics_world(self.world)
	local raycast, var_21_8, var_21_9 = PhysicsWorld.raycast(physics_world, current_position, forward, num, "all", "types", "both", "closest", "collision_filter", str)
	local flag = not var_21_9 and var_21_9 <= num

	if flag ~= self._near_wall then
		self._near_wall = flag

		local var_21_11 = first_person_extension
		local animation_set_variable = first_person_extension.animation_set_variable
		local str_2 = "disable_shooting"
		local flag_2

		flag_2 = not flag and 1 and 0

		animation_set_variable(var_21_11, str_2, flag_2)
		CharacterStateHelper.play_animation_event_first_person(first_person_extension, "near_wall_updated")
	end
end

ActionMinigun._buffed_shot_cost = function (self)
	-- function 22
	local buff_extension = self.buff_extension

	if not buff_extension then
		return (buff_extension:apply_buffs_to_value(self._shot_cost, "ammo_used_multiplier"))
	end

	return self._shot_cost
end
