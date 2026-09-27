-- chunkname: @scripts/entity_system/systems/weapon/weapon_system.lua

require("scripts/unit_extensions/weapons/weapon_unit_extension")
require("scripts/unit_extensions/weapons/husk_weapon_unit_extension")
require("scripts/unit_extensions/weapons/ai_weapon_unit_extension")
require("scripts/unit_extensions/weapons/single_weapon_unit_extension")

WeaponSystem = class(WeaponSystem, ExtensionSystemBase)
global_is_inside_inn = false

local tbl = {
	"rpc_attack_hit",
	"rpc_alert_enemy",
	"rpc_ai_weapon_shoot_start",
	"rpc_ai_weapon_shoot",
	"rpc_ai_weapon_shoot_end",
	"rpc_start_beam",
	"rpc_end_beam",
	"rpc_start_flamethrower",
	"rpc_end_flamethrower",
	"rpc_set_stormfiend_beam",
	"rpc_start_geiser",
	"rpc_end_geiser",
	"rpc_weapon_blood",
	"rpc_play_fx",
	"rpc_change_single_weapon_state",
	"rpc_change_synced_weapon_state",
	"rpc_summon_vortex",
	"rpc_start_soul_rip",
	"rpc_stop_soul_rip",
	"rpc_soul_rip_burst"
}
local tbl_2 = {
	"WeaponUnitExtension",
	"HuskWeaponUnitExtension",
	"AiWeaponUnitExtension",
	"SingleWeaponUnitExtension"
}

WeaponSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	WeaponSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	local hub_level = LevelSettings[arg_1_1.startup_data.level_key].hub_level

	hub_level = hub_level or false
	global_is_inside_inn = hub_level
	self._player_damage_forbidden = Managers.state.game_mode:setting("player_damage_forbidden")
	self.game = Managers.state.network:game()
	self.network_manager = Managers.state.network
	self._beam_particle_effects = {}
	self._geiser_particle_effects = {}
	self._flamethrower_particle_effects = {}
	self._soul_rip_spline_ids_lookup = {}
	self._soul_rip_particle_effects = {}
	self._chained_projectiles = {}
end

WeaponSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	arg_2_4.weapon_system = arg_2_0

	local on_add_extension = WeaponSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_4.weapon_system = nil

	return on_add_extension
end

WeaponSystem.rpc_alert_enemy = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local unit = self.unit_storage:unit(arg_3_2)

	if not HEALTH_ALIVE[unit] then
		return
	end

	local unit_2 = self.unit_storage:unit(arg_3_3)

	AiUtils.alert_unit_of_enemy(unit, unit_2)
end

local tbl_3 = {
	{
		default = 0,
		name = "power_level",
		min = MIN_POWER_LEVEL,
		max = MAX_POWER_LEVEL
	},
	{
		default = 0,
		name = "hit_target_index"
	},
	{
		default = 0,
		name = "boost_curve_multiplier"
	},
	{
		default = false,
		name = "is_critical_strike"
	},
	{
		default = true,
		name = "can_damage"
	},
	{
		default = true,
		name = "can_stagger"
	},
	{
		default = 1,
		name = "hit_ragdoll_actor"
	},
	{
		default = false,
		name = "blocking"
	},
	{
		default = false,
		name = "shield_break_procced"
	},
	{
		default = 1,
		name = "backstab_multiplier"
	},
	{
		default = false,
		name = "attacker_is_level_unit"
	},
	{
		default = false,
		name = "first_hit"
	},
	{
		default = 0,
		name = "total_hits"
	}
}

for i = 1, #tbl_3 do
	tbl_3[tbl_3[i].name] = i
end

local tbl_4 = {}

WeaponSystem.send_rpc_attack_hit = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, ...)
	-- function 4
	table.clear(tbl_4)

	local var_4_0 = select("#", ...)

	for i = 1, var_4_0, 2 do
		local var_4_1 = select(i, ...)
		local var_4_2 = select(i + 1, ...)

		tbl_4[tbl_3[var_4_1]] = var_4_2
	end

	for j = 1, #tbl_3 do
		local var_4_3 = tbl_3[j]
		local var_4_4 = tbl_4[j]

		if var_4_4 == nil then
			var_4_4 = var_4_3.default
		end

		if not var_4_3.min and not var_4_3.max then
			var_4_4 = math.clamp(var_4_4, var_4_3.min, var_4_3.max)
		elseif not var_4_3.min then
			var_4_4 = math.max(var_4_4, var_4_3.min)
		elseif not var_4_3.max then
			var_4_4 = math.min(var_4_4, var_4_3.max)
		end

		tbl_4[j] = var_4_4
	end

	if self.is_server or not LEVEL_EDITOR_TEST then
		self:rpc_attack_hit(nil, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, unpack(tbl_4))
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_attack_hit", arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, unpack(tbl_4))
	end

	local unit = self.unit_storage:unit(arg_4_3)
	local unit_2 = self.unit_storage:unit(arg_4_2)

	if not Managers.player:is_player_unit(unit_2) then
		local owner = Managers.player:owner(unit_2)

		if not (not owner.local_player and owner.bot_player) then
			local get_data = Unit.get_data(unit, "breed")
			local get_attributes = Managers.state.entity:system("ai_system"):get_attributes(unit)

			if not get_data and get_data.show_health_bar and not get_attributes.grudge_marked then
				Managers.state.event:trigger("boss_health_bar_register_unit", unit, "damage_done")
			end
		end
	end
end

local BLACKBOARDS = BLACKBOARDS

WeaponSystem.rpc_attack_hit = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17, arg_5_18, arg_5_19, arg_5_20, arg_5_21)
	-- function 5
	local unit = self.unit_storage:unit(arg_5_4)
	local game_object_or_level_unit = self.network_manager:game_object_or_level_unit(arg_5_3, arg_5_19)

	if not (not Unit.alive(unit) and Unit.alive(game_object_or_level_unit)) then
		return
	end

	local var_5_2 = NetworkLookup.damage_sources[arg_5_2]
	local player = Managers.player
	local is_player_unit = player:is_player_unit(game_object_or_level_unit)
	local flag = not player:is_player_unit(unit) and is_player_unit

	if not flag then
		if not self._player_damage_forbidden then
			return
		end

		if var_5_2 ~= "vs_ratling_gunner_gun" or not ScriptUnit.extension(unit, "status_system"):is_grabbed_by_pack_master() then
			ScriptUnit.extension_input(game_object_or_level_unit, "dialogue_system"):trigger_dialogue_event("vs_shooting_hooked_hero")
		end
	end

	local var_5_6 = NetworkLookup.hit_zones[arg_5_5]
	local var_5_7 = BLACKBOARDS[unit]
	local has_extension = ScriptUnit.has_extension(unit, "ai_slot_system")
	local extension

	if not ScriptUnit.has_extension(game_object_or_level_unit, "target_override_system") then
		extension = ScriptUnit.extension(game_object_or_level_unit, "target_override_system")

		if not extension then
			-- Nothing
		end
	end

	extension = nil

	do
		local extension_2
	end

	::label_5_0::

	if not ScriptUnit.has_extension(game_object_or_level_unit, "status_system") then
		extension_2 = ScriptUnit.extension(game_object_or_level_unit, "status_system")

		if not extension_2 then
			-- Nothing
		end
	end

	extension_2 = nil

	::label_5_1::

	local flag_2 = not extension_2 and not not extension_2:is_disabled() or nil
	local is_enemy = DamageUtils.is_enemy(game_object_or_level_unit, unit)
	local var_5_13 = NetworkLookup.hit_ragdoll_actors[arg_5_15]
	local var_5_14 = NetworkLookup.damage_profiles[arg_5_8]
	local var_5_15 = DamageProfileTemplates[var_5_14]

	if var_5_13 == "n/a" then
		var_5_13 = nil
	end

	if arg_5_10 == 0 then
		arg_5_10 = nil
	end

	if not flag and not arg_5_16 then
		local fatigue_type = var_5_15.fatigue_type
		local num = 1
		local flag_3 = true
		local str = "left"
		local network = Managers.state.network

		if not self.is_server then
			local var_5_21 = NetworkLookup.fatigue_types[fatigue_type]

			network.network_transmit:send_rpc_server("rpc_player_blocked_attack", arg_5_4, var_5_21, arg_5_3, num, flag_3, str, arg_5_19)
		end
	end

	local var_5_22
	local flag_4 = false

	if not var_5_7 and not var_5_7.breed and not var_5_7.breed.is_ai then
		if not var_5_7.breed.use_predicted_damage_in_stagger_calculation then
			local var_5_24

			if not var_5_15.targets then
				var_5_24 = var_5_15.targets[arg_5_10]

				if not var_5_24 then
					-- Nothing
				end
			end

			var_5_24 = var_5_15.default_target

			::label_5_2::

			if not var_5_24 then
				local var_5_25 = BoostCurves[var_5_24.boost_curve_type]

				var_5_22 = DamageUtils.calculate_damage(DamageOutput, unit, game_object_or_level_unit, var_5_6, arg_5_9, var_5_25, arg_5_11, arg_5_12, var_5_15, arg_5_10, arg_5_18, var_5_2)
			end
		end

		if not is_enemy and not has_extension and not extension and not flag_2 and not next(var_5_7.override_targets) and not HEALTH_ALIVE[unit] then
			local time = Managers.time:time("game")

			extension:add_to_override_targets(unit, game_object_or_level_unit, var_5_7, time)
		end

		flag_4 = not not var_5_7.breed.unbreakable_shield or var_5_15.shield_break or arg_5_17
	end

	local t = self.t

	DamageUtils.server_apply_hit(t, game_object_or_level_unit, unit, var_5_6 or "full", arg_5_6, arg_5_7, var_5_13, var_5_2, arg_5_9, var_5_15, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_16, flag_4, arg_5_18, arg_5_20, arg_5_21, nil, var_5_22)
end

WeaponSystem.destroy = function (self)
	-- function 6
	local world = self.world

	for k, v in pairs(self._beam_particle_effects) do
		World.destroy_particles(world, v.beam_effect)
		World.destroy_particles(world, v.beam_end_effect)
	end

	self._beam_particle_effects = nil

	self.network_event_delegate:unregister(self)
end

WeaponSystem.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	WeaponSystem.super.update(self, arg_7_1, arg_7_2)

	self.t = arg_7_2

	self:update_synced_beam_particle_effects()
	self:update_synced_geiser_particle_effects(arg_7_1, arg_7_2)
	self:update_synced_flamethrower_particle_effects()
	self:_update_chained_projectiles(arg_7_2)
	self:update_synced_soul_rip_particle_effects()
end

local num = 1
local num_2 = 4

WeaponSystem.update_synced_beam_particle_effects = function (self)
	-- function 8
	local game = self.game
	local network_manager = self.network_manager
	local get_data = World.get_data(self.world, "physics_world")

	for k, v in pairs(self._beam_particle_effects) do
		local unit_game_object_id = network_manager:unit_game_object_id(k)
		local weapon_unit = v.weapon_unit

		if not (not unit_game_object_id and Unit.alive(weapon_unit)) then
			World.destroy_particles(self.world, v.beam_effect)
			World.destroy_particles(self.world, v.beam_end_effect)

			self._beam_particle_effects[k] = nil
		else
			local game_object_field = GameSession.game_object_field(game, unit_game_object_id, "aim_direction")
			local game_object_field_2 = GameSession.game_object_field(game, unit_game_object_id, "aim_position")
			local range = v.range
			local immediate_raycast_actors = PhysicsWorld.immediate_raycast_actors(get_data, game_object_field_2, game_object_field, range, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
			local num_3 = game_object_field_2 + game_object_field * range
			local var_8_10
			local var_8_11

			if not immediate_raycast_actors then
				local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
				local owner = Managers.player:owner(k)
				local flag = not owner and DamageUtils.allow_friendly_fire_ranged(get_difficulty_settings, owner)

				for k_2, v_2 in pairs(immediate_raycast_actors) do
					local var_8_15 = v_2[num]
					local var_8_16 = v_2[num_2]
					local unit = Actor.unit(var_8_16)

					if unit ~= k then
						local get_data_2 = Unit.get_data(unit, "breed")
						local var_8_19

						if not get_data_2 then
							local is_enemy = DamageUtils.is_enemy(k, unit)
							local node = Actor.node(var_8_16)
							local name = get_data_2.hit_zones_lookup[node].name

							var_8_19 = not flag and get_data_2.is_player and not is_enemy and name ~= "afro"
						else
							var_8_19 = true
						end

						if not var_8_19 then
							var_8_10 = var_8_15
							var_8_11 = unit
						end

						break
					end
				end
			end

			if not var_8_11 then
				num_3 = var_8_10
			end

			local world_position = Unit.world_position(weapon_unit, Unit.node(weapon_unit, "fx_muzzle"))
			local distance = Vector3.distance(world_position, num_3)
			local normalize = Vector3.normalize(world_position - num_3)
			local look = Quaternion.look(normalize)
			local world = self.world

			World.move_particles(world, v.beam_end_effect, num_3)
			World.move_particles(world, v.beam_effect, num_3, look)
			World.set_particles_variable(world, v.beam_effect, v.beam_effect_length_id, Vector3(0.3, distance, 0))
		end
	end
end

local function fn(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	-- function 9
	local num = arg_9_2 / arg_9_1

	for i = 1, arg_9_1 do
		local num_2 = arg_9_3 + arg_9_4 * num
		local num_3 = num_2 - arg_9_3
		local normalize = Vector3.normalize(num_3)
		local length = Vector3.length(num_3)
		local immediate_raycast, var_9_6, var_9_7, var_9_8, var_9_9 = PhysicsWorld.immediate_raycast(arg_9_0, arg_9_3, normalize, length, "closest", "collision_filter", arg_9_6)

		if not var_9_6 then
			return immediate_raycast, var_9_6, var_9_7, var_9_8, var_9_9
		end

		arg_9_4 = arg_9_4 + arg_9_5 * num
		arg_9_3 = num_2
	end

	return false, arg_9_3
end

WeaponSystem.update_synced_geiser_particle_effects = function (self, arg_10_1, arg_10_2)
	-- function 10
	local game = self.game
	local network_manager = self.network_manager
	local world = self.world
	local get_data = World.get_data(world, "physics_world")

	for k, v in pairs(self._geiser_particle_effects) do
		repeat
			local game_object_or_level_unit = network_manager:game_object_or_level_unit(k)

			if not ALIVE[game_object_or_level_unit] then
				if not v.geiser_effect then
					World.destroy_particles(world, v.geiser_effect)
				end

				self._geiser_particle_effects[k] = nil

				break
			end

			if not v.geiser_effect then
				break
			end

			local num = (arg_10_2 - v.time_to_shoot) / v.charge_time
			local min = math.min(v.max_radius, v.max_radius * num + v.min_radius)
			local game_object_field = GameSession.game_object_field(game, k, "aim_position")
			local var_10_8 = Vector3(0, 0, 1)
			local look = Quaternion.look(GameSession.game_object_field(game, k, "aim_direction"), var_10_8)
			local num_2 = 10
			local num_3 = 1.5
			local num_4 = 15
			local angle = v.angle
			local num_5 = Quaternion.forward(Quaternion.multiply(look, Quaternion(Vector3.right(), angle))) * num_4
			local var_10_15 = Vector3(0, 0, -9.82)
			local str = "filter_geiser_check"
			local var_10_17, var_10_18, var_10_19, var_10_20 = fn(get_data, num_2, num_3, game_object_field, num_5, var_10_15, str, false)
			local var_10_21 = var_10_18

			World.move_particles(world, v.geiser_effect, var_10_21)
			World.set_particles_variable(world, v.geiser_effect, v.geiser_effect_variable, Vector3(min * 2, min * 2, 1))
		until true
	end
end

WeaponSystem.update_synced_flamethrower_particle_effects = function (self)
	-- function 11
	local network_manager = self.network_manager

	for k, v in pairs(self._flamethrower_particle_effects) do
		local unit_game_object_id = network_manager:unit_game_object_id(k)
		local weapon_unit = v.weapon_unit

		if not (not unit_game_object_id and Unit.alive(weapon_unit)) then
			World.stop_spawning_particles(self.world, v.flamethrower_effect)

			self._flamethrower_particle_effects[k] = nil
		else
			local world = self.world
			local world_position = Unit.world_position(weapon_unit, Unit.node(weapon_unit, "fx_muzzle"))
			local world_rotation = Unit.world_rotation(weapon_unit, Unit.node(weapon_unit, "fx_muzzle"))

			World.move_particles(world, v.flamethrower_effect, world_position, world_rotation)
		end
	end
end

WeaponSystem.rpc_ai_weapon_shoot_start = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local unit = Managers.state.unit_storage:unit(arg_12_2)

	if not unit then
		return
	end

	local get_data = Unit.get_data(unit, "breed")
	local extension = ScriptUnit.extension(unit, "ai_inventory_system")
	local default_inventory_template = get_data.default_inventory_template
	local get_unit = extension:get_unit(default_inventory_template)

	ScriptUnit.extension(get_unit, "weapon_system"):shoot_start(unit, arg_12_3 / 100)
end

WeaponSystem.rpc_ai_weapon_shoot = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local unit = Managers.state.unit_storage:unit(arg_13_2)

	if not unit then
		return
	end

	local get_data = Unit.get_data(unit, "breed")
	local extension = ScriptUnit.extension(unit, "ai_inventory_system")
	local default_inventory_template = get_data.default_inventory_template
	local get_unit = extension:get_unit(default_inventory_template)

	ScriptUnit.extension(get_unit, "weapon_system"):shoot(unit)
end

WeaponSystem.rpc_ai_weapon_shoot_end = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local unit = Managers.state.unit_storage:unit(arg_14_2)

	if not unit then
		return
	end

	local get_data = Unit.get_data(unit, "breed")
	local extension = ScriptUnit.extension(unit, "ai_inventory_system")
	local default_inventory_template = get_data.default_inventory_template
	local get_unit = extension:get_unit(default_inventory_template)

	ScriptUnit.extension(get_unit, "weapon_system"):shoot_end(unit)
end

WeaponSystem.rpc_change_single_weapon_state = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local unit = Managers.state.unit_storage:unit(arg_15_2)

	if not unit then
		return
	end

	local var_15_1 = NetworkLookup.single_weapon_states[arg_15_3]
	local flag = true
	local var_15_3 = CHANNEL_TO_PEER_ID[arg_15_1]

	self:change_single_weapon_state(unit, var_15_1, var_15_3, flag)
end

WeaponSystem.change_single_weapon_state = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local var_16_0 = BLACKBOARDS[arg_16_1]

	if not var_16_0 then
		local weapon_unit = var_16_0.weapon_unit

		if not weapon_unit then
			ScriptUnit.extension(weapon_unit, "weapon_system"):change_state(arg_16_2)
		end
	end

	local go_id = Managers.state.unit_storage:go_id(arg_16_1)
	local var_16_3 = NetworkLookup.single_weapon_states[arg_16_2]

	if not self.is_server then
		self.network_transmit:send_rpc_clients_except("rpc_change_single_weapon_state", arg_16_3, go_id, var_16_3)
	elseif not arg_16_4 then
		self.network_transmit:send_rpc_server("rpc_change_single_weapon_state", go_id, var_16_3)
	end
end

WeaponSystem.rpc_change_synced_weapon_state = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local unit = Managers.state.unit_storage:unit(arg_17_2)

	if not unit then
		return
	end

	local flag = true
	local var_17_2 = NetworkLookup.weapon_synced_states[arg_17_3]

	if var_17_2 == "n/a" then
		var_17_2 = nil
	end

	local _first_wielded_weapon_unit = self:_first_wielded_weapon_unit(unit)
	local has_extension = ScriptUnit.has_extension(_first_wielded_weapon_unit, "weapon_system")

	if not has_extension then
		return
	end

	has_extension:change_synced_state(var_17_2, flag)

	if not self.is_server then
		local var_17_5 = CHANNEL_TO_PEER_ID[arg_17_1]

		self.network_transmit:send_rpc_clients_except("rpc_change_synced_weapon_state", var_17_5, arg_17_2, arg_17_3)
	end
end

WeaponSystem.get_synced_weapon_state = function (self, arg_18_1)
	-- function 18
	local _first_wielded_weapon_unit = self:_first_wielded_weapon_unit(arg_18_1)

	if not _first_wielded_weapon_unit then
		return nil
	end

	local extension = ScriptUnit.extension(_first_wielded_weapon_unit, "weapon_system")

	if not extension.current_synced_state then
		return nil
	end

	return extension:current_synced_state()
end

WeaponSystem._first_wielded_weapon_unit = function (arg_19_0, arg_19_1)
	-- function 19
	local equipment = ScriptUnit.extension(arg_19_1, "inventory_system"):equipment()
	local left_hand_wielded_unit = equipment.left_hand_wielded_unit

	if not left_hand_wielded_unit then
		left_hand_wielded_unit = equipment.right_hand_wielded_unit

		if not left_hand_wielded_unit then
			left_hand_wielded_unit = equipment.left_hand_wielded_unit_3p
			left_hand_wielded_unit = left_hand_wielded_unit or equipment.right_hand_wielded_unit_3p
		end
	end

	return left_hand_wielded_unit
end

WeaponSystem.rpc_start_beam = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	if not LEVEL_EDITOR_TEST then
		local unit = self.unit_storage:unit(arg_20_2)
		local var_20_1 = NetworkLookup.effects[arg_20_3]
		local var_20_2 = NetworkLookup.effects[arg_20_4]
		local equipment = ScriptUnit.extension(unit, "inventory_system"):equipment()
		local right_hand_wielded_unit_3p = equipment.right_hand_wielded_unit_3p

		right_hand_wielded_unit_3p = right_hand_wielded_unit_3p or equipment.left_hand_wielded_unit_3p

		local world = self.world

		self._beam_particle_effects[unit] = {
			beam_effect = World.create_particles(world, var_20_1, Vector3.zero()),
			beam_end_effect = World.create_particles(world, var_20_2, Vector3.zero()),
			beam_effect_length_id = World.find_particles_variable(world, var_20_1, "trail_length"),
			beam_effect_name = var_20_1,
			beam_end_effect_name = var_20_2,
			range = arg_20_5,
			weapon_unit = right_hand_wielded_unit_3p
		}

		if not self.is_server then
			local var_20_6 = CHANNEL_TO_PEER_ID[arg_20_1]

			self.network_transmit:send_rpc_clients_except("rpc_start_beam", var_20_6, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
		end
	end
end

WeaponSystem.rpc_end_beam = function (self, arg_21_1, arg_21_2)
	-- function 21
	if not LEVEL_EDITOR_TEST then
		local world = self.world
		local unit = self.unit_storage:unit(arg_21_2)
		local var_21_2 = self._beam_particle_effects[unit]

		if not var_21_2 then
			World.destroy_particles(world, var_21_2.beam_effect)
			World.destroy_particles(world, var_21_2.beam_end_effect)

			self._beam_particle_effects[unit] = nil

			if not self.is_server then
				local var_21_3 = CHANNEL_TO_PEER_ID[arg_21_1]

				self.network_transmit:send_rpc_clients_except("rpc_end_beam", var_21_3, arg_21_2)
			end
		end
	end
end

WeaponSystem.rpc_start_geiser = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)
	-- function 22
	if not LEVEL_EDITOR_TEST then
		local var_22_0 = CHANNEL_TO_PEER_ID[arg_22_1]

		if not var_22_0 then
			return
		end

		local side = Managers.state.side
		local get_side_from_player_unique_id = side:get_side_from_player_unique_id(var_22_0 .. ":1")
		local var_22_3 = NetworkLookup.effects[arg_22_3]
		local tbl = {
			side = get_side_from_player_unique_id,
			min_radius = arg_22_4,
			max_radius = arg_22_5,
			charge_time = arg_22_6,
			angle = arg_22_7,
			time_to_shoot = Managers.time:time("game"),
			start_time = Managers.time:time("game"),
			geiser_effect_name = var_22_3
		}

		self._geiser_particle_effects[arg_22_2] = tbl

		if not self.is_server then
			self.network_transmit:send_rpc_side_clients_except("rpc_start_geiser", get_side_from_player_unique_id, true, true, var_22_0, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)

			if not DEDICATED_SERVER then
				return
			end

			local local_player = Managers.player:local_player()
			local get_side_from_player_unique_id_2 = side:get_side_from_player_unique_id(local_player:unique_id())

			if not side:is_enemy_by_side(get_side_from_player_unique_id, get_side_from_player_unique_id_2) then
				return
			end
		end

		local world = self.world

		tbl.geiser_effect = World.create_particles(world, var_22_3, Vector3.zero())
		tbl.geiser_effect_variable = World.find_particles_variable(world, var_22_3, "charge_radius")
	end
end

WeaponSystem.rpc_end_geiser = function (self, arg_23_1, arg_23_2)
	-- function 23
	if not LEVEL_EDITOR_TEST then
		local world = self.world
		local var_23_1 = self._geiser_particle_effects[arg_23_2]

		if not var_23_1 and not var_23_1.geiser_effect then
			World.destroy_particles(world, var_23_1.geiser_effect)
		end

		self._geiser_particle_effects[arg_23_2] = nil

		if not self.is_server then
			local var_23_2 = CHANNEL_TO_PEER_ID[arg_23_1]

			self.network_transmit:send_rpc_clients_except("rpc_end_geiser", var_23_2, arg_23_2)
		end
	end
end

WeaponSystem.rpc_start_flamethrower = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	if not LEVEL_EDITOR_TEST then
		local unit = self.unit_storage:unit(arg_24_2)
		local var_24_1 = NetworkLookup.effects[arg_24_3]
		local equipment = ScriptUnit.extension(unit, "inventory_system"):equipment()
		local right_hand_wielded_unit_3p = equipment.right_hand_wielded_unit_3p

		right_hand_wielded_unit_3p = right_hand_wielded_unit_3p or equipment.left_hand_wielded_unit_3p

		local world_position = Unit.world_position(right_hand_wielded_unit_3p, Unit.node(right_hand_wielded_unit_3p, "fx_muzzle"))
		local world_rotation = Unit.world_rotation(right_hand_wielded_unit_3p, Unit.node(right_hand_wielded_unit_3p, "fx_muzzle"))
		local world = self.world
		local var_24_7 = self._flamethrower_particle_effects[unit]

		if not var_24_7 then
			World.stop_spawning_particles(world, var_24_7.flamethrower_effect)

			var_24_7.flamethrower_effect = World.create_particles(world, var_24_1, world_position, world_rotation)
			var_24_7.flamethrower_effect_name = var_24_1
			var_24_7.weapon_unit = right_hand_wielded_unit_3p
		else
			self._flamethrower_particle_effects[unit] = {
				flamethrower_effect = World.create_particles(world, var_24_1, world_position, world_rotation),
				flamethrower_effect_name = var_24_1,
				weapon_unit = right_hand_wielded_unit_3p
			}
		end

		if not self.is_server then
			local var_24_8 = CHANNEL_TO_PEER_ID[arg_24_1]

			self.network_transmit:send_rpc_clients_except("rpc_start_flamethrower", var_24_8, arg_24_2, arg_24_3)
		end
	end
end

WeaponSystem.rpc_end_flamethrower = function (self, arg_25_1, arg_25_2)
	-- function 25
	if not LEVEL_EDITOR_TEST then
		local world = self.world
		local unit = self.unit_storage:unit(arg_25_2)
		local var_25_2 = self._flamethrower_particle_effects[unit]

		if not var_25_2 then
			World.stop_spawning_particles(world, var_25_2.flamethrower_effect)

			self._flamethrower_particle_effects[unit] = nil

			if not self.is_server then
				local var_25_3 = CHANNEL_TO_PEER_ID[arg_25_1]

				self.network_transmit:send_rpc_clients_except("rpc_end_flamethrower", var_25_3, arg_25_2)
			end
		end
	end
end

WeaponSystem.rpc_summon_vortex = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	if not LEVEL_EDITOR_TEST then
		local unit = self.unit_storage:unit(arg_26_2)
		local unit_2 = self.unit_storage:unit(arg_26_3)
		local var_26_2 = BLACKBOARDS[unit_2]

		if not var_26_2 then
			local thornsister_vortex_ext = var_26_2.thornsister_vortex_ext

			if not thornsister_vortex_ext then
				thornsister_vortex_ext:refresh_duration()
			else
				local var_26_4 = POSITION_LOOKUP[unit_2]

				if not var_26_4 then
					self:_summon_vortex(var_26_4, unit_2, unit)
				end
			end
		end
	end
end

WeaponSystem._summon_vortex = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local str = "units/weapons/enemy/wpn_chaos_plague_vortex/wpn_chaos_plague_vortex"
	local str_2 = "spirit_storm"
	local side_id = Managers.state.side.side_by_unit[arg_27_3].side_id
	local str_3 = "vortex_unit"
	local tbl = {
		area_damage_system = {
			vortex_template_name = str_2,
			owner_unit = arg_27_3,
			side_id = side_id,
			target_unit = arg_27_2
		}
	}

	Managers.state.unit_spawner:spawn_network_unit(str, str_3, tbl, arg_27_1, Quaternion.identity())
end

WeaponSystem.rpc_set_stormfiend_beam = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local unit = self.unit_storage:unit(arg_28_2)

	if not ALIVE[unit] then
		local extension = ScriptUnit.extension(unit, "ai_beam_effect_system")

		if not extension then
			local var_28_2 = NetworkLookup.attack_arm[arg_28_3]

			extension:set_beam(var_28_2, arg_28_4)
		end
	end
end

WeaponSystem.rpc_weapon_blood = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local unit = self.unit_storage:unit(arg_29_2)

	if not Unit.alive(unit) then
		return
	end

	Managers.state.blood:add_weapon_blood(unit, NetworkLookup.attack_templates[arg_29_3])

	if not self.is_server then
		local var_29_1 = CHANNEL_TO_PEER_ID[arg_29_1]

		self.network_transmit:send_rpc_clients_except("rpc_weapon_blood", var_29_1, arg_29_2, arg_29_3)
	end
end

WeaponSystem.rpc_play_fx = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	-- function 30
	local world = self.world
	local create_particles = World.create_particles
	local effects = NetworkLookup.effects
	local sound_events = NetworkLookup.sound_events

	if #arg_30_3 > 0 then
		local wwise_world = Managers.world:wwise_world(world)
		local trigger_event = WwiseWorld.trigger_event
		local make_auto_source = WwiseWorld.make_auto_source
		local system = Managers.state.entity:system("sound_environment_system")
		local set_source_environment = system.set_source_environment

		for i = 1, #arg_30_2 do
			local var_30_9 = effects[arg_30_2[i]]
			local var_30_10 = sound_events[arg_30_3[i]]
			local var_30_11 = arg_30_4[i]

			create_particles(world, var_30_9, var_30_11)

			local var_30_12 = make_auto_source(wwise_world, var_30_11)

			trigger_event(wwise_world, var_30_10, var_30_12)
			set_source_environment(system, var_30_12, var_30_11)
		end
	else
		for j = 1, #arg_30_2 do
			local var_30_13 = effects[arg_30_2[j]]

			create_particles(world, var_30_13, arg_30_4[j])
		end
	end
end

WeaponSystem.hot_join_sync = function (self, arg_31_1)
	-- function 31
	local var_31_0 = PEER_ID_TO_CHANNEL[arg_31_1]

	for k, v in pairs(self._beam_particle_effects) do
		local unit_game_object_id = Managers.state.network:unit_game_object_id(k)
		local var_31_2 = NetworkLookup.effects[v.beam_effect_name]
		local var_31_3 = NetworkLookup.effects[v.beam_end_effect_name]

		RPC.rpc_start_beam(var_31_0, unit_game_object_id, var_31_2, var_31_3, v.range)
	end

	for k_2, v_2 in pairs(self._geiser_particle_effects) do
		local var_31_4 = NetworkLookup.effects[v_2.geiser_effect_name]
		local min_radius = v_2.min_radius
		local max_radius = v_2.max_radius
		local charge_time = v_2.charge_time
		local angle = v_2.angle
		local num = v_2.time_to_shoot - v_2.start_time

		RPC.rpc_start_geiser(var_31_0, k_2, var_31_4, min_radius, max_radius, charge_time, angle, num)
	end
end

WeaponSystem.start_soul_rip = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	-- function 32
	local world = self.world

	if not self._soul_rip_particle_effects[arg_32_1] then
		self:cleanup_soul_rip(arg_32_1)
	end

	local new_map = Script.new_map(7)

	self._soul_rip_particle_effects[arg_32_1] = new_map

	local go_id = self.unit_storage:go_id(arg_32_1)

	new_map.owner_unit_id = go_id
	new_map.target_unit = arg_32_2
	new_map.target_node_id = arg_32_3
	new_map.seed = arg_32_4

	local var_32_3 = arg_32_1
	local flag = false
	local has_extension = ScriptUnit.has_extension(arg_32_1, "first_person_system")

	if not has_extension then
		var_32_3 = has_extension:get_first_person_unit()

		local str = "fx/wpnfx_necromancer_skullstaff_anticipation"
		local node

		if not Unit.has_node(var_32_3, "j_leftweaponattach") then
			node = Unit.node(var_32_3, "j_leftweaponattach")

			if not node then
				-- Nothing
			end
		end

		node = 0

		::label_32_0::

		new_map.anticipation_fx = ScriptWorld.create_particles_linked(world, str, var_32_3, node, "destroy")
		flag = has_extension:first_person_mode_active()
	end

	local flag_2

	flag_2 = not flag and "units/test_unit/cup_test" and "units/test_unit/cup_test_3p"
	new_map.weapon_unit = var_32_3

	local node_2

	if not Unit.has_node(var_32_3, "j_leftweaponattach") then
		node_2 = Unit.node(var_32_3, "j_leftweaponattach")

		if not node_2 then
			-- Nothing
		end
	end

	node_2 = 0

	::label_32_1::

	new_map.weapon_node_id = node_2
	new_map.weapon_fx_unit = World.spawn_unit(world, flag_2)

	local node_3

	if not Unit.has_node(arg_32_2, "j_spine") then
		node_3 = Unit.node(arg_32_2, "j_spine")

		if not node_3 then
			-- Nothing
		end
	end

	node_3 = 0

	::label_32_2::

	new_map.target_node_id = node_3
	new_map.target_fx_unit = World.spawn_unit(world, "units/test_unit/cup_test_3p")

	local var_32_11 = Vector3(2, 2, 2)

	Unit.set_local_scale(new_map.weapon_fx_unit, 0, var_32_11)

	local var_32_12 = Vector3(5, 5, 5)

	Unit.set_local_scale(new_map.target_fx_unit, 0, var_32_12)

	if not arg_32_5 then
		local go_id_2 = self.unit_storage:go_id(arg_32_2)

		if not self.is_server then
			self.network_transmit:send_rpc_clients("rpc_start_soul_rip", go_id, go_id_2, arg_32_3, arg_32_4)
		else
			self.network_transmit:send_rpc_server("rpc_start_soul_rip", go_id, go_id_2, arg_32_3, arg_32_4)
		end
	end
end

WeaponSystem.update_synced_soul_rip_particle_effects = function (self)
	-- function 33
	for k, v in pairs(self._soul_rip_particle_effects) do
		if not (not ALIVE[k] and ALIVE[v.target_unit]) then
			self:cleanup_soul_rip(k)
		else
			local world_position, world_position_2 = Unit.world_position(v.target_unit, v.target_node_id), Unit.world_position(v.weapon_unit, v.weapon_node_id)
			local normalize = Vector3.normalize(world_position - world_position_2)
			local weapon_fx_unit = v.weapon_fx_unit
			local world_position_3 = Unit.world_position(v.weapon_unit, v.weapon_node_id)

			Unit.set_local_position(weapon_fx_unit, 0, world_position_3)

			local look = Quaternion.look(normalize)

			Unit.set_local_rotation(weapon_fx_unit, 0, look)

			local target_fx_unit = v.target_fx_unit
			local world_position_4 = Unit.world_position(v.target_unit, v.target_node_id)

			Unit.set_local_position(target_fx_unit, 0, world_position_4)

			local look_2 = Quaternion.look(-normalize)

			Unit.set_local_rotation(target_fx_unit, 0, look_2)
		end
	end
end

WeaponSystem.stop_soul_rip = function (self, arg_34_1, arg_34_2)
	-- function 34
	local var_34_0 = self._soul_rip_particle_effects[arg_34_1]

	if not var_34_0 then
		self:cleanup_soul_rip(arg_34_1)

		if not arg_34_2 then
			if not self.is_server then
				self.network_transmit:send_rpc_clients("rpc_stop_soul_rip", var_34_0.owner_unit_id)
			else
				self.network_transmit:send_rpc_server("rpc_stop_soul_rip", var_34_0.owner_unit_id)
			end
		end
	end
end

WeaponSystem.cleanup_soul_rip = function (self, arg_35_1)
	-- function 35
	local var_35_0 = self._soul_rip_particle_effects[arg_35_1]

	if not var_35_0 then
		local world = self.world

		if not var_35_0.anticipation_fx then
			World.destroy_particles(world, var_35_0.anticipation_fx)
		end

		World.destroy_unit(world, var_35_0.weapon_fx_unit)
		World.destroy_unit(world, var_35_0.target_fx_unit)

		self._soul_rip_particle_effects[arg_35_1] = nil
	end
end

WeaponSystem.soul_rip_burst = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6)
	-- function 36
	local world = self.world
	local go_id = self.unit_storage:go_id(arg_36_1)
	local world_position = Unit.world_position(arg_36_2, arg_36_3)
	local game_object_field = GameSession.game_object_field(self.game, go_id, "aim_position")
	local normalize = Vector3.normalize(game_object_field - world_position)
	local look = Quaternion.look(normalize)
	local right = Quaternion.right(look)
	local forward = Quaternion.forward(look)
	local up = Vector3.up()
	local create_particles = World.create_particles(world, arg_36_4, world_position, Quaternion.look(up * 0.5 + right * 0.5))
	local _soul_rip_spline_ids_lookup = self._soul_rip_spline_ids_lookup

	if not _soul_rip_spline_ids_lookup[arg_36_4] then
		_soul_rip_spline_ids_lookup[arg_36_4] = {
			World.find_particles_variable(world, arg_36_4, "spline_1"),
			World.find_particles_variable(world, arg_36_4, "spline_2"),
			World.find_particles_variable(world, arg_36_4, "spline_3"),
			World.find_particles_variable(world, arg_36_4, "spline_4")
		}
	end

	local var_36_11 = world_position
	local num = var_36_11 + up + right * 2
	local var_36_13
	local var_36_14
	local var_36_15
	local next_random, var_36_17 = Math.next_random(arg_36_5)
	local next_random_2, var_36_19 = Math.next_random(next_random)
	local num_2 = var_36_11 + forward + Vector3(var_36_17 * 2 - 1, var_36_19 * 2 - 1, 2) + right * 0.5
	local next_random_3, var_36_22 = Math.next_random(next_random_2)
	local next_random_4, var_36_24 = Math.next_random(next_random_3)
	local num_3 = var_36_11 + Vector3(var_36_22 * 2 - 1, var_36_24 * 2 - 1, 5) + right * 0.5
	local var_36_26 = _soul_rip_spline_ids_lookup[arg_36_4]

	World.set_particles_variable(world, create_particles, var_36_26[1], var_36_11)
	World.set_particles_variable(world, create_particles, var_36_26[2], num)
	World.set_particles_variable(world, create_particles, var_36_26[3], num_2)
	World.set_particles_variable(world, create_particles, var_36_26[4], num_3)

	if not script_data.debug_soulrip then
		QuickDrawerStay:line(var_36_11, num, Color(255, 0, 0))
		QuickDrawerStay:line(num, num_2, Color(255, 0, 0))
		QuickDrawerStay:line(num_2, num_3, Color(255, 0, 0))
	end

	if not arg_36_6 then
		local go_id_2 = self.unit_storage:go_id(arg_36_2)
		local var_36_28 = NetworkLookup.effects[arg_36_4]

		if not self.is_server then
			self.network_transmit:send_rpc_clients("rpc_soul_rip_burst", go_id, go_id_2, arg_36_3, var_36_28, arg_36_5)
		else
			self.network_transmit:send_rpc_server("rpc_soul_rip_burst", go_id, go_id_2, arg_36_3, var_36_28, arg_36_5)
		end
	end
end

WeaponSystem.rpc_start_soul_rip = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	-- function 37
	local unit = self.unit_storage:unit(arg_37_2)
	local unit_2 = self.unit_storage:unit(arg_37_3)

	if not unit_2 then
		return
	end

	self:start_soul_rip(unit, unit_2, arg_37_4, arg_37_5, false)

	if not self.is_server then
		local var_37_2 = CHANNEL_TO_PEER_ID[arg_37_1]

		self.network_transmit:send_rpc_clients_except("rpc_start_soul_rip", var_37_2, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	end
end

WeaponSystem.rpc_stop_soul_rip = function (self, arg_38_1, arg_38_2)
	-- function 38
	local unit = self.unit_storage:unit(arg_38_2)

	self:stop_soul_rip(unit, false)

	if not self.is_server then
		local var_38_1 = CHANNEL_TO_PEER_ID[arg_38_1]

		self.network_transmit:send_rpc_clients_except("rpc_stop_soul_rip", var_38_1, arg_38_2)
	end
end

WeaponSystem.rpc_soul_rip_burst = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
	-- function 39
	local unit = self.unit_storage:unit(arg_39_3)
	local unit_2 = self.unit_storage:unit(arg_39_2)

	if not (not ALIVE[unit] and ALIVE[unit_2]) then
		return
	end

	local var_39_2 = NetworkLookup.effects[arg_39_5]

	self:soul_rip_burst(unit_2, unit, arg_39_4, var_39_2, arg_39_6, false)

	if not self.is_server then
		local var_39_3 = CHANNEL_TO_PEER_ID[arg_39_1]

		self.network_transmit:send_rpc_clients_except("rpc_soul_rip_burst", var_39_3, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
	end
end

WeaponSystem._update_chained_projectiles = function (self, arg_40_1)
	-- function 40
	local _chained_projectiles = self._chained_projectiles
	local broadphase = Managers.state.entity:system("ai_system").broadphase

	for k in pairs(_chained_projectiles) do
		if not (k.next_target_unit or not (arg_40_1 >= k.target_selection_t)) then
			if not self:_select_next_chained_projectile_target(k, broadphase) then
				self._chained_projectiles[k] = nil
			end
		elseif arg_40_1 >= k.next_chain_t then
			if not self:_apply_chained_projectile_damage(k) then
				k.next_target_unit = nil
				k.next_chain_t = arg_40_1 + k.settings.chain_delay
				k.target_selection_t = arg_40_1 + k.settings.target_selection_delay
			else
				self._chained_projectiles[k] = nil
			end
		end
	end
end

WeaponSystem.is_chained_projectile_active = function (self, arg_41_1)
	-- function 41
	return not not self._chained_projectiles[arg_41_1]
end

local tbl_5 = {}

WeaponSystem._select_next_chained_projectile_target = function (self, arg_42_1, arg_42_2)
	-- function 42
	local settings = arg_42_1.settings
	local hit_units = arg_42_1.hit_units
	local unbox = arg_42_1.last_chain_pos:unbox()
	local var_42_3 = tbl_5
	local world = self.world
	local tbl = {
		World.find_particles_variable(world, "fx/wpnfx_staff_death/curse_spirit", "spline_1"),
		World.find_particles_variable(world, "fx/wpnfx_staff_death/curse_spirit", "spline_2"),
		World.find_particles_variable(world, "fx/wpnfx_staff_death/curse_spirit", "spline_3")
	}
	local var_42_6 = Managers.state.side.side_by_unit[arg_42_1.owner_unit]
	local flag = not var_42_6 and var_42_6.enemy_broadphase_categories
	local query = Broadphase.query(arg_42_2, unbox, settings.chain_distance, var_42_3, flag)

	for i = 1, query do
		local var_42_9 = var_42_3[i]

		if hit_units[var_42_9] or not HEALTH_ALIVE[var_42_9] then
			hit_units[var_42_9] = true

			local node

			if not Unit.has_node(var_42_9, "j_spine") then
				node = Unit.node(var_42_9, "j_spine")

				if not node then
					-- Nothing
				end
			end

			node = 0

			::label_42_0::

			local world_position = Unit.world_position(var_42_9, node)
			local var_42_12 = Vector3(math.lerp(-0.5, 0.5, math.random()), math.lerp(-0.5, 0.5, math.random()), math.lerp(-0.5, 0.5, math.random()))
			local num = unbox + (world_position - unbox) / 2 + var_42_12

			self:_play_chained_projectile_fx("fx/wpnfx_staff_death/curse_spirit", tbl, unbox, num, world_position, true)

			arg_42_1.next_target_unit = var_42_9

			return true
		end
	end

	return false
end

WeaponSystem._play_chained_projectile_fx = function (self, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	-- function 43
	local var_43_0 = NetworkLookup.effects[arg_43_1]
	local tbl = {
		arg_43_3,
		arg_43_4,
		arg_43_5
	}

	if not self._fire_sound_event and not self.first_person_extension then
		self.first_person_extension:play_hud_sound_event(self._fire_sound_event)
	end

	if not self.is_server then
		Managers.state.network:rpc_play_particle_effect_spline(nil, var_43_0, arg_43_2, tbl)
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect_spline", var_43_0, arg_43_2, tbl)
	end
end

WeaponSystem.try_fire_chained_projectile = function (self, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5, arg_44_6, arg_44_7, arg_44_8, arg_44_9, arg_44_10, arg_44_11)
	-- function 44
	local tbl = {
		chain_count = 0,
		settings = arg_44_1,
		is_critical_strike = arg_44_3,
		power_level = arg_44_4,
		boost_curve_multiplier = arg_44_5,
		damage_source = arg_44_2,
		next_chain_t = arg_44_6 + (arg_44_1.chain_delay - arg_44_1.target_selection_delay),
		target_selection_t = math.huge,
		owner_unit = arg_44_7,
		hit_units = {},
		last_chain_pos = Vector3Box(arg_44_8),
		base_target_index = arg_44_11
	}

	if not arg_44_10 then
		tbl.hit_units[arg_44_10] = true
	end

	if not arg_44_9 then
		local broadphase = Managers.state.entity:system("ai_system").broadphase

		arg_44_9 = self:_select_next_chained_projectile_target(tbl, broadphase)

		if not arg_44_9 then
			return
		end
	end

	tbl.hit_units[arg_44_9] = true
	self._chained_projectiles[tbl] = true

	Managers.state.achievement:trigger_event("chained_projectile_fired", tbl, arg_44_7)
end

WeaponSystem._apply_chained_projectile_damage = function (self, arg_45_1)
	-- function 45
	local settings = arg_45_1.settings
	local num = arg_45_1.chain_count + 1
	local next_target_unit = arg_45_1.next_target_unit
	local num_2 = arg_45_1.base_target_index + num

	if not HEALTH_ALIVE[next_target_unit] then
		local unbox = arg_45_1.last_chain_pos:unbox()
		local is_critical_strike = arg_45_1.is_critical_strike
		local power_level = arg_45_1.power_level
		local boost_curve_multiplier = arg_45_1.boost_curve_multiplier
		local damage_profile = settings.damage_profile
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_45_1.owner_unit)

		if not unit_game_object_id then
			return
		end

		local var_45_11 = NetworkLookup.damage_profiles[damage_profile]
		local game_object_or_level_id, var_45_13 = network:game_object_or_level_id(next_target_unit)
		local var_45_14 = NetworkLookup.damage_sources[arg_45_1.damage_source]
		local torso = NetworkLookup.hit_zones.torso
		local num_3 = Unit.world_position(next_target_unit, 0) + Vector3.up()
		local direction_length, var_45_18 = Vector3.direction_length(num_3 - unbox)

		if not var_45_13 then
			local str = "full"
			local num_4 = 1
			local item_name = self.item_name
			local var_45_22 = DamageProfileTemplates[damage_profile]

			DamageUtils.damage_level_unit(next_target_unit, arg_45_1.owner_unit, str, power_level, self.melee_boost_curve_multiplier, is_critical_strike, var_45_22, num_4, direction_length, item_name)
		else
			self:send_rpc_attack_hit(var_45_14, unit_game_object_id, game_object_or_level_id, torso, num_3, direction_length, var_45_11, "power_level", power_level, "hit_target_index", num_2, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", boost_curve_multiplier, "is_critical_strike", is_critical_strike, "can_damage", true, "can_stagger", true, "first_hit", num_2 == 1)
		end

		local var_45_23 = NetworkLookup.effects["fx/wpnfx_staff_death/curse_spirit_impact"]
		local look = Quaternion.look(direction_length)

		if not self.is_server then
			Managers.state.network:rpc_play_particle_effect(nil, var_45_23, NetworkConstants.invalid_game_object_id, 0, num_3, look, false)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect", var_45_23, NetworkConstants.invalid_game_object_id, 0, num_3, look, false)
		end

		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_career_necro_passive_shadow_blood", next_target_unit)
	end

	if not (not ALIVE[next_target_unit] and not (num < settings.max_chain_count)) then
		local var_45_25

		if not Unit.has_node(next_target_unit, "j_spine") then
			local node = Unit.node(next_target_unit, "j_spine")

			var_45_25 = Unit.world_position(next_target_unit, node)
		else
			var_45_25 = Unit.world_position(next_target_unit, 0) + Vector3.up() * 0.8
		end

		arg_45_1.chain_count = num

		arg_45_1.last_chain_pos:store(var_45_25)

		return true
	else
		return false
	end
end
