-- chunkname: @scripts/entity_system/systems/area_damage/area_damage_system.lua

AreaDamageSystem = class(AreaDamageSystem, ExtensionSystemBase)

local alive = Unit.alive
local tbl = {
	"rpc_add_liquid_damage_blob",
	"rpc_area_damage",
	"rpc_create_explosion",
	"rpc_enable_area_damage",
	"rpc_update_liquid_damage_blob",
	"rpc_create_liquid_damage_area",
	"rpc_add_damage_wave_fx",
	"rpc_add_damage_blob_fx",
	"rpc_abort_damage_blob",
	"rpc_damage_wave_set_state",
	"rpc_create_damage_wave",
	"rpc_create_thornsister_push_wave",
	"rpc_necromancer_create_curse_weave",
	"rpc_necromancer_create_curse_area"
}
local tbl_2 = {
	"AreaDamageExtension",
	"TimedExplosionExtension",
	"LiquidAreaDamageExtension",
	"LiquidAreaDamageHuskExtension",
	"DamageWaveExtension",
	"DamageWaveHuskExtension",
	"DamageBlobExtension",
	"DamageBlobHuskExtension",
	"ProximityMineExtension"
}
local num = 128
local num_2 = 15

DLCUtils.append("area_damage_extension", tbl_2)

AreaDamageSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	AreaDamageSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.liquid_extensions = {}
	self.liquid_extension_indexes = {}
	self.num_liquid_extensions = 0
	self._source_attacker_unit_data = {}

	self:_create_aoe_damage_buffer()
end

local tbl_3 = {
	"DamageBlobExtension",
	"DamageWaveExtension",
	"LiquidAreaDamageExtension"
}

AreaDamageSystem.on_add_extension = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local on_add_extension = AreaDamageSystem.super.on_add_extension(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	if not table.contains(tbl_3, arg_2_3) then
		local num = self.num_liquid_extensions + 1

		self.liquid_extensions[num] = on_add_extension
		self.liquid_extension_indexes[on_add_extension] = num
		self.num_liquid_extensions = num
	end

	local source_attacker_unit = arg_2_4.source_attacker_unit

	if not source_attacker_unit then
		local tbl = {
			source_attacker_unit = source_attacker_unit,
			breed = Unit.get_data(source_attacker_unit, "breed")
		}

		self._source_attacker_unit_data[arg_2_2] = tbl

		local owner = Managers.player:owner(source_attacker_unit)

		if not owner then
			tbl.attacker_unique_id = owner:unique_id()
			tbl.attacker_side = Managers.state.side.side_by_unit[source_attacker_unit]
		end
	end

	if not on_add_extension.is_transient and not self.is_server then
		Managers.level_transition_handler.transient_package_loader:add_unit(arg_2_2, on_add_extension.transient_name_override)
	end

	return on_add_extension
end

AreaDamageSystem.has_source_attacker_unit_data = function (self, arg_3_1)
	-- function 3
	return self._source_attacker_unit_data[arg_3_1]
end

AreaDamageSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	local extension = ScriptUnit.extension(arg_4_1, "area_damage_system")
	local liquid_extension_indexes = self.liquid_extension_indexes
	local var_4_2 = liquid_extension_indexes[extension]

	if not var_4_2 then
		local liquid_extensions = self.liquid_extensions
		local num_liquid_extensions = self.num_liquid_extensions
		local var_4_5 = liquid_extensions[num_liquid_extensions]

		liquid_extensions[var_4_2] = var_4_5
		liquid_extensions[num_liquid_extensions] = nil
		liquid_extension_indexes[var_4_5] = var_4_2
		liquid_extension_indexes[extension] = nil
		self.num_liquid_extensions = num_liquid_extensions - 1
	end

	self._source_attacker_unit_data[arg_4_1] = nil

	if not extension.is_transient and not self.is_server then
		Managers.level_transition_handler.transient_package_loader:remove_unit(arg_4_1)
	end

	AreaDamageSystem.super.on_remove_extension(self, arg_4_1, arg_4_2)
end

AreaDamageSystem.destroy = function (self)
	-- function 5
	self.network_event_delegate:unregister(self)
end

AreaDamageSystem.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	AreaDamageSystem.super.update(self, arg_6_1, arg_6_2)
	self:_update_aoe_damage_buffer()
end

AreaDamageSystem.create_explosion = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9)
	-- function 7
	if not NetworkUtils.network_safe_position(arg_7_2) then
		return false
	end

	local network = Managers.state.network

	if not network:game() then
		local get_template = ExplosionUtils.get_template(arg_7_4)
		local clone = table.clone(get_template)
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		if not clone.scaling then
			clone.explosion.radius = clone.explosion.radius[get_difficulty]
		end

		local flag = false

		DamageUtils.create_explosion(self.world, arg_7_1, arg_7_2, arg_7_3, clone, arg_7_5, arg_7_6, self.is_server, flag, arg_7_1, arg_7_7, arg_7_8)

		if not alive(arg_7_1) then
			local game_object_or_level_id, var_7_6 = network:game_object_or_level_id(arg_7_1)

			if not game_object_or_level_id then
				local var_7_7 = NetworkLookup.explosion_templates[arg_7_4]
				local var_7_8 = NetworkLookup.damage_sources[arg_7_6]
				local clamp

				if not arg_7_7 then
					clamp = math.clamp(arg_7_7, MIN_POWER_LEVEL, MAX_POWER_LEVEL)

					if not clamp then
						-- Nothing
					end
				end

				clamp = 0

				::label_7_0::

				local flag_2 = not not arg_7_8
				local unit_game_object_id = network:unit_game_object_id(arg_7_9)

				unit_game_object_id = unit_game_object_id or game_object_or_level_id

				if not self.is_server then
					self.network_transmit:send_rpc_clients("rpc_create_explosion", game_object_or_level_id, var_7_6, arg_7_2, arg_7_3, var_7_7, arg_7_5, var_7_8, clamp, flag_2, unit_game_object_id)
				else
					self.network_transmit:send_rpc_server("rpc_create_explosion", game_object_or_level_id, var_7_6, arg_7_2, arg_7_3, var_7_7, arg_7_5, var_7_8, clamp, flag_2, unit_game_object_id)
				end
			end
		end
	end
end

AreaDamageSystem.enable_area_damage = function (self, arg_8_1, arg_8_2)
	-- function 8
	fassert(self.is_server, "You better call this on the server, or it's gonna craaash")
	ScriptUnit.extension(arg_8_1, "area_damage_system"):enable_area_damage(arg_8_2)

	local level_object_id = Managers.state.network:level_object_id(arg_8_1)

	self.network_transmit:send_rpc_clients("rpc_enable_area_damage", level_object_id, arg_8_2)
end

AreaDamageSystem.is_position_in_liquid = function (self, arg_9_1, arg_9_2)
	-- function 9
	local liquid_extensions = self.liquid_extensions
	local num_liquid_extensions = self.num_liquid_extensions
	local flag = false

	for i = 1, num_liquid_extensions do
		flag = liquid_extensions[i]:is_position_inside(arg_9_1, arg_9_2)

		if not flag then
			break
		end
	end

	return flag
end

AreaDamageSystem._create_aoe_damage_buffer = function (self)
	-- function 10
	local var_10_0 = num

	self._aoe_damage_ring_buffer = {
		write_index = 1,
		read_index = 1,
		size = 0,
		buffer = Script.new_array(var_10_0),
		max_size = var_10_0
	}

	for i = 1, var_10_0 do
		self._aoe_damage_ring_buffer.buffer[i] = {
			radius = 0,
			radius_max = 0,
			max_damage_radius = 0,
			shield_blocked = false,
			do_damage = false,
			radius_min = 0,
			full_power_level = 0,
			hit_distance = 0,
			hit_zone_name = "n/a",
			actual_power_level = 0,
			damage_source = "n/a",
			explosion_template_name = "n/a",
			push_speed = 0,
			impact_position = Vector3Box(),
			hit_direction = Vector3Box()
		}
	end
end

AreaDamageSystem.add_aoe_damage_target = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13, arg_11_14, arg_11_15, arg_11_16, arg_11_17, arg_11_18, arg_11_19, arg_11_20, arg_11_21)
	-- function 11
	local _aoe_damage_ring_buffer = self._aoe_damage_ring_buffer
	local buffer = _aoe_damage_ring_buffer.buffer
	local read_index = _aoe_damage_ring_buffer.read_index
	local write_index = _aoe_damage_ring_buffer.write_index
	local size = _aoe_damage_ring_buffer.size
	local max_size = _aoe_damage_ring_buffer.max_size

	if max_size < size + 1 then
		local var_11_6 = buffer[read_index]

		self:_damage_unit(var_11_6)

		size = size - 1
		_aoe_damage_ring_buffer.read_index = read_index % max_size + 1
	end

	local var_11_7 = buffer[write_index]

	var_11_7.hit_unit = arg_11_1
	var_11_7.attacker_unit = arg_11_2
	var_11_7.source_attacker_unit = arg_11_20

	var_11_7.impact_position:store(arg_11_3)

	var_11_7.shield_blocked = arg_11_4
	var_11_7.do_damage = arg_11_5
	var_11_7.hit_zone_name = arg_11_6
	var_11_7.damage_source = arg_11_7
	var_11_7.hit_distance = arg_11_8
	var_11_7.push_speed = arg_11_9
	var_11_7.radius = arg_11_10
	var_11_7.max_damage_radius = arg_11_11
	var_11_7.radius_min = arg_11_12
	var_11_7.radius_max = arg_11_13
	var_11_7.full_power_level = arg_11_14
	var_11_7.actual_power_level = arg_11_15

	var_11_7.hit_direction:store(arg_11_16)

	var_11_7.explosion_template_name = arg_11_17
	var_11_7.is_critical_strike = arg_11_18
	var_11_7.allow_critical_proc = arg_11_19
	var_11_7.target_number = arg_11_21
	_aoe_damage_ring_buffer.size = size + 1
	_aoe_damage_ring_buffer.write_index = write_index % max_size + 1
end

AreaDamageSystem._update_aoe_damage_buffer = function (self)
	-- function 12
	local _aoe_damage_ring_buffer = self._aoe_damage_ring_buffer

	if _aoe_damage_ring_buffer.size == 0 then
		return
	end

	local buffer = _aoe_damage_ring_buffer.buffer
	local read_index = _aoe_damage_ring_buffer.read_index
	local max_size = _aoe_damage_ring_buffer.max_size
	local min = math.min(num_2, _aoe_damage_ring_buffer.size)

	for i = 1, min do
		local var_12_5 = buffer[read_index]

		self:_damage_unit(var_12_5)

		read_index = read_index % max_size + 1
		_aoe_damage_ring_buffer.size = _aoe_damage_ring_buffer.size - 1
	end

	_aoe_damage_ring_buffer.read_index = read_index
end

AreaDamageSystem._damage_unit = function (arg_13_0, arg_13_1)
	-- function 13
	local hit_unit = arg_13_1.hit_unit
	local attacker_unit = arg_13_1.attacker_unit
	local source_attacker_unit = arg_13_1.source_attacker_unit
	local unbox = arg_13_1.impact_position:unbox()
	local shield_blocked = arg_13_1.shield_blocked
	local do_damage = arg_13_1.do_damage
	local hit_zone_name = arg_13_1.hit_zone_name
	local damage_source = arg_13_1.damage_source
	local hit_distance = arg_13_1.hit_distance
	local push_speed = arg_13_1.push_speed
	local radius = arg_13_1.radius
	local max_damage_radius = arg_13_1.max_damage_radius
	local radius_min = arg_13_1.radius_min
	local radius_max = arg_13_1.radius_max
	local full_power_level = arg_13_1.full_power_level
	local actual_power_level = arg_13_1.actual_power_level
	local unbox_2 = arg_13_1.hit_direction:unbox()
	local explosion_template_name = arg_13_1.explosion_template_name
	local is_critical_strike = arg_13_1.is_critical_strike
	local allow_critical_proc = arg_13_1.allow_critical_proc
	local target_number = arg_13_1.target_number

	if not alive(hit_unit) then
		return
	end

	if not alive(attacker_unit) then
		return
	end

	local get_template = ExplosionUtils.get_template(explosion_template_name)
	local explosion = get_template.explosion
	local unit_breed = AiUtils.unit_breed(hit_unit)

	if not unit_breed then
		-- Nothing
	end

	::label_13_0::

	local immune_breeds = explosion.immune_breeds

	if not immune_breeds then
		immune_breeds = explosion.immune_breeds[unit_breed.name]
		immune_breeds = immune_breeds or explosion.immune_breeds.all
	end

	::label_13_1::

	local owner = Managers.player:owner(hit_unit)

	owner = not owner and not Managers.player:owner(hit_unit):is_player_controlled()

	local bot_damage_immunity

	if not owner then
		bot_damage_immunity = explosion.bot_damage_immunity

		if not bot_damage_immunity then
			-- Nothing
		end
	end

	bot_damage_immunity = false

	::label_13_2::

	local flag = immune_breeds or bot_damage_immunity

	if not shield_blocked then
		hit_distance = math.lerp(hit_distance, radius, 0.5)
	end

	local flag_2 = max_damage_radius < hit_distance
	local owner_2 = Managers.player:owner(attacker_unit)

	if not (owner_2 ~= nil) then
		local var_13_30 = rawget(ItemMasterList, damage_source)

		if not (not unit_breed and not var_13_30 and IGNORED_ITEM_TYPES_FOR_BUFFS[var_13_30.item_type]) then
			local str = "aoe"

			if not (not var_13_30 and var_13_30.item_type ~= "grenade") then
				str = "grenade"
			end

			if not get_template.ignore_buffs then
				local flag_3 = false

				if not owner_2 and not owner_2.remote then
					local peer_id = owner_2.peer_id
					local var_13_34 = NetworkLookup.buff_attack_types[str]
					local network = Managers.state.network
					local unit_game_object_id = network:unit_game_object_id(attacker_unit)
					local unit_game_object_id_2 = network:unit_game_object_id(hit_unit)
					local var_13_38 = NetworkLookup.hit_zones[hit_zone_name]
					local var_13_39 = NetworkLookup.buff_weapon_types["n/a"]
					local var_13_40 = NetworkLookup.damage_sources[damage_source]
					local var_13_41 = PEER_ID_TO_CHANNEL[peer_id]

					RPC.rpc_buff_on_attack(var_13_41, unit_game_object_id, unit_game_object_id_2, var_13_34, not is_critical_strike and allow_critical_proc and false, var_13_38, 1, var_13_39, var_13_40)
					DamageUtils.buff_on_attack(attacker_unit, hit_unit, str, not is_critical_strike and allow_critical_proc, hit_zone_name, target_number, flag_3, "n/a", nil, damage_source)
				elseif not owner_2 then
					DamageUtils.buff_on_attack(attacker_unit, hit_unit, str, not is_critical_strike and allow_critical_proc, hit_zone_name, target_number, flag_3, "n/a", nil, damage_source)
				end
			end

			if not (get_template.no_aggro or unit_breed.cannot_be_aggroed) then
				AiUtils.aggro_unit_of_enemy(hit_unit, attacker_unit)
			end
		end
	end

	if not flag then
		local flag_4 = false
		local var_13_43 = BLACKBOARDS[hit_unit]
		local owner_3 = Managers.player:owner(hit_unit)
		local flag_5 = not owner_3 and not owner_3:is_player_controlled()

		if not var_13_43 and not (radius < hit_distance) or not var_13_43.shield_user then
			local stagger = var_13_43.stagger

			flag_4 = not stagger and stagger < 1
		end

		local var_13_47

		if (flag_4 or not unit_breed) and not unit_breed.hitbox_ragdoll_translation then
			var_13_47 = unit_breed.hitbox_ragdoll_translation.j_spine or unit_breed.hitbox_ragdoll_translation.j_spine1
		end

		if not (not flag_5 and explosion.bot_damage_profile) then
			-- Nothing
		end

		do
			local damage_profile_glance
		end

		::label_13_3::

		if not flag_2 then
			damage_profile_glance = explosion.damage_profile_glance

			if not damage_profile_glance then
				-- Nothing
			end
		end

		damage_profile_glance = explosion.damage_profile
		damage_profile_glance = damage_profile_glance or "default"

		::label_13_4::

		if not do_damage and not flag then
			damage_profile_glance = damage_profile_glance .. "_no_damage"
		end

		local time = Managers.time:time("game")
		local var_13_50 = DamageProfileTemplates[damage_profile_glance]
		local var_13_51 = target_number
		local num = 0
		local num_2 = 1
		local flag_6 = false
		local var_13_55
		local flag_7 = false
		local num_3 = 0

		DamageUtils.add_damage_network_player(var_13_50, var_13_51, actual_power_level, hit_unit, attacker_unit, hit_zone_name, unbox, unbox_2, damage_source, var_13_47, num, flag_6, var_13_55, flag_7, num_3, num_2, source_attacker_unit)

		if not HEALTH_ALIVE[hit_unit] then
			DamageUtils.stagger_ai(time, var_13_50, var_13_51, actual_power_level, hit_unit, attacker_unit, hit_zone_name, unbox_2, num, flag_6, shield_blocked, damage_source, source_attacker_unit)
		elseif not explosion.on_death_func then
			explosion.on_death_func(hit_unit)
		end

		DamageUtils.apply_dot(var_13_50, var_13_51, full_power_level, hit_unit, attacker_unit, hit_zone_name, damage_source, num, flag_6, explosion, source_attacker_unit)

		if not (not push_speed and not DamageUtils.is_player_unit(hit_unit) and ScriptUnit.extension(hit_unit, "status_system"):is_disabled()) then
			ScriptUnit.extension(hit_unit, "locomotion_system"):add_external_velocity(unbox_2 * push_speed)
		end
	end
end

AreaDamageSystem.rpc_area_damage = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local unit = self.unit_storage:unit(arg_14_2)

	if not unit then
		Unit.set_local_position(unit, 0, arg_14_3)
		ScriptUnit.extension(unit, "area_damage_system"):start_area_damage()
	end
end

AreaDamageSystem.rpc_create_explosion = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11)
	-- function 15
	if not self.is_server then
		local var_15_0 = CHANNEL_TO_PEER_ID[arg_15_1]

		self.network_transmit:send_rpc_clients_except("rpc_create_explosion", var_15_0, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9 or 0, arg_15_10, arg_15_11)
	end

	local var_15_1

	if not arg_15_3 then
		var_15_1 = LevelHelper:unit_by_index(self.world, arg_15_2)
	else
		var_15_1 = self.unit_storage:unit(arg_15_2)
	end

	local unit = self.unit_storage:unit(arg_15_11)
	local var_15_3 = NetworkLookup.explosion_templates[arg_15_6]
	local get_template = ExplosionUtils.get_template(var_15_3)
	local var_15_5 = NetworkLookup.damage_sources[arg_15_8]
	local flag = true

	DamageUtils.create_explosion(self.world, var_15_1, arg_15_4, arg_15_5, get_template, arg_15_7, var_15_5, self.is_server, flag, var_15_1, arg_15_9, arg_15_10, unit)
end

AreaDamageSystem.rpc_enable_area_damage = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_16_2, true)

	ScriptUnit.extension(game_object_or_level_unit, "area_damage_system"):enable(arg_16_3)
end

AreaDamageSystem.rpc_create_liquid_damage_area = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	fassert(self.is_server, "Error! Only the server should create Liquid Damage Areas!")

	local unit = self.unit_storage:unit(arg_17_2)
	local var_17_1 = NetworkLookup.liquid_area_damage_templates[arg_17_5]
	local tbl = {
		area_damage_system = {
			flow_dir = arg_17_4,
			liquid_template = var_17_1,
			source_unit = unit
		}
	}
	local str = "units/hub_elements/empty"
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "liquid_aoe_unit", tbl, arg_17_3)

	ScriptUnit.extension(spawn_network_unit, "area_damage_system"):ready()
end

AreaDamageSystem.rpc_add_liquid_damage_blob = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
	local unit = self.unit_storage:unit(arg_18_2)

	if not unit then
		ScriptUnit.extension(unit, "area_damage_system"):add_damage_blob(arg_18_3, arg_18_4, arg_18_5)
	end
end

AreaDamageSystem.rpc_update_liquid_damage_blob = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	local unit = self.unit_storage:unit(arg_19_2)

	if not unit then
		return
	end

	local extension = ScriptUnit.extension(unit, "area_damage_system")

	arg_19_4 = NetworkLookup.liquid_damage_blob_states[arg_19_4]

	if arg_19_4 == "filled" then
		extension:set_damage_blob_filled(arg_19_3)
	elseif arg_19_4 == "remove" then
		extension:remove_damage_blob(arg_19_3)
	elseif arg_19_4 == "destroy" then
		extension:destroy(arg_19_3)
	end
end

AreaDamageSystem.rpc_damage_wave_set_state = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local unit = self.unit_storage:unit(arg_20_2)

	if not unit then
		return
	end

	local extension = ScriptUnit.extension(unit, "area_damage_system")

	arg_20_3 = NetworkLookup.damage_wave_states[arg_20_3]

	if arg_20_3 == "impact" then
		extension:on_wavefront_impact(unit)
	elseif arg_20_3 == "running" then
		extension:set_running_wave(unit)
	elseif arg_20_3 == "arrived" then
		extension:set_wave_arrived(unit)
	elseif arg_20_3 == "hide" then
		extension:hide_wave(unit)
	end
end

AreaDamageSystem._create_damage_wave = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	fassert(self.is_server, "Error! Only the server should create Damage Waves!")

	arg_21_4 = arg_21_4 or "units/hub_elements/empty"

	local flag = arg_21_5 or {}
	local area_damage_system = flag.area_damage_system

	area_damage_system = area_damage_system or {}
	area_damage_system.damage_wave_template_name = arg_21_3
	area_damage_system.source_unit = arg_21_1
	flag.area_damage_system = area_damage_system

	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(arg_21_4, "damage_wave_unit", flag, arg_21_2)

	return (ScriptUnit.extension(spawn_network_unit, "area_damage_system"))
end

AreaDamageSystem.rpc_create_damage_wave = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	fassert(self.is_server, "Error! Only the server should create Damage Waves!")

	local str = "units/hub_elements/empty"
	local unit = self.unit_storage:unit(arg_22_2)
	local var_22_2 = NetworkLookup.damage_wave_templates[arg_22_5]

	self:_create_damage_wave(unit, arg_22_3, var_22_2, str):launch_wave(nil, arg_22_4)
end

AreaDamageSystem.rpc_create_thornsister_push_wave = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8)
	-- function 23
	fassert(self.is_server, "Error! Only the server should create thornsister push waves!")

	local str = "units/hub_elements/empty"
	local unit = self.unit_storage:unit(arg_23_2)
	local var_23_2 = NetworkLookup.damage_wave_templates[arg_23_5]
	local _create_damage_wave = self:_create_damage_wave(unit, arg_23_3, var_23_2)
	local tbl = {}

	for i = 1, #arg_23_7 do
		tbl[i] = Vector3Box(arg_23_7[i])
	end

	local tbl_2 = {
		power_level = arg_23_6,
		boxed_wall_segments = tbl,
		wall_index = arg_23_8
	}

	_create_damage_wave:launch_wave(nil, arg_23_4, tbl_2)
end

AreaDamageSystem.rpc_necromancer_create_curse_weave = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	-- function 24
	local unit = self.unit_storage:unit(arg_24_2)

	if not unit then
		return
	end

	local str = "units/hub_elements/empty"
	local str_2 = "necromancer_curse_wave"
	local has_extension = ScriptUnit.has_extension(unit, "talent_system")

	if not has_extension and not has_extension:has_talent("sienna_necromancer_6_3") then
		str_2 = "necromancer_curse_wave_linger"
	end

	local var_24_4 = DamageWaveTemplates.templates[str_2]
	local tbl = {
		area_damage_system = {
			player_units_inside = {},
			ai_hit_by_wavefront = {}
		}
	}
	local num_waves = var_24_4.num_waves
	local spawn_separation_dist = var_24_4.spawn_separation_dist
	local target_separation_dist = var_24_4.target_separation_dist
	local num = (var_24_4.max_speed + var_24_4.start_speed * 0.5) * var_24_4.time_of_life
	local extension = ScriptUnit.extension(unit, "talent_system")
	local flag = false

	if not flag then
		local num_2 = 2 * math.pi / num_waves

		for i = 0, num_waves - 1 do
			local num_3 = i * num_2
			local rotate = Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), num_3), arg_24_4)
			local num_4 = arg_24_3 + rotate * spawn_separation_dist
			local num_5 = arg_24_3 + rotate * num

			self:_create_damage_wave(unit, num_4, str_2, str, tbl):launch_wave(nil, num_5)
		end
	else
		local look = Quaternion.look(arg_24_4, Vector3.up())
		local right = Quaternion.right(look)

		for j = -(num_waves * 0.5) + 0.5, num_waves * 0.5 - 0.5 do
			local num_6 = arg_24_3 + right * j * spawn_separation_dist
			local num_7 = arg_24_3 + right * j * target_separation_dist + arg_24_4 * num

			if not script_data.debug_necromancer_curse_wave then
				QuickDrawerStay:sphere(num_6, 0.5, Colors.get("yellow"))
				QuickDrawerStay:sphere(num_7, 0.5, Colors.get("green"))
			end

			self:_create_damage_wave(unit, num_6, str_2, str, tbl):launch_wave(nil, num_7)
		end
	end
end

AreaDamageSystem.rpc_necromancer_create_curse_area = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	-- function 25
	local unit = self.unit_storage:unit(arg_25_2)

	if not unit then
		return
	end

	local world = self.world
	local unit_2 = self.unit_storage:unit(arg_25_2)
	local get_template = ExplosionUtils.get_template("sienna_necromancer_curse_area")

	if not get_template.explosion then
		local flag = true
		local is_server = Managers.state.network.is_server

		DamageUtils.create_explosion(world, unit_2, arg_25_3, Quaternion.identity(), get_template, 1, "career_ability", is_server, flag, unit, false, nil, unit)
	end

	if not get_template.aoe then
		DamageUtils.create_aoe(world, unit_2, arg_25_3, "career_ability", get_template)
	end
end

AreaDamageSystem.rpc_add_damage_wave_fx = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6)
	-- function 26
	local unit = self.unit_storage:unit(arg_26_2)

	if not unit then
		ScriptUnit.extension(unit, "area_damage_system"):add_damage_wave_fx(arg_26_3, arg_26_4, arg_26_5, arg_26_6)
	end
end

AreaDamageSystem.rpc_add_damage_blob_fx = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local unit = self.unit_storage:unit(arg_27_2)

	if not unit then
		ScriptUnit.extension(unit, "area_damage_system"):add_damage_blob_fx(arg_27_3, arg_27_4)
	end
end

AreaDamageSystem.rpc_abort_damage_blob = function (self, arg_28_1, arg_28_2)
	-- function 28
	local unit = self.unit_storage:unit(arg_28_2)

	if not unit then
		if not self.is_server then
			local var_28_1 = CHANNEL_TO_PEER_ID[arg_28_1]

			self.network_transmit:send_rpc_clients_except("rpc_abort_damage_blob", var_28_1, arg_28_2)
		end

		ScriptUnit.extension(unit, "area_damage_system"):abort()
	end
end
