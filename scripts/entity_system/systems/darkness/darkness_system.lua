-- chunkname: @scripts/entity_system/systems/darkness/darkness_system.lua

require("scripts/settings/level_settings")

DarknessSystem = class(DarknessSystem, ExtensionSystemBase)

local var_0_0 = {
	"LightSourceExtension",
	"PlayerUnitDarknessExtension",
	"ShadowFlareExtension"
}
local var_0_1 = {
	"rpc_shadow_flare_done"
}

DarknessSystem.DARKNESS_THRESHOLD = 0.025
DarknessSystem.TOTAL_DARKNESS_TRESHOLD = 0.0125

function DarknessSystem.init(arg_1_0, arg_1_1, arg_1_2)
	DarknessSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0._light_source_data = {}
	arg_1_0._player_unit_darkness_data = {}
	arg_1_0._screen_fx_name = "fx/screenspace_darkness_flash"

	local var_1_0 = LevelHelper:current_level_settings().darkness_settings

	if var_1_0 then
		local var_1_1 = var_1_0.volumes

		fassert(var_1_1, "Missing volumes table in darkness settings.")

		arg_1_0._darkness_volumes = var_1_1
		arg_1_0._num_volumes = #var_1_1

		local var_1_2 = var_1_0.player_light_intensity

		if var_1_2 then
			arg_1_0:set_player_light_intensity(var_1_2)
		end

		if var_1_0.disable_screen_fx then
			arg_1_0._screen_fx_name = nil
		end
	else
		arg_1_0._num_volumes = 0
	end

	arg_1_0._in_darkness = false
	arg_1_0._global_darkness = false
	arg_1_0._network_event_delegate = arg_1_1.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_1))
end

function DarknessSystem.set_global_darkness(arg_2_0, arg_2_1)
	arg_2_0._global_darkness = arg_2_1
end

function DarknessSystem.set_player_light_intensity(arg_3_0, arg_3_1)
	arg_3_0._player_light_intensity = arg_3_1
end

function DarknessSystem.set_level(arg_4_0, arg_4_1)
	arg_4_0._level = arg_4_1
end

function DarknessSystem.destroy(arg_5_0)
	arg_5_0._environment_handler = nil

	arg_5_0._network_event_delegate:unregister(arg_5_0)
end

function DarknessSystem.on_add_extension(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_3 == "ShadowFlareExtension" then
		return DarknessSystem.super.on_add_extension(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	end

	local var_6_0 = Unit.get_data(arg_6_2, "light_intensity")
	local var_6_1 = {
		intensity = arg_6_4 and arg_6_4.intensity or var_6_0 or 1
	}

	ScriptUnit.set_extension(arg_6_2, arg_6_0.name, var_6_1)

	if arg_6_3 == "LightSourceExtension" then
		arg_6_0._light_source_data[arg_6_2] = var_6_1
		POSITION_LOOKUP[arg_6_2] = Unit.world_position(arg_6_2, 0)
	elseif arg_6_3 == "PlayerUnitDarknessExtension" then
		arg_6_0._player_unit_darkness_data[arg_6_2] = var_6_1
	end

	return var_6_1
end

function DarknessSystem.on_remove_extension(arg_7_0, arg_7_1, arg_7_2)
	DarknessSystem.super.on_remove_extension(arg_7_0, arg_7_1, arg_7_2)

	if arg_7_2 == "LightSourceExtension" then
		arg_7_0._light_source_data[arg_7_1] = nil
		POSITION_LOOKUP[arg_7_1] = nil
	elseif arg_7_2 == "PlayerUnitDarknessExtension" then
		arg_7_0._player_unit_darkness_data[arg_7_1] = nil
	end
end

function DarknessSystem.update(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1.dt

	if arg_8_0._darkness_volumes or arg_8_0._global_darkness then
		arg_8_0:_update_light_sources(var_8_0, arg_8_2)
		arg_8_0:_update_player_unit_darkness(var_8_0, arg_8_2)
		arg_8_0:_update_darkness_fx(var_8_0, arg_8_2)
	end

	arg_8_0:_update_shadow_flare_extensions(var_8_0, arg_8_2)
end

function DarknessSystem._update_light_sources(arg_9_0, arg_9_1, arg_9_2)
	return
end

local var_0_2

LIGHT_LIGHT_VALUE = 0.05

local var_0_3 = 0.015
local var_0_4 = 0.15

local function var_0_5(arg_10_0)
	return (1 - arg_10_0 / var_0_3)^2 / 15
end

function DarknessSystem._update_player_unit_darkness(arg_11_0, arg_11_1, arg_11_2)
	for iter_11_0, iter_11_1 in pairs(arg_11_0._player_unit_darkness_data) do
		local var_11_0 = (POSITION_LOOKUP[iter_11_0] or Unit.world_position(iter_11_0, 0)) + Vector3(0, 0, 1)
		local var_11_1 = arg_11_0:is_in_darkness_volume(var_11_0)
		local var_11_2

		if var_11_1 then
			local var_11_3 = Managers.state.side.side_by_unit[iter_11_0]

			if var_11_3 then
				local var_11_4 = arg_11_0:calculate_light_value(var_11_0, var_11_3.PLAYER_UNITS)

				if var_11_4 > LIGHT_LIGHT_VALUE then
					iter_11_1.intensity = 0
					iter_11_1.in_darkness = false
				elseif var_11_4 > var_0_3 then
					iter_11_1.intensity = math.auto_lerp(LIGHT_LIGHT_VALUE, var_0_3, 0, var_0_4, var_11_4)
					iter_11_1.in_darkness = true
				else
					iter_11_1.intensity = math.min(math.max(iter_11_1.intensity, var_0_4) + arg_11_1 * var_0_5(var_11_4), 1)
					iter_11_1.in_darkness = true
				end
			end
		else
			iter_11_1.in_darkness = false
			iter_11_1.intensity = 0
		end
	end
end

local var_0_6 = 0

function DarknessSystem._update_darkness_fx(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = Managers.player:local_player(1)

	if var_12_0 then
		local var_12_1 = arg_12_0.world
		local var_12_2 = var_12_0:observed_unit()

		if not ALIVE[var_12_2] then
			var_12_2 = var_12_0.player_unit
		end

		local var_12_3 = arg_12_0._player_unit_darkness_data[var_12_2]
		local var_12_4 = var_12_3 and var_12_3.in_darkness
		local var_12_5 = var_12_3 and var_12_3.intensity or 0
		local var_12_6 = Managers.world:wwise_world(var_12_1)

		if not var_12_4 and arg_12_0._in_darkness then
			WwiseWorld.trigger_event(var_12_6, "Stop_music_darkness_will_take_you", var_0_6)

			arg_12_0._in_darkness = false

			WwiseWorld.set_source_parameter(var_12_6, var_0_6, "darkness_intensity", 0)

			local var_12_7 = arg_12_0._screen_fx_id

			if var_12_7 then
				World.destroy_particles(var_12_1, var_12_7)
			end
		elseif var_12_4 and not arg_12_0._in_darkness then
			WwiseWorld.trigger_event(var_12_6, "Play_music_darkness_will_take_you", var_0_6)

			arg_12_0._in_darkness = true

			WwiseWorld.set_source_parameter(var_12_6, var_0_6, "darkness_intensity", var_12_5 * 100)

			local var_12_8 = arg_12_0._screen_fx_name

			if var_12_8 then
				local var_12_9 = World.create_particles(var_12_1, var_12_8, Vector3.zero())
				local var_12_10 = "overlay"
				local var_12_11 = "intensity"

				World.set_particles_material_scalar(var_12_1, var_12_9, var_12_10, var_12_11, var_12_5)

				arg_12_0._screen_fx_id = var_12_9
			end
		elseif var_12_4 then
			WwiseWorld.set_source_parameter(var_12_6, var_0_6, "darkness_intensity", var_12_5 * 100)

			local var_12_12 = arg_12_0._screen_fx_id

			if var_12_12 then
				local var_12_13 = "overlay"
				local var_12_14 = "intensity"

				World.set_particles_material_scalar(var_12_1, var_12_12, var_12_13, var_12_14, var_12_5)
			end
		end
	end
end

function DarknessSystem.is_in_darkness_volume(arg_13_0, arg_13_1)
	if arg_13_0._global_darkness then
		return true
	end

	local var_13_0 = arg_13_0._darkness_volumes

	if var_13_0 then
		local var_13_1 = Level.is_point_inside_volume
		local var_13_2 = arg_13_0._level

		for iter_13_0 = 1, arg_13_0._num_volumes do
			local var_13_3 = var_13_0[iter_13_0]

			if var_13_1(var_13_2, var_13_3, arg_13_1) then
				return true
			end
		end
	end

	return false
end

function DarknessSystem.calculate_light_value(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = 0

	for iter_14_0, iter_14_1 in pairs(arg_14_0._light_source_data) do
		local var_14_1 = POSITION_LOOKUP[iter_14_0]
		local var_14_2 = math.max(Vector3.distance_squared(arg_14_1, var_14_1), 1)

		var_14_0 = var_14_0 + iter_14_1.intensity * (1 / var_14_2)
	end

	local var_14_3 = arg_14_0._player_light_intensity

	if arg_14_0._player_light_intensity then
		local var_14_4 = math.huge

		for iter_14_2 = 1, #arg_14_2 do
			local var_14_5 = arg_14_2[iter_14_2]
			local var_14_6 = POSITION_LOOKUP[var_14_5]
			local var_14_7 = math.max(Vector3.distance_squared(var_14_6, arg_14_1), 1)

			if var_14_7 < var_14_4 then
				var_14_4 = var_14_7
			end
		end

		var_14_0 = var_14_0 + var_14_3 * (1 / var_14_4)
	end

	return var_14_0
end

function DarknessSystem.is_in_darkness(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0:is_in_darkness_volume(arg_15_1) then
		return false
	end

	local var_15_0 = Managers.state.side:get_side_from_name("heroes")

	return arg_15_0:calculate_light_value(arg_15_1, var_15_0.PLAYER_UNITS) < (arg_15_2 or DarknessSystem.DARKNESS_THRESHOLD)
end

function DarknessSystem._update_shadow_flare_extensions(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = Managers.state.entity:get_entities("ShadowFlareExtension")

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		iter_16_1:update(iter_16_0, arg_16_1)
	end
end

function DarknessSystem.remove_mutator_torches(arg_17_0)
	local var_17_0 = Managers.player:local_player().player_unit
	local var_17_1 = arg_17_0._light_source_data

	if Managers.player.is_server then
		Managers.state.entity:system("pickup_system"):disable_teleporting_pickups()

		for iter_17_0, iter_17_1 in pairs(var_17_1) do
			local var_17_2 = ScriptUnit.has_extension(iter_17_0, "pickup_system")

			if var_17_2 and var_17_2.pickup_name == "mutator_torch" then
				Managers.state.unit_spawner:mark_for_deletion(iter_17_0)
			end
		end
	end

	if Unit.alive(var_17_0) then
		local var_17_3 = ScriptUnit.has_extension(var_17_0, "inventory_system")

		if var_17_3 then
			local var_17_4 = var_17_3:get_wielded_slot_name()
			local var_17_5 = var_17_3:get_slot_data(var_17_4)

			if var_17_5 then
				local var_17_6 = var_17_5.item_data

				if (var_17_6 and var_17_6.name) == "mutator_torch" then
					CharacterStateHelper.stop_weapon_actions(var_17_3, "wield")
					var_17_3:destroy_slot("slot_level_event", true)
					var_17_3:wield("slot_melee")
				end
			end
		end
	end
end

function DarknessSystem.shadow_flares_on_ground(arg_18_0)
	return Managers.state.entity:get_entities("ShadowFlareExtension")
end

function DarknessSystem.rpc_shadow_flare_done(arg_19_0, arg_19_1, arg_19_2)
	if arg_19_0.is_server then
		local var_19_0 = Managers.state.network
		local var_19_1 = CHANNEL_TO_PEER_ID[arg_19_1]

		var_19_0.network_transmit:send_rpc_clients_except("rpc_shadow_flare_done", var_19_1, arg_19_2)
	end

	local var_19_2 = Managers.state.unit_storage:unit(arg_19_2)
	local var_19_3 = ScriptUnit.extension(var_19_2, "darkness_system")

	if var_19_3 then
		var_19_3:set_flare_done()
	end
end
