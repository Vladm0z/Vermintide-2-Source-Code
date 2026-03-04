-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/liquid_area_damage_extension.lua

require("scripts/unit_extensions/weapons/area_damage/liquid/hex_grid")
require("scripts/managers/debug/debug_manager")

LiquidAreaDamageExtension = class(LiquidAreaDamageExtension)

local function var_0_0(...)
	if script_data.debug_liquid_system then
		print("[LiquidSystem]:", ...)
	end
end

function LiquidAreaDamageExtension.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_1.entity_manager
	local var_2_1 = var_2_0:system("ai_system")
	local var_2_2 = arg_2_1.world

	arg_2_0._world = var_2_2
	arg_2_0._unit = arg_2_2
	arg_2_0._network_transmit = arg_2_1.network_transmit
	arg_2_0._ai_system = var_2_1
	arg_2_0._nav_world = var_2_1:nav_world()
	arg_2_0._audio_system = var_2_0:system("audio_system")

	local var_2_3 = arg_2_3.liquid_template
	local var_2_4 = LiquidAreaDamageTemplates.templates[var_2_3]

	arg_2_0._liquid_area_damage_template = var_2_3

	local var_2_5 = Unit.world_position(arg_2_2, 0)
	local var_2_6 = var_2_4.above
	local var_2_7 = var_2_4.below
	local var_2_8 = arg_2_0:_find_point(var_2_5, var_2_6, var_2_7) or var_2_5
	local var_2_9 = var_2_4.cell_size
	local var_2_10 = arg_2_3.max_liquid or var_2_4.max_liquid or 50
	local var_2_11 = math.min(var_2_10 + 10, 50)

	arg_2_0._grid = HexGrid:new(var_2_8, var_2_11, 10, var_2_9, 1)

	local var_2_12 = Managers.time:time("game")
	local var_2_13 = var_2_4.delay or 0

	arg_2_0._next_pulse = var_2_12 + var_2_13
	arg_2_0._time_to_start = var_2_12 + var_2_13
	arg_2_0._time_to_remove = var_2_12 + var_2_4.time_of_life + var_2_13
	arg_2_0._spread_function = LiquidAreaDamageTemplates[var_2_4.liquid_spread_function]
	arg_2_0._buff_system = var_2_0:system("buff_system")
	arg_2_0._flow = {}
	arg_2_0._active_flow = {}
	arg_2_0._inactive_flow = {}
	arg_2_0._num_liquid = 0
	arg_2_0._max_liquid = var_2_10
	arg_2_0._starting_pressure = var_2_4.starting_pressure or 5
	arg_2_0._end_pressure = var_2_4.end_pressure or 0.5
	arg_2_0._spawned_unit_index = 1
	arg_2_0._cell_radius = var_2_9 / 2
	arg_2_0._do_direct_damage_ai = var_2_4.do_direct_damage_ai
	arg_2_0._do_direct_damage_player = var_2_4.do_direct_damage_player
	arg_2_0._hit_player_function = var_2_4.hit_player_function

	local var_2_14 = Managers.state.difficulty:get_difficulty()

	arg_2_0._damage_table = arg_2_3.damage_table or var_2_4.difficulty_direct_damage[var_2_14]
	arg_2_0._damage_type = var_2_4.damage_type

	local var_2_15 = var_2_4.use_nav_cost_map_volumes

	arg_2_0._use_nav_cost_map_volumes = var_2_15
	arg_2_0._apply_buff_to_ai = var_2_4.apply_buff_to_ai
	arg_2_0._apply_buff_to_player = var_2_4.apply_buff_to_player
	arg_2_0._buff_name = var_2_4.buff_template_name
	arg_2_0._buff_type = var_2_4.buff_template_type
	arg_2_0._damage_buff_name = var_2_4.damage_buff_template_name
	arg_2_0._fx_name_rim = var_2_4.fx_name_rim
	arg_2_0._fx_name_filled = var_2_4.fx_name_filled
	arg_2_0._fx_name_start_delayed = var_2_4.fx_name_start_delayed
	arg_2_0._override_fx_life_time = var_2_4.override_fx_life_time

	Unit.set_unit_visibility(arg_2_2, false)

	local var_2_16 = var_2_4.sfx_name_start

	arg_2_0._sfx_name_start = var_2_16
	arg_2_0._sfx_name_start_delayed = var_2_4.sfx_name_start_delayed
	arg_2_0._sfx_name_stop = var_2_4.sfx_name_stop

	local var_2_17 = Vector3.flat(arg_2_3.flow_dir)

	arg_2_0._starting_flow_angle, arg_2_0._flow_dir = math.atan2(var_2_17.y, var_2_17.x), Vector3Box(var_2_17)
	arg_2_0._linearized_flow = var_2_4.linearized_flow
	arg_2_0._immune_breeds = var_2_4.immune_breeds
	arg_2_0._colliding_units = {}
	arg_2_0._buff_affected_units = {}
	arg_2_0._affected_player_units = {}
	arg_2_0._source_attacker_unit = arg_2_3.source_unit or arg_2_2
	arg_2_0._done = false
	arg_2_0._started = var_2_13 <= 0

	local var_2_18 = arg_2_0._source_attacker_unit

	if not Managers.player:owner(var_2_18) then
		local var_2_19 = ScriptUnit.has_extension(var_2_18, "buff_system")

		if var_2_19 then
			arg_2_0.buff_damage_multiplier = var_2_19:apply_buffs_to_value(1, "damage_dealt")
		end
	end

	if var_2_15 then
		local var_2_20 = var_2_4.nav_cost_map_cost_type
		local var_2_21 = arg_2_0._max_liquid

		arg_2_0._nav_cost_map_cost_type = var_2_20
		arg_2_0._nav_cost_map_id = var_2_1:create_nav_cost_map(var_2_20, var_2_21)
	end

	local var_2_22 = var_2_4.init_function

	if var_2_22 then
		LiquidAreaDamageTemplates[var_2_22](arg_2_0, var_2_12)
	end

	local var_2_23 = var_2_4.update_function

	if var_2_23 then
		arg_2_0._liquid_update_function = LiquidAreaDamageTemplates[var_2_23]
	end

	local var_2_24 = var_2_4.buff_condition_function

	if var_2_24 then
		arg_2_0._buff_condition = LiquidAreaDamageTemplates[var_2_24]
	end

	if var_2_16 then
		WwiseUtils.trigger_unit_event(var_2_2, var_2_16, arg_2_2, 0)
	end
end

function LiquidAreaDamageExtension.ready(arg_3_0)
	local var_3_0 = arg_3_0._unit

	arg_3_0._unit_id = Managers.state.unit_storage:go_id(var_3_0)

	local var_3_1 = Unit.local_position(var_3_0, 0)
	local var_3_2 = arg_3_0._grid
	local var_3_3, var_3_4, var_3_5 = var_3_2:find_index(var_3_1)

	var_0_0("CREATING LIQUID AT: ", var_3_3, var_3_4, var_3_5)

	local var_3_6 = var_3_2:real_index(var_3_3, var_3_4, var_3_5)
	local var_3_7, var_3_8, var_3_9 = var_3_2:ijk(var_3_6)

	fassert(var_3_7 == var_3_3 and var_3_8 == var_3_4 and var_3_9 == var_3_5, "FAIL, %i:%i %i:%i %i:%i", var_3_3, var_3_7, var_3_4, var_3_8, var_3_5, var_3_9)

	local var_3_10 = var_3_2:find_position(var_3_3, var_3_4, var_3_5)
	local var_3_11 = Vector3.distance_squared(var_3_1, var_3_10)

	fassert(var_3_11 < 1, "FAIL test_pos %s and pos %s too far apart %q", tostring(var_3_10), tostring(var_3_1), var_3_11)

	local var_3_12 = arg_3_0._starting_flow_angle

	arg_3_0:_create_liquid(var_3_6, var_3_12)
	arg_3_0:_set_active(var_3_6)

	arg_3_0._damage_direction = arg_3_0._flow_dir
end

local var_0_1 = 1 / (math.sqrt(3) * 0.5)

function LiquidAreaDamageExtension._set_active(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._flow
	local var_4_1 = var_4_0[arg_4_1]
	local var_4_2 = var_4_1.position:unbox()

	var_4_1.full = true
	var_4_1.amount = 1

	if var_4_1.fx_id then
		World.stop_spawning_particles(arg_4_0._world, var_4_1.fx_id)
	end

	local var_4_3 = arg_4_0._fx_name_filled

	if not script_data.debug_liquid_system and var_4_3 then
		local var_4_4 = var_4_1.rotation:unbox()

		var_4_1.fx_id = World.create_particles(arg_4_0._world, var_4_3, var_4_2, var_4_4)

		local var_4_5 = arg_4_0._override_fx_life_time

		if var_4_5 then
			World.set_particles_life_time(arg_4_0._world, var_4_1.fx_id, var_4_5)
		end
	else
		var_4_1.fx_id = nil
	end

	arg_4_0._network_transmit:send_rpc_clients("rpc_update_liquid_damage_blob", arg_4_0._unit_id, arg_4_1, NetworkLookup.liquid_damage_blob_states.filled)

	arg_4_0._active_flow[arg_4_1] = var_4_1
	arg_4_0._inactive_flow[arg_4_1] = nil
	arg_4_0._num_liquid = arg_4_0._num_liquid + 1

	local var_4_6 = "LiquidAreaDamageExtension"

	if arg_4_0._do_direct_damage_player or arg_4_0._apply_buff_to_player then
		local var_4_7 = Managers.state.entity:system("ai_bot_group_system")
		local var_4_8 = arg_4_0._cell_radius * var_0_1

		var_4_1.threat = var_4_7:aoe_threat_created(var_4_2, "sphere", var_4_8, nil, math.huge, var_4_6)
	end

	if arg_4_0._use_nav_cost_map_volumes then
		local var_4_9 = arg_4_0._ai_system
		local var_4_10 = arg_4_0._nav_cost_map_id

		var_4_1.nav_cost_map_volume_id = var_4_9:add_nav_cost_map_sphere_volume(var_4_2, arg_4_0._cell_radius, var_4_10)
	end

	for iter_4_0, iter_4_1 in pairs(var_4_1.neighbours) do
		if not var_4_0[iter_4_1] then
			arg_4_0:_create_liquid(iter_4_1, var_4_1.angle)
		end
	end
end

function LiquidAreaDamageExtension.stop_fx(arg_5_0)
	if script_data.debug_liquid_system then
		arg_5_0._fx_stopped = true
	else
		for iter_5_0, iter_5_1 in pairs(arg_5_0._flow) do
			if iter_5_1.fx_id then
				World.stop_spawning_particles(arg_5_0._world, iter_5_1.fx_id)
			end
		end
	end
end

function LiquidAreaDamageExtension._create_liquid(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._grid
	local var_6_1, var_6_2, var_6_3 = var_6_0:ijk(arg_6_1)
	local var_6_4 = var_6_0:find_position(var_6_1, var_6_2, var_6_3)
	local var_6_5 = arg_6_0._nav_world
	local var_6_6 = var_6_0:directions()
	local var_6_7, var_6_8, var_6_9, var_6_10, var_6_11 = GwNavQueries.triangle_from_position(var_6_5, var_6_4, 2, 2)
	local var_6_12
	local var_6_13

	if var_6_7 then
		local var_6_14 = Vector3.normalize(var_6_10 - var_6_9)
		local var_6_15 = Vector3.normalize(var_6_11 - var_6_9)
		local var_6_16 = Vector3.normalize(Vector3.cross(var_6_14, var_6_15))

		var_6_13 = Quaternion.look(var_6_14, var_6_16)
		var_6_12 = Vector3(var_6_4.x, var_6_4.y, var_6_8)
	else
		var_6_13 = Quaternion.identity()
		var_6_12 = var_6_4
	end

	local var_6_17 = {}

	for iter_6_0 = 1, #var_6_6 do
		local var_6_18 = var_6_6[iter_6_0]
		local var_6_19 = var_6_1 + var_6_18[1]
		local var_6_20 = var_6_2 + var_6_18[2]
		local var_6_21 = var_6_3
		local var_6_22 = var_6_0:find_position(var_6_19, var_6_20, var_6_21)
		local var_6_23 = arg_6_0:_find_point(var_6_22)

		if var_6_23 and GwNavQueries.raycango(var_6_5, var_6_12, var_6_23) then
			var_6_17[iter_6_0] = var_6_0:real_index(var_6_0:find_index(var_6_23))
		end
	end

	local var_6_24
	local var_6_25 = arg_6_0._fx_name_rim

	if not script_data.debug_liquid_system and var_6_25 then
		var_6_24 = World.create_particles(arg_6_0._world, var_6_25, var_6_12, var_6_13)

		local var_6_26 = arg_6_0._override_fx_life_time

		if var_6_26 then
			World.set_particles_life_time(arg_6_0._world, var_6_24, var_6_26)
		end
	end

	local var_6_27 = false

	arg_6_0._network_transmit:send_rpc_clients("rpc_add_liquid_damage_blob", arg_6_0._unit_id, arg_6_1, var_6_12, var_6_27)

	local var_6_28 = {
		full = false,
		amount = 0,
		neighbours = var_6_17,
		position = Vector3Box(var_6_12),
		rotation = QuaternionBox(var_6_13),
		fx_id = var_6_24,
		angle = arg_6_2 or 0
	}

	arg_6_0._flow[arg_6_1] = var_6_28
	arg_6_0._inactive_flow[arg_6_1] = var_6_28
end

function LiquidAreaDamageExtension._find_point(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0._nav_world
	local var_7_1, var_7_2 = GwNavQueries.triangle_from_position(var_7_0, arg_7_1, arg_7_2 or 2, arg_7_3 or 2)

	if var_7_1 then
		return Vector3(arg_7_1.x, arg_7_1.y, var_7_2)
	else
		local var_7_3 = GwNavQueries.inside_position_from_outside_position(var_7_0, arg_7_1, arg_7_2 or 2, arg_7_3 or 2, 2, 0.5)

		if var_7_3 then
			return var_7_3
		end

		return nil
	end
end

function LiquidAreaDamageExtension.destroy(arg_8_0)
	local var_8_0 = arg_8_0._unit
	local var_8_1 = arg_8_0._sfx_name_stop

	if var_8_1 then
		local var_8_2 = arg_8_0._world

		WwiseUtils.trigger_unit_event(var_8_2, var_8_1, var_8_0, 0)
	end

	for iter_8_0, iter_8_1 in pairs(arg_8_0._buff_affected_units) do
		if Unit.alive(iter_8_0) then
			arg_8_0._buff_system:remove_server_controlled_buff(iter_8_0, iter_8_1)
		end

		arg_8_0._buff_affected_units[iter_8_0] = nil
	end

	local var_8_3 = Managers.state.side:sides()

	for iter_8_2 = 1, #var_8_3 do
		local var_8_4 = var_8_3[iter_8_2].PLAYER_AND_BOT_UNITS
		local var_8_5 = #var_8_4

		for iter_8_3 = 1, var_8_5 do
			local var_8_6 = var_8_4[iter_8_3]

			if Unit.alive(var_8_6) then
				local var_8_7 = arg_8_0._colliding_units[var_8_6]
				local var_8_8 = var_8_7 and ScriptUnit.extension(var_8_6, "status_system")

				if var_8_7 and var_8_8.in_liquid_unit == var_8_0 then
					StatusUtils.set_in_liquid_network(var_8_6, false)
				end
			end

			arg_8_0._colliding_units[var_8_6] = nil
		end
	end

	if arg_8_0._use_nav_cost_map_volumes then
		local var_8_9 = arg_8_0._ai_system
		local var_8_10 = arg_8_0._nav_cost_map_id

		for iter_8_4, iter_8_5 in pairs(arg_8_0._flow) do
			local var_8_11 = iter_8_5.nav_cost_map_volume_id

			if var_8_11 then
				var_8_9:remove_nav_cost_map_volume(var_8_11, var_8_10)
			end
		end

		var_8_9:destroy_nav_cost_map(var_8_10)
	end

	for iter_8_6, iter_8_7 in pairs(arg_8_0._flow) do
		local var_8_12 = iter_8_7.threat

		if var_8_12 then
			Managers.state.entity:system("ai_bot_group_system"):remove_threat(var_8_12)
		end
	end

	table.clear(arg_8_0._affected_player_units)
	arg_8_0:stop_fx()
end

local var_0_2 = {}
local var_0_3 = {}
local var_0_4 = {
	{
		index = 0,
		weight = 0,
		angle = 0
	},
	{
		index = 0,
		weight = 0,
		angle = 0
	},
	{
		index = 0,
		weight = 0,
		angle = 0
	},
	{
		index = 0,
		weight = 0,
		angle = 0
	},
	{
		index = 0,
		weight = 0,
		angle = 0
	},
	{
		index = 0,
		weight = 0,
		angle = 0
	}
}

function LiquidAreaDamageExtension.update(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = 1 - arg_9_0._num_liquid / arg_9_0._max_liquid
	local var_9_1 = math.lerp(arg_9_0._end_pressure, arg_9_0._starting_pressure, var_9_0)
	local var_9_2 = arg_9_0._active_flow
	local var_9_3 = arg_9_0._flow

	table.clear(var_0_2)
	table.clear(var_0_3)

	if not arg_9_0._started then
		if arg_9_5 < arg_9_0._time_to_start then
			return
		end

		arg_9_0._started = true

		if arg_9_0._sfx_name_start_delayed then
			WwiseUtils.trigger_unit_event(arg_9_0._world, arg_9_0._sfx_name_start_delayed, arg_9_0._unit, 0)
		end

		if arg_9_0._fx_name_start_delayed then
			local var_9_4 = Unit.world_position(arg_9_1, 0)
			local var_9_5 = Unit.world_rotation(arg_9_1, 0)

			World.create_particles(arg_9_0._world, arg_9_0._fx_name_start_delayed, var_9_4, var_9_5)
		end
	end

	if arg_9_5 > arg_9_0._time_to_remove then
		Managers.state.unit_spawner:mark_for_deletion(arg_9_0._unit)

		return
	end

	if not arg_9_0._done then
		local var_9_6 = arg_9_0._spread_function
		local var_9_7 = arg_9_0._grid:directions()
		local var_9_8 = 2 * math.pi

		for iter_9_0, iter_9_1 in pairs(arg_9_0._active_flow) do
			local var_9_9 = true
			local var_9_10 = 0
			local var_9_11 = 0
			local var_9_12 = iter_9_1.angle

			for iter_9_2, iter_9_3 in pairs(iter_9_1.neighbours) do
				local var_9_13 = var_9_3[iter_9_3]
				local var_9_14 = var_9_7[iter_9_2].angle
				local var_9_15
				local var_9_16

				if var_9_12 < var_9_14 then
					var_9_15 = var_9_14 - var_9_12
					var_9_16 = var_9_8 - var_9_14 + var_9_12
				else
					var_9_15 = var_9_8 - var_9_12 + var_9_14
					var_9_16 = var_9_12 - var_9_14
				end

				local var_9_17

				if var_9_15 < var_9_16 then
					var_9_17 = var_9_15
				else
					var_9_17 = -var_9_16
				end

				local var_9_18 = var_9_6(math.abs(var_9_17))

				var_9_11 = var_9_11 + var_9_18

				if not var_9_2[iter_9_3] and not var_9_13.full and var_9_18 > 0 then
					var_9_10 = var_9_10 + 1

					local var_9_19 = var_0_4[var_9_10]

					var_9_19.index = iter_9_3
					var_9_19.weight = var_9_18
					var_9_19.angle = var_9_14
					var_9_19.relative_angle = var_9_17
				end
			end

			local var_9_20 = arg_9_0._starting_flow_angle
			local var_9_21 = arg_9_0._linearized_flow

			for iter_9_4 = 1, var_9_10 do
				local var_9_22 = var_0_4[iter_9_4]
				local var_9_23 = var_9_22.index
				local var_9_24 = var_9_22.weight
				local var_9_25 = var_9_3[var_9_23]
				local var_9_26 = var_9_24 / var_9_11
				local var_9_27 = arg_9_3 * var_9_1 * var_9_26
				local var_9_28 = var_9_25.amount
				local var_9_29 = var_9_27 + var_9_28

				fassert(var_9_27 > 0)
				fassert(var_9_29 > 0)
				fassert(var_9_28 >= 0)

				if var_9_21 then
					var_9_25.angle = var_9_20 - var_9_22.relative_angle
					var_9_25.amount = var_9_29
				else
					var_9_25.amount = var_9_29
				end

				if var_9_25.amount >= 1 then
					var_0_3[var_9_23] = true
				end

				var_9_9 = false
			end

			if var_9_9 then
				var_0_2[iter_9_0] = true
			end
		end

		for iter_9_5, iter_9_6 in pairs(var_0_2) do
			var_9_2[iter_9_5] = nil
		end

		for iter_9_7, iter_9_8 in pairs(var_0_3) do
			arg_9_0:_set_active(iter_9_7)

			if arg_9_0._num_liquid == arg_9_0._max_liquid then
				arg_9_0._done = true

				break
			end
		end
	end

	arg_9_0:_update_collision_detection(arg_9_3, arg_9_5)

	while arg_9_5 > arg_9_0._next_pulse do
		arg_9_0._next_pulse = arg_9_0._next_pulse + 0.75

		arg_9_0:_pulse_damage()
	end

	if arg_9_0._liquid_update_function and not arg_9_0._liquid_update_function(arg_9_0, arg_9_5, arg_9_3) then
		arg_9_0._liquid_update_function = nil
	end
end

function LiquidAreaDamageExtension._add_buff_helper_function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0

	if arg_10_4 then
		var_10_0 = arg_10_4(arg_10_1)
	else
		var_10_0 = true
	end

	if arg_10_0._buff_affected_units[arg_10_1] == nil then
		if var_10_0 then
			arg_10_0._buff_affected_units[arg_10_1] = arg_10_5:add_buff(arg_10_1, arg_10_3, arg_10_2, true)
		end
	elseif not var_10_0 then
		local var_10_1 = arg_10_0._buff_affected_units[arg_10_1]

		arg_10_5:remove_server_controlled_buff(arg_10_1, var_10_1)

		arg_10_0._buff_affected_units[arg_10_1] = nil
	end
end

local var_0_5 = 10

function LiquidAreaDamageExtension._update_collision_detection(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = var_0_5
	local var_11_1 = arg_11_0._grid
	local var_11_2 = arg_11_0._unit
	local var_11_3 = arg_11_0._apply_buff_to_player
	local var_11_4 = arg_11_0._do_direct_damage_player

	arg_11_0._check_player_units = (var_11_3 or var_11_4) and arg_11_0._check_player_units

	local var_11_5 = arg_11_0._buff_system
	local var_11_6 = arg_11_0._buff_name
	local var_11_7 = arg_11_0._buff_type
	local var_11_8 = arg_11_0._buff_condition
	local var_11_9 = arg_11_0._immune_breeds

	if arg_11_0._check_player_units then
		local var_11_10 = Managers.state.side:sides()

		for iter_11_0 = 1, #var_11_10 do
			local var_11_11 = var_11_10[iter_11_0].PLAYER_AND_BOT_UNITS
			local var_11_12 = #var_11_11

			for iter_11_1 = 1, var_11_12 do
				local var_11_13 = var_11_11[iter_11_1]
				local var_11_14 = Unit.get_data(var_11_13, "breed")

				if var_11_14 and not var_11_9[var_11_14.name] then
					local var_11_15 = ScriptUnit.extension(var_11_13, "status_system")

					if arg_11_0:_is_unit_colliding(var_11_1, var_11_13) then
						arg_11_0._colliding_units[var_11_13] = 4

						if var_11_15.in_liquid_unit ~= var_11_2 then
							StatusUtils.set_in_liquid_network(var_11_13, true, var_11_2)
						end

						if not arg_11_0._affected_player_units[var_11_13] and arg_11_0._hit_player_function then
							arg_11_0._affected_player_units[var_11_13] = true

							arg_11_0._hit_player_function(var_11_13, var_11_11, arg_11_0._source_attacker_unit)
						end

						local var_11_16 = ScriptUnit.extension(var_11_13, "buff_system")

						if var_11_6 and var_11_3 and not var_11_16:has_buff_type(var_11_7) then
							arg_11_0:_add_buff_helper_function(var_11_13, var_11_2, var_11_6, var_11_8, var_11_5)
						end
					else
						arg_11_0._colliding_units[var_11_13] = nil

						if var_11_15.in_liquid_unit == var_11_2 then
							StatusUtils.set_in_liquid_network(var_11_13, false)
						end

						if var_11_6 and arg_11_0._buff_affected_units[var_11_13] then
							local var_11_17 = arg_11_0._buff_affected_units[var_11_13]

							var_11_5:remove_server_controlled_buff(var_11_13, var_11_17)

							arg_11_0._buff_affected_units[var_11_13] = nil
						end
					end
				end
			end

			arg_11_0._check_player_units = false
			var_11_0 = var_11_0 - var_11_12
		end
	end

	local var_11_18, var_11_19 = Managers.state.conflict:all_spawned_units()
	local var_11_20 = arg_11_0._spawned_unit_index
	local var_11_21 = math.min(var_11_20 + var_11_0, var_11_19)
	local var_11_22 = arg_11_0._apply_buff_to_ai
	local var_11_23 = BLACKBOARDS

	while var_11_20 <= var_11_21 do
		local var_11_24 = var_11_18[var_11_20]
		local var_11_25 = var_11_23[var_11_24].breed

		if var_11_25 and not var_11_9[var_11_25.name] then
			if arg_11_0:_is_unit_colliding(var_11_1, var_11_24) then
				arg_11_0._colliding_units[var_11_24] = var_11_25.armor_category or 1

				local var_11_26 = ScriptUnit.has_extension(var_11_24, "buff_system")

				if var_11_6 and var_11_22 and var_11_26 and not var_11_26:has_buff_type(var_11_7) then
					arg_11_0:_add_buff_helper_function(var_11_24, var_11_2, var_11_6, var_11_8, var_11_5)
				end
			else
				arg_11_0._colliding_units[var_11_24] = nil

				if var_11_6 and arg_11_0._buff_affected_units[var_11_24] then
					local var_11_27 = arg_11_0._buff_affected_units[var_11_24]

					var_11_5:remove_server_controlled_buff(var_11_24, var_11_27)

					arg_11_0._buff_affected_units[var_11_24] = nil
				end
			end
		end

		var_11_20 = var_11_20 + 1
	end

	if var_11_19 < var_11_20 then
		arg_11_0._spawned_unit_index = 1
		arg_11_0._check_player_units = true
	else
		arg_11_0._spawned_unit_index = var_11_20
	end
end

function LiquidAreaDamageExtension._is_unit_colliding(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = POSITION_LOOKUP[arg_12_2]

	if var_12_0 then
		for iter_12_0 = 0, 1 do
			local var_12_1, var_12_2, var_12_3 = arg_12_1:find_index(var_12_0 + iter_12_0 * Vector3.up())

			if arg_12_1:is_out_of_bounds(var_12_1, var_12_2, var_12_3) then
				break
			end

			local var_12_4 = arg_12_1:real_index(var_12_1, var_12_2, var_12_3)
			local var_12_5 = arg_12_0._flow[var_12_4]

			if var_12_5 then
				if var_12_5.full then
					return true
				else
					break
				end
			end
		end
	end

	return false
end

local var_0_6 = {}

function LiquidAreaDamageExtension._pulse_damage(arg_13_0)
	local var_13_0 = 0
	local var_13_1 = arg_13_0._damage_direction:unbox()
	local var_13_2 = arg_13_0._damage_type
	local var_13_3 = arg_13_0._source_attacker_unit
	local var_13_4 = var_13_3 and DamageUtils.is_player_unit(var_13_3)
	local var_13_5 = arg_13_0._do_direct_damage_player
	local var_13_6 = arg_13_0._do_direct_damage_ai
	local var_13_7 = arg_13_0._damage_buff_name
	local var_13_8 = arg_13_0._unit
	local var_13_9 = arg_13_0._damage_table

	for iter_13_0, iter_13_1 in pairs(arg_13_0._colliding_units) do
		local var_13_10 = DamageUtils.is_player_unit(iter_13_0)

		if HEALTH_ALIVE[iter_13_0] then
			if var_13_10 and var_13_5 or not var_13_10 and var_13_6 then
				local var_13_11 = var_13_9[iter_13_1] or var_13_9[1]

				DamageUtils.add_damage_network(iter_13_0, iter_13_0, var_13_11, "torso", var_13_2, nil, var_13_1, arg_13_0._liquid_area_damage_template, nil, var_13_3, nil, nil, nil, nil, nil, nil, nil, nil, 1)

				if var_13_4 then
					local var_13_12 = AiUtils.unit_breed(iter_13_0)

					if var_13_12 and not var_13_12.is_hero then
						AiUtils.alert_unit_of_enemy(iter_13_0, var_13_3)
					end
				end

				if var_13_7 then
					ScriptUnit.extension(iter_13_0, "buff_system"):add_buff(var_13_7, var_0_6)
				end
			end
		else
			var_13_0 = var_13_0 + 1
			var_0_2[var_13_0] = iter_13_0

			local var_13_13 = var_13_10 and ScriptUnit.extension(iter_13_0, "status_system")

			if var_13_10 and var_13_13.in_liquid_unit == var_13_8 then
				StatusUtils.set_in_liquid_network(iter_13_0, false)
			end
		end
	end

	for iter_13_2 = 1, var_13_0 do
		local var_13_14 = var_0_2[iter_13_2]

		arg_13_0._colliding_units[var_13_14] = nil
	end
end

function LiquidAreaDamageExtension.is_position_inside(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._grid
	local var_14_1, var_14_2, var_14_3 = var_14_0:find_index(arg_14_1)

	if var_14_0:is_out_of_bounds(var_14_1, var_14_2, var_14_3) then
		return false
	end

	local var_14_4 = arg_14_0._nav_cost_map_cost_type

	if var_14_4 == nil or arg_14_2 and arg_14_2[var_14_4] == 1 then
		return false
	end

	local var_14_5 = var_14_0:real_index(var_14_1, var_14_2, var_14_3)
	local var_14_6 = arg_14_0._flow[var_14_5]

	if var_14_6 and var_14_6.full then
		return true
	else
		return false
	end
end

function LiquidAreaDamageExtension.get_rim_nodes(arg_15_0)
	return arg_15_0._inactive_flow, false
end

function LiquidAreaDamageExtension.hot_join_sync(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._flow
	local var_16_1 = arg_16_0._unit_id
	local var_16_2 = arg_16_0._network_transmit

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		local var_16_3 = iter_16_1.position:unbox()
		local var_16_4 = iter_16_1.full

		var_16_2:send_rpc("rpc_add_liquid_damage_blob", arg_16_1, var_16_1, iter_16_0, var_16_3, var_16_4)
	end
end

function LiquidAreaDamageExtension.get_source_attacker_unit(arg_17_0)
	return arg_17_0._source_attacker_unit
end
