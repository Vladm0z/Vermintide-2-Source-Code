-- chunkname: @scripts/settings/dlcs/morris/morris_buff_settings.lua

require("scripts/settings/dlcs/morris/deus_power_up_settings")
require("scripts/settings/dlcs/morris/greed_pinata_settings")
require("scripts/settings/dlcs/morris/tweak_data/buff_tweak_data")

local scripts_utils_buff_area_helper = require("scripts/utils/buff_area_helper")
local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local morris = DLCSettings.morris

local function fn(arg_1_0)
	-- function 1
	local owner = Managers.player:owner(arg_1_0)

	return not owner and not owner.remote
end

local function fn_2(arg_2_0)
	-- function 2
	local owner = Managers.player:owner(arg_2_0)

	return not owner and owner.bot_player
end

local function fn_3(arg_3_0)
	-- function 3
	local var_3_0 = fn(arg_3_0)

	var_3_0 = not var_3_0 and not fn_2(arg_3_0)

	return var_3_0
end

local function fn_4()
	-- function 4
	return Managers.state.network.is_server
end

local function fn_5(arg_5_0)
	-- function 5
	local owner = Managers.player:owner(arg_5_0)
	local remote

	if not owner then
		remote = owner.remote

		if not remote then
			-- Nothing
		end

		remote = owner.bot_player

		if not remote then
			-- Nothing
		end
	end

	remote = false

	::label_5_0::

	return remote
end

local function fn_6(arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	if not ALIVE[arg_6_0] then
		if not fn_4() then
			DamageUtils.heal_network(arg_6_0, arg_6_0, arg_6_2, arg_6_1)
		else
			local network = Managers.state.network
			local unit_game_object_id = network:unit_game_object_id(arg_6_0)
			local var_6_2 = NetworkLookup.heal_types[arg_6_1]

			network.network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, arg_6_2, var_6_2)
		end
	end
end

local function fn_7(self, arg_7_1)
	-- function 7
	local template = self.template
	local var_7_1

	if not template.pickup_names then
		var_7_1 = template.pickup_names[arg_7_1.pickup_name]

		if not var_7_1 then
			-- Nothing
		end
	end

	if not template.pickup_slot_names then
		var_7_1 = template.pickup_slot_names[arg_7_1.slot_name]

		if not var_7_1 then
			-- Nothing
		end
	end

	var_7_1 = template.pickup_types
	var_7_1 = not var_7_1 and template.pickup_types[arg_7_1.type]

	::label_7_0::

	return var_7_1
end

local function fn_8(arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local random = math.random()
	local num = 0
	local num_2 = arg_8_1 + Vector3(math.random(-0.5, 0.5), math.random(-0.5, 0.5), 2)

	for k, v in pairs(arg_8_0) do
		num = num + v.drop_weight

		if not (random <= num) or not v.spawn_function(k, num_2, v.pickup_data, arg_8_2) then
			break
		end
	end
end

local function fn_9(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	if not (not fn(arg_9_0) and fn_2(arg_9_0)) then
		local wwise_world = Managers.world:wwise_world(arg_9_3)

		WwiseWorld.trigger_event(wwise_world, "Play_potion_morris_effect_end")
	end
end

local function fn_10(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	-- function 10
	local position_network_scale = AiAnimUtils.position_network_scale(arg_10_1, true)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(arg_10_2, true)
	local velocity_network_scale = AiAnimUtils.velocity_network_scale(arg_10_3, true)
	local time = Managers.time:time("game")
	local random_range = Math.random_range(-arg_10_6, arg_10_6)
	local tbl = {
		explode_time = time + arg_10_4 + random_range,
		fuse_time = arg_10_5,
		attacker_unit_id = Managers.state.network:unit_game_object_id(arg_10_7)
	}
	local tbl_2 = {
		projectile_locomotion_system = {
			network_position = position_network_scale,
			network_rotation = rotation_network_scale,
			network_velocity = velocity_network_scale,
			network_angular_velocity = velocity_network_scale
		},
		death_system = {
			in_hand = false,
			death_data = tbl,
			item_name = arg_10_0
		},
		health_system = {
			damage = 1,
			health_data = tbl,
			item_name = arg_10_0
		},
		pickup_system = {
			has_physics = true,
			spawn_type = "loot",
			pickup_name = arg_10_0
		}
	}
	local var_10_7 = AllPickups[arg_10_0]
	local unit_name = var_10_7.unit_name
	local unit_template_name = var_10_7.unit_template_name

	unit_template_name = unit_template_name or "pickup_unit"

	return Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl_2, arg_10_1, arg_10_2)
end

local function fn_11(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	Managers.state.entity:system("projectile_system"):spawn_drones(arg_11_0, "deus_damage_drone", arg_11_1, arg_11_2, SideRelations.enemy, arg_11_3)
end

morris.buff_function_templates = {
	update_stockpile_buff = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		-- function 12
		if not arg_12_1.buffs_applied then
			return
		end

		local has_extension = ScriptUnit.has_extension(arg_12_0, "inventory_system")

		if not has_extension then
			has_extension:refresh_buffs_on_ammo()

			arg_12_1.buffs_applied = true
		end
	end,
	remove_stockpile_buff = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
		-- function 13
		ScriptUnit.extension(arg_13_0, "buff_system"):add_buff("stockpile_refresh_ammo_buffs")
	end,
	start_armor_breaker = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
		-- function 14
		arg_14_1.next_tick_t = arg_14_2.t + 0.5

		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local wwise_world = Managers.world:wwise_world(arg_14_3)
		local num = 0
		local var_14_4

		if arg_14_0 == flag then
			local extension = ScriptUnit.extension(flag, "career_system")

			local function fn(arg_15_0, arg_15_1)
				-- function 15
				local get_loadout_item = BackendUtils.get_loadout_item(arg_15_0, arg_15_1)
				local traits = get_loadout_item.traits

				if not traits then
					for i, v in ipairs(traits) do
						if v == "armor_breaker" then
							return get_loadout_item.power_level
						end
					end
				end

				return arg_14_1.template.default_power_level
			end

			local career_name = extension:career_name()

			num = math.max(fn(career_name, "slot_melee"), fn(career_name, "slot_ranged"))

			local first_person_unit = ScriptUnit.extension(arg_14_0, "first_person_system").first_person_unit

			var_14_4 = World.create_particles(arg_14_3, "fx/magic_wind_metal_blade_dance_01_1p", POSITION_LOOKUP[first_person_unit])

			World.link_particles(arg_14_3, var_14_4, first_person_unit, Unit.node(first_person_unit, "root_point"), Matrix4x4.identity(), "stop")
			WwiseWorld.trigger_event(wwise_world, "Play_wind_metal_gameplay_mutator_wind_loop")
		else
			WwiseUtils.trigger_unit_event(arg_14_3, "Play_wind_metal_gameplay_mutator_wind_loop", arg_14_0, 0)

			var_14_4 = World.create_particles(arg_14_3, "fx/magic_wind_metal_blade_dance_01", POSITION_LOOKUP[arg_14_0])

			World.link_particles(arg_14_3, var_14_4, arg_14_0, Unit.node(arg_14_0, "root_point"), Matrix4x4.identity(), "stop")
		end

		arg_14_1.power_level = num
		arg_14_1.linked_effect = var_14_4
	end,
	update_armor_breaker = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		if arg_16_2.t >= arg_16_1.next_tick_t then
			arg_16_1.next_tick_t = arg_16_2.t + 0.5

			local system = Managers.state.entity:system("area_damage_system")
			local num = POSITION_LOOKUP[arg_16_0] + Vector3(0, 0, 1)
			local local_rotation = Unit.local_rotation(arg_16_0, 0)

			system:create_explosion(arg_16_0, num, local_rotation, "armor_breaker", 1, "undefined", arg_16_1.power_level, false)
		end
	end,
	remove_armor_breaker = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
		-- function 17
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local wwise_world = Managers.world:wwise_world(arg_17_3)

		if arg_17_0 == flag then
			WwiseWorld.trigger_event(wwise_world, "Stop_wind_metal_gameplay_mutator_wind_loop")
		else
			WwiseUtils.trigger_unit_event(arg_17_3, "Stop_wind_metal_gameplay_mutator_wind_loop", arg_17_0, 0)
		end

		local linked_effect = arg_17_1.linked_effect

		if not linked_effect then
			World.destroy_particles(arg_17_3, linked_effect)

			arg_17_1.linked_effect = nil
		end
	end,
	apply_mark_of_nurgle = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		-- function 18
		if not DEDICATED_SERVER then
			return
		end

		local template = arg_18_1.template
		local mark_particle = template.mark_particle
		local create_particles = World.create_particles(arg_18_3, mark_particle, POSITION_LOOKUP[arg_18_0])

		World.link_particles(arg_18_3, create_particles, arg_18_0, Unit.node(arg_18_0, "j_spine"), Matrix4x4.identity(), "stop")

		local start_sound_event_name = template.start_sound_event_name
		local trigger_unit_event, var_18_5, var_18_6 = WwiseUtils.trigger_unit_event(arg_18_3, start_sound_event_name, arg_18_0, 0)

		arg_18_1.sound_id = trigger_unit_event
		arg_18_1.wwise_world = var_18_6
		arg_18_1.linked_effect = create_particles
	end,
	remove_mark_of_nurgle = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		-- function 19
		local linked_effect = arg_19_1.linked_effect

		if not linked_effect then
			World.destroy_particles(arg_19_3, linked_effect)

			arg_19_1.linked_effect = nil
		end

		local sound_id = arg_19_1.sound_id

		if not sound_id then
			WwiseWorld.stop_event(arg_19_1.wwise_world, sound_id)

			arg_19_1.sound_id = nil
		end
	end,
	apply_generic_aoe = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		-- function 20
		scripts_utils_buff_area_helper.setup_range_check(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	end,
	update_generic_aoe = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
		-- function 21
		scripts_utils_buff_area_helper.update_range_check(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	end,
	unit_entered_range_generic_buff = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
		-- function 22
		local has_extension = ScriptUnit.has_extension(arg_22_0, "buff_system")

		if not has_extension then
			if not fn_5(arg_22_0) then
				local wwise_world = Managers.world:wwise_world(arg_22_4)

				WwiseWorld.trigger_event(wwise_world, "Play_blessing_rally_flag_loop")
			end

			local in_range_units_buff_name = arg_22_2.template.in_range_units_buff_name

			return (has_extension:add_buff(in_range_units_buff_name))
		end
	end,
	unit_left_range_generic_buff = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
		-- function 23
		if not ALIVE[arg_23_0] then
			if not fn_5(arg_23_0) then
				local wwise_world = Managers.world:wwise_world(arg_23_5)

				WwiseWorld.trigger_event(wwise_world, "Stop_blessing_rally_flag_loop")
			end

			ScriptUnit.extension(arg_23_0, "buff_system"):remove_buff(arg_23_1)
		end
	end,
	remove_generic_aoe = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
		-- function 24
		scripts_utils_buff_area_helper.destroy_range_check(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	end,
	apply_generic_decal = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
		-- function 25
		local decal_z_offset = arg_25_1.template.decal_z_offset

		decal_z_offset = decal_z_offset or 0

		local copy = Vector3.copy(POSITION_LOOKUP[arg_25_0])

		copy.z = copy.z + decal_z_offset

		local decal = arg_25_1.template.decal
		local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(decal, copy)
		local decal_scale = arg_25_1.template.decal_scale

		decal_scale = decal_scale or 1

		Unit.set_local_scale(spawn_local_unit, 0, Vector3(decal_scale, decal_scale, decal_scale))

		arg_25_1.linked_decal = spawn_local_unit
	end,
	remove_generic_decal = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
		-- function 26
		local linked_decal = arg_26_1.linked_decal

		if not linked_decal then
			Managers.state.unit_spawner:mark_for_deletion(linked_decal)
		end
	end,
	apply_curse_khorne_champions_aoe = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		-- function 27
		local create_particles = World.create_particles(arg_27_3, arg_27_1.template.particle_fx, POSITION_LOOKUP[arg_27_0])

		arg_27_1.fx_id = create_particles

		World.link_particles(arg_27_3, create_particles, arg_27_0, Unit.node(arg_27_0, "j_spine"), Matrix4x4.identity(), "stop")
		scripts_utils_buff_area_helper.setup_range_check(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	end,
	update_curse_khorne_champions_aoe = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
		-- function 28
		scripts_utils_buff_area_helper.update_range_check(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	end,
	unit_entered_range_champions_aoe = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
		-- function 29
		if not DamageUtils.is_enemy(arg_29_0, arg_29_1) then
			local has_extension = ScriptUnit.has_extension(arg_29_0, "buff_system")

			if not has_extension then
				local in_range_units_buff_name = arg_29_2.template.in_range_units_buff_name

				return (has_extension:add_buff(in_range_units_buff_name))
			end
		end
	end,
	unit_left_range_champions_aoe = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
		-- function 30
		if not arg_30_1 and not ALIVE[arg_30_0] then
			ScriptUnit.extension(arg_30_0, "buff_system"):remove_buff(arg_30_1)
		end
	end,
	remove_curse_khorne_champions_aoe = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
		-- function 31
		World.stop_spawning_particles(arg_31_3, arg_31_1.fx_id)
		scripts_utils_buff_area_helper.destroy_range_check(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	end,
	curse_khorne_champions_unit_link_unit = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
		-- function 32
		local template = arg_32_1.template
		local unit_name = template.unit_name
		local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(unit_name, POSITION_LOOKUP[arg_32_0])

		Managers.state.unit_spawner:create_unit_extensions(Unit.world(spawn_local_unit), spawn_local_unit, "prop_unit")
		World.link_unit(Unit.world(arg_32_0), spawn_local_unit, 0, arg_32_0, Unit.node(arg_32_0, "root_point"))

		arg_32_1.linked_unit = spawn_local_unit

		local z_offset = template.z_offset
		local var_32_4 = z_offset[Unit.get_data(arg_32_0, "breed").name]

		var_32_4 = var_32_4 or z_offset.default

		Unit.set_local_position(spawn_local_unit, 0, Vector3(0, 0, var_32_4))
	end,
	remove_linked_unit = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
		-- function 33
		if not arg_33_1.linked_unit then
			World.unlink_unit(Unit.world(arg_33_1.linked_unit), arg_33_1.linked_unit)
			Managers.state.unit_spawner:mark_for_deletion(arg_33_1.linked_unit)

			arg_33_1.linked_unit = nil
		end
	end,
	apply_curse_greed_pinata_drops = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
		-- function 34
		local extension = ScriptUnit.extension(arg_34_0, "health_system")

		if not extension then
			arg_34_1.health_extension = extension

			local num = extension:get_max_health() / arg_34_1.template.total_drops
			local get_damage_taken = arg_34_1.health_extension:get_damage_taken()

			arg_34_1.drop_step = num
			arg_34_1.drops_done = math.floor(get_damage_taken / num)
		end
	end,
	update_curse_greed_pinata_drops = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
		-- function 35
		local health_extension = arg_35_1.health_extension

		if not health_extension then
			local get_damage_taken = health_extension:get_damage_taken()

			if arg_35_1.prev_damage ~= get_damage_taken then
				local floor = math.floor(get_damage_taken / arg_35_1.drop_step)

				while floor > arg_35_1.drops_done do
					local attacker_unit_id = health_extension.last_damage_data.attacker_unit_id

					fn_8(arg_35_1.template.drop_table, POSITION_LOOKUP[arg_35_0], attacker_unit_id)

					arg_35_1.drops_done = arg_35_1.drops_done + 1
				end

				arg_35_1.prev_damage = get_damage_taken
			end
		end
	end,
	apply_attach_particle = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
		-- function 36
		if not arg_36_1.fx_id then
			local create_particles = World.create_particles(arg_36_3, arg_36_1.template.particle_fx, POSITION_LOOKUP[arg_36_0])

			arg_36_1.fx_id = create_particles

			local template = arg_36_1.template
			local node = Unit.node(arg_36_0, "j_spine")
			local local_rotation = Unit.local_rotation(arg_36_0, node)
			local from_euler_angles_xyz = Quaternion.from_euler_angles_xyz
			local offset_rotation_x = template.offset_rotation_x

			offset_rotation_x = offset_rotation_x or 0

			local offset_rotation_y = template.offset_rotation_y

			offset_rotation_y = offset_rotation_y or 0

			local offset_rotation_z = template.offset_rotation_z

			offset_rotation_z = offset_rotation_z or 0

			local var_36_8 = from_euler_angles_xyz(offset_rotation_x, offset_rotation_y, offset_rotation_z)
			local from_quaternion = Matrix4x4.from_quaternion(Quaternion.multiply(local_rotation, var_36_8))

			World.link_particles(arg_36_3, create_particles, arg_36_0, Unit.node(arg_36_0, "j_spine"), from_quaternion, "stop")
		end
	end,
	remove_attach_particle = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
		-- function 37
		if not arg_37_1.fx_id then
			World.stop_spawning_particles(arg_37_3, arg_37_1.fx_id)
		end
	end,
	apply_screenspace_fx = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
		-- function 38
		if not fn(arg_38_0) then
			return
		end

		if not arg_38_1.fx_id then
			arg_38_1.fx_id = World.create_particles(arg_38_3, arg_38_1.template.screenspace_fx, Vector3(0, 0, 0))
		end
	end,
	remove_screenspace_fx = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
		-- function 39
		if not arg_39_1.fx_id then
			World.stop_spawning_particles(arg_39_3, arg_39_1.fx_id)
		end
	end,
	start_bloodthirst = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
		-- function 40
		arg_40_1.reset_timer = function ()
			-- function 41
			arg_40_1.reset_at = arg_40_2.t + arg_40_1.template.reset_after_time
		end

		arg_40_1.reset_timer()

		arg_40_1.stacked_buffs = {}
	end,
	update_bloodthirst = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
		-- function 42
		if arg_42_2.t >= arg_42_1.reset_at then
			arg_42_1.kill_count = 0

			arg_42_1.reset_timer()
			BuffUtils.remove_stacked_buffs(arg_42_0, arg_42_1.stacked_buffs)
		end
	end,
	remove_bloodthirst = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
		-- function 43
		BuffUtils.remove_stacked_buffs(arg_43_0, arg_43_1.stacked_buffs)
	end,
	start_headhunter = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
		-- function 44
		arg_44_1.stacked_buffs = {}
	end,
	remove_headhunter = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
		-- function 45
		BuffUtils.remove_stacked_buffs(arg_45_0, arg_45_1.stacked_buffs)
	end,
	knockdown = function (arg_46_0, arg_46_1, arg_46_2)
		-- function 46
		if not fn_4() then
			local has_extension = ScriptUnit.has_extension(arg_46_0, "health_system")

			if not has_extension then
				has_extension:knock_down(arg_46_0)
			end
		end
	end,
	reset_health = function (arg_47_0, arg_47_1, arg_47_2)
		-- function 47
		if not fn_4() then
			local has_extension = ScriptUnit.has_extension(arg_47_0, "health_system")

			if not has_extension then
				has_extension:reset()
			end
		end
	end,
	apply_curse_rotten_miasma = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
		-- function 48
		arg_48_1.next_update_time = 0
		arg_48_1.stacked_buff_ids = {}
		arg_48_1.is_outside_safe_area = {}

		local get_difficulty_index = Managers.state.difficulty:get_difficulty_index()

		arg_48_1.radius = table.get_value_or_last(arg_48_1.template.safe_area_radius, get_difficulty_index)

		Unit.set_data(arg_48_0, "radius", arg_48_1.radius)
		Unit.flow_event(arg_48_0, "update_radius")
	end,
	update_curse_rotten_miasma = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
		-- function 49
		if not fn_4() then
			return
		end

		local local_position = Unit.local_position(arg_49_0, 0)

		if arg_49_1.next_update_time > arg_49_2.t then
			return
		end

		local template = arg_49_1.template

		arg_49_1.next_update_time = arg_49_2.t + template.buff_exposure_tick_rate

		local system = Managers.state.entity:system("buff_system")
		local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS

		for i, v in ipairs(PLAYER_UNITS) do
			local pow = math.pow(arg_49_1.radius, 2)
			local var_49_5 = POSITION_LOOKUP[v]
			local flag = pow < Vector3.distance_squared(local_position, var_49_5)
			local flag_2 = not flag
			local var_49_8 = arg_49_1.is_outside_safe_area[v]
			local flag_3 = not flag and not var_49_8
			local flag_4 = not flag_2 and var_49_8

			if not flag_3 then
				arg_49_1.is_outside_safe_area[v] = true
			elseif not flag_4 then
				arg_49_1.is_outside_safe_area[v] = false
			end

			local stacked_buff_ids = arg_49_1.stacked_buff_ids
			local var_49_12 = arg_49_1.stacked_buff_ids[v]

			var_49_12 = var_49_12 or {}
			stacked_buff_ids[v] = var_49_12

			local var_49_13 = arg_49_1.stacked_buff_ids[v]

			if not (not flag and not (#var_49_13 < template.miasma_stack_limit)) then
				local flag_5 = true
				local add_buff = system:add_buff(v, "curse_rotten_miasma_debuff", v, flag_5)

				var_49_13[#var_49_13 + 1] = add_buff
			elseif not (not flag_2 and not (#var_49_13 > 0)) then
				local var_49_16 = var_49_13[#var_49_13]

				system:remove_server_controlled_buff(v, var_49_16)

				var_49_13[#var_49_13] = nil

				if #var_49_13 == 0 then
					local extension_input = ScriptUnit.extension_input(v, "dialogue_system")
					local alloc_table = FrameTable.alloc_table()

					extension_input:trigger_networked_dialogue_event("curse_positive_effect_happened", alloc_table)
				end
			end
		end
	end,
	remove_curse_rotten_miasma = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
		-- function 50
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not flag then
			return
		end

		local extension = ScriptUnit.extension(flag, "buff_system")

		if not arg_50_1.stacked_buff_ids then
			for i, v in ipairs(arg_50_1.stacked_buff_ids) do
				extension:remove_buff(v)
			end

			table.clear(arg_50_1.stacked_buff_ids)
		end

		if not arg_50_1.effect_buff_id then
			extension:remove_buff(arg_50_1.effect_buff_id)

			arg_50_1.effect_buff_id = nil
		end
	end,
	apply_curse_rotten_miasma_debuff = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
		-- function 51
		if Managers.player:local_player().player_unit == arg_51_0 then
			local wwise_world = Managers.world:wwise_world(arg_51_3)

			WwiseWorld.trigger_event(wwise_world, "Play_curse_rotten_miasma_loop")

			arg_51_1.buff_triggered_sound = true
		end
	end,
	remove_curse_rotten_miasma_debuff = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
		-- function 52
		if not arg_52_1.buff_triggered_sound then
			local wwise_world = Managers.world:wwise_world(arg_52_3)

			WwiseWorld.trigger_event(wwise_world, "Stop_curse_rotten_miasma_loop")
		end
	end,
	apply_objective_unit = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
		-- function 53
		local str = "units/hub_elements/objective_unit"
		local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(str, POSITION_LOOKUP[arg_53_0])

		Unit.set_data(spawn_local_unit, "objective_server_only", true)
		Managers.state.unit_spawner:create_unit_extensions(Unit.world(spawn_local_unit), spawn_local_unit, "objective_unit")
		ScriptUnit.extension(spawn_local_unit, "tutorial_system"):set_active(true)
		World.link_unit(Unit.world(arg_53_0), spawn_local_unit, 0, arg_53_0, 0)

		arg_53_1.objective_unit = spawn_local_unit
	end,
	remove_objective_unit = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
		-- function 54
		if not arg_54_1.objective_unit then
			World.unlink_unit(Unit.world(arg_54_1.objective_unit), arg_54_1.objective_unit)
			Managers.state.unit_spawner:mark_for_deletion(arg_54_1.objective_unit)

			arg_54_1.objective_unit = nil
		end
	end,
	curse_abundance_of_life_custom_dot_tick = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
		-- function 55
		local current_health = ScriptUnit.extension(arg_55_0, "health_system"):current_health()
		local num = current_health * arg_55_1.template.damage_percentage

		if current_health > 30 then
			local num_2 = -Vector3.up()

			DamageUtils.add_damage_network(arg_55_0, arg_55_0, num, "torso", "wounded_dot", nil, num_2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	apply_killer_in_the_shadows_buff = function (arg_56_0, arg_56_1, arg_56_2)
		-- function 56
		if not fn(arg_56_0) then
			local extension = ScriptUnit.extension(arg_56_0, "status_system")

			extension:set_invisible(true, nil, "killer_in_the_shadows")
			extension:set_noclip(true, "killer_in_the_shadows")

			if not fn_2(arg_56_0) then
				ScriptUnit.extension(arg_56_0, "first_person_system"):play_hud_sound_event("Play_career_ability_kerillian_shade_enter_small")
				Managers.state.camera:set_mood("killer_in_the_shadows", "buff", true)
			end
		end
	end,
	remove_killer_in_the_shadows_buff = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
		-- function 57
		if not fn(arg_57_0) then
			local extension = ScriptUnit.extension(arg_57_0, "status_system")
			local set_invisible = extension:set_invisible(false, nil, "killer_in_the_shadows")

			extension:set_noclip(false, "killer_in_the_shadows")

			if not fn_2(arg_57_0) then
				if not set_invisible then
					ScriptUnit.extension(arg_57_0, "first_person_system"):play_hud_sound_event("Play_career_ability_kerillian_shade_exit")
				end

				Managers.state.camera:set_mood("killer_in_the_shadows", "buff", false)
				fn_9(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
			end
		end
	end,
	apply_pockets_full_of_bombs_buff = function (arg_58_0, arg_58_1, arg_58_2)
		-- function 58
		local extension = ScriptUnit.extension(arg_58_0, "inventory_system")
		local get_wielded_slot_name = extension:get_wielded_slot_name()
		local get_slot_data = extension:get_slot_data(get_wielded_slot_name)

		if get_wielded_slot_name ~= "slot_level_event" or not get_slot_data then
			extension:drop_level_event_item(get_slot_data)
		end

		local slot_name = AllPickups.frag_grenade_t1.slot_name

		if get_wielded_slot_name ~= slot_name then
			local extension_2 = ScriptUnit.extension(arg_58_0, "career_system")

			CharacterStateHelper.stop_weapon_actions(extension, "picked_up_object")
			CharacterStateHelper.stop_career_abilities(extension_2, "picked_up_object")
			extension:wield(slot_name)
		end
	end,
	update_pockets_full_of_bombs_buff = function (arg_59_0, arg_59_1, arg_59_2)
		-- function 59
		if not fn(arg_59_0) then
			local network_transmit = Managers.state.network.network_transmit
			local extension = ScriptUnit.extension(arg_59_0, "inventory_system")
			local extension_2 = ScriptUnit.extension(arg_59_0, "career_system")
			local frag_grenade_t1 = AllPickups.frag_grenade_t1
			local slot_name = frag_grenade_t1.slot_name
			local item_name = frag_grenade_t1.item_name

			if not extension:get_slot_data(slot_name) then
				local tbl = {}
				local var_59_7 = ItemMasterList[item_name]

				extension:add_equipment(slot_name, var_59_7, nil, tbl)

				local go_id = Managers.state.unit_storage:go_id(arg_59_0)
				local var_59_9 = NetworkLookup.equipment_slots[slot_name]
				local var_59_10 = NetworkLookup.item_names[item_name]
				local var_59_11 = NetworkLookup.weapon_skins["n/a"]

				if not go_id then
					if not fn_4() then
						network_transmit:send_rpc_clients("rpc_add_equipment", go_id, var_59_9, var_59_10, var_59_11)
					else
						network_transmit:send_rpc_server("rpc_add_equipment", go_id, var_59_9, var_59_10, var_59_11)
					end
				end

				if extension:get_wielded_slot_name() ~= slot_name then
					CharacterStateHelper.stop_weapon_actions(extension, "picked_up_object")
					CharacterStateHelper.stop_career_abilities(extension_2, "picked_up_object")
					extension:wield(slot_name)
				end
			end
		end
	end,
	trigger_sound_event = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
		-- function 60
		local wwise_world = Managers.world:wwise_world(arg_60_3)

		WwiseWorld.trigger_event(wwise_world, arg_60_1.template.sound_event_name)
	end,
	trigger_skulls_of_fury_sound_event = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
		-- function 61
		WwiseUtils.trigger_unit_event(arg_61_3, arg_61_1.template.sound_event_name, arg_61_0, 0)
	end,
	apply_health_bar = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
		-- function 62
		Managers.state.event:trigger("tutorial_event_show_health_bar", arg_62_0, true)

		arg_62_1.unit = arg_62_0
	end,
	remove_health_bar = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
		-- function 63
		Managers.state.event:trigger("tutorial_event_remove_health_bar", arg_63_0)
	end,
	remove_deus_rally_flag = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
		-- function 64
		if not fn_4() then
			Managers.state.unit_spawner:mark_for_deletion(arg_64_0)
		end
	end,
	apply_make_pingable = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
		-- function 65
		if not ScriptUnit.has_extension(arg_65_0, "ping_system") then
			local on_add_extension = Managers.state.entity:system("ping_system"):on_add_extension(arg_65_3, arg_65_0, "PingTargetExtension", {})

			on_add_extension:extensions_ready(arg_65_3, arg_65_0)

			arg_65_1.ping_target_extension = on_add_extension
		end
	end,
	remove_make_pingable = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
		-- function 66
		if not arg_66_1.ping_target_extension then
			local system = Managers.state.entity:system("ping_system")

			system:remove_ping_from_unit(arg_66_0)
			ScriptUnit.destroy_extension(arg_66_0, "ping_system")
			system:on_remove_extension(arg_66_0, "PingTargetExtension")

			arg_66_1.ping_target_extension = nil
		end
	end,
	remove_deus_potion_buff = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
		-- function 67
		fn_9(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	end,
	update_attack_speed_per_cooldown = function (arg_68_0, arg_68_1, arg_68_2)
		-- function 68
		local local_player = Managers.player:local_player()

		if not (not local_player and local_player.player_unit) then
			return
		end

		local template = arg_68_1.template
		local stat_buff = template.stat_buff
		local previous_multiplier = arg_68_1.previous_multiplier

		previous_multiplier = previous_multiplier or 0

		local num = ScriptUnit.extension(arg_68_0, "career_system"):current_ability_cooldown_percentage() * template.value
		local multiplier = arg_68_1.multiplier

		multiplier = multiplier or 0
		arg_68_1.previous_multiplier = multiplier
		arg_68_1.multiplier = num

		local extension = ScriptUnit.extension(arg_68_0, "buff_system")
		local num_2 = num - previous_multiplier

		if num_2 ~= 0 then
			extension:update_stat_buff(stat_buff, num_2, arg_68_1.stat_buff_index)
		end
	end,
	force_use_active_ability = function (arg_69_0, arg_69_1, arg_69_2)
		-- function 69
		local local_player = Managers.player:local_player()

		if not (not local_player and local_player.player_unit) then
			return
		end

		local extension = ScriptUnit.extension(arg_69_0, "career_system")

		if not extension:can_use_activated_ability() then
			extension:force_trigger_active_ability()
		end
	end,
	apply_active_ability_for_coins = function (arg_70_0, arg_70_1, arg_70_2)
		-- function 70
		local extension = ScriptUnit.extension(arg_70_0, "career_system")

		if not extension then
			extension:set_abilities_always_usable(true, "active_ability_for_coins")
		end
	end,
	remove_active_ability_for_coins = function (arg_71_0, arg_71_1, arg_71_2)
		-- function 71
		local extension = ScriptUnit.extension(arg_71_0, "career_system")

		if not extension then
			extension:set_abilities_always_usable(false, "active_ability_for_coins")
		end
	end,
	apply_max_health_buff_for_ai = function (arg_72_0, arg_72_1, arg_72_2)
		-- function 72
		if not fn_4() then
			local has_extension = ScriptUnit.has_extension(arg_72_0, "health_system")

			if not has_extension then
				local num = has_extension.unmodified_max_health * arg_72_1.multiplier

				arg_72_1.added_health = num

				local get_max_health = has_extension:get_max_health()

				has_extension:set_max_health(get_max_health + num)
			end
		end
	end,
	remove_max_health_buff_for_ai = function (arg_73_0, arg_73_1, arg_73_2)
		-- function 73
		if not fn_4() then
			local has_extension = ScriptUnit.has_extension(arg_73_0, "health_system")

			if not has_extension then
				local get_max_health = has_extension:get_max_health()

				if get_max_health > arg_73_1.added_health then
					has_extension:set_max_health(get_max_health - arg_73_1.added_health)
				end
			end
		end
	end,
	deus_knockdown_damage_immunity_aura_func = function (arg_74_0, arg_74_1, arg_74_2)
		-- function 74
		if not Managers.state.network.is_server then
			return
		end

		local template = arg_74_1.template
		local range = arg_74_1.range
		local num = range * range
		local var_74_3 = POSITION_LOOKUP[arg_74_0]
		local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_74_0].PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS
		local buff_to_add = template.buff_to_add
		local system = Managers.state.entity:system("buff_system")
		local is_ready_for_assisted_respawn = ScriptUnit.extension(arg_74_0, "status_system"):is_ready_for_assisted_respawn()

		for i = 1, count do
			local var_74_9 = PLAYER_AND_BOT_UNITS[i]

			if not (not Unit.alive(var_74_9) and var_74_9 == arg_74_0) then
				local extension = ScriptUnit.extension(var_74_9, "status_system")
				local var_74_11 = POSITION_LOOKUP[var_74_9]
				local distance_squared = Vector3.distance_squared(var_74_3, var_74_11)
				local extension_2 = ScriptUnit.extension(var_74_9, "buff_system")
				local is_knocked_down = extension:is_knocked_down()

				if (num < distance_squared or not is_knocked_down) and not is_ready_for_assisted_respawn then
					local get_non_stacking_buff = extension_2:get_non_stacking_buff(buff_to_add)

					if not get_non_stacking_buff then
						local server_id = get_non_stacking_buff.server_id

						if not server_id then
							system:remove_server_controlled_buff(var_74_9, server_id)
						end
					end
				end

				if not (not (distance_squared < num) or not is_knocked_down and is_ready_for_assisted_respawn or extension_2:has_buff_type(buff_to_add)) then
					local add_buff = system:add_buff(var_74_9, buff_to_add, arg_74_0, true)
					local get_non_stacking_buff_2 = extension_2:get_non_stacking_buff(buff_to_add)

					if not get_non_stacking_buff_2 then
						get_non_stacking_buff_2.server_id = add_buff
					end
				end
			end
		end
	end,
	on_extra_shot_buff_apply = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3)
		-- function 75
		if not fn_3(arg_75_0) then
			WwiseUtils.trigger_unit_event(arg_75_3, "hud_gameplay_stance_linesman_buff", arg_75_0, 0)
		end
	end,
	on_extra_shot_buff_remove = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
		-- function 76
		if not fn_3(arg_76_0) then
			WwiseUtils.trigger_unit_event(arg_76_3, "Play_potion_morris_effect_end", arg_76_0, 0)
		end
	end,
	apply_second_wind = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3)
		-- function 77
		if not fn_3(arg_77_0) then
			WwiseUtils.trigger_unit_event(arg_77_3, "Play_magic_shield_activate", arg_77_0, 0)
		end
	end,
	remove_second_wind = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3)
		-- function 78
		if not fn_3(arg_78_0) then
			WwiseUtils.trigger_unit_event(arg_78_3, "Play_potion_morris_effect_end", arg_78_0, 0)
		end
	end,
	apply_active_ability_movement_buff = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3)
		-- function 79
		BuffFunctionTemplates.functions.apply_movement_buff(arg_79_0, arg_79_1, arg_79_2, arg_79_3)

		if not fn_3(arg_79_0) then
			WwiseUtils.trigger_unit_event(arg_79_3, "hud_gameplay_stance_ninjafencer_buff", arg_79_0, 0)
		end
	end,
	remove_active_ability_movement_buff = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
		-- function 80
		BuffFunctionTemplates.functions.remove_movement_buff(arg_80_0, arg_80_1, arg_80_2, arg_80_3)

		if not fn_3(arg_80_0) then
			WwiseUtils.trigger_unit_event(arg_80_3, "Play_potion_morris_effect_end", arg_80_0, 0)
		end
	end,
	apply_ammo_reload_speed_buff = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3)
		-- function 81
		if not fn_3(arg_81_0) then
			WwiseUtils.trigger_unit_event(arg_81_3, "hud_gameplay_stance_linesman_buff", arg_81_0, 0)
		end
	end,
	remove_ammo_reload_speed_buff = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3)
		-- function 82
		if not fn_3(arg_82_0) then
			WwiseUtils.trigger_unit_event(arg_82_3, "Play_potion_morris_effect_end", arg_82_0, 0)
		end
	end,
	apply_damage_reduction_on_incapacitated = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3)
		-- function 83
		if not fn_3(arg_83_0) then
			WwiseUtils.trigger_unit_event(arg_83_3, "Play_magic_shield_activate", arg_83_0, 0)
		end
	end,
	remove_damage_reduction_on_incapacitated = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3)
		-- function 84
		if not fn_3(arg_84_0) then
			WwiseUtils.trigger_unit_event(arg_84_3, "Play_potion_morris_effect_end", arg_84_0, 0)
		end
	end,
	apply_parry_damage_immune = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
		-- function 85
		if not fn_3(arg_85_0) then
			WwiseUtils.trigger_unit_event(arg_85_3, "magic_shield_activate_fast", arg_85_0, 0)
		end
	end,
	apply_always_blocking = function (arg_86_0, arg_86_1, arg_86_2)
		-- function 86
		local extension = ScriptUnit.extension(arg_86_0, "status_system")
		local flag = not fn_4()

		extension:set_override_blocking(true, flag)
	end,
	remove_always_blocking = function (arg_87_0, arg_87_1, arg_87_2)
		-- function 87
		local extension = ScriptUnit.extension(arg_87_0, "status_system")
		local flag = not fn_4()

		extension:set_override_blocking(nil, flag)
	end,
	deus_standing_still_damage_reduction_update = function (arg_88_0, arg_88_1, arg_88_2)
		-- function 88
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_88_0] then
			local has_extension = ScriptUnit.has_extension(arg_88_0, "locomotion_system")

			if not has_extension then
				return
			end

			local system = Managers.state.entity:system("buff_system")
			local buff_to_add = arg_88_1.template.buff_to_add
			local current_velocity = has_extension:current_velocity()
			local length = Vector3.length(current_velocity)

			if not (not (length < 0.5) or arg_88_1.added_buff) then
				arg_88_1.added_buff = system:add_buff(arg_88_0, buff_to_add, arg_88_0, true)
			elseif not (length > 0.5) or not arg_88_1.added_buff then
				system:remove_server_controlled_buff(arg_88_0, arg_88_1.added_buff)

				arg_88_1.added_buff = nil
			end
		end
	end,
	melee_killing_spree_speed_counter_update = function (arg_89_0, arg_89_1, arg_89_2)
		-- function 89
		if not (not arg_89_1.kills and not arg_89_1.kills[1] and not (arg_89_1.kills[1] < arg_89_2.t)) then
			table.remove(arg_89_1.kills, 1)
		end
	end,
	deus_cooldown_reg_not_hit_init = function (arg_90_0, arg_90_1, arg_90_2)
		-- function 90
		if not Managers.state.network.is_server then
			return
		end

		arg_90_1.buffs = {}
		arg_90_1.next_buff_t = Managers.time:time("game") + arg_90_1.template.interval
	end,
	deus_cooldown_reg_not_hit_update = function (arg_91_0, arg_91_1, arg_91_2)
		-- function 91
		if not Managers.state.network.is_server then
			return
		end

		local time = Managers.time:time("game")
		local template = arg_91_1.template

		if not arg_91_1.reset then
			arg_91_1.next_buff_t = time + template.interval

			local system = Managers.state.entity:system("buff_system")

			for i = 1, #arg_91_1.buffs do
				local var_91_3 = arg_91_1.buffs[i]

				system:remove_server_controlled_buff(arg_91_0, var_91_3)
			end

			arg_91_1.reset = false

			table.clear(arg_91_1.buffs)
		end

		if not (not (time > arg_91_1.next_buff_t) or not (#arg_91_1.buffs < 5)) then
			arg_91_1.next_buff_t = time + template.interval

			local system_2 = Managers.state.entity:system("buff_system")
			local buff_to_add = template.buff_to_add
			local add_buff = system_2:add_buff(arg_91_0, buff_to_add, arg_91_0, true)

			arg_91_1.buffs[#arg_91_1.buffs + 1] = add_buff
		end
	end,
	update_ledge_rescue = function (arg_92_0, arg_92_1, arg_92_2)
		-- function 92
		local time = Managers.time:time("main")

		if not (not arg_92_1.rescue_timer and not (time > arg_92_1.rescue_timer)) then
			arg_92_1.rescue_timer = nil

			local pull_up_duration = arg_92_1.template.pull_up_duration

			arg_92_1.finish_pull_up_timer = time + pull_up_duration

			local animation_find_variable = Unit.animation_find_variable(arg_92_0, "revive_time")

			Unit.animation_set_variable(arg_92_0, animation_find_variable, pull_up_duration)
			Unit.animation_event(arg_92_0, "revive_start")

			if not ScriptUnit.has_extension(arg_92_0, "first_person_system") then
				ScriptUnit.extension(arg_92_0, "first_person_system"):set_wanted_player_height("stand", time, pull_up_duration)
			end
		end

		if not (not arg_92_1.finish_pull_up_timer and not (time > arg_92_1.finish_pull_up_timer)) then
			arg_92_1.finish_pull_up_timer = nil

			StatusUtils.set_pulled_up_network(arg_92_0, true, arg_92_0)
			Unit.animation_event(arg_92_0, "revive_complete")
		end
	end,
	update_disable_rescue = function (arg_93_0, arg_93_1, arg_93_2)
		-- function 93
		local time = Managers.time:time("main")

		if not (not arg_93_1.rescue_timer and not (time > arg_93_1.rescue_timer)) then
			arg_93_1.rescue_timer = nil

			if not fn_4() then
				return
			end

			if not ALIVE[arg_93_0] then
				return
			end

			local template = arg_93_1.template
			local main_world = Application.main_world()
			local var_93_3 = POSITION_LOOKUP[arg_93_0]
			local identity = Quaternion.identity()
			local get_template = ExplosionUtils.get_template(template.explosion_template)
			local get_career_power_level = ScriptUnit.has_extension(arg_93_0, "career_system"):get_career_power_level()

			DamageUtils.create_explosion(main_world, arg_93_0, var_93_3, identity, get_template, 1, "buff", true, fn_5(arg_93_0), arg_93_0, get_career_power_level, false)
		end
	end,
	always_blocking_init = function (arg_94_0, arg_94_1, arg_94_2)
		-- function 94
		local equipment = ScriptUnit.extension(arg_94_0, "inventory_system"):equipment()
		local wielded = equipment.wielded

		wielded = not wielded and equipment.wielded.slot_type == "melee"

		local buff_to_add = arg_94_1.template.buff_to_add
		local extension = ScriptUnit.extension(arg_94_0, "buff_system")

		if not wielded then
			arg_94_1.buff_id = extension:add_buff(buff_to_add)
		end
	end,
	always_blocking_update = function (arg_95_0, arg_95_1, arg_95_2)
		-- function 95
		local extension = ScriptUnit.extension(arg_95_0, "buff_system")
		local flag = not extension and extension:has_buff_type("deus_always_blocking_lock_out")

		if not (not arg_95_1.locked_out and flag) then
			local equipment = ScriptUnit.extension(arg_95_0, "inventory_system"):equipment()
			local wielded = equipment.wielded

			wielded = not wielded and equipment.wielded.slot_type == "melee"

			local buff_to_add = arg_95_1.template.buff_to_add

			if not wielded then
				arg_95_1.buff_id = extension:add_buff(buff_to_add)
			end

			arg_95_1.locked_out = nil
		elseif arg_95_1.locked_out or not flag then
			local buff_to_add_2 = arg_95_1.template.buff_to_add

			if not (not extension and extension:has_buff_type(buff_to_add_2)) then
				extension:remove_buff(arg_95_1.buff_id)
			end

			arg_95_1.locked_out = true
		end

		if arg_95_1.locked_out or not arg_95_1.swapped_weapons then
			local equipment_2 = arg_95_1.equipment
			local wielded_2 = equipment_2.wielded

			wielded_2 = not wielded_2 and equipment_2.wielded.slot_type == "melee"

			local buff_to_add_3 = arg_95_1.template.buff_to_add
			local flag_2 = not extension and extension:has_buff_type(buff_to_add_3)

			if not wielded_2 then
				if not flag_2 then
					arg_95_1.buff_id = extension:add_buff(buff_to_add_3)
				end
			elseif not flag_2 then
				extension:remove_buff(arg_95_1.buff_id)
			end

			arg_95_1.swapped_weapons = nil
		end
	end,
	apply_cursed_chest_init = function (arg_96_0, arg_96_1, arg_96_2)
		-- function 96
		local flag

		flag = not Unit.get_data(arg_96_0, "breed").boss and "fx/cursed_chest_spawn_02" and "fx/cursed_chest_spawn_01"

		local main_world = Application.main_world()
		local var_96_2 = POSITION_LOOKUP[arg_96_0]

		World.create_particles(main_world, flag, var_96_2)
	end,
	money_magnet_start = function (arg_97_0, arg_97_1, arg_97_2)
		-- function 97
		if not fn(arg_97_0) then
			return
		end

		arg_97_1.pickup_system = Managers.state.entity:system("pickup_system")
		arg_97_1.query_results = {}
		arg_97_1.interactor_extension = ScriptUnit.extension(arg_97_0, "interactor_system")
		arg_97_1.last_t = 0
	end,
	money_magnet_update = function (arg_98_0, arg_98_1, arg_98_2)
		-- function 98
		if not fn(arg_98_0) then
			return
		end

		local time = Managers.time:time("game")
		local last_t = arg_98_1.last_t
		local update_every = arg_98_1.template.update_every
		local interactor_extension = arg_98_1.interactor_extension

		if not interactor_extension:is_interacting() then
			return
		end

		if update_every < time - last_t then
			arg_98_1.last_t = time

			local pickup_system = arg_98_1.pickup_system
			local var_98_5 = POSITION_LOOKUP[arg_98_0]
			local magnet_distance = arg_98_1.template.magnet_distance
			local query_results = arg_98_1.query_results

			table.clear(query_results)

			local get_pickups = pickup_system:get_pickups(var_98_5, magnet_distance, query_results)

			for i = 1, get_pickups do
				local var_98_9 = query_results[i]
				local has_extension = ScriptUnit.has_extension(var_98_9, "pickup_system")

				if not (not has_extension and has_extension.pickup_name ~= "deus_soft_currency") then
					local flag = true

					interactor_extension:start_interaction(false, var_98_9, "pickup_object", flag)

					return
				end
			end
		end
	end,
	detect_weakness_unit_entered_range = function (arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4)
		-- function 99
		if not fn(arg_99_1) then
			return
		end

		if not arg_99_2.marked_enemy and not HEALTH_ALIVE[arg_99_2.marked_enemy] then
			return
		end

		if not arg_99_2.marked_enemy then
			arg_99_2.marked_enemy = nil
		end

		local name = Unit.get_data(arg_99_0, "breed").name
		local markable_enemies = arg_99_2.template.markable_enemies
		local time = Managers.time:time("main")
		local next_enemy_markable_at = arg_99_2.next_enemy_markable_at

		next_enemy_markable_at = next_enemy_markable_at or 0

		local flag = next_enemy_markable_at <= time

		if not markable_enemies[name] and not flag then
			local extension = ScriptUnit.extension(arg_99_0, "buff_system")
			local mark_buff = arg_99_2.template.mark_buff

			arg_99_2.marked_enemy_buff_id = extension:add_buff(mark_buff)
			arg_99_2.marked_enemy = arg_99_0
			arg_99_2.next_enemy_markable_at = time + arg_99_2.template.mark_cooldown
		end
	end,
	detect_weakness_unit_left_range = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3, arg_100_4, arg_100_5)
		-- function 100
		if not fn(arg_100_2) then
			return
		end

		local marked_enemy = arg_100_3.marked_enemy

		if marked_enemy ~= arg_100_0 or not HEALTH_ALIVE[marked_enemy] then
			local extension = ScriptUnit.extension(arg_100_0, "buff_system")
			local marked_enemy_buff_id = arg_100_3.marked_enemy_buff_id

			extension:remove_buff(marked_enemy_buff_id)
		end
	end,
	pyrotechnical_echo_update = function (arg_101_0, arg_101_1, arg_101_2)
		-- function 101
		local queued_explosions = arg_101_1.queued_explosions

		if not queued_explosions then
			local time = Managers.time:time("main")

			for i = 1, #queued_explosions do
				local var_101_2 = queued_explosions[i]

				if time > var_101_2.new_explosion_time then
					local world = Managers.world:world("level_world")
					local impact_data = var_101_2.impact_data
					local unbox = var_101_2.hit_position:unbox()
					local is_critical_strike = var_101_2.is_critical_strike
					local item_name = var_101_2.item_name
					local unbox_2 = var_101_2.rotation:unbox()
					local scale = var_101_2.scale
					local power_level = var_101_2.power_level
					local var_101_11 = arg_101_0
					local aoe = impact_data.aoe

					DamageUtils.create_explosion(world, var_101_11, unbox, unbox_2, aoe, scale, item_name, fn_4(), fn_5(var_101_11), var_101_11, power_level, is_critical_strike, var_101_11)
					table.swap_delete(queued_explosions, i)

					return
				end
			end
		end
	end,
	blazing_revenge_clear_aoe = function (arg_102_0, arg_102_1, arg_102_2)
		-- function 102
		if not fn_4() then
			return
		end

		local sound_end_event = arg_102_1.template.sound_end_event

		Managers.state.entity:system("audio_system"):play_audio_unit_event(sound_end_event, arg_102_0)

		local aoe_unit = arg_102_1.parent_buff_shared_table.aoe_unit

		if not aoe_unit and not Unit.alive(aoe_unit) then
			Managers.state.unit_spawner:mark_for_deletion(aoe_unit)
		end
	end,
	wolfpack_apply = function (arg_103_0, arg_103_1, arg_103_2, arg_103_3)
		-- function 103
		if not fn_4() then
			return
		end

		local buff_to_add = arg_103_1.template.buff_to_add
		local system = Managers.state.entity:system("buff_system")
		local flag = true

		system:add_buff(arg_103_0, buff_to_add, arg_103_0, flag)

		arg_103_1.units_in_range = {}

		scripts_utils_buff_area_helper.setup_range_check(arg_103_0, arg_103_1, arg_103_2, arg_103_3)
	end,
	wolfpack_update = function (arg_104_0, arg_104_1, arg_104_2, arg_104_3)
		-- function 104
		if not fn_4() then
			return
		end

		if not scripts_utils_buff_area_helper.update_range_check(arg_104_0, arg_104_1, arg_104_2, arg_104_3) then
			local units_in_range = arg_104_1.units_in_range
			local buff_to_add = arg_104_1.template.buff_to_add
			local system = Managers.state.entity:system("buff_system")

			for k, v in pairs(units_in_range) do
				local has_extension = ScriptUnit.has_extension(k, "buff_system")
				local flag = not has_extension and has_extension:has_buff_type(buff_to_add)

				if v == -1 then
					if not flag then
						local flag_2 = true

						units_in_range[k] = system:add_buff(arg_104_0, buff_to_add, arg_104_0, flag_2)
					end
				elseif not flag then
					system:remove_server_controlled_buff(arg_104_0, v)

					units_in_range[k] = -1
				end
			end
		end
	end,
	wolfpack_remove = function (arg_105_0, arg_105_1, arg_105_2, arg_105_3)
		-- function 105
		if not fn_4() then
			return
		end

		scripts_utils_buff_area_helper.destroy_range_check(arg_105_0, arg_105_1, arg_105_2, arg_105_3)

		local units_in_range = arg_105_1.units_in_range
		local system = Managers.state.entity:system("buff_system")

		for k, v in pairs(units_in_range) do
			if v ~= -1 then
				system:remove_server_controlled_buff(arg_105_0, v)

				units_in_range[k] = -1
			end
		end
	end,
	wolfpack_entered_range = function (arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4)
		-- function 106
		if not fn_4() then
			return
		end

		if arg_106_0 == arg_106_1 then
			return
		end

		local units_in_range = arg_106_2.units_in_range

		if not units_in_range[arg_106_0] then
			units_in_range[arg_106_0] = -1
		end
	end,
	wolfpack_left_range = function (arg_107_0, arg_107_1, arg_107_2, arg_107_3, arg_107_4, arg_107_5)
		-- function 107
		if not fn_4() then
			return
		end

		if arg_107_0 == arg_107_2 then
			return
		end

		local system = Managers.state.entity:system("buff_system")
		local var_107_1 = arg_107_3.units_in_range[arg_107_0]

		if not (not var_107_1 and var_107_1 == -1) then
			system:remove_server_controlled_buff(arg_107_2, var_107_1)
		end

		arg_107_3.units_in_range[arg_107_0] = nil
	end,
	comradery_apply = function (arg_108_0, arg_108_1, arg_108_2, arg_108_3)
		-- function 108
		if not fn_4() then
			return
		end

		local buff_to_add = arg_108_1.template.buff_to_add
		local system = Managers.state.entity:system("buff_system")
		local flag = true

		system:add_buff(arg_108_0, buff_to_add, arg_108_0, flag)

		arg_108_1.units_in_range = {}

		scripts_utils_buff_area_helper.setup_range_check(arg_108_0, arg_108_1, arg_108_2, arg_108_3)
	end,
	comradery_update = function (arg_109_0, arg_109_1, arg_109_2, arg_109_3)
		-- function 109
		if not fn_4() then
			return
		end

		scripts_utils_buff_area_helper.update_range_check(arg_109_0, arg_109_1, arg_109_2, arg_109_3)
	end,
	comradery_remove = function (arg_110_0, arg_110_1, arg_110_2, arg_110_3)
		-- function 110
		if not fn_4() then
			return
		end

		scripts_utils_buff_area_helper.destroy_range_check(arg_110_0, arg_110_1, arg_110_2, arg_110_3)

		local units_in_range = arg_110_1.units_in_range
		local system = Managers.state.entity:system("buff_system")

		for k, v in pairs(units_in_range) do
			system:remove_server_controlled_buff(arg_110_0, v)
		end
	end,
	comradery_entered_range = function (arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4)
		-- function 111
		if not fn_4() then
			return
		end

		if arg_111_0 == arg_111_1 then
			return
		end

		local units_in_range = arg_111_2.units_in_range

		if not units_in_range[arg_111_0] then
			local buff_to_add = arg_111_2.template.buff_to_add
			local system = Managers.state.entity:system("buff_system")
			local flag = true

			units_in_range[arg_111_0] = system:add_buff(arg_111_1, buff_to_add, arg_111_1, flag)
		end
	end,
	comradery_left_range = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4, arg_112_5)
		-- function 112
		if not fn_4() then
			return
		end

		if arg_112_0 == arg_112_2 then
			return
		end

		local system = Managers.state.entity:system("buff_system")
		local units_in_range = arg_112_3.units_in_range
		local var_112_2 = units_in_range[arg_112_0]

		if not var_112_2 then
			system:remove_server_controlled_buff(arg_112_2, var_112_2)
		end

		units_in_range[arg_112_0] = nil
	end,
	tenacious_update = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3)
		-- function 113
		if not fn_4() then
			return
		end

		if not arg_113_1.health_extension then
			arg_113_1.health_extension = ScriptUnit.has_extension(arg_113_0, "health_system")
		end

		local health_extension = arg_113_1.health_extension
		local template = arg_113_1.template

		if template.health_threshold <= health_extension:current_health_percent() then
			arg_113_1.next_update = nil

			return
		end

		local time = Managers.time:time("main")

		if not (not arg_113_1.next_update and not (time > arg_113_1.next_update)) then
			local health_per_tick = template.health_per_tick

			DamageUtils.heal_network(arg_113_0, arg_113_0, health_per_tick, "health_regen")

			arg_113_1.next_update = time + template.tick
		end
	end,
	hidden_escape_apply = function (arg_114_0, arg_114_1, arg_114_2, arg_114_3)
		-- function 114
		if not fn(arg_114_0) then
			local extension = ScriptUnit.extension(arg_114_0, "status_system")

			extension:set_invisible(true, nil, "hidden_escape")
			extension:set_noclip(true, "hidden_escape")

			if not fn_2(arg_114_0) then
				ScriptUnit.extension(arg_114_0, "first_person_system"):play_hud_sound_event("Play_career_ability_kerillian_shade_enter_small")
				Managers.state.camera:set_mood("hidden_escape", "buff", true)
			end
		end
	end,
	hidden_escape_remove = function (arg_115_0, arg_115_1, arg_115_2, arg_115_3)
		-- function 115
		if not fn(arg_115_0) then
			local extension = ScriptUnit.extension(arg_115_0, "status_system")
			local set_invisible = extension:set_invisible(false, nil, "hidden_escape")

			extension:set_noclip(false, "hidden_escape")

			local cooldown_buff = arg_115_1.template.cooldown_buff

			ScriptUnit.has_extension(arg_115_0, "buff_system"):add_buff(cooldown_buff, {
				attacker_unit = arg_115_0
			})

			if not fn_2(arg_115_0) then
				if not set_invisible then
					ScriptUnit.extension(arg_115_0, "first_person_system"):play_hud_sound_event("Play_career_ability_kerillian_shade_exit")
				end

				Managers.state.camera:set_mood("hidden_escape", "buff", false)
			end
		end
	end,
	update_bad_breath = function (arg_116_0, arg_116_1, arg_116_2)
		-- function 116
		if not fn_4() then
			return
		end

		if not ALIVE[arg_116_0] then
			return
		end

		local time = Managers.time:time("main")

		if not (not arg_116_1.rescue_timer and not (time > arg_116_1.rescue_timer)) then
			arg_116_1.rescue_timer = nil

			local var_116_1
			local disabler = arg_116_1.disabler

			if not disabler and not ALIVE[disabler] then
				var_116_1 = Unit.local_position(disabler, 0)
			else
				var_116_1 = POSITION_LOOKUP[arg_116_0]
			end

			arg_116_1.disabler = nil

			local template = arg_116_1.template
			local identity = Quaternion.identity()
			local explosion_template = template.explosion_template
			local get_career_power_level = ScriptUnit.has_extension(arg_116_0, "career_system"):get_career_power_level()

			Managers.state.entity:system("area_damage_system"):create_explosion(arg_116_0, var_116_1, identity, explosion_template, 1, "buff", get_career_power_level, false)

			local system = Managers.state.entity:system("buff_system")
			local cooldown_buff = template.cooldown_buff

			system:add_buff(arg_116_0, cooldown_buff, arg_116_0)
		end
	end,
	update_boulder_bro = function (arg_117_0, arg_117_1, arg_117_2)
		-- function 117
		local template = arg_117_1.template
		local time = Managers.time:time("main")

		if not (not arg_117_1.rescue_timer and not (time > arg_117_1.rescue_timer)) then
			arg_117_1.rescue_timer = nil

			local pull_up_duration = template.pull_up_duration

			arg_117_1.finish_pull_up_timer = time + pull_up_duration

			local animation_find_variable = Unit.animation_find_variable(arg_117_0, "revive_time")

			Unit.animation_set_variable(arg_117_0, animation_find_variable, pull_up_duration)
			Unit.animation_event(arg_117_0, "revive_start")

			if not ScriptUnit.has_extension(arg_117_0, "first_person_system") then
				ScriptUnit.extension(arg_117_0, "first_person_system"):set_wanted_player_height("stand", time, pull_up_duration)
			end
		end

		if not (not arg_117_1.finish_pull_up_timer and not (time > arg_117_1.finish_pull_up_timer)) then
			arg_117_1.finish_pull_up_timer = nil

			StatusUtils.set_pulled_up_network(arg_117_0, true, arg_117_0)
			Unit.animation_event(arg_117_0, "revive_complete")
			ScriptUnit.extension(arg_117_0, "buff_system"):queue_remove_buff(arg_117_1.id)
		end
	end,
	boulder_bro_add_buff = function (arg_118_0, arg_118_1, arg_118_2)
		-- function 118
		if not fn_4() then
			return
		end

		if not ALIVE[arg_118_0] then
			return
		end

		local buff_to_add = arg_118_1.template.buff_to_add

		ScriptUnit.extension(arg_118_0, "buff_system"):add_buff(buff_to_add)
	end,
	resolve_apply = function (arg_119_0, arg_119_1, arg_119_2)
		-- function 119
		local extension = ScriptUnit.extension(arg_119_0, "status_system")
		local bonus = arg_119_1.template.bonus

		extension.wounds = extension.wounds + bonus
	end,
	detect_weakness_link_unit = function (arg_120_0, arg_120_1, arg_120_2, arg_120_3)
		-- function 120
		local template = arg_120_1.template
		local unit_name = template.unit_name
		local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(unit_name, POSITION_LOOKUP[arg_120_0])

		Managers.state.unit_spawner:create_unit_extensions(Unit.world(spawn_local_unit), spawn_local_unit, "prop_unit")
		World.link_unit(Unit.world(arg_120_0), spawn_local_unit, 0, arg_120_0, Unit.node(arg_120_0, "root_point"))

		arg_120_1.linked_unit = spawn_local_unit

		local z_offset = template.z_offset
		local var_120_4 = z_offset[Unit.get_data(arg_120_0, "breed").name]

		var_120_4 = var_120_4 or z_offset.default

		Unit.set_local_position(spawn_local_unit, 0, Vector3(0, 0, var_120_4))
	end,
	health_orb_apply_func = function (arg_121_0, arg_121_1, arg_121_2, arg_121_3)
		-- function 121
		if not fn_4() then
			return
		end

		local granted_health = arg_121_1.template.granted_health

		DamageUtils.heal_network(arg_121_0, arg_121_0, granted_health, "buff")
	end,
	start_static_charge = function (arg_122_0, arg_122_1, arg_122_2, arg_122_3)
		-- function 122
		arg_122_1.next_tick_t = arg_122_2.t + arg_122_1.template.tick_every_t

		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local wwise_world = Managers.world:wwise_world(arg_122_3)
		local num = 0
		local var_122_4

		if arg_122_0 == flag then
			local first_person_unit = ScriptUnit.extension(arg_122_0, "first_person_system").first_person_unit

			var_122_4 = World.create_particles(arg_122_3, "fx/magic_wind_metal_blade_dance_01_1p", POSITION_LOOKUP[first_person_unit])

			World.link_particles(arg_122_3, var_122_4, first_person_unit, Unit.node(first_person_unit, "root_point"), Matrix4x4.identity(), "stop")
			WwiseWorld.trigger_event(wwise_world, "Play_wind_metal_gameplay_mutator_wind_loop")
		else
			WwiseUtils.trigger_unit_event(arg_122_3, "Play_wind_metal_gameplay_mutator_wind_loop", arg_122_0, 0)

			var_122_4 = World.create_particles(arg_122_3, "fx/magic_wind_metal_blade_dance_01", POSITION_LOOKUP[arg_122_0])

			World.link_particles(arg_122_3, var_122_4, arg_122_0, Unit.node(arg_122_0, "root_point"), Matrix4x4.identity(), "stop")
		end

		arg_122_1.power_level = num
		arg_122_1.linked_effect = var_122_4
	end,
	update_static_charge = function (arg_123_0, arg_123_1, arg_123_2)
		-- function 123
		if arg_123_2.t >= arg_123_1.next_tick_t then
			arg_123_1.next_tick_t = arg_123_2.t + arg_123_1.template.tick_every_t

			local system = Managers.state.entity:system("area_damage_system")
			local num = POSITION_LOOKUP[arg_123_0] + Vector3(0, 0, 1)
			local local_rotation = Unit.local_rotation(arg_123_0, 0)
			local get_career_power_level = ScriptUnit.has_extension(arg_123_0, "career_system"):get_career_power_level()

			system:create_explosion(arg_123_0, num, local_rotation, arg_123_1.template.explosion_template, 1, "undefined", get_career_power_level, false)
		end
	end,
	remove_static_charge = function (arg_124_0, arg_124_1, arg_124_2, arg_124_3)
		-- function 124
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local wwise_world = Managers.world:wwise_world(arg_124_3)

		if arg_124_0 == flag then
			WwiseWorld.trigger_event(wwise_world, "Stop_wind_metal_gameplay_mutator_wind_loop")
		else
			WwiseUtils.trigger_unit_event(arg_124_3, "Stop_wind_metal_gameplay_mutator_wind_loop", arg_124_0, 0)
		end

		local linked_effect = arg_124_1.linked_effect

		if not linked_effect then
			World.destroy_particles(arg_124_3, linked_effect)

			arg_124_1.linked_effect = nil
		end
	end,
	reduce_activated_ability_cooldown = function (arg_125_0, arg_125_1, arg_125_2, arg_125_3)
		-- function 125
		if not Unit.alive(arg_125_0) then
			local has_extension = ScriptUnit.has_extension(arg_125_0, "career_system")

			if not has_extension then
				has_extension:reduce_activated_ability_cooldown(arg_125_1.template.bonus)
			end
		end
	end,
	always_blocking_remove = function (arg_126_0, arg_126_1, arg_126_2)
		-- function 126
		local extension = ScriptUnit.extension(arg_126_0, "buff_system")

		if not arg_126_1.buff_id then
			extension:remove_buff(arg_126_1.buff_id)
		end
	end,
	resolve_update = function (arg_127_0, arg_127_1, arg_127_2)
		-- function 127
		local extension = ScriptUnit.extension(arg_127_0, "buff_system")
		local template = arg_127_1.template
		local cooldown_buff = template.cooldown_buff
		local full_heal_buff = template.full_heal_buff
		local after_revive_t = arg_127_1.after_revive_t
		local time = Managers.time:time("game")

		if not (not after_revive_t and not (after_revive_t < time)) then
			if not arg_127_1.full_heal_perk_buff_id then
				extension:remove_buff(arg_127_1.full_heal_perk_buff_id)

				arg_127_1.full_heal_perk_buff_id = nil
			end

			arg_127_1.after_revive_t = nil
		end

		if not (extension:get_buff_type(cooldown_buff) or extension:get_buff_type(full_heal_buff)) then
			arg_127_1.full_heal_perk_buff_id = extension:add_buff(full_heal_buff)
		end
	end,
	boon_skulls_04_regen_update = function (arg_128_0, arg_128_1, arg_128_2)
		-- function 128
		local thp_added = arg_128_1.thp_added

		thp_added = thp_added or 0

		if thp_added >= MorrisBuffTweakData.boon_skulls_04_data.thp_per_second * arg_128_1.duration then
			return
		end

		local thp_per_second = MorrisBuffTweakData.boon_skulls_04_data.thp_per_second
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_128_0)
		local heal_from_proc = NetworkLookup.heal_types.heal_from_proc

		network.network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, thp_per_second, heal_from_proc)

		arg_128_1.thp_added = thp_added + thp_per_second
	end,
	boon_skulls_04_regen_remove = function (arg_129_0, arg_129_1, arg_129_2)
		-- function 129
		if not HEALTH_ALIVE[arg_129_0] then
			return
		end

		if not (not Managers.state.network and Managers.state.network:game()) then
			return
		end

		local thp_added = arg_129_1.thp_added

		thp_added = thp_added or 0

		local num = MorrisBuffTweakData.boon_skulls_04_data.thp_per_second * arg_129_1.duration

		if thp_added < num then
			local network = Managers.state.network
			local unit_game_object_id = network:unit_game_object_id(arg_129_0)
			local heal_from_proc = NetworkLookup.heal_types.heal_from_proc

			network.network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, num - thp_added, heal_from_proc)
		end

		BuffFunctionTemplates.functions.skulls_event_boon_surge_removed(arg_129_0, arg_129_1, arg_129_2)
	end,
	skulls_event_boon_surge_applied = function (arg_130_0, arg_130_1, arg_130_2, arg_130_3)
		-- function 130
		if not (not fn(arg_130_0) and fn_2(arg_130_0)) then
			local extension = ScriptUnit.extension(arg_130_0, "first_person_system")
			local extension_2 = ScriptUnit.extension(arg_130_0, "buff_system")
			local get_buff_type = extension_2:get_buff_type("skulls_boon_buffs_tracker")

			if not get_buff_type then
				local add_buff = extension_2:add_buff("skulls_boon_buffs_tracker")

				get_buff_type = extension_2:get_buff_by_id(add_buff)

				local create_screen_particles = extension:create_screen_particles("fx/skulls_2023/screenspace_skulls_2023_buff")

				if not create_screen_particles then
					local num = 0
					local lerp = math.lerp(-0.55, 0.4, num)

					World.set_particles_material_scalar(arg_130_3, create_screen_particles, "overlay", "shadow_amount", lerp)

					get_buff_type.effect_id = create_screen_particles
				end

				get_buff_type.num_buffs = 1

				extension:play_hud_sound_event("Play_skulls_event_buff_on")
			else
				local num_buffs = get_buff_type.num_buffs
				local num_possible_buffs = get_buff_type.num_possible_buffs

				if not num_possible_buffs then
					num_possible_buffs = 0

					for i = 1, #DeusPowerUpsArray do
						if not table.contains(DeusPowerUpsArray[i].mutators, "skulls_2023") then
							num_possible_buffs = num_possible_buffs + 1
						end
					end

					get_buff_type.num_possible_buffs = num_possible_buffs
				end

				local effect_id = get_buff_type.effect_id

				if not effect_id then
					local num_2

					if num_possible_buffs > 1 then
						num_2 = (num_buffs - 1) / (num_possible_buffs - 1)

						if not num_2 then
							-- Nothing
						end
					end

					num_2 = 1

					::label_130_0::

					local lerp_2 = math.lerp(-0.55, 0.4, num_2)

					World.set_particles_material_scalar(arg_130_3, effect_id, "overlay", "shadow_amount", lerp_2)
				end

				if not (not (num_possible_buffs <= num_buffs) or get_buff_type.sound_played) then
					extension:play_hud_sound_event("Play_skulls_event_buff_max_stacks")

					get_buff_type.sound_played = true
				end

				get_buff_type.num_buffs = num_buffs + 1
			end
		end
	end,
	skulls_event_boon_surge_removed = function (arg_131_0, arg_131_1, arg_131_2)
		-- function 131
		if not (not fn(arg_131_0) and fn_2(arg_131_0)) then
			local extension = ScriptUnit.extension(arg_131_0, "buff_system")
			local get_buff_type = extension:get_buff_type("skulls_boon_buffs_tracker")
			local num = get_buff_type.num_buffs - 1

			get_buff_type.num_buffs = num

			if num == 0 then
				local effect_id = get_buff_type.effect_id
				local extension_2 = ScriptUnit.extension(arg_131_0, "first_person_system")

				if not effect_id then
					extension_2:stop_spawning_screen_particles(effect_id)
				end

				extension:remove_buff(get_buff_type.id)
				extension_2:play_hud_sound_event("Play_skulls_event_buff_off")
			end
		end
	end,
	periodic_aoe_stagger = function (arg_132_0, arg_132_1, arg_132_2)
		-- function 132
		if not fn_4() then
			return
		end

		local template = arg_132_1.template
		local update_frequency = template.update_frequency
		local min_update_frequency = template.min_update_frequency
		local min_update_frequency_at = template.min_update_frequency_at
		local current_health_percent = ScriptUnit.extension(arg_132_0, "health_system"):current_health_percent()

		arg_132_1.update_frequency = math.remap(min_update_frequency_at, 1, min_update_frequency, update_frequency, current_health_percent)

		local var_132_5 = POSITION_LOOKUP[arg_132_0]
		local explosion_template_name = arg_132_1.template.explosion_template_name
		local var_132_7 = ExplosionTemplates[explosion_template_name]
		local radius = var_132_7.explosion.radius
		local var_132_9 = Managers.state.side.side_by_unit[arg_132_0]

		if AiUtils.broadphase_query(var_132_5, radius, FrameTable.alloc_table(), var_132_9.enemy_broadphase_categories) <= 0 then
			return
		end

		local has_extension = ScriptUnit.has_extension(arg_132_0, "career_system")
		local get_career_power_level

		if not has_extension then
			get_career_power_level = has_extension:get_career_power_level()

			if not get_career_power_level then
				-- Nothing
			end
		end

		get_career_power_level = DefaultPowerLevel

		::label_132_0::

		local num = 1
		local str = "buff"
		local identity = Quaternion.identity()

		DamageUtils.create_explosion(Unit.world(arg_132_0), arg_132_0, var_132_5, identity, var_132_7, num, str, true, false, arg_132_0, get_career_power_level, false, arg_132_0)

		local unit_game_object_id = Managers.state.network:unit_game_object_id(arg_132_0)
		local var_132_16 = NetworkLookup.explosion_templates[explosion_template_name]
		local var_132_17 = NetworkLookup.damage_sources[str]

		Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", unit_game_object_id, false, var_132_5, identity, var_132_16, num, var_132_17, get_career_power_level, false, unit_game_object_id)
	end,
	teammates_extra_damage_aura_enter = function (arg_133_0, arg_133_1, arg_133_2, arg_133_3)
		-- function 133
		local has_extension = ScriptUnit.has_extension(arg_133_0, "buff_system")

		if not has_extension then
			local cached_params = arg_133_2.cached_params

			cached_params = cached_params or {
				attacker_unit = arg_133_1
			}
			arg_133_2.cached_params = cached_params

			return has_extension:add_buff("deus_extra_damage_aura_debuff", arg_133_2.cached_params)
		end

		return -1
	end,
	teammates_extra_damage_aura_leave = function (arg_134_0, arg_134_1, arg_134_2, arg_134_3, arg_134_4)
		-- function 134
		if arg_134_1 == -1 then
			return
		end

		local has_extension = ScriptUnit.has_extension(arg_134_0, "buff_system")

		if not has_extension then
			return has_extension:remove_buff(arg_134_1)
		end
	end,
	teammates_extra_stagger_aura_enter = function (arg_135_0, arg_135_1, arg_135_2, arg_135_3)
		-- function 135
		local has_extension = ScriptUnit.has_extension(arg_135_0, "buff_system")

		if not has_extension then
			local cached_params = arg_135_2.cached_params

			cached_params = cached_params or {
				attacker_unit = arg_135_1
			}
			arg_135_2.cached_params = cached_params

			return has_extension:add_buff("deus_extra_stagger_aura_debuff", arg_135_2.cached_params)
		end

		return -1
	end,
	teammates_extra_stagger_aura_leave = function (arg_136_0, arg_136_1, arg_136_2, arg_136_3, arg_136_4)
		-- function 136
		if arg_136_1 == -1 then
			return
		end

		local has_extension = ScriptUnit.has_extension(arg_136_0, "buff_system")

		if not has_extension then
			return has_extension:remove_buff(arg_136_1)
		end
	end,
	boon_meta_01_apply = function (arg_137_0, arg_137_1, arg_137_2)
		-- function 137
		local owner = Managers.player:owner(arg_137_0)

		if not owner then
			return
		end

		local extension = ScriptUnit.extension(arg_137_0, "buff_system")
		local count = #Managers.mechanism:game_mechanism():get_deus_run_controller():get_player_power_ups(owner:network_id(), owner:local_player_id())

		for i = 1, count do
			extension:add_buff("boon_meta_01_stack")
		end
	end,
	boon_weaponrarity_01_apply = function (arg_138_0, arg_138_1, arg_138_2)
		-- function 138
		local owner = Managers.player:owner(arg_138_0)

		if not (not owner and owner:network_id() == Network.peer_id()) then
			return
		end

		local career_name = ScriptUnit.extension(arg_138_0, "career_system"):career_name()
		local get_interface = Managers.backend:get_interface("deus")
		local get_loadout_item_id = get_interface:get_loadout_item_id(career_name, "slot_melee")
		local get_loadout_item = get_interface:get_loadout_item(get_loadout_item_id)
		local var_138_5 = ORDER_RARITY[not get_loadout_item and get_loadout_item.rarity]

		var_138_5 = var_138_5 or 1

		local get_loadout_item_id_2 = get_interface:get_loadout_item_id(career_name, "slot_ranged")
		local get_loadout_item_2 = get_interface:get_loadout_item(get_loadout_item_id_2)
		local var_138_8 = ORDER_RARITY[not get_loadout_item_2 and get_loadout_item_2.rarity]

		var_138_8 = var_138_8 or 1

		local max = math.max(var_138_5, var_138_8)
		local extension = ScriptUnit.extension(arg_138_0, "buff_system")

		for i = extension:num_buff_stacks("boon_weaponrarity_01_debuff") + 2, max do
			extension:add_buff("boon_weaponrarity_01_debuff")
		end
	end,
	boon_weaponrarity_02_apply = function (arg_139_0, arg_139_1, arg_139_2)
		-- function 139
		local owner = Managers.player:owner(arg_139_0)

		if not (not owner and owner:network_id() == Network.peer_id()) then
			return
		end

		local extension = ScriptUnit.extension(arg_139_0, "career_system")
		local extension_2 = ScriptUnit.extension(arg_139_0, "inventory_system")
		local career_name = extension:career_name()
		local get_wielded_slot_name = extension_2:get_wielded_slot_name()

		if not (get_wielded_slot_name == "slot_melee" or get_wielded_slot_name == "slot_ranged") then
			return
		end

		local get_interface = Managers.backend:get_interface("deus")
		local get_loadout_item_id = get_interface:get_loadout_item_id(career_name, get_wielded_slot_name)
		local get_loadout_item = get_interface:get_loadout_item(get_loadout_item_id)

		if not get_loadout_item then
			return
		end

		local rarity = get_loadout_item.rarity
		local var_139_9 = ORDER_RARITY[rarity]

		if not var_139_9 then
			return
		end

		local extension_3 = ScriptUnit.extension(arg_139_0, "buff_system")

		for i = extension_3:num_buff_stacks("boon_weaponrarity_02_debuff") + 2, var_139_9 do
			extension_3:add_buff("boon_weaponrarity_02_debuff")
		end
	end,
	boon_range_02_buff_adder_add_buff = function (arg_140_0, arg_140_1, arg_140_2)
		-- function 140
		if not HEALTH_ALIVE[arg_140_0] then
			local has_extension = ScriptUnit.has_extension(arg_140_0, "buff_system")
			local get_stacking_buff = has_extension:get_stacking_buff("boon_range_02_increased_damage_tracker")

			if not get_stacking_buff then
				for i = #get_stacking_buff, 1, -1 do
					local var_140_2 = get_stacking_buff[i]

					if var_140_2.attacker_unit == arg_140_2.attacker_unit then
						has_extension:remove_buff(var_140_2.id)
					end
				end
			end

			has_extension:add_buff("boon_range_02_increased_damage_tracker", {
				attacker_unit = arg_140_1.attacker_unit
			})
		end
	end,
	match_num_buffs_update = function (arg_141_0, arg_141_1, arg_141_2)
		-- function 141
		local buff_tracker = arg_141_1.buff_tracker

		buff_tracker = buff_tracker or {}
		arg_141_1.buff_tracker = buff_tracker

		local buff_to_check = arg_141_1.template.buff_to_check
		local buff_to_add = arg_141_1.template.buff_to_add
		local extension = ScriptUnit.extension(arg_141_0, "buff_system")
		local num_buff_stacks = extension:num_buff_stacks(buff_to_check)
		local count = #buff_tracker

		if num_buff_stacks ~= count then
			for i = count + 1, num_buff_stacks do
				buff_tracker[i] = extension:add_buff(buff_to_add)
			end

			for j = count, num_buff_stacks + 1, -1 do
				extension:remove_buff(buff_tracker[j])

				buff_tracker[j] = nil
			end
		end
	end
}
morris.proc_functions = {
	stockpile_refresh_ammo_buffs = function (arg_142_0, arg_142_1, arg_142_2)
		-- function 142
		local has_extension = ScriptUnit.has_extension(arg_142_0, "inventory_system")

		if not has_extension then
			local get_wielded_slot_data = has_extension:get_wielded_slot_data()
			local left_unit_1p = get_wielded_slot_data.left_unit_1p
			local right_unit_1p = get_wielded_slot_data.right_unit_1p
			local has_extension_2 = ScriptUnit.has_extension(left_unit_1p, "ammo_system")

			if not has_extension_2 then
				has_extension_2:refresh_buffs()
			end

			local has_extension_3 = ScriptUnit.has_extension(right_unit_1p, "ammo_system")

			if not has_extension_3 then
				has_extension_3:refresh_buffs()
			end
		end

		ScriptUnit.extension(arg_142_0, "buff_system"):remove_buff(arg_142_1.id)
	end,
	stagger_aoe_on_hit = function (arg_143_0, arg_143_1, arg_143_2)
		-- function 143
		if not fn_4() then
			return
		end

		if not ALIVE[arg_143_0] then
			return
		end

		local var_143_0 = arg_143_2[1]
		local template = arg_143_1.template
		local get_template = ExplosionUtils.get_template(template.explosion_template)
		local main_world = Application.main_world()
		local var_143_4 = POSITION_LOOKUP[var_143_0]
		local identity = Quaternion.identity()
		local get_career_power_level = ScriptUnit.has_extension(arg_143_0, "career_system"):get_career_power_level()

		DamageUtils.create_explosion(main_world, arg_143_0, var_143_4, identity, get_template, 1, "buff", fn_4(), fn_5(arg_143_0), arg_143_0, get_career_power_level, false)
	end,
	remove_this_player_buff = function (arg_144_0, arg_144_1, arg_144_2)
		-- function 144
		if not ALIVE[arg_144_0] then
			local has_extension = ScriptUnit.has_extension(arg_144_0, "buff_system")

			if not has_extension then
				has_extension:remove_buff(arg_144_1.id)
			end
		end
	end,
	armor_breaker_on_armored_kill = function (arg_145_0, arg_145_1, arg_145_2)
		-- function 145
		if not fn_4() then
			return
		end

		if not ALIVE[arg_145_0] then
			return
		end

		local template = arg_145_1.template
		local name = arg_145_2[2].name

		if not template.trigger_on_breed[name] and not ScriptUnit.has_extension(arg_145_0, "buff_system") then
			Managers.state.entity:system("buff_system"):add_buff(arg_145_0, "armor_breaker", arg_145_0)
		end
	end,
	remove_mark_of_nurgle = function (arg_146_0, arg_146_1, arg_146_2)
		-- function 146
		local main_world = Application.main_world()
		local linked_effect = arg_146_1.linked_effect

		if not linked_effect then
			World.destroy_particles(main_world, linked_effect)

			arg_146_1.linked_effect = nil
		end

		local sound_id = arg_146_1.sound_id

		if not sound_id then
			WwiseWorld.stop_event(arg_146_1.wwise_world, sound_id)

			arg_146_1.sound_id = nil
		end
	end,
	apply_mark_of_nurgle_dot = function (arg_147_0, arg_147_1, arg_147_2, arg_147_3, arg_147_4)
		-- function 147
		local var_147_0 = arg_147_2[arg_147_4.attacked_unit]
		local var_147_1 = arg_147_2[arg_147_4.attacker_unit]
		local var_147_2 = arg_147_2[arg_147_4.damage_source]

		if not (not ALIVE[var_147_0] and var_147_2 == "dot_debuff") then
			local extension = ScriptUnit.extension(var_147_0, "buff_system")
			local tbl = {
				attacker_unit = var_147_1
			}

			extension:add_buff("curse_mark_of_nurgle_dot", tbl)
		end
	end,
	mark_of_nurgle_explosion = function (arg_148_0, arg_148_1, arg_148_2)
		-- function 148
		if not Managers.state.entity:system("projectile_system") then
			local template = arg_148_1.template
			local var_148_1 = arg_148_2[1]
			local var_148_2 = POSITION_LOOKUP[var_148_1]
			local get_difficulty = Managers.state.difficulty:get_difficulty()
			local index_of = table.index_of(DefaultDifficulties, get_difficulty)
			local get_value_or_last = table.get_value_or_last(template.aoe_init_difficulty_damage, index_of)
			local get_value_or_last_2 = table.get_value_or_last(template.aoe_dot_difficulty_damage, index_of)
			local tbl = {
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
					aoe_dot_damage = DamageUtils.calculate_damage(get_value_or_last_2),
					aoe_init_damage = DamageUtils.calculate_damage(get_value_or_last),
					aoe_dot_damage_interval = template.aoe_dot_damage_interval,
					radius = template.radius,
					initial_radius = template.initial_radius,
					life_time = template.cloud_life_time,
					source_attacker_unit = var_148_1
				}
			}
			local str = "units/weapons/projectile/poison_wind_globe/poison_wind_globe"
			local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "aoe_unit", tbl, var_148_2)
			local go_id = Managers.state.unit_storage:go_id(spawn_network_unit)

			Unit.set_unit_visibility(spawn_network_unit, false)

			if not fn_4() then
				Managers.state.network.network_transmit:send_rpc_all("rpc_area_damage", go_id, var_148_2)
			end
		end
	end,
	bloodthirst_on_kill = function (arg_149_0, arg_149_1, arg_149_2)
		-- function 149
		arg_149_1.reset_timer()

		if not ALIVE[arg_149_0] then
			local template = arg_149_1.template
			local kill_count = arg_149_1.kill_count

			kill_count = kill_count or 0

			local num = kill_count + 1

			if num >= template.kills_needed then
				num = 0

				local buff_name_to_add = template.buff_name_to_add
				local flag = BuffUtils.get_max_stacks(buff_name_to_add) > #arg_149_1.stacked_buffs
				local has_extension = ScriptUnit.has_extension(arg_149_0, "buff_system")

				if not has_extension and not flag then
					local add_buff = has_extension:add_buff(buff_name_to_add)

					table.insert(arg_149_1.stacked_buffs, add_buff)
				end
			end

			arg_149_1.kill_count = num
		end
	end,
	headhunter_on_damage_dealt = function (arg_150_0, arg_150_1, arg_150_2, arg_150_3, arg_150_4)
		-- function 150
		if not ALIVE[arg_150_0] then
			return
		end

		local has_extension = ScriptUnit.has_extension(arg_150_0, "buff_system")
		local var_150_1 = arg_150_2[arg_150_4.hit_zone_name]
		local template = arg_150_1.template
		local var_150_3 = template.valid_hit_zones[var_150_1]
		local var_150_4 = template.ignore_hit_zones[var_150_1]

		if not var_150_3 then
			local buff_name_to_add = template.buff_name_to_add
			local flag = BuffUtils.get_max_stacks(buff_name_to_add) > #arg_150_1.stacked_buffs

			if not has_extension and not flag then
				local add_buff = has_extension:add_buff(buff_name_to_add)

				table.insert(arg_150_1.stacked_buffs, add_buff)
			end
		elseif var_150_4 or not has_extension then
			for i = 1, template.remove_amount do
				local var_150_8 = arg_150_1.stacked_buffs[#arg_150_1.stacked_buffs]

				has_extension:remove_buff(var_150_8)

				arg_150_1.stacked_buffs[#arg_150_1.stacked_buffs] = nil
			end
		end
	end,
	vampiric_heal = function (arg_151_0, arg_151_1, arg_151_2, arg_151_3, arg_151_4)
		-- function 151
		if not ALIVE[arg_151_0] and not fn_4() then
			local difficulty_multiplier = arg_151_1.template.difficulty_multiplier
			local var_151_1 = difficulty_multiplier[Managers.state.difficulty:get_difficulty()]

			var_151_1 = var_151_1 or table.values(difficulty_multiplier)[1]

			local num = arg_151_2[arg_151_4.damage_amount] * var_151_1

			DamageUtils.heal_network(arg_151_0, arg_151_0, num, "health_regen")
		end
	end,
	friendly_murder = function (arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4)
		-- function 152
		if not ALIVE[arg_152_0] and not fn_4() then
			local var_152_0 = POSITION_LOOKUP[arg_152_0]
			local range = arg_152_1.range
			local num = range * range
			local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_152_0].PLAYER_AND_BOT_UNITS
			local difficulty_multiplier = arg_152_1.template.difficulty_multiplier
			local var_152_5 = difficulty_multiplier[Managers.state.difficulty:get_difficulty()]

			var_152_5 = var_152_5 or table.values(difficulty_multiplier)[1]

			local num_2 = arg_152_2[arg_152_4.damage_amount] * var_152_5

			for i = 1, #PLAYER_AND_BOT_UNITS do
				local var_152_7 = PLAYER_AND_BOT_UNITS[i]

				if var_152_7 == arg_152_0 or not Unit.alive(var_152_7) then
					local var_152_8 = POSITION_LOOKUP[var_152_7]

					if num > Vector3.distance_squared(var_152_0, var_152_8) then
						DamageUtils.heal_network(var_152_7, arg_152_0, num_2, "health_regen")
					end
				end
			end
		end
	end,
	curse_khorne_champions_leader_death = function (arg_153_0, arg_153_1, arg_153_2)
		-- function 153
		return true
	end,
	spawn_greed_pinata = function (arg_154_0, arg_154_1, arg_154_2)
		-- function 154
		if not fn_4() then
			return true
		end

		local var_154_0 = arg_154_2[1]
		local var_154_1 = POSITION_LOOKUP[var_154_0]
		local var_154_2

		Managers.state.conflict:spawn_queued_unit(Breeds.chaos_greed_pinata, Vector3Box(var_154_1), QuaternionBox(Quaternion.identity()), "mutator", "spawn_idle", "terror_event", var_154_2)

		return true
	end,
	curse_greed_pinata_death = function (arg_155_0, arg_155_1, arg_155_2)
		-- function 155
		local health_extension = arg_155_1.health_extension

		if not health_extension then
			while arg_155_1.drops_done < arg_155_1.template.total_drops do
				local attacker_unit_id = health_extension.last_damage_data.attacker_unit_id

				fn_8(arg_155_1.template.drop_table, POSITION_LOOKUP[arg_155_2[1]], attacker_unit_id)

				arg_155_1.drops_done = arg_155_1.drops_done + 1
			end
		end

		return true
	end,
	remove_objective_unit = function (arg_156_0, arg_156_1, arg_156_2)
		-- function 156
		if not arg_156_1.objective_unit then
			World.unlink_unit(Unit.world(arg_156_1.objective_unit), arg_156_1.objective_unit)
			Managers.state.unit_spawner:mark_for_deletion(arg_156_1.objective_unit)

			arg_156_1.objective_unit = nil
		end
	end,
	all_potions_heal_func = function (arg_157_0, arg_157_1, arg_157_2)
		-- function 157
		if not ALIVE[arg_157_0] then
			local bonus = arg_157_1.bonus
			local str = "healing_draught"

			if not fn_4() then
				DamageUtils.heal_network(arg_157_0, arg_157_0, bonus, str)
			else
				local network = Managers.state.network
				local unit_game_object_id = network:unit_game_object_id(arg_157_0)
				local var_157_4 = NetworkLookup.heal_types[str]

				network.network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, bonus, var_157_4)
			end
		end
	end,
	remove_health_bar = function (arg_158_0, arg_158_1, arg_158_2)
		-- function 158
		Managers.state.event:trigger("tutorial_event_remove_health_bar", arg_158_1.unit)
	end,
	trigger_dialogue_event = function (arg_159_0, arg_159_1, arg_159_2)
		-- function 159
		local dialogue_event = arg_159_1.template.dialogue_event
		local extension_input = ScriptUnit.extension_input(arg_159_0, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_dialogue_event(dialogue_event, alloc_table)
	end,
	add_buff_on_pickup = function (arg_160_0, arg_160_1, arg_160_2)
		-- function 160
		if not ALIVE[arg_160_0] then
			local var_160_0 = arg_160_2[2]
			local var_160_1 = fn_7(arg_160_1, var_160_0)

			if not var_160_1 then
				if not arg_160_1.template.local_only then
					local extension = ScriptUnit.extension(arg_160_0, "buff_system")

					for i = 1, #var_160_1 do
						extension:add_buff(var_160_1[i])
					end
				else
					local system = Managers.state.entity:system("buff_system")

					for j = 1, #var_160_1 do
						system:add_buff(arg_160_0, var_160_1[j], arg_160_0, false)
					end
				end
			end
		end
	end,
	heal_on_pickup = function (arg_161_0, arg_161_1, arg_161_2, arg_161_3)
		-- function 161
		if not ALIVE[arg_161_0] then
			local var_161_0 = arg_161_2[2]
			local var_161_1 = fn_7(arg_161_1, var_161_0)
			local unit_template_name = var_161_0.unit_template_name
			local flag = not unit_template_name and unit_template_name == "limited_owned_pickup_unit"

			if not (not var_161_1 and flag) then
				fn_6(arg_161_0, var_161_1.type, var_161_1.amount)

				local sound_event = arg_161_1.template.sound_event

				if not fn(arg_161_0) then
					local var_161_5 = NetworkLookup.sound_events[sound_event]
					local network_id = Managers.player:owner(arg_161_0):network_id()

					Managers.state.network.network_transmit:send_rpc("rpc_play_2d_audio_event", network_id, var_161_5)
				else
					local wwise_world = Managers.world:wwise_world(arg_161_3)

					WwiseWorld.trigger_event(wwise_world, sound_event)
				end
			end
		end
	end,
	ally_gain_ammo_on_pickup = function (arg_162_0, arg_162_1, arg_162_2)
		-- function 162
		if not ALIVE[arg_162_0] then
			local var_162_0 = arg_162_2[2]
			local var_162_1 = fn_7(arg_162_1, var_162_0)

			if not var_162_1 then
				local ammo_bonus_fraction = var_162_1.ammo_bonus_fraction
				local max_range = var_162_1.max_range
				local num = max_range * max_range
				local var_162_5 = POSITION_LOOKUP[arg_162_0]
				local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_162_0].PLAYER_AND_BOT_UNITS
				local system = Managers.state.entity:system("ammo_system")

				for i = 1, #PLAYER_AND_BOT_UNITS do
					local var_162_8 = PLAYER_AND_BOT_UNITS[i]

					if not (not ALIVE[var_162_8] and var_162_8 == arg_162_0 or not (num >= Vector3.distance_squared(var_162_5, POSITION_LOOKUP[var_162_8]))) then
						system:give_ammo_fraction_to_owner(var_162_8, ammo_bonus_fraction, true)
					end
				end
			end
		end
	end,
	add_buff_on_ally_revived = function (arg_163_0, arg_163_1, arg_163_2)
		-- function 163
		local var_163_0 = arg_163_2[1]

		if not ALIVE[arg_163_0] and not ALIVE[var_163_0] and not fn_4() then
			local system = Managers.state.entity:system("buff_system")
			local buff_to_add = arg_163_1.template.buff_to_add

			if not buff_to_add then
				for i = 1, #buff_to_add do
					local var_163_3 = buff_to_add[i]

					system:add_buff(arg_163_0, var_163_3, arg_163_0, false)
				end
			end

			local buff_to_add_revived = arg_163_1.template.buff_to_add_revived

			if not buff_to_add_revived then
				for j = 1, #buff_to_add_revived do
					local var_163_5 = buff_to_add_revived[j]

					system:add_buff(var_163_0, var_163_5, arg_163_0, false)
				end
			end
		end
	end,
	chain_lightning = function (arg_164_0, arg_164_1, arg_164_2, arg_164_3, arg_164_4)
		-- function 164
		local var_164_0 = arg_164_2[arg_164_4.attacked_unit]
		local var_164_1 = arg_164_2[arg_164_4.first_hit]
		local var_164_2 = arg_164_2[arg_164_4.is_critical_strike]

		if not ALIVE[arg_164_0] and not ALIVE[var_164_0] and not var_164_1 and not var_164_2 then
			local var_164_3 = POSITION_LOOKUP[var_164_0]
			local template = arg_164_1.template
			local damage_source = template.damage_source
			local system = Managers.state.entity:system("audio_system")
			local sound_event = template.sound_event
			local str = "damage_over_time"
			local var_164_9 = arg_164_2[2]

			DamageUtils.add_damage_network(var_164_0, arg_164_0, var_164_9, "torso", str, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)

			local var_164_10 = NetworkLookup.effects["fx/cw_chain_lightning"]
			local num = POSITION_LOOKUP[arg_164_0] + 0.5 * Vector3.up()
			local var_164_12
			local has_node = Unit.has_node(var_164_0, "j_spine")

			has_node = not has_node and Unit.node(var_164_0, "j_spine")

			if not has_node then
				var_164_12 = Unit.world_position(var_164_0, has_node)
			else
				var_164_12 = POSITION_LOOKUP[var_164_0] + 0.5 * Vector3.up()
			end

			local distance = Vector3.distance(var_164_12, num)
			local var_164_15 = Vector3(1, distance, 0)
			local look = Quaternion.look(var_164_12 - num)

			Managers.state.network:rpc_play_particle_effect_with_variable(nil, var_164_10, num, look, "distance", var_164_15)

			local max_chain_range = template.max_chain_range
			local num_2 = template.max_targets - 1
			local var_164_19 = Managers.state.side.side_by_unit[arg_164_0]
			local flag = not var_164_19 and var_164_19.enemy_broadphase_categories
			local alloc_table = FrameTable.alloc_table()
			local tbl = {}

			for i = 1, num_2 do
				local broadphase_query = AiUtils.broadphase_query(var_164_3, max_chain_range, alloc_table, flag)

				table.sort(alloc_table, function (arg_165_0, arg_165_1)
					-- function 165
					return Vector3.distance_squared(POSITION_LOOKUP[arg_165_0], var_164_3) < Vector3.distance_squared(POSITION_LOOKUP[arg_165_1], var_164_3)
				end)

				for j = 1, broadphase_query do
					local var_164_24 = alloc_table[j]

					if not (not ALIVE[var_164_24] and tbl[var_164_24] and not HEALTH_ALIVE[var_164_24] and var_164_24 == var_164_0) then
						tbl[var_164_24] = true

						DamageUtils.add_damage_network(var_164_24, arg_164_0, var_164_9, "torso", str, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, i)
						system:play_audio_unit_event(sound_event, var_164_24)

						local var_164_25 = var_164_12
						local flag_2 = not Unit.has_node(var_164_24, "j_spine") and Unit.node(var_164_24, "j_spine")

						if not flag_2 then
							var_164_12 = Unit.world_position(var_164_24, flag_2)
						else
							var_164_12 = POSITION_LOOKUP[var_164_24] + 0.5 * Vector3.up()
						end

						local distance_2 = Vector3.distance(var_164_12, var_164_25)
						local var_164_28 = Vector3(1, distance_2, 0)
						local look_2 = Quaternion.look(var_164_12 - var_164_25)

						Managers.state.network:rpc_play_particle_effect_with_variable(nil, var_164_10, var_164_25, look_2, "distance", var_164_28)

						var_164_3 = POSITION_LOOKUP[var_164_24]

						break
					end
				end
			end
		end
	end,
	cooldown_on_friendly_ability = function (arg_166_0, arg_166_1, arg_166_2)
		-- function 166
		local var_166_0 = arg_166_2[1]

		if arg_166_0 == var_166_0 then
			return
		end

		local var_166_1 = POSITION_LOOKUP[arg_166_0]
		local var_166_2 = POSITION_LOOKUP[var_166_0]

		if not var_166_1 and not var_166_2 then
			local range = arg_166_1.template.range

			if range * range >= Vector3.distance_squared(var_166_1, var_166_2) then
				local has_extension = ScriptUnit.has_extension(arg_166_0, "career_system")

				if not has_extension then
					local value = arg_166_1.template.value

					has_extension:reduce_activated_ability_cooldown_percent(value)
				end
			end
		end
	end,
	skill_on_special_kill = function (arg_167_0, arg_167_1, arg_167_2)
		-- function 167
		if not ALIVE[arg_167_0] then
			local has_extension = ScriptUnit.has_extension(arg_167_0, "career_system")

			if not has_extension then
				local percent_restored = arg_167_1.template.percent_restored

				has_extension:reduce_activated_ability_cooldown_percent(percent_restored)
			end
		end
	end,
	add_buff_on_proc = function (arg_168_0, arg_168_1, arg_168_2)
		-- function 168
		local system = Managers.state.entity:system("buff_system")
		local buff_to_add = arg_168_1.template.buff_to_add

		system:add_buff(arg_168_0, buff_to_add, arg_168_0, false)
	end,
	add_buff_on_melee_kills_proc = function (arg_169_0, arg_169_1, arg_169_2)
		-- function 169
		if not fn_4() then
			return
		end

		local var_169_0 = arg_169_2[1]

		if not var_169_0 then
			return
		end

		local var_169_1 = var_169_0[DamageDataIndex.ATTACK_TYPE]

		if not (not var_169_1 and var_169_1 == "light_attack" and var_169_1 == "heavy_attack") then
			return
		end

		local buff_to_add = arg_169_1.template.buff_to_add
		local system = Managers.state.entity:system("buff_system")
		local extension = ScriptUnit.extension(arg_169_0, "buff_system")

		if not extension:get_non_stacking_buff(buff_to_add) then
			local add_buff = system:add_buff(arg_169_0, buff_to_add, arg_169_0, true)
			local get_non_stacking_buff = extension:get_non_stacking_buff(buff_to_add)

			if not get_non_stacking_buff then
				get_non_stacking_buff.server_id = add_buff
			end
		end
	end,
	add_buff_on_non_friendly_damage_taken = function (arg_170_0, arg_170_1, arg_170_2)
		-- function 170
		local var_170_0 = arg_170_2[1]
		local var_170_1 = Managers.state.side.side_by_unit[arg_170_0]
		local var_170_2 = Managers.state.side.side_by_unit[var_170_0]

		if not (arg_170_0 == var_170_0 or not var_170_1 or not var_170_2 or var_170_1 ~= var_170_2 or not var_170_2) then
			local system = Managers.state.entity:system("buff_system")
			local buff_to_add = arg_170_1.template.buff_to_add

			system:add_buff(arg_170_0, buff_to_add, arg_170_0, false)
		end
	end,
	deus_damage_reduction_on_incapacitated = function (arg_171_0, arg_171_1, arg_171_2)
		-- function 171
		if not ALIVE[arg_171_0] and not ScriptUnit.extension(arg_171_0, "status_system"):is_disabled() then
			local system = Managers.state.entity:system("buff_system")
			local buff_to_add = arg_171_1.template.buff_to_add

			system:add_buff(arg_171_0, buff_to_add, arg_171_0, false)
		end
	end,
	drop_item_on_ability_use = function (arg_172_0, arg_172_1, arg_172_2)
		-- function 172
		local has_extension = ScriptUnit.has_extension(arg_172_0, "inventory_system")
		local has_extension_2 = ScriptUnit.has_extension(arg_172_0, "buff_system")

		if not has_extension_2 and not has_extension_2:has_buff_type("drop_item_on_ability_use_cooldown") then
			return
		end

		if not has_extension then
			local tbl = {}
			local tbl_2 = {
				"slot_healthkit",
				"slot_potion",
				"slot_grenade"
			}

			for k, v in pairs(tbl_2) do
				local get_item_data = has_extension:get_item_data(v)

				if not get_item_data then
					local pickup_data = BackendUtils.get_item_template(get_item_data).pickup_data

					tbl[#tbl + 1] = pickup_data

					local get_additional_items = has_extension:get_additional_items(v)

					if not get_additional_items then
						for k_2, v_2 in pairs(get_additional_items) do
							local pickup_data_2 = BackendUtils.get_item_template(v_2).pickup_data

							tbl[#tbl + 1] = pickup_data_2
						end
					end
				end
			end

			if #tbl > 0 then
				local var_172_8 = tbl[math.random(1, #tbl)]
				local var_172_9 = POSITION_LOOKUP[arg_172_0]
				local var_172_10 = Vector3(math.random(-1, 1), math.random(-1, 1), 2)
				local normalize = Vector3.normalize(var_172_10)
				local num = var_172_9 + var_172_10 * 0.2

				if not NetworkUtils.network_safe_position(num) then
					local num_2 = math.random(-math.half_pi, math.half_pi) / 2
					local axis_angle = Quaternion.axis_angle(normalize, num_2)
					local pickup_name = var_172_8.pickup_name
					local slot_name = AllPickups[pickup_name].slot_name
					local system = Managers.state.entity:system("audio_system")
					local var_172_18

					if slot_name == "slot_healtkit" then
						var_172_18 = "morris_power_ups_clone_medkit"
					elseif slot_name == "slot_grenade" then
						var_172_18 = "morris_power_ups_clone_grenade"
					elseif slot_name == "slot_potion" then
						var_172_18 = "morris_power_ups_clone_potion"
					end

					system:play_audio_position_event(var_172_18, num)

					local str = "dropped"
					local network = Managers.state.network

					if not fn_4() then
						Managers.state.entity:system("pickup_system"):spawn_pickup(pickup_name, num, axis_angle, true, str)
					else
						local var_172_21 = NetworkLookup.pickup_names[pickup_name]
						local var_172_22 = NetworkLookup.pickup_spawn_types[str]

						network.network_transmit:send_rpc_server("rpc_spawn_pickup_with_physics", var_172_21, num, axis_angle, var_172_22)
					end

					local system_2 = Managers.state.entity:system("buff_system")
					local cooldown_buff = arg_172_1.template.cooldown_buff
					local cooldown_durations = arg_172_1.template.cooldown_durations

					system_2:add_buff(arg_172_0, cooldown_buff, arg_172_0, false)

					local get_non_stacking_buff = has_extension_2:get_non_stacking_buff("drop_item_on_ability_use_cooldown")
					local var_172_27 = cooldown_durations[pickup_name]

					var_172_27 = var_172_27 or 60
					get_non_stacking_buff.duration = var_172_27
				end
			end
		end
	end,
	apply_held_potion_effect = function (arg_173_0, arg_173_1, arg_173_2)
		-- function 173
		if not ALIVE[arg_173_0] then
			return
		end

		local has_extension = ScriptUnit.has_extension(arg_173_0, "inventory_system")

		if not has_extension then
			return
		end

		local str = "slot_potion"
		local get_item_data = has_extension:get_item_data(str)

		if not get_item_data then
			return
		end

		local get_item_template = BackendUtils.get_item_template(get_item_data)
		local tbl = {
			get_item_template.actions.action_one.default.buff_template
		}
		local get_additional_items = has_extension:get_additional_items(str)

		if not get_additional_items then
			for k, v in pairs(get_additional_items) do
				local buff_template = BackendUtils.get_item_template(v).actions.action_one.default.buff_template

				tbl[#tbl + 1] = buff_template
			end
		end

		if #tbl > 0 then
			local var_173_7 = tbl[math.random(#tbl)]

			Managers.state.entity:system("buff_system"):add_buff(arg_173_0, var_173_7, arg_173_0, false)
		end
	end,
	block_procs_parry = function (arg_174_0, arg_174_1, arg_174_2)
		-- function 174
		local extension = ScriptUnit.extension(arg_174_0, "buff_system")
		local var_174_1 = arg_174_2[1]
		local var_174_2 = arg_174_2[2]
		local var_174_3 = arg_174_2[3]

		extension:trigger_procs("on_timed_block", var_174_1, var_174_2, var_174_3)
	end,
	active_ability_for_coins = function (arg_175_0, arg_175_1, arg_175_2)
		-- function 175
		local has_extension = ScriptUnit.has_extension(arg_175_0, "career_system")

		if not has_extension then
			local current_ability_cooldown_percentage = has_extension:current_ability_cooldown_percentage()
			local floor = math.floor(current_ability_cooldown_percentage * 100)

			print("Remove Coins:", floor)
		end
	end,
	on_push_explosion = function (arg_176_0, arg_176_1, arg_176_2)
		-- function 176
		local template = arg_176_1.template
		local var_176_1 = arg_176_2[1]

		if not ALIVE[arg_176_0] and not ALIVE[var_176_1] then
			local extension = ScriptUnit.extension(arg_176_0, "career_system")
			local system = Managers.state.entity:system("area_damage_system")
			local lerp = Vector3.lerp(POSITION_LOOKUP[arg_176_0], POSITION_LOOKUP[var_176_1], 0.5)
			local str = "buff"
			local explosion_template = template.explosion_template
			local identity = Quaternion.identity()
			local num = extension:get_career_power_level() * template.power_scale
			local num_2 = 1
			local flag = false

			system:create_explosion(arg_176_0, lerp, identity, explosion_template, num_2, str, num, flag)
		end
	end,
	elites_on_kill_explosion = function (arg_177_0, arg_177_1, arg_177_2)
		-- function 177
		if not fn_4() then
			return
		end

		local template = arg_177_1.template
		local var_177_1 = arg_177_2[3]
		local has_extension = ScriptUnit.has_extension(var_177_1, "health_system")

		if not has_extension then
			local recent_damage_source = has_extension:recent_damage_source()
			local recently_damaged = has_extension:recently_damaged()

			if not (recent_damage_source ~= "buff" or recently_damaged ~= "grenade") then
				return
			end
		end

		if not ALIVE[arg_177_0] and not ALIVE[var_177_1] then
			local has_extension_2 = ScriptUnit.has_extension(arg_177_0, "career_system")
			local system = Managers.state.entity:system("area_damage_system")
			local var_177_7 = POSITION_LOOKUP[var_177_1]
			local str = "buff"
			local explosion_template = template.explosion_template
			local identity = Quaternion.identity()
			local num = has_extension_2:get_career_power_level() * template.power_scale
			local num_2 = 1
			local flag = false

			system:create_explosion(arg_177_0, var_177_7, identity, explosion_template, num_2, str, num, flag)

			local system_2 = Managers.state.entity:system("audio_system")
			local sound_event = template.sound_event

			system_2:play_audio_unit_event(sound_event, var_177_1)
		end

		Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_177_0, arg_177_1.server_id)
	end,
	heal_on_dot_damage_dealt = function (arg_178_0, arg_178_1, arg_178_2)
		-- function 178
		local str = "health_regen"
		local value = arg_178_1.template.value

		DamageUtils.heal_network(arg_178_0, arg_178_0, value, str)
	end,
	deus_collateral_damage_on_melee_killing_blow_func = function (arg_179_0, arg_179_1, arg_179_2, arg_179_3)
		-- function 179
		local template = arg_179_1.template
		local var_179_1 = arg_179_2[3]
		local var_179_2 = arg_179_2[1]

		if not var_179_2 then
			return
		end

		if not ALIVE[arg_179_0] and not ALIVE[var_179_1] then
			local var_179_3 = POSITION_LOOKUP[var_179_1]
			local var_179_4 = var_179_2[DamageDataIndex.DAMAGE_SOURCE_NAME]

			if not var_179_4 then
				return
			end

			local var_179_5 = var_179_2[DamageDataIndex.ATTACK_TYPE]

			if not (not var_179_5 and var_179_5 == "light_attack" and var_179_5 == "heavy_attack") then
				return
			end

			local var_179_6 = var_179_2[DamageDataIndex.DAMAGE_TYPE]
			local var_179_7 = var_179_2[DamageDataIndex.DAMAGE_AMOUNT]
			local max_range = template.max_range
			local var_179_9 = Managers.state.side.side_by_unit[arg_179_0]
			local flag = not var_179_9 and var_179_9.enemy_broadphase_categories
			local alloc_table = FrameTable.alloc_table()
			local tbl = {}

			for i = 1, 1 do
				local broadphase_query = AiUtils.broadphase_query(var_179_3, max_range, alloc_table, flag)

				table.sort(alloc_table, function (arg_180_0, arg_180_1)
					-- function 180
					return Vector3.distance_squared(POSITION_LOOKUP[arg_180_0], var_179_3) < Vector3.distance_squared(POSITION_LOOKUP[arg_180_1], var_179_3)
				end)

				for j = 1, broadphase_query do
					local var_179_14 = alloc_table[j]

					if not (not HEALTH_ALIVE[var_179_14] and tbl[var_179_14]) then
						tbl[var_179_14] = true

						DamageUtils.add_damage_network(var_179_14, arg_179_0, var_179_7, "torso", var_179_6, nil, Vector3(1, 0, 0), var_179_4, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, i)

						local system = Managers.state.entity:system("audio_system")
						local sound_event = template.sound_event

						system:play_audio_unit_event(sound_event, var_179_14)

						var_179_3 = POSITION_LOOKUP[var_179_14]

						break
					end
				end
			end
		end
	end,
	deus_special_farm_max_health_on_special = function (arg_181_0, arg_181_1, arg_181_2, arg_181_3)
		-- function 181
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_181_0] then
			local killed_specials = arg_181_1.killed_specials

			killed_specials = killed_specials or 0

			local num = killed_specials + 1
			local template = arg_181_1.template

			if num >= template.specials_per_pop then
				local system = Managers.state.entity:system("buff_system")
				local buff_to_add = template.buff_to_add

				system:add_buff(arg_181_0, buff_to_add, arg_181_0, true)

				num = 0
			end

			arg_181_1.killed_specials = num
		end
	end,
	deus_transmute_into_coins = function (arg_182_0, arg_182_1, arg_182_2, arg_182_3)
		-- function 182
		if not fn_4() then
			local var_182_0 = arg_182_2[2]
			local var_182_1 = arg_182_2[3]

			if not (var_182_0 ~= "heavy_attack" or var_182_1 ~= "head" or math.random(1, 10) ~= 1) then
				local var_182_2 = arg_182_2[1]
				local var_182_3 = POSITION_LOOKUP[var_182_2]
				local var_182_4 = Vector3(math.random(-1, 1), math.random(-1, 1), 2)
				local normalize = Vector3.normalize(var_182_4)
				local num = var_182_3 + var_182_4 * 0.2

				if not NetworkUtils.network_safe_position(num) then
					local num_2 = math.random(-math.half_pi, math.half_pi) / 2
					local axis_angle = Quaternion.axis_angle(normalize, num_2)
					local str = "deus_soft_currency"
					local str_2 = "dropped"

					Managers.state.entity:system("pickup_system"):spawn_pickup(str, num, axis_angle, true, str_2)

					local var_182_11 = arg_182_0
					local str_3 = "buff"
					local str_4 = "generic_mutator_explosion"
					local get_template = ExplosionUtils.get_template(str_4)

					DamageUtils.create_explosion(arg_182_3, var_182_11, num, Quaternion.identity(), get_template, 1, str_3, fn_4(), false, var_182_2, 0, false)

					local system = Managers.state.entity:system("audio_system")
					local sound_event = arg_182_1.template.sound_event

					system:play_audio_unit_event(sound_event, var_182_2)

					local go_id = Managers.state.unit_storage:go_id(var_182_11)
					local var_182_18 = NetworkLookup.explosion_templates[str_4]
					local var_182_19 = NetworkLookup.damage_sources[str_3]

					Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, num, Quaternion.identity(), var_182_18, 1, var_182_19, 0, false, go_id)

					local var_182_20 = BLACKBOARDS[var_182_2]

					Managers.state.conflict:destroy_unit(var_182_2, var_182_20, "buff")
				end
			end
		end
	end,
	always_blocking_weapon_swap = function (arg_183_0, arg_183_1, arg_183_2, arg_183_3)
		-- function 183
		arg_183_1.equipment = arg_183_2[1]
		arg_183_1.swapped_weapons = true
	end,
	always_blocking_temporarily_remove = function (arg_184_0, arg_184_1, arg_184_2, arg_184_3)
		-- function 184
		local extension = ScriptUnit.extension(arg_184_0, "buff_system")
		local str = "deus_always_blocking_lock_out"

		extension:add_buff(str)
	end,
	deus_reckless_swings_buff_on_hit = function (arg_185_0, arg_185_1, arg_185_2, arg_185_3)
		-- function 185
		if not fn_4() then
			local var_185_0 = arg_185_2[4]
			local flag = arg_185_2[2] == "light_attack" or arg_185_2[2] == "heavy_attack"

			if not (var_185_0 <= 1) or not flag then
				local template = arg_185_1.template
				local damage_to_deal = template.damage_to_deal

				if not template.is_non_lethal then
					local has_extension = ScriptUnit.has_extension(arg_185_0, "health_system")

					if not has_extension then
						local current_health = has_extension:current_health()

						damage_to_deal = math.clamp(damage_to_deal, 0, math.max(current_health - 0.25, 0))
						damage_to_deal = DamageUtils.networkify_damage(damage_to_deal)
					else
						damage_to_deal = 0
					end
				end

				if damage_to_deal > 0 then
					DamageUtils.add_damage_network(arg_185_0, arg_185_0, damage_to_deal, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_185_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end
			end
		end
	end,
	grenade_explode_buff_area = function (arg_186_0, arg_186_1, arg_186_2)
		-- function 186
		if not fn_4() then
			return
		end

		local alloc_table

		alloc_table.buff_area_position, alloc_table = arg_186_2[2], FrameTable.alloc_table()

		ScriptUnit.extension(arg_186_0, "buff_system"):add_buff(arg_186_1.template.buff_to_add, alloc_table)
	end,
	cursed_chest_area_buff = function (arg_187_0, arg_187_1, arg_187_2)
		-- function 187
		if not fn_4() then
			return
		end

		local alloc_table

		alloc_table.buff_area_position, alloc_table = Unit.world_position(arg_187_2[1], 0), FrameTable.alloc_table()

		ScriptUnit.extension(arg_187_0, "buff_system"):add_buff(arg_187_1.template.buff_to_add, alloc_table)
	end,
	spawn_drones_proc = function (arg_188_0, arg_188_1, arg_188_2)
		-- function 188
		local num_drones = arg_188_1.template.num_drones
		local radius = arg_188_1.template.radius
		local damage_profile_name = arg_188_1.template.damage_profile_name

		fn_11(arg_188_0, num_drones, radius, damage_profile_name)
	end,
	spawn_drones_proc_headshot = function (arg_189_0, arg_189_1, arg_189_2)
		-- function 189
		if arg_189_2[4] ~= "head" then
			return
		end

		ProcFunctions.spawn_drones_proc(arg_189_0, arg_189_1, arg_189_2)
	end,
	spawn_drones_proc_ability = function (arg_190_0, arg_190_1, arg_190_2)
		-- function 190
		if arg_190_2[1] ~= arg_190_0 then
			return
		end

		ProcFunctions.spawn_drones_proc(arg_190_0, arg_190_1, arg_190_2)
	end,
	boon_range_02_delayed_add_on_hit = function (arg_191_0, arg_191_1, arg_191_2)
		-- function 191
		local var_191_0 = arg_191_2[1]
		local has_extension = ScriptUnit.has_extension(var_191_0, "buff_system")

		if not has_extension then
			local cached_params = arg_191_1.cached_params

			cached_params = cached_params or {
				attacker_unit = arg_191_0
			}
			arg_191_1.cached_params = cached_params

			has_extension:add_buff("boon_range_02_buff_adder", arg_191_1.cached_params)
		end
	end,
	boon_range_02_damage_check = function (arg_192_0, arg_192_1, arg_192_2)
		-- function 192
		local var_192_0 = arg_192_2[1]
		local has_extension = ScriptUnit.has_extension(var_192_0, "buff_system")

		if not has_extension then
			local get_stacking_buff = has_extension:get_stacking_buff("boon_range_02_increased_damage_tracker")

			if not get_stacking_buff then
				for i = 1, #get_stacking_buff do
					if get_stacking_buff[i].attacker_unit == arg_192_0 then
						local cached_params = arg_192_1.cached_params

						cached_params = cached_params or {
							attacker_unit = arg_192_0
						}
						arg_192_1.cached_params = cached_params

						has_extension:add_buff("boon_range_02_damage_amplifier", arg_192_1.cached_params)

						break
					end
				end
			end
		end
	end,
	boon_range_02_damage_cleanup = function (arg_193_0, arg_193_1, arg_193_2)
		-- function 193
		local var_193_0 = arg_193_2[1]
		local has_extension = ScriptUnit.has_extension(var_193_0, "buff_system")

		if not has_extension then
			local get_stacking_buff = has_extension:get_stacking_buff("boon_range_02_damage_amplifier")

			if not get_stacking_buff then
				for i = #get_stacking_buff, 1, -1 do
					local var_193_3 = get_stacking_buff[i]

					if var_193_3.attacker_unit == arg_193_0 then
						has_extension:remove_buff(var_193_3.id)
					end
				end
			end
		end
	end,
	deus_big_swing_stagger_on_hit = function (arg_194_0, arg_194_1, arg_194_2, arg_194_3)
		-- function 194
		if not ALIVE[arg_194_0] then
			local var_194_0 = arg_194_2[4]
			local template = arg_194_1.template
			local targets_to_hit = template.targets_to_hit
			local flag = arg_194_2[2] == "light_attack" or arg_194_2[2] == "heavy_attack"

			if not (targets_to_hit <= var_194_0) or not flag then
				local extension = ScriptUnit.extension(arg_194_0, "buff_system")
				local buff_to_add = template.buff_to_add

				extension:add_buff(buff_to_add)
			end
		end
	end,
	deus_push_charge = function (arg_195_0, arg_195_1, arg_195_2, arg_195_3)
		-- function 195
		if not ALIVE[arg_195_0] then
			local extension = ScriptUnit.extension(arg_195_0, "status_system")

			if not extension.do_lunge then
				return
			end

			local template = arg_195_1.template
			local lunge_settings = template.lunge_settings
			local sound_event = template.sound_event

			WwiseUtils.trigger_unit_event(arg_195_3, sound_event, arg_195_0, 0)

			extension.do_lunge = {
				animation_end_event = "dodge_bwd",
				allow_rotation = false,
				first_person_animation_end_event = "dodge_bwd",
				first_person_hit_animation_event = "charge_react",
				dodge = true,
				first_person_animation_event = "dodge_bwd",
				first_person_animation_end_event_hit = "dodge_bwd",
				noclip = true,
				animation_event = "dodge_bwd",
				initial_speed = lunge_settings.initial_speed,
				falloff_to_speed = lunge_settings.falloff_to_speed,
				duration = lunge_settings.duration
			}
		end
	end,
	deus_target_full_health_damage_mult = function (arg_196_0, arg_196_1, arg_196_2, arg_196_3, arg_196_4)
		-- function 196
		local var_196_0 = arg_196_2[arg_196_4.attacked_unit]

		if not ALIVE[arg_196_0] and not ALIVE[var_196_0] then
			local template = arg_196_1.template
			local var_196_2 = arg_196_2[arg_196_4.buff_attack_type]
			local valid_attack_types = template.valid_attack_types

			if not valid_attack_types and not valid_attack_types[var_196_2] then
				local var_196_4 = arg_196_2[arg_196_4.PROC_MODIFIABLE]
				local has_extension = ScriptUnit.has_extension(var_196_0, "health_system")

				if not (not has_extension and not (has_extension:current_health_percent() >= 1)) then
					var_196_4.damage_amount = var_196_4.damage_amount * template.damage_mult
				end
			end
		end
	end,
	deus_damage_source_damage_mult = function (arg_197_0, arg_197_1, arg_197_2, arg_197_3, arg_197_4)
		-- function 197
		local var_197_0 = arg_197_2[arg_197_4.attacked_unit]

		if not ALIVE[arg_197_0] and not ALIVE[var_197_0] then
			local template = arg_197_1.template
			local var_197_2 = arg_197_2[arg_197_4.damage_source]
			local valid_damage_sources = template.valid_damage_sources

			if not valid_damage_sources and not valid_damage_sources[var_197_2] then
				local var_197_4 = arg_197_2[arg_197_4.PROC_MODIFIABLE]

				var_197_4.damage_amount = var_197_4.damage_amount * template.damage_mult
			end
		end
	end,
	triple_melee_headshot_power_counter = function (arg_198_0, arg_198_1, arg_198_2, arg_198_3)
		-- function 198
		local var_198_0 = arg_198_2[3]
		local var_198_1 = arg_198_2[2]

		if not (var_198_1 == "light_attack" or var_198_1 == "heavy_attack") then
			return
		end

		if var_198_0 == "head" then
			local num

			if not arg_198_1.stacks then
				num = arg_198_1.stacks + 1

				if not num then
					-- Nothing
				end
			end

			num = 1

			::label_198_0::

			arg_198_1.stacks = num

			if arg_198_1.stacks >= arg_198_1.template.hits then
				local system = Managers.state.entity:system("buff_system")
				local buff_to_add = arg_198_1.template.buff_to_add

				system:add_buff(arg_198_0, buff_to_add, arg_198_0, false)

				arg_198_1.stacks = 0
			end
		else
			arg_198_1.stacks = 0
		end
	end,
	melee_killing_spree_speed_counter = function (arg_199_0, arg_199_1, arg_199_2, arg_199_3)
		-- function 199
		if not fn(arg_199_0) then
			return
		end

		local var_199_0 = arg_199_2[1]

		if not var_199_0 then
			return
		end

		local var_199_1 = var_199_0[DamageDataIndex.ATTACK_TYPE]

		if not (not var_199_1 and var_199_1 == "light_attack" and var_199_1 == "heavy_attack") then
			return
		end

		local time = Managers.time:time("game")
		local kills = arg_199_1.kills

		kills = kills or {}
		arg_199_1.kills = kills
		arg_199_1.kills[#arg_199_1.kills + 1] = time + arg_199_1.template.time

		if #arg_199_1.kills >= arg_199_1.template.kills then
			local system = Managers.state.entity:system("buff_system")
			local buff_to_add = arg_199_1.template.buff_to_add

			system:add_buff(arg_199_0, buff_to_add, arg_199_0, false)

			local str = "hud_gameplay_stance_smiter_buff"
			local str_2 = "Play_potion_morris_effect_end"

			WwiseUtils.trigger_unit_event(arg_199_3, str, arg_199_0, 0)
			WwiseUtils.trigger_unit_event(arg_199_3, str_2, arg_199_0, 0)

			arg_199_1.kills = {}
		end
	end,
	transfer_temp_health_at_full = function (arg_200_0, arg_200_1, arg_200_2, arg_200_3)
		-- function 200
		local var_200_0 = arg_200_2[3]
		local flag = arg_200_2[1] == arg_200_0
		local extension = ScriptUnit.extension(arg_200_0, "status_system")

		if not (not flag and extension:is_permanent_heal(var_200_0) or ScriptUnit.extension(arg_200_0, "health_system"):current_health_percent() ~= 1) then
			local var_200_3 = arg_200_2[2]
			local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
			local var_200_5
			local huge = math.huge
			local var_200_7 = POSITION_LOOKUP[arg_200_0]
			local range = arg_200_1.template.range

			for i = 1, #PLAYER_UNITS do
				local var_200_9 = PLAYER_UNITS[i]

				if var_200_9 ~= arg_200_0 then
					local has_extension = ScriptUnit.has_extension(var_200_9, "health_system")
					local flag_2 = not has_extension and has_extension:current_health_percent()

					if not (not flag_2 and not (flag_2 < 1)) then
						local var_200_12 = POSITION_LOOKUP[var_200_9]
						local distance_squared = Vector3.distance_squared(var_200_7, var_200_12)

						if not (not (distance_squared < range * range) or not (distance_squared < huge)) then
							var_200_5 = var_200_9
							huge = range
						end
					end
				end
			end

			if not var_200_5 then
				DamageUtils.heal_network(var_200_5, arg_200_0, var_200_3, "heal_from_proc")
			end
		end
	end,
	last_player_standing_knocked_down_check = function (arg_201_0, arg_201_1, arg_201_2)
		-- function 201
		local extension = ScriptUnit.extension(arg_201_0, "status_system")
		local var_201_1 = HEALTH_ALIVE[arg_201_0]

		var_201_1 = not var_201_1 and not extension:is_knocked_down()

		if not var_201_1 then
			local flag = true
			local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

			for i, v in ipairs(PLAYER_AND_BOT_UNITS) do
				if v ~= arg_201_0 then
					local is_knocked_down = ScriptUnit.extension(v, "status_system"):is_knocked_down()

					if not (not HEALTH_ALIVE[v] and is_knocked_down) then
						flag = false
					end
				end
			end

			if not flag then
				local buff_to_add = arg_201_1.template.buff_to_add

				Managers.state.entity:system("buff_system"):add_buff(arg_201_0, buff_to_add, arg_201_0, false)
			end
		end
	end,
	friendly_cooldown_on_ability = function (arg_202_0, arg_202_1, arg_202_2)
		-- function 202
		if arg_202_0 ~= arg_202_2[1] then
			return
		end

		local template = arg_202_1.template
		local value = template.value
		local range = template.range
		local var_202_3 = arg_202_2[2]
		local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
		local var_202_5 = POSITION_LOOKUP[arg_202_0]

		for k, v in pairs(PLAYER_UNITS) do
			if arg_202_0 ~= v then
				local var_202_6 = POSITION_LOOKUP[v]

				if Vector3.distance_squared(var_202_5, var_202_6) < range * range then
					local go_id = Managers.state.unit_storage:go_id(v)

					if not go_id then
						Managers.state.network.network_transmit:send_rpc_server("rpc_server_reduce_activated_ability_cooldown_percent", go_id, value, var_202_3, true)
					end
				end
			end
		end
	end,
	deus_second_wind_on_hit = function (arg_203_0, arg_203_1, arg_203_2)
		-- function 203
		if not fn_4() then
			return
		end

		if not ALIVE[arg_203_0] then
			local template = arg_203_1.template
			local extension = ScriptUnit.extension(arg_203_0, "buff_system")

			if not extension:has_buff_perk("invulnerable") then
				return
			end

			local has_extension = ScriptUnit.has_extension(arg_203_0, "health_system")
			local health_threshold = template.health_threshold
			local current_health = has_extension:current_health()
			local get_max_health = has_extension:get_max_health()
			local var_203_6 = arg_203_2[2]
			local num = (current_health - var_203_6) / get_max_health

			if not (num <= 0) or not extension:has_buff_perk("ignore_death") then
				return
			end

			local var_203_8 = arg_203_2[3]
			local get_non_stacking_buff = extension:get_non_stacking_buff("deus_second_wind_cooldown")

			if not (not (num < health_threshold) or get_non_stacking_buff or var_203_8 == "life_tap") then
				local flag = not (num > 0) or not var_203_6 or current_health - 1

				DamageUtils.add_damage_network(arg_203_0, arg_203_0, flag, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_203_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)

				local buffs_to_add = template.buffs_to_add
				local system = Managers.state.entity:system("buff_system")

				for i = 1, #buffs_to_add do
					local var_203_13 = buffs_to_add[i]

					system:add_buff(arg_203_0, var_203_13, arg_203_0, false)
				end
			end
		end
	end,
	deus_guard_buff_on_damage = function (arg_204_0, arg_204_1, arg_204_2)
		-- function 204
		if not fn_4() then
			return
		end

		if not ALIVE[arg_204_0] then
			local attacker_unit = arg_204_1.attacker_unit
			local var_204_1 = arg_204_2[1]
			local var_204_2 = arg_204_2[2]
			local var_204_3 = arg_204_2[3]

			if not (arg_204_0 == attacker_unit or var_204_3 == "life_tap") then
				local extension = ScriptUnit.extension(attacker_unit, "buff_system")
				local apply_buffs_to_value = extension:apply_buffs_to_value(1, "damage_taken")

				if not extension:has_buff_type("deus_guard_buff") then
					apply_buffs_to_value = apply_buffs_to_value / -arg_204_1.template.multiplier
				end

				local num = var_204_2 * apply_buffs_to_value

				if num > 0 then
					DamageUtils.add_damage_network(attacker_unit, var_204_1, num, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_204_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end
			end
		end
	end,
	deus_cooldown_reg_not_hit_damage_taken = function (arg_205_0, arg_205_1, arg_205_2)
		-- function 205
		if not Managers.state.network.is_server then
			return
		end

		if arg_205_2[3] == arg_205_0 then
			return
		end

		arg_205_1.reset = true
	end,
	start_ledge_rescue_timer = function (arg_206_0, arg_206_1, arg_206_2)
		-- function 206
		local template = arg_206_1.template

		arg_206_1.rescue_timer = Managers.time:time("main") + template.rescue_delay
	end,
	start_disable_rescue_timer = function (arg_207_0, arg_207_1, arg_207_2)
		-- function 207
		local template = arg_207_1.template

		if not template.rescuable_disable_types[arg_207_2[1]] then
			arg_207_1.rescue_timer = Managers.time:time("main") + template.rescue_delay
		end
	end,
	play_particle_effect = function (arg_208_0, arg_208_1, arg_208_2)
		-- function 208
		local particle_fx = arg_208_1.template.particle_fx
		local main_world = Application.main_world()

		World.create_particles(main_world, particle_fx, POSITION_LOOKUP[arg_208_0])
	end,
	remove_linked_unit = function (arg_209_0, arg_209_1, arg_209_2)
		-- function 209
		if not arg_209_1.linked_unit then
			World.unlink_unit(Unit.world(arg_209_1.linked_unit), arg_209_1.linked_unit)
			Managers.state.unit_spawner:mark_for_deletion(arg_209_1.linked_unit)

			arg_209_1.linked_unit = nil
		end
	end,
	melee_wave_effect = function (arg_210_0, arg_210_1, arg_210_2)
		-- function 210
		if not fn_4() then
			return
		end

		if not ALIVE[arg_210_0] then
			return
		end

		local var_210_0 = arg_210_2[5]

		if not (var_210_0 == "MELEE_1H" or var_210_0 == "MELEE_2H") then
			return
		end

		if arg_210_2[4] ~= 1 then
			return
		end

		local server_buff_ids = arg_210_1.parent_buff_shared_table.server_buff_ids

		if not server_buff_ids then
			return
		end

		local var_210_2 = server_buff_ids[#server_buff_ids]

		if not var_210_2 then
			local var_210_3 = arg_210_2[1]
			local template = arg_210_1.template
			local get_template = ExplosionUtils.get_template(template.explosion_template)
			local world = Managers.world:world("level_world")
			local var_210_7 = POSITION_LOOKUP[var_210_3]
			local identity = Quaternion.identity()
			local get_career_power_level = ScriptUnit.has_extension(arg_210_0, "career_system"):get_career_power_level()

			DamageUtils.create_explosion(world, arg_210_0, var_210_7, identity, get_template, 1, "buff", fn_4(), fn_5(arg_210_0), arg_210_0, get_career_power_level, false)
			Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_210_0, var_210_2)

			server_buff_ids[#server_buff_ids] = nil
		end

		return true
	end,
	add_melee_wave_stacks = function (arg_211_0, arg_211_1, arg_211_2)
		-- function 211
		if not fn_4() then
			return
		end

		if arg_211_0 ~= arg_211_2[1] then
			return
		end

		if not ALIVE[arg_211_0] then
			local stacks_to_add = arg_211_1.template.stacks_to_add

			stacks_to_add = stacks_to_add or 1

			local buff_to_add = arg_211_1.template.buff_to_add
			local has_extension = ScriptUnit.has_extension(arg_211_0, "buff_system")
			local system = Managers.state.entity:system("buff_system")

			for i = 1, stacks_to_add do
				if has_extension:num_buff_type(buff_to_add) < BuffUtils.get_buff_template(buff_to_add).buffs[1].max_stacks then
					local add_buff = system:add_buff(arg_211_0, buff_to_add, arg_211_0, true)
					local parent_buff_shared_table = arg_211_1.parent_buff_shared_table
					local server_buff_ids = parent_buff_shared_table.server_buff_ids

					if not server_buff_ids then
						parent_buff_shared_table.server_buff_ids = {
							add_buff
						}
					else
						server_buff_ids[#server_buff_ids + 1] = add_buff
					end
				end
			end
		end
	end,
	career_ability_apply_dot_to_adjecent_enemies = function (arg_212_0, arg_212_1, arg_212_2)
		-- function 212
		assert(fn_4(), "'career_ability_apply_dot_to_adjecent_enemies' is a server only buff func")

		if arg_212_2[1] ~= arg_212_0 then
			return
		end

		local template = arg_212_1.template
		local params = arg_212_1.params

		params = params or {}
		arg_212_1.params = params
		arg_212_1.params.attacker_unit = arg_212_0

		local cached_broadphase = arg_212_1.cached_broadphase

		cached_broadphase = cached_broadphase or {}
		arg_212_1.cached_broadphase = cached_broadphase

		local var_212_3 = Managers.state.side.side_by_unit[arg_212_0]
		local broadphase_query = AiUtils.broadphase_query(POSITION_LOOKUP[arg_212_0], template.area_radius, arg_212_1.cached_broadphase, var_212_3.enemy_broadphase_categories)
		local str = "full"
		local str_2 = "buff"
		local var_212_7
		local var_212_8
		local var_212_9
		local var_212_10
		local var_212_11
		local var_212_12
		local cached_custom_dot = arg_212_1.cached_custom_dot

		cached_custom_dot = cached_custom_dot or {
			dot_template_name = template.dot_template_name
		}
		arg_212_1.cached_custom_dot = cached_custom_dot

		for i = 1, broadphase_query do
			local var_212_14 = arg_212_1.cached_broadphase[i]

			DamageUtils.apply_dot(var_212_7, var_212_8, var_212_9, var_212_14, arg_212_0, str, str_2, var_212_10, var_212_11, var_212_12, arg_212_0, arg_212_1.cached_custom_dot)
		end
	end,
	boon_dot_burning_01_spread = function (arg_213_0, arg_213_1, arg_213_2)
		-- function 213
		local var_213_0 = arg_213_2[3]

		if not Managers.state.status_effect:unit_is_burning(var_213_0) then
			return
		end

		local template = arg_213_1.template
		local cached_broadphase = arg_213_1.cached_broadphase

		cached_broadphase = cached_broadphase or {}
		arg_213_1.cached_broadphase = cached_broadphase

		local var_213_3 = Managers.state.side.side_by_unit[arg_213_0]
		local broadphase_query = AiUtils.broadphase_query(POSITION_LOOKUP[var_213_0], template.area_radius, arg_213_1.cached_broadphase, var_213_3.enemy_broadphase_categories)
		local str = "full"
		local str_2 = "buff"
		local var_213_7
		local var_213_8
		local var_213_9
		local var_213_10
		local var_213_11
		local var_213_12
		local cached_custom_dot = arg_213_1.cached_custom_dot

		cached_custom_dot = cached_custom_dot or {
			dot_template_name = template.dot_template_name
		}
		arg_213_1.cached_custom_dot = cached_custom_dot

		for i = 1, broadphase_query do
			local var_213_14 = arg_213_1.cached_broadphase[i]

			if var_213_14 ~= var_213_0 then
				DamageUtils.apply_dot(var_213_7, var_213_8, var_213_9, var_213_14, arg_213_0, str, str_2, var_213_10, var_213_11, var_213_12, arg_213_0, arg_213_1.cached_custom_dot)
			end
		end
	end,
	lightning_adjecent_enemies = function (arg_214_0, arg_214_1, arg_214_2)
		-- function 214
		local var_214_0 = arg_214_2[1]

		if not (not fn(arg_214_0) and not ALIVE[arg_214_0] and arg_214_0 == var_214_0) then
			return
		end

		local template = arg_214_1.template
		local alloc_table = FrameTable.alloc_table()
		local var_214_3 = Managers.state.side.side_by_unit[arg_214_0]
		local broadphase_query = AiUtils.broadphase_query(POSITION_LOOKUP[arg_214_0], template.area_radius, alloc_table, var_214_3.enemy_broadphase_categories)

		for i = 1, broadphase_query do
			local var_214_5 = alloc_table[i]
			local hit_zone = template.hit_zone

			if not hit_zone then
				hit_zone = arg_214_1.hit_zone_name
				hit_zone = hit_zone or "full"
			end

			local damage_source = template.damage_source

			damage_source = damage_source or "buff"

			local power_level = arg_214_1.power_level

			power_level = power_level or DefaultPowerLevel

			local damage_profile_name = template.damage_profile_name

			damage_profile_name = damage_profile_name or "default"

			local var_214_10 = DamageProfileTemplates[damage_profile_name]
			local var_214_11
			local flag = false
			local var_214_13
			local var_214_14
			local var_214_15

			if not var_214_10.targets then
				var_214_15 = var_214_10.targets[var_214_11]

				if not var_214_15 then
					-- Nothing
				end
			end

			var_214_15 = var_214_10.default_target

			::label_214_0::

			local damage_type = var_214_15.damage_type
			local var_214_17 = BoostCurves[var_214_15.boost_curve_type]
			local calculate_damage = DamageUtils.calculate_damage(DamageOutput, var_214_5, arg_214_0, hit_zone, power_level, var_214_17, var_214_14, flag, var_214_10, var_214_11, var_214_13, damage_source)

			DamageUtils.add_damage_network(var_214_5, arg_214_0, calculate_damage, "torso", damage_type, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)

			local system = Managers.state.entity:system("area_damage_system")
			local var_214_20 = POSITION_LOOKUP[var_214_5]
			local identity = Quaternion.identity()
			local explosion_template = template.explosion_template
			local num = 1

			system:create_explosion(arg_214_0, var_214_20, identity, explosion_template, num, damage_source, power_level, flag)

			local var_214_24 = NetworkLookup.effects[template.fx]
			local num_2 = POSITION_LOOKUP[arg_214_0] + 0.5 * Vector3.up()
			local var_214_26
			local has_node = Unit.has_node(var_214_5, "j_spine")

			has_node = not has_node and Unit.node(var_214_5, "j_spine")

			if not has_node then
				var_214_26 = Unit.world_position(var_214_5, has_node)
			else
				var_214_26 = POSITION_LOOKUP[var_214_5] + 0.5 * Vector3.up()
			end

			local distance = Vector3.distance(var_214_26, num_2)
			local var_214_29 = Vector3(1, distance, 0)
			local look = Quaternion.look(var_214_26 - num_2)

			if not fn_4() then
				Managers.state.network:rpc_play_particle_effect_with_variable(nil, var_214_24, num_2, look, "distance", var_214_29)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect_with_variable", var_214_24, num_2, look, "distance", var_214_29)
			end
		end

		if broadphase_query > 0 then
			local system_2 = Managers.state.entity:system("audio_system")
			local sound_event = template.sound_event

			system_2:play_audio_unit_event(sound_event, arg_214_0)
		end

		return true
	end,
	reduce_activated_ability_cooldown_on_block = function (arg_215_0, arg_215_1, arg_215_2)
		-- function 215
		if not ALIVE[arg_215_0] then
			ScriptUnit.extension(arg_215_0, "career_system"):reduce_activated_ability_cooldown(arg_215_1.bonus)
		end
	end,
	shield_splinters_explosion = function (arg_216_0, arg_216_1, arg_216_2)
		-- function 216
		local system = Managers.state.entity:system("area_damage_system")
		local var_216_1 = arg_216_2[1]
		local num = Unit.local_position(var_216_1, 0) + Vector3(0, 0, 1)
		local local_rotation = Unit.local_rotation(arg_216_0, 0)
		local explosion_template = arg_216_1.template.explosion_template
		local get_career_power_level = ScriptUnit.has_extension(arg_216_0, "career_system"):get_career_power_level()

		system:create_explosion(arg_216_0, num, local_rotation, explosion_template, 1, "undefined", get_career_power_level, false)
	end,
	home_run_sound = function (arg_217_0, arg_217_1, arg_217_2)
		-- function 217
		local template = arg_217_1.template
		local cooldown_over_at = arg_217_1.cooldown_over_at

		cooldown_over_at = cooldown_over_at or 0

		local time = Managers.time:time("main")

		if not (not ALIVE[arg_217_0] and not (cooldown_over_at <= time)) then
			arg_217_1.cooldown_over_at = time + template.cooldown

			local world = Managers.world:world("level_world")
			local sound_event = template.sound_event

			WwiseUtils.trigger_unit_event(world, sound_event, arg_217_0, 0)
		end
	end,
	detect_weakness_on_kill = function (arg_218_0, arg_218_1, arg_218_2)
		-- function 218
		local var_218_0 = arg_218_2[3]
		local extension = ScriptUnit.extension(var_218_0, "buff_system")

		if not extension then
			local mark_buff = arg_218_1.template.mark_buff

			if not extension:has_buff_type(mark_buff) then
				local system = Managers.state.entity:system("buff_system")
				local kill_buff = arg_218_1.template.kill_buff

				system:add_buff(arg_218_0, kill_buff, arg_218_0)
			end
		end
	end,
	remove_attach_particle = function (arg_219_0, arg_219_1, arg_219_2)
		-- function 219
		if not arg_219_1.fx_id then
			local main_world = Application.main_world()

			World.stop_spawning_particles(main_world, arg_219_1.fx_id)
		end
	end,
	pyrotechnical_echo_on_grenade_exploded = function (arg_220_0, arg_220_1, arg_220_2)
		-- function 220
		local queued_explosions = arg_220_1.queued_explosions

		queued_explosions = queued_explosions or {}
		arg_220_1.queued_explosions = queued_explosions

		local explosion_delay = arg_220_1.template.explosion_delay
		local time = Managers.time:time("main")
		local var_220_3 = arg_220_2[1]
		local var_220_4 = Vector3Box(arg_220_2[2])
		local var_220_5 = arg_220_2[3]
		local var_220_6 = arg_220_2[4]
		local var_220_7 = QuaternionBox(arg_220_2[5])
		local var_220_8 = arg_220_2[6]
		local var_220_9 = arg_220_2[7]
		local num = time + explosion_delay

		arg_220_1.queued_explosions[#arg_220_1.queued_explosions + 1] = {
			impact_data = var_220_3,
			hit_position = var_220_4,
			is_critical_strike = var_220_5,
			item_name = var_220_6,
			rotation = var_220_7,
			scale = var_220_8,
			power_level = var_220_9,
			new_explosion_time = num
		}

		return true
	end,
	blazing_revenge_on_knocked_down = function (arg_221_0, arg_221_1, arg_221_2, arg_221_3)
		-- function 221
		if not fn_4() then
			return
		end

		local template = arg_221_1.template
		local sound_start_event = template.sound_start_event

		Managers.state.entity:system("audio_system"):play_audio_unit_event(sound_start_event, arg_221_0)

		local var_221_2 = POSITION_LOOKUP[arg_221_0]
		local explosion_template = template.explosion_template
		local get_template = ExplosionUtils.get_template(explosion_template)
		local radius = get_template.aoe.radius
		local str = "buff"

		arg_221_1.parent_buff_shared_table.aoe_unit = DamageUtils.create_aoe(arg_221_3, arg_221_0, var_221_2, str, get_template, radius)
	end,
	blazing_revenge_clear_aoe = function (arg_222_0, arg_222_1, arg_222_2)
		-- function 222
		if not fn_4() then
			return
		end

		local sound_end_event = arg_222_1.template.sound_end_event

		Managers.state.entity:system("audio_system"):play_audio_unit_event(sound_end_event, arg_222_0)

		local aoe_unit = arg_222_1.parent_buff_shared_table.aoe_unit

		if not aoe_unit and not Unit.alive(aoe_unit) then
			Managers.state.unit_spawner:mark_for_deletion(aoe_unit)
		end
	end,
	cluster_barrel_on_barrel_exploded = function (arg_223_0, arg_223_1, arg_223_2)
		-- function 223
		if not fn_4() then
			return
		end

		local var_223_0 = arg_223_2[4]

		if not Unit.get_data(var_223_0, "is_cluster_barrel") then
			return
		end

		local template = arg_223_1.template
		local num = arg_223_2[1] + Vector3.up() * 0.1
		local explode_time = template.explode_time
		local random_explosion_delay = template.random_explosion_delay
		local item_name = template.item_name
		local fuse_time = template.fuse_time
		local barrel_count = template.barrel_count
		local max_horizontal_velocity = template.max_horizontal_velocity
		local vertical_velocity = template.vertical_velocity

		for i = 1, barrel_count do
			local var_223_10 = Vector3(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1)
			local look = Quaternion.look(var_223_10)
			local var_223_12 = Vector3(math.random() * max_horizontal_velocity * 2 - max_horizontal_velocity, math.random() * max_horizontal_velocity * 2 - max_horizontal_velocity, vertical_velocity)
			local var_223_13 = fn_10(item_name, num, look, var_223_12, explode_time, fuse_time, random_explosion_delay, arg_223_0)

			Unit.set_data(var_223_13, "is_cluster_barrel", true)
		end
	end,
	add_buffs_on_melee_headshot = function (arg_224_0, arg_224_1, arg_224_2)
		-- function 224
		if not Unit.alive(arg_224_0) then
			local var_224_0 = arg_224_2[3]
			local var_224_1 = arg_224_2[5]

			if not (not var_224_0 and var_224_0 == "head" and var_224_0 == "neck" and not var_224_1 and var_224_1 == "MELEE_1H" or var_224_1 ~= "MELEE_2H") then
				local template = arg_224_1.template
				local extension = ScriptUnit.extension(arg_224_0, "buff_system")
				local blocker_buff = template.blocker_buff

				if not blocker_buff and not extension:has_buff_type(blocker_buff) then
					return
				end

				local buffs_to_add = template.buffs_to_add

				for i = 1, #buffs_to_add do
					local var_224_6 = buffs_to_add[i]

					Managers.state.entity:system("buff_system"):add_buff(arg_224_0, var_224_6, arg_224_0)
				end
			end
		end
	end,
	invigorating_strike_on_damage_dealt = function (arg_225_0, arg_225_1, arg_225_2)
		-- function 225
		if not Managers.state.network.is_server then
			return
		end

		local var_225_0 = arg_225_2[3]
		local var_225_1 = arg_225_2[9]
		local var_225_2 = rawget(ItemMasterList, var_225_1)

		if not (not var_225_2 and var_225_2.slot_type == "melee" or var_225_2.slot_type ~= "ranged") then
			local has_extension = ScriptUnit.has_extension(arg_225_0, "buff_system")
			local template = arg_225_1.template
			local cooldown_buff = template.cooldown_buff

			if not (not has_extension and has_extension:get_non_stacking_buff(cooldown_buff)) then
				local num = var_225_0 * template.damage_to_heal_conversion_multiplier

				DamageUtils.heal_network(arg_225_0, arg_225_0, num, "heal_from_proc")
				Managers.state.entity:system("buff_system"):add_buff(arg_225_0, cooldown_buff, arg_225_0)
			end
		end
	end,
	staggering_force_on_stagger = function (arg_226_0, arg_226_1, arg_226_2)
		-- function 226
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_226_0] then
			local template = arg_226_1.template
			local enemy_count = template.enemy_count
			local var_226_2 = arg_226_2[8]

			if not (not var_226_2 and not (enemy_count <= var_226_2)) then
				local buff_to_add = template.buff_to_add

				Managers.state.entity:system("buff_system"):add_buff(arg_226_0, buff_to_add, arg_226_0)
			end
		end
	end,
	refilling_shot_on_critical_hit = function (arg_227_0, arg_227_1, arg_227_2)
		-- function 227
		if not (not fn(arg_227_0) and ALIVE[arg_227_0]) then
			return
		end

		local parent_buff_shared_table = arg_227_1.parent_buff_shared_table
		local ammo_used_extension = parent_buff_shared_table.ammo_used_extension

		if not ammo_used_extension and not ammo_used_extension then
			local ammo_used = parent_buff_shared_table.ammo_used

			ammo_used_extension:add_ammo_to_clip(ammo_used)
		end
	end,
	refilling_shot_on_start_action = function (arg_228_0, arg_228_1, arg_228_2)
		-- function 228
		if not (not fn(arg_228_0) and ALIVE[arg_228_0]) then
			return
		end

		local parent_buff_shared_table = arg_228_1.parent_buff_shared_table

		parent_buff_shared_table.ammo_used_extension = nil
		parent_buff_shared_table.ammo_used = nil
	end,
	refilling_shot_on_ammo_used = function (arg_229_0, arg_229_1, arg_229_2)
		-- function 229
		if not (not fn(arg_229_0) and ALIVE[arg_229_0]) then
			return
		end

		local parent_buff_shared_table = arg_229_1.parent_buff_shared_table

		parent_buff_shared_table.ammo_used_extension = arg_229_2[1]
		parent_buff_shared_table.ammo_used = arg_229_2[2]
	end,
	thorn_skin_effect = function (arg_230_0, arg_230_1, arg_230_2)
		-- function 230
		if not ALIVE[arg_230_0] then
			local template = arg_230_1.template
			local get_template = ExplosionUtils.get_template(template.explosion_template)
			local main_world = Application.main_world()
			local var_230_3 = POSITION_LOOKUP[arg_230_0]
			local identity = Quaternion.identity()
			local get_career_power_level = ScriptUnit.has_extension(arg_230_0, "career_system"):get_career_power_level()

			DamageUtils.create_explosion(main_world, arg_230_0, var_230_3, identity, get_template, 1, "buff", fn_4(), fn_5(arg_230_0), arg_230_0, get_career_power_level, false)
		end

		return true
	end,
	crescendo_strike_on_crit = function (arg_231_0, arg_231_1, arg_231_2)
		-- function 231
		if not ALIVE[arg_231_0] then
			local buff_to_add = arg_231_1.template.buff_to_add

			ScriptUnit.extension(arg_231_0, "buff_system"):add_buff(buff_to_add, {
				attacker_unit = arg_231_0
			})
		end
	end,
	lucky_on_crit = function (arg_232_0, arg_232_1, arg_232_2)
		-- function 232
		if not (not fn(arg_232_0) and ALIVE[arg_232_0]) then
			return
		end

		local extension = ScriptUnit.extension(arg_232_0, "buff_system")
		local parent_buff_shared_table = arg_232_1.parent_buff_shared_table
		local buff_ids = parent_buff_shared_table.buff_ids

		if not buff_ids then
			for i = 1, #buff_ids do
				local var_232_3 = buff_ids[i]

				extension:remove_buff(var_232_3)
			end

			table.clear(parent_buff_shared_table.buff_ids)
		end
	end,
	lucky_on_non_crit = function (arg_233_0, arg_233_1, arg_233_2)
		-- function 233
		if not (not fn(arg_233_0) and ALIVE[arg_233_0]) then
			return
		end

		local buff_to_add = arg_233_1.template.buff_to_add
		local add_buff = ScriptUnit.extension(arg_233_0, "buff_system"):add_buff(buff_to_add, {
			attacker_unit = arg_233_0
		})
		local parent_buff_shared_table = arg_233_1.parent_buff_shared_table
		local buff_ids = parent_buff_shared_table.buff_ids

		buff_ids = buff_ids or {}
		buff_ids[#buff_ids + 1] = add_buff
		parent_buff_shared_table.buff_ids = buff_ids
	end,
	hidden_escape_on_damage_taken = function (arg_234_0, arg_234_1, arg_234_2)
		-- function 234
		if not (not fn(arg_234_0) and ALIVE[arg_234_0]) then
			return
		end

		local extension = ScriptUnit.extension(arg_234_0, "buff_system")
		local template = arg_234_1.template

		if not template.invalid_damage_sources[arg_234_2[3]] then
			return
		end

		local cooldown_buff = template.cooldown_buff

		if not extension:get_buff_type(cooldown_buff) then
			local buff_to_add = template.buff_to_add

			if not ScriptUnit.extension(arg_234_0, "status_system"):is_invisible() then
				return
			end

			extension:add_buff(buff_to_add, {
				attacker_unit = arg_234_0
			})
		end
	end,
	hidden_escape_on_hit = function (arg_235_0, arg_235_1, arg_235_2)
		-- function 235
		if not (not fn(arg_235_0) and ALIVE[arg_235_0]) then
			return
		end

		ScriptUnit.extension(arg_235_0, "buff_system"):remove_buff(arg_235_1.id)
	end,
	curative_empowerment_on_healed_ally = function (arg_236_0, arg_236_1, arg_236_2)
		-- function 236
		local var_236_0 = arg_236_2[1]

		if not fn_4() then
			return
		end

		local var_236_1 = arg_236_2[3]
		local template = arg_236_1.template

		if var_236_1 ~= template.heal_type then
			return
		end

		local buff_to_add = template.buff_to_add
		local system = Managers.state.entity:system("buff_system")

		if not ALIVE[arg_236_0] then
			system:add_buff(arg_236_0, buff_to_add, arg_236_0)
		end

		if not ALIVE[var_236_0] then
			system:add_buff(var_236_0, buff_to_add, arg_236_0)
		end
	end,
	pent_up_anger_on_block = function (arg_237_0, arg_237_1, arg_237_2)
		-- function 237
		if not ALIVE[arg_237_0] then
			return
		end

		local extension = ScriptUnit.extension(arg_237_0, "buff_system")
		local template = arg_237_1.template
		local buff_to_add = template.buff_to_add
		local crit_buff = template.crit_buff

		if not extension:get_non_stacking_buff(crit_buff) then
			return false
		end

		extension:add_buff(buff_to_add, {
			attacker_unit = arg_237_0
		})

		return true
	end,
	surprise_strike_add_buff = function (arg_238_0, arg_238_1, arg_238_2)
		-- function 238
		if not (not fn(arg_238_0) and ALIVE[arg_238_0]) then
			return
		end

		local extension = ScriptUnit.extension(arg_238_0, "buff_system")
		local buff_to_add = arg_238_1.template.buff_to_add

		extension:add_buff(buff_to_add, {
			attacker_unit = arg_238_0
		})

		return true
	end,
	start_bad_breath_timer = function (arg_239_0, arg_239_1, arg_239_2)
		-- function 239
		if not fn_4() then
			return false
		end

		local template = arg_239_1.template
		local cooldown_buff = template.cooldown_buff

		if not ScriptUnit.extension(arg_239_0, "buff_system"):get_buff_type(cooldown_buff) then
			return false
		end

		if not template.rescuable_disable_types[arg_239_2[1]] then
			arg_239_1.disabler, arg_239_1.rescue_timer = arg_239_2[2], Managers.time:time("main") + template.rescue_delay

			return true
		end
	end,
	start_boulder_bro_timer = function (arg_240_0, arg_240_1, arg_240_2)
		-- function 240
		local template = arg_240_1.template

		arg_240_1.rescue_timer = Managers.time:time("main") + template.rescue_delay

		return false
	end,
	static_blade_on_timed_block = function (arg_241_0, arg_241_1, arg_241_2)
		-- function 241
		if not (not fn(arg_241_0) and ALIVE[arg_241_0]) then
			return
		end

		local template = arg_241_1.template
		local cooldown_buff = template.cooldown_buff
		local extension = ScriptUnit.extension(arg_241_0, "buff_system")

		if not extension:get_buff_type(cooldown_buff) then
			return false
		end

		local var_241_3 = arg_241_2[1]
		local hit_zone = template.hit_zone

		if not hit_zone then
			hit_zone = arg_241_1.hit_zone_name
			hit_zone = hit_zone or "full"
		end

		local damage_source = template.damage_source

		damage_source = damage_source or "buff"

		local power_level = arg_241_1.power_level

		power_level = power_level or DefaultPowerLevel

		local damage_profile_name = template.damage_profile_name

		damage_profile_name = damage_profile_name or "default"

		local var_241_8 = DamageProfileTemplates[damage_profile_name]
		local var_241_9
		local flag = false
		local var_241_11
		local var_241_12
		local var_241_13

		if not var_241_8.targets then
			var_241_13 = var_241_8.targets[var_241_9]

			if not var_241_13 then
				-- Nothing
			end
		end

		var_241_13 = var_241_8.default_target

		::label_241_0::

		local damage_type = var_241_13.damage_type
		local var_241_15 = BoostCurves[var_241_13.boost_curve_type]
		local calculate_damage = DamageUtils.calculate_damage(DamageOutput, var_241_3, arg_241_0, hit_zone, power_level, var_241_15, var_241_12, flag, var_241_8, var_241_9, var_241_11, damage_source)

		DamageUtils.add_damage_network(var_241_3, arg_241_0, calculate_damage, "torso", damage_type, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)

		local system = Managers.state.entity:system("area_damage_system")
		local var_241_18 = POSITION_LOOKUP[var_241_3]
		local identity = Quaternion.identity()
		local explosion_template = template.explosion_template
		local num = 1

		system:create_explosion(arg_241_0, var_241_18, identity, explosion_template, num, damage_source, power_level, flag)

		local var_241_22 = NetworkLookup.effects["fx/cw_chain_lightning"]
		local num_2 = POSITION_LOOKUP[arg_241_0] + 0.5 * Vector3.up()
		local var_241_24
		local has_node = Unit.has_node(var_241_3, "j_spine")

		has_node = not has_node and Unit.node(var_241_3, "j_spine")

		if not has_node then
			var_241_24 = Unit.world_position(var_241_3, has_node)
		else
			var_241_24 = POSITION_LOOKUP[var_241_3] + 0.5 * Vector3.up()
		end

		local distance = Vector3.distance(var_241_24, num_2)
		local var_241_27 = Vector3(1, distance, 0)
		local look = Quaternion.look(var_241_24 - num_2)

		if not fn_4() then
			Managers.state.network:rpc_play_particle_effect_with_variable(nil, var_241_22, num_2, look, "distance", var_241_27)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect_with_variable", var_241_22, num_2, look, "distance", var_241_27)
		end

		local system_2 = Managers.state.entity:system("audio_system")
		local sound_event = template.sound_event

		system_2:play_audio_unit_event(sound_event, var_241_3)
		extension:add_buff(cooldown_buff, {
			attacker_unit = arg_241_0
		})

		return true
	end,
	spawn_orb = function (arg_242_0, arg_242_1, arg_242_2)
		-- function 242
		if not fn_4() then
			if not ALIVE[arg_242_0] then
				return
			end

			local var_242_0 = arg_242_2[3]
			local num = POSITION_LOOKUP[var_242_0] + Vector3(0, 0, 1)
			local var_242_2 = POSITION_LOOKUP[arg_242_0]
			local normalize = Vector3.normalize(num - var_242_2)
			local pi = math.pi
			local orb_name = arg_242_1.template.orb_settings.orb_name
			local peer_id = Managers.player:owner(arg_242_0).peer_id

			Managers.state.entity:system("orb_system"):spawn_orb(orb_name, peer_id, num, normalize, pi)
		end
	end,
	on_damage_taken_health_orbs = function (arg_243_0, arg_243_1, arg_243_2)
		-- function 243
		if not fn_4() then
			return
		end

		if not ALIVE[arg_243_0] then
			local template = arg_243_1.template

			if not ScriptUnit.extension(arg_243_0, "status_system"):is_disabled() then
				return
			end

			local var_243_1 = arg_243_2[2]
			local leftover_health = arg_243_1.leftover_health

			leftover_health = leftover_health or 0

			local num = var_243_1 + leftover_health
			local num_2 = num / template.health_per_orb
			local floor = math.floor(num_2)

			arg_243_1.leftover_health = math.fmod(num, template.health_per_orb)

			local orb_name = arg_243_1.template.orb_settings.orb_name
			local peer_id = Managers.player:owner(arg_243_0).peer_id
			local num_3 = POSITION_LOOKUP[arg_243_0] + Vector3(0, 0, 1)
			local var_243_9 = Vector3(0, 0, 1)
			local num_4 = 2 * math.pi
			local system = Managers.state.entity:system("orb_system")

			for i = 1, floor do
				system:spawn_orb(orb_name, peer_id, num_3, var_243_9, num_4)
			end
		end
	end,
	on_kill_static_charge = function (arg_244_0, arg_244_1, arg_244_2)
		-- function 244
		if not fn_4() then
			return
		end

		if not ALIVE[arg_244_0] then
			local template = arg_244_1.template

			if not ScriptUnit.extension(arg_244_0, "status_system"):is_disabled() then
				return
			end

			local kill_count = arg_244_1.kill_count

			kill_count = kill_count or 0
			arg_244_1.kill_count = kill_count + 1

			if arg_244_1.kill_count >= template.kills_per_orb then
				arg_244_1.kill_count = 0

				local num = POSITION_LOOKUP[arg_244_0] + Vector3(0, 0, 1)
				local orb_name = arg_244_1.template.orb_settings.orb_name
				local peer_id = Managers.player:owner(arg_244_0).peer_id
				local var_244_5 = Vector3(0, 0, 1)
				local num_2 = 2 * math.pi

				Managers.state.entity:system("orb_system"):spawn_orb(orb_name, peer_id, num, var_244_5, num_2)
			end
		end
	end,
	on_potion_consumed_sharing_is_caring = function (arg_245_0, arg_245_1, arg_245_2)
		-- function 245
		if not ALIVE[arg_245_0] then
			local var_245_0 = arg_245_2[1]
			local str = ItemMasterList[var_245_0].temporary_template .. "_orb"

			if not AllPickups[str] then
				local num = POSITION_LOOKUP[arg_245_0] + Vector3(0, 0, 1)
				local peer_id = Managers.player:owner(arg_245_0).peer_id
				local var_245_4 = Vector3(0, 0, 1)
				local num_2 = 2 * math.pi

				if not fn_4() then
					Managers.state.entity:system("orb_system"):spawn_orb(str, peer_id, num, var_245_4, num_2)
				else
					local network = Managers.state.network
					local var_245_7 = NetworkLookup.pickup_names[str]

					network.network_transmit:send_rpc_server("rpc_spawn_orb", var_245_7, peer_id, num, var_245_4, num_2)
				end
			end
		end
	end,
	on_timed_block_protection_orbs = function (arg_246_0, arg_246_1, arg_246_2)
		-- function 246
		local time = Managers.time:time("main")

		if not (not arg_246_1.cooldown_end_t and not (time < arg_246_1.cooldown_end_t)) then
			return
		end

		if not ALIVE[arg_246_0] then
			if not ScriptUnit.extension(arg_246_0, "status_system"):is_disabled() then
				return
			end

			local num = POSITION_LOOKUP[arg_246_0] + Vector3(0, 0, 1)
			local orb_name = arg_246_1.template.orb_settings.orb_name
			local peer_id = Managers.player:owner(arg_246_0).peer_id
			local var_246_4 = Vector3(0, 0, 1)
			local num_2 = 2 * math.pi

			if not fn_4() then
				Managers.state.entity:system("orb_system"):spawn_orb(orb_name, peer_id, num, var_246_4, num_2)
			else
				local network = Managers.state.network
				local var_246_7 = NetworkLookup.pickup_names[orb_name]

				network.network_transmit:send_rpc_server("rpc_spawn_orb", var_246_7, peer_id, num, var_246_4, num_2)
			end

			arg_246_1.cooldown_end_t = time + arg_246_1.template.cooldown
		end
	end,
	focused_accuracy_on_hit = function (arg_247_0, arg_247_1, arg_247_2)
		-- function 247
		if not ALIVE[arg_247_0] then
			return
		end

		local cooldown_buff = arg_247_1.template.cooldown_buff

		if not ScriptUnit.extension(arg_247_0, "buff_system"):get_buff_type(cooldown_buff) then
			return
		end

		local var_247_1 = arg_247_2[3]

		if not (not var_247_1 and var_247_1 == "head" or var_247_1 ~= "neck") then
			Managers.state.entity:system("buff_system"):add_buff(arg_247_0, cooldown_buff, arg_247_0)

			local orb_name = arg_247_1.template.orb_settings.orb_name
			local var_247_3 = arg_247_2[1]
			local num = POSITION_LOOKUP[var_247_3] + Vector3(0, 0, 1)
			local peer_id = Managers.player:owner(arg_247_0).peer_id
			local var_247_6 = Vector3(0, 0, 1)
			local num_2 = 2 * math.pi

			if not fn_4() then
				Managers.state.entity:system("orb_system"):spawn_orb(orb_name, peer_id, num, var_247_6, num_2)
			else
				local network = Managers.state.network
				local var_247_9 = NetworkLookup.pickup_names[orb_name]

				network.network_transmit:send_rpc_server("rpc_spawn_orb", var_247_9, peer_id, num, var_247_6, num_2)
			end
		end
	end,
	deus_ranged_crit_explosion_on_damage_dealt = function (arg_248_0, arg_248_1, arg_248_2, arg_248_3)
		-- function 248
		local template = arg_248_1.template
		local var_248_1 = arg_248_2[2]
		local valid_attack_types = template.valid_attack_types

		if not (not valid_attack_types and valid_attack_types[var_248_1]) then
			return
		end

		local cooldown_buff = arg_248_1.template.cooldown_buff

		if not ScriptUnit.extension(arg_248_0, "buff_system"):get_buff_type(cooldown_buff) then
			return
		end

		local var_248_4 = arg_248_2[1]
		local var_248_5 = arg_248_2[6]
		local var_248_6 = arg_248_2[4]

		if not ALIVE[arg_248_0] and not ALIVE[var_248_4] and var_248_6 ~= 1 or not var_248_5 then
			local has_extension = ScriptUnit.has_extension(arg_248_0, "career_system")
			local system = Managers.state.entity:system("area_damage_system")
			local var_248_9 = POSITION_LOOKUP[var_248_4]
			local str = "buff"
			local explosion_template = template.explosion_template
			local identity = Quaternion.identity()
			local num = has_extension:get_career_power_level() * template.power_scale
			local num_2 = 1
			local flag = false

			system:create_explosion(arg_248_0, var_248_9, identity, explosion_template, num_2, str, num, flag)

			local system_2 = Managers.state.entity:system("audio_system")
			local sound_event = template.sound_event

			system_2:play_audio_unit_event(sound_event, var_248_4)
			Managers.state.entity:system("buff_system"):add_buff(arg_248_0, cooldown_buff, arg_248_0)
		end
	end,
	resolve_on_revived = function (arg_249_0, arg_249_1, arg_249_2)
		-- function 249
		local extension = ScriptUnit.extension(arg_249_0, "buff_system")
		local template = arg_249_1.template
		local cooldown_buff = template.cooldown_buff
		local full_heal_buff = template.full_heal_buff

		if not extension:get_buff_type(full_heal_buff) then
			extension:add_buff(cooldown_buff)

			arg_249_1.after_revive_t = Managers.time:time("game") + 3
		end
	end,
	squats_add_buff = function (arg_250_0, arg_250_1, arg_250_2)
		-- function 250
		if not (not fn(arg_250_0) and ALIVE[arg_250_0]) then
			return
		end

		local template = arg_250_1.template
		local build_up_buff = template.build_up_buff
		local actual_buff = template.actual_buff
		local extension = ScriptUnit.extension(arg_250_0, "buff_system")

		if not extension:get_buff_type(actual_buff) then
			return
		end

		local system = Managers.state.entity:system("buff_system")

		system:add_buff(arg_250_0, build_up_buff, arg_250_0)

		if extension:num_buff_stacks(build_up_buff) >= template.stack_count_to_trigger_actual_buff then
			while true do
				local get_buff_type = extension:get_buff_type(build_up_buff)

				if not get_buff_type then
					break
				end

				extension:remove_buff(get_buff_type.id)
			end

			system:add_buff(arg_250_0, actual_buff, arg_250_0)
		end
	end,
	boon_skulls_01_on_hit = function (arg_251_0, arg_251_1, arg_251_2)
		-- function 251
		local extension = ScriptUnit.extension(arg_251_0, "buff_system")

		if not extension:get_buff_type("boon_skulls_01_surge") then
			return
		end

		extension:add_buff(arg_251_1.template.buff_to_add)
	end,
	boon_skulls_02_on_kill = function (arg_252_0, arg_252_1, arg_252_2)
		-- function 252
		if not ScriptUnit.extension(arg_252_0, "buff_system"):get_buff_type("boon_skulls_02_surge") then
			return
		end

		Managers.state.entity:system("buff_system"):add_buff_synced(arg_252_0, arg_252_1.template.buff_to_add, BuffSyncType.LocalAndServer)
	end,
	boon_skulls_03_on_parry = function (arg_253_0, arg_253_1, arg_253_2)
		-- function 253
		local extension = ScriptUnit.extension(arg_253_0, "buff_system")

		if extension:num_buff_stacks("boon_skulls_03_cooldown") > 0 then
			return
		end

		local var_253_1 = POSITION_LOOKUP[arg_253_0]
		local explosion_template_name = arg_253_1.template.explosion_template_name
		local var_253_3 = ExplosionTemplates[explosion_template_name]
		local has_extension = ScriptUnit.has_extension(arg_253_0, "career_system")
		local get_career_power_level

		if not has_extension then
			get_career_power_level = has_extension:get_career_power_level()

			if not get_career_power_level then
				-- Nothing
			end
		end

		get_career_power_level = DefaultPowerLevel

		::label_253_0::

		local num = 1
		local str = "buff"
		local identity = Quaternion.identity()

		if not fn_4() then
			DamageUtils.create_explosion(Unit.world(arg_253_0), arg_253_0, var_253_1, identity, var_253_3, num, str, false, true, arg_253_0, get_career_power_level, false, arg_253_0)
		end

		local unit_game_object_id = Managers.state.network:unit_game_object_id(arg_253_0)
		local var_253_10 = NetworkLookup.explosion_templates[explosion_template_name]
		local var_253_11 = NetworkLookup.damage_sources[str]

		Managers.state.network.network_transmit:send_rpc_server("rpc_create_explosion", unit_game_object_id, false, var_253_1, identity, var_253_10, num, var_253_11, get_career_power_level, false, unit_game_object_id)
		extension:add_buff("boon_skulls_03_cooldown")
	end,
	boon_skulls_04_on_hit = function (arg_254_0, arg_254_1, arg_254_2)
		-- function 254
		local owner = Managers.player:owner(arg_254_0)

		if not (not owner and owner:network_id() == Network.peer_id()) then
			return
		end

		local var_254_1 = arg_254_2[4]
		local flag = arg_254_2[2] == "light_attack" or arg_254_2[2] == "heavy_attack"

		if not (var_254_1 > 1 or flag) then
			return
		end

		local extension = ScriptUnit.extension(arg_254_0, "health_system")
		local current_temporary_health = extension:current_temporary_health()

		if current_temporary_health <= 0 then
			return
		end

		local extension_2 = ScriptUnit.extension(arg_254_0, "buff_system")

		if not extension_2:get_buff_type("boon_skulls_04_regen") then
			return
		end

		local min = math.min(current_temporary_health, MorrisBuffTweakData.boon_skulls_04_data.thp_on_hit)
		local current_health = extension:current_health()
		local clamp = math.clamp(min, 0, math.max(current_health - 0.25, 0))
		local floor = math.floor(DamageUtils.networkify_damage(clamp))
		local num_buff_stacks = extension_2:num_buff_stacks("boon_skulls_04_stack")

		if num_buff_stacks + floor >= MorrisBuffTweakData.boon_skulls_04_data.total_thp_to_consume then
			floor = MorrisBuffTweakData.boon_skulls_04_data.total_thp_to_consume - num_buff_stacks

			local get_stacking_buff = extension_2:get_stacking_buff("boon_skulls_04_stack")

			for i = num_buff_stacks, 1, -1 do
				extension_2:remove_buff(get_stacking_buff[i].id)
			end

			extension_2:add_buff("boon_skulls_04_regen")
		else
			for j = 1, floor do
				extension_2:add_buff("boon_skulls_04_stack")
			end
		end

		if floor > 0 then
			DamageUtils.add_damage_network(arg_254_0, arg_254_0, floor, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_254_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	boon_skulls_05_on_hit = function (arg_255_0, arg_255_1, arg_255_2)
		-- function 255
		local owner = Managers.player:owner(arg_255_0)

		if not (not owner and owner:network_id() == Network.peer_id()) then
			return
		end

		local var_255_1 = arg_255_2[4]
		local flag = arg_255_2[2] == "heavy_attack"

		if not (var_255_1 > 1 or flag) then
			return
		end

		if not ScriptUnit.extension(arg_255_0, "buff_system"):get_buff_type("boon_skulls_05_surge") then
			return
		end

		Managers.state.entity:system("buff_system"):add_buff_synced(arg_255_0, arg_255_1.template.buff_to_add, BuffSyncType.LocalAndServer)
	end,
	boon_skulls_07_on_skull_picked_up = function (arg_256_0, arg_256_1, arg_256_2)
		-- function 256
		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local num = 1

		for k, v in pairs(Managers.player:human_players()) do
			local get_player_power_ups = get_deus_run_controller:get_player_power_ups(v:network_id(), v:local_player_id())

			if not table.find_func(get_player_power_ups, function (arg_257_0, arg_257_1)
				-- function 257
				return arg_257_1.name == "boon_skulls_set_bonus_02"
			end) then
				num = num + MorrisBuffTweakData.boon_skulls_set_bonus_02.effect_amplify_amount
			end
		end

		local game_mode = Managers.state.game_mode:game_mode()

		if not game_mode.on_picked_up_soft_currency then
			local var_256_4 = arg_256_2[2]
			local num_2 = arg_256_1.template.coins_to_gain * num

			game_mode:on_picked_up_soft_currency(var_256_4, arg_256_0, num_2, DeusSoftCurrencySettings.types.GROUND)
		end

		local local_player = Managers.player:local_player()

		Managers.state.event:trigger("player_pickup_deus_soft_currency", local_player)
	end,
	boon_skulls_08_on_skull_picked_up = function (arg_258_0, arg_258_1, arg_258_2)
		-- function 258
		local var_258_0 = arg_258_2[1]
		local local_player = Managers.player:local_player()

		if var_258_0 == (not local_player and local_player.player_unit) then
			local cooldown_to_reduce = arg_258_1.template.cooldown_to_reduce

			if not (ScriptUnit.extension(arg_258_0, "buff_system"):num_buff_stacks("power_up_boon_skulls_set_bonus_02_event") > 0) then
				cooldown_to_reduce = cooldown_to_reduce * (1 + MorrisBuffTweakData.boon_skulls_set_bonus_02.effect_amplify_amount)
			end

			ScriptUnit.extension(arg_258_0, "career_system"):reduce_activated_ability_cooldown_percent(cooldown_to_reduce, 1, true)
		end
	end,
	teammates_extra_damage_aura_reduce_own_damage = function (arg_259_0, arg_259_1, arg_259_2)
		-- function 259
		local var_259_0 = arg_259_2[1]
		local has_extension = ScriptUnit.has_extension(var_259_0, "buff_system")
		local flag = false
		local flag_2 = not has_extension and has_extension:get_stacking_buff("deus_extra_damage_aura_debuff")

		if not flag_2 then
			for i = 1, #flag_2 do
				if flag_2[i].attacker_unit == arg_259_0 then
					flag = true

					break
				end
			end
		end

		if not flag then
			return
		end

		local add_buff, var_259_5, var_259_6 = ScriptUnit.extension(arg_259_0, "buff_system"):add_buff("teammates_extra_damage_counteract_buff")

		var_259_6.source_buff_id = arg_259_1.id
	end,
	teammates_extra_damage_aura_revert_own_damage = function (arg_260_0, arg_260_1, arg_260_2)
		-- function 260
		local extension = ScriptUnit.extension(arg_260_0, "buff_system")
		local get_stacking_buff = extension:get_stacking_buff("teammates_extra_damage_counteract_buff")

		if not get_stacking_buff then
			local id = arg_260_1.id

			for i = #get_stacking_buff, 1, -1 do
				if get_stacking_buff[i].source_buff_id == id then
					extension:remove_buff(get_stacking_buff[i].id)

					return
				end
			end
		end
	end,
	teammates_extra_stagger_aura_reduce_own_stagger = function (arg_261_0, arg_261_1, arg_261_2)
		-- function 261
		local var_261_0 = arg_261_2[1]
		local has_extension = ScriptUnit.has_extension(var_261_0, "buff_system")
		local flag = false
		local flag_2 = not has_extension and has_extension:get_stacking_buff("deus_extra_stagger_aura_debuff")

		if not flag_2 then
			for i = 1, #flag_2 do
				if flag_2[i].attacker_unit == arg_261_0 then
					flag = true

					break
				end
			end
		end

		if not flag then
			return
		end

		local add_buff, var_261_5, var_261_6 = ScriptUnit.extension(arg_261_0, "buff_system"):add_buff("teammates_extra_stagger_counteract_buff")

		var_261_6.source_buff_id = arg_261_1.id
	end,
	teammates_extra_stagger_aura_revert_own_stagger = function (arg_262_0, arg_262_1, arg_262_2)
		-- function 262
		local extension = ScriptUnit.extension(arg_262_0, "buff_system")
		local get_stacking_buff = extension:get_stacking_buff("teammates_extra_stagger_counteract_buff")

		if not get_stacking_buff then
			local id = arg_262_1.id

			for i = #get_stacking_buff, 1, -1 do
				if get_stacking_buff[i].source_buff_id == id then
					extension:remove_buff(get_stacking_buff[i].id)

					return
				end
			end
		end
	end,
	extra_stagger_near_teammates_check = function (arg_263_0, arg_263_1, arg_263_2)
		-- function 263
		local var_263_0 = arg_263_2[1]
		local local_position = Unit.local_position(var_263_0, 1)
		local distance_from_allies = arg_263_1.template.distance_from_allies
		local num = distance_from_allies * distance_from_allies
		local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_263_0].PLAYER_AND_BOT_UNITS

		for i = 1, #PLAYER_AND_BOT_UNITS do
			local var_263_5 = PLAYER_AND_BOT_UNITS[i]

			if var_263_5 ~= arg_263_0 then
				local var_263_6 = POSITION_LOOKUP[var_263_5]

				if not (not var_263_6 and not (num >= Vector3.distance_squared(local_position, var_263_6))) then
					ScriptUnit.extension(arg_263_0, "buff_system"):add_buff("boon_teamaura_02_stagger_buff")

					break
				end
			end
		end
	end,
	extra_stagger_near_teammates_cleanup = function (arg_264_0, arg_264_1, arg_264_2)
		-- function 264
		local extension = ScriptUnit.extension(arg_264_0, "buff_system")
		local get_stacking_buff = extension:get_stacking_buff("boon_teamaura_02_stagger_buff")

		if not (not get_stacking_buff and not (#get_stacking_buff > 0)) then
			extension:remove_buff(get_stacking_buff[1].id)
		end
	end,
	extra_damage_near_teammates_check = function (arg_265_0, arg_265_1, arg_265_2)
		-- function 265
		local var_265_0 = arg_265_2[1]
		local local_position = Unit.local_position(var_265_0, 1)
		local distance_from_allies = arg_265_1.template.distance_from_allies
		local num = distance_from_allies * distance_from_allies
		local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_265_0].PLAYER_AND_BOT_UNITS

		for i = 1, #PLAYER_AND_BOT_UNITS do
			local var_265_5 = PLAYER_AND_BOT_UNITS[i]

			if var_265_5 ~= arg_265_0 then
				local var_265_6 = POSITION_LOOKUP[var_265_5]

				if not (not var_265_6 and not (num >= Vector3.distance_squared(local_position, var_265_6))) then
					ScriptUnit.extension(arg_265_0, "buff_system"):add_buff("boon_teamaura_01_damage_buff")

					break
				end
			end
		end
	end,
	extra_damage_near_teammates_cleanup = function (arg_266_0, arg_266_1, arg_266_2)
		-- function 266
		local extension = ScriptUnit.extension(arg_266_0, "buff_system")
		local get_stacking_buff = extension:get_stacking_buff("boon_teamaura_01_damage_buff")

		if not (not get_stacking_buff and not (#get_stacking_buff > 0)) then
			extension:remove_buff(get_stacking_buff[1].id)
		end
	end,
	boon_meta_01_boon_granted = function (arg_267_0, arg_267_1, arg_267_2)
		-- function 267
		local owner = Managers.player:owner(arg_267_0)

		if not owner then
			return
		end

		local extension = ScriptUnit.extension(arg_267_0, "buff_system")
		local num_buff_stacks = extension:num_buff_stacks("boon_meta_01_stack")
		local count = #Managers.mechanism:game_mechanism():get_deus_run_controller():get_player_power_ups(owner:network_id(), owner:local_player_id())

		for i = num_buff_stacks + 1, count do
			extension:add_buff("boon_meta_01_stack")
		end

		local get_stacking_buff = extension:get_stacking_buff("boon_meta_01_stack")

		for j = num_buff_stacks, count + 1, -1 do
			local var_267_5 = get_stacking_buff[j]

			extension:remove_buff(var_267_5.id)
		end
	end,
	boon_weaponrarity_02_weapon_wielded = function (arg_268_0, arg_268_1, arg_268_2)
		-- function 268
		local extension = ScriptUnit.extension(arg_268_0, "career_system")
		local extension_2 = ScriptUnit.extension(arg_268_0, "inventory_system")
		local career_name = extension:career_name()
		local get_wielded_slot_name = extension_2:get_wielded_slot_name()
		local extension_3 = ScriptUnit.extension(arg_268_0, "buff_system")
		local num_buff_stacks = extension_3:num_buff_stacks("boon_weaponrarity_02_debuff")
		local unique = ORDER_RARITY.unique

		if not (get_wielded_slot_name == "slot_melee" or get_wielded_slot_name ~= "slot_ranged") then
			local get_interface = Managers.backend:get_interface("deus")
			local get_loadout_item_id = get_interface:get_loadout_item_id(career_name, get_wielded_slot_name)
			local get_loadout_item = get_interface:get_loadout_item(get_loadout_item_id)

			if not get_loadout_item then
				return
			end

			local rarity = get_loadout_item.rarity

			unique = ORDER_RARITY[rarity] or ORDER_RARITY.unique
		end

		for i = num_buff_stacks, unique - 2 do
			extension_3:add_buff("boon_weaponrarity_02_debuff")
		end

		local get_stacking_buff = extension_3:get_stacking_buff("boon_weaponrarity_02_debuff")

		for j = num_buff_stacks, unique, -1 do
			local var_268_12 = get_stacking_buff[#get_stacking_buff]

			extension_3:remove_buff(var_268_12.id)
		end
	end,
	boon_weaponrarity_01_weapon_wielded = function (arg_269_0, arg_269_1, arg_269_2)
		-- function 269
		local career_name = ScriptUnit.extension(arg_269_0, "career_system"):career_name()
		local get_interface = Managers.backend:get_interface("deus")
		local get_loadout_item_id = get_interface:get_loadout_item_id(career_name, "slot_melee")
		local get_loadout_item = get_interface:get_loadout_item(get_loadout_item_id)
		local var_269_4 = ORDER_RARITY[not get_loadout_item and get_loadout_item.rarity]

		var_269_4 = var_269_4 or 1

		local get_loadout_item_id_2 = get_interface:get_loadout_item_id(career_name, "slot_ranged")
		local get_loadout_item_2 = get_interface:get_loadout_item(get_loadout_item_id_2)
		local var_269_7 = ORDER_RARITY[not get_loadout_item_2 and get_loadout_item_2.rarity]

		var_269_7 = var_269_7 or 1

		local max = math.max(var_269_4, var_269_7)
		local extension = ScriptUnit.extension(arg_269_0, "buff_system")
		local num_buff_stacks = extension:num_buff_stacks("boon_weaponrarity_01_debuff")

		for i = num_buff_stacks, max - 2 do
			extension:add_buff("boon_weaponrarity_01_debuff")
		end

		local get_stacking_buff = extension:get_stacking_buff("boon_weaponrarity_01_debuff")

		for j = num_buff_stacks, max, -1 do
			local var_269_12 = get_stacking_buff[#get_stacking_buff]

			extension:remove_buff(var_269_12.id)
		end
	end
}
morris.explosion_templates = {
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
			radius_max = 3.5,
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
morris.buff_templates = {
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.disable_interactions,
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.free_grenade,
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.rewield_grenade_on_throw
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.disable_interactions,
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.free_grenade,
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.rewield_grenade_on_throw
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.poison_proof
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.poison_proof
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.bleeding
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.bleeding
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.slayer_curse
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.temp_to_permanent_health
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.ignore_death
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.shared_health_pool_damage_only
				}
			}
		}
	},
	we_deus_01_kerillian_critical_bleed_dot_disable = {
		buffs = {
			{
				name = "we_deus_01_kerillian_critical_bleed_dot_disable",
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.kerillian_critical_bleed_dot_disable
				}
			}
		}
	},
	wh_deus_01_victor_witchhunter_bleed_on_critical_hit_disable = {
		buffs = {
			{
				name = "wh_deus_01_victor_witchhunter_bleed_on_critical_hit_disable",
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.victor_witchhunter_bleed_on_critical_hit_disable
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning_elven_magic
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning_elven_magic
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning_elven_magic
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning_elven_magic
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.ledge_self_rescue
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.guaranteed_crit
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.guaranteed_crit
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.guaranteed_crit
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.guaranteed_crit
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.ledge_self_rescue
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.generic_melee_bleed
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.full_health_revive
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

table.merge_recursive(morris.buff_templates, DeusPowerUpBuffTemplates)
