-- chunkname: @scripts/entity_system/systems/area_damage/area_damage_system.lua

AreaDamageSystem = class(AreaDamageSystem, ExtensionSystemBase)

local var_0_0 = Unit.alive
local var_0_1 = {
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
local var_0_2 = {
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
local var_0_3 = 128
local var_0_4 = 15

DLCUtils.append("area_damage_extension", var_0_2)

function AreaDamageSystem.init(arg_1_0, arg_1_1, arg_1_2)
	AreaDamageSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_2)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_1))

	arg_1_0.liquid_extensions = {}
	arg_1_0.liquid_extension_indexes = {}
	arg_1_0.num_liquid_extensions = 0
	arg_1_0._source_attacker_unit_data = {}

	arg_1_0:_create_aoe_damage_buffer()
end

local var_0_5 = {
	"DamageBlobExtension",
	"DamageWaveExtension",
	"LiquidAreaDamageExtension"
}

function AreaDamageSystem.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = AreaDamageSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	if table.contains(var_0_5, arg_2_3) then
		local var_2_1 = arg_2_0.num_liquid_extensions + 1

		arg_2_0.liquid_extensions[var_2_1] = var_2_0
		arg_2_0.liquid_extension_indexes[var_2_0] = var_2_1
		arg_2_0.num_liquid_extensions = var_2_1
	end

	local var_2_2 = arg_2_4.source_attacker_unit

	if var_2_2 then
		local var_2_3 = {
			source_attacker_unit = var_2_2,
			breed = Unit.get_data(var_2_2, "breed")
		}

		arg_2_0._source_attacker_unit_data[arg_2_2] = var_2_3

		local var_2_4 = Managers.player:owner(var_2_2)

		if var_2_4 then
			var_2_3.attacker_unique_id = var_2_4:unique_id()
			var_2_3.attacker_side = Managers.state.side.side_by_unit[var_2_2]
		end
	end

	if var_2_0.is_transient and arg_2_0.is_server then
		Managers.level_transition_handler.transient_package_loader:add_unit(arg_2_2, var_2_0.transient_name_override)
	end

	return var_2_0
end

function AreaDamageSystem.has_source_attacker_unit_data(arg_3_0, arg_3_1)
	return arg_3_0._source_attacker_unit_data[arg_3_1]
end

function AreaDamageSystem.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = ScriptUnit.extension(arg_4_1, "area_damage_system")
	local var_4_1 = arg_4_0.liquid_extension_indexes
	local var_4_2 = var_4_1[var_4_0]

	if var_4_2 then
		local var_4_3 = arg_4_0.liquid_extensions
		local var_4_4 = arg_4_0.num_liquid_extensions
		local var_4_5 = var_4_3[var_4_4]

		var_4_3[var_4_2] = var_4_5
		var_4_3[var_4_4] = nil
		var_4_1[var_4_5] = var_4_2
		var_4_1[var_4_0] = nil
		arg_4_0.num_liquid_extensions = var_4_4 - 1
	end

	arg_4_0._source_attacker_unit_data[arg_4_1] = nil

	if var_4_0.is_transient and arg_4_0.is_server then
		Managers.level_transition_handler.transient_package_loader:remove_unit(arg_4_1)
	end

	AreaDamageSystem.super.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
end

function AreaDamageSystem.destroy(arg_5_0)
	arg_5_0.network_event_delegate:unregister(arg_5_0)
end

function AreaDamageSystem.update(arg_6_0, arg_6_1, arg_6_2)
	AreaDamageSystem.super.update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_aoe_damage_buffer()
end

function AreaDamageSystem.create_explosion(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9)
	if not NetworkUtils.network_safe_position(arg_7_2) then
		return false
	end

	local var_7_0 = Managers.state.network

	if var_7_0:game() then
		local var_7_1 = ExplosionUtils.get_template(arg_7_4)
		local var_7_2 = table.clone(var_7_1)
		local var_7_3 = Managers.state.difficulty:get_difficulty()

		if var_7_2.scaling then
			var_7_2.explosion.radius = var_7_2.explosion.radius[var_7_3]
		end

		local var_7_4 = false

		DamageUtils.create_explosion(arg_7_0.world, arg_7_1, arg_7_2, arg_7_3, var_7_2, arg_7_5, arg_7_6, arg_7_0.is_server, var_7_4, arg_7_1, arg_7_7, arg_7_8)

		if var_0_0(arg_7_1) then
			local var_7_5, var_7_6 = var_7_0:game_object_or_level_id(arg_7_1)

			if var_7_5 then
				local var_7_7 = NetworkLookup.explosion_templates[arg_7_4]
				local var_7_8 = NetworkLookup.damage_sources[arg_7_6]
				local var_7_9 = arg_7_7 and math.clamp(arg_7_7, MIN_POWER_LEVEL, MAX_POWER_LEVEL) or 0
				local var_7_10 = not not arg_7_8
				local var_7_11 = var_7_0:unit_game_object_id(arg_7_9) or var_7_5

				if arg_7_0.is_server then
					arg_7_0.network_transmit:send_rpc_clients("rpc_create_explosion", var_7_5, var_7_6, arg_7_2, arg_7_3, var_7_7, arg_7_5, var_7_8, var_7_9, var_7_10, var_7_11)
				else
					arg_7_0.network_transmit:send_rpc_server("rpc_create_explosion", var_7_5, var_7_6, arg_7_2, arg_7_3, var_7_7, arg_7_5, var_7_8, var_7_9, var_7_10, var_7_11)
				end
			end
		end
	end
end

function AreaDamageSystem.enable_area_damage(arg_8_0, arg_8_1, arg_8_2)
	fassert(arg_8_0.is_server, "You better call this on the server, or it's gonna craaash")
	ScriptUnit.extension(arg_8_1, "area_damage_system"):enable_area_damage(arg_8_2)

	local var_8_0 = Managers.state.network:level_object_id(arg_8_1)

	arg_8_0.network_transmit:send_rpc_clients("rpc_enable_area_damage", var_8_0, arg_8_2)
end

function AreaDamageSystem.is_position_in_liquid(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.liquid_extensions
	local var_9_1 = arg_9_0.num_liquid_extensions
	local var_9_2 = false

	for iter_9_0 = 1, var_9_1 do
		var_9_2 = var_9_0[iter_9_0]:is_position_inside(arg_9_1, arg_9_2)

		if var_9_2 then
			break
		end
	end

	return var_9_2
end

function AreaDamageSystem._create_aoe_damage_buffer(arg_10_0)
	local var_10_0 = var_0_3

	arg_10_0._aoe_damage_ring_buffer = {
		write_index = 1,
		read_index = 1,
		size = 0,
		buffer = Script.new_array(var_10_0),
		max_size = var_10_0
	}

	for iter_10_0 = 1, var_10_0 do
		arg_10_0._aoe_damage_ring_buffer.buffer[iter_10_0] = {
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

function AreaDamageSystem.add_aoe_damage_target(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13, arg_11_14, arg_11_15, arg_11_16, arg_11_17, arg_11_18, arg_11_19, arg_11_20, arg_11_21)
	local var_11_0 = arg_11_0._aoe_damage_ring_buffer
	local var_11_1 = var_11_0.buffer
	local var_11_2 = var_11_0.read_index
	local var_11_3 = var_11_0.write_index
	local var_11_4 = var_11_0.size
	local var_11_5 = var_11_0.max_size

	if var_11_5 < var_11_4 + 1 then
		local var_11_6 = var_11_1[var_11_2]

		arg_11_0:_damage_unit(var_11_6)

		var_11_4 = var_11_4 - 1
		var_11_0.read_index = var_11_2 % var_11_5 + 1
	end

	local var_11_7 = var_11_1[var_11_3]

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
	var_11_0.size = var_11_4 + 1
	var_11_0.write_index = var_11_3 % var_11_5 + 1
end

function AreaDamageSystem._update_aoe_damage_buffer(arg_12_0)
	local var_12_0 = arg_12_0._aoe_damage_ring_buffer

	if var_12_0.size == 0 then
		return
	end

	local var_12_1 = var_12_0.buffer
	local var_12_2 = var_12_0.read_index
	local var_12_3 = var_12_0.max_size
	local var_12_4 = math.min(var_0_4, var_12_0.size)

	for iter_12_0 = 1, var_12_4 do
		local var_12_5 = var_12_1[var_12_2]

		arg_12_0:_damage_unit(var_12_5)

		var_12_2 = var_12_2 % var_12_3 + 1
		var_12_0.size = var_12_0.size - 1
	end

	var_12_0.read_index = var_12_2
end

function AreaDamageSystem._damage_unit(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1.hit_unit
	local var_13_1 = arg_13_1.attacker_unit
	local var_13_2 = arg_13_1.source_attacker_unit
	local var_13_3 = arg_13_1.impact_position:unbox()
	local var_13_4 = arg_13_1.shield_blocked
	local var_13_5 = arg_13_1.do_damage
	local var_13_6 = arg_13_1.hit_zone_name
	local var_13_7 = arg_13_1.damage_source
	local var_13_8 = arg_13_1.hit_distance
	local var_13_9 = arg_13_1.push_speed
	local var_13_10 = arg_13_1.radius
	local var_13_11 = arg_13_1.max_damage_radius
	local var_13_12 = arg_13_1.radius_min
	local var_13_13 = arg_13_1.radius_max
	local var_13_14 = arg_13_1.full_power_level
	local var_13_15 = arg_13_1.actual_power_level
	local var_13_16 = arg_13_1.hit_direction:unbox()
	local var_13_17 = arg_13_1.explosion_template_name
	local var_13_18 = arg_13_1.is_critical_strike
	local var_13_19 = arg_13_1.allow_critical_proc
	local var_13_20 = arg_13_1.target_number

	if not var_0_0(var_13_0) then
		return
	end

	if not var_0_0(var_13_1) then
		return
	end

	local var_13_21 = ExplosionUtils.get_template(var_13_17)
	local var_13_22 = var_13_21.explosion
	local var_13_23 = AiUtils.unit_breed(var_13_0)
	local var_13_24 = var_13_23 and var_13_22.immune_breeds and (var_13_22.immune_breeds[var_13_23.name] or var_13_22.immune_breeds.all)
	local var_13_25 = Managers.player:owner(var_13_0) and not Managers.player:owner(var_13_0):is_player_controlled() and var_13_22.bot_damage_immunity or false
	local var_13_26 = var_13_24 or var_13_25

	if var_13_4 then
		var_13_8 = math.lerp(var_13_8, var_13_10, 0.5)
	end

	local var_13_27 = var_13_11 < var_13_8
	local var_13_28 = Managers.player:owner(var_13_1)

	if var_13_28 ~= nil then
		local var_13_29 = rawget(ItemMasterList, var_13_7)

		if var_13_23 and var_13_29 and not IGNORED_ITEM_TYPES_FOR_BUFFS[var_13_29.item_type] then
			local var_13_30 = "aoe"

			if var_13_29 and var_13_29.item_type == "grenade" then
				var_13_30 = "grenade"
			end

			if not var_13_21.ignore_buffs then
				local var_13_31 = false

				if var_13_28 and var_13_28.remote then
					local var_13_32 = var_13_28.peer_id
					local var_13_33 = NetworkLookup.buff_attack_types[var_13_30]
					local var_13_34 = Managers.state.network
					local var_13_35 = var_13_34:unit_game_object_id(var_13_1)
					local var_13_36 = var_13_34:unit_game_object_id(var_13_0)
					local var_13_37 = NetworkLookup.hit_zones[var_13_6]
					local var_13_38 = NetworkLookup.buff_weapon_types["n/a"]
					local var_13_39 = NetworkLookup.damage_sources[var_13_7]
					local var_13_40 = PEER_ID_TO_CHANNEL[var_13_32]

					RPC.rpc_buff_on_attack(var_13_40, var_13_35, var_13_36, var_13_33, var_13_18 and var_13_19 or false, var_13_37, 1, var_13_38, var_13_39)
					DamageUtils.buff_on_attack(var_13_1, var_13_0, var_13_30, var_13_18 and var_13_19, var_13_6, var_13_20, var_13_31, "n/a", nil, var_13_7)
				elseif var_13_28 then
					DamageUtils.buff_on_attack(var_13_1, var_13_0, var_13_30, var_13_18 and var_13_19, var_13_6, var_13_20, var_13_31, "n/a", nil, var_13_7)
				end
			end

			if not var_13_21.no_aggro and not var_13_23.cannot_be_aggroed then
				AiUtils.aggro_unit_of_enemy(var_13_0, var_13_1)
			end
		end
	end

	if not var_13_26 then
		local var_13_41 = false
		local var_13_42 = BLACKBOARDS[var_13_0]
		local var_13_43 = Managers.player:owner(var_13_0)
		local var_13_44 = var_13_43 and not var_13_43:is_player_controlled()

		if var_13_42 and var_13_10 < var_13_8 and var_13_42.shield_user then
			local var_13_45 = var_13_42.stagger

			var_13_41 = not var_13_45 or var_13_45 < 1
		end

		local var_13_46

		if not var_13_41 and var_13_23 and var_13_23.hitbox_ragdoll_translation then
			var_13_46 = var_13_23.hitbox_ragdoll_translation.j_spine or var_13_23.hitbox_ragdoll_translation.j_spine1
		end

		local var_13_47 = var_13_44 and var_13_22.bot_damage_profile or var_13_27 and var_13_22.damage_profile_glance or var_13_22.damage_profile or "default"

		if not var_13_5 or var_13_26 then
			var_13_47 = var_13_47 .. "_no_damage"
		end

		local var_13_48 = Managers.time:time("game")
		local var_13_49 = DamageProfileTemplates[var_13_47]
		local var_13_50 = var_13_20
		local var_13_51 = 0
		local var_13_52 = 1
		local var_13_53 = false
		local var_13_54
		local var_13_55 = false
		local var_13_56 = 0

		DamageUtils.add_damage_network_player(var_13_49, var_13_50, var_13_15, var_13_0, var_13_1, var_13_6, var_13_3, var_13_16, var_13_7, var_13_46, var_13_51, var_13_53, var_13_54, var_13_55, var_13_56, var_13_52, var_13_2)

		if HEALTH_ALIVE[var_13_0] then
			DamageUtils.stagger_ai(var_13_48, var_13_49, var_13_50, var_13_15, var_13_0, var_13_1, var_13_6, var_13_16, var_13_51, var_13_53, var_13_4, var_13_7, var_13_2)
		elseif var_13_22.on_death_func then
			var_13_22.on_death_func(var_13_0)
		end

		DamageUtils.apply_dot(var_13_49, var_13_50, var_13_14, var_13_0, var_13_1, var_13_6, var_13_7, var_13_51, var_13_53, var_13_22, var_13_2)

		if var_13_9 and DamageUtils.is_player_unit(var_13_0) and not ScriptUnit.extension(var_13_0, "status_system"):is_disabled() then
			ScriptUnit.extension(var_13_0, "locomotion_system"):add_external_velocity(var_13_16 * var_13_9)
		end
	end
end

function AreaDamageSystem.rpc_area_damage(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_0.unit_storage:unit(arg_14_2)

	if var_14_0 then
		Unit.set_local_position(var_14_0, 0, arg_14_3)
		ScriptUnit.extension(var_14_0, "area_damage_system"):start_area_damage()
	end
end

function AreaDamageSystem.rpc_create_explosion(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11)
	if arg_15_0.is_server then
		local var_15_0 = CHANNEL_TO_PEER_ID[arg_15_1]

		arg_15_0.network_transmit:send_rpc_clients_except("rpc_create_explosion", var_15_0, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9 or 0, arg_15_10, arg_15_11)
	end

	local var_15_1

	if arg_15_3 then
		var_15_1 = LevelHelper:unit_by_index(arg_15_0.world, arg_15_2)
	else
		var_15_1 = arg_15_0.unit_storage:unit(arg_15_2)
	end

	local var_15_2 = arg_15_0.unit_storage:unit(arg_15_11)
	local var_15_3 = NetworkLookup.explosion_templates[arg_15_6]
	local var_15_4 = ExplosionUtils.get_template(var_15_3)
	local var_15_5 = NetworkLookup.damage_sources[arg_15_8]
	local var_15_6 = true

	DamageUtils.create_explosion(arg_15_0.world, var_15_1, arg_15_4, arg_15_5, var_15_4, arg_15_7, var_15_5, arg_15_0.is_server, var_15_6, var_15_1, arg_15_9, arg_15_10, var_15_2)
end

function AreaDamageSystem.rpc_enable_area_damage(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = Managers.state.network:game_object_or_level_unit(arg_16_2, true)

	ScriptUnit.extension(var_16_0, "area_damage_system"):enable(arg_16_3)
end

function AreaDamageSystem.rpc_create_liquid_damage_area(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	fassert(arg_17_0.is_server, "Error! Only the server should create Liquid Damage Areas!")

	local var_17_0 = arg_17_0.unit_storage:unit(arg_17_2)
	local var_17_1 = NetworkLookup.liquid_area_damage_templates[arg_17_5]
	local var_17_2 = {
		area_damage_system = {
			flow_dir = arg_17_4,
			liquid_template = var_17_1,
			source_unit = var_17_0
		}
	}
	local var_17_3 = "units/hub_elements/empty"
	local var_17_4 = Managers.state.unit_spawner:spawn_network_unit(var_17_3, "liquid_aoe_unit", var_17_2, arg_17_3)

	ScriptUnit.extension(var_17_4, "area_damage_system"):ready()
end

function AreaDamageSystem.rpc_add_liquid_damage_blob(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	local var_18_0 = arg_18_0.unit_storage:unit(arg_18_2)

	if var_18_0 then
		ScriptUnit.extension(var_18_0, "area_damage_system"):add_damage_blob(arg_18_3, arg_18_4, arg_18_5)
	end
end

function AreaDamageSystem.rpc_update_liquid_damage_blob(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = arg_19_0.unit_storage:unit(arg_19_2)

	if not var_19_0 then
		return
	end

	local var_19_1 = ScriptUnit.extension(var_19_0, "area_damage_system")

	arg_19_4 = NetworkLookup.liquid_damage_blob_states[arg_19_4]

	if arg_19_4 == "filled" then
		var_19_1:set_damage_blob_filled(arg_19_3)
	elseif arg_19_4 == "remove" then
		var_19_1:remove_damage_blob(arg_19_3)
	elseif arg_19_4 == "destroy" then
		var_19_1:destroy(arg_19_3)
	end
end

function AreaDamageSystem.rpc_damage_wave_set_state(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_0.unit_storage:unit(arg_20_2)

	if not var_20_0 then
		return
	end

	local var_20_1 = ScriptUnit.extension(var_20_0, "area_damage_system")

	arg_20_3 = NetworkLookup.damage_wave_states[arg_20_3]

	if arg_20_3 == "impact" then
		var_20_1:on_wavefront_impact(var_20_0)
	elseif arg_20_3 == "running" then
		var_20_1:set_running_wave(var_20_0)
	elseif arg_20_3 == "arrived" then
		var_20_1:set_wave_arrived(var_20_0)
	elseif arg_20_3 == "hide" then
		var_20_1:hide_wave(var_20_0)
	end
end

function AreaDamageSystem._create_damage_wave(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	fassert(arg_21_0.is_server, "Error! Only the server should create Damage Waves!")

	arg_21_4 = arg_21_4 or "units/hub_elements/empty"

	local var_21_0 = arg_21_5 or {}
	local var_21_1 = var_21_0.area_damage_system or {}

	var_21_1.damage_wave_template_name = arg_21_3
	var_21_1.source_unit = arg_21_1
	var_21_0.area_damage_system = var_21_1

	local var_21_2 = Managers.state.unit_spawner:spawn_network_unit(arg_21_4, "damage_wave_unit", var_21_0, arg_21_2)

	return (ScriptUnit.extension(var_21_2, "area_damage_system"))
end

function AreaDamageSystem.rpc_create_damage_wave(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	fassert(arg_22_0.is_server, "Error! Only the server should create Damage Waves!")

	local var_22_0 = "units/hub_elements/empty"
	local var_22_1 = arg_22_0.unit_storage:unit(arg_22_2)
	local var_22_2 = NetworkLookup.damage_wave_templates[arg_22_5]

	arg_22_0:_create_damage_wave(var_22_1, arg_22_3, var_22_2, var_22_0):launch_wave(nil, arg_22_4)
end

function AreaDamageSystem.rpc_create_thornsister_push_wave(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8)
	fassert(arg_23_0.is_server, "Error! Only the server should create thornsister push waves!")

	local var_23_0 = "units/hub_elements/empty"
	local var_23_1 = arg_23_0.unit_storage:unit(arg_23_2)
	local var_23_2 = NetworkLookup.damage_wave_templates[arg_23_5]
	local var_23_3 = arg_23_0:_create_damage_wave(var_23_1, arg_23_3, var_23_2)
	local var_23_4 = {}

	for iter_23_0 = 1, #arg_23_7 do
		var_23_4[iter_23_0] = Vector3Box(arg_23_7[iter_23_0])
	end

	local var_23_5 = {
		power_level = arg_23_6,
		boxed_wall_segments = var_23_4,
		wall_index = arg_23_8
	}

	var_23_3:launch_wave(nil, arg_23_4, var_23_5)
end

function AreaDamageSystem.rpc_necromancer_create_curse_weave(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	local var_24_0 = arg_24_0.unit_storage:unit(arg_24_2)

	if not var_24_0 then
		return
	end

	local var_24_1 = "units/hub_elements/empty"
	local var_24_2 = "necromancer_curse_wave"
	local var_24_3 = ScriptUnit.has_extension(var_24_0, "talent_system")

	if var_24_3 and var_24_3:has_talent("sienna_necromancer_6_3") then
		var_24_2 = "necromancer_curse_wave_linger"
	end

	local var_24_4 = DamageWaveTemplates.templates[var_24_2]
	local var_24_5 = {
		area_damage_system = {
			player_units_inside = {},
			ai_hit_by_wavefront = {}
		}
	}
	local var_24_6 = var_24_4.num_waves
	local var_24_7 = var_24_4.spawn_separation_dist
	local var_24_8 = var_24_4.target_separation_dist
	local var_24_9 = (var_24_4.max_speed + var_24_4.start_speed * 0.5) * var_24_4.time_of_life
	local var_24_10 = ScriptUnit.extension(var_24_0, "talent_system")
	local var_24_11 = false

	if var_24_11 then
		local var_24_12 = 2 * math.pi / var_24_6

		for iter_24_0 = 0, var_24_6 - 1 do
			local var_24_13 = iter_24_0 * var_24_12
			local var_24_14 = Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), var_24_13), arg_24_4)
			local var_24_15 = arg_24_3 + var_24_14 * var_24_7
			local var_24_16 = arg_24_3 + var_24_14 * var_24_9

			arg_24_0:_create_damage_wave(var_24_0, var_24_15, var_24_2, var_24_1, var_24_5):launch_wave(nil, var_24_16)
		end
	else
		local var_24_17 = Quaternion.look(arg_24_4, Vector3.up())
		local var_24_18 = Quaternion.right(var_24_17)

		for iter_24_1 = -(var_24_6 * 0.5) + 0.5, var_24_6 * 0.5 - 0.5 do
			local var_24_19 = arg_24_3 + var_24_18 * iter_24_1 * var_24_7
			local var_24_20 = arg_24_3 + var_24_18 * iter_24_1 * var_24_8 + arg_24_4 * var_24_9

			if script_data.debug_necromancer_curse_wave then
				QuickDrawerStay:sphere(var_24_19, 0.5, Colors.get("yellow"))
				QuickDrawerStay:sphere(var_24_20, 0.5, Colors.get("green"))
			end

			arg_24_0:_create_damage_wave(var_24_0, var_24_19, var_24_2, var_24_1, var_24_5):launch_wave(nil, var_24_20)
		end
	end
end

function AreaDamageSystem.rpc_necromancer_create_curse_area(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	local var_25_0 = arg_25_0.unit_storage:unit(arg_25_2)

	if not var_25_0 then
		return
	end

	local var_25_1 = arg_25_0.world
	local var_25_2 = arg_25_0.unit_storage:unit(arg_25_2)
	local var_25_3 = ExplosionUtils.get_template("sienna_necromancer_curse_area")

	if var_25_3.explosion then
		local var_25_4 = true
		local var_25_5 = Managers.state.network.is_server

		DamageUtils.create_explosion(var_25_1, var_25_2, arg_25_3, Quaternion.identity(), var_25_3, 1, "career_ability", var_25_5, var_25_4, var_25_0, false, nil, var_25_0)
	end

	if var_25_3.aoe then
		DamageUtils.create_aoe(var_25_1, var_25_2, arg_25_3, "career_ability", var_25_3)
	end
end

function AreaDamageSystem.rpc_add_damage_wave_fx(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6)
	local var_26_0 = arg_26_0.unit_storage:unit(arg_26_2)

	if var_26_0 then
		ScriptUnit.extension(var_26_0, "area_damage_system"):add_damage_wave_fx(arg_26_3, arg_26_4, arg_26_5, arg_26_6)
	end
end

function AreaDamageSystem.rpc_add_damage_blob_fx(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = arg_27_0.unit_storage:unit(arg_27_2)

	if var_27_0 then
		ScriptUnit.extension(var_27_0, "area_damage_system"):add_damage_blob_fx(arg_27_3, arg_27_4)
	end
end

function AreaDamageSystem.rpc_abort_damage_blob(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0.unit_storage:unit(arg_28_2)

	if var_28_0 then
		if arg_28_0.is_server then
			local var_28_1 = CHANNEL_TO_PEER_ID[arg_28_1]

			arg_28_0.network_transmit:send_rpc_clients_except("rpc_abort_damage_blob", var_28_1, arg_28_2)
		end

		ScriptUnit.extension(var_28_0, "area_damage_system"):abort()
	end
end
