-- chunkname: @scripts/unit_extensions/generic/generic_status_extension.lua

GenericStatusExtension = class(GenericStatusExtension)

local DamageDataIndex = DamageDataIndex
local num = 3
local num_2 = -3
local num_3 = 2
local num_4 = 2
local num_5 = 60
local num_6 = 2
local tbl = {
	blocked_slam = true,
	ogre_shove = true,
	blocked_berzerker = true,
	chaos_cleave = true,
	blocked_sv_sweep_2 = true,
	blocked_sv_cleave = true,
	complete = true,
	blocked_running = true,
	blocked_charge = true,
	blocked_attack_2 = true,
	sv_shove = true,
	sv_push = true,
	blocked_sv_sweep = true,
	shield_blocked_slam = true,
	chaos_spawn_combo = true,
	blocked_headbutt = true,
	blocked_attack = true,
	blocked_ranged = true,
	blocked_attack_3 = true
}

GenericStatusExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.profile_id = arg_1_3.profile_id

	fassert(self.profile_id)

	self.unit = arg_1_2
	self.pacing_intensity = 0
	self.pacing_intensity_decay_delay = 0
	self.move_speed_multiplier = 1
	self.move_speed_multiplier_timer = 1
	self.invisible = {}
	self.crouching = false
	self.blocking = false
	self.override_blocking = nil
	self.charge_blocking = false
	self.catapulted = false
	self.catapulted_direction = nil
	self.pounced_down = false
	self.on_ladder = false
	self.is_ledge_hanging = false
	self.left_ladder_timer = 0
	self.aim_unit = nil
	self.revived = false
	self.dead = false
	self.pulled_up = false
	self.overpowered = false
	self.overpowered_template = nil
	self.overpowered_attacking_unit = nil
	self._has_blocked = false
	self.my_dodge_cd = 0
	self.my_dodge_jump_override_t = 0
	self.dodge_cooldown = 0
	self.dodge_cooldown_delay = 0
	self.is_aiming = false
	self.dodge_count = 2
	self.combo_target_count = 0
	self.fatigue = 0
	self.last_fatigue_gain_time = 0
	self.show_fatigue_gui = false
	self.max_fatigue_points = 100
	self.next_hanging_damage_time = 0
	self.block_broken = false
	self.gutter_runner_leaping = false
	self.block_broken_at_t = -math.huge
	self.stagger_immune = false
	self.pushed = false
	self.pushed_at_t = -math.huge
	self.push_cooldown = false
	self.push_cooldown_timer = false
	self.timed_block = nil
	self.shield_block = nil
	self.charged = false
	self.charged_at_t = -math.huge
	self.interrupt_cooldown = false
	self.interrupt_cooldown_timer = nil
	self.inside_transport_unit = nil
	self.using_transport = false
	self.dodge_position = Vector3Box(0, 0, 0)
	self.overcharge_exploding = false
	self.fall_height = nil
	self.under_ratling_gunner_attack = nil
	self.last_catapulted_time = 0
	self.grabbed_by_tentacle = false
	self.grabbed_by_tentacle_status = nil
	self.grabbed_by_chaos_spawn = false
	self.grabbed_by_chaos_spawn_status = nil
	self.in_vortex = false
	self.in_vortex_unit = nil
	self.near_vortex = false
	self.near_vortex_unit = nil
	self.in_liquid = false
	self.in_liquid_unit = nil
	self.in_hanging_cage_unit = nil
	self.in_hanging_cage_state = nil
	self.in_hanging_cage_animations = nil
	self.wounds = arg_1_3.wounds

	if self.wounds == -1 then
		self.wounds = math.huge
	end

	self._base_max_wounds = self.wounds
	self._num_times_grabbed_by_pack_master = 0
	self._hit_by_globadier_poison_instances = {}
	self._num_times_knocked_down = 0
	self.is_server = Managers.player.is_server
	self.update_funcs = {}

	self:set_spawn_grace_time(5)

	if not arg_1_3.respawn_unit then
		self.ready_for_assisted_respawn = true
		self.assisted_respawn_flavour_unit = arg_1_3.respawn_unit
	else
		self.ready_for_assisted_respawn = false
	end

	self.assisted_respawning = false
	self.player = arg_1_3.player
	self.is_bot = self.player.bot_player
	self.in_end_zone = false
	self.is_husk = self.player.remote

	if not self.is_server then
		self.conflict_director = Managers.state.conflict
	end

	self._intoxication_level = 0
	self.noclip = {}
	self._incapacitated_outline_ids = {}
	self._assisted_respawn_outline_id = -1
	self._invisible_outline_id = -1
end

GenericStatusExtension.extensions_ready = function (self)
	-- function 2
	local unit = self.unit

	self.health_extension = ScriptUnit.extension(unit, "health_system")
	self.buff_extension = ScriptUnit.extension(unit, "buff_system")
	self.inventory_extension = ScriptUnit.extension(unit, "inventory_system")
	self.career_extension = ScriptUnit.extension(unit, "career_system")
	self.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	if not (not ScriptUnit.has_extension(unit, "first_person_system") and self.locomotion_extension.is_bot) then
		self.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
		self.low_health_playing_id, self.low_health_source_id = self.first_person_extension:play_hud_sound_event("hud_low_health")
	end

	Managers.state.event:register(self, "on_player_joined_party", "_on_player_joined_party")
end

GenericStatusExtension.destroy = function (self)
	-- function 3
	local first_person_extension = self.first_person_extension

	if not first_person_extension then
		first_person_extension:play_hud_sound_event("stop_hud_low_health")
	end

	local event = Managers.state.event

	if not event then
		event:unregister("on_player_joined_party", self)
	end
end

GenericStatusExtension.add_damage_intensity = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.pacing_intensity = math.clamp(self.pacing_intensity + arg_4_1 * CurrentIntensitySettings.intensity_add_per_percent_dmg_taken * 100, 0, 100)
	self.pacing_intensity_decay_delay = CurrentIntensitySettings.decay_delay
end

GenericStatusExtension.add_pacing_intensity = function (self, arg_5_1)
	-- function 5
	self.pacing_intensity = math.clamp(self.pacing_intensity + arg_5_1, 0, 100)
	self.pacing_intensity_decay_delay = CurrentIntensitySettings.decay_delay
end

GenericStatusExtension.add_combo_target_count = function (self, arg_6_1)
	-- function 6
	self.combo_target_count = math.clamp(self.combo_target_count + arg_6_1, 0, 5)
end

GenericStatusExtension.add_pacing_intensity_by_difficulty = function (self, arg_7_1)
	-- function 7
	local var_7_0 = arg_7_1[Managers.state.difficulty:get_difficulty()]

	if not var_7_0 then
		return
	end

	self.pacing_intensity = math.clamp(self.pacing_intensity + var_7_0, 0, 100)
	self.pacing_intensity_decay_delay = CurrentIntensitySettings.decay_delay
end

GenericStatusExtension.add_intoxication_level = function (self, arg_8_1)
	-- function 8
	self._intoxication_level = math.clamp(self._intoxication_level + arg_8_1, num_2, num)
end

GenericStatusExtension.invert_intoxication_level = function (self)
	-- function 9
	self._intoxication_level = self._intoxication_level * -1
end

GenericStatusExtension.intoxication_level = function (self)
	-- function 10
	return self._intoxication_level
end

local tbl_2 = {
	temporary_health_degen = true,
	overcharge = true,
	wounded_dot = true,
	knockdown_bleed = true,
	heal = true,
	health_degen = true
}

GenericStatusExtension.update = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local health_extension = self.health_extension
	local recent_damages, var_11_2 = health_extension:recent_damages()

	if not self.is_server then
		local STRIDE = DamageDataIndex.STRIDE

		for i = 1, var_11_2 / STRIDE do
			local num = (i - 1) * STRIDE
			local var_11_5 = recent_damages[num + DamageDataIndex.DAMAGE_TYPE]

			if not tbl_2[var_11_5] then
				local var_11_6 = recent_damages[num + DamageDataIndex.DAMAGE_AMOUNT]
				local get_max_health = health_extension:get_max_health()

				self:add_damage_intensity(var_11_6 / get_max_health, var_11_5)
			end
		end

		local ignore_pacing_intensity_decay_delay = self.conflict_director.pacing:ignore_pacing_intensity_decay_delay()

		if not ((self.pacing_intensity_decay_delay <= 0 or not ignore_pacing_intensity_decay_delay) and self.conflict_director:intensity_decay_frozen()) then
			self.pacing_intensity = math.clamp(self.pacing_intensity - CurrentIntensitySettings.decay_per_second * arg_11_3, 0, CurrentIntensitySettings.max_intensity)
		end

		self.pacing_intensity_decay_delay = self.pacing_intensity_decay_delay - arg_11_3
	end

	if self.move_speed_multiplier_timer < 1 then
		local num_2 = arg_11_3 * PlayerUnitStatusSettings.move_speed_reduction_on_hit_recover_time

		self.move_speed_multiplier_timer = self.move_speed_multiplier_timer + num_2
	end

	local flag = true

	if var_11_2 > 0 then
		local flag_2 = false

		for j = 1, var_11_2 / DamageDataIndex.STRIDE do
			local var_11_12 = recent_damages[(j - 1) * DamageDataIndex.STRIDE + DamageDataIndex.DAMAGE_TYPE]

			if not PlayerUnitMovementSettings.slowing_damage_types[var_11_12] then
				flag_2 = true

				if not self.buff_extension:has_buff_perk("no_moveslow_on_hit") then
					flag_2 = false
				end

				break
			end

			if not tbl_2[var_11_12] then
				flag = false
			end
		end

		if not flag_2 then
			self.move_speed_multiplier = self:current_move_speed_multiplier() * 0.5
			self.move_speed_multiplier = math.max(0.2, self.move_speed_multiplier)
			self.move_speed_multiplier_timer = 0
		end
	end

	local player = self.player

	if not script_data.debug_fatigue then
		local var_11_14 = SPProfiles[player:profile_index()]
		local text = Debug.text
		local str = "(%s) Fatigue: %s, Max: %s"
		local display_name

		if player:name() ~= "anonymous" or not var_11_14 then
			display_name = var_11_14.display_name

			if not display_name then
				-- Nothing
			end
		end

		display_name = player:name()

		::label_11_0::

		text(str, display_name, self.fatigue, PlayerUnitStatusSettings.MAX_FATIGUE)
	end

	if not player.remote then
		local max_fatigue_points = self.max_fatigue_points
		local _get_current_max_fatigue_points = self:_get_current_max_fatigue_points()

		_get_current_max_fatigue_points = _get_current_max_fatigue_points or max_fatigue_points

		local block_broken_degen_delay = self.block_broken_degen_delay

		if not block_broken_degen_delay then
			block_broken_degen_delay = self.push_degen_delay
			block_broken_degen_delay = block_broken_degen_delay or PlayerUnitStatusSettings.FATIGUE_DEGEN_DELAY
		end

		local num_3 = block_broken_degen_delay / self.buff_extension:apply_buffs_to_value(1, "fatigue_regen")

		if max_fatigue_points ~= _get_current_max_fatigue_points then
			local flag_3

			flag_3 = _get_current_max_fatigue_points ~= 0 or not 0 or max_fatigue_points / _get_current_max_fatigue_points * self.fatigue

			self:set_fatigue_points(flag_3, "force_set")
		end

		if not (flag or not (var_11_2 > 0) or not (self.fatigue >= 50)) then
			if not self.action_stun_push then
				self.action_stun_push = false
			else
				self:remove_fatigue_points(100 / _get_current_max_fatigue_points)
			end
		end

		if arg_11_5 >= self.last_fatigue_gain_time + num_3 then
			self.action_stun_push = false
			self.show_fatigue_gui = false

			local flag_4

			flag_4 = _get_current_max_fatigue_points ~= 0 or not 0 or PlayerUnitStatusSettings.FATIGUE_POINTS_DEGEN_AMOUNT / _get_current_max_fatigue_points * PlayerUnitStatusSettings.MAX_FATIGUE

			local apply_buffs_to_value = self.buff_extension:apply_buffs_to_value(flag_4, "fatigue_regen")

			if flag_4 < apply_buffs_to_value then
				self.has_bonus_fatigue_active = true
			elseif not self.bonus_fatigue_active_timer then
				self.has_bonus_fatigue_active = false
			end

			self:remove_fatigue_points(apply_buffs_to_value * arg_11_3)

			self.block_broken_degen_delay = nil
			self.push_degen_delay = nil
		end

		if not ((not (self.dodge_cooldown > 0) or not self.dodge_cooldown_delay) and not (arg_11_5 > self.dodge_cooldown_delay)) then
			self.dodge_cooldown = 0
		end

		self.max_fatigue_points = _get_current_max_fatigue_points

		local bonus_fatigue_active_timer = self.bonus_fatigue_active_timer

		if not (not bonus_fatigue_active_timer and not (bonus_fatigue_active_timer <= arg_11_5)) then
			self.has_bonus_fatigue_active = false
			self.bonus_fatigue_active_timer = nil
		end

		if not self.push_cooldown then
			if not self.push_cooldown_timer then
				self.push_cooldown_timer = arg_11_5 + 1.5
			elseif arg_11_5 > self.push_cooldown_timer then
				self.push_cooldown_timer = false
				self.pushed = false
				self.push_cooldown = false
			end
		end

		if not self.interrupt_cooldown then
			if not self.interrupt_cooldown_timer then
				self.interrupt_cooldown_timer = arg_11_5 + 0.5
			elseif arg_11_5 > self.interrupt_cooldown_timer then
				self.interrupt_cooldown = false
				self.interrupt_cooldown_timer = nil
			end
		end

		if not self.first_person_extension and not self.low_health_playing_id then
			local num_4 = self.health_extension:current_health_percent() * 100
			local wwise_world = Managers.world:wwise_world(self.world)

			WwiseWorld.set_source_parameter(wwise_world, self.low_health_source_id, "health_status", num_4)
		end

		if not self.shielded and health_extension:has_assist_shield() or not health_extension:previous_shield_end_reason() then
			self:set_shielded(false)
		end
	end

	if not self.pack_master_status then
		if self.pack_master_status == "pack_master_hanging" then
			if not self.is_server then
				if arg_11_5 > self.next_hanging_damage_time then
					local hanging_by_pack_master = PlayerUnitStatusSettings.hanging_by_pack_master

					DamageUtils.add_damage_network(arg_11_1, arg_11_1, hanging_by_pack_master.damage_amount, hanging_by_pack_master.hit_zone_name, hanging_by_pack_master.damage_type, nil, Vector3.up(), "skaven_pack_master", nil, arg_11_1, nil, nil, nil, nil, nil, nil, nil, nil, 1)

					self.next_hanging_damage_time = arg_11_5 + 1
				end

				if not self.dead then
					StatusUtils.set_grabbed_by_pack_master_network("pack_master_dropping", arg_11_1, true, nil)
				end
			end
		elseif self.pack_master_status == "pack_master_dropping" then
			if not (not self.release_falling_time and not (arg_11_5 > self.release_falling_time)) then
				ScriptUnit.extension(arg_11_1, "locomotion_system"):set_disabled(false, nil, nil, true)

				if not self.is_server then
					StatusUtils.set_grabbed_by_pack_master_network("pack_master_released", arg_11_1, false, nil)
				end

				self.release_falling_time = nil
			end
		elseif self.pack_master_status == "pack_master_unhooked" then
			if not (not self.release_unhook_time and not (arg_11_5 > self.release_unhook_time)) then
				ScriptUnit.extension(arg_11_1, "locomotion_system"):set_disabled(false, nil, nil, true)

				if not self.is_server then
					StatusUtils.set_grabbed_by_pack_master_network("pack_master_released", arg_11_1, false, nil)
				end

				self.release_unhook_time = nil
			end
		elseif self.pack_master_status == "pack_master_released" then
			self.pack_master_status = nil
		elseif self.pack_master_status == "pack_master_dragging" then
			if not (not self.is_server and not self.pack_master_grabber and Unit.alive(self.pack_master_grabber)) then
				StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", arg_11_1, false, nil)
			end
		elseif not ((self.pack_master_status ~= "pack_master_hoisting" or not self.is_server) and not self.pack_master_grabber and Unit.alive(self.pack_master_grabber)) then
			StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", arg_11_1, false, nil)
		end
	end

	for k, v in pairs(self.update_funcs) do
		v(self, arg_11_5, arg_11_3)
	end
end

GenericStatusExtension.set_spawn_grace_time = function (self, arg_12_1)
	-- function 12
	self.spawn_grace_time = Managers.time:time("game") + arg_12_1
	self.spawn_grace = true
	self.update_funcs.spawn_grace_time = GenericStatusExtension.update_spawn_grace_time
end

GenericStatusExtension.update_spawn_grace_time = function (self, arg_13_1)
	-- function 13
	if arg_13_1 > self.spawn_grace_time then
		self.spawn_grace = false
		self.update_funcs.spawn_grace_time = nil
	end
end

GenericStatusExtension.fall_distance = function (self)
	-- function 14
	if not self.fall_height then
		if not self.ignore_next_fall_damage then
			self.fall_height = POSITION_LOOKUP[self.unit].z

			return 0
		end

		local z = POSITION_LOOKUP[self.unit].z

		return self.fall_height - z
	end

	return 0
end

GenericStatusExtension.set_ignore_next_fall_damage = function (self, arg_15_1)
	-- function 15
	self.ignore_next_fall_damage = arg_15_1
end

GenericStatusExtension.update_falling = function (self, arg_16_1)
	-- function 16
	if not (not self.locomotion_extension:is_on_ground() and self.on_ladder) then
		local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(self.unit)
		local MIN_FALL_DAMAGE_HEIGHT = get_movement_settings_table.fall.heights.MIN_FALL_DAMAGE_HEIGHT
		local HARD_LANDING_FALL_HEIGHT = get_movement_settings_table.fall.heights.HARD_LANDING_FALL_HEIGHT
		local get_script_driven_gravity_scale = self.locomotion_extension:get_script_driven_gravity_scale()
		local abs = math.abs(self:fall_distance() * get_script_driven_gravity_scale)
		local str = "landed"

		if MIN_FALL_DAMAGE_HEIGHT < abs then
			local abs_2 = math.abs(abs)

			if not (global_is_inside_inn or self.inside_transport_unit or self.ignore_next_fall_damage or self.is_bot) then
				local clamp = math.clamp(abs_2 * 4, 0, 255)
				local network = Managers.state.network
				local go_id = Managers.state.unit_storage:go_id(self.unit)

				network.network_transmit:send_rpc_server("rpc_take_falling_damage", go_id, clamp)
			end

			str = "landed_soft"

			if HARD_LANDING_FALL_HEIGHT <= abs_2 then
				str = "landed_hard"
			end
		end

		if not self.first_person_extension then
			self.first_person_extension:play_camera_effect_sequence(str, arg_16_1)
		end

		self.ignore_next_fall_damage = false
		self.update_funcs.falling = nil
		self.fall_height = nil
	end
end

GenericStatusExtension._get_current_max_fatigue_points = function (self)
	-- function 17
	local inventory_extension = self.inventory_extension
	local get_wielded_slot_name = inventory_extension:get_wielded_slot_name()
	local get_slot_data = inventory_extension:get_slot_data(get_wielded_slot_name)

	if not get_slot_data then
		local max_fatigue_points = inventory_extension:get_item_template(get_slot_data).max_fatigue_points

		max_fatigue_points = not max_fatigue_points and math.clamp(self.buff_extension:apply_buffs_to_value(max_fatigue_points, "max_fatigue"), 1, 100)

		return max_fatigue_points
	end
end

GenericStatusExtension.get_max_fatigue_points = function (self)
	-- function 18
	return self:_get_current_max_fatigue_points()
end

GenericStatusExtension.can_block = function (self, arg_19_1, arg_19_2)
	-- function 19
	local unit = self.unit
	local player = self.player
	local equipment = self.inventory_extension:equipment()
	local network = Managers.state.network
	local template = equipment.wielded.template

	template = template or equipment.wielded.temporary_template

	local get_weapon_template = WeaponUtils.get_weapon_template(template)

	if not template then
		return false
	end

	local game = network:game()
	local unit_game_object_id = network:unit_game_object_id(unit)

	if not (not game and unit_game_object_id) then
		return false
	end

	if not player then
		local game_object_field = GameSession.game_object_field(game, unit_game_object_id, "aim_direction")
		local flat = Vector3.flat(game_object_field)
		local var_19_10 = POSITION_LOOKUP[unit]
		local var_19_11 = POSITION_LOOKUP[arg_19_1]

		var_19_11 = var_19_11 or Unit.world_position(arg_19_1, 0)

		local normalize = Vector3.normalize(var_19_11 - var_19_10)
		local flat_2 = Vector3.flat(normalize)
		local buff_extension = self.buff_extension
		local var_19_15 = buff_extension
		local apply_buffs_to_value = buff_extension.apply_buffs_to_value
		local block_angle = get_weapon_template.block_angle

		block_angle = block_angle or 90

		local var_19_18 = apply_buffs_to_value(var_19_15, block_angle, "block_angle")
		local var_19_19 = buff_extension
		local apply_buffs_to_value_2 = buff_extension.apply_buffs_to_value
		local outer_block_angle = get_weapon_template.outer_block_angle

		outer_block_angle = outer_block_angle or 360

		local var_19_22 = apply_buffs_to_value_2(var_19_19, outer_block_angle, "block_angle")
		local clamp = math.clamp(var_19_18, 0, 360)
		local clamp_2 = math.clamp(var_19_22, 0, 360)
		local rad = math.rad(clamp * 0.5)
		local rad_2 = math.rad(clamp_2 * 0.5)
		local dot = Vector3.dot(flat_2, flat)
		local acos = math.acos(dot)
		local flag = acos <= rad
		local flag_2 = not (rad < acos) or acos <= rad_2

		if not (flag or flag_2) then
			return false
		end

		if not script_data.debug_draw_block_arcs then
			if not (not flag and flag_2) then
				self._debug_draw_color = Colors.get_table("lime")
			elseif flag or not flag_2 then
				self._debug_draw_color = Colors.get_table("dark_orange")
			else
				self._debug_draw_color = Colors.get_table("red")
			end
		end

		local outer_block_fatigue_point_multiplier

		if not flag_2 then
			outer_block_fatigue_point_multiplier = get_weapon_template.outer_block_fatigue_point_multiplier

			if not outer_block_fatigue_point_multiplier then
				outer_block_fatigue_point_multiplier = 2
			end
		else
			outer_block_fatigue_point_multiplier = get_weapon_template.block_fatigue_point_multiplier
			outer_block_fatigue_point_multiplier = outer_block_fatigue_point_multiplier or 1
		end

		local flag_3 = not flag and not flag_2

		arg_19_2 = arg_19_2 or not (Vector3.cross(flat_2, flat).z < 0) or not "left" or "right"

		return true, outer_block_fatigue_point_multiplier, flag_3, arg_19_2
	end

	return false
end

GenericStatusExtension.blocked_attack = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local unit = self.unit
	local equipment = self.inventory_extension:equipment()
	local var_20_2

	self:set_has_blocked(true)

	local player = self.player

	if not player then
		local buff_extension = self.buff_extension
		local str = "power_up_deus_block_procs_parry_exotic"
		local has_buff_type = buff_extension:has_buff_type(str)
		local flag = false
		local time = Managers.time:time("game")

		if not self.timed_block and time < self.timed_block and not has_buff_type then
			buff_extension:trigger_procs("on_timed_block", arg_20_2)

			flag = true
		end

		if not player.remote then
			local extension = ScriptUnit.extension(unit, "first_person_system")
			local get_first_person_unit = extension:get_first_person_unit()

			if not player.local_player and not Managers.state.controller_features then
				Managers.state.controller_features:add_effect("rumble", {
					rumble_effect = "block"
				})
			end

			var_20_2 = equipment.right_hand_wielded_unit or equipment.left_hand_wielded_unit

			local template = equipment.wielded.template

			template = template or equipment.wielded.temporary_template

			local get_weapon_template = WeaponUtils.get_weapon_template(template)

			if not flag then
				extension:play_hud_sound_event("Play_player_parry_success", nil, false)
			end

			self:add_fatigue_points(arg_20_1, arg_20_2, var_20_2, arg_20_3, flag)

			local str_2 = "parry_hit_reaction"

			if not arg_20_4 then
				if not (not (PlayerUnitStatusSettings.fatigue_point_costs[arg_20_1] <= 2) or arg_20_5 == "left" or arg_20_5 ~= "right") then
					str_2 = "parry_deflect_" .. arg_20_5
				end

				local sound_event_block_within_arc

				if not get_weapon_template then
					sound_event_block_within_arc = get_weapon_template.sound_event_block_within_arc

					if not sound_event_block_within_arc then
						-- Nothing
					end
				end

				sound_event_block_within_arc = "Play_player_block_ark_success"

				::label_20_0::

				extension:play_hud_sound_event(sound_event_block_within_arc, nil, false)
			else
				local wwise_world = Managers.world:wwise_world(self.world)
				local var_20_16 = POSITION_LOOKUP[arg_20_2]

				if not var_20_16 then
					local current_position = extension:current_position()
					local normalize = Vector3.normalize(var_20_16 - current_position)

					WwiseWorld.trigger_event(wwise_world, "Play_player_combat_out_of_arc_block", current_position + normalize)
				end
			end

			Unit.animation_event(get_first_person_unit, str_2)
			QuestSettings.handle_bastard_block(unit, arg_20_2, true)
		else
			var_20_2 = equipment.right_hand_wielded_unit_3p or equipment.left_hand_wielded_unit_3p

			QuestSettings.handle_bastard_block(unit, arg_20_2, true)
			Unit.animation_event(unit, "parry_hit_reaction")
		end

		Managers.state.entity:system("play_go_tutorial_system"):register_block()
		Managers.state.achievement:trigger_event("player_blocked_attack", player, arg_20_2)
	end

	if not var_20_2 then
		local var_20_19 = POSITION_LOOKUP[var_20_2]
		local world_rotation = Unit.world_rotation(var_20_2, 0)
		local num = var_20_19 + Quaternion.up(world_rotation) * Math.random() * 0.5 + Quaternion.right(world_rotation) * 0.1

		World.create_particles(self.world, "fx/wpnfx_sword_spark_parry", num)
	end
end

GenericStatusExtension.set_shielded = function (self, arg_21_1)
	-- function 21
	local unit = self.unit

	if not self.player.local_player then
		local extension = ScriptUnit.extension(unit, "first_person_system")

		if not arg_21_1 then
			extension:play_hud_sound_event("hud_player_buff_shield_activate")
			extension:create_screen_particles("fx/screenspace_shield_healed")
		else
			local previous_shield_end_reason = self.health_extension:previous_shield_end_reason()

			if previous_shield_end_reason == "blocked_damage" then
				extension:play_hud_sound_event("hud_player_buff_shield_down")
			elseif previous_shield_end_reason == "timed_out" then
				extension:play_hud_sound_event("hud_player_buff_shield_deactivate")
			end
		end
	end

	self.shielded = arg_21_1
end

local tbl_3 = {
	career_passive = true,
	health_regen = true,
	heal_from_proc = true,
	career_skill = true
}
local tbl_4 = {
	bandage_temp_health = true,
	buff_shared_medpack_temp_health = true,
	healing_draught_temp_health = true,
	buff_shared_medpack = true,
	bandage = true,
	bandage_trinket = true,
	healing_draught = true
}

GenericStatusExtension.healed = function (self, arg_22_1)
	-- function 22
	local unit = self.unit

	if not self.player.local_player then
		if not tbl_3[arg_22_1] then
			local get_first_person_unit = ScriptUnit.extension(unit, "first_person_system"):get_first_person_unit()

			Unit.flow_event(get_first_person_unit, "sfx_heal")
		end

		local var_22_2 = HealingMoods[arg_22_1]

		if not var_22_2 then
			Managers.state.camera:set_mood(var_22_2, self, true)
		end
	elseif not tbl_4[arg_22_1] then
		ScriptWorld.create_particles_linked(self.world, "fx/chr_player_fak_healed", unit, 0, "destroy")
	end
end

GenericStatusExtension.fatigued = function (self)
	-- function 23
	local MAX_FATIGUE = PlayerUnitStatusSettings.MAX_FATIGUE
	local max_fatigue_points = self.max_fatigue_points

	if not self.buff_extension:has_buff_perk("no_push_fatigue_cost") then
		return false
	end

	local flag

	flag = max_fatigue_points ~= 0 or not true or self.fatigue > MAX_FATIGUE - MAX_FATIGUE / max_fatigue_points

	return flag
end

GenericStatusExtension.add_fatigue_points = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	-- function 24
	local buff_extension = self.buff_extension

	if not Development.parameter("disable_fatigue_system") then
		return
	end

	local player = self.player

	if not player and not player.remote then
		Crashify.print_exception("[GenericStatusExtension]", "Tried adding fatigue points to a remote player.")

		return
	end

	local var_24_2 = PlayerUnitStatusSettings.fatigue_point_costs[arg_24_1]
	local time = Managers.time:time("game")
	local MAX_FATIGUE = PlayerUnitStatusSettings.MAX_FATIGUE
	local num = var_24_2 * (MAX_FATIGUE / self.max_fatigue_points) * (arg_24_4 or 1)

	if not arg_24_5 then
		num = buff_extension:apply_buffs_to_value(num, "timed_block_cost")
	end

	if not var_24_2 and not arg_24_4 and not (var_24_2 < 2) and not (arg_24_4 < 1) or not buff_extension:has_buff_perk("in_arc_block_cost_reduction") then
		num = 0
	end

	if not arg_24_3 then
		num = buff_extension:apply_buffs_to_value(num, "block_cost")

		if not buff_extension:has_buff_perk("overcharged_block") then
			local has_extension = ScriptUnit.has_extension(self.unit, "overcharge_system")

			if not has_extension and not has_extension:above_overcharge_threshold() then
				num = num * 0.5

				has_extension:remove_charge(var_24_2)
			end
		end
	end

	local clamp = math.clamp(self.fatigue + num, 0, MAX_FATIGUE)

	self:set_fatigue_points(clamp, arg_24_1)

	if not arg_24_3 then
		buff_extension:trigger_procs("on_block", arg_24_2, arg_24_1, arg_24_3)
	end

	if not (MAX_FATIGUE <= clamp) or not tbl[arg_24_1] then
		self:set_block_broken(true, time, arg_24_2)
	end

	if num > 0 then
		self.last_fatigue_gain_time = time
		self.show_fatigue_gui = true
	end

	if arg_24_1 == "action_stun_push" then
		self.action_stun_push = true
	end

	local first_person_extension = self.first_person_extension

	if not (var_24_2 > PlayerUnitStatusSettings.fatigue_points_to_play_heavy_block_sfx) or not first_person_extension then
		first_person_extension:play_hud_sound_event("Play_player_combat_heavy_block_sweetner", nil, false)
	end
end

GenericStatusExtension.set_fatigue_points = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local fatigue = self.fatigue

	arg_25_3 = not (not not arg_25_3 or fatigue < arg_25_1 or fatigue == arg_25_1 or fatigue == 100 or arg_25_1 == 0)
	self.fatigue = arg_25_1

	if not self.is_server then
		local var_25_1 = PlayerUnitStatusSettings.fatigue_point_costs[arg_25_2]
		local MAX_FATIGUE = PlayerUnitStatusSettings.MAX_FATIGUE

		if not (not (var_25_1 >= PlayerUnitStatusSettings.fatigue_points_to_trigger_vo) or not (MAX_FATIGUE <= arg_25_1)) then
			local player_profile = ScriptUnit.extension(self.unit, "dialogue_system").context.player_profile

			SurroundingAwareSystem.add_event(self.unit, "block_broken_by_heavy_hit", DialogueSettings.grabbed_broadcast_range, "profile_name", player_profile)
		end
	end

	if not arg_25_3 then
		local go_id = Managers.state.unit_storage:go_id(self.unit)
		local var_25_5 = NetworkLookup.fatigue_types[arg_25_2]

		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_set_fatigue_points", go_id, arg_25_1, var_25_5)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_fatigue_points", go_id, arg_25_1, var_25_5)
		end
	end
end

GenericStatusExtension.remove_fatigue_points = function (self, arg_26_1)
	-- function 26
	local max = math.max(self.fatigue - arg_26_1, 0)

	self:set_fatigue_points(max, "force_set")
end

GenericStatusExtension.remove_all_fatigue = function (self)
	-- function 27
	self:remove_fatigue_points(math.huge)
end

GenericStatusExtension.get_dodge_item_data = function (self)
	-- function 28
	local inventory_extension = self.inventory_extension
	local get_wielded_slot_name = inventory_extension:get_wielded_slot_name()
	local get_slot_data = inventory_extension:get_slot_data(get_wielded_slot_name)
	local var_28_3

	if not get_slot_data then
		var_28_3 = inventory_extension:get_item_template(get_slot_data).dodge_count
	end

	self.dodge_count = var_28_3 or 2
end

GenericStatusExtension.add_dodge_cooldown = function (self)
	-- function 29
	if not self.buff_extension:has_buff_perk("infinite_dodge") then
		self.dodge_cooldown = 0

		return
	end

	self:get_dodge_item_data()

	self.dodge_cooldown = math.min(self.dodge_cooldown + 1, 3 + self.dodge_count)
	self.dodge_cooldown_delay = nil
end

GenericStatusExtension.start_dodge_cooldown = function (self, arg_30_1)
	-- function 30
	self.dodge_cooldown_delay = arg_30_1 + 0.5
end

GenericStatusExtension.get_dodge_cooldown = function (self)
	-- function 31
	if not self.buff_extension:has_buff_type("passive_career_we_2") then
		return 1
	end

	return 0.4 + 0.6 * (1 - math.max(self.dodge_cooldown - self.dodge_count, 0) / 3)
end

GenericStatusExtension.current_fatigue = function (self)
	-- function 32
	return self.fatigue
end

GenericStatusExtension.current_fatigue_points = function (self)
	-- function 33
	local MAX_FATIGUE = PlayerUnitStatusSettings.MAX_FATIGUE
	local max_fatigue_points = self.max_fatigue_points
	local flag

	flag = max_fatigue_points ~= 0 or not 0 or math.ceil(self.fatigue / (MAX_FATIGUE / max_fatigue_points))

	return flag, max_fatigue_points
end

GenericStatusExtension.set_stagger_immune = function (self, arg_34_1)
	-- function 34
	self.stagger_immune = arg_34_1
end

GenericStatusExtension.set_pushed = function (self, arg_35_1, arg_35_2)
	-- function 35
	if not arg_35_1 and self.push_cooldown and not self.stagger_immune then
		return
	elseif not arg_35_1 then
		self.pushed = arg_35_1
		self.push_cooldown = true
		self.pushed_at_t = arg_35_2
	else
		self.pushed = arg_35_1
	end
end

GenericStatusExtension.set_charged = function (self, arg_36_1, arg_36_2)
	-- function 36
	self.charged = arg_36_1
end

GenericStatusExtension.set_pushed_no_cooldown = function (self, arg_37_1, arg_37_2)
	-- function 37
	if not arg_37_1 and not self.stagger_immune then
		return
	end

	self.pushed = arg_37_1

	if not arg_37_1 then
		self.pushed_at_t = arg_37_2
	end
end

GenericStatusExtension.set_hit_react_type = function (self, arg_38_1)
	-- function 38
	self._hit_react_type = arg_38_1
end

GenericStatusExtension.hitreact_interrupt = function (self)
	-- function 39
	if not self.interrupt_cooldown then
		return false
	else
		self.interrupt_cooldown = true

		return true
	end
end

GenericStatusExtension.is_pushed = function (self)
	-- function 40
	local pushed = self.pushed

	pushed = not pushed and not self.overcharge_exploding

	return pushed
end

GenericStatusExtension.is_charged = function (self)
	-- function 41
	return self.charged
end

GenericStatusExtension.hit_react_type = function (self)
	-- function 42
	local _hit_react_type = self._hit_react_type

	_hit_react_type = _hit_react_type or "light"

	return _hit_react_type
end

GenericStatusExtension.set_block_broken = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	if self.block_broken == arg_43_1 then
		return
	end

	self.block_broken = arg_43_1

	if not arg_43_1 then
		self.block_broken_degen_delay = 2
		self.block_broken_at_t = arg_43_2

		self.buff_extension:trigger_procs("on_block_broken")
		Managers.state.achievement:trigger_event("register_block_broken", self.unit, arg_43_3)
	end

	local player = self.player

	if not (not player and player.remote) then
		local go_id = Managers.state.unit_storage:go_id(self.unit)
		local go_id_2 = Managers.state.unit_storage:go_id(arg_43_3)

		go_id_2 = go_id_2 or 0

		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.block_broken, arg_43_1, go_id, go_id_2)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.block_broken, arg_43_1, go_id, go_id_2)
		end
	end
end

GenericStatusExtension.set_gutter_runner_leaping = function (self, arg_44_1)
	-- function 44
	if self.gutter_runner_leaping == arg_44_1 then
		return
	end

	self.gutter_runner_leaping = arg_44_1

	local player = self.player

	if not (not player and player.remote) then
		local go_id = Managers.state.unit_storage:go_id(self.unit)

		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.gutter_runner_leaping, arg_44_1, go_id, 0)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.gutter_runner_leaping, arg_44_1, go_id, 0)
		end
	end
end

GenericStatusExtension.set_reviving = function (self, arg_45_1, arg_45_2)
	-- function 45
	if self.reviving == arg_45_1 then
		return
	end

	self.reviving = arg_45_1

	local player = self.player

	if not (not Managers.state.network and Managers.state.network:game()) then
		return
	end

	if not (not player and player.remote) then
		local go_id = Managers.state.unit_storage:go_id(self.unit)
		local go_id_2 = Managers.state.unit_storage:go_id(arg_45_2)

		go_id_2 = go_id_2 or 0

		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.reviving, arg_45_1, go_id, go_id_2)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.reviving, arg_45_1, go_id, go_id_2)
		end
	end
end

GenericStatusExtension.set_has_pushed = function (self, arg_46_1)
	-- function 46
	if not self.buff_extension:has_buff_perk("slayer_stamina") then
		self.push_degen_delay = arg_46_1 or 1.5
	end
end

GenericStatusExtension.set_has_blocked = function (self, arg_47_1)
	-- function 47
	self._has_blocked = arg_47_1
end

GenericStatusExtension.set_pounced_down = function (self, arg_48_1, arg_48_2)
	-- function 48
	arg_48_1 = not arg_48_1 and arg_48_2 == nil or Unit.alive(arg_48_2)

	if arg_48_1 == self.pounced_down then
		return
	end

	local unit = self.unit
	local extension = ScriptUnit.extension(unit, "locomotion_system")

	self.pounced_down = arg_48_1

	if not arg_48_1 then
		self.pouncer_unit = arg_48_2

		local flat_no_roll = Quaternion.flat_no_roll(Unit.local_rotation(arg_48_2, 0))
		local multiply = Quaternion.multiply(Quaternion.axis_angle(Vector3.up(), math.pi), flat_no_roll)

		Unit.set_local_rotation(unit, 0, multiply)

		if not self.is_husk then
			extension:set_wanted_velocity(Vector3.zero())
		end

		extension:set_disabled(true, LocomotionUtils.update_local_animation_driven_movement_with_parent, arg_48_2)
	else
		extension:set_disabled(false, LocomotionUtils.update_local_animation_driven_movement_with_parent)

		self.pouncer_unit = nil
	end

	self:set_outline_incapacitated(not not self:is_dead() or self:is_disabled(), arg_48_2, self.pounced_down)

	if not arg_48_1 then
		SurroundingAwareSystem.add_event(unit, "pounced_down", DialogueSettings.pounced_down_broadcast_range, "target", unit, "target_name", ScriptUnit.extension(unit, "dialogue_system").context.player_profile)

		local extension_input = ScriptUnit.extension_input(unit, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		alloc_table.distance = DialogueSettings.pounced_down_broadcast_range
		alloc_table.target = unit
		alloc_table.target_name = ScriptUnit.extension(unit, "dialogue_system").context.player_profile

		extension_input:trigger_dialogue_event("pounced_down", alloc_table)
		Managers.music:trigger_event("enemy_gutter_runner_pounced_stinger")
	end

	if not self.is_server then
		local go_id = Managers.state.unit_storage:go_id(self.unit)
		local go_id_2 = Managers.state.unit_storage:go_id(arg_48_2)

		go_id_2 = go_id_2 or NetworkConstants.invalid_game_object_id

		Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.pounced_down, arg_48_1, go_id, go_id_2)
	end

	if not arg_48_1 then
		ScriptUnit.extension(unit, "buff_system"):trigger_procs("on_player_disabled", "assassin_pounced", arg_48_2)
		Managers.state.event:trigger("on_player_disabled", "assassin_pounced", unit, arg_48_2)
		Managers.state.achievement:trigger_event("register_player_disabled", unit)

		if not self.is_server then
			self.update_funcs.pounced_down = GenericStatusExtension.update_pounced_down
		end
	else
		self.update_funcs.pounced_down = nil
	end

	if not self.is_server and not arg_48_2 then
		local unit_owner = Managers.player:unit_owner(arg_48_2)
		local get_data = Unit.get_data(arg_48_2, "breed")

		if not arg_48_1 and not unit_owner then
			StatisticsUtil.register_disable(unit_owner, Managers.player:statistics_db(), get_data.name)

			local system = Managers.state.entity:system("versus_horde_ability_system")

			if not system then
				system:server_ability_recharge_boost(unit_owner.peer_id, "gutter_runner_pinned")
			end
		end
	end
end

GenericStatusExtension.update_pounced_down = function (self)
	-- function 49
	assert(self.is_server, "[GenericStatusExtension] 'update_pounced_down' is meant to only be called on the server")

	if not HEALTH_ALIVE[self.pouncer_unit] then
		self:set_pounced_down(false, nil)
	end
end

GenericStatusExtension.set_crouching = function (self, arg_50_1)
	-- function 50
	self.crouching = arg_50_1

	self:set_slowed(arg_50_1)

	local player = self.player

	if not (not player and player.remote) then
		local go_id = Managers.state.unit_storage:go_id(self.unit)

		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.crouching, arg_50_1, go_id, 0)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.crouching, arg_50_1, go_id, 0)
		end
	end
end

GenericStatusExtension.crouch_toggle = function (self)
	-- function 51
	return not self.crouching
end

local tbl_5 = {}

GenericStatusExtension.set_knocked_down = function (self, arg_52_1)
	-- function 52
	self.knocked_down = arg_52_1

	local unit = self.unit
	local health_extension = self.health_extension

	health_extension = health_extension or ScriptUnit.extension(unit, "health_system")

	local buff_extension = self.buff_extension

	buff_extension = buff_extension or ScriptUnit.extension(unit, "buff_system")

	local player = self.player
	local is_server = self.is_server

	self:set_outline_incapacitated(not not self:is_dead() or self:is_disabled())

	if not arg_52_1 then
		local str = "knocked_down"
		local _num_times_knocked_down = self._num_times_knocked_down

		if _num_times_knocked_down >= num_6 then
			str = "knocked_down_multiple_times"
		end

		self._num_times_knocked_down = _num_times_knocked_down + 1

		SurroundingAwareSystem.add_event(unit, str, DialogueSettings.knocked_down_broadcast_range, "target", unit, "target_name", ScriptUnit.extension(unit, "dialogue_system").context.player_profile)

		local extension_input = ScriptUnit.extension_input(unit, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		alloc_table.distance = 0
		alloc_table.height_distance = 0
		alloc_table.target_name = ScriptUnit.extension(unit, "dialogue_system").context.player_profile

		extension_input:trigger_dialogue_event("knocked_down", alloc_table)

		local var_52_9 = POSITION_LOOKUP[unit]
		local tbl = {}
		local broadphase_query = AiUtils.broadphase_query(var_52_9, DialogueSettings.knocked_down_broadcast_range, tbl)

		for i = 1, broadphase_query do
			local var_52_12 = tbl[i]
			local has_extension = ScriptUnit.has_extension(var_52_12, "dialogue_system")

			if not has_extension then
				has_extension.input:trigger_dialogue_event("knocked_down", alloc_table)
			end
		end

		if not (not is_server and self.knocked_down_bleed_id) then
			self.knocked_down_bleed_id = buff_extension:add_buff("knockdown_bleed")
		end

		if not player.local_player then
			Managers.state.camera:set_mood("knocked_down", self, true)
		end

		buff_extension:trigger_procs("on_knocked_down")

		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not flag then
			local has_extension_2 = ScriptUnit.has_extension(flag, "buff_system")

			if not has_extension_2 then
				has_extension_2:trigger_procs("on_ally_knocked_down", unit)
			end
		end

		if self._intoxication_level < 0 then
			self._intoxication_level = -1
		end

		StatisticsUtil.register_knockdown(unit, health_extension, Managers.player:statistics_db(), is_server)

		local flag_2 = Managers.mechanism:current_mechanism_name() == "versus"
		local var_52_18 = health_extension:recent_damages()[3]
		local side = Managers.state.side

		if not flag_2 and not side:versus_is_dark_pact(flag) then
			local owner = Managers.player:owner(var_52_18)

			if not (not owner and owner.peer_id == Network.peer_id()) then
				local wwise_world = Managers.world:wwise_world(self.world)

				WwiseWorld.trigger_event(wwise_world, "versus_hud_skaven_down_hero_stinger_1p")
				WwiseWorld.trigger_event(wwise_world, "versus_hud_skaven_down_hero_stinger_3p")
			else
				local wwise_world_2 = Managers.world:wwise_world(self.world)

				WwiseWorld.trigger_event(wwise_world_2, "versus_hud_skaven_down_hero_stinger_3p")
			end
		end
	else
		health_extension:reset()

		if not is_server and not self.knocked_down_bleed_id then
			buff_extension:remove_buff(self.knocked_down_bleed_id)

			self.knocked_down_bleed_id = nil
		end

		if not player.local_player then
			Managers.state.camera:set_mood("knocked_down", self, false)
		end
	end

	if not arg_52_1 then
		if not is_server then
			self:add_pacing_intensity(CurrentIntensitySettings.intensity_add_knockdown)
		end

		local recent_damages, var_52_24 = health_extension:recent_damages()

		pack_index[DamageDataIndex.STRIDE](tbl_5, 1, unpack_index[DamageDataIndex.STRIDE](recent_damages, 1))

		if not player then
			local var_52_25 = tbl_5[DamageDataIndex.DAMAGE_TYPE]
			local var_52_26 = POSITION_LOOKUP[unit]

			Managers.telemetry_events:player_knocked_down(player, var_52_25, var_52_26)
		end

		Managers.state.achievement:trigger_event("player_knocked_down", player)
	end

	Managers.music:check_last_man_standing_music_state()
end

GenericStatusExtension.set_ready_for_assisted_respawn = function (self, arg_53_1, arg_53_2)
	-- function 53
	self.ready_for_assisted_respawn = arg_53_1
	self.assisted_respawn_flavour_unit = arg_53_2

	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(unit, "outline_system")

	if not has_extension then
		return
	end

	local player = self.player

	if not arg_53_1 then
		if not player and not player.local_player then
			self._assisted_respawn_outline_id = has_extension:add_outline(OutlineSettings.templates.ready_for_assisted_respawn)
		else
			self._assisted_respawn_outline_id = has_extension:add_outline(OutlineSettings.templates.ready_for_assisted_respawn_husk)
		end
	else
		has_extension:remove_outline(self._assisted_respawn_outline_id)

		self._assisted_respawn_outline_id = nil
	end
end

GenericStatusExtension.set_assisted_respawning = function (self, arg_54_1, arg_54_2)
	-- function 54
	self.assisted_respawning = arg_54_1
	self.assisted_respawn_helper_unit = arg_54_2
end

GenericStatusExtension.is_assisted_respawning = function (self)
	-- function 55
	return self.assisted_respawning
end

GenericStatusExtension.get_assisted_respawn_helper_unit = function (self)
	-- function 56
	return self.assisted_respawn_helper_unit
end

GenericStatusExtension.set_respawned = function (self, arg_57_1)
	-- function 57
	if not arg_57_1 then
		self:set_ready_for_assisted_respawn(false)
		Managers.music:check_last_man_standing_music_state()
	end
end

GenericStatusExtension.set_dead = function (self, arg_58_1)
	-- function 58
	local player = self.player

	if not arg_58_1 and not ScriptUnit.has_extension(self.unit, "outline_system") then
		ScriptUnit.extension(self.unit, "outline_system"):add_outline(OutlineSettings.templates.dead)
	end

	if not (not arg_58_1 and not player and player.remote) then
		local inventory_extension = self.inventory_extension
		local career_extension = self.career_extension

		CharacterStateHelper.stop_weapon_actions(inventory_extension, "dead")
		CharacterStateHelper.stop_career_abilities(career_extension, "dead")
	end

	Managers.state.achievement:trigger_event("player_dead", player)

	self.dead = arg_58_1
end

GenericStatusExtension.set_blocking = function (self, arg_59_1)
	-- function 59
	self.blocking = arg_59_1

	local inventory_extension = self.inventory_extension
	local get_wielded_slot_name = inventory_extension:get_wielded_slot_name()
	local get_slot_data = inventory_extension:get_slot_data(get_wielded_slot_name)

	if not get_slot_data then
		local shield_block = inventory_extension:get_item_template(get_slot_data).shield_block

		shield_block = shield_block or false
		self.shield_block = shield_block
	end

	if not arg_59_1 then
		self.raise_block_time = Managers.time:time("game")
	end
end

GenericStatusExtension.set_override_blocking = function (self, arg_60_1, arg_60_2)
	-- function 60
	self.override_blocking = arg_60_1

	if not arg_60_2 then
		local network = Managers.state.network
		local game = network:game()
		local unit_game_object_id = network:unit_game_object_id(self.unit)

		if not unit_game_object_id and not game then
			network.network_transmit:send_rpc_server("rpc_set_override_blocking", unit_game_object_id, arg_60_1 or false)
		end
	end
end

GenericStatusExtension.set_charge_blocking = function (self, arg_61_1)
	-- function 61
	self.charge_blocking = arg_61_1
end

GenericStatusExtension.set_stagger_immmune = function (self, arg_62_1)
	-- function 62
	self.stagger_immune = arg_62_1
end

GenericStatusExtension.set_slowed = function (self, arg_63_1)
	-- function 63
	self.is_slowed = arg_63_1
end

GenericStatusExtension.set_wounded = function (self, arg_64_1, arg_64_2, arg_64_3)
	-- function 64
	if not arg_64_1 then
		if not self.buff_extension:has_buff_perk("infinite_wounds") then
			self.wounds = self.wounds - 1
		end
	elseif arg_64_2 == "healed" then
		self.wounds = self:get_max_wounds()
	end

	if not (not self.player.local_player and Managers.state.game_mode:has_activated_mutator("instant_death")) then
		local camera = Managers.state.camera
		local is_wounded = self:is_wounded()
		local wounded_and_on_last_wound = self:wounded_and_on_last_wound()

		camera:set_mood("bleeding_out", self, is_wounded)
		camera:set_mood("wounded", self, wounded_and_on_last_wound)
	end
end

GenericStatusExtension.set_pulled_up = function (self, arg_65_1, arg_65_2)
	-- function 65
	if not self.is_ledge_hanging then
		self.pulled_up = arg_65_1

		if not arg_65_1 and not ALIVE[arg_65_2] then
			local extension_input = ScriptUnit.extension_input(self.unit, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			alloc_table.reviver = arg_65_2
			alloc_table.reviver_name = ScriptUnit.extension(arg_65_2, "dialogue_system").context.player_profile

			extension_input:trigger_dialogue_event("revive_completed", alloc_table)
		end
	elseif not arg_65_1 then
		self.pulled_up = arg_65_1
	end
end

GenericStatusExtension.set_revived = function (self, arg_66_1, arg_66_2)
	-- function 66
	self.revived = arg_66_1

	local unit = self.unit

	if not arg_66_1 then
		if not ALIVE[arg_66_2] then
			local extension_input = ScriptUnit.extension_input(unit, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			alloc_table.reviver = arg_66_2
			alloc_table.reviver_name = ScriptUnit.extension(arg_66_2, "dialogue_system").context.player_profile

			extension_input:trigger_dialogue_event("revive_completed", alloc_table)
			ScriptUnit.extension(arg_66_2, "buff_system"):trigger_procs("on_revived_ally", unit)
		end

		ScriptUnit.extension(unit, "buff_system"):trigger_procs("on_revived", arg_66_2)
	end
end

GenericStatusExtension.set_zooming = function (self, arg_67_1, arg_67_2)
	-- function 67
	self.zooming = arg_67_1

	self:set_slowed(arg_67_1)

	local camera_follow_unit = self.player.camera_follow_unit

	if not arg_67_1 then
		if not Unit.alive(camera_follow_unit) then
			arg_67_2 = arg_67_2 or "zoom_in"

			if not Development.parameter("third_person_mode") then
				arg_67_2 = arg_67_2 .. "_third_person"
			end

			Unit.set_data(camera_follow_unit, "camera", "settings_node", arg_67_2)

			self.zoom_mode = arg_67_2
		end
	else
		if not Unit.alive(camera_follow_unit) then
			if not Development.parameter("third_person_mode") then
				Unit.set_data(camera_follow_unit, "camera", "settings_node", "over_shoulder")
			else
				Unit.set_data(camera_follow_unit, "camera", "settings_node", "first_person_node")
			end
		end

		self.zoom_mode = nil
	end
end

local tbl_6 = {
	"zoom_in",
	"increased_zoom_in"
}

GenericStatusExtension.switch_variable_zoom = function (self, arg_68_1)
	-- function 68
	local camera_follow_unit = self.player.camera_follow_unit

	if not Unit.alive(camera_follow_unit) then
		arg_68_1 = arg_68_1 or tbl_6

		local num = 1

		for i, v in ipairs(arg_68_1) do
			if v == self.zoom_mode then
				num = i % #arg_68_1 + 1

				break
			end
		end

		local var_68_2 = arg_68_1[num]

		Unit.set_data(camera_follow_unit, "camera", "settings_node", var_68_2)

		self.zoom_mode = var_68_2
	end
end

GenericStatusExtension.set_grabbed_by_tentacle = function (self, arg_69_1, arg_69_2)
	-- function 69
	self.grabbed_by_tentacle = arg_69_1
	self.grabbed_by_tentacle_unit = arg_69_2

	local flag

	flag = not arg_69_1 and "grabbed" and nil
	self.grabbed_by_tentacle_status = flag
end

GenericStatusExtension.set_grabbed_by_tentacle_status = function (self, arg_70_1)
	-- function 70
	self.grabbed_by_tentacle_status = arg_70_1
end

GenericStatusExtension.set_grabbed_by_chaos_spawn = function (self, arg_71_1, arg_71_2)
	-- function 71
	self.grabbed_by_chaos_spawn = arg_71_1

	if not arg_71_1 then
		self.grabbed_by_chaos_spawn_status = "grabbed"
		self.grabbed_by_chaos_spawn_status_count = 1
		self.grabbed_by_chaos_spawn_unit = arg_71_2
	else
		self.grabbed_by_chaos_spawn_status = nil
		self.grabbed_by_chaos_spawn_status_count = nil
	end
end

GenericStatusExtension.set_grabbed_by_chaos_spawn_status = function (self, arg_72_1)
	-- function 72
	if not self.grabbed_by_chaos_spawn_status_count then
		self.grabbed_by_chaos_spawn_status = arg_72_1
		self.grabbed_by_chaos_spawn_status_count = self.grabbed_by_chaos_spawn_status_count + 1
	end
end

GenericStatusExtension.set_in_vortex = function (self, arg_73_1, arg_73_2)
	-- function 73
	self.in_vortex = arg_73_1
	self.in_vortex_unit = not arg_73_1 and arg_73_2 and nil

	self:set_outline_incapacitated(not not self:is_dead() or self:is_disabled())
end

GenericStatusExtension.set_near_vortex = function (self, arg_74_1, arg_74_2)
	-- function 74
	self.near_vortex = arg_74_1
	self.near_vortex_unit = not arg_74_1 and arg_74_2 and nil
end

GenericStatusExtension.set_in_liquid = function (self, arg_75_1, arg_75_2)
	-- function 75
	self.in_liquid = arg_75_1
	self.in_liquid_unit = not arg_75_1 and arg_75_2 and nil
end

GenericStatusExtension.set_catapulted = function (self, arg_76_1, arg_76_2)
	-- function 76
	local unit = self.unit

	if not arg_76_1 then
		if not self:is_disabled() then
			self.catapulted = true
			self.last_catapulted_time = Managers.time:time("game")

			if not self.is_husk then
				self.catapulted_velocity = Vector3Box(arg_76_2)

				local extension = ScriptUnit.extension(unit, "first_person_system")
				local dot = Vector3.dot(Quaternion.forward(extension:current_rotation()), arg_76_2)
				local var_76_3
				local var_76_4
				local str

				if dot > 0 then
					var_76_3 = Vector3.normalize(arg_76_2)
					str = "forward"
				else
					var_76_3 = Vector3.normalize(-arg_76_2)
					str = "backward"
				end

				self.catapulted_direction = str

				local look = Quaternion.look(var_76_3, Vector3.up())

				extension:force_look_rotation(look)
			end
		end
	else
		self.catapulted = false
		self.catapulted_direction = nil
		self.catapulted_velocity = nil
	end

	local player = self.player

	if not player and player.remote or not Managers.state.network:game() then
		local go_id = Managers.state.unit_storage:go_id(unit)

		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_set_catapulted", go_id, arg_76_1, arg_76_2 or Vector3.zero())
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_catapulted", go_id, arg_76_1, arg_76_2 or Vector3.zero())
		end
	end
end

GenericStatusExtension.leap_start = function (arg_77_0, arg_77_1)
	-- function 77
	ScriptUnit.has_extension(arg_77_1, "buff_system"):trigger_procs("on_leap_start")
end

GenericStatusExtension.leap_finished = function (arg_78_0, arg_78_1)
	-- function 78
	ScriptUnit.has_extension(arg_78_1, "buff_system"):trigger_procs("on_leap_finished")
end

GenericStatusExtension.set_inside_transport_unit = function (self, arg_79_1)
	-- function 79
	self.inside_transport_unit = arg_79_1
end

GenericStatusExtension.set_using_transport = function (self, arg_80_1)
	-- function 80
	self.using_transport = arg_80_1
end

GenericStatusExtension.set_overcharge_exploding = function (self, arg_81_1)
	-- function 81
	self.overcharge_exploding = arg_81_1
end

GenericStatusExtension.set_left_ladder = function (self, arg_82_1)
	-- function 82
	self.left_ladder_timer = arg_82_1 + PlayerUnitMovementSettings.get_movement_settings_table(self.unit).ladder.leave_ladder_reattach_time
end

GenericStatusExtension.set_is_on_ladder = function (self, arg_83_1, arg_83_2)
	-- function 83
	self.on_ladder = arg_83_1
	self.current_ladder_unit = arg_83_2
end

GenericStatusExtension.set_is_ledge_hanging = function (self, arg_84_1, arg_84_2)
	-- function 84
	self.is_ledge_hanging = arg_84_1
	self.current_ledge_hanging_unit = arg_84_2

	local unit = self.unit

	if not arg_84_1 then
		self.pulled_up = false
	end

	local has_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not arg_84_1 and not has_extension then
		has_extension:trigger_procs("on_ledge_hang_start")
	end

	self:set_outline_incapacitated(not not self:is_dead() or self:is_disabled())

	if not arg_84_1 then
		SurroundingAwareSystem.add_event(unit, "ledge_hanging", DialogueSettings.grabbed_broadcast_range, "target", unit, "target_name", ScriptUnit.extension(unit, "dialogue_system").context.player_profile)

		local extension_input = ScriptUnit.extension_input(unit, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		alloc_table.target_name = ScriptUnit.extension(unit, "dialogue_system").context.player_profile

		extension_input:trigger_dialogue_event("ledge_hanging", alloc_table)
		Managers.state.achievement:trigger_event("register_player_disabled", unit)
	end
end

GenericStatusExtension.set_in_hanging_cage = function (self, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
	-- function 85
	if not arg_85_1 then
		self.in_hanging_cage_unit = arg_85_2 or self.in_hanging_cage_unit
		self.in_hanging_cage_state = arg_85_3 or self.in_hanging_cage_state
		self.in_hanging_cage_animations = arg_85_4 or self.in_hanging_cage_animations
	else
		self.in_hanging_cage_unit = nil
		self.in_hanging_cage_state = nil
		self.in_hanging_cage_animations = nil
	end

	self.in_hanging_cage = arg_85_1
end

GenericStatusExtension.set_outline_incapacitated = function (self, arg_86_1, arg_86_2, arg_86_3)
	-- function 86
	local unit = self.unit
	local player = self.player

	if not player then
		return
	end

	local has_extension = ScriptUnit.has_extension(unit, "outline_system")

	if not has_extension then
		return
	end

	if not arg_86_1 then
		if not (player.local_player or self._incapacitated_outline_ids.target_id) then
			self._incapacitated_outline_ids.target_id = has_extension:add_outline(OutlineSettings.templates.incapacitated)
		end
	else
		local _incapacitated_outline_ids = self._incapacitated_outline_ids

		has_extension:remove_outline(_incapacitated_outline_ids.target_id)

		_incapacitated_outline_ids.target_id = nil
	end

	local has_extension_2 = ScriptUnit.has_extension(arg_86_2, "outline_system")

	if not has_extension_2 then
		arg_86_3 = not has_extension_2 and arg_86_3

		local _incapacitated_outline_ids_2 = self._incapacitated_outline_ids
		local disabler_id = _incapacitated_outline_ids_2.disabler_id

		if not arg_86_3 then
			if not disabler_id then
				_incapacitated_outline_ids_2.disabler_id = has_extension_2:add_outline(OutlineSettings.templates.incapacitated)
			end
		elseif not disabler_id then
			has_extension_2:remove_outline(disabler_id)

			_incapacitated_outline_ids_2.disabler_id = nil
		end
	end
end

GenericStatusExtension._set_packmaster_unhooked = function (self, arg_87_1, arg_87_2)
	-- function 87
	local time = Managers.time:time("game")

	if not self.release_unhook_time then
		-- Nothing
	elseif not self.dead then
		if not (arg_87_2 == "pack_master_dragging" or arg_87_2 ~= "pack_master_pulling") then
			self.release_unhook_time = time + PlayerUnitStatusSettings.hanging_by_pack_master.release_dragging_time_dead
		else
			self.release_unhook_time = time + PlayerUnitStatusSettings.hanging_by_pack_master.release_unhook_time_dead
		end
	elseif not self.knocked_down then
		self.release_unhook_time = time + PlayerUnitStatusSettings.hanging_by_pack_master.release_unhook_time_ko
	else
		self.release_unhook_time = time + PlayerUnitStatusSettings.hanging_by_pack_master.release_unhook_time
	end

	if not self.is_husk then
		arg_87_1:set_wanted_velocity(Vector3.zero())
		arg_87_1:move_to_non_intersecting_position()
	end

	self.pack_master_status = "pack_master_unhooked"
	self.pack_master_grabber = nil
	self.pack_master_player = nil
end

GenericStatusExtension.set_pack_master = function (self, arg_88_1, arg_88_2, arg_88_3)
	-- function 88
	if not self.is_server then
		local pack_master_grabber = self.pack_master_grabber

		if not arg_88_3 and arg_88_3 == pack_master_grabber or not ALIVE[pack_master_grabber] then
			local flag = false
			local flag_2 = true

			return flag, flag_2, pack_master_grabber
		end
	end

	local unit = self.unit

	self.pack_master_grabber = not arg_88_2 and arg_88_3 and nil
	self.pack_master_player = Managers.player:owner(self.pack_master_grabber)

	local pack_master_status = self.pack_master_status

	self.pack_master_status = arg_88_1

	if not arg_88_2 then
		ScriptUnit.extension(unit, "buff_system"):trigger_procs("on_player_disabled", "pack_master_grab", arg_88_3)
		Managers.state.event:trigger("on_player_disabled", "pack_master_grab", unit, arg_88_3)
		Managers.state.achievement:trigger_event("register_player_disabled", unit)
	end

	local extension = ScriptUnit.extension(unit, "locomotion_system")
	local flag_3 = not arg_88_2 and arg_88_1 ~= "pack_master_hanging"
	local player = Managers.player
	local unit_owner = player:unit_owner(arg_88_3)

	if player:local_player() ~= unit_owner then
		self:set_outline_incapacitated(not not self:is_dead() or self:is_disabled(), arg_88_3, flag_3)
	end

	if arg_88_1 == "pack_master_pulling" then
		if not arg_88_2 then
			self:_set_packmaster_unhooked(extension, arg_88_1)

			return true
		end

		local var_88_9 = ALIVE[arg_88_3]

		var_88_9 = not var_88_9 and Unit.get_data(arg_88_3, "breed")

		if (pack_master_status or not var_88_9) and not var_88_9.is_player and not unit_owner and not self.is_server then
			StatisticsUtil.register_disable(unit_owner, Managers.player:statistics_db(), var_88_9.name)

			local system = Managers.state.entity:system("versus_horde_ability_system")

			if not system then
				system:server_ability_recharge_boost(unit_owner.peer_id, "pack_master_grab")
			end
		end

		self.release_unhook_time = nil

		local local_rotation = Unit.local_rotation(arg_88_3, 0)
		local forward = Quaternion.forward(local_rotation)
		local look = Quaternion.look(forward, Vector3.up())

		Unit.set_local_rotation(unit, 0, look)

		if not self.is_husk then
			extension:set_wanted_velocity(Vector3.zero())
		end

		local unit_name = SPProfiles[self.profile_id].unit_name
		local str = "attack_grab_" .. unit_name

		Unit.animation_event(arg_88_3, str)

		local str_2 = "grabbed"
		local _num_times_grabbed_by_pack_master = self._num_times_grabbed_by_pack_master

		if _num_times_grabbed_by_pack_master >= num_3 then
			str_2 = "grabbed_multiple_times"
		end

		self._num_times_grabbed_by_pack_master = _num_times_grabbed_by_pack_master + 1

		SurroundingAwareSystem.add_event(unit, str_2, DialogueSettings.grabbed_broadcast_range, "target", unit, "target_name", ScriptUnit.extension(unit, "dialogue_system").context.player_profile, "enemy_tag", "skaven_pack_master")
		Managers.music:trigger_event("enemy_pack_master_grabbed_stinger")
	elseif arg_88_1 == "pack_master_dragging" then
		if not arg_88_2 then
			self:_set_packmaster_unhooked(extension, arg_88_1)

			return true
		end

		if pack_master_status == "pack_master_pulling" then
			extension:set_disabled(false, nil, nil, true)
		end
	elseif arg_88_1 == "pack_master_unhooked" then
		if pack_master_status ~= "pack_master_unhooked" then
			self:_set_packmaster_unhooked(extension, arg_88_1)
		end

		extension:set_disabled(false, nil, nil, true)
	elseif arg_88_1 == "pack_master_hoisting" then
		if not arg_88_2 then
			self:_set_packmaster_unhooked(extension, arg_88_1)

			return true
		end

		if not self.is_husk then
			extension:set_wanted_velocity(Vector3.zero())
		end

		local function fn()
			-- function 89
			if not ALIVE[unit] then
				return
			end

			local var_89_0 = ALIVE[arg_88_3]

			var_89_0 = not var_89_0 and Unit.get_data(arg_88_3, "breed")

			if not var_89_0 and not var_89_0.is_player then
				local get_data = World.get_data(self.world, "physics_world")
				local get_hoist_position = PactswornUtils.get_hoist_position(get_data, unit, arg_88_3)

				extension:teleport_to(get_hoist_position, nil)
			end
		end

		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn)

		local normalize = Vector3.normalize(POSITION_LOOKUP[unit] - POSITION_LOOKUP[arg_88_3])

		Vector3.set_z(normalize, 0)
		Unit.set_local_rotation(unit, 0, Quaternion.look(normalize, Vector3.up()))
		extension:set_disabled(true, LocomotionUtils.update_local_animation_driven_movement_plus_mover)
	elseif arg_88_1 == "pack_master_hanging" then
		extension:set_disabled(true, LocomotionUtils.update_local_animation_driven_movement_plus_mover)

		if not self.is_server then
			local system_2 = Managers.state.entity:system("versus_horde_ability_system")

			if not system_2 and not unit_owner then
				system_2:server_ability_recharge_boost(unit_owner.peer_id, "pack_master_hoist")
			end

			if not Managers.player:owner(arg_88_3) then
				ScriptUnit.extension_input(arg_88_3, "dialogue_system"):trigger_dialogue_event("vs_packmaster_hoisted_player")
			end
		end
	elseif arg_88_1 == "pack_master_dropping" then
		local time = Managers.time:time("game")

		extension:set_disabled(false, nil, nil, true)

		if not self.release_falling_time then
			-- Nothing
		elseif not self.dead then
			self.release_falling_time = time + PlayerUnitStatusSettings.hanging_by_pack_master.release_falling_time_dead
		elseif not self.knocked_down then
			self.release_falling_time = time + PlayerUnitStatusSettings.hanging_by_pack_master.release_falling_time_ko
		else
			extension:set_disabled(false, nil, nil, true)

			self.release_falling_time = time + PlayerUnitStatusSettings.hanging_by_pack_master.release_falling_time
		end
	elseif arg_88_1 == "pack_master_released" then
		SurroundingAwareSystem.add_event(unit, "un_grabbed", DialogueSettings.grabbed_broadcast_range, "target", unit, "target_name", ScriptUnit.extension(unit, "dialogue_system").context.player_profile)

		if not Managers.state.network.is_server then
			extension:set_disabled(false, nil, nil, true)
		end
	end

	return true
end

GenericStatusExtension.query_pack_master_player = function (self)
	-- function 90
	return self.pack_master_player
end

GenericStatusExtension.hit_by_globadier_poison = function (self, arg_91_1)
	-- function 91
	local time = Managers.time:time("game")
	local _hit_by_globadier_poison_instances = self._hit_by_globadier_poison_instances
	local num = 0

	for k, v in pairs(_hit_by_globadier_poison_instances) do
		if time > v.t then
			_hit_by_globadier_poison_instances[k] = nil
		elseif not v.claimed then
			num = num + 1
		end
	end

	local str = "hit_by_goo"

	if not _hit_by_globadier_poison_instances[arg_91_1] then
		_hit_by_globadier_poison_instances[arg_91_1].t = time + num_5
	else
		_hit_by_globadier_poison_instances[arg_91_1] = {
			t = time + num_5
		}
		num = num + 1
	end

	if num > num_4 then
		str = "hit_by_goo_multiple_times"

		for k_2, v_2 in pairs(_hit_by_globadier_poison_instances) do
			v_2.claimed = true
		end
	end

	local unit = self.unit

	SurroundingAwareSystem.add_event(unit, str, DialogueSettings.globadier_poisoned_broadcast_range, "target", unit, "target_name", ScriptUnit.extension(unit, "dialogue_system").context.player_profile)
end

GenericStatusExtension.set_grabbed_by_corruptor = function (self, arg_92_1, arg_92_2, arg_92_3)
	-- function 92
	local unit = self.unit

	self.corruptor_grabbed = not arg_92_2 and arg_92_3 and nil
	self.grabbed_by_corruptor = arg_92_2
	self.corruptor_unit = arg_92_3
	self.corruptor_status = arg_92_1

	self:set_outline_incapacitated(not not self:is_dead() or self:is_disabled(), arg_92_3, arg_92_2)

	local extension = ScriptUnit.extension(unit, "locomotion_system")

	if arg_92_1 == "chaos_corruptor_grabbed" then
		if not self.is_husk then
			extension:set_wanted_velocity(Vector3.zero())
		end

		SurroundingAwareSystem.add_event(unit, "grabbed", DialogueSettings.grabbed_broadcast_range, "target", unit, "target_name", ScriptUnit.extension(unit, "dialogue_system").context.player_profile, "enemy_tag", "chaos_corruptor_sorcerer")
		Managers.music:trigger_event("enemy_pack_master_grabbed_stinger")
	elseif not (arg_92_1 ~= "chaos_corruptor_released" or self.is_husk) then
		extension:set_wanted_velocity(Vector3.zero())
		extension:move_to_non_intersecting_position()
	end

	if not arg_92_2 then
		ScriptUnit.extension(unit, "buff_system"):trigger_procs("on_player_disabled", "corruptor_grab", self.corruptor_unit)
		Managers.state.event:trigger("on_player_disabled", "corruptor_grab", unit, self.corruptor_unit)
		Managers.state.achievement:trigger_event("register_player_disabled", unit)
	end
end

GenericStatusExtension.get_pacing_intensity = function (self)
	-- function 93
	return self.pacing_intensity
end

GenericStatusExtension.get_combo_target_count = function (self)
	-- function 94
	return self.combo_target_count
end

GenericStatusExtension.is_pounced_down = function (self)
	-- function 95
	return self.pounced_down, self.pouncer_unit
end

GenericStatusExtension.get_pouncer_unit = function (self)
	-- function 96
	return self.pouncer_unit
end

GenericStatusExtension.is_knocked_down = function (self)
	-- function 97
	return self.knocked_down
end

GenericStatusExtension.set_knocked_down_bleed_buff_paused = function (self, arg_98_1)
	-- function 98
	local unit = self.unit
	local buff_extension = self.buff_extension

	buff_extension = buff_extension or ScriptUnit.extension(unit, "buff_system")

	if not self.knocked_down_bleed_id and not arg_98_1 then
		buff_extension:remove_buff(self.knocked_down_bleed_id)

		self.knocked_down_bleed_id = nil
	elseif not (not self.knocked_down and arg_98_1 or self.knocked_down_bleed_id) then
		self.knocked_down_bleed_id = buff_extension:add_buff("knockdown_bleed")
	end

	return self.knocked_down_bleed_id
end

GenericStatusExtension.is_ready_for_assisted_respawn = function (self)
	-- function 99
	return self.ready_for_assisted_respawn
end

GenericStatusExtension.disabled_vo_reason = function (self)
	-- function 100
	local var_100_0

	if not self:is_dead() then
		var_100_0 = "dead"
	elseif not self:is_pounced_down() then
		var_100_0 = "pounced_down"
	elseif self:is_grabbed_by_pack_master() or not self:is_hanging_from_hook() then
		var_100_0 = "grabbed"
	elseif not self:get_is_ledge_hanging() then
		var_100_0 = "ledge_hanging"
	elseif self:is_knocked_down() or not self:is_ready_for_assisted_respawn() then
		var_100_0 = "knocked_down"
	end

	return var_100_0
end

GenericStatusExtension.set_has_bonus_fatigue_active = function (self)
	-- function 101
	self.has_bonus_fatigue_active = true
	self.bonus_fatigue_active_timer = Managers.time:time("game") + 1.5

	local first_person_extension = self.first_person_extension

	if not first_person_extension then
		first_person_extension:play_hud_sound_event("hud_player_buff_regen_stamina")
	end
end

GenericStatusExtension.get_disabler_unit = function (self)
	-- function 102
	local grabbed_by_tentacle_unit = self.grabbed_by_tentacle_unit

	if not grabbed_by_tentacle_unit then
		grabbed_by_tentacle_unit = self.pouncer_unit

		if not grabbed_by_tentacle_unit then
			grabbed_by_tentacle_unit = self.grabbed_by_chaos_spawn_unit

			if not grabbed_by_tentacle_unit then
				grabbed_by_tentacle_unit = self.pack_master_grabber
				grabbed_by_tentacle_unit = grabbed_by_tentacle_unit or self.corruptor_unit
			end
		end
	end

	if not Unit.alive(grabbed_by_tentacle_unit) then
		return grabbed_by_tentacle_unit
	end
end

GenericStatusExtension.is_disabled_by_pact_sworn = function (self)
	-- function 103
	local is_hanging_from_hook = self:is_hanging_from_hook()

	if not is_hanging_from_hook then
		is_hanging_from_hook = self:is_grabbed_by_tentacle()

		if not is_hanging_from_hook then
			is_hanging_from_hook = self:is_grabbed_by_chaos_spawn()

			if not is_hanging_from_hook then
				is_hanging_from_hook = self:is_in_vortex()

				if not is_hanging_from_hook then
					is_hanging_from_hook = self:is_grabbed_by_corruptor()

					if not is_hanging_from_hook then
						is_hanging_from_hook = self:is_pounced_down()
						is_hanging_from_hook = is_hanging_from_hook or self:is_grabbed_by_pack_master()
					end
				end
			end
		end
	end

	return is_hanging_from_hook
end

GenericStatusExtension.is_disabled = function (self)
	-- function 104
	local is_dead = self:is_dead()

	if not is_dead then
		is_dead = self:is_knocked_down()

		if not is_dead then
			is_dead = self:get_is_ledge_hanging()

			if not is_dead then
				is_dead = self:is_hanging_from_hook()

				if not is_dead then
					is_dead = self:is_ready_for_assisted_respawn()

					if not is_dead then
						is_dead = self:is_grabbed_by_tentacle()

						if not is_dead then
							is_dead = self:is_grabbed_by_chaos_spawn()

							if not is_dead then
								is_dead = self:is_in_vortex()

								if not is_dead then
									is_dead = self:is_grabbed_by_corruptor()

									if not is_dead then
										is_dead = self:is_overpowered()

										if not is_dead then
											is_dead = self:is_pounced_down()
											is_dead = is_dead or self:is_grabbed_by_pack_master()
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	return is_dead
end

GenericStatusExtension.disabled_by_other = function (self, arg_105_1)
	-- function 105
	local is_dead = self:is_dead()

	if not is_dead then
		is_dead = self:is_knocked_down()

		if not is_dead then
			is_dead = self:get_is_ledge_hanging()

			if not is_dead then
				is_dead = self:is_hanging_from_hook()

				if not is_dead then
					is_dead = self:is_ready_for_assisted_respawn()

					if not is_dead then
						is_dead = self:is_grabbed_by_tentacle()

						if not is_dead then
							is_dead = self:is_grabbed_by_chaos_spawn()

							if not is_dead then
								is_dead = self:is_in_vortex()

								if not is_dead then
									is_dead = self:is_grabbed_by_corruptor()

									if not is_dead then
										is_dead = self:is_overpowered()

										if not is_dead then
											if not (not self:is_pounced_down() and self:get_pouncer_unit() ~= arg_105_1) then
												is_dead = self:is_grabbed_by_pack_master()

												if not is_dead then
													-- Nothing
												end

												if self:get_pack_master_grabber() == arg_105_1 then
													is_dead = false

													goto label_105_0
												end
											end

											is_dead = true
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	::label_105_0::

	return is_dead
end

GenericStatusExtension.is_disabled_non_temporarily = function (self)
	-- function 106
	local is_dead = self:is_dead()

	if not is_dead then
		is_dead = self:is_pounced_down()

		if not is_dead then
			is_dead = self:is_knocked_down()

			if not is_dead then
				is_dead = self:is_grabbed_by_pack_master()

				if not is_dead then
					is_dead = self:get_is_ledge_hanging()

					if not is_dead then
						is_dead = self:is_hanging_from_hook()

						if not is_dead then
							is_dead = self:is_ready_for_assisted_respawn()

							if not is_dead then
								is_dead = self:is_grabbed_by_tentacle()

								if not is_dead then
									is_dead = self:is_grabbed_by_corruptor()
									is_dead = is_dead or self:is_overpowered()
								end
							end
						end
					end
				end
			end
		end
	end

	return is_dead
end

GenericStatusExtension.is_valid_vortex_target = function (self)
	-- function 107
	return not not self:is_dead() or not not self:is_pounced_down() or not not self:is_knocked_down() or not not self:is_grabbed_by_pack_master() or not not self:get_is_ledge_hanging() or not not self:is_hanging_from_hook() or not not self:is_ready_for_assisted_respawn() or not not self:is_grabbed_by_tentacle() or not not self:is_grabbed_by_chaos_spawn() or not self:is_in_end_zone()
end

GenericStatusExtension.is_valid_corruptor_target = function (self)
	-- function 108
	return not not self:is_dead() or not not self:is_pounced_down() or not not self:is_knocked_down() or not not self:is_grabbed_by_pack_master() or not not self:get_is_ledge_hanging() or not not self:is_hanging_from_hook() or not not self:is_ready_for_assisted_respawn() or not not self:is_grabbed_by_tentacle() or not not self:is_grabbed_by_chaos_spawn() or not self:is_in_end_zone()
end

GenericStatusExtension.is_ogre_target = function (self)
	-- function 109
	return not not self:is_dead() or not not self:is_pounced_down() or not not self:is_grabbed_by_pack_master() or not not self:is_hanging_from_hook() or not not self:is_using_transport() or not not self:is_grabbed_by_tentacle() or not self:is_grabbed_by_chaos_spawn()
end

GenericStatusExtension.is_chaos_spawn_target = function (self)
	-- function 110
	return not not self:is_dead() or not not self:is_knocked_down() or not not self:is_pounced_down() or not not self:is_grabbed_by_pack_master() or not not self:is_hanging_from_hook() or not not self:is_using_transport() or not not self:is_grabbed_by_tentacle() or not self:is_grabbed_by_chaos_spawn()
end

GenericStatusExtension.is_lord_target = function (self)
	-- function 111
	return not not self:is_dead() or not not self:is_knocked_down() or not not self:is_pounced_down() or not not self:is_grabbed_by_pack_master() or not not self:is_hanging_from_hook() or not not self:is_using_transport() or not not self:is_grabbed_by_tentacle() or not self:is_grabbed_by_chaos_spawn()
end

GenericStatusExtension.is_available_for_career_revive = function (self)
	-- function 112
	local is_knocked_down = self:is_knocked_down()

	is_knocked_down = not is_knocked_down and not not self:is_pounced_down() and not not self:is_grabbed_by_pack_master() and not not self:is_hanging_from_hook() and not not self:is_grabbed_by_tentacle() or not self:is_grabbed_by_chaos_spawn()

	return is_knocked_down
end

GenericStatusExtension.is_grabbed_by_tentacle = function (self)
	-- function 113
	return self.grabbed_by_tentacle
end

GenericStatusExtension.is_grabbed_by_corruptor = function (self)
	-- function 114
	return self.grabbed_by_corruptor
end

GenericStatusExtension.is_grabbed_by_chaos_spawn = function (self)
	-- function 115
	return self.grabbed_by_chaos_spawn
end

GenericStatusExtension.is_in_liquid = function (self)
	-- function 116
	return self.in_liquid
end

GenericStatusExtension.is_dead = function (self)
	-- function 117
	return self.dead
end

GenericStatusExtension.is_crouching = function (self)
	-- function 118
	return self.crouching
end

GenericStatusExtension.is_blocking = function (self)
	-- function 119
	local blocking

	if self.override_blocking == nil then
		blocking = self.blocking

		if not blocking then
			-- Nothing
		end
	end

	blocking = self.override_blocking

	::label_119_0::

	return blocking, self.shield_block
end

GenericStatusExtension.is_wounded = function (self)
	-- function 120
	return self.wounds < self:get_max_wounds()
end

GenericStatusExtension.wounded_and_on_last_wound = function (self)
	-- function 121
	return self.wounds ~= 1 or self:get_max_wounds() > 1
end

GenericStatusExtension.is_permanent_heal = function (self, arg_122_1)
	-- function 122
	local has_extension = ScriptUnit.has_extension(self.unit, "buff_system")

	if not has_extension then
		if not has_extension:has_buff_perk("disable_permanent_heal") then
			return false
		end

		if not has_extension:has_buff_perk("temp_to_permanent_health") then
			return true
		end
	end

	return arg_122_1 == "healing_draught" or arg_122_1 == "bandage" or arg_122_1 == "bandage_trinket" or arg_122_1 == "buff_shared_medpack" or arg_122_1 == "career_passive" or arg_122_1 == "health_regen" or arg_122_1 == "debug" or arg_122_1 == "health_conversion"
end

GenericStatusExtension.heal_can_remove_wounded = function (arg_123_0, arg_123_1)
	-- function 123
	return arg_123_1 == "healing_draught" or arg_123_1 == "bandage" or arg_123_1 == "bandage_trinket" or arg_123_1 == "buff_shared_medpack" or arg_123_1 == "debug" or arg_123_1 == "healing_draught_temp_health" or arg_123_1 == "bandage_temp_health" or arg_123_1 == "buff_shared_medpack_temp_health"
end

GenericStatusExtension.is_revived = function (self)
	-- function 124
	return self.revived
end

GenericStatusExtension.is_reviving = function (self)
	-- function 125
	return self.reviving
end

GenericStatusExtension.is_pulled_up = function (self)
	-- function 126
	return self.pulled_up
end

GenericStatusExtension.is_zooming = function (self)
	-- function 127
	return self.zooming
end

GenericStatusExtension.num_wounds_remaining = function (self)
	-- function 128
	return self.wounds
end

GenericStatusExtension.has_wounds_remaining = function (self)
	-- function 129
	return self.wounds > 1
end

GenericStatusExtension.has_recently_left_ladder = function (self, arg_130_1)
	-- function 130
	return arg_130_1 < self.left_ladder_timer
end

GenericStatusExtension.get_is_on_ladder = function (self)
	-- function 131
	return self.on_ladder, self.current_ladder_unit
end

GenericStatusExtension.get_is_ledge_hanging = function (self)
	-- function 132
	return self.is_ledge_hanging, self.current_ledge_hanging_unit
end

GenericStatusExtension.is_catapulted = function (self)
	-- function 133
	return self.catapulted, self.catapulted_direction
end

GenericStatusExtension.is_in_vortex = function (self)
	-- function 134
	return self.in_vortex
end

GenericStatusExtension.is_block_broken = function (self)
	-- function 135
	return self.block_broken
end

GenericStatusExtension.is_gutter_runner_leaping = function (self)
	-- function 136
	return self.gutter_runner_leaping
end

GenericStatusExtension.get_inside_transport_unit = function (self)
	-- function 137
	return self.inside_transport_unit
end

GenericStatusExtension.is_using_transport = function (self)
	-- function 138
	return self.using_transport
end

GenericStatusExtension.is_overcharge_exploding = function (self)
	-- function 139
	return self.overcharge_exploding
end

GenericStatusExtension.is_grabbed_by_pack_master = function (self)
	-- function 140
	return self.pack_master_grabber == nil or Unit.alive(self.pack_master_grabber)
end

GenericStatusExtension.is_hanging_from_hook = function (self)
	-- function 141
	return self.pack_master_status == "pack_master_hanging"
end

GenericStatusExtension.is_dropping_from_hook = function (self)
	-- function 142
	return self.pack_master_status == "pack_master_dropping"
end

GenericStatusExtension.get_pack_master_grabber = function (self)
	-- function 143
	return self.pack_master_grabber
end

GenericStatusExtension.has_blocked = function (self)
	-- function 144
	return self._has_blocked
end

GenericStatusExtension.reset_move_speed_multiplier = function (self)
	-- function 145
	self.move_speed_multiplier = 1
	self.move_speed_multiplier_timer = 1
end

GenericStatusExtension.current_move_speed_multiplier = function (self)
	-- function 146
	local smoothstep = math.smoothstep(self.move_speed_multiplier_timer, 0, 1)

	return math.lerp(self.move_speed_multiplier, 1, smoothstep)
end

GenericStatusExtension.set_invisible = function (self, arg_147_1, arg_147_2, arg_147_3)
	-- function 147
	assert(not not arg_147_3 ~= not not self.is_husk, "Setting invisibility is only allowed locally.")

	if not self.is_husk then
		local is_invisible = self:is_invisible()

		self.invisible[arg_147_3] = arg_147_1 or nil

		if is_invisible == self:is_invisible() then
			return false
		end
	else
		self.invisible.network_sync = arg_147_1 or nil
	end

	local unit = self.unit
	local var_147_2
	local flag = not arg_147_2
	local local_player = Managers.player:local_player()
	local side = Managers.state.side
	local var_147_6 = side.side_by_unit[unit]
	local flag_2 = not local_player and Managers.party:get_party_from_player_id(local_player:network_id(), local_player:local_player_id())
	local flag_3 = not flag_2 and side.side_by_party[flag_2]
	local is_enemy_by_side = side:is_enemy_by_side(flag_3, var_147_6)
	local enemy_fade

	if not is_enemy_by_side then
		enemy_fade = PlayerUnitStatusSettings.invisibility.enemy_fade

		if not enemy_fade then
			-- Nothing
		end
	end

	enemy_fade = PlayerUnitStatusSettings.invisibility.friendly_fade

	::label_147_0::

	if not arg_147_1 then
		var_147_2 = "lua_enabled_invisibility"

		if not flag then
			Managers.state.entity:system("fade_system"):set_min_fade(unit, enemy_fade)
		end

		if not is_enemy_by_side then
			self._invisible_outline_id = ScriptUnit.extension(self.unit, "outline_system"):add_outline(OutlineSettings.templates.invisible)
		end

		if not DEDICATED_SERVER then
			self.update_funcs.invisible = GenericStatusExtension.update_invisibility
		end
	else
		var_147_2 = "lua_disabled_invisibility"

		if not flag then
			Managers.state.entity:system("fade_system"):set_min_fade(unit, 0)
		end

		if not is_enemy_by_side then
			ScriptUnit.extension(self.unit, "outline_system"):remove_outline(self._invisible_outline_id)

			self._invisible_outline_id = -1
		end

		if not DEDICATED_SERVER then
			self.update_funcs.invisible = nil
		end
	end

	if not flag then
		Unit.flow_event(unit, var_147_2)
	else
		local first_person_extension = self.first_person_extension

		if not first_person_extension then
			local get_first_person_unit = first_person_extension:get_first_person_unit()
			local get_first_person_mesh_unit = first_person_extension:get_first_person_mesh_unit()

			Unit.flow_event(get_first_person_unit, var_147_2)
			Unit.flow_event(get_first_person_mesh_unit, var_147_2)
		end
	end

	local buff_extension = self.buff_extension

	if not arg_147_1 then
		buff_extension:trigger_procs("on_invisible")
	else
		buff_extension:trigger_procs("on_visible")
	end

	if not self.is_husk then
		local network = Managers.state.network

		if not network and not network:game() then
			local go_id = Managers.state.unit_storage:go_id(unit)

			if not self.is_server then
				network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.invisible, arg_147_1, go_id, 0)
			else
				network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.invisible, arg_147_1, go_id, 0)
			end
		end
	end
end

GenericStatusExtension.update_invisibility = function (self, arg_148_1, arg_148_2)
	-- function 148
	local local_player = Managers.player:local_player()
	local unit = self.unit
	local side = Managers.state.side
	local var_148_3 = side.side_by_unit[unit]
	local flag = not local_player and Managers.party:get_party_from_player_id(local_player:network_id(), local_player:local_player_id())
	local flag_2 = not flag and side.side_by_party[flag]

	if not side:is_enemy_by_side(flag_2, var_148_3) then
		local enemy_fade = PlayerUnitStatusSettings.invisibility.enemy_fade
		local disabled_enemy_fade_min = PlayerUnitStatusSettings.invisibility.disabled_enemy_fade_min
		local disabled_enemy_fade_max = PlayerUnitStatusSettings.invisibility.disabled_enemy_fade_max
		local _invis_fade_value = self._invis_fade_value
		local var_148_10 = enemy_fade

		if not self:is_disabled() then
			local intensity = PlayerUnitStatusSettings.invisibility.intensity
			local clamp = math.clamp
			local _invis_fade_value_2 = self._invis_fade_value

			_invis_fade_value_2 = _invis_fade_value_2 or 1
			var_148_10 = clamp(_invis_fade_value_2 + (math.random(0, 1) * 2 - 1) * arg_148_2 * intensity, disabled_enemy_fade_min, disabled_enemy_fade_max)
		end

		if var_148_10 ~= _invis_fade_value then
			self._invis_fade_value = var_148_10

			Managers.state.entity:system("fade_system"):set_min_fade(unit, var_148_10)
		end
	end
end

GenericStatusExtension.set_move_through_ai = function (self, arg_149_1)
	-- function 149
	self.move_through_ai = arg_149_1

	self:set_noclip(arg_149_1, "move_through_ai")
end

GenericStatusExtension.has_noclip = function (self)
	-- function 150
	return not table.is_empty(self.noclip)
end

GenericStatusExtension.set_noclip = function (self, arg_151_1, arg_151_2)
	-- function 151
	local has_noclip = self:has_noclip()

	self.noclip[arg_151_2] = arg_151_1 or nil

	if has_noclip == self:has_noclip() then
		return
	end

	if not self.is_husk then
		self.locomotion_extension:set_mover_filter_property("enemy_noclip", arg_151_1)
	end
end

GenericStatusExtension.is_invisible = function (self)
	-- function 152
	return not table.is_empty(self.invisible)
end

GenericStatusExtension.set_inspecting = function (self, arg_153_1)
	-- function 153
	self.inspecting = arg_153_1
end

GenericStatusExtension.is_inspecting = function (self)
	-- function 154
	return self.inspecting
end

GenericStatusExtension.set_overpowered = function (self, arg_155_1, arg_155_2, arg_155_3)
	-- function 155
	self.overpowered = arg_155_1
	self.overpowered_template = arg_155_2
	self.overpowered_attacking_unit = arg_155_3

	self:set_outline_incapacitated(not not self:is_dead() or self:is_disabled())
end

GenericStatusExtension.is_overpowered = function (self)
	-- function 156
	return self.overpowered
end

GenericStatusExtension.is_overpowered_by_attacker = function (self)
	-- function 157
	return self.overpowered_attacking_unit ~= self.unit
end

GenericStatusExtension.can_dodge = function (self, arg_158_1)
	-- function 158
	local has_buff_perk = self.buff_extension:has_buff_perk("root")

	return not (arg_158_1 > self.my_dodge_cd) or not has_buff_perk
end

GenericStatusExtension.set_dodge_cd = function (self, arg_159_1, arg_159_2)
	-- function 159
	self.my_dodge_cd = arg_159_1 + arg_159_2
end

GenericStatusExtension.can_override_dodge_with_jump = function (self, arg_160_1)
	-- function 160
	return arg_160_1 < self.my_dodge_jump_override_t
end

GenericStatusExtension.set_dodge_jump_override_t = function (self, arg_161_1, arg_161_2)
	-- function 161
	self.my_dodge_jump_override_t = arg_161_1 + arg_161_2
end

GenericStatusExtension.dodge_locked = function (self)
	-- function 162
	return self.dodge_is_locked
end

GenericStatusExtension.set_dodge_locked = function (self, arg_163_1)
	-- function 163
	self.dodge_is_locked = arg_163_1
end

GenericStatusExtension.set_is_dodging = function (self, arg_164_1)
	-- function 164
	self.is_dodging = arg_164_1

	if not arg_164_1 then
		self.dodge_position:store(Unit.world_position(self.unit, 0))
	end

	if not self.is_husk then
		local go_id = Managers.state.unit_storage:go_id(self.unit)

		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.dodging, arg_164_1, go_id, 0)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, arg_164_1, go_id, 0)
		end
	end
end

GenericStatusExtension.get_is_dodging = function (self)
	-- function 165
	local is_dodging = self.is_dodging

	is_dodging = not is_dodging and self.dodge_cooldown <= self.dodge_count

	return is_dodging
end

GenericStatusExtension.get_dodge_position = function (self)
	-- function 166
	return self.dodge_position:unbox()
end

GenericStatusExtension.get_is_slowed = function (self)
	-- function 167
	return self.is_slowed
end

GenericStatusExtension.set_falling_height = function (self, arg_168_1, arg_168_2)
	-- function 168
	fassert(not self.is_husk, "Trying to set falling height on non-owned unit")

	if not ALIVE[self.unit] then
		self.fall_height = arg_168_2 or not self.fall_height or not arg_168_1 or self.fall_height > POSITION_LOOKUP[self.unit].z or self.fall_height or POSITION_LOOKUP[self.unit].z
		self.update_funcs.falling = GenericStatusExtension.update_falling
	end
end

GenericStatusExtension.max_wounds_network_safe = function (self)
	-- function 169
	local get_max_wounds = self:get_max_wounds()

	if get_max_wounds == math.huge then
		get_max_wounds = -1
	end

	return get_max_wounds
end

GenericStatusExtension.hot_join_sync = function (self, arg_170_1)
	-- function 170
	if not Managers.state.unit_spawner:is_marked_for_deletion(self.unit) then
		return
	end

	local statuses = NetworkLookup.statuses
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(self.unit)
	local var_170_3 = PEER_ID_TO_CHANNEL[arg_170_1]
	local unit_game_object_id_2

	if not self.ready_for_assisted_respawn then
		unit_game_object_id_2 = network:unit_game_object_id(self.assisted_respawn_flavour_unit)

		if not unit_game_object_id_2 then
			-- Nothing
		end
	end

	unit_game_object_id_2 = 0

	::label_170_0::

	RPC.rpc_hot_join_sync_health_status(var_170_3, unit_game_object_id, self:max_wounds_network_safe(), self.ready_for_assisted_respawn, unit_game_object_id_2)

	if not self.pack_master_status then
		local time = Managers.time:time("game")
		local alive = Unit.alive(self.pack_master_grabber)
		local unit_game_object_id_3 = network:unit_game_object_id(self.pack_master_grabber)

		unit_game_object_id_3 = unit_game_object_id_3 or NetworkConstants.invalid_game_object_id

		local var_170_8 = statuses[self.pack_master_status]

		if self.pack_master_status == "pack_master_dropping" then
			local clamp = math.clamp(time - self.release_falling_time, 0, 7)

			RPC.rpc_hooked_sync(var_170_3, var_170_8, unit_game_object_id, clamp)
		elseif self.pack_master_status == "pack_master_unhooked" then
			local clamp_2 = math.clamp(time - self.release_unhook_time, 0, 7)

			RPC.rpc_hooked_sync(var_170_3, var_170_8, unit_game_object_id, clamp_2)
		end

		RPC.rpc_status_change_bool(var_170_3, var_170_8, alive, unit_game_object_id, unit_game_object_id_3)
	end

	local unit_game_object_id_4

	if not self.is_ledge_hanging then
		unit_game_object_id_4 = network:unit_game_object_id(self.current_ledge_hanging_unit)

		if not unit_game_object_id_4 then
			-- Nothing
		end
	end

	unit_game_object_id_4 = 0

	do
		local unit_game_object_id_5
	end

	::label_170_1::

	if not self.pounced_down then
		unit_game_object_id_5 = network:unit_game_object_id(self.pouncer_unit)

		if not unit_game_object_id_5 then
			-- Nothing
		end
	end

	unit_game_object_id_5 = 0

	do
		local unit_game_object_id_6
	end

	::label_170_2::

	if not self.on_ladder then
		unit_game_object_id_6 = network:unit_game_object_id(self.current_ladder_unit)

		if not unit_game_object_id_6 then
			-- Nothing
		end
	end

	unit_game_object_id_6 = 0

	::label_170_3::

	RPC.rpc_status_change_bool(var_170_3, statuses.pounced_down, self.pounced_down, unit_game_object_id, unit_game_object_id_5)
	RPC.rpc_status_change_bool(var_170_3, statuses.pushed, self.pushed, unit_game_object_id, 0)
	RPC.rpc_status_change_bool(var_170_3, statuses.charged, self.charged, unit_game_object_id, 0)
	RPC.rpc_status_change_bool(var_170_3, statuses.dead, self.dead, unit_game_object_id, 0)

	local unit_game_object_id_7 = network:unit_game_object_id(self.grabbed_by_tentacle_unit)

	unit_game_object_id_7 = unit_game_object_id_7 or NetworkConstants.invalid_game_object_id

	RPC.rpc_status_change_bool(var_170_3, statuses.grabbed_by_tentacle, self.grabbed_by_tentacle, unit_game_object_id, unit_game_object_id_7)

	if not (not self.grabbed_by_tentacle_status and self.grabbed_by_tentacle_status == "grabbed") then
		local var_170_15 = NetworkLookup.grabbed_by_tentacle[self.grabbed_by_tentacle_status]

		RPC.rpc_status_change_int(var_170_3, statuses.grabbed_by_tentacle, var_170_15, unit_game_object_id)
	end

	local unit_game_object_id_8 = network:unit_game_object_id(self.grabbed_by_chaos_spawn_unit)

	unit_game_object_id_8 = unit_game_object_id_8 or NetworkConstants.invalid_game_object_id

	RPC.rpc_status_change_bool(var_170_3, statuses.grabbed_by_chaos_spawn, self.grabbed_by_chaos_spawn, unit_game_object_id, unit_game_object_id_8)

	if not (not self.grabbed_by_chaos_spawn_status and self.grabbed_by_chaos_spawn_status == "grabbed") then
		local var_170_17 = NetworkLookup.grabbed_by_chaos_spawn[self.grabbed_by_chaos_spawn_status]

		RPC.rpc_status_change_int(var_170_3, statuses.grabbed_by_chaos_spawn, var_170_17, unit_game_object_id)
	end

	local unit_game_object_id_9

	if not self.overpowered then
		unit_game_object_id_9 = network:unit_game_object_id(self.overpowered_attacking_unit)

		if not unit_game_object_id_9 then
			-- Nothing
		end
	end

	unit_game_object_id_9 = NetworkConstants.invalid_game_object_id

	do
		local var_170_19
	end

	::label_170_4::

	if not self.overpowered then
		var_170_19 = NetworkLookup.overpowered_templates[self.overpowered_template]

		if not var_170_19 then
			-- Nothing
		end
	end

	var_170_19 = 0

	::label_170_5::

	RPC.rpc_status_change_int_and_unit(var_170_3, statuses.overpowered, var_170_19, unit_game_object_id, unit_game_object_id_9)

	if not self.knocked_down then
		local knocked_down = statuses.knocked_down

		RPC.rpc_status_change_bool(var_170_3, knocked_down, true, unit_game_object_id, 0)
	end

	local unit_game_object_id_10

	if not self.in_vortex then
		unit_game_object_id_10 = network:unit_game_object_id(self.in_vortex_unit)

		if not unit_game_object_id_10 then
			-- Nothing
		end
	end

	unit_game_object_id_10 = NetworkConstants.invalid_game_object_id

	::label_170_6::

	RPC.rpc_status_change_bool(var_170_3, statuses.in_vortex, self.in_vortex, unit_game_object_id, unit_game_object_id_10)
	RPC.rpc_status_change_bool(var_170_3, statuses.crouching, self.crouching, unit_game_object_id, 0)
	RPC.rpc_status_change_bool(var_170_3, statuses.pulled_up, self.pulled_up, unit_game_object_id, 0)
	RPC.rpc_status_change_bool(var_170_3, statuses.ladder_climbing, self.on_ladder, unit_game_object_id, unit_game_object_id_6)
	RPC.rpc_status_change_bool(var_170_3, statuses.ledge_hanging, self.is_ledge_hanging, unit_game_object_id, unit_game_object_id_4)
	RPC.rpc_status_change_bool(var_170_3, statuses.in_end_zone, self.in_end_zone, unit_game_object_id, 0)
end

GenericStatusExtension.set_in_end_zone = function (self, arg_171_1, arg_171_2)
	-- function 171
	if not (not self.is_server and self.in_end_zone == arg_171_1) then
		local go_id = Managers.state.unit_storage:go_id(self.unit)
		local game_object_or_level_id, var_171_2 = Managers.state.network:game_object_or_level_id(arg_171_2)

		game_object_or_level_id = game_object_or_level_id or NetworkConstants.invalid_game_object_id

		Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.in_end_zone, arg_171_1, go_id, game_object_or_level_id)
	end

	self.in_end_zone = arg_171_1

	if not (not self.player.local_player and self._current_end_zone_state == arg_171_1) then
		local flag = true

		if not arg_171_2 then
			flag = not Unit.get_data(arg_171_2, "effects_disabled")
		end

		local set_state = Wwise.set_state
		local str = "inside_waystone"
		local flag_2

		flag_2 = not arg_171_1 and not flag and "true" and "false"

		set_state(str, flag_2)

		self._current_end_zone_state = arg_171_1
	end
end

GenericStatusExtension.set_is_aiming = function (self, arg_172_1)
	-- function 172
	self.is_aiming = arg_172_1
end

GenericStatusExtension.get_is_aiming = function (self)
	-- function 173
	return self.is_aiming
end

GenericStatusExtension.is_in_end_zone = function (self)
	-- function 174
	return self.in_end_zone
end

GenericStatusExtension.is_staggered = function (arg_175_0)
	-- function 175
	return false
end

GenericStatusExtension.breed_action = function (self)
	-- function 176
	return self._current_action
end

GenericStatusExtension.should_climb = function (arg_177_0)
	-- function 177
	return false
end

GenericStatusExtension.get_max_wounds = function (self)
	-- function 178
	local _base_max_wounds = self._base_max_wounds

	return self.buff_extension:apply_buffs_to_value(_base_max_wounds, "extra_wounds")
end

GenericStatusExtension._on_player_joined_party = function (self, arg_179_1, arg_179_2, arg_179_3, arg_179_4, arg_179_5)
	-- function 179
	if not self.is_server then
		return
	end

	if not self:is_invisible() then
		local statuses = NetworkLookup.statuses
		local network = Managers.state.network

		if not network:game() then
			local unit_game_object_id = network:unit_game_object_id(self.unit)
			local var_179_3 = PEER_ID_TO_CHANNEL[arg_179_1]

			if not unit_game_object_id then
				RPC.rpc_status_change_bool(var_179_3, statuses.invisible, true, unit_game_object_id, 0)
			end
		end
	end
end
