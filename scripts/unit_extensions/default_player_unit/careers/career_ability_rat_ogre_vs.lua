-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_rat_ogre_vs.lua

CareerAbilityRatOgreJump = class(CareerAbilityRatOgreJump)

local degrees_to_radians = math.degrees_to_radians(75)
local num = 8
local num_2 = 0.1
local tbl = {}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local num_3 = -PlayerUnitMovementSettings.gravity_acceleration
	local zero = Vector3.zero()
	local speed_to_hit_moving_target, var_1_3 = WeaponHelper.speed_to_hit_moving_target(arg_1_1, arg_1_2, degrees_to_radians, zero, num_3, num_2)
	local test_angled_trajectory, var_1_5, var_1_6 = WeaponHelper.test_angled_trajectory(arg_1_0, arg_1_1, arg_1_2, -num_3, speed_to_hit_moving_target, degrees_to_radians, tbl, num, nil, true)

	fassert(test_angled_trajectory, "no landing location for leap")

	return Vector3.normalize(var_1_5), speed_to_hit_moving_target, var_1_3
end

CareerAbilityRatOgreJump.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self._owner_unit = arg_2_2
	self._world = arg_2_1.world
	self._wwise_world = Managers.world:wwise_world(self._world)

	local player = arg_2_3.player

	self._player = player
	self._is_server = player.is_server
	self._local_player = player.local_player
	self._bot_player = player.bot_player
	self._network_manager = Managers.state.network
	self._input_manager = Managers.input
	self._indicator_fx_unit_name = "fx/units/aoe_globadier"
	self._indicator_unit = nil
	self._is_priming = false
	self._last_valid_landing_position = nil
	self.stored_valid_pos = false
	self._buff_data = {}
end

CareerAbilityRatOgreJump.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._first_person_extension = ScriptUnit.has_extension(arg_3_2, "first_person_system")
	self._status_extension = ScriptUnit.extension(arg_3_2, "status_system")
	self._career_extension = ScriptUnit.extension(arg_3_2, "career_system")
	self._ability_id = self._career_extension:ability_id("ogre_jump")
	self._ability_data = self._career_extension:get_activated_ability_data(self._ability_id)
	self._passive_ability_extension = self._career_extension:get_passive_ability()
	self._ability_input = self._ability_data.input_action
	self._jump_data = self._ability_data.jump_ability_data
	self._prime_time = self._ability_data.prime_time
	self._buff_extension = ScriptUnit.extension(arg_3_2, "buff_system")
	self._locomotion_extension = ScriptUnit.extension(arg_3_2, "locomotion_system")
	self._input_extension = ScriptUnit.has_extension(arg_3_2, "input_system")
	self._inventory_extension = ScriptUnit.extension(arg_3_2, "inventory_system")
	self._ghost_mode_extension = ScriptUnit.extension(arg_3_2, "ghost_mode_system")
	self._breed = Unit.get_data(arg_3_2, "breed")

	if not self._first_person_extension then
		self._first_person_unit = self._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityRatOgreJump.was_triggered = function (self)
	-- function 4
	local _input_extension = self._input_extension

	if not _input_extension then
		return false
	end

	if not self._is_priming then
		if not self:_ability_available() then
			return false
		end

		if not (not _input_extension:get(self._ability_input) and self._ghost_mode_extension:is_in_ghost_mode()) then
			self:_start()

			return true
		end
	end

	return false
end

CareerAbilityRatOgreJump._ability_available = function (self)
	-- function 5
	local is_in_ghost_mode = ScriptUnit.has_extension(self._owner_unit, "ghost_mode_system"):is_in_ghost_mode()
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local can_use_activated_ability = _career_extension:can_use_activated_ability()
	local is_disabled = _status_extension:is_disabled()
	local is_on_ground = _locomotion_extension:is_on_ground()

	return not not is_in_ghost_mode or not can_use_activated_ability or not not is_disabled or is_on_ground
end

CareerAbilityRatOgreJump.destroy = function (self)
	-- function 6
	if not self._local_player then
		self._first_person_extension:play_hud_sound_event("Stop_vs_rat_ogre_jump_charge_vce_1p")
		self._first_person_extension:play_remote_unit_sound_event("Stop_vs_rat_ogre_jump_charge_vce_3p", self._owner_unit, 0)
	end
end

CareerAbilityRatOgreJump._start = function (self)
	-- function 7
	local get_item_data_and_weapon_extensions, var_7_1, var_7_2 = CharacterStateHelper.get_item_data_and_weapon_extensions(self._inventory_extension)

	if not var_7_1 then
		var_7_1:stop_action("interrupted")
	end

	self._jump_data = self._career_extension:get_activated_ability_data(self._ability_id).jump_ability_data

	self:_start_calculate_leap_position()

	self._priming_charged = Managers.time:time("game") + self._prime_time

	if not self._jump_data.priming_buffs then
		self:_add_ability_buffs(self._jump_data.priming_buffs)
	end

	if not self._local_player then
		self._first_person_extension:play_hud_sound_event("Play_vs_rat_ogre_jump_charge_vce_1p")
		self._first_person_extension:play_remote_unit_sound_event("Play_vs_rat_ogre_jump_charge_vce_3p", self._owner_unit, 0)
	end

	self._first_person_extension:play_animation_event("attack_jump")
	CharacterStateHelper.play_animation_event(self._owner_unit, "attack_jump")
end

CareerAbilityRatOgreJump._add_ability_buffs = function (self, arg_8_1)
	-- function 8
	for i = 1, #arg_8_1 do
		local var_8_0 = arg_8_1[i]
		local flag = not var_8_0 and var_8_0.buff_template

		assert(flag, "need a buff_template to add a buff")

		local tbl = {
			external_optional_multiplier = not var_8_0 and var_8_0.external_optional_multiplier
		}
		local add_buff, var_8_4, var_8_5 = self._buff_extension:add_buff(flag, tbl)

		self._buff_data[#self._buff_data + 1] = {
			add_buff,
			var_8_4,
			var_8_5
		}
	end
end

CareerAbilityRatOgreJump._remove_ability_buffs = function (self)
	-- function 9
	if not self._buff_data then
		return
	end

	for i = #self._buff_data, 1, -1 do
		local var_9_0 = self._buff_data[i][1]

		self._buff_extension:remove_buff(var_9_0, true)
		table.swap_delete(self._buff_data, i)
	end
end

CareerAbilityRatOgreJump._update_priming = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	if not (not (arg_10_5 > self._priming_charged) or self._done_priming) then
		self._done_priming = true

		if not Managers.player:owner(arg_10_1).local_player then
			self._first_person_extension:play_hud_sound_event("Play_vs_rat_ogre_jump_charge_complete")
		end
	else
		local num = math.min(self._prime_time - (self._priming_charged - arg_10_5), self._prime_time) / self._prime_time

		self:_set_priming_progress(num)
	end
end

CareerAbilityRatOgreJump.update = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local _input_extension = self._input_extension

	if not _input_extension then
		return
	end

	local was_triggered = self:was_triggered()

	if not CharacterStateHelper.is_staggered(self._status_extension) and not self._is_priming then
		self._career_extension:stop_ability("staggered")

		return
	end

	if not self._is_priming then
		local get = _input_extension:get("dark_pact_action_one")

		if not get then
			get = _input_extension:get("jump")

			if not get then
				get = _input_extension:get("jump_only")

				if not get then
					get = _input_extension:get("dark_pact_reload")
					get = (get or not _input_extension:get("dark_pact_action_two_release") or not not self._done_priming or _input_extension:get("dark_pact_action_two_hold") or not self._done_priming) and self._status_extension:is_climbing()
				end
			end
		end

		if not get then
			self._career_extension:stop_ability("aborted")
			self._career_extension:start_activated_ability_cooldown(self._ability_id, 1)
			self._network_manager:anim_event(arg_11_1, "interrupt")
			CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, "interrupt")

			return
		end

		self:_update_priming(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)

		local _calculate_leap_position, var_11_4, var_11_5 = self:_calculate_leap_position()

		if not _calculate_leap_position and not var_11_4 then
			local var_11_6 = POSITION_LOOKUP[arg_11_1]
			local min_jump_dist = self._jump_data.min_jump_dist
			local flag = not self._last_valid_landing_position

			if not (self.stored_valid_pos or not (min_jump_dist <= var_11_5)) then
				self.stored_valid_pos = true
			end

			local _last_valid_landing_position = self._last_valid_landing_position

			_last_valid_landing_position = not _last_valid_landing_position and not self.stored_valid_pos

			local _last_valid_landing_position_2 = self._last_valid_landing_position

			_last_valid_landing_position_2 = not _last_valid_landing_position_2 and min_jump_dist <= var_11_5

			if not flag then
				self._last_valid_landing_position = Vector3Box(var_11_4)

				self:_handel_hit_indicator(var_11_4)
			elseif not _last_valid_landing_position_2 then
				self._last_valid_landing_position:store(var_11_4)
				self:_handel_hit_indicator(var_11_4)
			elseif self.stored_valid_pos or not _last_valid_landing_position then
				self._last_valid_landing_position:store(var_11_4)
				self:_handel_hit_indicator(var_11_4)
			end
		end

		if not self._last_valid_landing_position then
			self._career_extension:stop_ability("aborted")

			return
		end

		if not _input_extension:get("dark_pact_action_two_release") and not self._done_priming then
			if not _calculate_leap_position and not self._last_valid_landing_position then
				self:_set_priming_progress(0)
				self:_do_leap()
			else
				self:_stop_priming()
			end
		end
	end
end

CareerAbilityRatOgreJump.stop = function (self, arg_12_1)
	-- function 12
	if not self._is_priming then
		self:_stop_priming()
	end

	if arg_12_1 == "aborted" then
		self._network_manager:anim_event(self._owner_unit, "cancel_priming")
	end

	if arg_12_1 == "staggered" then
		self._career_extension:start_activated_ability_cooldown(self._ability_id, 1)
	end

	self:stop_passive_ability()

	local get_item_data_and_weapon_extensions, var_12_1, var_12_2 = CharacterStateHelper.get_item_data_and_weapon_extensions(self._inventory_extension)

	if not var_12_1 then
		var_12_1:stop_action("interrupted")
	end
end

CareerAbilityRatOgreJump._start_calculate_leap_position = function (self)
	-- function 13
	self._last_valid_landing_position = nil
	self._done_priming = false
	self._is_priming = true
	self._ability_data.is_priming = true
end

CareerAbilityRatOgreJump._destroy_indicator_unit = function (self)
	-- function 14
	if not Unit.alive(self._indicator_unit) then
		World.destroy_unit(self._world, self._indicator_unit)

		self._indicator_unit = nil
	end
end

CareerAbilityRatOgreJump._handel_hit_indicator = function (self, arg_15_1)
	-- function 15
	local _indicator_fx_unit_name = self._indicator_fx_unit_name

	if not arg_15_1 then
		if not self._indicator_unit then
			Unit.set_local_position(self._indicator_unit, 0, arg_15_1)
		else
			self._indicator_unit = World.spawn_unit(self._world, _indicator_fx_unit_name, arg_15_1)

			local hit_indicator_raidus = self._jump_data.hit_indicator_raidus

			Unit.set_local_scale(self._indicator_unit, 0, Vector3(hit_indicator_raidus, hit_indicator_raidus, hit_indicator_raidus))
		end
	else
		self:_destroy_indicator_unit()
	end
end

CareerAbilityRatOgreJump._calculate_leap_position = function (self)
	-- function 16
	local _world = self._world
	local get_data = World.get_data(_world, "physics_world")
	local _first_person_extension = self._first_person_extension
	local current_position = _first_person_extension:current_position()
	local current_rotation = _first_person_extension:current_rotation()
	local degrees_to_radians = math.degrees_to_radians(self._jump_data.min_pitch)
	local degrees_to_radians_2 = math.degrees_to_radians(self._jump_data.max_pitch)
	local yaw = Quaternion.yaw(current_rotation)
	local clamp = math.clamp(Quaternion.pitch(current_rotation), -degrees_to_radians, degrees_to_radians_2)
	local var_16_9 = Quaternion(Vector3.up(), yaw)
	local var_16_10 = Quaternion(Vector3.right(), clamp)
	local multiply = Quaternion.multiply(var_16_9, var_16_10)
	local forward = Quaternion.forward(multiply)
	local jump_speed = self._jump_data.movement_settings.jump_speed
	local num = (Vector3.up() * 0.3 + forward) * jump_speed
	local var_16_15 = Vector3(0, 0, -11)
	local str = "filter_player_enemy_leap_state_noclip_mover"
	local get_landing_position, var_16_18 = self:get_landing_position(get_data, self._owner_unit, current_position, num, var_16_15, str)
	local var_16_19

	if not get_landing_position then
		var_16_19 = Vector3.length(var_16_18 - current_position)
	end

	return get_landing_position, var_16_18, var_16_19
end

CareerAbilityRatOgreJump._stop_priming = function (self)
	-- function 17
	self:_destroy_indicator_unit()
	self:_set_priming_progress(0)

	if not self._local_player then
		self._first_person_extension:play_hud_sound_event("Stop_vs_rat_ogre_jump_charge_vce_1p")
		self._first_person_extension:play_remote_unit_sound_event("Stop_vs_rat_ogre_jump_charge_vce_3p", self._owner_unit, 0)
	end

	self._is_priming = false
	self._ability_data.is_priming = false
	self._last_valid_landing_position = nil

	self:_remove_ability_buffs()

	self.stored_valid_pos = false
end

CareerAbilityRatOgreJump._do_common_stuff = function (self)
	-- function 18
	local _owner_unit = self._owner_unit
	local _is_server = self._is_server
	local _local_player = self._local_player
	local _bot_player = self._bot_player
	local _career_extension = self._career_extension

	if not _is_server and _bot_player and not _local_player then
		local _first_person_extension = self._first_person_extension

		_first_person_extension:play_hud_sound_event("Play_vs_rat_ogre_jump_1p")
		_first_person_extension:play_remote_unit_sound_event("Play_vs_rat_ogre_jump_3p", _owner_unit, 0)
	end

	_career_extension:start_activated_ability_cooldown(self._ability_id)
end

CareerAbilityRatOgreJump._do_leap = function (self)
	-- function 19
	local unbox = self._last_valid_landing_position:unbox()

	self:_stop_priming()

	if not self._locomotion_extension:is_on_ground() then
		return
	end

	self:_do_common_stuff()

	local _world = self._world
	local _owner_unit = self._owner_unit
	local _status_extension = self._status_extension

	self._locomotion_extension:set_external_velocity_enabled(false)
	_status_extension:reset_move_speed_multiplier()

	local get_data = World.get_data(_world, "physics_world")
	local var_19_5 = POSITION_LOOKUP[_owner_unit]
	local var_19_6, var_19_7, var_19_8 = fn(get_data, var_19_5, unbox)
	local distance = Vector3.distance(var_19_5, unbox)
	local lerp_data = self._jump_data.lerp_data
	local movement_settings = self._jump_data.movement_settings
	local flag = not lerp_data and lerp_data.zero_distance
	local flag_2 = not lerp_data and lerp_data.start_accel_distance
	local flag_3 = not lerp_data and lerp_data.end_accel_distance
	local flag_4 = not lerp_data and lerp_data.glide_distance
	local flag_5 = not lerp_data and lerp_data.slow_distance
	local flag_6 = not lerp_data and lerp_data.full_distance
	local flag_7 = not movement_settings and movement_settings.jump_speed

	_status_extension.do_leap = {
		camera_effect_sequence_start = "jump",
		move_function = "leap",
		camera_effect_sequence_land = "landed_leap",
		direction = Vector3Box(var_19_6),
		speed = flag_7,
		projected_hit_pos = Vector3Box(var_19_8),
		lerp_data = {
			zero_distance = flag or 0,
			start_accel_distance = flag_2 or 0.1,
			end_accel_distance = flag_3 or 0.2,
			glide_distance = flag_4 or 0.5,
			slow_distance = flag_5 or 0.7,
			full_distance = flag_6 or 1
		},
		movement_settings = movement_settings,
		leap_events = {
			start = function (self, arg_20_1)
				-- function 20
				self._start_leap_buff_id = Managers.state.entity:system("buff_system"):add_buff_synced(arg_20_1, "vs_rat_ogre_start_leap_stagger_immune", BuffSyncType.ClientAndServer, nil, Network.peer_id())

				if not self._screenspace_effect_id then
					local total_distance = self._leap_data.total_distance
					local num = 50
					local inv_lerp_clamped = math.inv_lerp_clamped(0, num, total_distance)
					local str = "fx/speedlines_01_1p"

					self._screenspace_effect_id = self._first_person_extension:create_screen_particles(str)

					ScriptWorld.set_material_variable_for_particles(_world, self._screenspace_effect_id, "distort_burst", "distortion_strength", inv_lerp_clamped)
					ScriptWorld.set_material_variable_for_particles(_world, self._screenspace_effect_id, "distort_loop", "distortion_strength", inv_lerp_clamped)
				end
			end,
			finished = function (self, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				local system = Managers.state.entity:system("buff_system")

				system:remove_buff_synced(arg_21_1, self._start_leap_buff_id)
				system:add_buff_synced(arg_21_1, "vs_rat_ogre_finish_leap_stagger_immune", BuffSyncType.ClientAndServer, nil, Network.peer_id())

				if not self._screenspace_effect_id then
					World.destroy_particles(self._world, self._screenspace_effect_id)

					self._screenspace_effect_id = nil
				end

				if not arg_21_2 then
					if not self._leap_data.anim_finish_event_1p then
						CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, self._leap_data.anim_finish_event_1p)
					end

					if not self._leap_data.anim_finish_event_3p then
						CharacterStateHelper.play_animation_event(arg_21_1, self._leap_data.anim_finish_event_3p)
					end

					local identity = Quaternion.identity()
					local str = "vs_rat_ogre_leap_landing"
					local num = 1
					local num_2 = 50

					Managers.state.entity:system("area_damage_system"):create_explosion(arg_21_1, arg_21_3, identity, str, num, "vs_rat_ogre_hands", num_2, false)
				end

				local get_item_data_and_weapon_extensions, var_21_6, var_21_7 = CharacterStateHelper.get_item_data_and_weapon_extensions(self._inventory_extension)

				var_21_6:stop_action("interrupted")
				self._career_extension:stop_ability()
			end
		}
	}

	self._passive_ability_extension:start_leap(var_19_5, unbox, distance)
end

CareerAbilityRatOgreJump.stop_passive_ability = function (self)
	-- function 22
	self._passive_ability_extension:stop_leap()
end

CareerAbilityRatOgreJump._play_vo = function (self)
	-- function 23
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end

local num_3 = 30
local num_4 = 3
local num_5 = 0.0001
local num_6 = 10

CareerAbilityRatOgreJump.get_landing_position = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	-- function 24
	local num = num_4 / num_3
	local var_24_1 = arg_24_3
	local mover = Unit.mover(arg_24_2)
	local radius = Mover.radius(mover)
	local var_24_4 = Vector3(0, 0, 0.1)

	for i = 1, num_3 do
		local num_2 = var_24_1 + arg_24_4 * num
		local num_7 = num_2 - var_24_1
		local normalize = Vector3.normalize(num_7)
		local length = Vector3.length(num_7)
		local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(arg_24_1, var_24_1, num_2, radius, num_6, "collision_filter", arg_24_6)

		if not linear_sphere_sweep then
			local var_24_10 = linear_sphere_sweep[1]
			local position = var_24_10.position
			local normal = var_24_10.normal
			local flag = true
			local flag_2 = Vector3.dot(normal, Vector3.up()) < 0.95

			if not flag_2 then
				local mover_fits_at, var_24_16 = Unit.mover_fits_at(arg_24_2, "standing", position + var_24_4, 1)

				if not mover_fits_at then
					position = var_24_16
				else
					flag = false
				end
			end

			if not (flag_2 or flag) then
				local length_2 = Vector3.length(Vector3.flat(arg_24_4))

				for j = 1, num_3 do
					local flag_3

					flag_3 = j ~= 1 or not 0.5 or 1

					local flag_4

					flag_4 = not (length_2 <= num_5) or not 0 or flag_3 / length_2

					local var_24_20

					if flag_4 > 0 then
						var_24_20 = position - arg_24_4 * flag_4 - arg_24_5 * (flag_4 * flag_4 * 0.5)
					else
						var_24_20 = arg_24_3
					end

					local immediate_raycast, var_24_22, var_24_23, var_24_24, var_24_25 = PhysicsWorld.immediate_raycast(arg_24_1, var_24_20, Vector3.down(), 10, "closest", "collision_filter", arg_24_6)

					if not immediate_raycast then
						local mover_fits_at_2, var_24_27 = Unit.mover_fits_at(arg_24_2, "standing", var_24_22 + var_24_4, 1)

						if not mover_fits_at_2 then
							local var_24_28 = var_24_27

							return true, var_24_28
						else
							position = var_24_20
						end
					end
				end
			end

			return true, position
		end

		arg_24_4 = arg_24_4 + arg_24_5 * num
		var_24_1 = num_2
	end

	return false, var_24_1
end

CareerAbilityRatOgreJump._set_priming_progress = function (arg_25_0, arg_25_1)
	-- function 25
	arg_25_0._career_extension:get_activated_ability_data(arg_25_0._ability_id).priming_progress = arg_25_1
end
