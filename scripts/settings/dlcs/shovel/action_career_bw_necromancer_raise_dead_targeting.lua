-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_raise_dead_targeting.lua

local str = "fx/bw_necromancer_ability_indicator"
local num = 15
local num_2 = -12

ActionCareerBWNecromancerRaiseDeadTargeting = class(ActionCareerBWNecromancerRaiseDeadTargeting, ActionBase)

ActionCareerBWNecromancerRaiseDeadTargeting.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerBWNecromancerRaiseDeadTargeting.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._ai_navigation_system = Managers.state.entity:system("ai_navigation_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	self._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self._weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self._world = arg_1_1
	self._owner_unit = arg_1_4
	self._last_valid_spawn_position = Vector3Box()
	self._fp_rotation = QuaternionBox()
	self._decal_diameter_id = World.find_particles_variable(self._world, str, "diameter")
	self._unit_spawner = Managers.state.unit_spawner
	self._buff_unit_params = {
		is_husk = true
	}

	self._nav_callback = function ()
		-- function 2
		local time = Managers.time:time("game")

		self:_update_targeting(time)
	end
end

ActionCareerBWNecromancerRaiseDeadTargeting.client_owner_start_action = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_5 = arg_3_5 or {}

	ActionCareerBWNecromancerRaiseDeadTargeting.super.client_owner_start_action(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	self._weapon_extension:set_mode(true)

	local breed_to_spawn = arg_3_1.breed_to_spawn
	local has_extension = ScriptUnit.has_extension(self._owner_unit, "talent_system")

	if not has_extension and not has_extension:has_talent("sienna_necromancer_6_3_2") then
		breed_to_spawn = arg_3_1.faster_breed_to_spawn
	end

	self._spawn_data = {
		cooldown_leeway = arg_3_1.cooldown_leeway,
		cooldown_per_spawn_percent = arg_3_1.cooldown_per_spawn_percent,
		controlled_unit_template = arg_3_1.controlled_unit_template,
		breed_to_spawn = breed_to_spawn,
		spawns_per_second = arg_3_1.spawns_per_second,
		target_center = Vector3Box()
	}

	local _owner_unit = self._owner_unit

	self._first_person_extension:play_unit_sound_event("Play_career_necro_ability_raise_dead_target", _owner_unit, 0, false)

	self._valid = false
	self._diameter = arg_3_1.radius * 2

	self:_start_targeting()
	self._ai_navigation_system:add_safe_navigation_callback(self._nav_callback)
end

ActionCareerBWNecromancerRaiseDeadTargeting.client_owner_post_update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	self._ai_navigation_system:add_safe_navigation_callback(self._nav_callback)
end

ActionCareerBWNecromancerRaiseDeadTargeting._start_targeting = function (self)
	-- function 5
	local _world = self._world

	self._spawn_decal_id = World.create_particles(_world, str, Vector3(0, 0, -600))

	World.set_particles_variable(_world, self._spawn_decal_id, self._decal_diameter_id, Vector3(self._diameter, self._diameter, 1))

	local var_5_1 = POSITION_LOOKUP[self._owner_unit]

	self._last_valid_spawn_position:store(var_5_1)
end

ActionCareerBWNecromancerRaiseDeadTargeting._update_targeting = function (self, arg_6_1)
	-- function 6
	local _get_projectile_position, var_6_1 = self:_get_projectile_position(num)
	local _world = self._world

	if not _get_projectile_position then
		self._valid = true

		self._spawn_data.target_center:store(var_6_1)
		World.move_particles(_world, self._spawn_decal_id, var_6_1)
	end
end

ActionCareerBWNecromancerRaiseDeadTargeting._get_projectile_position = function (self)
	-- function 7
	local _world = self._world
	local get_data = World.get_data(_world, "physics_world")
	local str = "filter_adept_teleport"
	local _get_first_person_position_direction, var_7_4 = self:_get_first_person_position_direction()
	local num_3 = var_7_4 * num
	local var_7_6 = Vector3(0, 0, num_2)
	local ground_target, var_7_8 = WeaponHelper:ground_target(get_data, self._owner_unit, _get_first_person_position_direction, num_3, var_7_6, str)

	if not ground_target then
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local num_4 = 1
		local num_5 = 1
		local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_7_8, num_4, num_5)

		if not pos_on_mesh then
			local num_6 = 3
			local num_7 = 0.5

			pos_on_mesh = GwNavQueries.inside_position_from_outside_position(nav_world, var_7_8, num_4, num_5, num_6, num_7)
		end

		ground_target = not not pos_on_mesh
		var_7_8 = pos_on_mesh
	end

	return ground_target, var_7_8
end

ActionCareerBWNecromancerRaiseDeadTargeting._get_first_person_position_direction = function (self)
	-- function 8
	local _first_person_extension = self._first_person_extension
	local current_position = _first_person_extension:current_position()
	local current_rotation = _first_person_extension:current_rotation()
	local rad = math.rad(45)
	local rad_2 = math.rad(12.5)
	local yaw = Quaternion.yaw(current_rotation)
	local clamp = math.clamp(Quaternion.pitch(current_rotation), -rad, rad_2)
	local var_8_7 = Quaternion(Vector3.up(), yaw)
	local var_8_8 = Quaternion(Vector3.right(), clamp)
	local multiply = Quaternion.multiply(var_8_7, var_8_8)
	local forward = Quaternion.forward(multiply)

	return current_position, forward
end

ActionCareerBWNecromancerRaiseDeadTargeting.finish = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _world = self._world
	local _spawn_decal_id = self._spawn_decal_id

	World.destroy_particles(_world, _spawn_decal_id)

	if not ((arg_9_1 ~= "new_interupting_action" or not self._valid) and arg_9_2.new_sub_action ~= "spawn_summon_area") then
		local unbox = self._spawn_data.target_center:unbox()
		local create_shared_lifetime_buff_unit = self._buff_extension:create_shared_lifetime_buff_unit(unbox)
		local alloc_table = FrameTable.alloc_table()

		alloc_table.source_attacker_unit = self._owner_unit

		local add_buff_synced = Managers.state.entity:system("buff_system"):add_buff_synced(create_shared_lifetime_buff_unit, "raise_dead_ability", BuffSyncType.All, alloc_table)

		ScriptUnit.extension(create_shared_lifetime_buff_unit, "buff_system"):get_buff_by_id(add_buff_synced).spawn_data = self._spawn_data

		local _owner_unit = self._owner_unit
		local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
		local alloc_table_2 = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table_2)

		local network_transmit = Managers.state.network.network_transmit
		local str = "career_necro_skeleton_spawn"

		Managers.state.entity:system("audio_system"):play_audio_position_event(str, unbox)
		self._first_person_extension:play_unit_sound_event("Play_career_necro_ability_raise_dead_cast", _owner_unit, 0, false)
		self._first_person_extension:play_remote_unit_sound_event("Play_career_necro_ability_raise_dead_cast_husk", _owner_unit, 0)

		local _is_server = self._is_server
		local str_2 = "sienna_necromancer_ability_stagger"
		local has_extension = ScriptUnit.has_extension(self._owner_unit, "talent_system")

		if not has_extension and not has_extension:has_talent("sienna_necromancer_6_2") then
			str_2 = "sienna_necromancer_ability_stagger_improved"
		end

		local _world_2 = self._world
		local get_template = ExplosionUtils.get_template(str_2)
		local num = 1
		local str_3 = "career_ability"
		local flag = false
		local identity = Quaternion.identity()
		local get_career_power_level = self._career_extension:get_career_power_level()

		DamageUtils.create_explosion(_world_2, _owner_unit, unbox, identity, get_template, num, str_3, _is_server, flag, _owner_unit, get_career_power_level, false, _owner_unit)

		local var_9_21 = NetworkLookup.explosion_templates[str_2]
		local var_9_22 = NetworkLookup.damage_sources[str_3]
		local go_id = Managers.state.unit_storage:go_id(_owner_unit)

		if not _is_server then
			network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, unbox, identity, var_9_21, num, var_9_22, get_career_power_level, false, go_id)
		else
			network_transmit:send_rpc_server("rpc_create_explosion", go_id, false, unbox, identity, var_9_21, num, var_9_22, get_career_power_level, false, go_id)
		end

		local str_4 = "fx/necromancer_wave_round"
		local var_9_25 = NetworkLookup.effects[str_4]
		local num_2 = 0
		local flag_2 = false

		network_transmit:send_rpc_server("rpc_play_particle_effect_no_rotation", var_9_25, NetworkConstants.invalid_game_object_id, num_2, unbox, flag_2)
		self._career_extension:start_activated_ability_cooldown()
		self._career_extension:get_passive_ability_by_name("bw_necromancer"):store_buff_unit(create_shared_lifetime_buff_unit)
	end

	return nil
end
