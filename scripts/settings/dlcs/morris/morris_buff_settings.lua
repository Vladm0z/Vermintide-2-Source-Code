-- chunkname: @scripts/settings/dlcs/morris/morris_buff_settings.lua

require("scripts/settings/dlcs/morris/deus_power_up_settings")
require("scripts/settings/dlcs/morris/greed_pinata_settings")
require("scripts/settings/dlcs/morris/tweak_data/buff_tweak_data")

local var_0_0 = require("scripts/utils/buff_area_helper")
local var_0_1 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local var_0_2 = DLCSettings.morris

local function var_0_3(arg_1_0)
	local var_1_0 = Managers.player:owner(arg_1_0)

	return var_1_0 and not var_1_0.remote
end

local function var_0_4(arg_2_0)
	local var_2_0 = Managers.player:owner(arg_2_0)

	return var_2_0 and var_2_0.bot_player
end

local function var_0_5(arg_3_0)
	return var_0_3(arg_3_0) and not var_0_4(arg_3_0)
end

local function var_0_6()
	return Managers.state.network.is_server
end

local function var_0_7(arg_5_0)
	local var_5_0 = Managers.player:owner(arg_5_0)

	return var_5_0 and (var_5_0.remote or var_5_0.bot_player) or false
end

local function var_0_8(arg_6_0, arg_6_1, arg_6_2)
	if ALIVE[arg_6_0] then
		if var_0_6() then
			DamageUtils.heal_network(arg_6_0, arg_6_0, arg_6_2, arg_6_1)
		else
			local var_6_0 = Managers.state.network
			local var_6_1 = var_6_0:unit_game_object_id(arg_6_0)
			local var_6_2 = NetworkLookup.heal_types[arg_6_1]

			var_6_0.network_transmit:send_rpc_server("rpc_request_heal", var_6_1, arg_6_2, var_6_2)
		end
	end
end

local function var_0_9(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.template

	return var_7_0.pickup_names and var_7_0.pickup_names[arg_7_1.pickup_name] or var_7_0.pickup_slot_names and var_7_0.pickup_slot_names[arg_7_1.slot_name] or var_7_0.pickup_types and var_7_0.pickup_types[arg_7_1.type]
end

local function var_0_10(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = math.random()
	local var_8_1 = 0
	local var_8_2 = arg_8_1 + Vector3(math.random(-0.5, 0.5), math.random(-0.5, 0.5), 2)

	for iter_8_0, iter_8_1 in pairs(arg_8_0) do
		var_8_1 = var_8_1 + iter_8_1.drop_weight

		if var_8_0 <= var_8_1 and iter_8_1.spawn_function(iter_8_0, var_8_2, iter_8_1.pickup_data, arg_8_2) then
			break
		end
	end
end

local function var_0_11(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if var_0_3(arg_9_0) and not var_0_4(arg_9_0) then
		local var_9_0 = Managers.world:wwise_world(arg_9_3)

		WwiseWorld.trigger_event(var_9_0, "Play_potion_morris_effect_end")
	end
end

local function var_0_12(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	local var_10_0 = AiAnimUtils.position_network_scale(arg_10_1, true)
	local var_10_1 = AiAnimUtils.rotation_network_scale(arg_10_2, true)
	local var_10_2 = AiAnimUtils.velocity_network_scale(arg_10_3, true)
	local var_10_3 = Managers.time:time("game")
	local var_10_4 = Math.random_range(-arg_10_6, arg_10_6)
	local var_10_5 = {
		explode_time = var_10_3 + arg_10_4 + var_10_4,
		fuse_time = arg_10_5,
		attacker_unit_id = Managers.state.network:unit_game_object_id(arg_10_7)
	}
	local var_10_6 = {
		projectile_locomotion_system = {
			network_position = var_10_0,
			network_rotation = var_10_1,
			network_velocity = var_10_2,
			network_angular_velocity = var_10_2
		},
		death_system = {
			in_hand = false,
			death_data = var_10_5,
			item_name = arg_10_0
		},
		health_system = {
			damage = 1,
			health_data = var_10_5,
			item_name = arg_10_0
		},
		pickup_system = {
			has_physics = true,
			spawn_type = "loot",
			pickup_name = arg_10_0
		}
	}
	local var_10_7 = AllPickups[arg_10_0]
	local var_10_8 = var_10_7.unit_name
	local var_10_9 = var_10_7.unit_template_name or "pickup_unit"

	return Managers.state.unit_spawner:spawn_network_unit(var_10_8, var_10_9, var_10_6, arg_10_1, arg_10_2)
end

local function var_0_13(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	Managers.state.entity:system("projectile_system"):spawn_drones(arg_11_0, "deus_damage_drone", arg_11_1, arg_11_2, SideRelations.enemy, arg_11_3)
end

var_0_2.buff_function_templates = {
	update_stockpile_buff = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		if arg_12_1.buffs_applied then
			return
		end

		local var_12_0 = ScriptUnit.has_extension(arg_12_0, "inventory_system")

		if var_12_0 then
			var_12_0:refresh_buffs_on_ammo()

			arg_12_1.buffs_applied = true
		end
	end,
	remove_stockpile_buff = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
		ScriptUnit.extension(arg_13_0, "buff_system"):add_buff("stockpile_refresh_ammo_buffs")
	end,
	start_armor_breaker = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
		arg_14_1.next_tick_t = arg_14_2.t + 0.5

		local var_14_0 = Managers.player:local_player()
		local var_14_1 = var_14_0 and var_14_0.player_unit
		local var_14_2 = Managers.world:wwise_world(arg_14_3)
		local var_14_3 = 0
		local var_14_4

		if arg_14_0 == var_14_1 then
			local var_14_5 = ScriptUnit.extension(var_14_1, "career_system")

			local function var_14_6(arg_15_0, arg_15_1)
				local var_15_0 = BackendUtils.get_loadout_item(arg_15_0, arg_15_1)
				local var_15_1 = var_15_0.traits

				if var_15_1 then
					for iter_15_0, iter_15_1 in ipairs(var_15_1) do
						if iter_15_1 == "armor_breaker" then
							return var_15_0.power_level
						end
					end
				end

				return arg_14_1.template.default_power_level
			end

			local var_14_7 = var_14_5:career_name()

			var_14_3 = math.max(var_14_6(var_14_7, "slot_melee"), var_14_6(var_14_7, "slot_ranged"))

			local var_14_8 = ScriptUnit.extension(arg_14_0, "first_person_system").first_person_unit

			var_14_4 = World.create_particles(arg_14_3, "fx/magic_wind_metal_blade_dance_01_1p", POSITION_LOOKUP[var_14_8])

			World.link_particles(arg_14_3, var_14_4, var_14_8, Unit.node(var_14_8, "root_point"), Matrix4x4.identity(), "stop")
			WwiseWorld.trigger_event(var_14_2, "Play_wind_metal_gameplay_mutator_wind_loop")
		else
			WwiseUtils.trigger_unit_event(arg_14_3, "Play_wind_metal_gameplay_mutator_wind_loop", arg_14_0, 0)

			var_14_4 = World.create_particles(arg_14_3, "fx/magic_wind_metal_blade_dance_01", POSITION_LOOKUP[arg_14_0])

			World.link_particles(arg_14_3, var_14_4, arg_14_0, Unit.node(arg_14_0, "root_point"), Matrix4x4.identity(), "stop")
		end

		arg_14_1.power_level = var_14_3
		arg_14_1.linked_effect = var_14_4
	end,
	update_armor_breaker = function(arg_16_0, arg_16_1, arg_16_2)
		if arg_16_2.t >= arg_16_1.next_tick_t then
			arg_16_1.next_tick_t = arg_16_2.t + 0.5

			local var_16_0 = Managers.state.entity:system("area_damage_system")
			local var_16_1 = POSITION_LOOKUP[arg_16_0] + Vector3(0, 0, 1)
			local var_16_2 = Unit.local_rotation(arg_16_0, 0)

			var_16_0:create_explosion(arg_16_0, var_16_1, var_16_2, "armor_breaker", 1, "undefined", arg_16_1.power_level, false)
		end
	end,
	remove_armor_breaker = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
		local var_17_0 = Managers.player:local_player()
		local var_17_1 = var_17_0 and var_17_0.player_unit
		local var_17_2 = Managers.world:wwise_world(arg_17_3)

		if arg_17_0 == var_17_1 then
			WwiseWorld.trigger_event(var_17_2, "Stop_wind_metal_gameplay_mutator_wind_loop")
		else
			WwiseUtils.trigger_unit_event(arg_17_3, "Stop_wind_metal_gameplay_mutator_wind_loop", arg_17_0, 0)
		end

		local var_17_3 = arg_17_1.linked_effect

		if var_17_3 then
			World.destroy_particles(arg_17_3, var_17_3)

			arg_17_1.linked_effect = nil
		end
	end,
	apply_mark_of_nurgle = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		if DEDICATED_SERVER then
			return
		end

		local var_18_0 = arg_18_1.template
		local var_18_1 = var_18_0.mark_particle
		local var_18_2 = World.create_particles(arg_18_3, var_18_1, POSITION_LOOKUP[arg_18_0])

		World.link_particles(arg_18_3, var_18_2, arg_18_0, Unit.node(arg_18_0, "j_spine"), Matrix4x4.identity(), "stop")

		local var_18_3 = var_18_0.start_sound_event_name
		local var_18_4, var_18_5, var_18_6 = WwiseUtils.trigger_unit_event(arg_18_3, var_18_3, arg_18_0, 0)

		arg_18_1.sound_id = var_18_4
		arg_18_1.wwise_world = var_18_6
		arg_18_1.linked_effect = var_18_2
	end,
	remove_mark_of_nurgle = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		local var_19_0 = arg_19_1.linked_effect

		if var_19_0 then
			World.destroy_particles(arg_19_3, var_19_0)

			arg_19_1.linked_effect = nil
		end

		local var_19_1 = arg_19_1.sound_id

		if var_19_1 then
			WwiseWorld.stop_event(arg_19_1.wwise_world, var_19_1)

			arg_19_1.sound_id = nil
		end
	end,
	apply_generic_aoe = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		var_0_0.setup_range_check(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	end,
	update_generic_aoe = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
		var_0_0.update_range_check(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	end,
	unit_entered_range_generic_buff = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
		local var_22_0 = ScriptUnit.has_extension(arg_22_0, "buff_system")

		if var_22_0 then
			if not var_0_7(arg_22_0) then
				local var_22_1 = Managers.world:wwise_world(arg_22_4)

				WwiseWorld.trigger_event(var_22_1, "Play_blessing_rally_flag_loop")
			end

			local var_22_2 = arg_22_2.template.in_range_units_buff_name

			return (var_22_0:add_buff(var_22_2))
		end
	end,
	unit_left_range_generic_buff = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
		if ALIVE[arg_23_0] then
			if not var_0_7(arg_23_0) then
				local var_23_0 = Managers.world:wwise_world(arg_23_5)

				WwiseWorld.trigger_event(var_23_0, "Stop_blessing_rally_flag_loop")
			end

			ScriptUnit.extension(arg_23_0, "buff_system"):remove_buff(arg_23_1)
		end
	end,
	remove_generic_aoe = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
		var_0_0.destroy_range_check(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	end,
	apply_generic_decal = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
		local var_25_0 = arg_25_1.template.decal_z_offset or 0
		local var_25_1 = Vector3.copy(POSITION_LOOKUP[arg_25_0])

		var_25_1.z = var_25_1.z + var_25_0

		local var_25_2 = arg_25_1.template.decal
		local var_25_3 = Managers.state.unit_spawner:spawn_local_unit(var_25_2, var_25_1)
		local var_25_4 = arg_25_1.template.decal_scale or 1

		Unit.set_local_scale(var_25_3, 0, Vector3(var_25_4, var_25_4, var_25_4))

		arg_25_1.linked_decal = var_25_3
	end,
	remove_generic_decal = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
		local var_26_0 = arg_26_1.linked_decal

		if var_26_0 then
			Managers.state.unit_spawner:mark_for_deletion(var_26_0)
		end
	end,
	apply_curse_khorne_champions_aoe = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		local var_27_0 = World.create_particles(arg_27_3, arg_27_1.template.particle_fx, POSITION_LOOKUP[arg_27_0])

		arg_27_1.fx_id = var_27_0

		World.link_particles(arg_27_3, var_27_0, arg_27_0, Unit.node(arg_27_0, "j_spine"), Matrix4x4.identity(), "stop")
		var_0_0.setup_range_check(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	end,
	update_curse_khorne_champions_aoe = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
		var_0_0.update_range_check(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	end,
	unit_entered_range_champions_aoe = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
		if not DamageUtils.is_enemy(arg_29_0, arg_29_1) then
			local var_29_0 = ScriptUnit.has_extension(arg_29_0, "buff_system")

			if var_29_0 then
				local var_29_1 = arg_29_2.template.in_range_units_buff_name

				return (var_29_0:add_buff(var_29_1))
			end
		end
	end,
	unit_left_range_champions_aoe = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
		if arg_30_1 and ALIVE[arg_30_0] then
			ScriptUnit.extension(arg_30_0, "buff_system"):remove_buff(arg_30_1)
		end
	end,
	remove_curse_khorne_champions_aoe = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
		World.stop_spawning_particles(arg_31_3, arg_31_1.fx_id)
		var_0_0.destroy_range_check(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	end,
	curse_khorne_champions_unit_link_unit = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
		local var_32_0 = arg_32_1.template
		local var_32_1 = var_32_0.unit_name
		local var_32_2 = Managers.state.unit_spawner:spawn_local_unit(var_32_1, POSITION_LOOKUP[arg_32_0])

		Managers.state.unit_spawner:create_unit_extensions(Unit.world(var_32_2), var_32_2, "prop_unit")
		World.link_unit(Unit.world(arg_32_0), var_32_2, 0, arg_32_0, Unit.node(arg_32_0, "root_point"))

		arg_32_1.linked_unit = var_32_2

		local var_32_3 = var_32_0.z_offset
		local var_32_4 = var_32_3[Unit.get_data(arg_32_0, "breed").name] or var_32_3.default

		Unit.set_local_position(var_32_2, 0, Vector3(0, 0, var_32_4))
	end,
	remove_linked_unit = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
		if arg_33_1.linked_unit then
			World.unlink_unit(Unit.world(arg_33_1.linked_unit), arg_33_1.linked_unit)
			Managers.state.unit_spawner:mark_for_deletion(arg_33_1.linked_unit)

			arg_33_1.linked_unit = nil
		end
	end,
	apply_curse_greed_pinata_drops = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
		local var_34_0 = ScriptUnit.extension(arg_34_0, "health_system")

		if var_34_0 then
			arg_34_1.health_extension = var_34_0

			local var_34_1 = var_34_0:get_max_health() / arg_34_1.template.total_drops
			local var_34_2 = arg_34_1.health_extension:get_damage_taken()

			arg_34_1.drop_step = var_34_1
			arg_34_1.drops_done = math.floor(var_34_2 / var_34_1)
		end
	end,
	update_curse_greed_pinata_drops = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
		local var_35_0 = arg_35_1.health_extension

		if var_35_0 then
			local var_35_1 = var_35_0:get_damage_taken()

			if arg_35_1.prev_damage ~= var_35_1 then
				local var_35_2 = math.floor(var_35_1 / arg_35_1.drop_step)

				while var_35_2 > arg_35_1.drops_done do
					local var_35_3 = var_35_0.last_damage_data.attacker_unit_id

					var_0_10(arg_35_1.template.drop_table, POSITION_LOOKUP[arg_35_0], var_35_3)

					arg_35_1.drops_done = arg_35_1.drops_done + 1
				end

				arg_35_1.prev_damage = var_35_1
			end
		end
	end,
	apply_attach_particle = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
		if not arg_36_1.fx_id then
			local var_36_0 = World.create_particles(arg_36_3, arg_36_1.template.particle_fx, POSITION_LOOKUP[arg_36_0])

			arg_36_1.fx_id = var_36_0

			local var_36_1 = arg_36_1.template
			local var_36_2 = Unit.node(arg_36_0, "j_spine")
			local var_36_3 = Unit.local_rotation(arg_36_0, var_36_2)
			local var_36_4 = Quaternion.from_euler_angles_xyz(var_36_1.offset_rotation_x or 0, var_36_1.offset_rotation_y or 0, var_36_1.offset_rotation_z or 0)
			local var_36_5 = Matrix4x4.from_quaternion(Quaternion.multiply(var_36_3, var_36_4))

			World.link_particles(arg_36_3, var_36_0, arg_36_0, Unit.node(arg_36_0, "j_spine"), var_36_5, "stop")
		end
	end,
	remove_attach_particle = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
		if arg_37_1.fx_id then
			World.stop_spawning_particles(arg_37_3, arg_37_1.fx_id)
		end
	end,
	apply_screenspace_fx = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
		if not var_0_3(arg_38_0) then
			return
		end

		if not arg_38_1.fx_id then
			arg_38_1.fx_id = World.create_particles(arg_38_3, arg_38_1.template.screenspace_fx, Vector3(0, 0, 0))
		end
	end,
	remove_screenspace_fx = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
		if arg_39_1.fx_id then
			World.stop_spawning_particles(arg_39_3, arg_39_1.fx_id)
		end
	end,
	start_bloodthirst = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
		function arg_40_1.reset_timer()
			arg_40_1.reset_at = arg_40_2.t + arg_40_1.template.reset_after_time
		end

		arg_40_1.reset_timer()

		arg_40_1.stacked_buffs = {}
	end,
	update_bloodthirst = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
		if arg_42_2.t >= arg_42_1.reset_at then
			arg_42_1.kill_count = 0

			arg_42_1.reset_timer()
			BuffUtils.remove_stacked_buffs(arg_42_0, arg_42_1.stacked_buffs)
		end
	end,
	remove_bloodthirst = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
		BuffUtils.remove_stacked_buffs(arg_43_0, arg_43_1.stacked_buffs)
	end,
	start_headhunter = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
		arg_44_1.stacked_buffs = {}
	end,
	remove_headhunter = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
		BuffUtils.remove_stacked_buffs(arg_45_0, arg_45_1.stacked_buffs)
	end,
	knockdown = function(arg_46_0, arg_46_1, arg_46_2)
		if var_0_6() then
			local var_46_0 = ScriptUnit.has_extension(arg_46_0, "health_system")

			if var_46_0 then
				var_46_0:knock_down(arg_46_0)
			end
		end
	end,
	reset_health = function(arg_47_0, arg_47_1, arg_47_2)
		if var_0_6() then
			local var_47_0 = ScriptUnit.has_extension(arg_47_0, "health_system")

			if var_47_0 then
				var_47_0:reset()
			end
		end
	end,
	apply_curse_rotten_miasma = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
		arg_48_1.next_update_time = 0
		arg_48_1.stacked_buff_ids = {}
		arg_48_1.is_outside_safe_area = {}

		local var_48_0 = Managers.state.difficulty:get_difficulty_index()

		arg_48_1.radius = table.get_value_or_last(arg_48_1.template.safe_area_radius, var_48_0)

		Unit.set_data(arg_48_0, "radius", arg_48_1.radius)
		Unit.flow_event(arg_48_0, "update_radius")
	end,
	update_curse_rotten_miasma = function(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
		if not var_0_6() then
			return
		end

		local var_49_0 = Unit.local_position(arg_49_0, 0)

		if arg_49_1.next_update_time > arg_49_2.t then
			return
		end

		local var_49_1 = arg_49_1.template

		arg_49_1.next_update_time = arg_49_2.t + var_49_1.buff_exposure_tick_rate

		local var_49_2 = Managers.state.entity:system("buff_system")
		local var_49_3 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS

		for iter_49_0, iter_49_1 in ipairs(var_49_3) do
			local var_49_4 = math.pow(arg_49_1.radius, 2)
			local var_49_5 = POSITION_LOOKUP[iter_49_1]
			local var_49_6 = var_49_4 < Vector3.distance_squared(var_49_0, var_49_5)
			local var_49_7 = not var_49_6
			local var_49_8 = arg_49_1.is_outside_safe_area[iter_49_1]
			local var_49_9 = var_49_6 and not var_49_8
			local var_49_10 = var_49_7 and var_49_8

			if var_49_9 then
				arg_49_1.is_outside_safe_area[iter_49_1] = true
			elseif var_49_10 then
				arg_49_1.is_outside_safe_area[iter_49_1] = false
			end

			arg_49_1.stacked_buff_ids[iter_49_1] = arg_49_1.stacked_buff_ids[iter_49_1] or {}

			local var_49_11 = arg_49_1.stacked_buff_ids[iter_49_1]

			if var_49_6 and #var_49_11 < var_49_1.miasma_stack_limit then
				local var_49_12 = true
				local var_49_13 = var_49_2:add_buff(iter_49_1, "curse_rotten_miasma_debuff", iter_49_1, var_49_12)

				var_49_11[#var_49_11 + 1] = var_49_13
			elseif var_49_7 and #var_49_11 > 0 then
				local var_49_14 = var_49_11[#var_49_11]

				var_49_2:remove_server_controlled_buff(iter_49_1, var_49_14)

				var_49_11[#var_49_11] = nil

				if #var_49_11 == 0 then
					local var_49_15 = ScriptUnit.extension_input(iter_49_1, "dialogue_system")
					local var_49_16 = FrameTable.alloc_table()

					var_49_15:trigger_networked_dialogue_event("curse_positive_effect_happened", var_49_16)
				end
			end
		end
	end,
	remove_curse_rotten_miasma = function(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
		local var_50_0 = Managers.player:local_player()
		local var_50_1 = var_50_0 and var_50_0.player_unit

		if not var_50_1 then
			return
		end

		local var_50_2 = ScriptUnit.extension(var_50_1, "buff_system")

		if arg_50_1.stacked_buff_ids then
			for iter_50_0, iter_50_1 in ipairs(arg_50_1.stacked_buff_ids) do
				var_50_2:remove_buff(iter_50_1)
			end

			table.clear(arg_50_1.stacked_buff_ids)
		end

		if arg_50_1.effect_buff_id then
			var_50_2:remove_buff(arg_50_1.effect_buff_id)

			arg_50_1.effect_buff_id = nil
		end
	end,
	apply_curse_rotten_miasma_debuff = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
		if Managers.player:local_player().player_unit == arg_51_0 then
			local var_51_0 = Managers.world:wwise_world(arg_51_3)

			WwiseWorld.trigger_event(var_51_0, "Play_curse_rotten_miasma_loop")

			arg_51_1.buff_triggered_sound = true
		end
	end,
	remove_curse_rotten_miasma_debuff = function(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
		if arg_52_1.buff_triggered_sound then
			local var_52_0 = Managers.world:wwise_world(arg_52_3)

			WwiseWorld.trigger_event(var_52_0, "Stop_curse_rotten_miasma_loop")
		end
	end,
	apply_objective_unit = function(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
		local var_53_0 = "units/hub_elements/objective_unit"
		local var_53_1 = Managers.state.unit_spawner:spawn_local_unit(var_53_0, POSITION_LOOKUP[arg_53_0])

		Unit.set_data(var_53_1, "objective_server_only", true)
		Managers.state.unit_spawner:create_unit_extensions(Unit.world(var_53_1), var_53_1, "objective_unit")
		ScriptUnit.extension(var_53_1, "tutorial_system"):set_active(true)
		World.link_unit(Unit.world(arg_53_0), var_53_1, 0, arg_53_0, 0)

		arg_53_1.objective_unit = var_53_1
	end,
	remove_objective_unit = function(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
		if arg_54_1.objective_unit then
			World.unlink_unit(Unit.world(arg_54_1.objective_unit), arg_54_1.objective_unit)
			Managers.state.unit_spawner:mark_for_deletion(arg_54_1.objective_unit)

			arg_54_1.objective_unit = nil
		end
	end,
	curse_abundance_of_life_custom_dot_tick = function(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
		local var_55_0 = ScriptUnit.extension(arg_55_0, "health_system"):current_health()
		local var_55_1 = var_55_0 * arg_55_1.template.damage_percentage

		if var_55_0 > 30 then
			local var_55_2 = -Vector3.up()

			DamageUtils.add_damage_network(arg_55_0, arg_55_0, var_55_1, "torso", "wounded_dot", nil, var_55_2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	apply_killer_in_the_shadows_buff = function(arg_56_0, arg_56_1, arg_56_2)
		if var_0_3(arg_56_0) then
			local var_56_0 = ScriptUnit.extension(arg_56_0, "status_system")

			var_56_0:set_invisible(true, nil, "killer_in_the_shadows")
			var_56_0:set_noclip(true, "killer_in_the_shadows")

			if not var_0_4(arg_56_0) then
				ScriptUnit.extension(arg_56_0, "first_person_system"):play_hud_sound_event("Play_career_ability_kerillian_shade_enter_small")
				Managers.state.camera:set_mood("killer_in_the_shadows", "buff", true)
			end
		end
	end,
	remove_killer_in_the_shadows_buff = function(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
		if var_0_3(arg_57_0) then
			local var_57_0 = ScriptUnit.extension(arg_57_0, "status_system")
			local var_57_1 = var_57_0:set_invisible(false, nil, "killer_in_the_shadows")

			var_57_0:set_noclip(false, "killer_in_the_shadows")

			if not var_0_4(arg_57_0) then
				if var_57_1 then
					ScriptUnit.extension(arg_57_0, "first_person_system"):play_hud_sound_event("Play_career_ability_kerillian_shade_exit")
				end

				Managers.state.camera:set_mood("killer_in_the_shadows", "buff", false)
				var_0_11(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
			end
		end
	end,
	apply_pockets_full_of_bombs_buff = function(arg_58_0, arg_58_1, arg_58_2)
		local var_58_0 = ScriptUnit.extension(arg_58_0, "inventory_system")
		local var_58_1 = var_58_0:get_wielded_slot_name()
		local var_58_2 = var_58_0:get_slot_data(var_58_1)

		if var_58_1 == "slot_level_event" and var_58_2 then
			var_58_0:drop_level_event_item(var_58_2)
		end

		local var_58_3 = AllPickups.frag_grenade_t1.slot_name

		if var_58_1 ~= var_58_3 then
			local var_58_4 = ScriptUnit.extension(arg_58_0, "career_system")

			CharacterStateHelper.stop_weapon_actions(var_58_0, "picked_up_object")
			CharacterStateHelper.stop_career_abilities(var_58_4, "picked_up_object")
			var_58_0:wield(var_58_3)
		end
	end,
	update_pockets_full_of_bombs_buff = function(arg_59_0, arg_59_1, arg_59_2)
		if var_0_3(arg_59_0) then
			local var_59_0 = Managers.state.network.network_transmit
			local var_59_1 = ScriptUnit.extension(arg_59_0, "inventory_system")
			local var_59_2 = ScriptUnit.extension(arg_59_0, "career_system")
			local var_59_3 = AllPickups.frag_grenade_t1
			local var_59_4 = var_59_3.slot_name
			local var_59_5 = var_59_3.item_name

			if not var_59_1:get_slot_data(var_59_4) then
				local var_59_6 = {}
				local var_59_7 = ItemMasterList[var_59_5]

				var_59_1:add_equipment(var_59_4, var_59_7, nil, var_59_6)

				local var_59_8 = Managers.state.unit_storage:go_id(arg_59_0)
				local var_59_9 = NetworkLookup.equipment_slots[var_59_4]
				local var_59_10 = NetworkLookup.item_names[var_59_5]
				local var_59_11 = NetworkLookup.weapon_skins["n/a"]

				if var_59_8 then
					if var_0_6() then
						var_59_0:send_rpc_clients("rpc_add_equipment", var_59_8, var_59_9, var_59_10, var_59_11)
					else
						var_59_0:send_rpc_server("rpc_add_equipment", var_59_8, var_59_9, var_59_10, var_59_11)
					end
				end

				if var_59_1:get_wielded_slot_name() ~= var_59_4 then
					CharacterStateHelper.stop_weapon_actions(var_59_1, "picked_up_object")
					CharacterStateHelper.stop_career_abilities(var_59_2, "picked_up_object")
					var_59_1:wield(var_59_4)
				end
			end
		end
	end,
	trigger_sound_event = function(arg_60_0, arg_60_1, arg_60_2, arg_60_3)
		local var_60_0 = Managers.world:wwise_world(arg_60_3)

		WwiseWorld.trigger_event(var_60_0, arg_60_1.template.sound_event_name)
	end,
	trigger_skulls_of_fury_sound_event = function(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
		WwiseUtils.trigger_unit_event(arg_61_3, arg_61_1.template.sound_event_name, arg_61_0, 0)
	end,
	apply_health_bar = function(arg_62_0, arg_62_1, arg_62_2, arg_62_3)
		Managers.state.event:trigger("tutorial_event_show_health_bar", arg_62_0, true)

		arg_62_1.unit = arg_62_0
	end,
	remove_health_bar = function(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
		Managers.state.event:trigger("tutorial_event_remove_health_bar", arg_63_0)
	end,
	remove_deus_rally_flag = function(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
		if var_0_6() then
			Managers.state.unit_spawner:mark_for_deletion(arg_64_0)
		end
	end,
	apply_make_pingable = function(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
		if not ScriptUnit.has_extension(arg_65_0, "ping_system") then
			local var_65_0 = Managers.state.entity:system("ping_system"):on_add_extension(arg_65_3, arg_65_0, "PingTargetExtension", {})

			var_65_0:extensions_ready(arg_65_3, arg_65_0)

			arg_65_1.ping_target_extension = var_65_0
		end
	end,
	remove_make_pingable = function(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
		if arg_66_1.ping_target_extension then
			local var_66_0 = Managers.state.entity:system("ping_system")

			var_66_0:remove_ping_from_unit(arg_66_0)
			ScriptUnit.destroy_extension(arg_66_0, "ping_system")
			var_66_0:on_remove_extension(arg_66_0, "PingTargetExtension")

			arg_66_1.ping_target_extension = nil
		end
	end,
	remove_deus_potion_buff = function(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
		var_0_11(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	end,
	update_attack_speed_per_cooldown = function(arg_68_0, arg_68_1, arg_68_2)
		local var_68_0 = Managers.player:local_player()

		if not (var_68_0 and var_68_0.player_unit) then
			return
		end

		local var_68_1 = arg_68_1.template
		local var_68_2 = var_68_1.stat_buff
		local var_68_3 = arg_68_1.previous_multiplier or 0
		local var_68_4 = ScriptUnit.extension(arg_68_0, "career_system"):current_ability_cooldown_percentage() * var_68_1.value

		arg_68_1.previous_multiplier = arg_68_1.multiplier or 0
		arg_68_1.multiplier = var_68_4

		local var_68_5 = ScriptUnit.extension(arg_68_0, "buff_system")
		local var_68_6 = var_68_4 - var_68_3

		if var_68_6 ~= 0 then
			var_68_5:update_stat_buff(var_68_2, var_68_6, arg_68_1.stat_buff_index)
		end
	end,
	force_use_active_ability = function(arg_69_0, arg_69_1, arg_69_2)
		local var_69_0 = Managers.player:local_player()

		if not (var_69_0 and var_69_0.player_unit) then
			return
		end

		local var_69_1 = ScriptUnit.extension(arg_69_0, "career_system")

		if var_69_1:can_use_activated_ability() then
			var_69_1:force_trigger_active_ability()
		end
	end,
	apply_active_ability_for_coins = function(arg_70_0, arg_70_1, arg_70_2)
		local var_70_0 = ScriptUnit.extension(arg_70_0, "career_system")

		if var_70_0 then
			var_70_0:set_abilities_always_usable(true, "active_ability_for_coins")
		end
	end,
	remove_active_ability_for_coins = function(arg_71_0, arg_71_1, arg_71_2)
		local var_71_0 = ScriptUnit.extension(arg_71_0, "career_system")

		if var_71_0 then
			var_71_0:set_abilities_always_usable(false, "active_ability_for_coins")
		end
	end,
	apply_max_health_buff_for_ai = function(arg_72_0, arg_72_1, arg_72_2)
		if var_0_6() then
			local var_72_0 = ScriptUnit.has_extension(arg_72_0, "health_system")

			if var_72_0 then
				local var_72_1 = var_72_0.unmodified_max_health * arg_72_1.multiplier

				arg_72_1.added_health = var_72_1

				local var_72_2 = var_72_0:get_max_health()

				var_72_0:set_max_health(var_72_2 + var_72_1)
			end
		end
	end,
	remove_max_health_buff_for_ai = function(arg_73_0, arg_73_1, arg_73_2)
		if var_0_6() then
			local var_73_0 = ScriptUnit.has_extension(arg_73_0, "health_system")

			if var_73_0 then
				local var_73_1 = var_73_0:get_max_health()

				if var_73_1 > arg_73_1.added_health then
					var_73_0:set_max_health(var_73_1 - arg_73_1.added_health)
				end
			end
		end
	end,
	deus_knockdown_damage_immunity_aura_func = function(arg_74_0, arg_74_1, arg_74_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_74_0 = arg_74_1.template
		local var_74_1 = arg_74_1.range
		local var_74_2 = var_74_1 * var_74_1
		local var_74_3 = POSITION_LOOKUP[arg_74_0]
		local var_74_4 = Managers.state.side.side_by_unit[arg_74_0].PLAYER_AND_BOT_UNITS
		local var_74_5 = #var_74_4
		local var_74_6 = var_74_0.buff_to_add
		local var_74_7 = Managers.state.entity:system("buff_system")
		local var_74_8 = ScriptUnit.extension(arg_74_0, "status_system"):is_ready_for_assisted_respawn()

		for iter_74_0 = 1, var_74_5 do
			local var_74_9 = var_74_4[iter_74_0]

			if Unit.alive(var_74_9) and var_74_9 ~= arg_74_0 then
				local var_74_10 = ScriptUnit.extension(var_74_9, "status_system")
				local var_74_11 = POSITION_LOOKUP[var_74_9]
				local var_74_12 = Vector3.distance_squared(var_74_3, var_74_11)
				local var_74_13 = ScriptUnit.extension(var_74_9, "buff_system")
				local var_74_14 = var_74_10:is_knocked_down()

				if var_74_2 < var_74_12 or not var_74_14 or var_74_8 then
					local var_74_15 = var_74_13:get_non_stacking_buff(var_74_6)

					if var_74_15 then
						local var_74_16 = var_74_15.server_id

						if var_74_16 then
							var_74_7:remove_server_controlled_buff(var_74_9, var_74_16)
						end
					end
				end

				if var_74_12 < var_74_2 and var_74_14 and not var_74_8 and not var_74_13:has_buff_type(var_74_6) then
					local var_74_17 = var_74_7:add_buff(var_74_9, var_74_6, arg_74_0, true)
					local var_74_18 = var_74_13:get_non_stacking_buff(var_74_6)

					if var_74_18 then
						var_74_18.server_id = var_74_17
					end
				end
			end
		end
	end,
	on_extra_shot_buff_apply = function(arg_75_0, arg_75_1, arg_75_2, arg_75_3)
		if var_0_5(arg_75_0) then
			WwiseUtils.trigger_unit_event(arg_75_3, "hud_gameplay_stance_linesman_buff", arg_75_0, 0)
		end
	end,
	on_extra_shot_buff_remove = function(arg_76_0, arg_76_1, arg_76_2, arg_76_3)
		if var_0_5(arg_76_0) then
			WwiseUtils.trigger_unit_event(arg_76_3, "Play_potion_morris_effect_end", arg_76_0, 0)
		end
	end,
	apply_second_wind = function(arg_77_0, arg_77_1, arg_77_2, arg_77_3)
		if var_0_5(arg_77_0) then
			WwiseUtils.trigger_unit_event(arg_77_3, "Play_magic_shield_activate", arg_77_0, 0)
		end
	end,
	remove_second_wind = function(arg_78_0, arg_78_1, arg_78_2, arg_78_3)
		if var_0_5(arg_78_0) then
			WwiseUtils.trigger_unit_event(arg_78_3, "Play_potion_morris_effect_end", arg_78_0, 0)
		end
	end,
	apply_active_ability_movement_buff = function(arg_79_0, arg_79_1, arg_79_2, arg_79_3)
		BuffFunctionTemplates.functions.apply_movement_buff(arg_79_0, arg_79_1, arg_79_2, arg_79_3)

		if var_0_5(arg_79_0) then
			WwiseUtils.trigger_unit_event(arg_79_3, "hud_gameplay_stance_ninjafencer_buff", arg_79_0, 0)
		end
	end,
	remove_active_ability_movement_buff = function(arg_80_0, arg_80_1, arg_80_2, arg_80_3)
		BuffFunctionTemplates.functions.remove_movement_buff(arg_80_0, arg_80_1, arg_80_2, arg_80_3)

		if var_0_5(arg_80_0) then
			WwiseUtils.trigger_unit_event(arg_80_3, "Play_potion_morris_effect_end", arg_80_0, 0)
		end
	end,
	apply_ammo_reload_speed_buff = function(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
		if var_0_5(arg_81_0) then
			WwiseUtils.trigger_unit_event(arg_81_3, "hud_gameplay_stance_linesman_buff", arg_81_0, 0)
		end
	end,
	remove_ammo_reload_speed_buff = function(arg_82_0, arg_82_1, arg_82_2, arg_82_3)
		if var_0_5(arg_82_0) then
			WwiseUtils.trigger_unit_event(arg_82_3, "Play_potion_morris_effect_end", arg_82_0, 0)
		end
	end,
	apply_damage_reduction_on_incapacitated = function(arg_83_0, arg_83_1, arg_83_2, arg_83_3)
		if var_0_5(arg_83_0) then
			WwiseUtils.trigger_unit_event(arg_83_3, "Play_magic_shield_activate", arg_83_0, 0)
		end
	end,
	remove_damage_reduction_on_incapacitated = function(arg_84_0, arg_84_1, arg_84_2, arg_84_3)
		if var_0_5(arg_84_0) then
			WwiseUtils.trigger_unit_event(arg_84_3, "Play_potion_morris_effect_end", arg_84_0, 0)
		end
	end,
	apply_parry_damage_immune = function(arg_85_0, arg_85_1, arg_85_2, arg_85_3)
		if var_0_5(arg_85_0) then
			WwiseUtils.trigger_unit_event(arg_85_3, "magic_shield_activate_fast", arg_85_0, 0)
		end
	end,
	apply_always_blocking = function(arg_86_0, arg_86_1, arg_86_2)
		local var_86_0 = ScriptUnit.extension(arg_86_0, "status_system")
		local var_86_1 = not var_0_6()

		var_86_0:set_override_blocking(true, var_86_1)
	end,
	remove_always_blocking = function(arg_87_0, arg_87_1, arg_87_2)
		local var_87_0 = ScriptUnit.extension(arg_87_0, "status_system")
		local var_87_1 = not var_0_6()

		var_87_0:set_override_blocking(nil, var_87_1)
	end,
	deus_standing_still_damage_reduction_update = function(arg_88_0, arg_88_1, arg_88_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_88_0] then
			local var_88_0 = ScriptUnit.has_extension(arg_88_0, "locomotion_system")

			if not var_88_0 then
				return
			end

			local var_88_1 = Managers.state.entity:system("buff_system")
			local var_88_2 = arg_88_1.template.buff_to_add
			local var_88_3 = var_88_0:current_velocity()
			local var_88_4 = Vector3.length(var_88_3)

			if var_88_4 < 0.5 and not arg_88_1.added_buff then
				arg_88_1.added_buff = var_88_1:add_buff(arg_88_0, var_88_2, arg_88_0, true)
			elseif var_88_4 > 0.5 and arg_88_1.added_buff then
				var_88_1:remove_server_controlled_buff(arg_88_0, arg_88_1.added_buff)

				arg_88_1.added_buff = nil
			end
		end
	end,
	melee_killing_spree_speed_counter_update = function(arg_89_0, arg_89_1, arg_89_2)
		if arg_89_1.kills and arg_89_1.kills[1] and arg_89_1.kills[1] < arg_89_2.t then
			table.remove(arg_89_1.kills, 1)
		end
	end,
	deus_cooldown_reg_not_hit_init = function(arg_90_0, arg_90_1, arg_90_2)
		if not Managers.state.network.is_server then
			return
		end

		arg_90_1.buffs = {}
		arg_90_1.next_buff_t = Managers.time:time("game") + arg_90_1.template.interval
	end,
	deus_cooldown_reg_not_hit_update = function(arg_91_0, arg_91_1, arg_91_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_91_0 = Managers.time:time("game")
		local var_91_1 = arg_91_1.template

		if arg_91_1.reset then
			arg_91_1.next_buff_t = var_91_0 + var_91_1.interval

			local var_91_2 = Managers.state.entity:system("buff_system")

			for iter_91_0 = 1, #arg_91_1.buffs do
				local var_91_3 = arg_91_1.buffs[iter_91_0]

				var_91_2:remove_server_controlled_buff(arg_91_0, var_91_3)
			end

			arg_91_1.reset = false

			table.clear(arg_91_1.buffs)
		end

		if var_91_0 > arg_91_1.next_buff_t and #arg_91_1.buffs < 5 then
			arg_91_1.next_buff_t = var_91_0 + var_91_1.interval

			local var_91_4 = Managers.state.entity:system("buff_system")
			local var_91_5 = var_91_1.buff_to_add
			local var_91_6 = var_91_4:add_buff(arg_91_0, var_91_5, arg_91_0, true)

			arg_91_1.buffs[#arg_91_1.buffs + 1] = var_91_6
		end
	end,
	update_ledge_rescue = function(arg_92_0, arg_92_1, arg_92_2)
		local var_92_0 = Managers.time:time("main")

		if arg_92_1.rescue_timer and var_92_0 > arg_92_1.rescue_timer then
			arg_92_1.rescue_timer = nil

			local var_92_1 = arg_92_1.template.pull_up_duration

			arg_92_1.finish_pull_up_timer = var_92_0 + var_92_1

			local var_92_2 = Unit.animation_find_variable(arg_92_0, "revive_time")

			Unit.animation_set_variable(arg_92_0, var_92_2, var_92_1)
			Unit.animation_event(arg_92_0, "revive_start")

			if ScriptUnit.has_extension(arg_92_0, "first_person_system") then
				ScriptUnit.extension(arg_92_0, "first_person_system"):set_wanted_player_height("stand", var_92_0, var_92_1)
			end
		end

		if arg_92_1.finish_pull_up_timer and var_92_0 > arg_92_1.finish_pull_up_timer then
			arg_92_1.finish_pull_up_timer = nil

			StatusUtils.set_pulled_up_network(arg_92_0, true, arg_92_0)
			Unit.animation_event(arg_92_0, "revive_complete")
		end
	end,
	update_disable_rescue = function(arg_93_0, arg_93_1, arg_93_2)
		local var_93_0 = Managers.time:time("main")

		if arg_93_1.rescue_timer and var_93_0 > arg_93_1.rescue_timer then
			arg_93_1.rescue_timer = nil

			if not var_0_6() then
				return
			end

			if not ALIVE[arg_93_0] then
				return
			end

			local var_93_1 = arg_93_1.template
			local var_93_2 = Application.main_world()
			local var_93_3 = POSITION_LOOKUP[arg_93_0]
			local var_93_4 = Quaternion.identity()
			local var_93_5 = ExplosionUtils.get_template(var_93_1.explosion_template)
			local var_93_6 = ScriptUnit.has_extension(arg_93_0, "career_system"):get_career_power_level()

			DamageUtils.create_explosion(var_93_2, arg_93_0, var_93_3, var_93_4, var_93_5, 1, "buff", true, var_0_7(arg_93_0), arg_93_0, var_93_6, false)
		end
	end,
	always_blocking_init = function(arg_94_0, arg_94_1, arg_94_2)
		local var_94_0 = ScriptUnit.extension(arg_94_0, "inventory_system"):equipment()
		local var_94_1 = var_94_0.wielded and var_94_0.wielded.slot_type == "melee"
		local var_94_2 = arg_94_1.template.buff_to_add
		local var_94_3 = ScriptUnit.extension(arg_94_0, "buff_system")

		if var_94_1 then
			arg_94_1.buff_id = var_94_3:add_buff(var_94_2)
		end
	end,
	always_blocking_update = function(arg_95_0, arg_95_1, arg_95_2)
		local var_95_0 = ScriptUnit.extension(arg_95_0, "buff_system")
		local var_95_1 = var_95_0 and var_95_0:has_buff_type("deus_always_blocking_lock_out")

		if arg_95_1.locked_out and not var_95_1 then
			local var_95_2 = ScriptUnit.extension(arg_95_0, "inventory_system"):equipment()
			local var_95_3 = var_95_2.wielded and var_95_2.wielded.slot_type == "melee"
			local var_95_4 = arg_95_1.template.buff_to_add

			if var_95_3 then
				arg_95_1.buff_id = var_95_0:add_buff(var_95_4)
			end

			arg_95_1.locked_out = nil
		elseif not arg_95_1.locked_out and var_95_1 then
			local var_95_5 = arg_95_1.template.buff_to_add

			if var_95_0 and var_95_0:has_buff_type(var_95_5) then
				var_95_0:remove_buff(arg_95_1.buff_id)
			end

			arg_95_1.locked_out = true
		end

		if not arg_95_1.locked_out and arg_95_1.swapped_weapons then
			local var_95_6 = arg_95_1.equipment
			local var_95_7 = var_95_6.wielded and var_95_6.wielded.slot_type == "melee"
			local var_95_8 = arg_95_1.template.buff_to_add
			local var_95_9 = var_95_0 and var_95_0:has_buff_type(var_95_8)

			if var_95_7 then
				if not var_95_9 then
					arg_95_1.buff_id = var_95_0:add_buff(var_95_8)
				end
			elseif var_95_9 then
				var_95_0:remove_buff(arg_95_1.buff_id)
			end

			arg_95_1.swapped_weapons = nil
		end
	end,
	apply_cursed_chest_init = function(arg_96_0, arg_96_1, arg_96_2)
		local var_96_0 = Unit.get_data(arg_96_0, "breed").boss and "fx/cursed_chest_spawn_02" or "fx/cursed_chest_spawn_01"
		local var_96_1 = Application.main_world()
		local var_96_2 = POSITION_LOOKUP[arg_96_0]

		World.create_particles(var_96_1, var_96_0, var_96_2)
	end,
	money_magnet_start = function(arg_97_0, arg_97_1, arg_97_2)
		if not var_0_3(arg_97_0) then
			return
		end

		arg_97_1.pickup_system = Managers.state.entity:system("pickup_system")
		arg_97_1.query_results = {}
		arg_97_1.interactor_extension = ScriptUnit.extension(arg_97_0, "interactor_system")
		arg_97_1.last_t = 0
	end,
	money_magnet_update = function(arg_98_0, arg_98_1, arg_98_2)
		if not var_0_3(arg_98_0) then
			return
		end

		local var_98_0 = Managers.time:time("game")
		local var_98_1 = arg_98_1.last_t
		local var_98_2 = arg_98_1.template.update_every
		local var_98_3 = arg_98_1.interactor_extension

		if var_98_3:is_interacting() then
			return
		end

		if var_98_2 < var_98_0 - var_98_1 then
			arg_98_1.last_t = var_98_0

			local var_98_4 = arg_98_1.pickup_system
			local var_98_5 = POSITION_LOOKUP[arg_98_0]
			local var_98_6 = arg_98_1.template.magnet_distance
			local var_98_7 = arg_98_1.query_results

			table.clear(var_98_7)

			local var_98_8 = var_98_4:get_pickups(var_98_5, var_98_6, var_98_7)

			for iter_98_0 = 1, var_98_8 do
				local var_98_9 = var_98_7[iter_98_0]
				local var_98_10 = ScriptUnit.has_extension(var_98_9, "pickup_system")

				if var_98_10 and var_98_10.pickup_name == "deus_soft_currency" then
					local var_98_11 = true

					var_98_3:start_interaction(false, var_98_9, "pickup_object", var_98_11)

					return
				end
			end
		end
	end,
	detect_weakness_unit_entered_range = function(arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4)
		if not var_0_3(arg_99_1) then
			return
		end

		if arg_99_2.marked_enemy and HEALTH_ALIVE[arg_99_2.marked_enemy] then
			return
		end

		if arg_99_2.marked_enemy then
			arg_99_2.marked_enemy = nil
		end

		local var_99_0 = Unit.get_data(arg_99_0, "breed").name
		local var_99_1 = arg_99_2.template.markable_enemies
		local var_99_2 = Managers.time:time("main")
		local var_99_3 = var_99_2 >= (arg_99_2.next_enemy_markable_at or 0)

		if var_99_1[var_99_0] and var_99_3 then
			local var_99_4 = ScriptUnit.extension(arg_99_0, "buff_system")
			local var_99_5 = arg_99_2.template.mark_buff

			arg_99_2.marked_enemy_buff_id = var_99_4:add_buff(var_99_5)
			arg_99_2.marked_enemy = arg_99_0
			arg_99_2.next_enemy_markable_at = var_99_2 + arg_99_2.template.mark_cooldown
		end
	end,
	detect_weakness_unit_left_range = function(arg_100_0, arg_100_1, arg_100_2, arg_100_3, arg_100_4, arg_100_5)
		if not var_0_3(arg_100_2) then
			return
		end

		local var_100_0 = arg_100_3.marked_enemy

		if var_100_0 == arg_100_0 and HEALTH_ALIVE[var_100_0] then
			local var_100_1 = ScriptUnit.extension(arg_100_0, "buff_system")
			local var_100_2 = arg_100_3.marked_enemy_buff_id

			var_100_1:remove_buff(var_100_2)
		end
	end,
	pyrotechnical_echo_update = function(arg_101_0, arg_101_1, arg_101_2)
		local var_101_0 = arg_101_1.queued_explosions

		if var_101_0 then
			local var_101_1 = Managers.time:time("main")

			for iter_101_0 = 1, #var_101_0 do
				local var_101_2 = var_101_0[iter_101_0]

				if var_101_1 > var_101_2.new_explosion_time then
					local var_101_3 = Managers.world:world("level_world")
					local var_101_4 = var_101_2.impact_data
					local var_101_5 = var_101_2.hit_position:unbox()
					local var_101_6 = var_101_2.is_critical_strike
					local var_101_7 = var_101_2.item_name
					local var_101_8 = var_101_2.rotation:unbox()
					local var_101_9 = var_101_2.scale
					local var_101_10 = var_101_2.power_level
					local var_101_11 = arg_101_0
					local var_101_12 = var_101_4.aoe

					DamageUtils.create_explosion(var_101_3, var_101_11, var_101_5, var_101_8, var_101_12, var_101_9, var_101_7, var_0_6(), var_0_7(var_101_11), var_101_11, var_101_10, var_101_6, var_101_11)
					table.swap_delete(var_101_0, iter_101_0)

					return
				end
			end
		end
	end,
	blazing_revenge_clear_aoe = function(arg_102_0, arg_102_1, arg_102_2)
		if not var_0_6() then
			return
		end

		local var_102_0 = arg_102_1.template.sound_end_event

		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_102_0, arg_102_0)

		local var_102_1 = arg_102_1.parent_buff_shared_table.aoe_unit

		if var_102_1 and Unit.alive(var_102_1) then
			Managers.state.unit_spawner:mark_for_deletion(var_102_1)
		end
	end,
	wolfpack_apply = function(arg_103_0, arg_103_1, arg_103_2, arg_103_3)
		if not var_0_6() then
			return
		end

		local var_103_0 = arg_103_1.template.buff_to_add
		local var_103_1 = Managers.state.entity:system("buff_system")
		local var_103_2 = true

		var_103_1:add_buff(arg_103_0, var_103_0, arg_103_0, var_103_2)

		arg_103_1.units_in_range = {}

		var_0_0.setup_range_check(arg_103_0, arg_103_1, arg_103_2, arg_103_3)
	end,
	wolfpack_update = function(arg_104_0, arg_104_1, arg_104_2, arg_104_3)
		if not var_0_6() then
			return
		end

		if var_0_0.update_range_check(arg_104_0, arg_104_1, arg_104_2, arg_104_3) then
			local var_104_0 = arg_104_1.units_in_range
			local var_104_1 = arg_104_1.template.buff_to_add
			local var_104_2 = Managers.state.entity:system("buff_system")

			for iter_104_0, iter_104_1 in pairs(var_104_0) do
				local var_104_3 = ScriptUnit.has_extension(iter_104_0, "buff_system")
				local var_104_4 = var_104_3 and var_104_3:has_buff_type(var_104_1)

				if iter_104_1 == -1 then
					if var_104_4 then
						local var_104_5 = true

						var_104_0[iter_104_0] = var_104_2:add_buff(arg_104_0, var_104_1, arg_104_0, var_104_5)
					end
				elseif not var_104_4 then
					var_104_2:remove_server_controlled_buff(arg_104_0, iter_104_1)

					var_104_0[iter_104_0] = -1
				end
			end
		end
	end,
	wolfpack_remove = function(arg_105_0, arg_105_1, arg_105_2, arg_105_3)
		if not var_0_6() then
			return
		end

		var_0_0.destroy_range_check(arg_105_0, arg_105_1, arg_105_2, arg_105_3)

		local var_105_0 = arg_105_1.units_in_range
		local var_105_1 = Managers.state.entity:system("buff_system")

		for iter_105_0, iter_105_1 in pairs(var_105_0) do
			if iter_105_1 ~= -1 then
				var_105_1:remove_server_controlled_buff(arg_105_0, iter_105_1)

				var_105_0[iter_105_0] = -1
			end
		end
	end,
	wolfpack_entered_range = function(arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4)
		if not var_0_6() then
			return
		end

		if arg_106_0 == arg_106_1 then
			return
		end

		local var_106_0 = arg_106_2.units_in_range

		if not var_106_0[arg_106_0] then
			var_106_0[arg_106_0] = -1
		end
	end,
	wolfpack_left_range = function(arg_107_0, arg_107_1, arg_107_2, arg_107_3, arg_107_4, arg_107_5)
		if not var_0_6() then
			return
		end

		if arg_107_0 == arg_107_2 then
			return
		end

		local var_107_0 = Managers.state.entity:system("buff_system")
		local var_107_1 = arg_107_3.units_in_range[arg_107_0]

		if var_107_1 and var_107_1 ~= -1 then
			var_107_0:remove_server_controlled_buff(arg_107_2, var_107_1)
		end

		arg_107_3.units_in_range[arg_107_0] = nil
	end,
	comradery_apply = function(arg_108_0, arg_108_1, arg_108_2, arg_108_3)
		if not var_0_6() then
			return
		end

		local var_108_0 = arg_108_1.template.buff_to_add
		local var_108_1 = Managers.state.entity:system("buff_system")
		local var_108_2 = true

		var_108_1:add_buff(arg_108_0, var_108_0, arg_108_0, var_108_2)

		arg_108_1.units_in_range = {}

		var_0_0.setup_range_check(arg_108_0, arg_108_1, arg_108_2, arg_108_3)
	end,
	comradery_update = function(arg_109_0, arg_109_1, arg_109_2, arg_109_3)
		if not var_0_6() then
			return
		end

		var_0_0.update_range_check(arg_109_0, arg_109_1, arg_109_2, arg_109_3)
	end,
	comradery_remove = function(arg_110_0, arg_110_1, arg_110_2, arg_110_3)
		if not var_0_6() then
			return
		end

		var_0_0.destroy_range_check(arg_110_0, arg_110_1, arg_110_2, arg_110_3)

		local var_110_0 = arg_110_1.units_in_range
		local var_110_1 = Managers.state.entity:system("buff_system")

		for iter_110_0, iter_110_1 in pairs(var_110_0) do
			var_110_1:remove_server_controlled_buff(arg_110_0, iter_110_1)
		end
	end,
	comradery_entered_range = function(arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4)
		if not var_0_6() then
			return
		end

		if arg_111_0 == arg_111_1 then
			return
		end

		local var_111_0 = arg_111_2.units_in_range

		if not var_111_0[arg_111_0] then
			local var_111_1 = arg_111_2.template.buff_to_add
			local var_111_2 = Managers.state.entity:system("buff_system")
			local var_111_3 = true

			var_111_0[arg_111_0] = var_111_2:add_buff(arg_111_1, var_111_1, arg_111_1, var_111_3)
		end
	end,
	comradery_left_range = function(arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4, arg_112_5)
		if not var_0_6() then
			return
		end

		if arg_112_0 == arg_112_2 then
			return
		end

		local var_112_0 = Managers.state.entity:system("buff_system")
		local var_112_1 = arg_112_3.units_in_range
		local var_112_2 = var_112_1[arg_112_0]

		if var_112_2 then
			var_112_0:remove_server_controlled_buff(arg_112_2, var_112_2)
		end

		var_112_1[arg_112_0] = nil
	end,
	tenacious_update = function(arg_113_0, arg_113_1, arg_113_2, arg_113_3)
		if not var_0_6() then
			return
		end

		if not arg_113_1.health_extension then
			arg_113_1.health_extension = ScriptUnit.has_extension(arg_113_0, "health_system")
		end

		local var_113_0 = arg_113_1.health_extension
		local var_113_1 = arg_113_1.template

		if var_113_1.health_threshold <= var_113_0:current_health_percent() then
			arg_113_1.next_update = nil

			return
		end

		local var_113_2 = Managers.time:time("main")

		if not arg_113_1.next_update or var_113_2 > arg_113_1.next_update then
			local var_113_3 = var_113_1.health_per_tick

			DamageUtils.heal_network(arg_113_0, arg_113_0, var_113_3, "health_regen")

			arg_113_1.next_update = var_113_2 + var_113_1.tick
		end
	end,
	hidden_escape_apply = function(arg_114_0, arg_114_1, arg_114_2, arg_114_3)
		if var_0_3(arg_114_0) then
			local var_114_0 = ScriptUnit.extension(arg_114_0, "status_system")

			var_114_0:set_invisible(true, nil, "hidden_escape")
			var_114_0:set_noclip(true, "hidden_escape")

			if not var_0_4(arg_114_0) then
				ScriptUnit.extension(arg_114_0, "first_person_system"):play_hud_sound_event("Play_career_ability_kerillian_shade_enter_small")
				Managers.state.camera:set_mood("hidden_escape", "buff", true)
			end
		end
	end,
	hidden_escape_remove = function(arg_115_0, arg_115_1, arg_115_2, arg_115_3)
		if var_0_3(arg_115_0) then
			local var_115_0 = ScriptUnit.extension(arg_115_0, "status_system")
			local var_115_1 = var_115_0:set_invisible(false, nil, "hidden_escape")

			var_115_0:set_noclip(false, "hidden_escape")

			local var_115_2 = arg_115_1.template.cooldown_buff

			ScriptUnit.has_extension(arg_115_0, "buff_system"):add_buff(var_115_2, {
				attacker_unit = arg_115_0
			})

			if not var_0_4(arg_115_0) then
				if var_115_1 then
					ScriptUnit.extension(arg_115_0, "first_person_system"):play_hud_sound_event("Play_career_ability_kerillian_shade_exit")
				end

				Managers.state.camera:set_mood("hidden_escape", "buff", false)
			end
		end
	end,
	update_bad_breath = function(arg_116_0, arg_116_1, arg_116_2)
		if not var_0_6() then
			return
		end

		if not ALIVE[arg_116_0] then
			return
		end

		local var_116_0 = Managers.time:time("main")

		if arg_116_1.rescue_timer and var_116_0 > arg_116_1.rescue_timer then
			arg_116_1.rescue_timer = nil

			local var_116_1
			local var_116_2 = arg_116_1.disabler

			if var_116_2 and ALIVE[var_116_2] then
				var_116_1 = Unit.local_position(var_116_2, 0)
			else
				var_116_1 = POSITION_LOOKUP[arg_116_0]
			end

			arg_116_1.disabler = nil

			local var_116_3 = arg_116_1.template
			local var_116_4 = Quaternion.identity()
			local var_116_5 = var_116_3.explosion_template
			local var_116_6 = ScriptUnit.has_extension(arg_116_0, "career_system"):get_career_power_level()

			Managers.state.entity:system("area_damage_system"):create_explosion(arg_116_0, var_116_1, var_116_4, var_116_5, 1, "buff", var_116_6, false)

			local var_116_7 = Managers.state.entity:system("buff_system")
			local var_116_8 = var_116_3.cooldown_buff

			var_116_7:add_buff(arg_116_0, var_116_8, arg_116_0)
		end
	end,
	update_boulder_bro = function(arg_117_0, arg_117_1, arg_117_2)
		local var_117_0 = arg_117_1.template
		local var_117_1 = Managers.time:time("main")

		if arg_117_1.rescue_timer and var_117_1 > arg_117_1.rescue_timer then
			arg_117_1.rescue_timer = nil

			local var_117_2 = var_117_0.pull_up_duration

			arg_117_1.finish_pull_up_timer = var_117_1 + var_117_2

			local var_117_3 = Unit.animation_find_variable(arg_117_0, "revive_time")

			Unit.animation_set_variable(arg_117_0, var_117_3, var_117_2)
			Unit.animation_event(arg_117_0, "revive_start")

			if ScriptUnit.has_extension(arg_117_0, "first_person_system") then
				ScriptUnit.extension(arg_117_0, "first_person_system"):set_wanted_player_height("stand", var_117_1, var_117_2)
			end
		end

		if arg_117_1.finish_pull_up_timer and var_117_1 > arg_117_1.finish_pull_up_timer then
			arg_117_1.finish_pull_up_timer = nil

			StatusUtils.set_pulled_up_network(arg_117_0, true, arg_117_0)
			Unit.animation_event(arg_117_0, "revive_complete")
			ScriptUnit.extension(arg_117_0, "buff_system"):queue_remove_buff(arg_117_1.id)
		end
	end,
	boulder_bro_add_buff = function(arg_118_0, arg_118_1, arg_118_2)
		if not var_0_6() then
			return
		end

		if not ALIVE[arg_118_0] then
			return
		end

		local var_118_0 = arg_118_1.template.buff_to_add

		ScriptUnit.extension(arg_118_0, "buff_system"):add_buff(var_118_0)
	end,
	resolve_apply = function(arg_119_0, arg_119_1, arg_119_2)
		local var_119_0 = ScriptUnit.extension(arg_119_0, "status_system")
		local var_119_1 = arg_119_1.template.bonus

		var_119_0.wounds = var_119_0.wounds + var_119_1
	end,
	detect_weakness_link_unit = function(arg_120_0, arg_120_1, arg_120_2, arg_120_3)
		local var_120_0 = arg_120_1.template
		local var_120_1 = var_120_0.unit_name
		local var_120_2 = Managers.state.unit_spawner:spawn_local_unit(var_120_1, POSITION_LOOKUP[arg_120_0])

		Managers.state.unit_spawner:create_unit_extensions(Unit.world(var_120_2), var_120_2, "prop_unit")
		World.link_unit(Unit.world(arg_120_0), var_120_2, 0, arg_120_0, Unit.node(arg_120_0, "root_point"))

		arg_120_1.linked_unit = var_120_2

		local var_120_3 = var_120_0.z_offset
		local var_120_4 = var_120_3[Unit.get_data(arg_120_0, "breed").name] or var_120_3.default

		Unit.set_local_position(var_120_2, 0, Vector3(0, 0, var_120_4))
	end,
	health_orb_apply_func = function(arg_121_0, arg_121_1, arg_121_2, arg_121_3)
		if not var_0_6() then
			return
		end

		local var_121_0 = arg_121_1.template.granted_health

		DamageUtils.heal_network(arg_121_0, arg_121_0, var_121_0, "buff")
	end,
	start_static_charge = function(arg_122_0, arg_122_1, arg_122_2, arg_122_3)
		arg_122_1.next_tick_t = arg_122_2.t + arg_122_1.template.tick_every_t

		local var_122_0 = Managers.player:local_player()
		local var_122_1 = var_122_0 and var_122_0.player_unit
		local var_122_2 = Managers.world:wwise_world(arg_122_3)
		local var_122_3 = 0
		local var_122_4

		if arg_122_0 == var_122_1 then
			local var_122_5 = ScriptUnit.extension(arg_122_0, "first_person_system").first_person_unit

			var_122_4 = World.create_particles(arg_122_3, "fx/magic_wind_metal_blade_dance_01_1p", POSITION_LOOKUP[var_122_5])

			World.link_particles(arg_122_3, var_122_4, var_122_5, Unit.node(var_122_5, "root_point"), Matrix4x4.identity(), "stop")
			WwiseWorld.trigger_event(var_122_2, "Play_wind_metal_gameplay_mutator_wind_loop")
		else
			WwiseUtils.trigger_unit_event(arg_122_3, "Play_wind_metal_gameplay_mutator_wind_loop", arg_122_0, 0)

			var_122_4 = World.create_particles(arg_122_3, "fx/magic_wind_metal_blade_dance_01", POSITION_LOOKUP[arg_122_0])

			World.link_particles(arg_122_3, var_122_4, arg_122_0, Unit.node(arg_122_0, "root_point"), Matrix4x4.identity(), "stop")
		end

		arg_122_1.power_level = var_122_3
		arg_122_1.linked_effect = var_122_4
	end,
	update_static_charge = function(arg_123_0, arg_123_1, arg_123_2)
		if arg_123_2.t >= arg_123_1.next_tick_t then
			arg_123_1.next_tick_t = arg_123_2.t + arg_123_1.template.tick_every_t

			local var_123_0 = Managers.state.entity:system("area_damage_system")
			local var_123_1 = POSITION_LOOKUP[arg_123_0] + Vector3(0, 0, 1)
			local var_123_2 = Unit.local_rotation(arg_123_0, 0)
			local var_123_3 = ScriptUnit.has_extension(arg_123_0, "career_system"):get_career_power_level()

			var_123_0:create_explosion(arg_123_0, var_123_1, var_123_2, arg_123_1.template.explosion_template, 1, "undefined", var_123_3, false)
		end
	end,
	remove_static_charge = function(arg_124_0, arg_124_1, arg_124_2, arg_124_3)
		local var_124_0 = Managers.player:local_player()
		local var_124_1 = var_124_0 and var_124_0.player_unit
		local var_124_2 = Managers.world:wwise_world(arg_124_3)

		if arg_124_0 == var_124_1 then
			WwiseWorld.trigger_event(var_124_2, "Stop_wind_metal_gameplay_mutator_wind_loop")
		else
			WwiseUtils.trigger_unit_event(arg_124_3, "Stop_wind_metal_gameplay_mutator_wind_loop", arg_124_0, 0)
		end

		local var_124_3 = arg_124_1.linked_effect

		if var_124_3 then
			World.destroy_particles(arg_124_3, var_124_3)

			arg_124_1.linked_effect = nil
		end
	end,
	reduce_activated_ability_cooldown = function(arg_125_0, arg_125_1, arg_125_2, arg_125_3)
		if Unit.alive(arg_125_0) then
			local var_125_0 = ScriptUnit.has_extension(arg_125_0, "career_system")

			if var_125_0 then
				var_125_0:reduce_activated_ability_cooldown(arg_125_1.template.bonus)
			end
		end
	end,
	always_blocking_remove = function(arg_126_0, arg_126_1, arg_126_2)
		local var_126_0 = ScriptUnit.extension(arg_126_0, "buff_system")

		if arg_126_1.buff_id then
			var_126_0:remove_buff(arg_126_1.buff_id)
		end
	end,
	resolve_update = function(arg_127_0, arg_127_1, arg_127_2)
		local var_127_0 = ScriptUnit.extension(arg_127_0, "buff_system")
		local var_127_1 = arg_127_1.template
		local var_127_2 = var_127_1.cooldown_buff
		local var_127_3 = var_127_1.full_heal_buff
		local var_127_4 = arg_127_1.after_revive_t
		local var_127_5 = Managers.time:time("game")

		if var_127_4 and var_127_4 < var_127_5 then
			if arg_127_1.full_heal_perk_buff_id then
				var_127_0:remove_buff(arg_127_1.full_heal_perk_buff_id)

				arg_127_1.full_heal_perk_buff_id = nil
			end

			arg_127_1.after_revive_t = nil
		end

		if not var_127_0:get_buff_type(var_127_2) and not var_127_0:get_buff_type(var_127_3) then
			arg_127_1.full_heal_perk_buff_id = var_127_0:add_buff(var_127_3)
		end
	end,
	boon_skulls_04_regen_update = function(arg_128_0, arg_128_1, arg_128_2)
		local var_128_0 = arg_128_1.thp_added or 0

		if var_128_0 >= MorrisBuffTweakData.boon_skulls_04_data.thp_per_second * arg_128_1.duration then
			return
		end

		local var_128_1 = MorrisBuffTweakData.boon_skulls_04_data.thp_per_second
		local var_128_2 = Managers.state.network
		local var_128_3 = var_128_2:unit_game_object_id(arg_128_0)
		local var_128_4 = NetworkLookup.heal_types.heal_from_proc

		var_128_2.network_transmit:send_rpc_server("rpc_request_heal", var_128_3, var_128_1, var_128_4)

		arg_128_1.thp_added = var_128_0 + var_128_1
	end,
	boon_skulls_04_regen_remove = function(arg_129_0, arg_129_1, arg_129_2)
		if not HEALTH_ALIVE[arg_129_0] then
			return
		end

		if not Managers.state.network or not Managers.state.network:game() then
			return
		end

		local var_129_0 = arg_129_1.thp_added or 0
		local var_129_1 = MorrisBuffTweakData.boon_skulls_04_data.thp_per_second * arg_129_1.duration

		if var_129_0 < var_129_1 then
			local var_129_2 = Managers.state.network
			local var_129_3 = var_129_2:unit_game_object_id(arg_129_0)
			local var_129_4 = NetworkLookup.heal_types.heal_from_proc

			var_129_2.network_transmit:send_rpc_server("rpc_request_heal", var_129_3, var_129_1 - var_129_0, var_129_4)
		end

		BuffFunctionTemplates.functions.skulls_event_boon_surge_removed(arg_129_0, arg_129_1, arg_129_2)
	end,
	skulls_event_boon_surge_applied = function(arg_130_0, arg_130_1, arg_130_2, arg_130_3)
		if var_0_3(arg_130_0) and not var_0_4(arg_130_0) then
			local var_130_0 = ScriptUnit.extension(arg_130_0, "first_person_system")
			local var_130_1 = ScriptUnit.extension(arg_130_0, "buff_system")
			local var_130_2 = var_130_1:get_buff_type("skulls_boon_buffs_tracker")

			if not var_130_2 then
				local var_130_3 = var_130_1:add_buff("skulls_boon_buffs_tracker")

				var_130_2 = var_130_1:get_buff_by_id(var_130_3)

				local var_130_4 = var_130_0:create_screen_particles("fx/skulls_2023/screenspace_skulls_2023_buff")

				if var_130_4 then
					local var_130_5 = 0
					local var_130_6 = math.lerp(-0.55, 0.4, var_130_5)

					World.set_particles_material_scalar(arg_130_3, var_130_4, "overlay", "shadow_amount", var_130_6)

					var_130_2.effect_id = var_130_4
				end

				var_130_2.num_buffs = 1

				var_130_0:play_hud_sound_event("Play_skulls_event_buff_on")
			else
				local var_130_7 = var_130_2.num_buffs
				local var_130_8 = var_130_2.num_possible_buffs

				if not var_130_8 then
					var_130_8 = 0

					for iter_130_0 = 1, #DeusPowerUpsArray do
						if table.contains(DeusPowerUpsArray[iter_130_0].mutators, "skulls_2023") then
							var_130_8 = var_130_8 + 1
						end
					end

					var_130_2.num_possible_buffs = var_130_8
				end

				local var_130_9 = var_130_2.effect_id

				if var_130_9 then
					local var_130_10 = var_130_8 > 1 and (var_130_7 - 1) / (var_130_8 - 1) or 1
					local var_130_11 = math.lerp(-0.55, 0.4, var_130_10)

					World.set_particles_material_scalar(arg_130_3, var_130_9, "overlay", "shadow_amount", var_130_11)
				end

				if var_130_8 <= var_130_7 and not var_130_2.sound_played then
					var_130_0:play_hud_sound_event("Play_skulls_event_buff_max_stacks")

					var_130_2.sound_played = true
				end

				var_130_2.num_buffs = var_130_7 + 1
			end
		end
	end,
	skulls_event_boon_surge_removed = function(arg_131_0, arg_131_1, arg_131_2)
		if var_0_3(arg_131_0) and not var_0_4(arg_131_0) then
			local var_131_0 = ScriptUnit.extension(arg_131_0, "buff_system")
			local var_131_1 = var_131_0:get_buff_type("skulls_boon_buffs_tracker")
			local var_131_2 = var_131_1.num_buffs - 1

			var_131_1.num_buffs = var_131_2

			if var_131_2 == 0 then
				local var_131_3 = var_131_1.effect_id
				local var_131_4 = ScriptUnit.extension(arg_131_0, "first_person_system")

				if var_131_3 then
					var_131_4:stop_spawning_screen_particles(var_131_3)
				end

				var_131_0:remove_buff(var_131_1.id)
				var_131_4:play_hud_sound_event("Play_skulls_event_buff_off")
			end
		end
	end,
	periodic_aoe_stagger = function(arg_132_0, arg_132_1, arg_132_2)
		if not var_0_6() then
			return
		end

		local var_132_0 = arg_132_1.template
		local var_132_1 = var_132_0.update_frequency
		local var_132_2 = var_132_0.min_update_frequency
		local var_132_3 = var_132_0.min_update_frequency_at
		local var_132_4 = ScriptUnit.extension(arg_132_0, "health_system"):current_health_percent()

		arg_132_1.update_frequency = math.remap(var_132_3, 1, var_132_2, var_132_1, var_132_4)

		local var_132_5 = POSITION_LOOKUP[arg_132_0]
		local var_132_6 = arg_132_1.template.explosion_template_name
		local var_132_7 = ExplosionTemplates[var_132_6]
		local var_132_8 = var_132_7.explosion.radius
		local var_132_9 = Managers.state.side.side_by_unit[arg_132_0]

		if AiUtils.broadphase_query(var_132_5, var_132_8, FrameTable.alloc_table(), var_132_9.enemy_broadphase_categories) <= 0 then
			return
		end

		local var_132_10 = ScriptUnit.has_extension(arg_132_0, "career_system")
		local var_132_11 = var_132_10 and var_132_10:get_career_power_level() or DefaultPowerLevel
		local var_132_12 = 1
		local var_132_13 = "buff"
		local var_132_14 = Quaternion.identity()

		DamageUtils.create_explosion(Unit.world(arg_132_0), arg_132_0, var_132_5, var_132_14, var_132_7, var_132_12, var_132_13, true, false, arg_132_0, var_132_11, false, arg_132_0)

		local var_132_15 = Managers.state.network:unit_game_object_id(arg_132_0)
		local var_132_16 = NetworkLookup.explosion_templates[var_132_6]
		local var_132_17 = NetworkLookup.damage_sources[var_132_13]

		Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_132_15, false, var_132_5, var_132_14, var_132_16, var_132_12, var_132_17, var_132_11, false, var_132_15)
	end,
	teammates_extra_damage_aura_enter = function(arg_133_0, arg_133_1, arg_133_2, arg_133_3)
		local var_133_0 = ScriptUnit.has_extension(arg_133_0, "buff_system")

		if var_133_0 then
			arg_133_2.cached_params = arg_133_2.cached_params or {
				attacker_unit = arg_133_1
			}

			return var_133_0:add_buff("deus_extra_damage_aura_debuff", arg_133_2.cached_params)
		end

		return -1
	end,
	teammates_extra_damage_aura_leave = function(arg_134_0, arg_134_1, arg_134_2, arg_134_3, arg_134_4)
		if arg_134_1 == -1 then
			return
		end

		local var_134_0 = ScriptUnit.has_extension(arg_134_0, "buff_system")

		if var_134_0 then
			return var_134_0:remove_buff(arg_134_1)
		end
	end,
	teammates_extra_stagger_aura_enter = function(arg_135_0, arg_135_1, arg_135_2, arg_135_3)
		local var_135_0 = ScriptUnit.has_extension(arg_135_0, "buff_system")

		if var_135_0 then
			arg_135_2.cached_params = arg_135_2.cached_params or {
				attacker_unit = arg_135_1
			}

			return var_135_0:add_buff("deus_extra_stagger_aura_debuff", arg_135_2.cached_params)
		end

		return -1
	end,
	teammates_extra_stagger_aura_leave = function(arg_136_0, arg_136_1, arg_136_2, arg_136_3, arg_136_4)
		if arg_136_1 == -1 then
			return
		end

		local var_136_0 = ScriptUnit.has_extension(arg_136_0, "buff_system")

		if var_136_0 then
			return var_136_0:remove_buff(arg_136_1)
		end
	end,
	boon_meta_01_apply = function(arg_137_0, arg_137_1, arg_137_2)
		local var_137_0 = Managers.player:owner(arg_137_0)

		if not var_137_0 then
			return
		end

		local var_137_1 = ScriptUnit.extension(arg_137_0, "buff_system")
		local var_137_2 = #Managers.mechanism:game_mechanism():get_deus_run_controller():get_player_power_ups(var_137_0:network_id(), var_137_0:local_player_id())

		for iter_137_0 = 1, var_137_2 do
			var_137_1:add_buff("boon_meta_01_stack")
		end
	end,
	boon_weaponrarity_01_apply = function(arg_138_0, arg_138_1, arg_138_2)
		local var_138_0 = Managers.player:owner(arg_138_0)

		if not var_138_0 or var_138_0:network_id() ~= Network.peer_id() then
			return
		end

		local var_138_1 = ScriptUnit.extension(arg_138_0, "career_system"):career_name()
		local var_138_2 = Managers.backend:get_interface("deus")
		local var_138_3 = var_138_2:get_loadout_item_id(var_138_1, "slot_melee")
		local var_138_4 = var_138_2:get_loadout_item(var_138_3)
		local var_138_5 = ORDER_RARITY[var_138_4 and var_138_4.rarity] or 1
		local var_138_6 = var_138_2:get_loadout_item_id(var_138_1, "slot_ranged")
		local var_138_7 = var_138_2:get_loadout_item(var_138_6)
		local var_138_8 = ORDER_RARITY[var_138_7 and var_138_7.rarity] or 1
		local var_138_9 = math.max(var_138_5, var_138_8)
		local var_138_10 = ScriptUnit.extension(arg_138_0, "buff_system")

		for iter_138_0 = var_138_10:num_buff_stacks("boon_weaponrarity_01_debuff") + 2, var_138_9 do
			var_138_10:add_buff("boon_weaponrarity_01_debuff")
		end
	end,
	boon_weaponrarity_02_apply = function(arg_139_0, arg_139_1, arg_139_2)
		local var_139_0 = Managers.player:owner(arg_139_0)

		if not var_139_0 or var_139_0:network_id() ~= Network.peer_id() then
			return
		end

		local var_139_1 = ScriptUnit.extension(arg_139_0, "career_system")
		local var_139_2 = ScriptUnit.extension(arg_139_0, "inventory_system")
		local var_139_3 = var_139_1:career_name()
		local var_139_4 = var_139_2:get_wielded_slot_name()

		if var_139_4 ~= "slot_melee" and var_139_4 ~= "slot_ranged" then
			return
		end

		local var_139_5 = Managers.backend:get_interface("deus")
		local var_139_6 = var_139_5:get_loadout_item_id(var_139_3, var_139_4)
		local var_139_7 = var_139_5:get_loadout_item(var_139_6)

		if not var_139_7 then
			return
		end

		local var_139_8 = var_139_7.rarity
		local var_139_9 = ORDER_RARITY[var_139_8]

		if not var_139_9 then
			return
		end

		local var_139_10 = ScriptUnit.extension(arg_139_0, "buff_system")

		for iter_139_0 = var_139_10:num_buff_stacks("boon_weaponrarity_02_debuff") + 2, var_139_9 do
			var_139_10:add_buff("boon_weaponrarity_02_debuff")
		end
	end,
	boon_range_02_buff_adder_add_buff = function(arg_140_0, arg_140_1, arg_140_2)
		if HEALTH_ALIVE[arg_140_0] then
			local var_140_0 = ScriptUnit.has_extension(arg_140_0, "buff_system")
			local var_140_1 = var_140_0:get_stacking_buff("boon_range_02_increased_damage_tracker")

			if var_140_1 then
				for iter_140_0 = #var_140_1, 1, -1 do
					local var_140_2 = var_140_1[iter_140_0]

					if var_140_2.attacker_unit == arg_140_2.attacker_unit then
						var_140_0:remove_buff(var_140_2.id)
					end
				end
			end

			var_140_0:add_buff("boon_range_02_increased_damage_tracker", {
				attacker_unit = arg_140_1.attacker_unit
			})
		end
	end,
	match_num_buffs_update = function(arg_141_0, arg_141_1, arg_141_2)
		local var_141_0 = arg_141_1.buff_tracker or {}

		arg_141_1.buff_tracker = var_141_0

		local var_141_1 = arg_141_1.template.buff_to_check
		local var_141_2 = arg_141_1.template.buff_to_add
		local var_141_3 = ScriptUnit.extension(arg_141_0, "buff_system")
		local var_141_4 = var_141_3:num_buff_stacks(var_141_1)
		local var_141_5 = #var_141_0

		if var_141_4 ~= var_141_5 then
			for iter_141_0 = var_141_5 + 1, var_141_4 do
				var_141_0[iter_141_0] = var_141_3:add_buff(var_141_2)
			end

			for iter_141_1 = var_141_5, var_141_4 + 1, -1 do
				var_141_3:remove_buff(var_141_0[iter_141_1])

				var_141_0[iter_141_1] = nil
			end
		end
	end
}
var_0_2.proc_functions = {
	stockpile_refresh_ammo_buffs = function(arg_142_0, arg_142_1, arg_142_2)
		local var_142_0 = ScriptUnit.has_extension(arg_142_0, "inventory_system")

		if var_142_0 then
			local var_142_1 = var_142_0:get_wielded_slot_data()
			local var_142_2 = var_142_1.left_unit_1p
			local var_142_3 = var_142_1.right_unit_1p
			local var_142_4 = ScriptUnit.has_extension(var_142_2, "ammo_system")

			if var_142_4 then
				var_142_4:refresh_buffs()
			end

			local var_142_5 = ScriptUnit.has_extension(var_142_3, "ammo_system")

			if var_142_5 then
				var_142_5:refresh_buffs()
			end
		end

		ScriptUnit.extension(arg_142_0, "buff_system"):remove_buff(arg_142_1.id)
	end,
	stagger_aoe_on_hit = function(arg_143_0, arg_143_1, arg_143_2)
		if not var_0_6() then
			return
		end

		if not ALIVE[arg_143_0] then
			return
		end

		local var_143_0 = arg_143_2[1]
		local var_143_1 = arg_143_1.template
		local var_143_2 = ExplosionUtils.get_template(var_143_1.explosion_template)
		local var_143_3 = Application.main_world()
		local var_143_4 = POSITION_LOOKUP[var_143_0]
		local var_143_5 = Quaternion.identity()
		local var_143_6 = ScriptUnit.has_extension(arg_143_0, "career_system"):get_career_power_level()

		DamageUtils.create_explosion(var_143_3, arg_143_0, var_143_4, var_143_5, var_143_2, 1, "buff", var_0_6(), var_0_7(arg_143_0), arg_143_0, var_143_6, false)
	end,
	remove_this_player_buff = function(arg_144_0, arg_144_1, arg_144_2)
		if ALIVE[arg_144_0] then
			local var_144_0 = ScriptUnit.has_extension(arg_144_0, "buff_system")

			if var_144_0 then
				var_144_0:remove_buff(arg_144_1.id)
			end
		end
	end,
	armor_breaker_on_armored_kill = function(arg_145_0, arg_145_1, arg_145_2)
		if not var_0_6() then
			return
		end

		if not ALIVE[arg_145_0] then
			return
		end

		local var_145_0 = arg_145_1.template
		local var_145_1 = arg_145_2[2].name

		if var_145_0.trigger_on_breed[var_145_1] and ScriptUnit.has_extension(arg_145_0, "buff_system") then
			Managers.state.entity:system("buff_system"):add_buff(arg_145_0, "armor_breaker", arg_145_0)
		end
	end,
	remove_mark_of_nurgle = function(arg_146_0, arg_146_1, arg_146_2)
		local var_146_0 = Application.main_world()
		local var_146_1 = arg_146_1.linked_effect

		if var_146_1 then
			World.destroy_particles(var_146_0, var_146_1)

			arg_146_1.linked_effect = nil
		end

		local var_146_2 = arg_146_1.sound_id

		if var_146_2 then
			WwiseWorld.stop_event(arg_146_1.wwise_world, var_146_2)

			arg_146_1.sound_id = nil
		end
	end,
	apply_mark_of_nurgle_dot = function(arg_147_0, arg_147_1, arg_147_2, arg_147_3, arg_147_4)
		local var_147_0 = arg_147_2[arg_147_4.attacked_unit]
		local var_147_1 = arg_147_2[arg_147_4.attacker_unit]
		local var_147_2 = arg_147_2[arg_147_4.damage_source]

		if ALIVE[var_147_0] and var_147_2 ~= "dot_debuff" then
			local var_147_3 = ScriptUnit.extension(var_147_0, "buff_system")
			local var_147_4 = {
				attacker_unit = var_147_1
			}

			var_147_3:add_buff("curse_mark_of_nurgle_dot", var_147_4)
		end
	end,
	mark_of_nurgle_explosion = function(arg_148_0, arg_148_1, arg_148_2)
		if Managers.state.entity:system("projectile_system") then
			local var_148_0 = arg_148_1.template
			local var_148_1 = arg_148_2[1]
			local var_148_2 = POSITION_LOOKUP[var_148_1]
			local var_148_3 = Managers.state.difficulty:get_difficulty()
			local var_148_4 = table.index_of(DefaultDifficulties, var_148_3)
			local var_148_5 = table.get_value_or_last(var_148_0.aoe_init_difficulty_damage, var_148_4)
			local var_148_6 = table.get_value_or_last(var_148_0.aoe_dot_difficulty_damage, var_148_4)
			local var_148_7 = {
				area_damage_system = {
					area_damage_template = "globadier_area_dot_damage",
					invisible_unit = true,
					nav_tag_volume_layer = "bot_poison_wind",
					create_nav_tag_volume = true,
					damage_source = "poison_dot",
					player_screen_effect_name = "fx/screenspace_poison_globe_impact",
					area_ai_random_death_template = "area_poison_ai_random_death",
					dot_effect_name = "fx/wpnfx_poison_wind_globe_impact",
					explosion_template_name = "corrupted_flesh_explosion",
					extra_dot_effect_name = "fx/chr_gutter_death",
					damage_players = true,
					aoe_dot_damage = DamageUtils.calculate_damage(var_148_6),
					aoe_init_damage = DamageUtils.calculate_damage(var_148_5),
					aoe_dot_damage_interval = var_148_0.aoe_dot_damage_interval,
					radius = var_148_0.radius,
					initial_radius = var_148_0.initial_radius,
					life_time = var_148_0.cloud_life_time,
					source_attacker_unit = var_148_1
				}
			}
			local var_148_8 = "units/weapons/projectile/poison_wind_globe/poison_wind_globe"
			local var_148_9 = Managers.state.unit_spawner:spawn_network_unit(var_148_8, "aoe_unit", var_148_7, var_148_2)
			local var_148_10 = Managers.state.unit_storage:go_id(var_148_9)

			Unit.set_unit_visibility(var_148_9, false)

			if var_0_6() then
				Managers.state.network.network_transmit:send_rpc_all("rpc_area_damage", var_148_10, var_148_2)
			end
		end
	end,
	bloodthirst_on_kill = function(arg_149_0, arg_149_1, arg_149_2)
		arg_149_1.reset_timer()

		if ALIVE[arg_149_0] then
			local var_149_0 = arg_149_1.template
			local var_149_1 = (arg_149_1.kill_count or 0) + 1

			if var_149_1 >= var_149_0.kills_needed then
				var_149_1 = 0

				local var_149_2 = var_149_0.buff_name_to_add
				local var_149_3 = BuffUtils.get_max_stacks(var_149_2) > #arg_149_1.stacked_buffs
				local var_149_4 = ScriptUnit.has_extension(arg_149_0, "buff_system")

				if var_149_4 and var_149_3 then
					local var_149_5 = var_149_4:add_buff(var_149_2)

					table.insert(arg_149_1.stacked_buffs, var_149_5)
				end
			end

			arg_149_1.kill_count = var_149_1
		end
	end,
	headhunter_on_damage_dealt = function(arg_150_0, arg_150_1, arg_150_2, arg_150_3, arg_150_4)
		if not ALIVE[arg_150_0] then
			return
		end

		local var_150_0 = ScriptUnit.has_extension(arg_150_0, "buff_system")
		local var_150_1 = arg_150_2[arg_150_4.hit_zone_name]
		local var_150_2 = arg_150_1.template
		local var_150_3 = var_150_2.valid_hit_zones[var_150_1]
		local var_150_4 = var_150_2.ignore_hit_zones[var_150_1]

		if var_150_3 then
			local var_150_5 = var_150_2.buff_name_to_add
			local var_150_6 = BuffUtils.get_max_stacks(var_150_5) > #arg_150_1.stacked_buffs

			if var_150_0 and var_150_6 then
				local var_150_7 = var_150_0:add_buff(var_150_5)

				table.insert(arg_150_1.stacked_buffs, var_150_7)
			end
		elseif not var_150_4 and var_150_0 then
			for iter_150_0 = 1, var_150_2.remove_amount do
				local var_150_8 = arg_150_1.stacked_buffs[#arg_150_1.stacked_buffs]

				var_150_0:remove_buff(var_150_8)

				arg_150_1.stacked_buffs[#arg_150_1.stacked_buffs] = nil
			end
		end
	end,
	vampiric_heal = function(arg_151_0, arg_151_1, arg_151_2, arg_151_3, arg_151_4)
		if ALIVE[arg_151_0] and var_0_6() then
			local var_151_0 = arg_151_1.template.difficulty_multiplier
			local var_151_1 = var_151_0[Managers.state.difficulty:get_difficulty()] or table.values(var_151_0)[1]
			local var_151_2 = arg_151_2[arg_151_4.damage_amount] * var_151_1

			DamageUtils.heal_network(arg_151_0, arg_151_0, var_151_2, "health_regen")
		end
	end,
	friendly_murder = function(arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4)
		if ALIVE[arg_152_0] and var_0_6() then
			local var_152_0 = POSITION_LOOKUP[arg_152_0]
			local var_152_1 = arg_152_1.range
			local var_152_2 = var_152_1 * var_152_1
			local var_152_3 = Managers.state.side.side_by_unit[arg_152_0].PLAYER_AND_BOT_UNITS
			local var_152_4 = arg_152_1.template.difficulty_multiplier
			local var_152_5 = var_152_4[Managers.state.difficulty:get_difficulty()] or table.values(var_152_4)[1]
			local var_152_6 = arg_152_2[arg_152_4.damage_amount] * var_152_5

			for iter_152_0 = 1, #var_152_3 do
				local var_152_7 = var_152_3[iter_152_0]

				if var_152_7 ~= arg_152_0 and Unit.alive(var_152_7) then
					local var_152_8 = POSITION_LOOKUP[var_152_7]

					if var_152_2 > Vector3.distance_squared(var_152_0, var_152_8) then
						DamageUtils.heal_network(var_152_7, arg_152_0, var_152_6, "health_regen")
					end
				end
			end
		end
	end,
	curse_khorne_champions_leader_death = function(arg_153_0, arg_153_1, arg_153_2)
		return true
	end,
	spawn_greed_pinata = function(arg_154_0, arg_154_1, arg_154_2)
		if not var_0_6() then
			return true
		end

		local var_154_0 = arg_154_2[1]
		local var_154_1 = POSITION_LOOKUP[var_154_0]
		local var_154_2

		Managers.state.conflict:spawn_queued_unit(Breeds.chaos_greed_pinata, Vector3Box(var_154_1), QuaternionBox(Quaternion.identity()), "mutator", "spawn_idle", "terror_event", var_154_2)

		return true
	end,
	curse_greed_pinata_death = function(arg_155_0, arg_155_1, arg_155_2)
		local var_155_0 = arg_155_1.health_extension

		if var_155_0 then
			while arg_155_1.drops_done < arg_155_1.template.total_drops do
				local var_155_1 = var_155_0.last_damage_data.attacker_unit_id

				var_0_10(arg_155_1.template.drop_table, POSITION_LOOKUP[arg_155_2[1]], var_155_1)

				arg_155_1.drops_done = arg_155_1.drops_done + 1
			end
		end

		return true
	end,
	remove_objective_unit = function(arg_156_0, arg_156_1, arg_156_2)
		if arg_156_1.objective_unit then
			World.unlink_unit(Unit.world(arg_156_1.objective_unit), arg_156_1.objective_unit)
			Managers.state.unit_spawner:mark_for_deletion(arg_156_1.objective_unit)

			arg_156_1.objective_unit = nil
		end
	end,
	all_potions_heal_func = function(arg_157_0, arg_157_1, arg_157_2)
		if ALIVE[arg_157_0] then
			local var_157_0 = arg_157_1.bonus
			local var_157_1 = "healing_draught"

			if var_0_6() then
				DamageUtils.heal_network(arg_157_0, arg_157_0, var_157_0, var_157_1)
			else
				local var_157_2 = Managers.state.network
				local var_157_3 = var_157_2:unit_game_object_id(arg_157_0)
				local var_157_4 = NetworkLookup.heal_types[var_157_1]

				var_157_2.network_transmit:send_rpc_server("rpc_request_heal", var_157_3, var_157_0, var_157_4)
			end
		end
	end,
	remove_health_bar = function(arg_158_0, arg_158_1, arg_158_2)
		Managers.state.event:trigger("tutorial_event_remove_health_bar", arg_158_1.unit)
	end,
	trigger_dialogue_event = function(arg_159_0, arg_159_1, arg_159_2)
		local var_159_0 = arg_159_1.template.dialogue_event
		local var_159_1 = ScriptUnit.extension_input(arg_159_0, "dialogue_system")
		local var_159_2 = FrameTable.alloc_table()

		var_159_1:trigger_dialogue_event(var_159_0, var_159_2)
	end,
	add_buff_on_pickup = function(arg_160_0, arg_160_1, arg_160_2)
		if ALIVE[arg_160_0] then
			local var_160_0 = arg_160_2[2]
			local var_160_1 = var_0_9(arg_160_1, var_160_0)

			if var_160_1 then
				if arg_160_1.template.local_only then
					local var_160_2 = ScriptUnit.extension(arg_160_0, "buff_system")

					for iter_160_0 = 1, #var_160_1 do
						var_160_2:add_buff(var_160_1[iter_160_0])
					end
				else
					local var_160_3 = Managers.state.entity:system("buff_system")

					for iter_160_1 = 1, #var_160_1 do
						var_160_3:add_buff(arg_160_0, var_160_1[iter_160_1], arg_160_0, false)
					end
				end
			end
		end
	end,
	heal_on_pickup = function(arg_161_0, arg_161_1, arg_161_2, arg_161_3)
		if ALIVE[arg_161_0] then
			local var_161_0 = arg_161_2[2]
			local var_161_1 = var_0_9(arg_161_1, var_161_0)
			local var_161_2 = var_161_0.unit_template_name
			local var_161_3 = var_161_2 and var_161_2 == "limited_owned_pickup_unit"

			if var_161_1 and not var_161_3 then
				var_0_8(arg_161_0, var_161_1.type, var_161_1.amount)

				local var_161_4 = arg_161_1.template.sound_event

				if not var_0_3(arg_161_0) then
					local var_161_5 = NetworkLookup.sound_events[var_161_4]
					local var_161_6 = Managers.player:owner(arg_161_0):network_id()

					Managers.state.network.network_transmit:send_rpc("rpc_play_2d_audio_event", var_161_6, var_161_5)
				else
					local var_161_7 = Managers.world:wwise_world(arg_161_3)

					WwiseWorld.trigger_event(var_161_7, var_161_4)
				end
			end
		end
	end,
	ally_gain_ammo_on_pickup = function(arg_162_0, arg_162_1, arg_162_2)
		if ALIVE[arg_162_0] then
			local var_162_0 = arg_162_2[2]
			local var_162_1 = var_0_9(arg_162_1, var_162_0)

			if var_162_1 then
				local var_162_2 = var_162_1.ammo_bonus_fraction
				local var_162_3 = var_162_1.max_range
				local var_162_4 = var_162_3 * var_162_3
				local var_162_5 = POSITION_LOOKUP[arg_162_0]
				local var_162_6 = Managers.state.side.side_by_unit[arg_162_0].PLAYER_AND_BOT_UNITS
				local var_162_7 = Managers.state.entity:system("ammo_system")

				for iter_162_0 = 1, #var_162_6 do
					local var_162_8 = var_162_6[iter_162_0]

					if ALIVE[var_162_8] and var_162_8 ~= arg_162_0 and var_162_4 >= Vector3.distance_squared(var_162_5, POSITION_LOOKUP[var_162_8]) then
						var_162_7:give_ammo_fraction_to_owner(var_162_8, var_162_2, true)
					end
				end
			end
		end
	end,
	add_buff_on_ally_revived = function(arg_163_0, arg_163_1, arg_163_2)
		local var_163_0 = arg_163_2[1]

		if ALIVE[arg_163_0] and ALIVE[var_163_0] and var_0_6() then
			local var_163_1 = Managers.state.entity:system("buff_system")
			local var_163_2 = arg_163_1.template.buff_to_add

			if var_163_2 then
				for iter_163_0 = 1, #var_163_2 do
					local var_163_3 = var_163_2[iter_163_0]

					var_163_1:add_buff(arg_163_0, var_163_3, arg_163_0, false)
				end
			end

			local var_163_4 = arg_163_1.template.buff_to_add_revived

			if var_163_4 then
				for iter_163_1 = 1, #var_163_4 do
					local var_163_5 = var_163_4[iter_163_1]

					var_163_1:add_buff(var_163_0, var_163_5, arg_163_0, false)
				end
			end
		end
	end,
	chain_lightning = function(arg_164_0, arg_164_1, arg_164_2, arg_164_3, arg_164_4)
		local var_164_0 = arg_164_2[arg_164_4.attacked_unit]
		local var_164_1 = arg_164_2[arg_164_4.first_hit]
		local var_164_2 = arg_164_2[arg_164_4.is_critical_strike]

		if ALIVE[arg_164_0] and ALIVE[var_164_0] and var_164_1 and var_164_2 then
			local var_164_3 = POSITION_LOOKUP[var_164_0]
			local var_164_4 = arg_164_1.template
			local var_164_5 = var_164_4.damage_source
			local var_164_6 = Managers.state.entity:system("audio_system")
			local var_164_7 = var_164_4.sound_event
			local var_164_8 = "damage_over_time"
			local var_164_9 = arg_164_2[2]

			DamageUtils.add_damage_network(var_164_0, arg_164_0, var_164_9, "torso", var_164_8, nil, Vector3(1, 0, 0), var_164_5, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)

			local var_164_10 = NetworkLookup.effects["fx/cw_chain_lightning"]
			local var_164_11 = POSITION_LOOKUP[arg_164_0] + 0.5 * Vector3.up()
			local var_164_12
			local var_164_13 = Unit.has_node(var_164_0, "j_spine") and Unit.node(var_164_0, "j_spine")

			if var_164_13 then
				var_164_12 = Unit.world_position(var_164_0, var_164_13)
			else
				var_164_12 = POSITION_LOOKUP[var_164_0] + 0.5 * Vector3.up()
			end

			local var_164_14 = Vector3.distance(var_164_12, var_164_11)
			local var_164_15 = Vector3(1, var_164_14, 0)
			local var_164_16 = Quaternion.look(var_164_12 - var_164_11)

			Managers.state.network:rpc_play_particle_effect_with_variable(nil, var_164_10, var_164_11, var_164_16, "distance", var_164_15)

			local var_164_17 = var_164_4.max_chain_range
			local var_164_18 = var_164_4.max_targets - 1
			local var_164_19 = Managers.state.side.side_by_unit[arg_164_0]
			local var_164_20 = var_164_19 and var_164_19.enemy_broadphase_categories
			local var_164_21 = FrameTable.alloc_table()
			local var_164_22 = {}

			for iter_164_0 = 1, var_164_18 do
				local var_164_23 = AiUtils.broadphase_query(var_164_3, var_164_17, var_164_21, var_164_20)

				table.sort(var_164_21, function(arg_165_0, arg_165_1)
					return Vector3.distance_squared(POSITION_LOOKUP[arg_165_0], var_164_3) < Vector3.distance_squared(POSITION_LOOKUP[arg_165_1], var_164_3)
				end)

				for iter_164_1 = 1, var_164_23 do
					local var_164_24 = var_164_21[iter_164_1]

					if ALIVE[var_164_24] and not var_164_22[var_164_24] and HEALTH_ALIVE[var_164_24] and var_164_24 ~= var_164_0 then
						var_164_22[var_164_24] = true

						DamageUtils.add_damage_network(var_164_24, arg_164_0, var_164_9, "torso", var_164_8, nil, Vector3(1, 0, 0), var_164_5, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, iter_164_0)
						var_164_6:play_audio_unit_event(var_164_7, var_164_24)

						local var_164_25 = var_164_12
						local var_164_26 = Unit.has_node(var_164_24, "j_spine") and Unit.node(var_164_24, "j_spine")

						if var_164_26 then
							var_164_12 = Unit.world_position(var_164_24, var_164_26)
						else
							var_164_12 = POSITION_LOOKUP[var_164_24] + 0.5 * Vector3.up()
						end

						local var_164_27 = Vector3.distance(var_164_12, var_164_25)
						local var_164_28 = Vector3(1, var_164_27, 0)
						local var_164_29 = Quaternion.look(var_164_12 - var_164_25)

						Managers.state.network:rpc_play_particle_effect_with_variable(nil, var_164_10, var_164_25, var_164_29, "distance", var_164_28)

						var_164_3 = POSITION_LOOKUP[var_164_24]

						break
					end
				end
			end
		end
	end,
	cooldown_on_friendly_ability = function(arg_166_0, arg_166_1, arg_166_2)
		local var_166_0 = arg_166_2[1]

		if arg_166_0 == var_166_0 then
			return
		end

		local var_166_1 = POSITION_LOOKUP[arg_166_0]
		local var_166_2 = POSITION_LOOKUP[var_166_0]

		if var_166_1 and var_166_2 then
			local var_166_3 = arg_166_1.template.range

			if var_166_3 * var_166_3 >= Vector3.distance_squared(var_166_1, var_166_2) then
				local var_166_4 = ScriptUnit.has_extension(arg_166_0, "career_system")

				if var_166_4 then
					local var_166_5 = arg_166_1.template.value

					var_166_4:reduce_activated_ability_cooldown_percent(var_166_5)
				end
			end
		end
	end,
	skill_on_special_kill = function(arg_167_0, arg_167_1, arg_167_2)
		if ALIVE[arg_167_0] then
			local var_167_0 = ScriptUnit.has_extension(arg_167_0, "career_system")

			if var_167_0 then
				local var_167_1 = arg_167_1.template.percent_restored

				var_167_0:reduce_activated_ability_cooldown_percent(var_167_1)
			end
		end
	end,
	add_buff_on_proc = function(arg_168_0, arg_168_1, arg_168_2)
		local var_168_0 = Managers.state.entity:system("buff_system")
		local var_168_1 = arg_168_1.template.buff_to_add

		var_168_0:add_buff(arg_168_0, var_168_1, arg_168_0, false)
	end,
	add_buff_on_melee_kills_proc = function(arg_169_0, arg_169_1, arg_169_2)
		if not var_0_6() then
			return
		end

		local var_169_0 = arg_169_2[1]

		if not var_169_0 then
			return
		end

		local var_169_1 = var_169_0[DamageDataIndex.ATTACK_TYPE]

		if not var_169_1 or var_169_1 ~= "light_attack" and var_169_1 ~= "heavy_attack" then
			return
		end

		local var_169_2 = arg_169_1.template.buff_to_add
		local var_169_3 = Managers.state.entity:system("buff_system")
		local var_169_4 = ScriptUnit.extension(arg_169_0, "buff_system")

		if not var_169_4:get_non_stacking_buff(var_169_2) then
			local var_169_5 = var_169_3:add_buff(arg_169_0, var_169_2, arg_169_0, true)
			local var_169_6 = var_169_4:get_non_stacking_buff(var_169_2)

			if var_169_6 then
				var_169_6.server_id = var_169_5
			end
		end
	end,
	add_buff_on_non_friendly_damage_taken = function(arg_170_0, arg_170_1, arg_170_2)
		local var_170_0 = arg_170_2[1]
		local var_170_1 = Managers.state.side.side_by_unit[arg_170_0]
		local var_170_2 = Managers.state.side.side_by_unit[var_170_0]

		if arg_170_0 == var_170_0 or var_170_1 and var_170_2 and var_170_1 ~= var_170_2 or not var_170_2 then
			local var_170_3 = Managers.state.entity:system("buff_system")
			local var_170_4 = arg_170_1.template.buff_to_add

			var_170_3:add_buff(arg_170_0, var_170_4, arg_170_0, false)
		end
	end,
	deus_damage_reduction_on_incapacitated = function(arg_171_0, arg_171_1, arg_171_2)
		if ALIVE[arg_171_0] and ScriptUnit.extension(arg_171_0, "status_system"):is_disabled() then
			local var_171_0 = Managers.state.entity:system("buff_system")
			local var_171_1 = arg_171_1.template.buff_to_add

			var_171_0:add_buff(arg_171_0, var_171_1, arg_171_0, false)
		end
	end,
	drop_item_on_ability_use = function(arg_172_0, arg_172_1, arg_172_2)
		local var_172_0 = ScriptUnit.has_extension(arg_172_0, "inventory_system")
		local var_172_1 = ScriptUnit.has_extension(arg_172_0, "buff_system")

		if not var_172_1 or var_172_1:has_buff_type("drop_item_on_ability_use_cooldown") then
			return
		end

		if var_172_0 then
			local var_172_2 = {}
			local var_172_3 = {
				"slot_healthkit",
				"slot_potion",
				"slot_grenade"
			}

			for iter_172_0, iter_172_1 in pairs(var_172_3) do
				local var_172_4 = var_172_0:get_item_data(iter_172_1)

				if var_172_4 then
					local var_172_5 = BackendUtils.get_item_template(var_172_4).pickup_data

					var_172_2[#var_172_2 + 1] = var_172_5

					local var_172_6 = var_172_0:get_additional_items(iter_172_1)

					if var_172_6 then
						for iter_172_2, iter_172_3 in pairs(var_172_6) do
							local var_172_7 = BackendUtils.get_item_template(iter_172_3).pickup_data

							var_172_2[#var_172_2 + 1] = var_172_7
						end
					end
				end
			end

			if #var_172_2 > 0 then
				local var_172_8 = var_172_2[math.random(1, #var_172_2)]
				local var_172_9 = POSITION_LOOKUP[arg_172_0]
				local var_172_10 = Vector3(math.random(-1, 1), math.random(-1, 1), 2)
				local var_172_11 = Vector3.normalize(var_172_10)
				local var_172_12 = var_172_9 + var_172_10 * 0.2

				if NetworkUtils.network_safe_position(var_172_12) then
					local var_172_13 = math.random(-math.half_pi, math.half_pi) / 2
					local var_172_14 = Quaternion.axis_angle(var_172_11, var_172_13)
					local var_172_15 = var_172_8.pickup_name
					local var_172_16 = AllPickups[var_172_15].slot_name
					local var_172_17 = Managers.state.entity:system("audio_system")
					local var_172_18

					if var_172_16 == "slot_healtkit" then
						var_172_18 = "morris_power_ups_clone_medkit"
					elseif var_172_16 == "slot_grenade" then
						var_172_18 = "morris_power_ups_clone_grenade"
					elseif var_172_16 == "slot_potion" then
						var_172_18 = "morris_power_ups_clone_potion"
					end

					var_172_17:play_audio_position_event(var_172_18, var_172_12)

					local var_172_19 = "dropped"
					local var_172_20 = Managers.state.network

					if var_0_6() then
						Managers.state.entity:system("pickup_system"):spawn_pickup(var_172_15, var_172_12, var_172_14, true, var_172_19)
					else
						local var_172_21 = NetworkLookup.pickup_names[var_172_15]
						local var_172_22 = NetworkLookup.pickup_spawn_types[var_172_19]

						var_172_20.network_transmit:send_rpc_server("rpc_spawn_pickup_with_physics", var_172_21, var_172_12, var_172_14, var_172_22)
					end

					local var_172_23 = Managers.state.entity:system("buff_system")
					local var_172_24 = arg_172_1.template.cooldown_buff
					local var_172_25 = arg_172_1.template.cooldown_durations

					var_172_23:add_buff(arg_172_0, var_172_24, arg_172_0, false)

					var_172_1:get_non_stacking_buff("drop_item_on_ability_use_cooldown").duration = var_172_25[var_172_15] or 60
				end
			end
		end
	end,
	apply_held_potion_effect = function(arg_173_0, arg_173_1, arg_173_2)
		if not ALIVE[arg_173_0] then
			return
		end

		local var_173_0 = ScriptUnit.has_extension(arg_173_0, "inventory_system")

		if not var_173_0 then
			return
		end

		local var_173_1 = "slot_potion"
		local var_173_2 = var_173_0:get_item_data(var_173_1)

		if not var_173_2 then
			return
		end

		local var_173_3 = BackendUtils.get_item_template(var_173_2)
		local var_173_4 = {
			var_173_3.actions.action_one.default.buff_template
		}
		local var_173_5 = var_173_0:get_additional_items(var_173_1)

		if var_173_5 then
			for iter_173_0, iter_173_1 in pairs(var_173_5) do
				local var_173_6 = BackendUtils.get_item_template(iter_173_1).actions.action_one.default.buff_template

				var_173_4[#var_173_4 + 1] = var_173_6
			end
		end

		if #var_173_4 > 0 then
			local var_173_7 = var_173_4[math.random(#var_173_4)]

			Managers.state.entity:system("buff_system"):add_buff(arg_173_0, var_173_7, arg_173_0, false)
		end
	end,
	block_procs_parry = function(arg_174_0, arg_174_1, arg_174_2)
		local var_174_0 = ScriptUnit.extension(arg_174_0, "buff_system")
		local var_174_1 = arg_174_2[1]
		local var_174_2 = arg_174_2[2]
		local var_174_3 = arg_174_2[3]

		var_174_0:trigger_procs("on_timed_block", var_174_1, var_174_2, var_174_3)
	end,
	active_ability_for_coins = function(arg_175_0, arg_175_1, arg_175_2)
		local var_175_0 = ScriptUnit.has_extension(arg_175_0, "career_system")

		if var_175_0 then
			local var_175_1 = var_175_0:current_ability_cooldown_percentage()
			local var_175_2 = math.floor(var_175_1 * 100)

			print("Remove Coins:", var_175_2)
		end
	end,
	on_push_explosion = function(arg_176_0, arg_176_1, arg_176_2)
		local var_176_0 = arg_176_1.template
		local var_176_1 = arg_176_2[1]

		if ALIVE[arg_176_0] and ALIVE[var_176_1] then
			local var_176_2 = ScriptUnit.extension(arg_176_0, "career_system")
			local var_176_3 = Managers.state.entity:system("area_damage_system")
			local var_176_4 = Vector3.lerp(POSITION_LOOKUP[arg_176_0], POSITION_LOOKUP[var_176_1], 0.5)
			local var_176_5 = "buff"
			local var_176_6 = var_176_0.explosion_template
			local var_176_7 = Quaternion.identity()
			local var_176_8 = var_176_2:get_career_power_level() * var_176_0.power_scale
			local var_176_9 = 1
			local var_176_10 = false

			var_176_3:create_explosion(arg_176_0, var_176_4, var_176_7, var_176_6, var_176_9, var_176_5, var_176_8, var_176_10)
		end
	end,
	elites_on_kill_explosion = function(arg_177_0, arg_177_1, arg_177_2)
		if not var_0_6() then
			return
		end

		local var_177_0 = arg_177_1.template
		local var_177_1 = arg_177_2[3]
		local var_177_2 = ScriptUnit.has_extension(var_177_1, "health_system")

		if var_177_2 then
			local var_177_3 = var_177_2:recent_damage_source()
			local var_177_4 = var_177_2:recently_damaged()

			if var_177_3 == "buff" and var_177_4 == "grenade" then
				return
			end
		end

		if ALIVE[arg_177_0] and ALIVE[var_177_1] then
			local var_177_5 = ScriptUnit.has_extension(arg_177_0, "career_system")
			local var_177_6 = Managers.state.entity:system("area_damage_system")
			local var_177_7 = POSITION_LOOKUP[var_177_1]
			local var_177_8 = "buff"
			local var_177_9 = var_177_0.explosion_template
			local var_177_10 = Quaternion.identity()
			local var_177_11 = var_177_5:get_career_power_level() * var_177_0.power_scale
			local var_177_12 = 1
			local var_177_13 = false

			var_177_6:create_explosion(arg_177_0, var_177_7, var_177_10, var_177_9, var_177_12, var_177_8, var_177_11, var_177_13)

			local var_177_14 = Managers.state.entity:system("audio_system")
			local var_177_15 = var_177_0.sound_event

			var_177_14:play_audio_unit_event(var_177_15, var_177_1)
		end

		Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_177_0, arg_177_1.server_id)
	end,
	heal_on_dot_damage_dealt = function(arg_178_0, arg_178_1, arg_178_2)
		local var_178_0 = "health_regen"
		local var_178_1 = arg_178_1.template.value

		DamageUtils.heal_network(arg_178_0, arg_178_0, var_178_1, var_178_0)
	end,
	deus_collateral_damage_on_melee_killing_blow_func = function(arg_179_0, arg_179_1, arg_179_2, arg_179_3)
		local var_179_0 = arg_179_1.template
		local var_179_1 = arg_179_2[3]
		local var_179_2 = arg_179_2[1]

		if not var_179_2 then
			return
		end

		if ALIVE[arg_179_0] and ALIVE[var_179_1] then
			local var_179_3 = POSITION_LOOKUP[var_179_1]
			local var_179_4 = var_179_2[DamageDataIndex.DAMAGE_SOURCE_NAME]

			if not var_179_4 then
				return
			end

			local var_179_5 = var_179_2[DamageDataIndex.ATTACK_TYPE]

			if not var_179_5 or var_179_5 ~= "light_attack" and var_179_5 ~= "heavy_attack" then
				return
			end

			local var_179_6 = var_179_2[DamageDataIndex.DAMAGE_TYPE]
			local var_179_7 = var_179_2[DamageDataIndex.DAMAGE_AMOUNT]
			local var_179_8 = var_179_0.max_range
			local var_179_9 = Managers.state.side.side_by_unit[arg_179_0]
			local var_179_10 = var_179_9 and var_179_9.enemy_broadphase_categories
			local var_179_11 = FrameTable.alloc_table()
			local var_179_12 = {}

			for iter_179_0 = 1, 1 do
				local var_179_13 = AiUtils.broadphase_query(var_179_3, var_179_8, var_179_11, var_179_10)

				table.sort(var_179_11, function(arg_180_0, arg_180_1)
					return Vector3.distance_squared(POSITION_LOOKUP[arg_180_0], var_179_3) < Vector3.distance_squared(POSITION_LOOKUP[arg_180_1], var_179_3)
				end)

				for iter_179_1 = 1, var_179_13 do
					local var_179_14 = var_179_11[iter_179_1]

					if HEALTH_ALIVE[var_179_14] and not var_179_12[var_179_14] then
						var_179_12[var_179_14] = true

						DamageUtils.add_damage_network(var_179_14, arg_179_0, var_179_7, "torso", var_179_6, nil, Vector3(1, 0, 0), var_179_4, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, iter_179_0)

						local var_179_15 = Managers.state.entity:system("audio_system")
						local var_179_16 = var_179_0.sound_event

						var_179_15:play_audio_unit_event(var_179_16, var_179_14)

						var_179_3 = POSITION_LOOKUP[var_179_14]

						break
					end
				end
			end
		end
	end,
	deus_special_farm_max_health_on_special = function(arg_181_0, arg_181_1, arg_181_2, arg_181_3)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_181_0] then
			local var_181_0 = (arg_181_1.killed_specials or 0) + 1
			local var_181_1 = arg_181_1.template

			if var_181_0 >= var_181_1.specials_per_pop then
				local var_181_2 = Managers.state.entity:system("buff_system")
				local var_181_3 = var_181_1.buff_to_add

				var_181_2:add_buff(arg_181_0, var_181_3, arg_181_0, true)

				var_181_0 = 0
			end

			arg_181_1.killed_specials = var_181_0
		end
	end,
	deus_transmute_into_coins = function(arg_182_0, arg_182_1, arg_182_2, arg_182_3)
		if var_0_6() then
			local var_182_0 = arg_182_2[2]
			local var_182_1 = arg_182_2[3]

			if var_182_0 == "heavy_attack" and var_182_1 == "head" and math.random(1, 10) == 1 then
				local var_182_2 = arg_182_2[1]
				local var_182_3 = POSITION_LOOKUP[var_182_2]
				local var_182_4 = Vector3(math.random(-1, 1), math.random(-1, 1), 2)
				local var_182_5 = Vector3.normalize(var_182_4)
				local var_182_6 = var_182_3 + var_182_4 * 0.2

				if NetworkUtils.network_safe_position(var_182_6) then
					local var_182_7 = math.random(-math.half_pi, math.half_pi) / 2
					local var_182_8 = Quaternion.axis_angle(var_182_5, var_182_7)
					local var_182_9 = "deus_soft_currency"
					local var_182_10 = "dropped"

					Managers.state.entity:system("pickup_system"):spawn_pickup(var_182_9, var_182_6, var_182_8, true, var_182_10)

					local var_182_11 = arg_182_0
					local var_182_12 = "buff"
					local var_182_13 = "generic_mutator_explosion"
					local var_182_14 = ExplosionUtils.get_template(var_182_13)

					DamageUtils.create_explosion(arg_182_3, var_182_11, var_182_6, Quaternion.identity(), var_182_14, 1, var_182_12, var_0_6(), false, var_182_2, 0, false)

					local var_182_15 = Managers.state.entity:system("audio_system")
					local var_182_16 = arg_182_1.template.sound_event

					var_182_15:play_audio_unit_event(var_182_16, var_182_2)

					local var_182_17 = Managers.state.unit_storage:go_id(var_182_11)
					local var_182_18 = NetworkLookup.explosion_templates[var_182_13]
					local var_182_19 = NetworkLookup.damage_sources[var_182_12]

					Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_182_17, false, var_182_6, Quaternion.identity(), var_182_18, 1, var_182_19, 0, false, var_182_17)

					local var_182_20 = BLACKBOARDS[var_182_2]

					Managers.state.conflict:destroy_unit(var_182_2, var_182_20, "buff")
				end
			end
		end
	end,
	always_blocking_weapon_swap = function(arg_183_0, arg_183_1, arg_183_2, arg_183_3)
		arg_183_1.equipment = arg_183_2[1]
		arg_183_1.swapped_weapons = true
	end,
	always_blocking_temporarily_remove = function(arg_184_0, arg_184_1, arg_184_2, arg_184_3)
		local var_184_0 = ScriptUnit.extension(arg_184_0, "buff_system")
		local var_184_1 = "deus_always_blocking_lock_out"

		var_184_0:add_buff(var_184_1)
	end,
	deus_reckless_swings_buff_on_hit = function(arg_185_0, arg_185_1, arg_185_2, arg_185_3)
		if var_0_6() then
			local var_185_0 = arg_185_2[4]
			local var_185_1 = arg_185_2[2] == "light_attack" or arg_185_2[2] == "heavy_attack"

			if var_185_0 <= 1 and var_185_1 then
				local var_185_2 = arg_185_1.template
				local var_185_3 = var_185_2.damage_to_deal

				if var_185_2.is_non_lethal then
					local var_185_4 = ScriptUnit.has_extension(arg_185_0, "health_system")

					if var_185_4 then
						local var_185_5 = var_185_4:current_health()

						var_185_3 = math.clamp(var_185_3, 0, math.max(var_185_5 - 0.25, 0))
						var_185_3 = DamageUtils.networkify_damage(var_185_3)
					else
						var_185_3 = 0
					end
				end

				if var_185_3 > 0 then
					DamageUtils.add_damage_network(arg_185_0, arg_185_0, var_185_3, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_185_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end
			end
		end
	end,
	grenade_explode_buff_area = function(arg_186_0, arg_186_1, arg_186_2)
		if not var_0_6() then
			return
		end

		local var_186_0

		var_186_0.buff_area_position, var_186_0 = arg_186_2[2], FrameTable.alloc_table()

		ScriptUnit.extension(arg_186_0, "buff_system"):add_buff(arg_186_1.template.buff_to_add, var_186_0)
	end,
	cursed_chest_area_buff = function(arg_187_0, arg_187_1, arg_187_2)
		if not var_0_6() then
			return
		end

		local var_187_0

		var_187_0.buff_area_position, var_187_0 = Unit.world_position(arg_187_2[1], 0), FrameTable.alloc_table()

		ScriptUnit.extension(arg_187_0, "buff_system"):add_buff(arg_187_1.template.buff_to_add, var_187_0)
	end,
	spawn_drones_proc = function(arg_188_0, arg_188_1, arg_188_2)
		local var_188_0 = arg_188_1.template.num_drones
		local var_188_1 = arg_188_1.template.radius
		local var_188_2 = arg_188_1.template.damage_profile_name

		var_0_13(arg_188_0, var_188_0, var_188_1, var_188_2)
	end,
	spawn_drones_proc_headshot = function(arg_189_0, arg_189_1, arg_189_2)
		if arg_189_2[4] ~= "head" then
			return
		end

		ProcFunctions.spawn_drones_proc(arg_189_0, arg_189_1, arg_189_2)
	end,
	spawn_drones_proc_ability = function(arg_190_0, arg_190_1, arg_190_2)
		if arg_190_2[1] ~= arg_190_0 then
			return
		end

		ProcFunctions.spawn_drones_proc(arg_190_0, arg_190_1, arg_190_2)
	end,
	boon_range_02_delayed_add_on_hit = function(arg_191_0, arg_191_1, arg_191_2)
		local var_191_0 = arg_191_2[1]
		local var_191_1 = ScriptUnit.has_extension(var_191_0, "buff_system")

		if var_191_1 then
			arg_191_1.cached_params = arg_191_1.cached_params or {
				attacker_unit = arg_191_0
			}

			var_191_1:add_buff("boon_range_02_buff_adder", arg_191_1.cached_params)
		end
	end,
	boon_range_02_damage_check = function(arg_192_0, arg_192_1, arg_192_2)
		local var_192_0 = arg_192_2[1]
		local var_192_1 = ScriptUnit.has_extension(var_192_0, "buff_system")

		if var_192_1 then
			local var_192_2 = var_192_1:get_stacking_buff("boon_range_02_increased_damage_tracker")

			if var_192_2 then
				for iter_192_0 = 1, #var_192_2 do
					if var_192_2[iter_192_0].attacker_unit == arg_192_0 then
						arg_192_1.cached_params = arg_192_1.cached_params or {
							attacker_unit = arg_192_0
						}

						var_192_1:add_buff("boon_range_02_damage_amplifier", arg_192_1.cached_params)

						break
					end
				end
			end
		end
	end,
	boon_range_02_damage_cleanup = function(arg_193_0, arg_193_1, arg_193_2)
		local var_193_0 = arg_193_2[1]
		local var_193_1 = ScriptUnit.has_extension(var_193_0, "buff_system")

		if var_193_1 then
			local var_193_2 = var_193_1:get_stacking_buff("boon_range_02_damage_amplifier")

			if var_193_2 then
				for iter_193_0 = #var_193_2, 1, -1 do
					local var_193_3 = var_193_2[iter_193_0]

					if var_193_3.attacker_unit == arg_193_0 then
						var_193_1:remove_buff(var_193_3.id)
					end
				end
			end
		end
	end,
	deus_big_swing_stagger_on_hit = function(arg_194_0, arg_194_1, arg_194_2, arg_194_3)
		if ALIVE[arg_194_0] then
			local var_194_0 = arg_194_2[4]
			local var_194_1 = arg_194_1.template
			local var_194_2 = var_194_1.targets_to_hit
			local var_194_3 = arg_194_2[2] == "light_attack" or arg_194_2[2] == "heavy_attack"

			if var_194_2 <= var_194_0 and var_194_3 then
				local var_194_4 = ScriptUnit.extension(arg_194_0, "buff_system")
				local var_194_5 = var_194_1.buff_to_add

				var_194_4:add_buff(var_194_5)
			end
		end
	end,
	deus_push_charge = function(arg_195_0, arg_195_1, arg_195_2, arg_195_3)
		if ALIVE[arg_195_0] then
			local var_195_0 = ScriptUnit.extension(arg_195_0, "status_system")

			if var_195_0.do_lunge then
				return
			end

			local var_195_1 = arg_195_1.template
			local var_195_2 = var_195_1.lunge_settings
			local var_195_3 = var_195_1.sound_event

			WwiseUtils.trigger_unit_event(arg_195_3, var_195_3, arg_195_0, 0)

			var_195_0.do_lunge = {
				animation_end_event = "dodge_bwd",
				allow_rotation = false,
				first_person_animation_end_event = "dodge_bwd",
				first_person_hit_animation_event = "charge_react",
				dodge = true,
				first_person_animation_event = "dodge_bwd",
				first_person_animation_end_event_hit = "dodge_bwd",
				noclip = true,
				animation_event = "dodge_bwd",
				initial_speed = var_195_2.initial_speed,
				falloff_to_speed = var_195_2.falloff_to_speed,
				duration = var_195_2.duration
			}
		end
	end,
	deus_target_full_health_damage_mult = function(arg_196_0, arg_196_1, arg_196_2, arg_196_3, arg_196_4)
		local var_196_0 = arg_196_2[arg_196_4.attacked_unit]

		if ALIVE[arg_196_0] and ALIVE[var_196_0] then
			local var_196_1 = arg_196_1.template
			local var_196_2 = arg_196_2[arg_196_4.buff_attack_type]
			local var_196_3 = var_196_1.valid_attack_types

			if var_196_3 and var_196_3[var_196_2] then
				local var_196_4 = arg_196_2[arg_196_4.PROC_MODIFIABLE]
				local var_196_5 = ScriptUnit.has_extension(var_196_0, "health_system")

				if var_196_5 and var_196_5:current_health_percent() >= 1 then
					var_196_4.damage_amount = var_196_4.damage_amount * var_196_1.damage_mult
				end
			end
		end
	end,
	deus_damage_source_damage_mult = function(arg_197_0, arg_197_1, arg_197_2, arg_197_3, arg_197_4)
		local var_197_0 = arg_197_2[arg_197_4.attacked_unit]

		if ALIVE[arg_197_0] and ALIVE[var_197_0] then
			local var_197_1 = arg_197_1.template
			local var_197_2 = arg_197_2[arg_197_4.damage_source]
			local var_197_3 = var_197_1.valid_damage_sources

			if var_197_3 and var_197_3[var_197_2] then
				local var_197_4 = arg_197_2[arg_197_4.PROC_MODIFIABLE]

				var_197_4.damage_amount = var_197_4.damage_amount * var_197_1.damage_mult
			end
		end
	end,
	triple_melee_headshot_power_counter = function(arg_198_0, arg_198_1, arg_198_2, arg_198_3)
		local var_198_0 = arg_198_2[3]
		local var_198_1 = arg_198_2[2]

		if var_198_1 ~= "light_attack" and var_198_1 ~= "heavy_attack" then
			return
		end

		if var_198_0 == "head" then
			arg_198_1.stacks = arg_198_1.stacks and arg_198_1.stacks + 1 or 1

			if arg_198_1.stacks >= arg_198_1.template.hits then
				local var_198_2 = Managers.state.entity:system("buff_system")
				local var_198_3 = arg_198_1.template.buff_to_add

				var_198_2:add_buff(arg_198_0, var_198_3, arg_198_0, false)

				arg_198_1.stacks = 0
			end
		else
			arg_198_1.stacks = 0
		end
	end,
	melee_killing_spree_speed_counter = function(arg_199_0, arg_199_1, arg_199_2, arg_199_3)
		if not var_0_3(arg_199_0) then
			return
		end

		local var_199_0 = arg_199_2[1]

		if not var_199_0 then
			return
		end

		local var_199_1 = var_199_0[DamageDataIndex.ATTACK_TYPE]

		if not var_199_1 or var_199_1 ~= "light_attack" and var_199_1 ~= "heavy_attack" then
			return
		end

		local var_199_2 = Managers.time:time("game")

		arg_199_1.kills = arg_199_1.kills or {}
		arg_199_1.kills[#arg_199_1.kills + 1] = var_199_2 + arg_199_1.template.time

		if #arg_199_1.kills >= arg_199_1.template.kills then
			local var_199_3 = Managers.state.entity:system("buff_system")
			local var_199_4 = arg_199_1.template.buff_to_add

			var_199_3:add_buff(arg_199_0, var_199_4, arg_199_0, false)

			local var_199_5 = "hud_gameplay_stance_smiter_buff"
			local var_199_6 = "Play_potion_morris_effect_end"

			WwiseUtils.trigger_unit_event(arg_199_3, var_199_5, arg_199_0, 0)
			WwiseUtils.trigger_unit_event(arg_199_3, var_199_6, arg_199_0, 0)

			arg_199_1.kills = {}
		end
	end,
	transfer_temp_health_at_full = function(arg_200_0, arg_200_1, arg_200_2, arg_200_3)
		local var_200_0 = arg_200_2[3]
		local var_200_1 = arg_200_2[1] == arg_200_0
		local var_200_2 = ScriptUnit.extension(arg_200_0, "status_system")

		if var_200_1 and not var_200_2:is_permanent_heal(var_200_0) and ScriptUnit.extension(arg_200_0, "health_system"):current_health_percent() == 1 then
			local var_200_3 = arg_200_2[2]
			local var_200_4 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
			local var_200_5
			local var_200_6 = math.huge
			local var_200_7 = POSITION_LOOKUP[arg_200_0]
			local var_200_8 = arg_200_1.template.range

			for iter_200_0 = 1, #var_200_4 do
				local var_200_9 = var_200_4[iter_200_0]

				if var_200_9 ~= arg_200_0 then
					local var_200_10 = ScriptUnit.has_extension(var_200_9, "health_system")
					local var_200_11 = var_200_10 and var_200_10:current_health_percent()

					if var_200_11 and var_200_11 < 1 then
						local var_200_12 = POSITION_LOOKUP[var_200_9]
						local var_200_13 = Vector3.distance_squared(var_200_7, var_200_12)

						if var_200_13 < var_200_8 * var_200_8 and var_200_13 < var_200_6 then
							var_200_5 = var_200_9
							var_200_6 = var_200_8
						end
					end
				end
			end

			if var_200_5 then
				DamageUtils.heal_network(var_200_5, arg_200_0, var_200_3, "heal_from_proc")
			end
		end
	end,
	last_player_standing_knocked_down_check = function(arg_201_0, arg_201_1, arg_201_2)
		local var_201_0 = ScriptUnit.extension(arg_201_0, "status_system")

		if HEALTH_ALIVE[arg_201_0] and not var_201_0:is_knocked_down() then
			local var_201_1 = true
			local var_201_2 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

			for iter_201_0, iter_201_1 in ipairs(var_201_2) do
				if iter_201_1 ~= arg_201_0 then
					local var_201_3 = ScriptUnit.extension(iter_201_1, "status_system"):is_knocked_down()

					if HEALTH_ALIVE[iter_201_1] and not var_201_3 then
						var_201_1 = false
					end
				end
			end

			if var_201_1 then
				local var_201_4 = arg_201_1.template.buff_to_add

				Managers.state.entity:system("buff_system"):add_buff(arg_201_0, var_201_4, arg_201_0, false)
			end
		end
	end,
	friendly_cooldown_on_ability = function(arg_202_0, arg_202_1, arg_202_2)
		if arg_202_0 ~= arg_202_2[1] then
			return
		end

		local var_202_0 = arg_202_1.template
		local var_202_1 = var_202_0.value
		local var_202_2 = var_202_0.range
		local var_202_3 = arg_202_2[2]
		local var_202_4 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
		local var_202_5 = POSITION_LOOKUP[arg_202_0]

		for iter_202_0, iter_202_1 in pairs(var_202_4) do
			if arg_202_0 ~= iter_202_1 then
				local var_202_6 = POSITION_LOOKUP[iter_202_1]

				if Vector3.distance_squared(var_202_5, var_202_6) < var_202_2 * var_202_2 then
					local var_202_7 = Managers.state.unit_storage:go_id(iter_202_1)

					if var_202_7 then
						Managers.state.network.network_transmit:send_rpc_server("rpc_server_reduce_activated_ability_cooldown_percent", var_202_7, var_202_1, var_202_3, true)
					end
				end
			end
		end
	end,
	deus_second_wind_on_hit = function(arg_203_0, arg_203_1, arg_203_2)
		if not var_0_6() then
			return
		end

		if ALIVE[arg_203_0] then
			local var_203_0 = arg_203_1.template
			local var_203_1 = ScriptUnit.extension(arg_203_0, "buff_system")

			if var_203_1:has_buff_perk("invulnerable") then
				return
			end

			local var_203_2 = ScriptUnit.has_extension(arg_203_0, "health_system")
			local var_203_3 = var_203_0.health_threshold
			local var_203_4 = var_203_2:current_health()
			local var_203_5 = var_203_2:get_max_health()
			local var_203_6 = arg_203_2[2]
			local var_203_7 = (var_203_4 - var_203_6) / var_203_5

			if var_203_7 <= 0 and var_203_1:has_buff_perk("ignore_death") then
				return
			end

			local var_203_8 = arg_203_2[3]
			local var_203_9 = var_203_1:get_non_stacking_buff("deus_second_wind_cooldown")

			if var_203_7 < var_203_3 and not var_203_9 and var_203_8 ~= "life_tap" then
				local var_203_10 = var_203_7 > 0 and var_203_6 or var_203_4 - 1

				DamageUtils.add_damage_network(arg_203_0, arg_203_0, var_203_10, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_203_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)

				local var_203_11 = var_203_0.buffs_to_add
				local var_203_12 = Managers.state.entity:system("buff_system")

				for iter_203_0 = 1, #var_203_11 do
					local var_203_13 = var_203_11[iter_203_0]

					var_203_12:add_buff(arg_203_0, var_203_13, arg_203_0, false)
				end
			end
		end
	end,
	deus_guard_buff_on_damage = function(arg_204_0, arg_204_1, arg_204_2)
		if not var_0_6() then
			return
		end

		if ALIVE[arg_204_0] then
			local var_204_0 = arg_204_1.attacker_unit
			local var_204_1 = arg_204_2[1]
			local var_204_2 = arg_204_2[2]
			local var_204_3 = arg_204_2[3]

			if arg_204_0 ~= var_204_0 and var_204_3 ~= "life_tap" then
				local var_204_4 = ScriptUnit.extension(var_204_0, "buff_system")
				local var_204_5 = var_204_4:apply_buffs_to_value(1, "damage_taken")

				if var_204_4:has_buff_type("deus_guard_buff") then
					var_204_5 = var_204_5 / -arg_204_1.template.multiplier
				end

				local var_204_6 = var_204_2 * var_204_5

				if var_204_6 > 0 then
					DamageUtils.add_damage_network(var_204_0, var_204_1, var_204_6, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_204_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end
			end
		end
	end,
	deus_cooldown_reg_not_hit_damage_taken = function(arg_205_0, arg_205_1, arg_205_2)
		if not Managers.state.network.is_server then
			return
		end

		if arg_205_2[3] == arg_205_0 then
			return
		end

		arg_205_1.reset = true
	end,
	start_ledge_rescue_timer = function(arg_206_0, arg_206_1, arg_206_2)
		local var_206_0 = arg_206_1.template

		arg_206_1.rescue_timer = Managers.time:time("main") + var_206_0.rescue_delay
	end,
	start_disable_rescue_timer = function(arg_207_0, arg_207_1, arg_207_2)
		local var_207_0 = arg_207_1.template

		if var_207_0.rescuable_disable_types[arg_207_2[1]] then
			arg_207_1.rescue_timer = Managers.time:time("main") + var_207_0.rescue_delay
		end
	end,
	play_particle_effect = function(arg_208_0, arg_208_1, arg_208_2)
		local var_208_0 = arg_208_1.template.particle_fx
		local var_208_1 = Application.main_world()

		World.create_particles(var_208_1, var_208_0, POSITION_LOOKUP[arg_208_0])
	end,
	remove_linked_unit = function(arg_209_0, arg_209_1, arg_209_2)
		if arg_209_1.linked_unit then
			World.unlink_unit(Unit.world(arg_209_1.linked_unit), arg_209_1.linked_unit)
			Managers.state.unit_spawner:mark_for_deletion(arg_209_1.linked_unit)

			arg_209_1.linked_unit = nil
		end
	end,
	melee_wave_effect = function(arg_210_0, arg_210_1, arg_210_2)
		if not var_0_6() then
			return
		end

		if not ALIVE[arg_210_0] then
			return
		end

		local var_210_0 = arg_210_2[5]

		if var_210_0 ~= "MELEE_1H" and var_210_0 ~= "MELEE_2H" then
			return
		end

		if arg_210_2[4] ~= 1 then
			return
		end

		local var_210_1 = arg_210_1.parent_buff_shared_table.server_buff_ids

		if not var_210_1 then
			return
		end

		local var_210_2 = var_210_1[#var_210_1]

		if var_210_2 then
			local var_210_3 = arg_210_2[1]
			local var_210_4 = arg_210_1.template
			local var_210_5 = ExplosionUtils.get_template(var_210_4.explosion_template)
			local var_210_6 = Managers.world:world("level_world")
			local var_210_7 = POSITION_LOOKUP[var_210_3]
			local var_210_8 = Quaternion.identity()
			local var_210_9 = ScriptUnit.has_extension(arg_210_0, "career_system"):get_career_power_level()

			DamageUtils.create_explosion(var_210_6, arg_210_0, var_210_7, var_210_8, var_210_5, 1, "buff", var_0_6(), var_0_7(arg_210_0), arg_210_0, var_210_9, false)
			Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_210_0, var_210_2)

			var_210_1[#var_210_1] = nil
		end

		return true
	end,
	add_melee_wave_stacks = function(arg_211_0, arg_211_1, arg_211_2)
		if not var_0_6() then
			return
		end

		if arg_211_0 ~= arg_211_2[1] then
			return
		end

		if ALIVE[arg_211_0] then
			local var_211_0 = arg_211_1.template.stacks_to_add or 1
			local var_211_1 = arg_211_1.template.buff_to_add
			local var_211_2 = ScriptUnit.has_extension(arg_211_0, "buff_system")
			local var_211_3 = Managers.state.entity:system("buff_system")

			for iter_211_0 = 1, var_211_0 do
				if var_211_2:num_buff_type(var_211_1) < BuffUtils.get_buff_template(var_211_1).buffs[1].max_stacks then
					local var_211_4 = var_211_3:add_buff(arg_211_0, var_211_1, arg_211_0, true)
					local var_211_5 = arg_211_1.parent_buff_shared_table
					local var_211_6 = var_211_5.server_buff_ids

					if not var_211_6 then
						var_211_5.server_buff_ids = {
							var_211_4
						}
					else
						var_211_6[#var_211_6 + 1] = var_211_4
					end
				end
			end
		end
	end,
	career_ability_apply_dot_to_adjecent_enemies = function(arg_212_0, arg_212_1, arg_212_2)
		assert(var_0_6(), "'career_ability_apply_dot_to_adjecent_enemies' is a server only buff func")

		if arg_212_2[1] ~= arg_212_0 then
			return
		end

		local var_212_0 = arg_212_1.template

		arg_212_1.params = arg_212_1.params or {}
		arg_212_1.params.attacker_unit = arg_212_0
		arg_212_1.cached_broadphase = arg_212_1.cached_broadphase or {}

		local var_212_1 = Managers.state.side.side_by_unit[arg_212_0]
		local var_212_2 = AiUtils.broadphase_query(POSITION_LOOKUP[arg_212_0], var_212_0.area_radius, arg_212_1.cached_broadphase, var_212_1.enemy_broadphase_categories)
		local var_212_3 = "full"
		local var_212_4 = "buff"
		local var_212_5
		local var_212_6
		local var_212_7
		local var_212_8
		local var_212_9
		local var_212_10

		arg_212_1.cached_custom_dot = arg_212_1.cached_custom_dot or {
			dot_template_name = var_212_0.dot_template_name
		}

		for iter_212_0 = 1, var_212_2 do
			local var_212_11 = arg_212_1.cached_broadphase[iter_212_0]

			DamageUtils.apply_dot(var_212_5, var_212_6, var_212_7, var_212_11, arg_212_0, var_212_3, var_212_4, var_212_8, var_212_9, var_212_10, arg_212_0, arg_212_1.cached_custom_dot)
		end
	end,
	boon_dot_burning_01_spread = function(arg_213_0, arg_213_1, arg_213_2)
		local var_213_0 = arg_213_2[3]

		if not Managers.state.status_effect:unit_is_burning(var_213_0) then
			return
		end

		local var_213_1 = arg_213_1.template

		arg_213_1.cached_broadphase = arg_213_1.cached_broadphase or {}

		local var_213_2 = Managers.state.side.side_by_unit[arg_213_0]
		local var_213_3 = AiUtils.broadphase_query(POSITION_LOOKUP[var_213_0], var_213_1.area_radius, arg_213_1.cached_broadphase, var_213_2.enemy_broadphase_categories)
		local var_213_4 = "full"
		local var_213_5 = "buff"
		local var_213_6
		local var_213_7
		local var_213_8
		local var_213_9
		local var_213_10
		local var_213_11

		arg_213_1.cached_custom_dot = arg_213_1.cached_custom_dot or {
			dot_template_name = var_213_1.dot_template_name
		}

		for iter_213_0 = 1, var_213_3 do
			local var_213_12 = arg_213_1.cached_broadphase[iter_213_0]

			if var_213_12 ~= var_213_0 then
				DamageUtils.apply_dot(var_213_6, var_213_7, var_213_8, var_213_12, arg_213_0, var_213_4, var_213_5, var_213_9, var_213_10, var_213_11, arg_213_0, arg_213_1.cached_custom_dot)
			end
		end
	end,
	lightning_adjecent_enemies = function(arg_214_0, arg_214_1, arg_214_2)
		local var_214_0 = arg_214_2[1]

		if not var_0_3(arg_214_0) or not ALIVE[arg_214_0] or arg_214_0 ~= var_214_0 then
			return
		end

		local var_214_1 = arg_214_1.template
		local var_214_2 = FrameTable.alloc_table()
		local var_214_3 = Managers.state.side.side_by_unit[arg_214_0]
		local var_214_4 = AiUtils.broadphase_query(POSITION_LOOKUP[arg_214_0], var_214_1.area_radius, var_214_2, var_214_3.enemy_broadphase_categories)

		for iter_214_0 = 1, var_214_4 do
			local var_214_5 = var_214_2[iter_214_0]
			local var_214_6 = var_214_1.hit_zone or arg_214_1.hit_zone_name or "full"
			local var_214_7 = var_214_1.damage_source or "buff"
			local var_214_8 = arg_214_1.power_level or DefaultPowerLevel
			local var_214_9 = var_214_1.damage_profile_name or "default"
			local var_214_10 = DamageProfileTemplates[var_214_9]
			local var_214_11
			local var_214_12 = false
			local var_214_13
			local var_214_14
			local var_214_15 = var_214_10.targets and var_214_10.targets[var_214_11] or var_214_10.default_target
			local var_214_16 = var_214_15.damage_type
			local var_214_17 = BoostCurves[var_214_15.boost_curve_type]
			local var_214_18 = DamageUtils.calculate_damage(DamageOutput, var_214_5, arg_214_0, var_214_6, var_214_8, var_214_17, var_214_14, var_214_12, var_214_10, var_214_11, var_214_13, var_214_7)

			DamageUtils.add_damage_network(var_214_5, arg_214_0, var_214_18, "torso", var_214_16, nil, Vector3(1, 0, 0), var_214_7, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)

			local var_214_19 = Managers.state.entity:system("area_damage_system")
			local var_214_20 = POSITION_LOOKUP[var_214_5]
			local var_214_21 = Quaternion.identity()
			local var_214_22 = var_214_1.explosion_template
			local var_214_23 = 1

			var_214_19:create_explosion(arg_214_0, var_214_20, var_214_21, var_214_22, var_214_23, var_214_7, var_214_8, var_214_12)

			local var_214_24 = NetworkLookup.effects[var_214_1.fx]
			local var_214_25 = POSITION_LOOKUP[arg_214_0] + 0.5 * Vector3.up()
			local var_214_26
			local var_214_27 = Unit.has_node(var_214_5, "j_spine") and Unit.node(var_214_5, "j_spine")

			if var_214_27 then
				var_214_26 = Unit.world_position(var_214_5, var_214_27)
			else
				var_214_26 = POSITION_LOOKUP[var_214_5] + 0.5 * Vector3.up()
			end

			local var_214_28 = Vector3.distance(var_214_26, var_214_25)
			local var_214_29 = Vector3(1, var_214_28, 0)
			local var_214_30 = Quaternion.look(var_214_26 - var_214_25)

			if var_0_6() then
				Managers.state.network:rpc_play_particle_effect_with_variable(nil, var_214_24, var_214_25, var_214_30, "distance", var_214_29)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect_with_variable", var_214_24, var_214_25, var_214_30, "distance", var_214_29)
			end
		end

		if var_214_4 > 0 then
			local var_214_31 = Managers.state.entity:system("audio_system")
			local var_214_32 = var_214_1.sound_event

			var_214_31:play_audio_unit_event(var_214_32, arg_214_0)
		end

		return true
	end,
	reduce_activated_ability_cooldown_on_block = function(arg_215_0, arg_215_1, arg_215_2)
		if ALIVE[arg_215_0] then
			ScriptUnit.extension(arg_215_0, "career_system"):reduce_activated_ability_cooldown(arg_215_1.bonus)
		end
	end,
	shield_splinters_explosion = function(arg_216_0, arg_216_1, arg_216_2)
		local var_216_0 = Managers.state.entity:system("area_damage_system")
		local var_216_1 = arg_216_2[1]
		local var_216_2 = Unit.local_position(var_216_1, 0) + Vector3(0, 0, 1)
		local var_216_3 = Unit.local_rotation(arg_216_0, 0)
		local var_216_4 = arg_216_1.template.explosion_template
		local var_216_5 = ScriptUnit.has_extension(arg_216_0, "career_system"):get_career_power_level()

		var_216_0:create_explosion(arg_216_0, var_216_2, var_216_3, var_216_4, 1, "undefined", var_216_5, false)
	end,
	home_run_sound = function(arg_217_0, arg_217_1, arg_217_2)
		local var_217_0 = arg_217_1.template
		local var_217_1 = arg_217_1.cooldown_over_at or 0
		local var_217_2 = Managers.time:time("main")

		if ALIVE[arg_217_0] and var_217_1 <= var_217_2 then
			arg_217_1.cooldown_over_at = var_217_2 + var_217_0.cooldown

			local var_217_3 = Managers.world:world("level_world")
			local var_217_4 = var_217_0.sound_event

			WwiseUtils.trigger_unit_event(var_217_3, var_217_4, arg_217_0, 0)
		end
	end,
	detect_weakness_on_kill = function(arg_218_0, arg_218_1, arg_218_2)
		local var_218_0 = arg_218_2[3]
		local var_218_1 = ScriptUnit.extension(var_218_0, "buff_system")

		if var_218_1 then
			local var_218_2 = arg_218_1.template.mark_buff

			if var_218_1:has_buff_type(var_218_2) then
				local var_218_3 = Managers.state.entity:system("buff_system")
				local var_218_4 = arg_218_1.template.kill_buff

				var_218_3:add_buff(arg_218_0, var_218_4, arg_218_0)
			end
		end
	end,
	remove_attach_particle = function(arg_219_0, arg_219_1, arg_219_2)
		if arg_219_1.fx_id then
			local var_219_0 = Application.main_world()

			World.stop_spawning_particles(var_219_0, arg_219_1.fx_id)
		end
	end,
	pyrotechnical_echo_on_grenade_exploded = function(arg_220_0, arg_220_1, arg_220_2)
		arg_220_1.queued_explosions = arg_220_1.queued_explosions or {}

		local var_220_0 = arg_220_1.template.explosion_delay
		local var_220_1 = Managers.time:time("main")
		local var_220_2 = arg_220_2[1]
		local var_220_3 = Vector3Box(arg_220_2[2])
		local var_220_4 = arg_220_2[3]
		local var_220_5 = arg_220_2[4]
		local var_220_6 = QuaternionBox(arg_220_2[5])
		local var_220_7 = arg_220_2[6]
		local var_220_8 = arg_220_2[7]
		local var_220_9 = var_220_1 + var_220_0

		arg_220_1.queued_explosions[#arg_220_1.queued_explosions + 1] = {
			impact_data = var_220_2,
			hit_position = var_220_3,
			is_critical_strike = var_220_4,
			item_name = var_220_5,
			rotation = var_220_6,
			scale = var_220_7,
			power_level = var_220_8,
			new_explosion_time = var_220_9
		}

		return true
	end,
	blazing_revenge_on_knocked_down = function(arg_221_0, arg_221_1, arg_221_2, arg_221_3)
		if not var_0_6() then
			return
		end

		local var_221_0 = arg_221_1.template
		local var_221_1 = var_221_0.sound_start_event

		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_221_1, arg_221_0)

		local var_221_2 = POSITION_LOOKUP[arg_221_0]
		local var_221_3 = var_221_0.explosion_template
		local var_221_4 = ExplosionUtils.get_template(var_221_3)
		local var_221_5 = var_221_4.aoe.radius
		local var_221_6 = "buff"

		arg_221_1.parent_buff_shared_table.aoe_unit = DamageUtils.create_aoe(arg_221_3, arg_221_0, var_221_2, var_221_6, var_221_4, var_221_5)
	end,
	blazing_revenge_clear_aoe = function(arg_222_0, arg_222_1, arg_222_2)
		if not var_0_6() then
			return
		end

		local var_222_0 = arg_222_1.template.sound_end_event

		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_222_0, arg_222_0)

		local var_222_1 = arg_222_1.parent_buff_shared_table.aoe_unit

		if var_222_1 and Unit.alive(var_222_1) then
			Managers.state.unit_spawner:mark_for_deletion(var_222_1)
		end
	end,
	cluster_barrel_on_barrel_exploded = function(arg_223_0, arg_223_1, arg_223_2)
		if not var_0_6() then
			return
		end

		local var_223_0 = arg_223_2[4]

		if Unit.get_data(var_223_0, "is_cluster_barrel") then
			return
		end

		local var_223_1 = arg_223_1.template
		local var_223_2 = arg_223_2[1] + Vector3.up() * 0.1
		local var_223_3 = var_223_1.explode_time
		local var_223_4 = var_223_1.random_explosion_delay
		local var_223_5 = var_223_1.item_name
		local var_223_6 = var_223_1.fuse_time
		local var_223_7 = var_223_1.barrel_count
		local var_223_8 = var_223_1.max_horizontal_velocity
		local var_223_9 = var_223_1.vertical_velocity

		for iter_223_0 = 1, var_223_7 do
			local var_223_10 = Vector3(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1)
			local var_223_11 = Quaternion.look(var_223_10)
			local var_223_12 = Vector3(math.random() * var_223_8 * 2 - var_223_8, math.random() * var_223_8 * 2 - var_223_8, var_223_9)
			local var_223_13 = var_0_12(var_223_5, var_223_2, var_223_11, var_223_12, var_223_3, var_223_6, var_223_4, arg_223_0)

			Unit.set_data(var_223_13, "is_cluster_barrel", true)
		end
	end,
	add_buffs_on_melee_headshot = function(arg_224_0, arg_224_1, arg_224_2)
		if Unit.alive(arg_224_0) then
			local var_224_0 = arg_224_2[3]
			local var_224_1 = arg_224_2[5]

			if var_224_0 and (var_224_0 == "head" or var_224_0 == "neck") and var_224_1 and (var_224_1 == "MELEE_1H" or var_224_1 == "MELEE_2H") then
				local var_224_2 = arg_224_1.template
				local var_224_3 = ScriptUnit.extension(arg_224_0, "buff_system")
				local var_224_4 = var_224_2.blocker_buff

				if var_224_4 and var_224_3:has_buff_type(var_224_4) then
					return
				end

				local var_224_5 = var_224_2.buffs_to_add

				for iter_224_0 = 1, #var_224_5 do
					local var_224_6 = var_224_5[iter_224_0]

					Managers.state.entity:system("buff_system"):add_buff(arg_224_0, var_224_6, arg_224_0)
				end
			end
		end
	end,
	invigorating_strike_on_damage_dealt = function(arg_225_0, arg_225_1, arg_225_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_225_0 = arg_225_2[3]
		local var_225_1 = arg_225_2[9]
		local var_225_2 = rawget(ItemMasterList, var_225_1)

		if var_225_2 and (var_225_2.slot_type == "melee" or var_225_2.slot_type == "ranged") then
			local var_225_3 = ScriptUnit.has_extension(arg_225_0, "buff_system")
			local var_225_4 = arg_225_1.template
			local var_225_5 = var_225_4.cooldown_buff

			if not (var_225_3 and var_225_3:get_non_stacking_buff(var_225_5)) then
				local var_225_6 = var_225_0 * var_225_4.damage_to_heal_conversion_multiplier

				DamageUtils.heal_network(arg_225_0, arg_225_0, var_225_6, "heal_from_proc")
				Managers.state.entity:system("buff_system"):add_buff(arg_225_0, var_225_5, arg_225_0)
			end
		end
	end,
	staggering_force_on_stagger = function(arg_226_0, arg_226_1, arg_226_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_226_0] then
			local var_226_0 = arg_226_1.template
			local var_226_1 = var_226_0.enemy_count
			local var_226_2 = arg_226_2[8]

			if var_226_2 and var_226_1 <= var_226_2 then
				local var_226_3 = var_226_0.buff_to_add

				Managers.state.entity:system("buff_system"):add_buff(arg_226_0, var_226_3, arg_226_0)
			end
		end
	end,
	refilling_shot_on_critical_hit = function(arg_227_0, arg_227_1, arg_227_2)
		if not var_0_3(arg_227_0) or not ALIVE[arg_227_0] then
			return
		end

		local var_227_0 = arg_227_1.parent_buff_shared_table
		local var_227_1 = var_227_0.ammo_used_extension

		if var_227_1 and var_227_1 then
			local var_227_2 = var_227_0.ammo_used

			var_227_1:add_ammo_to_clip(var_227_2)
		end
	end,
	refilling_shot_on_start_action = function(arg_228_0, arg_228_1, arg_228_2)
		if not var_0_3(arg_228_0) or not ALIVE[arg_228_0] then
			return
		end

		local var_228_0 = arg_228_1.parent_buff_shared_table

		var_228_0.ammo_used_extension = nil
		var_228_0.ammo_used = nil
	end,
	refilling_shot_on_ammo_used = function(arg_229_0, arg_229_1, arg_229_2)
		if not var_0_3(arg_229_0) or not ALIVE[arg_229_0] then
			return
		end

		local var_229_0 = arg_229_1.parent_buff_shared_table

		var_229_0.ammo_used_extension = arg_229_2[1]
		var_229_0.ammo_used = arg_229_2[2]
	end,
	thorn_skin_effect = function(arg_230_0, arg_230_1, arg_230_2)
		if ALIVE[arg_230_0] then
			local var_230_0 = arg_230_1.template
			local var_230_1 = ExplosionUtils.get_template(var_230_0.explosion_template)
			local var_230_2 = Application.main_world()
			local var_230_3 = POSITION_LOOKUP[arg_230_0]
			local var_230_4 = Quaternion.identity()
			local var_230_5 = ScriptUnit.has_extension(arg_230_0, "career_system"):get_career_power_level()

			DamageUtils.create_explosion(var_230_2, arg_230_0, var_230_3, var_230_4, var_230_1, 1, "buff", var_0_6(), var_0_7(arg_230_0), arg_230_0, var_230_5, false)
		end

		return true
	end,
	crescendo_strike_on_crit = function(arg_231_0, arg_231_1, arg_231_2)
		if ALIVE[arg_231_0] then
			local var_231_0 = arg_231_1.template.buff_to_add

			ScriptUnit.extension(arg_231_0, "buff_system"):add_buff(var_231_0, {
				attacker_unit = arg_231_0
			})
		end
	end,
	lucky_on_crit = function(arg_232_0, arg_232_1, arg_232_2)
		if not var_0_3(arg_232_0) or not ALIVE[arg_232_0] then
			return
		end

		local var_232_0 = ScriptUnit.extension(arg_232_0, "buff_system")
		local var_232_1 = arg_232_1.parent_buff_shared_table
		local var_232_2 = var_232_1.buff_ids

		if var_232_2 then
			for iter_232_0 = 1, #var_232_2 do
				local var_232_3 = var_232_2[iter_232_0]

				var_232_0:remove_buff(var_232_3)
			end

			table.clear(var_232_1.buff_ids)
		end
	end,
	lucky_on_non_crit = function(arg_233_0, arg_233_1, arg_233_2)
		if not var_0_3(arg_233_0) or not ALIVE[arg_233_0] then
			return
		end

		local var_233_0 = arg_233_1.template.buff_to_add
		local var_233_1 = ScriptUnit.extension(arg_233_0, "buff_system"):add_buff(var_233_0, {
			attacker_unit = arg_233_0
		})
		local var_233_2 = arg_233_1.parent_buff_shared_table
		local var_233_3 = var_233_2.buff_ids or {}

		var_233_3[#var_233_3 + 1] = var_233_1
		var_233_2.buff_ids = var_233_3
	end,
	hidden_escape_on_damage_taken = function(arg_234_0, arg_234_1, arg_234_2)
		if not var_0_3(arg_234_0) or not ALIVE[arg_234_0] then
			return
		end

		local var_234_0 = ScriptUnit.extension(arg_234_0, "buff_system")
		local var_234_1 = arg_234_1.template

		if var_234_1.invalid_damage_sources[arg_234_2[3]] then
			return
		end

		local var_234_2 = var_234_1.cooldown_buff

		if not var_234_0:get_buff_type(var_234_2) then
			local var_234_3 = var_234_1.buff_to_add

			if ScriptUnit.extension(arg_234_0, "status_system"):is_invisible() then
				return
			end

			var_234_0:add_buff(var_234_3, {
				attacker_unit = arg_234_0
			})
		end
	end,
	hidden_escape_on_hit = function(arg_235_0, arg_235_1, arg_235_2)
		if not var_0_3(arg_235_0) or not ALIVE[arg_235_0] then
			return
		end

		ScriptUnit.extension(arg_235_0, "buff_system"):remove_buff(arg_235_1.id)
	end,
	curative_empowerment_on_healed_ally = function(arg_236_0, arg_236_1, arg_236_2)
		local var_236_0 = arg_236_2[1]

		if not var_0_6() then
			return
		end

		local var_236_1 = arg_236_2[3]
		local var_236_2 = arg_236_1.template

		if var_236_1 ~= var_236_2.heal_type then
			return
		end

		local var_236_3 = var_236_2.buff_to_add
		local var_236_4 = Managers.state.entity:system("buff_system")

		if ALIVE[arg_236_0] then
			var_236_4:add_buff(arg_236_0, var_236_3, arg_236_0)
		end

		if ALIVE[var_236_0] then
			var_236_4:add_buff(var_236_0, var_236_3, arg_236_0)
		end
	end,
	pent_up_anger_on_block = function(arg_237_0, arg_237_1, arg_237_2)
		if not ALIVE[arg_237_0] then
			return
		end

		local var_237_0 = ScriptUnit.extension(arg_237_0, "buff_system")
		local var_237_1 = arg_237_1.template
		local var_237_2 = var_237_1.buff_to_add
		local var_237_3 = var_237_1.crit_buff

		if var_237_0:get_non_stacking_buff(var_237_3) then
			return false
		end

		var_237_0:add_buff(var_237_2, {
			attacker_unit = arg_237_0
		})

		return true
	end,
	surprise_strike_add_buff = function(arg_238_0, arg_238_1, arg_238_2)
		if not var_0_3(arg_238_0) or not ALIVE[arg_238_0] then
			return
		end

		local var_238_0 = ScriptUnit.extension(arg_238_0, "buff_system")
		local var_238_1 = arg_238_1.template.buff_to_add

		var_238_0:add_buff(var_238_1, {
			attacker_unit = arg_238_0
		})

		return true
	end,
	start_bad_breath_timer = function(arg_239_0, arg_239_1, arg_239_2)
		if not var_0_6() then
			return false
		end

		local var_239_0 = arg_239_1.template
		local var_239_1 = var_239_0.cooldown_buff

		if ScriptUnit.extension(arg_239_0, "buff_system"):get_buff_type(var_239_1) then
			return false
		end

		if var_239_0.rescuable_disable_types[arg_239_2[1]] then
			arg_239_1.disabler, arg_239_1.rescue_timer = arg_239_2[2], Managers.time:time("main") + var_239_0.rescue_delay

			return true
		end
	end,
	start_boulder_bro_timer = function(arg_240_0, arg_240_1, arg_240_2)
		local var_240_0 = arg_240_1.template

		arg_240_1.rescue_timer = Managers.time:time("main") + var_240_0.rescue_delay

		return false
	end,
	static_blade_on_timed_block = function(arg_241_0, arg_241_1, arg_241_2)
		if not var_0_3(arg_241_0) or not ALIVE[arg_241_0] then
			return
		end

		local var_241_0 = arg_241_1.template
		local var_241_1 = var_241_0.cooldown_buff
		local var_241_2 = ScriptUnit.extension(arg_241_0, "buff_system")

		if var_241_2:get_buff_type(var_241_1) then
			return false
		end

		local var_241_3 = arg_241_2[1]
		local var_241_4 = var_241_0.hit_zone or arg_241_1.hit_zone_name or "full"
		local var_241_5 = var_241_0.damage_source or "buff"
		local var_241_6 = arg_241_1.power_level or DefaultPowerLevel
		local var_241_7 = var_241_0.damage_profile_name or "default"
		local var_241_8 = DamageProfileTemplates[var_241_7]
		local var_241_9
		local var_241_10 = false
		local var_241_11
		local var_241_12
		local var_241_13 = var_241_8.targets and var_241_8.targets[var_241_9] or var_241_8.default_target
		local var_241_14 = var_241_13.damage_type
		local var_241_15 = BoostCurves[var_241_13.boost_curve_type]
		local var_241_16 = DamageUtils.calculate_damage(DamageOutput, var_241_3, arg_241_0, var_241_4, var_241_6, var_241_15, var_241_12, var_241_10, var_241_8, var_241_9, var_241_11, var_241_5)

		DamageUtils.add_damage_network(var_241_3, arg_241_0, var_241_16, "torso", var_241_14, nil, Vector3(1, 0, 0), var_241_5, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)

		local var_241_17 = Managers.state.entity:system("area_damage_system")
		local var_241_18 = POSITION_LOOKUP[var_241_3]
		local var_241_19 = Quaternion.identity()
		local var_241_20 = var_241_0.explosion_template
		local var_241_21 = 1

		var_241_17:create_explosion(arg_241_0, var_241_18, var_241_19, var_241_20, var_241_21, var_241_5, var_241_6, var_241_10)

		local var_241_22 = NetworkLookup.effects["fx/cw_chain_lightning"]
		local var_241_23 = POSITION_LOOKUP[arg_241_0] + 0.5 * Vector3.up()
		local var_241_24
		local var_241_25 = Unit.has_node(var_241_3, "j_spine") and Unit.node(var_241_3, "j_spine")

		if var_241_25 then
			var_241_24 = Unit.world_position(var_241_3, var_241_25)
		else
			var_241_24 = POSITION_LOOKUP[var_241_3] + 0.5 * Vector3.up()
		end

		local var_241_26 = Vector3.distance(var_241_24, var_241_23)
		local var_241_27 = Vector3(1, var_241_26, 0)
		local var_241_28 = Quaternion.look(var_241_24 - var_241_23)

		if var_0_6() then
			Managers.state.network:rpc_play_particle_effect_with_variable(nil, var_241_22, var_241_23, var_241_28, "distance", var_241_27)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect_with_variable", var_241_22, var_241_23, var_241_28, "distance", var_241_27)
		end

		local var_241_29 = Managers.state.entity:system("audio_system")
		local var_241_30 = var_241_0.sound_event

		var_241_29:play_audio_unit_event(var_241_30, var_241_3)
		var_241_2:add_buff(var_241_1, {
			attacker_unit = arg_241_0
		})

		return true
	end,
	spawn_orb = function(arg_242_0, arg_242_1, arg_242_2)
		if var_0_6() then
			if not ALIVE[arg_242_0] then
				return
			end

			local var_242_0 = arg_242_2[3]
			local var_242_1 = POSITION_LOOKUP[var_242_0] + Vector3(0, 0, 1)
			local var_242_2 = POSITION_LOOKUP[arg_242_0]
			local var_242_3 = Vector3.normalize(var_242_1 - var_242_2)
			local var_242_4 = math.pi
			local var_242_5 = arg_242_1.template.orb_settings.orb_name
			local var_242_6 = Managers.player:owner(arg_242_0).peer_id

			Managers.state.entity:system("orb_system"):spawn_orb(var_242_5, var_242_6, var_242_1, var_242_3, var_242_4)
		end
	end,
	on_damage_taken_health_orbs = function(arg_243_0, arg_243_1, arg_243_2)
		if not var_0_6() then
			return
		end

		if ALIVE[arg_243_0] then
			local var_243_0 = arg_243_1.template

			if ScriptUnit.extension(arg_243_0, "status_system"):is_disabled() then
				return
			end

			local var_243_1 = arg_243_2[2] + (arg_243_1.leftover_health or 0)
			local var_243_2 = var_243_1 / var_243_0.health_per_orb
			local var_243_3 = math.floor(var_243_2)

			arg_243_1.leftover_health = math.fmod(var_243_1, var_243_0.health_per_orb)

			local var_243_4 = arg_243_1.template.orb_settings.orb_name
			local var_243_5 = Managers.player:owner(arg_243_0).peer_id
			local var_243_6 = POSITION_LOOKUP[arg_243_0] + Vector3(0, 0, 1)
			local var_243_7 = Vector3(0, 0, 1)
			local var_243_8 = 2 * math.pi
			local var_243_9 = Managers.state.entity:system("orb_system")

			for iter_243_0 = 1, var_243_3 do
				var_243_9:spawn_orb(var_243_4, var_243_5, var_243_6, var_243_7, var_243_8)
			end
		end
	end,
	on_kill_static_charge = function(arg_244_0, arg_244_1, arg_244_2)
		if not var_0_6() then
			return
		end

		if ALIVE[arg_244_0] then
			local var_244_0 = arg_244_1.template

			if ScriptUnit.extension(arg_244_0, "status_system"):is_disabled() then
				return
			end

			arg_244_1.kill_count = (arg_244_1.kill_count or 0) + 1

			if arg_244_1.kill_count >= var_244_0.kills_per_orb then
				arg_244_1.kill_count = 0

				local var_244_1 = POSITION_LOOKUP[arg_244_0] + Vector3(0, 0, 1)
				local var_244_2 = arg_244_1.template.orb_settings.orb_name
				local var_244_3 = Managers.player:owner(arg_244_0).peer_id
				local var_244_4 = Vector3(0, 0, 1)
				local var_244_5 = 2 * math.pi

				Managers.state.entity:system("orb_system"):spawn_orb(var_244_2, var_244_3, var_244_1, var_244_4, var_244_5)
			end
		end
	end,
	on_potion_consumed_sharing_is_caring = function(arg_245_0, arg_245_1, arg_245_2)
		if ALIVE[arg_245_0] then
			local var_245_0 = arg_245_2[1]
			local var_245_1 = ItemMasterList[var_245_0].temporary_template .. "_orb"

			if AllPickups[var_245_1] then
				local var_245_2 = POSITION_LOOKUP[arg_245_0] + Vector3(0, 0, 1)
				local var_245_3 = Managers.player:owner(arg_245_0).peer_id
				local var_245_4 = Vector3(0, 0, 1)
				local var_245_5 = 2 * math.pi

				if var_0_6() then
					Managers.state.entity:system("orb_system"):spawn_orb(var_245_1, var_245_3, var_245_2, var_245_4, var_245_5)
				else
					local var_245_6 = Managers.state.network
					local var_245_7 = NetworkLookup.pickup_names[var_245_1]

					var_245_6.network_transmit:send_rpc_server("rpc_spawn_orb", var_245_7, var_245_3, var_245_2, var_245_4, var_245_5)
				end
			end
		end
	end,
	on_timed_block_protection_orbs = function(arg_246_0, arg_246_1, arg_246_2)
		local var_246_0 = Managers.time:time("main")

		if arg_246_1.cooldown_end_t and var_246_0 < arg_246_1.cooldown_end_t then
			return
		end

		if ALIVE[arg_246_0] then
			if ScriptUnit.extension(arg_246_0, "status_system"):is_disabled() then
				return
			end

			local var_246_1 = POSITION_LOOKUP[arg_246_0] + Vector3(0, 0, 1)
			local var_246_2 = arg_246_1.template.orb_settings.orb_name
			local var_246_3 = Managers.player:owner(arg_246_0).peer_id
			local var_246_4 = Vector3(0, 0, 1)
			local var_246_5 = 2 * math.pi

			if var_0_6() then
				Managers.state.entity:system("orb_system"):spawn_orb(var_246_2, var_246_3, var_246_1, var_246_4, var_246_5)
			else
				local var_246_6 = Managers.state.network
				local var_246_7 = NetworkLookup.pickup_names[var_246_2]

				var_246_6.network_transmit:send_rpc_server("rpc_spawn_orb", var_246_7, var_246_3, var_246_1, var_246_4, var_246_5)
			end

			arg_246_1.cooldown_end_t = var_246_0 + arg_246_1.template.cooldown
		end
	end,
	focused_accuracy_on_hit = function(arg_247_0, arg_247_1, arg_247_2)
		if not ALIVE[arg_247_0] then
			return
		end

		local var_247_0 = arg_247_1.template.cooldown_buff

		if ScriptUnit.extension(arg_247_0, "buff_system"):get_buff_type(var_247_0) then
			return
		end

		local var_247_1 = arg_247_2[3]

		if var_247_1 and (var_247_1 == "head" or var_247_1 == "neck") then
			Managers.state.entity:system("buff_system"):add_buff(arg_247_0, var_247_0, arg_247_0)

			local var_247_2 = arg_247_1.template.orb_settings.orb_name
			local var_247_3 = arg_247_2[1]
			local var_247_4 = POSITION_LOOKUP[var_247_3] + Vector3(0, 0, 1)
			local var_247_5 = Managers.player:owner(arg_247_0).peer_id
			local var_247_6 = Vector3(0, 0, 1)
			local var_247_7 = 2 * math.pi

			if var_0_6() then
				Managers.state.entity:system("orb_system"):spawn_orb(var_247_2, var_247_5, var_247_4, var_247_6, var_247_7)
			else
				local var_247_8 = Managers.state.network
				local var_247_9 = NetworkLookup.pickup_names[var_247_2]

				var_247_8.network_transmit:send_rpc_server("rpc_spawn_orb", var_247_9, var_247_5, var_247_4, var_247_6, var_247_7)
			end
		end
	end,
	deus_ranged_crit_explosion_on_damage_dealt = function(arg_248_0, arg_248_1, arg_248_2, arg_248_3)
		local var_248_0 = arg_248_1.template
		local var_248_1 = arg_248_2[2]
		local var_248_2 = var_248_0.valid_attack_types

		if var_248_2 and not var_248_2[var_248_1] then
			return
		end

		local var_248_3 = arg_248_1.template.cooldown_buff

		if ScriptUnit.extension(arg_248_0, "buff_system"):get_buff_type(var_248_3) then
			return
		end

		local var_248_4 = arg_248_2[1]
		local var_248_5 = arg_248_2[6]
		local var_248_6 = arg_248_2[4]

		if ALIVE[arg_248_0] and ALIVE[var_248_4] and var_248_6 == 1 and var_248_5 then
			local var_248_7 = ScriptUnit.has_extension(arg_248_0, "career_system")
			local var_248_8 = Managers.state.entity:system("area_damage_system")
			local var_248_9 = POSITION_LOOKUP[var_248_4]
			local var_248_10 = "buff"
			local var_248_11 = var_248_0.explosion_template
			local var_248_12 = Quaternion.identity()
			local var_248_13 = var_248_7:get_career_power_level() * var_248_0.power_scale
			local var_248_14 = 1
			local var_248_15 = false

			var_248_8:create_explosion(arg_248_0, var_248_9, var_248_12, var_248_11, var_248_14, var_248_10, var_248_13, var_248_15)

			local var_248_16 = Managers.state.entity:system("audio_system")
			local var_248_17 = var_248_0.sound_event

			var_248_16:play_audio_unit_event(var_248_17, var_248_4)
			Managers.state.entity:system("buff_system"):add_buff(arg_248_0, var_248_3, arg_248_0)
		end
	end,
	resolve_on_revived = function(arg_249_0, arg_249_1, arg_249_2)
		local var_249_0 = ScriptUnit.extension(arg_249_0, "buff_system")
		local var_249_1 = arg_249_1.template
		local var_249_2 = var_249_1.cooldown_buff
		local var_249_3 = var_249_1.full_heal_buff

		if var_249_0:get_buff_type(var_249_3) then
			var_249_0:add_buff(var_249_2)

			arg_249_1.after_revive_t = Managers.time:time("game") + 3
		end
	end,
	squats_add_buff = function(arg_250_0, arg_250_1, arg_250_2)
		if not var_0_3(arg_250_0) or not ALIVE[arg_250_0] then
			return
		end

		local var_250_0 = arg_250_1.template
		local var_250_1 = var_250_0.build_up_buff
		local var_250_2 = var_250_0.actual_buff
		local var_250_3 = ScriptUnit.extension(arg_250_0, "buff_system")

		if var_250_3:get_buff_type(var_250_2) then
			return
		end

		local var_250_4 = Managers.state.entity:system("buff_system")

		var_250_4:add_buff(arg_250_0, var_250_1, arg_250_0)

		if var_250_3:num_buff_stacks(var_250_1) >= var_250_0.stack_count_to_trigger_actual_buff then
			while true do
				local var_250_5 = var_250_3:get_buff_type(var_250_1)

				if not var_250_5 then
					break
				end

				var_250_3:remove_buff(var_250_5.id)
			end

			var_250_4:add_buff(arg_250_0, var_250_2, arg_250_0)
		end
	end,
	boon_skulls_01_on_hit = function(arg_251_0, arg_251_1, arg_251_2)
		local var_251_0 = ScriptUnit.extension(arg_251_0, "buff_system")

		if var_251_0:get_buff_type("boon_skulls_01_surge") then
			return
		end

		var_251_0:add_buff(arg_251_1.template.buff_to_add)
	end,
	boon_skulls_02_on_kill = function(arg_252_0, arg_252_1, arg_252_2)
		if ScriptUnit.extension(arg_252_0, "buff_system"):get_buff_type("boon_skulls_02_surge") then
			return
		end

		Managers.state.entity:system("buff_system"):add_buff_synced(arg_252_0, arg_252_1.template.buff_to_add, BuffSyncType.LocalAndServer)
	end,
	boon_skulls_03_on_parry = function(arg_253_0, arg_253_1, arg_253_2)
		local var_253_0 = ScriptUnit.extension(arg_253_0, "buff_system")

		if var_253_0:num_buff_stacks("boon_skulls_03_cooldown") > 0 then
			return
		end

		local var_253_1 = POSITION_LOOKUP[arg_253_0]
		local var_253_2 = arg_253_1.template.explosion_template_name
		local var_253_3 = ExplosionTemplates[var_253_2]
		local var_253_4 = ScriptUnit.has_extension(arg_253_0, "career_system")
		local var_253_5 = var_253_4 and var_253_4:get_career_power_level() or DefaultPowerLevel
		local var_253_6 = 1
		local var_253_7 = "buff"
		local var_253_8 = Quaternion.identity()

		if not var_0_6() then
			DamageUtils.create_explosion(Unit.world(arg_253_0), arg_253_0, var_253_1, var_253_8, var_253_3, var_253_6, var_253_7, false, true, arg_253_0, var_253_5, false, arg_253_0)
		end

		local var_253_9 = Managers.state.network:unit_game_object_id(arg_253_0)
		local var_253_10 = NetworkLookup.explosion_templates[var_253_2]
		local var_253_11 = NetworkLookup.damage_sources[var_253_7]

		Managers.state.network.network_transmit:send_rpc_server("rpc_create_explosion", var_253_9, false, var_253_1, var_253_8, var_253_10, var_253_6, var_253_11, var_253_5, false, var_253_9)
		var_253_0:add_buff("boon_skulls_03_cooldown")
	end,
	boon_skulls_04_on_hit = function(arg_254_0, arg_254_1, arg_254_2)
		local var_254_0 = Managers.player:owner(arg_254_0)

		if not var_254_0 or var_254_0:network_id() ~= Network.peer_id() then
			return
		end

		local var_254_1 = arg_254_2[4]
		local var_254_2 = arg_254_2[2] == "light_attack" or arg_254_2[2] == "heavy_attack"

		if var_254_1 > 1 or not var_254_2 then
			return
		end

		local var_254_3 = ScriptUnit.extension(arg_254_0, "health_system")
		local var_254_4 = var_254_3:current_temporary_health()

		if var_254_4 <= 0 then
			return
		end

		local var_254_5 = ScriptUnit.extension(arg_254_0, "buff_system")

		if var_254_5:get_buff_type("boon_skulls_04_regen") then
			return
		end

		local var_254_6 = math.min(var_254_4, MorrisBuffTweakData.boon_skulls_04_data.thp_on_hit)
		local var_254_7 = var_254_3:current_health()
		local var_254_8 = math.clamp(var_254_6, 0, math.max(var_254_7 - 0.25, 0))
		local var_254_9 = math.floor(DamageUtils.networkify_damage(var_254_8))
		local var_254_10 = var_254_5:num_buff_stacks("boon_skulls_04_stack")

		if var_254_10 + var_254_9 >= MorrisBuffTweakData.boon_skulls_04_data.total_thp_to_consume then
			var_254_9 = MorrisBuffTweakData.boon_skulls_04_data.total_thp_to_consume - var_254_10

			local var_254_11 = var_254_5:get_stacking_buff("boon_skulls_04_stack")

			for iter_254_0 = var_254_10, 1, -1 do
				var_254_5:remove_buff(var_254_11[iter_254_0].id)
			end

			var_254_5:add_buff("boon_skulls_04_regen")
		else
			for iter_254_1 = 1, var_254_9 do
				var_254_5:add_buff("boon_skulls_04_stack")
			end
		end

		if var_254_9 > 0 then
			DamageUtils.add_damage_network(arg_254_0, arg_254_0, var_254_9, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_254_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	boon_skulls_05_on_hit = function(arg_255_0, arg_255_1, arg_255_2)
		local var_255_0 = Managers.player:owner(arg_255_0)

		if not var_255_0 or var_255_0:network_id() ~= Network.peer_id() then
			return
		end

		local var_255_1 = arg_255_2[4]
		local var_255_2 = arg_255_2[2] == "heavy_attack"

		if var_255_1 > 1 or not var_255_2 then
			return
		end

		if ScriptUnit.extension(arg_255_0, "buff_system"):get_buff_type("boon_skulls_05_surge") then
			return
		end

		Managers.state.entity:system("buff_system"):add_buff_synced(arg_255_0, arg_255_1.template.buff_to_add, BuffSyncType.LocalAndServer)
	end,
	boon_skulls_07_on_skull_picked_up = function(arg_256_0, arg_256_1, arg_256_2)
		local var_256_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local var_256_1 = 1

		for iter_256_0, iter_256_1 in pairs(Managers.player:human_players()) do
			local var_256_2 = var_256_0:get_player_power_ups(iter_256_1:network_id(), iter_256_1:local_player_id())

			if table.find_func(var_256_2, function(arg_257_0, arg_257_1)
				return arg_257_1.name == "boon_skulls_set_bonus_02"
			end) then
				var_256_1 = var_256_1 + MorrisBuffTweakData.boon_skulls_set_bonus_02.effect_amplify_amount
			end
		end

		local var_256_3 = Managers.state.game_mode:game_mode()

		if var_256_3.on_picked_up_soft_currency then
			local var_256_4 = arg_256_2[2]
			local var_256_5 = arg_256_1.template.coins_to_gain * var_256_1

			var_256_3:on_picked_up_soft_currency(var_256_4, arg_256_0, var_256_5, DeusSoftCurrencySettings.types.GROUND)
		end

		local var_256_6 = Managers.player:local_player()

		Managers.state.event:trigger("player_pickup_deus_soft_currency", var_256_6)
	end,
	boon_skulls_08_on_skull_picked_up = function(arg_258_0, arg_258_1, arg_258_2)
		local var_258_0 = arg_258_2[1]
		local var_258_1 = Managers.player:local_player()

		if var_258_0 == (var_258_1 and var_258_1.player_unit) then
			local var_258_2 = arg_258_1.template.cooldown_to_reduce

			if ScriptUnit.extension(arg_258_0, "buff_system"):num_buff_stacks("power_up_boon_skulls_set_bonus_02_event") > 0 then
				var_258_2 = var_258_2 * (1 + MorrisBuffTweakData.boon_skulls_set_bonus_02.effect_amplify_amount)
			end

			ScriptUnit.extension(arg_258_0, "career_system"):reduce_activated_ability_cooldown_percent(var_258_2, 1, true)
		end
	end,
	teammates_extra_damage_aura_reduce_own_damage = function(arg_259_0, arg_259_1, arg_259_2)
		local var_259_0 = arg_259_2[1]
		local var_259_1 = ScriptUnit.has_extension(var_259_0, "buff_system")
		local var_259_2 = false
		local var_259_3 = var_259_1 and var_259_1:get_stacking_buff("deus_extra_damage_aura_debuff")

		if var_259_3 then
			for iter_259_0 = 1, #var_259_3 do
				if var_259_3[iter_259_0].attacker_unit == arg_259_0 then
					var_259_2 = true

					break
				end
			end
		end

		if not var_259_2 then
			return
		end

		local var_259_4, var_259_5, var_259_6 = ScriptUnit.extension(arg_259_0, "buff_system"):add_buff("teammates_extra_damage_counteract_buff")

		var_259_6.source_buff_id = arg_259_1.id
	end,
	teammates_extra_damage_aura_revert_own_damage = function(arg_260_0, arg_260_1, arg_260_2)
		local var_260_0 = ScriptUnit.extension(arg_260_0, "buff_system")
		local var_260_1 = var_260_0:get_stacking_buff("teammates_extra_damage_counteract_buff")

		if var_260_1 then
			local var_260_2 = arg_260_1.id

			for iter_260_0 = #var_260_1, 1, -1 do
				if var_260_1[iter_260_0].source_buff_id == var_260_2 then
					var_260_0:remove_buff(var_260_1[iter_260_0].id)

					return
				end
			end
		end
	end,
	teammates_extra_stagger_aura_reduce_own_stagger = function(arg_261_0, arg_261_1, arg_261_2)
		local var_261_0 = arg_261_2[1]
		local var_261_1 = ScriptUnit.has_extension(var_261_0, "buff_system")
		local var_261_2 = false
		local var_261_3 = var_261_1 and var_261_1:get_stacking_buff("deus_extra_stagger_aura_debuff")

		if var_261_3 then
			for iter_261_0 = 1, #var_261_3 do
				if var_261_3[iter_261_0].attacker_unit == arg_261_0 then
					var_261_2 = true

					break
				end
			end
		end

		if not var_261_2 then
			return
		end

		local var_261_4, var_261_5, var_261_6 = ScriptUnit.extension(arg_261_0, "buff_system"):add_buff("teammates_extra_stagger_counteract_buff")

		var_261_6.source_buff_id = arg_261_1.id
	end,
	teammates_extra_stagger_aura_revert_own_stagger = function(arg_262_0, arg_262_1, arg_262_2)
		local var_262_0 = ScriptUnit.extension(arg_262_0, "buff_system")
		local var_262_1 = var_262_0:get_stacking_buff("teammates_extra_stagger_counteract_buff")

		if var_262_1 then
			local var_262_2 = arg_262_1.id

			for iter_262_0 = #var_262_1, 1, -1 do
				if var_262_1[iter_262_0].source_buff_id == var_262_2 then
					var_262_0:remove_buff(var_262_1[iter_262_0].id)

					return
				end
			end
		end
	end,
	extra_stagger_near_teammates_check = function(arg_263_0, arg_263_1, arg_263_2)
		local var_263_0 = arg_263_2[1]
		local var_263_1 = Unit.local_position(var_263_0, 1)
		local var_263_2 = arg_263_1.template.distance_from_allies
		local var_263_3 = var_263_2 * var_263_2
		local var_263_4 = Managers.state.side.side_by_unit[arg_263_0].PLAYER_AND_BOT_UNITS

		for iter_263_0 = 1, #var_263_4 do
			local var_263_5 = var_263_4[iter_263_0]

			if var_263_5 ~= arg_263_0 then
				local var_263_6 = POSITION_LOOKUP[var_263_5]

				if var_263_6 and var_263_3 >= Vector3.distance_squared(var_263_1, var_263_6) then
					ScriptUnit.extension(arg_263_0, "buff_system"):add_buff("boon_teamaura_02_stagger_buff")

					break
				end
			end
		end
	end,
	extra_stagger_near_teammates_cleanup = function(arg_264_0, arg_264_1, arg_264_2)
		local var_264_0 = ScriptUnit.extension(arg_264_0, "buff_system")
		local var_264_1 = var_264_0:get_stacking_buff("boon_teamaura_02_stagger_buff")

		if var_264_1 and #var_264_1 > 0 then
			var_264_0:remove_buff(var_264_1[1].id)
		end
	end,
	extra_damage_near_teammates_check = function(arg_265_0, arg_265_1, arg_265_2)
		local var_265_0 = arg_265_2[1]
		local var_265_1 = Unit.local_position(var_265_0, 1)
		local var_265_2 = arg_265_1.template.distance_from_allies
		local var_265_3 = var_265_2 * var_265_2
		local var_265_4 = Managers.state.side.side_by_unit[arg_265_0].PLAYER_AND_BOT_UNITS

		for iter_265_0 = 1, #var_265_4 do
			local var_265_5 = var_265_4[iter_265_0]

			if var_265_5 ~= arg_265_0 then
				local var_265_6 = POSITION_LOOKUP[var_265_5]

				if var_265_6 and var_265_3 >= Vector3.distance_squared(var_265_1, var_265_6) then
					ScriptUnit.extension(arg_265_0, "buff_system"):add_buff("boon_teamaura_01_damage_buff")

					break
				end
			end
		end
	end,
	extra_damage_near_teammates_cleanup = function(arg_266_0, arg_266_1, arg_266_2)
		local var_266_0 = ScriptUnit.extension(arg_266_0, "buff_system")
		local var_266_1 = var_266_0:get_stacking_buff("boon_teamaura_01_damage_buff")

		if var_266_1 and #var_266_1 > 0 then
			var_266_0:remove_buff(var_266_1[1].id)
		end
	end,
	boon_meta_01_boon_granted = function(arg_267_0, arg_267_1, arg_267_2)
		local var_267_0 = Managers.player:owner(arg_267_0)

		if not var_267_0 then
			return
		end

		local var_267_1 = ScriptUnit.extension(arg_267_0, "buff_system")
		local var_267_2 = var_267_1:num_buff_stacks("boon_meta_01_stack")
		local var_267_3 = #Managers.mechanism:game_mechanism():get_deus_run_controller():get_player_power_ups(var_267_0:network_id(), var_267_0:local_player_id())

		for iter_267_0 = var_267_2 + 1, var_267_3 do
			var_267_1:add_buff("boon_meta_01_stack")
		end

		local var_267_4 = var_267_1:get_stacking_buff("boon_meta_01_stack")

		for iter_267_1 = var_267_2, var_267_3 + 1, -1 do
			local var_267_5 = var_267_4[iter_267_1]

			var_267_1:remove_buff(var_267_5.id)
		end
	end,
	boon_weaponrarity_02_weapon_wielded = function(arg_268_0, arg_268_1, arg_268_2)
		local var_268_0 = ScriptUnit.extension(arg_268_0, "career_system")
		local var_268_1 = ScriptUnit.extension(arg_268_0, "inventory_system")
		local var_268_2 = var_268_0:career_name()
		local var_268_3 = var_268_1:get_wielded_slot_name()
		local var_268_4 = ScriptUnit.extension(arg_268_0, "buff_system")
		local var_268_5 = var_268_4:num_buff_stacks("boon_weaponrarity_02_debuff")
		local var_268_6 = ORDER_RARITY.unique

		if var_268_3 == "slot_melee" or var_268_3 == "slot_ranged" then
			local var_268_7 = Managers.backend:get_interface("deus")
			local var_268_8 = var_268_7:get_loadout_item_id(var_268_2, var_268_3)
			local var_268_9 = var_268_7:get_loadout_item(var_268_8)

			if not var_268_9 then
				return
			end

			local var_268_10 = var_268_9.rarity

			var_268_6 = ORDER_RARITY[var_268_10] or ORDER_RARITY.unique
		end

		for iter_268_0 = var_268_5, var_268_6 - 2 do
			var_268_4:add_buff("boon_weaponrarity_02_debuff")
		end

		local var_268_11 = var_268_4:get_stacking_buff("boon_weaponrarity_02_debuff")

		for iter_268_1 = var_268_5, var_268_6, -1 do
			local var_268_12 = var_268_11[#var_268_11]

			var_268_4:remove_buff(var_268_12.id)
		end
	end,
	boon_weaponrarity_01_weapon_wielded = function(arg_269_0, arg_269_1, arg_269_2)
		local var_269_0 = ScriptUnit.extension(arg_269_0, "career_system"):career_name()
		local var_269_1 = Managers.backend:get_interface("deus")
		local var_269_2 = var_269_1:get_loadout_item_id(var_269_0, "slot_melee")
		local var_269_3 = var_269_1:get_loadout_item(var_269_2)
		local var_269_4 = ORDER_RARITY[var_269_3 and var_269_3.rarity] or 1
		local var_269_5 = var_269_1:get_loadout_item_id(var_269_0, "slot_ranged")
		local var_269_6 = var_269_1:get_loadout_item(var_269_5)
		local var_269_7 = ORDER_RARITY[var_269_6 and var_269_6.rarity] or 1
		local var_269_8 = math.max(var_269_4, var_269_7)
		local var_269_9 = ScriptUnit.extension(arg_269_0, "buff_system")
		local var_269_10 = var_269_9:num_buff_stacks("boon_weaponrarity_01_debuff")

		for iter_269_0 = var_269_10, var_269_8 - 2 do
			var_269_9:add_buff("boon_weaponrarity_01_debuff")
		end

		local var_269_11 = var_269_9:get_stacking_buff("boon_weaponrarity_01_debuff")

		for iter_269_1 = var_269_10, var_269_8, -1 do
			local var_269_12 = var_269_11[#var_269_11]

			var_269_9:remove_buff(var_269_12.id)
		end
	end
}
var_0_2.explosion_templates = {
	stagger_aoe_on_crit = {
		name = "stagger_aoe_on_crit",
		explosion = {
			no_prop_damage = true,
			radius = 5,
			use_attacker_power_level = true,
			max_damage_radius = 2,
			alert_enemies_radius = 15,
			attack_template = "drakegun",
			alert_enemies = true,
			damage_profile = "ability_push",
			no_friendly_fire = true
		}
	},
	armor_breaker = {
		name = "armor_breaker",
		explosion = {
			use_attacker_power_level = true,
			radius = 4,
			hit_sound_event = "Play_wind_metal_gameplay_mutator_wind_hit",
			damage_profile = "armor_breaker",
			no_friendly_fire = true
		}
	},
	bolt_of_change = {
		time_to_explode = 3,
		follow_time = 6,
		explosion = {
			trigger_on_server_only = true,
			radius = 4,
			alert_enemies_radius = 20,
			attack_template = "grenade",
			alert_enemies = true,
			allow_friendly_fire_override = true,
			different_power_levels_for_players = true,
			buildup_effect_time = 1.5,
			sound_event_name = "Play_mutator_enemy_split_large",
			damage_profile = "bolt_of_change",
			power_level = 250,
			buildup_effect_name = "fx/deus_lightning_strike_02",
			effect_name = "fx/deus_lightning_strike_01",
			camera_effect = {
				near_distance = 5,
				near_scale = 1,
				shake_name = "lightning_strike",
				far_scale = 0.15,
				far_distance = 20
			}
		}
	},
	magma = {
		aoe = {
			dot_template_name = "burning_magma_dot",
			nav_tag_volume_layer = "fire_grenade",
			dot_balefire_variant = true,
			create_nav_tag_volume = true,
			attack_template = "wizard_staff_geiser",
			sound_event_name = "player_combat_weapon_fire_bw_deus_01_impact",
			damage_interval = 0.5,
			duration = 6,
			area_damage_template = "explosion_template_aoe",
			nav_mesh_effect = {
				particle_radius = 2,
				particle_name = "fx/wpnfx_bw_deus_geyser_01_remap",
				particle_spacing = 0.9
			}
		}
	},
	bots_avoid_curse = {
		aoe = {
			duration = 5,
			radius = 5,
			create_nav_tag_volume = true,
			nav_tag_volume_layer = "bot_poison_wind"
		}
	},
	corrupted_flesh_explosion = {
		aoe = {
			start_aoe_sound_event_name = "Play_curse_corrupted_flesh_explosion",
			stop_aoe_sound_event_name = "Stop_curse_corrupted_flesh_explosion"
		}
	},
	blessing_of_isha_stagger = {
		name = "blessing_of_isha_stagger",
		explosion = {
			use_attacker_power_level = true,
			no_friendly_fire = true,
			no_prop_damage = true,
			max_damage_radius = 0,
			damage_profile = "markus_knight_charge",
			attack_template = "markus_knight_charge"
		}
	},
	holy_hand_grenade = {
		is_grenade = true,
		explosion = {
			dont_rotate_fx = true,
			radius = 10,
			max_damage_radius = 6,
			alert_enemies_radius = 20,
			sound_event_name = "Play_blessing_morris_grenade_explosion",
			attack_template = "grenade",
			damage_profile_glance = "holy_hand_grenade",
			alert_enemies = true,
			damage_profile = "holy_hand_grenade",
			effect_name = "fx/wpnfx_holy_handgrenade_explosion_01",
			difficulty_power_level = {
				easy = {
					power_level_glance = 4000,
					power_level = 8000
				},
				normal = {
					power_level_glance = 8000,
					power_level = 16000
				},
				hard = {
					power_level_glance = 12000,
					power_level = 24000
				},
				harder = {
					power_level_glance = 16000,
					power_level = 32000
				},
				hardest = {
					power_level_glance = 20000,
					power_level = 40000
				},
				cataclysm = {
					power_level_glance = 12000,
					power_level = 24000
				},
				cataclysm_2 = {
					power_level_glance = 16000,
					power_level = 32000
				},
				cataclysm_3 = {
					power_level_glance = 20000,
					power_level = 40000
				}
			},
			camera_effect = {
				near_distance = 10,
				near_scale = 1,
				shake_name = "holy_hand_grenade_explosion",
				far_scale = 0.5,
				far_distance = 40
			}
		}
	},
	curse_skulls_of_fury_explosion = {
		time_to_explode = 3,
		explosion = {
			trigger_on_server_only = true,
			radius = 4,
			alert_enemies = true,
			buildup_effect_name = "fx/deus_curse_skulls_of_fury_timer_01",
			buildup_effect_time = 3,
			deletion_timer = 0,
			alert_enemies_radius = 20,
			attack_template = "skulls_of_fury",
			different_power_levels_for_players = true,
			sound_event_name = "Play_curse_skulls_of_fury_explosion",
			effect_name = "fx/magic_wind_fire_explosion_01",
			allow_friendly_fire_override = true,
			max_damage_radius = 4,
			unit_scale = 1,
			damage_profile_glance = "curse_skulls_of_fury_explosion_glance",
			damage_profile = "curse_skulls_of_fury_explosion",
			buildup_effect_offset = {
				0,
				0,
				-2
			},
			difficulty_power_level = {
				easy = {
					power_level_glance = 50,
					power_level = 100
				},
				normal = {
					power_level_glance = 100,
					power_level = 200
				},
				hard = {
					power_level_glance = 150,
					power_level = 300
				},
				harder = {
					power_level_glance = 200,
					power_level = 400
				},
				hardest = {
					power_level_glance = 250,
					power_level = 500
				},
				cataclysm = {
					power_level_glance = 300,
					power_level = 600
				},
				cataclysm_2 = {
					power_level_glance = 350,
					power_level = 700
				},
				cataclysm_3 = {
					power_level_glance = 400,
					power_level = 800
				}
			},
			camera_effect = {
				near_distance = 5,
				near_scale = 1,
				shake_name = "lightning_strike",
				far_scale = 0.15,
				far_distance = 20
			}
		}
	},
	we_deus_01_small = {
		explosion = {
			use_attacker_power_level = true,
			radius_min = 0.5,
			radius_max = 1,
			attacker_power_level_offset = 0.25,
			max_damage_radius_min = 0.1,
			damage_profile_glance = "we_deus_01_small_explosion_glance",
			max_damage_radius_max = 0.75,
			sound_event_name = "we_deus_01_big_hit",
			damage_profile = "we_deus_01_small_explosion",
			effect_name = "fx/wpnfx_we_deus_01_impact"
		}
	},
	we_deus_01_large = {
		explosion = {
			use_attacker_power_level = true,
			radius_min = 1.25,
			sound_event_name = "we_deus_01_big_hit",
			radius_max = 3,
			attacker_power_level_offset = 0.25,
			max_damage_radius_min = 0.5,
			alert_enemies_radius = 10,
			damage_profile_glance = "we_deus_01_large_explosion_glance",
			max_damage_radius_max = 2,
			alert_enemies = true,
			damage_profile = "we_deus_01_large_explosion",
			effect_name = "fx/wpnfx_we_deus_01_explosion"
		}
	},
	deus_relic_small = {
		explosion = {
			use_attacker_power_level = true,
			radius_min = 0.5,
			no_friendly_fire = true,
			radius_max = 1,
			attacker_power_level_offset = 0.25,
			max_damage_radius_min = 0.1,
			damage_profile_glance = "deus_relic_small_explosion_glance",
			max_damage_radius_max = 0.75,
			sound_event_name = "we_deus_01_big_hit",
			damage_profile = "deus_relic_small_explosion",
			effect_name = "fx/wpnfx_we_deus_01_impact"
		}
	},
	deus_relic_large = {
		explosion = {
			use_attacker_power_level = true,
			radius_min = 1.25,
			sound_event_name = "we_deus_01_big_hit",
			radius_max = 3,
			no_friendly_fire = true,
			attacker_power_level_offset = 0.25,
			max_damage_radius_min = 0.5,
			alert_enemies_radius = 10,
			damage_profile_glance = "deus_relic_large_explosion_glance",
			max_damage_radius_max = 2,
			alert_enemies = true,
			damage_profile = "deus_relic_large_explosion",
			effect_name = "fx/wpnfx_we_deus_01_explosion"
		}
	},
	dr_deus_01 = {
		explosion = {
			use_attacker_power_level = true,
			dont_rotate_fx = true,
			radius = 4,
			max_damage_radius = 1,
			alert_enemies_radius = 20,
			attacker_power_level_offset = 2,
			attack_type = "grenade",
			attack_template = "grenade",
			sound_event_name = "player_combat_weapon_dr_deus_01_explosion",
			damage_profile_glance = "dr_deus_01_glance",
			alert_enemies = true,
			damage_profile = "dr_deus_01_explosion",
			effect_name = "fx/wpnfx_frag_grenade_impact",
			camera_effect = {
				near_distance = 5,
				near_scale = 1,
				shake_name = "frag_grenade_explosion",
				far_scale = 0.15,
				far_distance = 20
			},
			mechanism_overrides = {
				versus = {
					damage_profile = "dr_deus_01_explosion_vs",
					damage_profile_glance = "dr_deus_01_glance_vs"
				}
			}
		}
	},
	buff_explosion = {
		explosion = {
			use_attacker_power_level = true,
			radius = 3,
			max_damage_radius = 1.5,
			alert_enemies_radius = 10,
			attacker_power_level_offset = 0.5,
			effect_name = "fx/cw_enemy_explosion",
			attack_template = "grenade",
			sound_event_name = "fireball_big_hit",
			damage_profile_glance = "frag_grenade_glance",
			alert_enemies = true,
			damage_profile = "frag_grenade",
			no_friendly_fire = true,
			camera_effect = {
				near_distance = 5,
				near_scale = 1,
				shake_name = "frag_grenade_explosion",
				far_scale = 0.15,
				far_distance = 20
			}
		}
	},
	deus_ranged_crit_explosion = {
		explosion = {
			radius = 3,
			alert_enemies = true,
			max_damage_radius = 2.5,
			no_friendly_fire = true,
			alert_enemies_radius = 15,
			sound_event_name = "Play_enemy_combat_warpfire_backpack_explode",
			damage_profile = "frag_grenade",
			effect_name = "fx/cw_enemy_explosion",
			difficulty_power_level = {
				easy = {
					power_level_glance = 100,
					power_level = 200
				},
				normal = {
					power_level_glance = 100,
					power_level = 100
				},
				hard = {
					power_level_glance = 200,
					power_level = 200
				},
				harder = {
					power_level_glance = 300,
					power_level = 300
				},
				hardest = {
					power_level_glance = 400,
					power_level = 400
				},
				cataclysm = {
					power_level_glance = 300,
					power_level = 600
				},
				cataclysm_2 = {
					power_level_glance = 400,
					power_level = 800
				},
				cataclysm_3 = {
					power_level_glance = 500,
					power_level = 1000
				}
			}
		}
	},
	player_disabled_stagger = {
		name = "stagger_aoe_on_crit",
		explosion = {
			no_prop_damage = true,
			radius = 5,
			effect_name = "fx/cw_enemy_explosion",
			max_damage_radius = 2,
			use_attacker_power_level = true,
			alert_enemies_radius = 15,
			attack_template = "drakegun",
			alert_enemies = true,
			damage_profile = "ability_push",
			no_friendly_fire = true
		}
	},
	melee_wave = {
		name = "melee_wave",
		explosion = {
			use_attacker_power_level = true,
			radius = 5,
			effect_name = "fx/chr_kruber_shockwave",
			hit_sound_event = "Play_wind_metal_gameplay_mutator_wind_hit",
			max_damage_radius = 2,
			no_prop_damage = true,
			alert_enemies_radius = 15,
			attack_template = "drakegun",
			sound_event_name = "boon_melee_wave",
			alert_enemies = true,
			damage_profile = "ability_push",
			no_friendly_fire = true
		}
	},
	shield_splinters = {
		name = "shield_splinters",
		explosion = {
			use_attacker_power_level = true,
			radius = 4,
			no_friendly_fire = true,
			hit_sound_event = "Play_wind_metal_gameplay_mutator_wind_hit",
			damage_profile = "armor_breaker",
			sound_event_name = "boon_shield_of_splinters",
			effect_name = "fx/wpnfx_flaming_flail_hit_01"
		}
	},
	blazing_revenge = {
		name = "blazing_revenge",
		aoe = {
			dot_template_name = "burning_dot_fire_grenade",
			radius = 4,
			nav_tag_volume_layer = "fire_grenade",
			create_nav_tag_volume = true,
			attack_template = "fire_grenade_dot",
			friendly_fire = false,
			damage_interval = 1,
			area_damage_template = "explosion_template_aoe",
			duration = math.huge,
			nav_mesh_effect = {
				particle_radius = 2,
				particle_name = "fx/wpnfx_fire_grenade_impact_remains",
				particle_spacing = 0.9
			}
		}
	},
	thorn_skin = {
		name = "thorn_skin",
		explosion = {
			use_attacker_power_level = true,
			radius = 2,
			hit_sound_event = "Play_wind_metal_gameplay_mutator_wind_hit",
			damage_profile = "thorn_skin",
			no_friendly_fire = true
		}
	},
	static_charge = {
		name = "static_charge",
		explosion = {
			use_attacker_power_level = true,
			radius = 3,
			no_friendly_fire = true,
			max_damage_radius = 2,
			damage_profile = "static_charge",
			no_prop_damage = true,
			sound_event_name = "boon_orb_static_charge",
			attack_template = "drakegun"
		}
	},
	bad_breath = {
		name = "stagger_aoe_on_crit",
		explosion = {
			no_prop_damage = true,
			radius = 5,
			effect_name = "fx/belakor/blk_smite_01_fx",
			max_damage_radius = 2,
			use_attacker_power_level = true,
			alert_enemies_radius = 15,
			sound_event_name = "boon_bad_breath",
			attack_template = "drakegun",
			alert_enemies = true,
			damage_profile = "ability_push",
			no_friendly_fire = true
		}
	},
	static_blade = {
		name = "static_blade",
		explosion = {
			use_attacker_power_level = true,
			radius = 1,
			no_friendly_fire = true,
			max_damage_radius = 0,
			damage_profile = "markus_knight_charge",
			no_prop_damage = true,
			attack_template = "markus_knight_charge"
		}
	},
	periodic_aoe_stagger = {
		name = "periodic_aoe_stagger",
		explosion = {
			use_attacker_power_level = true,
			radius = 5,
			effect_name = "fx/chr_kruber_shockwave",
			max_damage_radius = 0,
			damage_profile = "periodic_aoe_stagger",
			no_friendly_fire = true,
			no_prop_damage = true,
			attack_template = "drakegun"
		}
	},
	boon_skulls_03 = {
		name = "boon_skulls_03",
		explosion = {
			use_attacker_power_level = true,
			radius = 5,
			no_friendly_fire = true,
			max_damage_radius = 0,
			damage_profile = "boon_skulls_03",
			no_prop_damage = true,
			attack_template = "drakegun"
		}
	}
}
var_0_2.buff_templates = {
	liquid_bravado_potion = {
		buffs = {
			{
				name = "liquid_bravado_potion",
				stat_buff = "power_level",
				max_stacks = 1,
				icon = "potion_liquid_bravado",
				remove_buff_func = "remove_deus_potion_buff",
				refresh_durations = true,
				multiplier = MorrisBuffTweakData.liquid_bravado_potion.multiplier,
				duration = MorrisBuffTweakData.liquid_bravado_potion.duration
			}
		}
	},
	liquid_bravado_potion_increased = {
		buffs = {
			{
				name = "liquid_bravado_potion_increased",
				stat_buff = "power_level",
				max_stacks = 1,
				icon = "potion_liquid_bravado",
				remove_buff_func = "remove_deus_potion_buff",
				refresh_durations = true,
				multiplier = MorrisBuffTweakData.liquid_bravado_potion_increased.multiplier,
				duration = MorrisBuffTweakData.liquid_bravado_potion_increased.duration
			}
		}
	},
	vampiric_draught_potion = {
		buffs = {
			{
				name = "vampiric_draught_potion_heal",
				remove_buff_func = "remove_deus_potion_buff",
				buff_func = "vampiric_heal",
				event = "on_damage_dealt",
				refresh_durations = true,
				max_stacks = 1,
				icon = "potion_vampiric_draught",
				duration = MorrisBuffTweakData.vampiric_draught_potion.duration,
				difficulty_multiplier = MorrisBuffTweakData.vampiric_draught_potion.difficulty_multiplier
			}
		}
	},
	vampiric_draught_potion_increased = {
		buffs = {
			{
				name = "vampiric_draught_potion_heal_increased",
				remove_buff_func = "remove_deus_potion_buff",
				buff_func = "vampiric_heal",
				event = "on_damage_dealt",
				refresh_durations = true,
				max_stacks = 1,
				icon = "potion_vampiric_draught",
				duration = MorrisBuffTweakData.vampiric_draught_potion_increased.duration,
				difficulty_multiplier = MorrisBuffTweakData.vampiric_draught_potion_increased.difficulty_multiplier
			}
		}
	},
	moot_milk_potion = {
		activation_effect = MorrisBuffTweakData.moot_milk_potion.activation_effect,
		buffs = {
			{
				buff_to_add = "moot_milk_strength",
				name = "moot_milk_potion",
				remove_buff_func = "add_buff",
				refresh_durations = true,
				max_stacks = 1,
				duration = MorrisBuffTweakData.moot_milk_potion.effect_duration
			}
		}
	},
	moot_milk_strength = {
		buffs = {
			{
				apply_buff_func = "apply_movement_buff",
				name = "moot_milk_increase_dodge_distance",
				icon = "potion_moot_milk",
				refresh_durations = true,
				remove_buff_func = "remove_movement_buff",
				max_stacks = 1,
				multiplier = MorrisBuffTweakData.moot_milk_potion.dodge_distance_multiplier,
				duration = MorrisBuffTweakData.moot_milk_potion.duration,
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			},
			{
				name = "moot_milk_increase_dodge_speed",
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				multiplier = MorrisBuffTweakData.moot_milk_potion.dodge_speed_multiplier,
				duration = MorrisBuffTweakData.moot_milk_potion.duration,
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				remove_buff_func = "remove_deus_potion_buff",
				name = "moot_milk_sound",
				refresh_durations = true,
				duration = MorrisBuffTweakData.moot_milk_potion.duration
			}
		}
	},
	moot_milk_potion_increased = {
		activation_effect = MorrisBuffTweakData.moot_milk_potion_increased.activation_effect,
		buffs = {
			{
				buff_to_add = "moot_milk_strength_increased",
				name = "moot_milk_strength_increased",
				refresh_durations = true,
				max_stacks = 1,
				remove_buff_func = "add_buff",
				duration = MorrisBuffTweakData.moot_milk_potion_increased.effect_duration
			}
		}
	},
	moot_milk_strength_increased = {
		buffs = {
			{
				apply_buff_func = "apply_movement_buff",
				name = "moot_milk_increase_dodge_distance_increased",
				icon = "potion_moot_milk",
				refresh_durations = true,
				remove_buff_func = "remove_movement_buff",
				max_stacks = 1,
				multiplier = MorrisBuffTweakData.moot_milk_potion_increased.dodge_distance_multiplier,
				duration = MorrisBuffTweakData.moot_milk_potion_increased.duration,
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			},
			{
				name = "moot_milk_increase_dodge_speed_increased",
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				multiplier = MorrisBuffTweakData.moot_milk_potion_increased.dodge_speed_multiplier,
				duration = MorrisBuffTweakData.moot_milk_potion_increased.duration,
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				remove_buff_func = "remove_deus_potion_buff",
				name = "moot_milk_sound_increased",
				refresh_durations = true,
				duration = MorrisBuffTweakData.moot_milk_potion_increased.duration
			}
		}
	},
	friendly_murderer_potion = {
		buffs = {
			{
				name = "friendly_murderer_potion",
				buff_func = "friendly_murder",
				event = "on_damage_dealt",
				remove_buff_func = "remove_deus_potion_buff",
				refresh_durations = true,
				max_stacks = 1,
				icon = "potion_friendly_murderer",
				duration = MorrisBuffTweakData.friendly_murderer_potion.duration,
				difficulty_multiplier = MorrisBuffTweakData.friendly_murderer_potion.difficulty_multiplier,
				range = MorrisBuffTweakData.friendly_murderer_potion.range
			}
		}
	},
	friendly_murderer_potion_increased = {
		buffs = {
			{
				name = "friendly_murderer_potion_increased",
				buff_func = "friendly_murder",
				event = "on_damage_dealt",
				remove_buff_func = "remove_deus_potion_buff",
				refresh_durations = true,
				max_stacks = 1,
				icon = "potion_friendly_murderer",
				duration = MorrisBuffTweakData.friendly_murderer_potion_increased.duration,
				difficulty_multiplier = MorrisBuffTweakData.friendly_murderer_potion_increased.difficulty_multiplier,
				range = MorrisBuffTweakData.friendly_murderer_potion_increased.range
			}
		}
	},
	killer_in_the_shadows_potion = {
		buffs = {
			{
				remove_buff_func = "remove_killer_in_the_shadows_buff",
				name = "killer_in_the_shadows_potion",
				icon = "potion_killer_in_the_shadows",
				refresh_durations = true,
				max_stacks = 1,
				apply_buff_func = "apply_killer_in_the_shadows_buff",
				duration = MorrisBuffTweakData.killer_in_the_shadows_potion.duration
			}
		}
	},
	killer_in_the_shadows_potion_increased = {
		buffs = {
			{
				remove_buff_func = "remove_killer_in_the_shadows_buff",
				name = "killer_in_the_shadows_potion_increased",
				icon = "potion_killer_in_the_shadows",
				refresh_durations = true,
				max_stacks = 1,
				apply_buff_func = "apply_killer_in_the_shadows_buff",
				duration = MorrisBuffTweakData.killer_in_the_shadows_potion_increased.duration
			}
		}
	},
	pockets_full_of_bombs_potion = {
		buffs = {
			{
				update_func = "update_pockets_full_of_bombs_buff",
				name = "pockets_full_of_bombs_potion",
				remove_buff_func = "remove_deus_potion_buff",
				icon = "potion_pockets_full_of_bombs",
				apply_buff_func = "apply_pockets_full_of_bombs_buff",
				duration = MorrisBuffTweakData.pockets_full_of_bombs_potion.duration,
				perks = {
					var_0_1.disable_interactions,
					var_0_1.free_grenade,
					var_0_1.rewield_grenade_on_throw
				}
			},
			{
				remove_buff_func = "remove_movement_buff",
				name = "pockets_full_of_bombs_potion_movement_speed",
				apply_buff_func = "apply_movement_buff",
				duration = MorrisBuffTweakData.pockets_full_of_bombs_potion.movespeed_duration,
				multiplier = MorrisBuffTweakData.pockets_full_of_bombs_potion.movespeed_multiplier,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	},
	pockets_full_of_bombs_potion_increased = {
		buffs = {
			{
				update_func = "update_pockets_full_of_bombs_buff",
				name = "pockets_full_of_bombs_potion_increased",
				remove_buff_func = "remove_deus_potion_buff",
				icon = "potion_pockets_full_of_bombs",
				apply_buff_func = "apply_pockets_full_of_bombs_buff",
				duration = MorrisBuffTweakData.pockets_full_of_bombs_potion_increased.duration,
				perks = {
					var_0_1.disable_interactions,
					var_0_1.free_grenade,
					var_0_1.rewield_grenade_on_throw
				}
			},
			{
				name = "pockets_full_of_bombs_potion_movement_speed_increased",
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				multiplier = MorrisBuffTweakData.pockets_full_of_bombs_potion_increased.movespeed_multiplier,
				duration = MorrisBuffTweakData.pockets_full_of_bombs_potion_increased.movespeed_duration,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	},
	hold_my_beer_potion = {
		buffs = {
			{
				activation_effect = "fx/screenspace_drink_01",
				name = "hold_my_beer_potion",
				icon = "potion_hold_my_beer",
				continuous_effect = "fx/screenspace_drink_looping",
				max_stacks = 1,
				remove_buff_func = "remove_deus_potion_buff",
				refresh_durations = true,
				duration = MorrisBuffTweakData.hold_my_beer_potion.fx_duration
			},
			{
				remove_buff_func = "remove_movement_buff",
				name = "hold_my_beer_potion_movement_speed",
				max_stacks = 1,
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				duration = MorrisBuffTweakData.hold_my_beer_potion.movespeed_duration,
				multiplier = MorrisBuffTweakData.hold_my_beer_potion.movespeed_multiplier,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				name = "hold_my_beer_potion_damage_increase",
				stat_buff = "increased_weapon_damage",
				refresh_durations = true,
				max_stacks = 1,
				duration = MorrisBuffTweakData.hold_my_beer_potion.duration,
				multiplier = MorrisBuffTweakData.hold_my_beer_potion.multiplier
			}
		}
	},
	hold_my_beer_potion_increased = {
		buffs = {
			{
				activation_effect = "fx/screenspace_drink_01",
				name = "hold_my_beer_potion_increased",
				icon = "potion_hold_my_beer",
				continuous_effect = "fx/screenspace_drink_looping",
				max_stacks = 1,
				remove_buff_func = "remove_deus_potion_buff",
				refresh_durations = true,
				duration = MorrisBuffTweakData.hold_my_beer_potion_increased.fx_duration
			},
			{
				remove_buff_func = "remove_movement_buff",
				name = "hold_my_beer_potion_movement_speed_increased",
				max_stacks = 1,
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				duration = MorrisBuffTweakData.hold_my_beer_potion_increased.movespeed_duration,
				multiplier = MorrisBuffTweakData.hold_my_beer_potion_increased.movespeed_multiplier,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				name = "hold_my_beer_potion_damage_increase_increased",
				stat_buff = "increased_weapon_damage",
				refresh_durations = true,
				max_stacks = 1,
				duration = MorrisBuffTweakData.hold_my_beer_potion_increased.duration,
				multiplier = MorrisBuffTweakData.hold_my_beer_potion_increased.multiplier
			}
		}
	},
	poison_proof_potion = {
		buffs = {
			{
				name = "poison_proof_potion",
				remove_buff_func = "remove_deus_potion_buff",
				max_stacks = 1,
				icon = "potion_poison_proof",
				refresh_durations = true,
				perks = {
					var_0_1.poison_proof
				},
				duration = MorrisBuffTweakData.poison_proof_potion.duration
			}
		}
	},
	poison_proof_potion_increased = {
		buffs = {
			{
				name = "poison_proof_potion_increased ",
				remove_buff_func = "remove_deus_potion_buff",
				max_stacks = 1,
				icon = "potion_poison_proof",
				refresh_durations = true,
				perks = {
					var_0_1.poison_proof
				},
				duration = MorrisBuffTweakData.poison_proof_potion_increased.duration
			}
		}
	},
	mark_of_nurgle = {
		buffs = {
			{
				start_sound_event_name = "Play_curse_corrupted_flesh_loop",
				name = "mark_of_nurgle",
				mark_particle = "fx/deus_corrupted_flesh_01",
				buff_func = "remove_mark_of_nurgle",
				event = "on_death",
				remove_buff_func = "remove_mark_of_nurgle",
				apply_buff_func = "apply_mark_of_nurgle",
				stop_sound_event_name = "Stop_curse_corrupted_flesh_loop"
			},
			{
				event = "on_damage_dealt",
				name = "mark_of_nurgle_dot_attack",
				buff_func = "apply_mark_of_nurgle_dot"
			},
			{
				name = "mark_of_nurgle_death_explosion",
				radius = 5,
				cloud_life_time = 4,
				buff_func = "mark_of_nurgle_explosion",
				event = "on_death",
				initial_radius = 1,
				aoe_dot_damage_interval = 1,
				aoe_init_difficulty_damage = {
					5,
					5,
					5,
					5,
					5
				},
				aoe_dot_difficulty_damage = {
					10,
					10,
					10,
					10,
					10
				}
			},
			{
				remove_on_proc = true,
				name = "mark_of_nurgle_pingable",
				buff_func = "curse_khorne_champions_leader_death",
				event = "on_death",
				remove_buff_func = "remove_make_pingable",
				apply_buff_func = "apply_make_pingable"
			}
		}
	},
	curse_mark_of_nurgle_dot = {
		buffs = {
			{
				duration = 3,
				name = "curse_mark_of_nurgle_dot",
				damage_profile = "curse_mark_of_nurgle_dot",
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 1,
				time_between_dot_damages = 1,
				max_stacks = 1,
				update_func = "apply_dot_damage"
			}
		}
	},
	curse_khorne_champions_aoe = {
		buffs = {
			{
				particle_fx = "fx/deus_curse_khorne_champions_leader",
				name = "curse_khorne_champions_leader",
				buff_func = "curse_khorne_champions_leader_death",
				event = "on_death",
				remove_buff_func = "remove_curse_khorne_champions_aoe",
				apply_buff_func = "apply_curse_khorne_champions_aoe",
				remove_on_proc = true,
				update_func = "update_curse_khorne_champions_aoe",
				in_range_units_buff_name = "curse_khorne_champions_buff",
				range_check = {
					unit_left_range_func = "unit_left_range_champions_aoe",
					radius = 8,
					update_rate = 1,
					unit_entered_range_func = "unit_entered_range_champions_aoe"
				}
			},
			{
				remove_on_proc = true,
				name = "curse_khorne_champions_aoe_pingable",
				buff_func = "curse_khorne_champions_leader_death",
				event = "on_death",
				remove_buff_func = "remove_make_pingable",
				apply_buff_func = "apply_make_pingable"
			},
			{
				unit_name = "units/props/deus_bloodgod_curse/deus_bloodgod_curse_01",
				name = "curse_khorne_champions_unit",
				buff_func = "remove_linked_unit",
				event = "on_death",
				remove_buff_func = "remove_linked_unit",
				apply_buff_func = "curse_khorne_champions_unit_link_unit",
				z_offset = {
					default = 2,
					chaos_raider = 2,
					beastmen_bestigor = 1.9,
					chaos_warrior = 2.4,
					skaven_storm_vermin_commander = 1.9,
					skaven_storm_vermin = 1.9,
					skaven_storm_vermin_with_shield = 1.9,
					skaven_storm_vermin_champion = 1.9
				}
			}
		}
	},
	curse_khorne_champions_buff = {
		buffs = {
			{
				remove_buff_func = "remove_max_health_buff_for_ai",
				name = "curse_khorne_champions_max_health",
				apply_buff_func = "apply_max_health_buff_for_ai",
				multiplier = 1
			},
			{
				remove_buff_func = "remove_attach_particle",
				name = "curse_khorne_champions_particle",
				apply_buff_func = "apply_attach_particle",
				particle_fx = "fx/deus_curse_khorne_champions_buff"
			}
		}
	},
	curse_skulls_of_fury = {
		buffs = {
			{
				name = "curse_skulls_of_fury",
				apply_buff_func = "trigger_skulls_of_fury_sound_event",
				sound_event_name = "Play_curse_skulls_of_fury_activated"
			},
			{
				decal = "units/decals/deus_decal_bloodstorm_outer",
				name = "curse_skulls_of_fury_decal",
				decal_z_offset = -2,
				decal_scale = 5,
				remove_buff_func = "remove_generic_decal",
				apply_buff_func = "apply_generic_decal"
			}
		}
	},
	curse_blood_storm_dot = {
		buffs = {
			{
				duration = 1,
				name = "curse_blood_storm_dot",
				max_stacks = 1,
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.5,
				time_between_dot_damages = 0.5,
				damage_profile = "blood_storm",
				update_func = "apply_dot_damage",
				reapply_buff_func = "reapply_dot_damage",
				perks = {
					var_0_1.bleeding
				}
			}
		}
	},
	curse_blood_storm_dot_bots = {
		buffs = {
			{
				duration = 1,
				name = "curse_blood_storm_dot",
				max_stacks = 1,
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.5,
				time_between_dot_damages = 0.5,
				damage_profile = "blood_storm_bots",
				update_func = "apply_dot_damage",
				reapply_buff_func = "reapply_dot_damage",
				perks = {
					var_0_1.bleeding
				}
			}
		}
	},
	curse_abundance_of_life = {
		buffs = {
			{
				damage_percentage = 0.01,
				name = "curse_abundance_of_life_dot",
				time_between_dot_damages = 2,
				custom_dot_tick_func = "curse_abundance_of_life_custom_dot_tick",
				update_func = "apply_dot_damage",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 2
			},
			{
				event = "on_potion_consumed",
				name = "curse_abundance_of_life_heal_on_potions",
				bonus = 100,
				buff_func = "all_potions_heal_func"
			},
			{
				event = "on_potion_consumed",
				name = "curse_abundance_of_life_vo",
				dialogue_event = "curse_positive_effect_happened",
				buff_func = "trigger_dialogue_event"
			}
		}
	},
	blessing_of_grimnir_boss_buff = {
		buffs = {
			{
				multiplier = 0.5,
				name = "blessing_of_grimnir_boss_health_buff",
				stat_buff = "max_health",
				remove_buff_func = "remove_max_health_buff_for_ai",
				apply_buff_func = "apply_max_health_buff_for_ai"
			},
			{
				multiplier = 0.5,
				name = "blessing_of_grimnir_boss_damage_buff",
				stat_buff = "damage_dealt"
			}
		}
	},
	blessing_of_grimnir_player_buff = {
		buffs = {
			{
				name = "blessing_of_grimnir_player_buff",
				multiplier = 0.2,
				stat_buff = "max_health",
				is_persistent = true,
				icon = "bardin_ironbreaker_regen_stamina_on_block_broken"
			}
		}
	},
	curse_rotten_miasma = {
		buffs = {
			{
				update_func = "update_curse_rotten_miasma",
				name = "curse_rotten_miasma",
				buff_exposure_tick_rate = 1.3,
				remove_buff_func = "remove_curse_rotten_miasma",
				apply_buff_func = "apply_curse_rotten_miasma",
				miasma_stack_limit = 35,
				safe_area_radius = {
					8,
					8,
					8,
					8,
					8
				}
			}
		}
	},
	curse_rotten_miasma_debuff = {
		buffs = {
			{
				icon = "buff_icon_mutator_icon_slayer_curse",
				name = "curse_rotten_miasma_debuff",
				debuff = true,
				perks = {
					var_0_1.slayer_curse
				}
			},
			{
				activation_effect = "fx/screenspace_deus_miasma",
				name = "curse_rotten_miasma_effect",
				continuous_effect = "fx/screenspace_deus_miasma",
				max_stacks = 1,
				remove_buff_func = "remove_curse_rotten_miasma_debuff",
				apply_buff_func = "apply_curse_rotten_miasma_debuff"
			}
		}
	},
	curse_greed_pinata_drops = {
		buffs = {
			{
				name = "curse_greed_pinata_drops",
				buff_func = "curse_greed_pinata_death",
				event = "on_death",
				update_func = "update_curse_greed_pinata_drops",
				apply_buff_func = "apply_curse_greed_pinata_drops",
				total_drops = GreedPinataSettings.total_drops,
				drop_table = GreedPinataSettings.possible_drops
			}
		}
	},
	curse_greed_pinata_spawner = {
		buffs = {
			{
				particle_fx = "fx/deus_curse_khorne_champions_leader",
				name = "curse_greed_pinata_spawner",
				buff_func = "spawn_greed_pinata",
				event = "on_death",
				remove_buff_func = "remove_attach_particle",
				apply_buff_func = "apply_attach_particle"
			}
		}
	},
	blessing_of_shallya_buff = {
		buffs = {
			{
				name = "blessing_of_shallya_buff",
				perks = {
					var_0_1.temp_to_permanent_health
				}
			}
		}
	},
	stockpile_refresh_ammo_buffs = {
		buffs = {
			{
				event = "on_inventory_post_apply_buffs",
				name = "stockpile_refresh_ammo_buffs",
				buff_func = "stockpile_refresh_ammo_buffs"
			}
		}
	},
	deus_rally_flag_aoe_buff = {
		buffs = {
			{
				remove_buff_func = "remove_deus_rally_flag",
				name = "deus_rally_flag_lifetime",
				duration = 120
			},
			{
				name = "deus_rally_flag_aoe_buff",
				update_func = "update_generic_aoe",
				remove_buff_func = "remove_generic_aoe",
				apply_buff_func = "apply_generic_aoe",
				in_range_units_buff_name = "deus_rally_flag_buff",
				range_check = {
					radius = 5,
					update_rate = 0.01,
					only_players = true,
					unit_left_range_func = "unit_left_range_generic_buff",
					unit_entered_range_func = "unit_entered_range_generic_buff"
				}
			},
			{
				decal = "units/decals/decal_deus_rally_flag_01",
				name = "deus_rally_flag_aoe_decal",
				decal_scale = 5,
				remove_buff_func = "remove_generic_decal",
				apply_buff_func = "apply_generic_decal"
			}
		}
	},
	deus_rally_flag_buff = {
		buffs = {
			{
				icon = "markus_questing_knight_buff_health_regen",
				name = "deus_rally_flag_health_buff",
				stat_buff = "max_health",
				multiplier = 0.2
			},
			{
				heal = 5,
				name = "deus_rally_flag_health_regen_buff",
				heal_type = "health_regen",
				time_between_heal = 1,
				update_func = "health_regen_update",
				apply_buff_func = "health_regen_start"
			}
		}
	},
	blessing_of_isha_invincibility = {
		buffs = {
			{
				name = "blessing_of_isha_invincibility",
				perks = {
					var_0_1.ignore_death
				}
			}
		}
	},
	blessing_of_ranald_damage_taken = {
		buffs = {
			{
				multiplier = 0.2,
				name = "blessing_of_ranald_damage_taken",
				stat_buff = "damage_taken"
			}
		}
	},
	blessing_of_ranald_coins_greed = {
		buffs = {
			{
				multiplier = 0.5,
				name = "blessing_of_ranald_coins_greed",
				stat_buff = "deus_coins_greed"
			}
		}
	},
	objective_unit = {
		buffs = {
			{
				name = "objective_unit",
				buff_func = "remove_objective_unit",
				event = "on_death",
				remove_buff_func = "remove_objective_unit",
				apply_buff_func = "apply_objective_unit"
			}
		}
	},
	cursed_chest_objective_unit = {
		buffs = {
			{
				apply_buff_func = "apply_cursed_chest_init",
				name = "cursed_chest_init"
			},
			{
				name = "cursed_chest_objective_unit",
				buff_func = "remove_objective_unit",
				event = "on_death",
				remove_buff_func = "remove_objective_unit",
				apply_buff_func = "apply_objective_unit"
			}
		}
	},
	curse_empathy_shared_health_pool = {
		buffs = {
			{
				name = "shared_health_pool",
				perks = {
					var_0_1.shared_health_pool_damage_only
				}
			}
		}
	},
	we_deus_01_kerillian_critical_bleed_dot_disable = {
		buffs = {
			{
				name = "we_deus_01_kerillian_critical_bleed_dot_disable",
				perks = {
					var_0_1.kerillian_critical_bleed_dot_disable
				}
			}
		}
	},
	wh_deus_01_victor_witchhunter_bleed_on_critical_hit_disable = {
		buffs = {
			{
				name = "wh_deus_01_victor_witchhunter_bleed_on_critical_hit_disable",
				perks = {
					var_0_1.victor_witchhunter_bleed_on_critical_hit_disable
				}
			}
		}
	},
	we_deus_01_dot = {
		buffs = {
			{
				duration = 2,
				name = "we_deus_01_dot",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.75,
				time_between_dot_damages = 0.75,
				damage_type = "burninating",
				damage_profile = "we_deus_01_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_1.burning_elven_magic
				}
			}
		}
	},
	we_deus_01_dot_fast = {
		buffs = {
			{
				name = "we_deus_01_dot_fast",
				ticks = 2,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.75,
				time_between_dot_damages = 0.75,
				damage_type = "burninating",
				damage_profile = "we_deus_01_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_1.burning_elven_magic
				}
			}
		}
	},
	we_deus_01_dot_special_charged = {
		buffs = {
			{
				name = "we_deus_01_dot_special_charged",
				ticks = 4,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.75,
				time_between_dot_damages = 0.75,
				damage_type = "burninating",
				damage_profile = "we_deus_01_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_1.burning_elven_magic
				}
			}
		}
	},
	we_deus_01_dot_charged = {
		buffs = {
			{
				name = "we_deus_01_dot_charged",
				ticks = 6,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.75,
				time_between_dot_damages = 0.75,
				damage_type = "burninating",
				damage_profile = "we_deus_01_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_1.burning_elven_magic
				}
			}
		}
	},
	health_bar = {
		buffs = {
			{
				name = "health_bar",
				buff_func = "remove_health_bar",
				event = "on_death",
				remove_buff_func = "remove_health_bar",
				apply_buff_func = "apply_health_bar"
			}
		}
	},
	burning_magma_dot = {
		buffs = {
			{
				duration = 2,
				name = "burning_magma_dot",
				max_stacks = 5,
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.5,
				time_between_dot_damages = 0.5,
				damage_type = "burninating",
				damage_profile = "burning_dot",
				update_func = "apply_dot_damage",
				reapply_buff_func = "reapply_dot_damage",
				perks = {
					var_0_1.burning
				}
			}
		}
	},
	deus_difficulty_tweak_boss_buff = {
		buffs = {
			{
				name = "deus_difficulty_tweak_boss_buff",
				apply_buff_func = "apply_max_health_buff_for_ai",
				remove_buff_func = "remove_max_health_buff_for_ai",
				variable_multiplier = {
					-0.25,
					0.25
				}
			}
		}
	},
	ledge_rescue = {
		buffs = {
			{
				rescue_delay = 0.5,
				name = "ledge_rescue",
				buff_func = "start_ledge_rescue_timer",
				event = "on_ledge_hang_start",
				update_func = "update_ledge_rescue",
				pull_up_duration = 1,
				perks = {
					var_0_1.ledge_self_rescue
				}
			}
		}
	},
	disable_rescue = {
		buffs = {
			{
				name = "disable_rescue",
				rescue_delay = 0.5,
				buff_func = "start_disable_rescue_timer",
				event = "on_player_disabled",
				update_func = "update_disable_rescue",
				explosion_template = "player_disabled_stagger",
				rescuable_disable_types = {
					pack_master_grab = true,
					assassin_pounced = true,
					corruptor_grab = true
				}
			}
		}
	},
	melee_wave_buff = {
		buffs = {
			{
				max_stacks = 3,
				name = "melee_wave_buff",
				icon = "deus_icon_melee_wave"
			}
		}
	},
	speed_over_stamina_buff = {
		buffs = {
			{
				name = "speed_over_stamina",
				stat_buff = "attack_speed",
				refresh_durations = true,
				max_stacks = 1,
				icon = "deus_icon_speed_over_stamina",
				duration = MorrisBuffTweakData.speed_over_stamina_buff.duration,
				multiplier = MorrisBuffTweakData.speed_over_stamina_buff.multiplier
			}
		}
	},
	missing_health_power_up_buff = {
		buffs = {
			{
				name = "missing_health_power_up_buff",
				stat_buff = "damage_taken",
				icon = "deus_icon_missing_health_power_up",
				multiplier = MorrisBuffTweakData.missing_health_power_up_buff.multiplier,
				max_stacks = MorrisBuffTweakData.missing_health_power_up_buff.max_stacks
			}
		}
	},
	detect_weakness_marked_enemy = {
		buffs = {
			{
				unit_name = "units/props/blk/blk_kill_the_marked",
				name = "detect_weakness_marked_enemy",
				buff_func = "remove_linked_unit",
				event = "on_death",
				remove_buff_func = "remove_linked_unit",
				apply_buff_func = "detect_weakness_link_unit",
				z_offset = {
					default = 2.2,
					chaos_raider = 2.2,
					skaven_storm_vermin_with_shield = 2.1,
					beastmen_bestigor = 2.2,
					chaos_berzerker = 2.2,
					skaven_clan_rat_with_shield = 2,
					chaos_marauder = 2.2,
					skaven_plague_monk = 2.1,
					chaos_marauder_with_shield = 2.2,
					chaos_fanatic = 2.2,
					skaven_slave = 1.9,
					skaven_clan_rat = 2,
					beastmen_ungor = 2.2,
					chaos_warrior = 2.6,
					skaven_storm_vermin_commander = 2.1,
					skaven_storm_vermin = 2.1,
					beastmen_gor = 2.2,
					skaven_storm_vermin_champion = 2.1
				}
			}
		}
	},
	detect_weakness_buff = {
		buffs = {
			{
				name = "detect_weakness_buff",
				stat_buff = "power_level",
				refresh_durations = true,
				max_stacks = 1,
				priority_buff = true,
				icon = "deus_icon_kill_the_marked",
				multiplier = MorrisBuffTweakData.detect_weakness_buff.multiplier,
				duration = MorrisBuffTweakData.detect_weakness_buff.duration
			}
		}
	},
	squats_build_up_buff = {
		buffs = {
			{
				name = "squats_build_up_buff",
				refresh_durations = true,
				duration = MorrisBuffTweakData.squats_build_up_buff.duration,
				max_stacks = MorrisBuffTweakData.squats_build_up_buff.max_stacks
			}
		}
	},
	squats_buff = {
		buffs = {
			{
				name = "squats_buff",
				stat_buff = "power_level",
				icon = "deus_icon_squats",
				max_stacks = 1,
				priority_buff = true,
				multiplier = MorrisBuffTweakData.squats_buff.multiplier,
				duration = MorrisBuffTweakData.squats_buff.duration
			}
		}
	},
	guaranteed_crit_buff = {
		buffs = {
			{
				max_stacks = 1,
				name = "guaranteed_crit_buff",
				buff_func = "dummy_function",
				event = "on_critical_action",
				icon = "bardin_ranger_linesman_unbalance",
				remove_on_proc = true,
				perks = {
					var_0_1.guaranteed_crit
				}
			}
		}
	},
	follow_up_guaranteed_crit_buff = {
		buffs = {
			{
				max_stacks = 1,
				name = "follow_up_guaranteed_crit_buff",
				buff_func = "dummy_function",
				event = "on_critical_action",
				icon = "deus_icon_buff_follow_up",
				priority_buff = true,
				remove_on_proc = true,
				perks = {
					var_0_1.guaranteed_crit
				}
			}
		}
	},
	wolfpack_buff = {
		buffs = {
			{
				name = "wolfpack_buff",
				stat_buff = "power_level",
				max_stacks = 4,
				icon = "deus_icon_wolfpack",
				multiplier = MorrisBuffTweakData.wolfpack_buff.multiplier
			}
		}
	},
	comradery_buff = {
		buffs = {
			{
				name = "comradery_buff",
				stat_buff = "power_level_melee",
				max_stacks = 4,
				icon = "deus_icon_comradery",
				multiplier = MorrisBuffTweakData.comradery_buff.multiplier
			}
		}
	},
	invigorating_strike_cooldown = {
		buffs = {
			{
				icon = "deus_icon_invigorating_strike",
				name = "invigorating_strike_cooldown",
				max_stacks = 1,
				is_cooldown = true,
				duration = MorrisBuffTweakData.invigorating_strike_cooldown.duration
			}
		}
	},
	staggering_force_buff = {
		buffs = {
			{
				name = "staggering_force_buff",
				stat_buff = "power_level",
				refresh_durations = true,
				max_stacks = 1,
				icon = "deus_icon_staggering_force",
				duration = MorrisBuffTweakData.staggering_force_buff.duration,
				multiplier = MorrisBuffTweakData.staggering_force_buff.multiplier
			}
		}
	},
	crescendo_strike_buff = {
		buffs = {
			{
				refresh_durations = true,
				name = "crescendo_strike_buff",
				stat_buff = "critical_strike_chance",
				icon = "deus_icon_buff_crescendo_strike",
				duration = MorrisBuffTweakData.crescendo_strike_buff.duration,
				max_stacks = MorrisBuffTweakData.crescendo_strike_buff.max_stacks,
				bonus = MorrisBuffTweakData.crescendo_strike_buff.bonus
			}
		}
	},
	lucky_buff = {
		buffs = {
			{
				name = "lucky_buff",
				stat_buff = "critical_strike_chance",
				max_stacks = 20,
				icon = "deus_icon_lucky",
				bonus = MorrisBuffTweakData.lucky_buff.bonus
			}
		}
	},
	hidden_escape_buff = {
		buffs = {
			{
				apply_buff_func = "hidden_escape_apply",
				name = "hidden_escape_buff",
				icon = "deus_icon_hidden_escape",
				remove_buff_func = "hidden_escape_remove",
				cooldown_buff = "hidden_escape_cooldown_buff",
				duration = MorrisBuffTweakData.hidden_escape_buff.duration
			},
			{
				event = "on_hit",
				name = "hidden_escape_on_hit",
				buff_func = "hidden_escape_on_hit"
			}
		}
	},
	hidden_escape_cooldown_buff = {
		buffs = {
			{
				is_cooldown = true,
				name = "hidden_escape_cooldown_buff",
				icon = "deus_icon_hidden_escape",
				duration = MorrisBuffTweakData.hidden_escape_cooldown_buff.duration
			}
		}
	},
	curative_empowerment_buff = {
		buffs = {
			{
				name = "curative_empowerment_buff",
				stat_buff = "power_level",
				refresh_durations = true,
				max_stacks = 5,
				icon = "deus_icon_curative_empowerment",
				multiplier = MorrisBuffTweakData.curative_empowerment_buff.multiplier,
				duration = MorrisBuffTweakData.curative_empowerment_buff.duration
			}
		}
	},
	pent_up_anger_buff = {
		buffs = {
			{
				reset_on_max_stacks = true,
				name = "pent_up_anger_buff",
				on_max_stacks_overflow_func = "add_remove_buffs",
				on_max_stacks_func = "add_remove_buffs",
				icon = "deus_icon_pent_up_anger",
				max_stacks = MorrisBuffTweakData.pent_up_anger_buff.max_stacks,
				max_stack_data = {
					buffs_to_add = {
						"pent_up_anger_guaranteed_crit_buff"
					}
				}
			}
		}
	},
	pent_up_anger_guaranteed_crit_buff = {
		buffs = {
			{
				max_stacks = 1,
				name = "pent_up_anger_guaranteed_crit_buff",
				buff_func = "dummy_function",
				event = "on_critical_action",
				icon = "deus_icon_pent_up_anger",
				priority_buff = true,
				remove_on_proc = true,
				perks = {
					var_0_1.guaranteed_crit
				}
			}
		}
	},
	surprise_strike_guaranteed_crit_buff = {
		buffs = {
			{
				icon = "deus_icon_surprise_strike",
				name = "surprise_strike_guaranteed_crit_buff",
				perks = {
					var_0_1.guaranteed_crit
				},
				duration = MorrisBuffTweakData.surprise_strike_guaranteed_crit_buff.duration
			}
		}
	},
	bad_breath_cooldown_buff = {
		buffs = {
			{
				is_cooldown = true,
				name = "bad_breath_cooldown_buff",
				icon = "deus_icon_bad_breath",
				duration = MorrisBuffTweakData.bad_breath_cooldown_buff.duration
			}
		}
	},
	boulder_bro_buff = {
		buffs = {
			{
				buff_to_add = "boulder_bro_cooldown_buff",
				rescue_delay = 0.5,
				name = "boulder_bro_perk",
				buff_func = "start_boulder_bro_timer",
				event = "on_ledge_hang_start",
				remove_buff_func = "boulder_bro_add_buff",
				update_func = "update_boulder_bro",
				pull_up_duration = 1,
				perks = {
					var_0_1.ledge_self_rescue
				}
			}
		}
	},
	boulder_bro_cooldown_buff = {
		buffs = {
			{
				buff_to_add = "boulder_bro_buff",
				name = "boulder_bro_cooldown_buff",
				icon = "deus_icon_boulder_bro",
				is_cooldown = true,
				remove_buff_func = "boulder_bro_add_buff",
				duration = MorrisBuffTweakData.boulder_bro_cooldown_buff.duration
			}
		}
	},
	static_blade_cooldown_buff = {
		buffs = {
			{
				is_cooldown = true,
				name = "static_blade_cooldown_buff",
				icon = "deus_icon_static_blade",
				duration = MorrisBuffTweakData.static_blade_cooldown_buff.duration
			}
		}
	},
	home_run = {
		buffs = {
			{
				multiplier = 10,
				name = "home_run",
				stat_buff = "hit_force"
			},
			{
				multiplier = 0.5,
				name = "home_run_hit_mass_reduction",
				stat_buff = "applied_stagger_distance"
			},
			{
				multiplier = 0.4,
				name = "home_run_impact",
				stat_buff = "power_level_impact"
			},
			{
				sound_event = "boon_homerun",
				name = "home_run_sound",
				cooldown = 0.25,
				buff_func = "home_run_sound",
				event = "on_body_pushed"
			}
		}
	},
	shield_splinters = {
		buffs = {
			{
				event = "on_broke_shield",
				name = "shield_splinters",
				explosion_template = "shield_splinters",
				buff_func = "shield_splinters_explosion"
			}
		}
	},
	refilling_shot = {
		create_parent_buff_shared_table = true,
		buffs = {
			{
				event = "on_start_action",
				name = "refilling_shot",
				buff_func = "refilling_shot_on_start_action"
			},
			{
				event = "on_ammo_used",
				name = "refilling_shot_on_ammo_used",
				buff_func = "refilling_shot_on_ammo_used"
			},
			{
				event = "on_critical_hit",
				name = "refilling_shot_critical_hit_ammo_reload",
				buff_func = "refilling_shot_on_critical_hit"
			}
		}
	},
	piercing_projectiles = {
		buffs = {
			{
				name = "piercing_projectiles",
				stat_buff = "ranged_additional_penetrations",
				bonus = MorrisBuffTweakData.piercing_projectiles.bonus
			}
		}
	},
	serrated_blade = {
		buffs = {
			{
				name = "serrated_blade",
				perks = {
					var_0_1.generic_melee_bleed
				}
			}
		}
	},
	crescendo_strike = {
		buffs = {
			{
				event = "on_critical_hit",
				name = "crescendo_strike",
				buff_to_add = "crescendo_strike_buff",
				buff_func = "crescendo_strike_on_crit"
			}
		}
	},
	follow_up = {
		buffs = {
			{
				name = "follow_up",
				blocker_buff = "follow_up_cooldown",
				buff_func = "add_buffs_on_melee_headshot",
				event = "on_hit",
				buffs_to_add = {
					"follow_up_guaranteed_crit_buff",
					"follow_up_cooldown"
				}
			}
		}
	},
	follow_up_cooldown = {
		buffs = {
			{
				name = "follow_up_cooldown",
				duration = MorrisBuffTweakData.follow_up_cooldown.duration
			}
		}
	},
	deus_extra_shot = {
		buffs = {
			{
				name = "deus_extra_shot",
				stat_buff = "extra_shot",
				bonus = MorrisBuffTweakData.deus_extra_shot.bonus
			}
		}
	},
	always_blocking = {
		buffs = {
			{
				buff_to_add = "deus_always_blocking_buff",
				name = "always_blocking",
				update_func = "always_blocking_update",
				remove_buff_func = "always_blocking_remove",
				apply_buff_func = "always_blocking_init"
			},
			{
				event = "on_block_broken",
				name = "block_broken_remove_buff",
				buff_func = "always_blocking_temporarily_remove"
			}
		}
	},
	deus_big_swing_stagger = {
		buffs = {
			{
				buff_to_add = "deus_big_swing_stagger_buff",
				name = "deus_big_swing_stagger",
				buff_func = "deus_big_swing_stagger_on_hit",
				event = "on_hit",
				targets_to_hit = MorrisBuffTweakData.deus_big_swing_stagger_buff.targets_to_hit
			}
		}
	},
	deus_always_blocking_buff = {
		buffs = {
			{
				remove_buff_func = "remove_always_blocking",
				name = "deus_always_blocking_buff",
				apply_buff_func = "apply_always_blocking"
			}
		}
	},
	deus_always_blocking_lock_out = {
		buffs = {
			{
				refresh_durations = true,
				name = "deus_always_blocking_lock_out",
				icon = "deus_icon_always_blocking_01",
				debuff = true,
				max_stacks = 1,
				duration = 10
			}
		}
	},
	deus_big_swing_stagger_buff = {
		buffs = {
			{
				refresh_durations = true,
				name = "deus_big_swing_stagger_buff",
				stat_buff = "power_level_impact",
				icon = "deus_icon_big_swing_stagger",
				max_stacks = 1,
				duration = MorrisBuffTweakData.deus_big_swing_stagger_buff.duration,
				multiplier = MorrisBuffTweakData.deus_big_swing_stagger_buff.multiplier
			}
		}
	},
	deus_ammo_pickup_reload_speed_buff = {
		buffs = {
			{
				name = "deus_ammo_pickup_reload_speed_buff",
				stat_buff = "reload_speed",
				refresh_durations = true,
				remove_buff_func = "remove_ammo_reload_speed_buff",
				apply_buff_func = "apply_ammo_reload_speed_buff",
				max_stacks = 1,
				icon = "deus_icon_ammo_pickup_reload_speed",
				multiplier = MorrisBuffTweakData.deus_ammo_pickup_reload_speed_buff.multiplier,
				duration = MorrisBuffTweakData.deus_ammo_pickup_reload_speed_buff.duration
			}
		}
	},
	deus_ammo_pickup_reload_speed = {
		buffs = {
			{
				name = "deus_ammo_pickup_reload_speed",
				authority = "client",
				buff_func = "add_buff_on_pickup",
				event = "on_consumable_picked_up",
				pickup_types = {
					ammo = {
						"deus_ammo_pickup_reload_speed_buff"
					}
				}
			}
		}
	},
	deus_crit_chain_lightning = {
		buffs = {
			{
				sound_event = "morris_power_ups_lightning_strike",
				name = "deus_crit_chain_lightning",
				authority = "server",
				buff_func = "chain_lightning",
				event = "on_player_damage_dealt",
				damage_profile = "beam_shot",
				particle_name = "",
				damage_source = "buff",
				max_targets = MorrisBuffTweakData.deus_crit_chain_lightning.max_targets,
				max_chain_range = MorrisBuffTweakData.deus_crit_chain_lightning.max_chain_range
			}
		}
	},
	deus_ranged_crit_explosion = {
		buffs = {
			{
				sound_event = "morris_power_ups_ammo_explosion",
				name = "deus_ranged_crit_explosion",
				authority = "server",
				buff_func = "deus_ranged_crit_explosion_on_damage_dealt",
				event = "on_hit",
				cooldown_buff = "deus_ranged_crit_explosion_cooldown",
				explosion_template = "deus_ranged_crit_explosion",
				valid_attack_types = {
					instant_projectile = true,
					heavy_instant_projectile = true,
					projectile = true
				},
				power_scale = MorrisBuffTweakData.deus_ranged_crit_explosion.multiplier
			}
		}
	},
	deus_ranged_crit_explosion_cooldown = {
		buffs = {
			{
				name = "deus_ranged_crit_explosion_cooldown",
				icon = "deus_ranged_crit_explosion",
				duration = MorrisBuffTweakData.deus_ranged_crit_explosion.cooldown_duration
			}
		}
	},
	deus_collateral_damage_on_melee_killing_blow = {
		buffs = {
			{
				name = "deus_collateral_damage_on_melee_killing_blow",
				authority = "server",
				buff_func = "deus_collateral_damage_on_melee_killing_blow_func",
				event = "on_kill",
				sound_event = "morris_power_ups_extra_damage",
				max_range = MorrisBuffTweakData.deus_collateral_damage_on_melee_killing_blow.max_range,
				proc_chance = MorrisBuffTweakData.deus_collateral_damage_on_melee_killing_blow.proc_chance
			}
		}
	},
	health_orb = {
		buffs = {
			{
				name = "health_orb",
				apply_buff_func = "health_orb_apply_func",
				duration = 0,
				granted_health = MorrisBuffTweakData.health_orbs.orb_health
			}
		}
	},
	static_charge = {
		buffs = {
			{
				activation_effect = "fx/screenspace_potion_01",
				name = "static_charge",
				update_func = "update_static_charge",
				refresh_durations = true,
				remove_buff_func = "remove_static_charge",
				apply_buff_func = "start_static_charge",
				explosion_template = "static_charge",
				icon = "twitch_icon_heavens_lightning",
				tick_every_t = 1,
				duration = MorrisBuffTweakData.static_charge.orb_duration
			}
		}
	},
	protection_orb = {
		buffs = {
			{
				name = "protection_orb",
				stat_buff = "damage_taken",
				icon = "deus_icon_protection",
				max_stacks = 1,
				multiplier = MorrisBuffTweakData.protection_orb.multiplier,
				duration = MorrisBuffTweakData.protection_orb.duration
			}
		}
	},
	focused_accuracy_cooldown = {
		buffs = {
			{
				name = "focused_accuracy_cooldown",
				debuff = true,
				is_cooldown = true,
				icon = "deus_icon_focussed_accuracy",
				duration = MorrisBuffTweakData.focused_accuracy.cooldown_duration
			}
		}
	},
	ability_cooldown_reduction_orb = {
		buffs = {
			{
				name = "ability_cooldown_reduction_orb",
				stat_buff = "cooldown_regen",
				refresh_durations = true,
				max_stacks = 1,
				icon = "deus_icon_focussed_accuracy",
				multiplier = MorrisBuffTweakData.ability_cooldown_reduction_orb.multiplier,
				duration = MorrisBuffTweakData.ability_cooldown_reduction_orb.duration
			}
		}
	},
	resolve_cooldown_buff = {
		buffs = {
			{
				is_cooldown = true,
				name = "resolve_cooldown_buff",
				icon = "deus_icon_resolve",
				duration = MorrisBuffTweakData.resolve.cooldown
			}
		}
	},
	resolve_buff = {
		buffs = {
			{
				name = "resolve_buff",
				perks = {
					var_0_1.full_health_revive
				}
			}
		}
	},
	deus_extra_damage_aura_debuff = {
		buffs = {
			{
				name = "deus_extra_damage_aura_debuff",
				stat_buff = "damage_taken",
				multiplier = MorrisBuffTweakData.boon_aura_01.multiplier,
				max_stacks = math.huge
			}
		}
	},
	teammates_extra_damage_counteract_buff = {
		buffs = {
			{
				name = "teammates_extra_damage_counteract_buff",
				stat_buff = "damage_dealt",
				duration = 0,
				multiplier = 1 / (1 + MorrisBuffTweakData.boon_aura_01.multiplier) - 1,
				max_stacks = math.huge
			}
		}
	},
	deus_extra_stagger_aura_debuff = {
		buffs = {
			{
				name = "deus_extra_stagger_aura_debuff",
				stat_buff = "impact_vulnerability",
				multiplier = MorrisBuffTweakData.boon_aura_02.multiplier,
				max_stacks = math.huge
			}
		}
	},
	teammates_extra_stagger_counteract_buff = {
		buffs = {
			{
				name = "teammates_extra_stagger_counteract_buff",
				stat_buff = "power_level_impact",
				duration = 0,
				multiplier = 1 / (1 + MorrisBuffTweakData.boon_aura_02.multiplier) - 1,
				max_stacks = math.huge
			}
		}
	},
	boon_teamaura_02_stagger_buff = {
		buffs = {
			{
				name = "boon_teamaura_02_stagger_buff",
				stat_buff = "power_level_impact",
				duration = 0,
				multiplier = MorrisBuffTweakData.boon_teamaura_02_data.multiplier,
				max_stacks = math.huge
			}
		}
	},
	boon_teamaura_01_damage_buff = {
		buffs = {
			{
				name = "boon_teamaura_01_damage_buff",
				stat_buff = "damage_dealt",
				duration = 0,
				multiplier = MorrisBuffTweakData.boon_teamaura_01_data.multiplier,
				max_stacks = math.huge
			}
		}
	},
	boon_meta_01_stack = {
		buffs = {
			{
				name = "boon_meta_01_stack",
				stat_buff = "damage_dealt",
				multiplier = MorrisBuffTweakData.boon_meta_01_data.damage_multiplier_per_stack,
				max_stacks = math.huge
			},
			{
				name = "boon_meta_01_stack_atk_speed",
				stat_buff = "attack_speed",
				multiplier = MorrisBuffTweakData.boon_meta_01_data.attack_speed_multiplier_per_stack,
				max_stacks = math.huge
			}
		}
	},
	boon_weaponrarity_01_debuff = {
		buffs = {
			{
				name = "boon_weaponrarity_01_debuff",
				stat_buff = "cooldown_regen",
				multiplier = MorrisBuffTweakData.boon_weaponrarity_01_data.multiplier_per_rarity,
				max_stacks = math.huge
			}
		}
	},
	boon_weaponrarity_02_debuff = {
		buffs = {
			{
				name = "boon_weaponrarity_02_debuff",
				stat_buff = "critical_strike_chance",
				bonus = MorrisBuffTweakData.boon_weaponrarity_02_data.bonus_per_rarity,
				max_stacks = math.huge
			}
		}
	},
	boon_range_02_buff_adder = {
		buffs = {
			{
				duration = 0,
				name = "boon_range_02_buff_adder",
				remove_buff_func = "boon_range_02_buff_adder_add_buff"
			}
		}
	},
	boon_range_02_increased_damage_tracker = {
		buffs = {
			{
				name = "boon_range_02_increased_damage_tracker",
				duration = MorrisBuffTweakData.boon_range_02_data.duration,
				max_stacks = math.huge
			}
		}
	},
	boon_range_02_damage_amplifier = {
		buffs = {
			{
				name = "boon_range_02_damage_amplifier",
				stat_buff = "damage_taken",
				duration = 0,
				max_stacks = math.huge,
				multiplier = MorrisBuffTweakData.boon_range_02_data.multiplier
			}
		}
	}
}

table.merge_recursive(var_0_2.buff_templates, DeusPowerUpBuffTemplates)
