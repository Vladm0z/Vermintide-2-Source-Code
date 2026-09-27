-- chunkname: @scripts/unit_extensions/weapons/actions/action_push_stagger.lua

ActionPushStagger = class(ActionPushStagger, ActionBase)

ActionPushStagger.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionPushStagger.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	self._status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	self.owner_unit_first_person = arg_1_6
	self.has_played_rumble_effect = false
	self.hit_units = {}
	self.push_units = {}
	self.waiting_for_callback = false
	self._player_direction = Vector3Box()
end

ActionPushStagger.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ActionPushStagger.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	self.current_action = arg_2_1

	local owner_unit = self.owner_unit
	local extension = ScriptUnit.extension(owner_unit, "buff_system")
	local extension_2 = ScriptUnit.extension(owner_unit, "career_system")
	local _status_extension = self._status_extension

	self.owner_buff_extension = extension
	self.owner_career_extension = extension_2

	local has_melee_boost, var_2_5 = extension_2:has_melee_boost()
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1, arg_2_2)

	self.melee_boost_curve_multiplier = var_2_5
	self.power_level = arg_2_4
	self.has_played_rumble_effect = false

	for k, v in pairs(self.hit_units) do
		self.hit_units[k] = nil
	end

	for k_2, v_2 in pairs(self.push_units) do
		self.push_units[k_2] = nil
	end

	self.bot_player = Managers.player:owner(owner_unit).bot_player

	if not self.bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "light_swing"
		})
	end

	local flag = not arg_2_5 and arg_2_5.action_hand
	local var_2_8

	if not flag then
		var_2_8 = arg_2_1["damage_profile_inner_" .. flag]

		if not var_2_8 then
			-- Nothing
		end
	end

	var_2_8 = arg_2_1.damage_profile_inner
	var_2_8 = var_2_8 or "default"

	::label_2_0::

	self.damage_profile_inner_id = NetworkLookup.damage_profiles[var_2_8]
	self.damage_profile_inner = DamageProfileTemplates[var_2_8]

	local var_2_9

	if not flag then
		var_2_9 = arg_2_1["damage_profile_outer_" .. flag]

		if not var_2_9 then
			-- Nothing
		end
	end

	var_2_9 = arg_2_1.damage_profile_outer
	var_2_9 = var_2_9 or "default"

	::label_2_1::

	self.damage_profile_outer_id = NetworkLookup.damage_profiles[var_2_9]
	self.damage_profile_outer = DamageProfileTemplates[var_2_9]

	self:_handle_fatigue(extension, _status_extension, arg_2_1, true)

	self.block_end_time = arg_2_2 + 0.5

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")
	local extension_3 = ScriptUnit.extension(owner_unit, "first_person_system")

	self:_handle_critical_strike(is_critical_strike, extension, has_extension, extension_3, "on_critical_sweep", "Play_player_combat_crit_swing_2D")

	self._is_critical_strike = is_critical_strike

	if not LEVEL_EDITOR_TEST then
		local go_id = Managers.state.unit_storage:go_id(owner_unit)

		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, true)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, true)
		end
	end

	_status_extension:set_blocking(true)
	extension:trigger_procs("on_push_used")
	Unit.animation_event(self.owner_unit_first_person, "hitreaction_defend_reset")
end

local tbl = {
	has_gotten_callback = false,
	overlap_units = {}
}

local function fn(arg_3_0)
	-- function 3
	tbl.has_gotten_callback = true

	local overlap_units = tbl.overlap_units

	for k, v in pairs(arg_3_0) do
		tbl.num_hits = tbl.num_hits + 1

		if overlap_units[tbl.num_hits] == nil then
			overlap_units[tbl.num_hits] = ActorBox()
		end

		overlap_units[tbl.num_hits]:store(v)
	end
end

ActionPushStagger.client_owner_post_update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local weapon_system = self.weapon_system

	if not (not self.block_end_time and not (arg_4_2 > self.block_end_time)) then
		if not LEVEL_EDITOR_TEST then
			local go_id = Managers.state.unit_storage:go_id(owner_unit)

			if not self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, false)
			end
		end

		local _status_extension = self._status_extension

		_status_extension:set_blocking(false)
		_status_extension:set_has_blocked(false)
	end

	if tbl.has_gotten_callback or not arg_4_4 then
		self.waiting_for_callback = true
		tbl.num_hits = 0

		local get_data = World.get_data(arg_4_3, "physics_world")
		local var_4_6 = POSITION_LOOKUP[owner_unit]
		local apply_buffs_to_value = self.owner_buff_extension:apply_buffs_to_value(2.5, "push_range")
		local max = math.max(current_action.push_radius, apply_buffs_to_value)
		local str = "filter_melee_push"

		PhysicsWorld.overlap(get_data, fn, "shape", "sphere", "position", var_4_6, "size", max, "types", "dynamics", "collision_filter", str)

		local owner_unit_first_person = self.owner_unit_first_person
		local world_rotation = Unit.world_rotation(owner_unit_first_person, 0)
		local normalize = Vector3.normalize(Quaternion.forward(world_rotation))

		self._player_direction:store(normalize)
	elseif not self.waiting_for_callback and not tbl.has_gotten_callback then
		self.waiting_for_callback = false
		tbl.has_gotten_callback = false

		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(owner_unit)
		local overlap_units = tbl.overlap_units
		local hit_units = self.hit_units
		local push_units = self.push_units
		local num_hits = tbl.num_hits
		local flag = false
		local unbox = self._player_direction:unbox()
		local flat = Vector3.flat(unbox)
		local owner_buff_extension = self.owner_buff_extension
		local rad = math.rad
		local var_4_24 = owner_buff_extension
		local apply_buffs_to_value_2 = owner_buff_extension.apply_buffs_to_value
		local push_angle = current_action.push_angle

		push_angle = push_angle or 90

		local var_4_27 = rad(apply_buffs_to_value_2(var_4_24, push_angle, "block_angle") * 0.5)
		local rad_2 = math.rad
		local var_4_29 = owner_buff_extension
		local apply_buffs_to_value_3 = owner_buff_extension.apply_buffs_to_value
		local outer_push_angle = current_action.outer_push_angle

		outer_push_angle = outer_push_angle or 0

		local var_4_32 = rad_2(apply_buffs_to_value_3(var_4_29, outer_push_angle, "block_angle") * 0.5)
		local num = 0

		for i = 1, num_hits do
			repeat
				local unbox_2 = overlap_units[i]:unbox()

				if unbox_2 == nil then
					break
				end

				local unit = Actor.unit(unbox_2)

				if hit_units[unit] ~= nil or not HEALTH_ALIVE[unit] then
					hit_units[unit] = true

					if not DamageUtils.is_enemy(owner_unit, unit) then
						break
					end

					local get_data_2 = Unit.get_data(unit, "breed")

					if not get_data_2 then
						return
					end

					local node = Actor.node(unbox_2)
					local name = get_data_2.hit_zones_lookup[node].name
					local normalize_2 = Vector3.normalize(POSITION_LOOKUP[unit] - POSITION_LOOKUP[owner_unit])
					local flat_2 = Vector3.flat(normalize_2)
					local dot = Vector3.dot(flat_2, flat)
					local acos = math.acos(dot)
					local flag_2 = acos <= var_4_27
					local flag_3 = not (var_4_27 < acos) or acos <= var_4_32

					if not (flag_2 or flag_3) then
						break
					end

					num = num + 1
					push_units[unit] = {
						hit_actor = unbox_2,
						hit_zone_name = name,
						inner_push = flag_2,
						outer_push = flag_3,
						node = node,
						attack_direction = normalize_2,
						target_index = num
					}
				end
			until true
		end

		if num == 0 then
			return
		end

		for k, v in pairs(push_units) do
			repeat
				if not Unit.alive(k) then
					break
				end

				if not (not v.inner_push and v.outer_push) then
					local str_2 = "Play_player_push_ark_success"

					ScriptUnit.extension(owner_unit, "first_person_system"):play_hud_sound_event(str_2, nil, false)
				end

				local unit_game_object_id_2 = network:unit_game_object_id(k)
				local var_4_47 = NetworkLookup.hit_zones[v.hit_zone_name]
				local power_level = self.power_level
				local damage_profile_inner_id

				if not v.inner_push then
					damage_profile_inner_id = self.damage_profile_inner_id

					if not damage_profile_inner_id then
						-- Nothing
					end
				end

				damage_profile_inner_id = self.damage_profile_outer_id

				do
					local damage_profile_inner
				end

				::label_4_0::

				if not v.inner_push then
					damage_profile_inner = self.damage_profile_inner

					if not damage_profile_inner then
						-- Nothing
					end
				end

				damage_profile_inner = self.damage_profile_outer

				::label_4_1::

				local default_target = damage_profile_inner.default_target
				local world_position = Unit.world_position(k, v.node)
				local impact_particle_effect = current_action.impact_particle_effect

				impact_particle_effect = impact_particle_effect or "fx/impact_block_push"

				local var_4_54 = POSITION_LOOKUP[k]

				var_4_54 = var_4_54 or Unit.world_position(k, 0)

				local var_4_55 = POSITION_LOOKUP[owner_unit]

				var_4_55 = var_4_55 or Unit.world_position(owner_unit, 0)

				local normalize_3 = Vector3.normalize(var_4_54 - var_4_55)

				if not impact_particle_effect then
					EffectHelper.player_melee_hit_particles(arg_4_3, impact_particle_effect, world_position, normalize_3, nil, k)
				end

				local stagger_impact_sound_event = current_action.stagger_impact_sound_event

				stagger_impact_sound_event = stagger_impact_sound_event or "blunt_hit"

				if not stagger_impact_sound_event then
					local get_attack_template = DamageUtils.get_attack_template(default_target.attack_template)
					local sound_type

					if not get_attack_template then
						sound_type = get_attack_template.sound_type

						if not sound_type then
							-- Nothing
						end
					end

					sound_type = "stun_heavy"

					::label_4_2::

					local bot_player = self.bot_player

					EffectHelper.play_melee_hit_effects(stagger_impact_sound_event, arg_4_3, world_position, sound_type, bot_player, k)

					local var_4_61 = NetworkLookup.sound_events[stagger_impact_sound_event]
					local var_4_62 = NetworkLookup.melee_impact_sound_types[sound_type]

					world_position = Vector3(math.clamp(world_position.x, -600, 600), math.clamp(world_position.y, -600, 600), math.clamp(world_position.z, -600, 600))

					if not self.is_server then
						network.network_transmit:send_rpc_clients("rpc_play_melee_hit_effects", var_4_61, world_position, var_4_62, unit_game_object_id_2)
					else
						network.network_transmit:send_rpc_server("rpc_play_melee_hit_effects", var_4_61, world_position, var_4_62, unit_game_object_id_2)
					end
				else
					Application.warning("[ActionPushStagger] Missing sound event for push action in unit %q.", self.weapon_unit)
				end

				local attack_is_shield_blocked = AiUtils.attack_is_shield_blocked(k, owner_unit)
				local item_name = self.item_name
				local var_4_65 = NetworkLookup.damage_sources[item_name]
				local _is_critical_strike = self._is_critical_strike
				local target_index = v.target_index

				target_index = target_index or nil

				weapon_system:send_rpc_attack_hit(var_4_65, unit_game_object_id, unit_game_object_id_2, var_4_47, world_position, normalize_3, damage_profile_inner_id, "power_level", power_level, "hit_target_index", target_index, "blocking", attack_is_shield_blocked, "shield_break_procced", false, "boost_curve_multiplier", self.melee_boost_curve_multiplier, "is_critical_strike", _is_critical_strike, "can_damage", false, "can_stagger", true, "total_hits", num)

				if not (not Managers.state.controller_features and not self.owner.local_player and self.has_played_rumble_effect) then
					Managers.state.controller_features:add_effect("rumble", {
						rumble_effect = "push_hit"
					})

					self.has_played_rumble_effect = true
				end

				Managers.state.entity:system("play_go_tutorial_system"):register_push(k)
				owner_buff_extension:trigger_procs("on_push", k, item_name)

				local player = Managers.player
				local owner = player:owner(self.owner_unit)

				if not (LEVEL_EDITOR_TEST or player.is_server) then
					local network_id = owner:network_id()
					local local_player_id = owner:local_player_id()
					local on_push = NetworkLookup.proc_events.on_push

					Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", network_id, local_player_id, on_push)
				end

				flag = true
			until true
		end

		if not (not flag and self.bot_player) then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "hit_character_light"
			})
		end
	end
end

ActionPushStagger.finish = function (self, arg_5_1)
	-- function 5
	local has_extension = ScriptUnit.has_extension(self.owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end

	self.waiting_for_callback = false
	tbl.has_gotten_callback = false

	local ammo_extension = self.ammo_extension
	local current_action = self.current_action
	local owner_unit = self.owner_unit

	if arg_5_1 ~= "new_interupting_action" then
		local reload_when_out_of_ammo_condition_func = current_action.reload_when_out_of_ammo_condition_func
		local flag

		flag = reload_when_out_of_ammo_condition_func or not true or reload_when_out_of_ammo_condition_func(owner_unit, arg_5_1)

		if not ammo_extension and not current_action.reload_when_out_of_ammo and not flag and ammo_extension:ammo_count() ~= 0 or not ammo_extension:can_reload() then
			local flag_2 = true

			ammo_extension:start_reload(flag_2)
		end
	end

	if not LEVEL_EDITOR_TEST then
		local go_id = Managers.state.unit_storage:go_id(owner_unit)

		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, false)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, false)
		end
	end

	local _status_extension = self._status_extension

	_status_extension:set_blocking(false)
	_status_extension:set_has_blocked(false)
end
