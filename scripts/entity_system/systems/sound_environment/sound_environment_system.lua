-- chunkname: @scripts/entity_system/systems/sound_environment/sound_environment_system.lua

require("scripts/helpers/wwise_utils")

SoundEnvironmentSystem = class(SoundEnvironmentSystem, ExtensionSystemBase)

local var_0_0 = {}
local var_0_1 = {}
local var_0_2 = 0.5
local var_0_3 = 1 - var_0_2
local var_0_4 = 1

function SoundEnvironmentSystem.init(arg_1_0, arg_1_1, arg_1_2)
	SoundEnvironmentSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	arg_1_0._highest_prio_system = EngineOptimized.highest_prio_environment_init()

	local var_1_0 = arg_1_0.world

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)

	WwiseWorld.reset_aux_environment(arg_1_0.wwise_world)

	arg_1_0._environments = {}
	arg_1_0._fade_environments = {}
	arg_1_0._current_environment = nil

	local var_1_1 = arg_1_1.startup_data.level_key
	local var_1_2 = LevelSettings[var_1_1]
	local var_1_3 = var_1_2.ambient_sound_event
	local var_1_4 = var_1_2.global_environment_fade_time
	local var_1_5 = var_1_2.player_aux_bus_name
	local var_1_6 = var_1_2.environment_state

	arg_1_0:register_sound_environment("global", -1, var_1_3, var_1_4, var_1_5, var_1_6)
	arg_1_0:enter_environment(0, "global")

	arg_1_0._updated_sources = {}
	arg_1_0._num_sources = 0
	arg_1_0._current_source_index = 0
	arg_1_0._check_timer = 0
end

function SoundEnvironmentSystem.destroy(arg_2_0)
	EngineOptimized.highest_prio_environment_destroy(arg_2_0._highest_prio_system)
end

local var_0_5 = {
	aux_bus_name = "",
	prio = 0,
	fade_time = 0,
	volume_name = "",
	ambient_sound_event_stop = "",
	ambient_sound_event_start = "",
	fade_info = {
		current_value = 0
	}
}

function SoundEnvironmentSystem.register_sound_environment(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	fassert(arg_3_0._environments[arg_3_1] == nil, "Already registered sound environment with name %q", arg_3_1)

	local var_3_0 = arg_3_0._environments[arg_3_1] or table.clone(var_0_5)

	var_3_0.prio = arg_3_2

	if arg_3_3 ~= "" then
		var_3_0.ambient_sound_event_start = "Play_" .. arg_3_3
		var_3_0.ambient_sound_event_stop = "Stop_" .. arg_3_3
	end

	var_3_0.fade_time = arg_3_4 or 1

	assert(arg_3_5, "Sound environment lacks auxiliary bus")

	var_3_0.player_aux_bus_name = arg_3_5
	var_3_0.source_aux_bus_name = arg_3_5 .. "_source"

	assert(arg_3_6, "Have to set environment state")

	var_3_0.environment_state = arg_3_6
	arg_3_0._environments[arg_3_1] = var_3_0

	local var_3_1 = {}
	local var_3_2 = 1

	for iter_3_0, iter_3_1 in pairs(arg_3_0._environments) do
		local var_3_3 = iter_3_1.prio

		var_3_1[var_3_2] = {
			p = var_3_3,
			n = iter_3_0
		}
		var_3_2 = var_3_2 + 1
	end

	table.sort(var_3_1, function(arg_4_0, arg_4_1)
		return arg_4_0.p > arg_4_1.p
	end)

	local var_3_4 = {}
	local var_3_5 = var_3_2 - 1

	for iter_3_2 = 1, var_3_5 do
		var_3_4[iter_3_2] = var_3_1[iter_3_2].n
	end

	EngineOptimized.highest_prio_environment_reorder(arg_3_0._highest_prio_system, unpack(var_3_4))
end

function SoundEnvironmentSystem._highest_prio_environment_at_position(arg_5_0, arg_5_1)
	local var_5_0
	local var_5_1 = LevelHelper:current_level(arg_5_0.world)

	return (EngineOptimized.highest_prio_environment_at_position(arg_5_0._highest_prio_system, var_5_1, arg_5_1))
end

function SoundEnvironmentSystem.set_source_environment(arg_6_0, arg_6_1, arg_6_2)
	if not GameSettingsDevelopment.fade_environments then
		return
	end

	if not Vector3.is_valid(arg_6_2) then
		return
	end

	local var_6_0 = arg_6_0:_highest_prio_environment_at_position(arg_6_2)
	local var_6_1 = arg_6_0._environments
	local var_6_2 = arg_6_0.wwise_world
	local var_6_3 = var_6_1[var_6_0 or "global"].source_aux_bus_name

	assert(var_6_3, "No source aux environment in %s", var_6_0 or "global")
	WwiseWorld.reset_environment_for_source(var_6_2, arg_6_1)
	WwiseWorld.set_environment_for_source(var_6_2, arg_6_1, var_6_3, var_0_2)

	local var_6_4 = arg_6_0._fade_environments
	local var_6_5 = false
	local var_6_6 = arg_6_0._current_environment

	for iter_6_0, iter_6_1 in pairs(var_6_4) do
		local var_6_7 = var_6_1[iter_6_0]
		local var_6_8 = var_6_7.fade_info

		WwiseWorld.set_environment(var_6_2, var_6_7.player_aux_bus_name, var_6_8.current_value * var_0_3)

		var_6_5 = var_6_5 or iter_6_0 == var_6_6
	end

	if not var_6_5 then
		local var_6_9 = arg_6_0._environments[var_6_6]

		WwiseWorld.set_environment(var_6_2, var_6_9.player_aux_bus_name, var_0_3)
	end

	return var_6_3
end

function SoundEnvironmentSystem.register_source_environment_update(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0._updated_sources[#arg_7_0._updated_sources + 1] = {
		unit = arg_7_2,
		source = arg_7_1,
		node = arg_7_3 and Unit.node(arg_7_2, arg_7_3) or 0
	}
	arg_7_0._num_sources = arg_7_0._num_sources + 1
end

function SoundEnvironmentSystem.unregister_source_environment_update(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._num_sources

	for iter_8_0 = 1, var_8_0 do
		if arg_8_0._updated_sources[iter_8_0].source == arg_8_1 then
			table.remove(arg_8_0._updated_sources, iter_8_0)

			local var_8_1 = arg_8_0._current_source_index

			if iter_8_0 < var_8_1 then
				arg_8_0._current_source_index = var_8_1 - 1
			end

			arg_8_0._num_sources = var_8_0 - 1

			return
		end
	end
end

local var_0_6 = 3
local var_0_7 = {}

function SoundEnvironmentSystem._update_source_environments(arg_9_0)
	local var_9_0 = arg_9_0._num_sources
	local var_9_1 = math.min(var_9_0, var_0_6)
	local var_9_2 = math.min(arg_9_0._current_source_index, var_9_0)
	local var_9_3 = arg_9_0._updated_sources
	local var_9_4 = WwiseWorld.has_source
	local var_9_5 = 0

	for iter_9_0 = 1, var_9_1 do
		var_9_2 = var_9_2 % var_9_0 + 1

		local var_9_6 = var_9_3[var_9_2]
		local var_9_7 = var_9_6.source

		if var_9_4(arg_9_0.wwise_world, var_9_7) then
			local var_9_8 = Unit.world_position(var_9_6.unit, var_9_6.node)
			local var_9_9 = arg_9_0:set_source_environment(var_9_7, var_9_8)
		else
			var_0_7[#var_0_7 + 1] = var_9_7
			var_9_5 = var_9_5 + 1
		end
	end

	arg_9_0._current_source_index = var_9_2

	for iter_9_1 = 1, var_9_5 do
		local var_9_10 = var_0_7[iter_9_1]

		arg_9_0:unregister_source_environment_update(var_9_10)

		var_0_7[iter_9_1] = nil
	end
end

function SoundEnvironmentSystem.local_player_created(arg_10_0, arg_10_1)
	arg_10_0.player = arg_10_1
end

function SoundEnvironmentSystem.update(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_2 > arg_11_0._check_timer then
		arg_11_0._check_timer = arg_11_2 + 1

		if not arg_11_0.player then
			return
		end

		local var_11_0 = arg_11_0.player.viewport_name
		local var_11_1 = Managers.state.camera:listener_pose(var_11_0)
		local var_11_2 = Matrix4x4.translation(var_11_1)
		local var_11_3 = arg_11_0:_highest_prio_environment_at_position(var_11_2)

		if var_11_3 then
			if var_11_3 ~= arg_11_0._current_environment then
				arg_11_0:enter_environment(arg_11_2, var_11_3, arg_11_0._current_environment)
			end
		elseif arg_11_0._current_environment ~= "global" then
			arg_11_0:enter_environment(arg_11_2, "global", arg_11_0._current_environment)
		end
	end

	if GameSettingsDevelopment.fade_environments then
		arg_11_0:_update_fade(arg_11_2)
		arg_11_0:_update_source_environments()
	end
end

function SoundEnvironmentSystem._update_fade(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.wwise_world
	local var_12_1 = arg_12_0._environments
	local var_12_2 = arg_12_0._fade_environments

	for iter_12_0, iter_12_1 in pairs(var_12_2) do
		local var_12_3 = var_12_1[iter_12_0]
		local var_12_4 = var_12_3.fade_info
		local var_12_5 = var_12_4.fade_start
		local var_12_6 = var_12_4.fade_time
		local var_12_7 = arg_12_1 - var_12_5
		local var_12_8 = math.clamp(var_12_7 / var_12_6, 0, 1)
		local var_12_9 = var_12_4.start_value
		local var_12_10 = var_12_4.target_value
		local var_12_11 = math.lerp(var_12_9, var_12_10, var_12_8)

		var_12_4.current_value = var_12_11

		WwiseWorld.set_environment(var_12_0, var_12_3.player_aux_bus_name, var_12_11 * var_0_3)

		if var_12_11 == var_12_10 then
			var_12_2[iter_12_0] = nil
		end
	end
end

function SoundEnvironmentSystem._add_fade_environment(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_0._environments[arg_13_2].fade_info

	var_13_0.fade_start = arg_13_1
	var_13_0.fade_time = arg_13_3
	var_13_0.start_value = var_13_0.current_value
	var_13_0.target_value = arg_13_4
	arg_13_0._fade_environments[arg_13_2] = true
end

local var_0_8 = 3

function SoundEnvironmentSystem._clamp_num_fade_environments(arg_14_0)
	local var_14_0 = 0
	local var_14_1
	local var_14_2 = math.huge

	for iter_14_0, iter_14_1 in pairs(arg_14_0._fade_environments) do
		var_14_0 = var_14_0 + 1

		local var_14_3 = arg_14_0._environments[iter_14_0].fade_info
		local var_14_4 = var_14_3.current_value

		if var_14_3.target_value == 0 and var_14_4 < var_14_2 then
			var_14_2 = var_14_4
			var_14_1 = iter_14_0
		end
	end

	assert(var_14_0 <= var_0_8 + 1, "Too many environments, cleanup failed.")

	if var_14_0 > var_0_8 then
		local var_14_5 = arg_14_0._environments[var_14_1]

		var_14_5.fade_info.current_value = 0
		arg_14_0._fade_environments[var_14_1] = nil

		WwiseWorld.set_environment(arg_14_0.wwise_world, var_14_5.player_aux_bus_name, 0)
	end
end

function SoundEnvironmentSystem.enter_environment(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_0._environments[arg_15_2]

	if GameSettingsDevelopment.fade_environments then
		local var_15_1 = var_15_0.fade_time
		local var_15_2 = var_15_0.fade_info

		if var_15_2.current_value > 0 then
			var_15_1 = var_15_1 * (1 - var_15_2.current_value)

			if var_15_1 < 0.001 then
				var_15_1 = 0.001
			end
		end

		arg_15_0:_add_fade_environment(arg_15_1, arg_15_2, var_15_1, 1)

		if arg_15_3 then
			arg_15_0:_add_fade_environment(arg_15_1, arg_15_3, var_15_1, 0)
		end

		arg_15_0:_clamp_num_fade_environments()
	else
		arg_15_0:_set_environment(arg_15_2)
	end

	Wwise.set_state("interior_exterior", var_15_0.environment_state)

	local var_15_3 = arg_15_0.wwise_world

	if arg_15_3 then
		local var_15_4 = arg_15_0._environments[arg_15_3].ambient_sound_event_stop

		if var_15_4 then
			WwiseWorld.trigger_event(var_15_3, var_15_4)
		end
	end

	local var_15_5 = var_15_0.ambient_sound_event_start

	if var_15_5 then
		WwiseWorld.trigger_event(var_15_3, var_15_5)
	end

	arg_15_0._current_environment = arg_15_2
end

function SoundEnvironmentSystem._set_environment(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.wwise_world
	local var_16_1 = arg_16_0._environments[arg_16_1]

	WwiseWorld.reset_aux_environment(var_16_0)
	WwiseWorld.set_environment(var_16_0, var_16_1.player_aux_bus_name, var_0_4)
end
