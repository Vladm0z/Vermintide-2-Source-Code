-- chunkname: @scripts/entity_system/systems/sound/sound_sector_system.lua

require("scripts/entity_system/systems/sound/sound_sector_event_templates")

local var_0_0 = 1
local var_0_1 = {
	"rpc_enemy_has_target"
}

SoundSectorSystem = class(SoundSectorSystem, ExtensionSystemBase)
SoundSectorSystem.system_extensions = {
	"SoundSectorExtension"
}

function SoundSectorSystem.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.unit_storage = arg_1_1.unit_storage

	local var_1_0 = SoundSectorSystem.system_extensions

	arg_1_1.entity_manager:register_system(arg_1_0, arg_1_2, var_1_0)

	arg_1_0.world = arg_1_1.world
	arg_1_0.wwise_world = Managers.world:wwise_world(arg_1_0.world)

	local var_1_1 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_1

	var_1_1:register(arg_1_0, unpack(var_0_1))

	arg_1_0._extensions = {}
	arg_1_0._frozen_extensions = {}
	arg_1_0._sectors = {}
	arg_1_0._sector_sound_source_ids = {}
	arg_1_0._sector_sound_source_units = {}
	arg_1_0._sector_sound_source_refs = {}
	arg_1_0._sector_process_index = 0

	for iter_1_0 = 1, var_0_0 do
		arg_1_0._sectors[iter_1_0] = {}

		local var_1_2 = World.spawn_unit(arg_1_0.world, "units/testunits/camera")

		arg_1_0._sector_sound_source_units[iter_1_0] = var_1_2
	end

	arg_1_0._events = {
		ai_unit_deactivated = "event_ai_unit_deactivated",
		ai_unit_activated = "event_ai_unit_activated"
	}

	local var_1_3 = Managers.state.event

	for iter_1_1, iter_1_2 in pairs(arg_1_0._events) do
		var_1_3:register(arg_1_0, iter_1_1, iter_1_2)
	end
end

function SoundSectorSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)

	local var_2_0 = Managers.state.event

	for iter_2_0, iter_2_1 in pairs(arg_2_0._events) do
		var_2_0:unregister(iter_2_0, arg_2_0)
	end

	local var_2_1 = arg_2_0.wwise_world

	for iter_2_2, iter_2_3 in pairs(arg_2_0._sector_sound_source_refs) do
		WwiseWorld.destroy_manual_source(var_2_1, iter_2_2)
	end
end

function SoundSectorSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = {}

	ScriptUnit.set_extension(arg_3_2, "sound_sector_system", var_3_0)

	if arg_3_3 == "SoundSectorExtension" then
		arg_3_0._extensions[arg_3_2] = var_3_0

		if arg_3_0.camera_unit then
			local var_3_1 = Unit.local_position(arg_3_0.camera_unit, 0)
			local var_3_2 = arg_3_0:_calc_unit_sector(var_3_1, arg_3_2)

			if var_3_2 then
				arg_3_0._sectors[var_3_2][arg_3_2] = arg_3_2
			end

			var_3_0.sector_index = var_3_2
		end
	end

	return var_3_0
end

function SoundSectorSystem.extensions_ready(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_3 == "SoundSectorExtension" then
		local var_4_0 = arg_4_0._extensions[arg_4_2].sector_index

		if var_4_0 then
			local var_4_1 = ScriptUnit.extension(arg_4_2, "death_system")

			arg_4_0._sectors[var_4_0][arg_4_2] = var_4_1
		end
	end
end

function SoundSectorSystem.on_remove_extension(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._frozen_extensions[arg_5_1] = nil

	arg_5_0:_cleanup_extension(arg_5_1, arg_5_2)
	ScriptUnit.remove_extension(arg_5_1, arg_5_0.NAME)
end

function SoundSectorSystem.on_freeze_extension(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._extensions[arg_6_1]

	fassert(var_6_0, "Unit was already frozen.")

	arg_6_0._frozen_extensions[arg_6_1] = var_6_0

	arg_6_0:_cleanup_extension(arg_6_1, arg_6_2)
end

function SoundSectorSystem._cleanup_extension(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._extensions[arg_7_1]

	if var_7_0 == nil then
		return
	end

	local var_7_1 = var_7_0.sector_index

	if var_7_1 then
		arg_7_0._sectors[var_7_1][arg_7_1] = nil
	end

	var_7_0.has_target = nil
	arg_7_0._extensions[arg_7_1] = nil
end

function SoundSectorSystem.freeze(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0._frozen_extensions

	if var_8_0[arg_8_1] then
		return
	end

	local var_8_1 = arg_8_0._extensions[arg_8_1]

	fassert(var_8_1, "Unit to freeze didn't have unfrozen extension")
	arg_8_0:_cleanup_extension(arg_8_1, arg_8_2)

	arg_8_0._extensions[arg_8_1] = nil
	var_8_0[arg_8_1] = var_8_1
end

function SoundSectorSystem.unfreeze(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._frozen_extensions[arg_9_1]

	arg_9_0._frozen_extensions[arg_9_1] = nil
	arg_9_0._extensions[arg_9_1] = var_9_0

	if arg_9_0.camera_unit then
		local var_9_1 = Unit.local_position(arg_9_0.camera_unit, 0)
		local var_9_2 = arg_9_0:_calc_unit_sector(var_9_1, arg_9_1)

		if var_9_2 then
			local var_9_3 = ScriptUnit.extension(arg_9_1, "death_system")

			arg_9_0._sectors[var_9_2][arg_9_1] = var_9_3
		end

		var_9_0.sector_index = var_9_2
	end
end

function SoundSectorSystem.update(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if not arg_10_0.camera_unit then
		return
	end

	local var_10_0 = Unit.local_position(arg_10_0.camera_unit, 0)

	var_10_0 = Vector3.is_valid(var_10_0) and var_10_0 or Vector3(0, 0, 0)

	local var_10_1 = arg_10_0._sector_sound_source_ids

	arg_10_0:_update_sectors(var_10_0)

	local var_10_2 = arg_10_0._sector_sound_source_units
	local var_10_3 = arg_10_0.wwise_world
	local var_10_4 = Unit.set_local_position
	local var_10_5 = WwiseWorld.set_source_parameter

	arg_10_0._sector_process_index = 1

	local var_10_6 = arg_10_0._sector_process_index

	for iter_10_0, iter_10_1 in pairs(SoundSectorEventTemplates) do
		local var_10_7, var_10_8, var_10_9 = iter_10_1.evaluate(arg_10_0._sectors, var_10_6, arg_10_2, arg_10_0._extensions, var_10_0)
		local var_10_10 = iter_10_1.sound_event_start .. var_10_6
		local var_10_11 = var_10_1[var_10_10]
		local var_10_12 = var_10_11 ~= nil

		if var_10_7 then
			local var_10_13 = var_10_2[var_10_6]

			var_10_4(var_10_13, 0, var_10_8)
			var_10_5(var_10_3, var_10_11, "enemy_count", var_10_9)

			if not var_10_12 then
				arg_10_0:_play_sector_sound_event(var_10_6, var_10_10, var_10_9, var_10_8, iter_10_1.sound_event_start)
			end
		elseif var_10_12 then
			arg_10_0:_stop_sector_sound_event(var_10_6, var_10_10, iter_10_1.sound_event_stop)
		end
	end
end

function SoundSectorSystem._update_sectors(arg_11_0, arg_11_1)
	for iter_11_0, iter_11_1 in pairs(arg_11_0._extensions) do
		local var_11_0 = arg_11_0:_calc_unit_sector(arg_11_1, iter_11_0)
		local var_11_1 = iter_11_1.sector_index

		if var_11_1 ~= var_11_0 then
			if var_11_1 then
				arg_11_0._sectors[var_11_1][iter_11_0] = nil
			end

			if var_11_0 then
				local var_11_2 = ScriptUnit.extension(iter_11_0, "death_system")

				arg_11_0._sectors[var_11_0][iter_11_0] = var_11_2
			end

			iter_11_1.sector_index = var_11_0
		end
	end
end

function SoundSectorSystem._play_sector_sound_event(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	local var_12_0 = LevelHelper:current_level_settings().terrain or "city"
	local var_12_1 = arg_12_0._sector_sound_source_units[arg_12_1]
	local var_12_2 = Managers.state.entity:system("sound_environment_system")
	local var_12_3 = arg_12_0.wwise_world
	local var_12_4 = WwiseUtils.make_unit_manual_source(var_12_3, var_12_1)

	WwiseWorld.set_switch(var_12_3, "area", var_12_0, var_12_4)
	WwiseWorld.trigger_event(var_12_3, arg_12_5, var_12_4)
	var_12_2:register_source_environment_update(var_12_4, var_12_1)

	arg_12_0._sector_sound_source_ids[arg_12_2] = var_12_4
	arg_12_0._sector_sound_source_refs[var_12_4] = (arg_12_0._sector_sound_source_refs[var_12_4] or 0) + 1
	arg_12_0.current_audio_event = arg_12_5
end

function SoundSectorSystem._stop_sector_sound_event(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0.wwise_world
	local var_13_1 = arg_13_0._sector_sound_source_ids[arg_13_2]

	Managers.state.entity:system("sound_environment_system"):unregister_source_environment_update(var_13_1)
	WwiseWorld.trigger_event(var_13_0, arg_13_3, var_13_1)

	arg_13_0._sector_sound_source_ids[arg_13_2] = nil

	local var_13_2 = arg_13_0._sector_sound_source_refs

	var_13_2[var_13_1] = var_13_2[var_13_1] - 1

	if var_13_2[var_13_1] <= 0 then
		fassert(var_13_2[var_13_1] == 0, "Sector sound source id [%d] ref count gone negative", var_13_1)

		var_13_2[var_13_1] = nil

		WwiseWorld.destroy_manual_source(var_13_0, var_13_1)
	end
end

local var_0_2 = 25
local var_0_3 = 1600

function SoundSectorSystem._calc_unit_sector(arg_14_0, arg_14_1, arg_14_2)
	if not Vector3.is_valid(arg_14_1) then
		return false
	end

	local var_14_0 = POSITION_LOOKUP[arg_14_2]
	local var_14_1 = Vector3.distance_squared(arg_14_1, var_14_0)

	if var_14_1 < var_0_2 or var_14_1 > var_0_3 then
		return false
	else
		return 1
	end
end

function SoundSectorSystem.hot_join_sync(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._extensions
	local var_15_1 = Managers.state.network.network_transmit

	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		if iter_15_1.has_target then
			local var_15_2 = arg_15_0.unit_storage:go_id(iter_15_0)

			var_15_1:send_rpc("rpc_enemy_has_target", arg_15_1, var_15_2, true)
		end
	end
end

function SoundSectorSystem.local_player_created(arg_16_0, arg_16_1)
	arg_16_0.camera_unit = arg_16_1.camera_follow_unit
end

function SoundSectorSystem.event_ai_unit_activated(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0.unit_storage:go_id(arg_17_1)
	local var_17_1 = arg_17_0._extensions[arg_17_1]

	if var_17_1 then
		var_17_1.has_target = true

		Managers.state.network.network_transmit:send_rpc_clients("rpc_enemy_has_target", var_17_0, true)
	end
end

function SoundSectorSystem.event_ai_unit_deactivated(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_0.unit_storage:go_id(arg_18_1)
	local var_18_1 = arg_18_0._extensions[arg_18_1]

	if var_18_1 then
		var_18_1.has_target = false

		Managers.state.network.network_transmit:send_rpc_clients("rpc_enemy_has_target", var_18_0, false)
	end
end

function SoundSectorSystem.rpc_enemy_has_target(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = arg_19_0.unit_storage:unit(arg_19_2)

	if var_19_0 == nil then
		return
	end

	local var_19_1 = arg_19_0._extensions[var_19_0]

	if var_19_1 then
		var_19_1.has_target = arg_19_3
	end
end
