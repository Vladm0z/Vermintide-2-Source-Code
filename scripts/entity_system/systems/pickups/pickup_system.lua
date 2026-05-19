-- chunkname: @scripts/entity_system/systems/pickups/pickup_system.lua

require("scripts/unit_extensions/pickups/pickup_unit_extension")
require("scripts/unit_extensions/pickups/pickup_spawner_extension")

LifeTimePickupUnitExtension = class(LifeTimePickupUnitExtension, PickupUnitExtension)
LimitedOwnedPickupUnitExtension = class(LimitedOwnedPickupUnitExtension, PickupUnitExtension)
PlayerTeleportingPickupExtension = class(PlayerTeleportingPickupExtension, PickupUnitExtension)
PickupSystem = class(PickupSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_spawn_pickup_with_physics",
	"rpc_spawn_pickup",
	"rpc_finalize_consumption",
	"rpc_spawn_linked_pickup",
	"rpc_force_use_pickup",
	"rpc_delete_pickup",
	"rpc_delete_limited_owned_pickup_unit",
	"rpc_delete_limited_owned_pickups",
	"rpc_delete_limited_owned_pickup_type"
}
local var_0_1 = {
	"LifeTimePickupUnitExtension",
	"LimitedOwnedPickupUnitExtension",
	"PlayerTeleportingPickupExtension",
	"PickupUnitExtension",
	"PickupSpawnerExtension"
}

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_2 = iter_0_1.additional_system_extensions and iter_0_1.additional_system_extensions.pickup_system

	if var_0_2 then
		for iter_0_2, iter_0_3 in ipairs(var_0_2) do
			require(iter_0_3.require)

			var_0_1[#var_0_1 + 1] = iter_0_3.class
		end
	end
end

local var_0_3 = {}

DLCUtils.append("pickup_system_extension_update", var_0_3)

function PickupSystem.init(arg_1_0, arg_1_1, arg_1_2)
	PickupSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	arg_1_0._debug_spawned_pickup = {}

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0._network_manager = arg_1_1.network_manager
	arg_1_0._statistics_db = arg_1_1.statistics_db

	local var_1_1 = Managers.mechanism:get_level_seed("pickups")

	arg_1_0:set_seed(var_1_1)

	arg_1_0.guaranteed_pickup_spawners = {}
	arg_1_0.triggered_pickup_spawners = {}
	arg_1_0._next_index = 1
	arg_1_0._broadphase = Broadphase(255, 15)
	arg_1_0._broadphase_ids = {}
	arg_1_0._pickup_units_by_type = {}

	for iter_1_0, iter_1_1 in pairs(AllPickups) do
		arg_1_0._pickup_units_by_type[iter_1_0] = {}
	end

	arg_1_0.primary_pickup_spawners = {}
	arg_1_0.secondary_pickup_spawners = {}
	arg_1_0.specified_pickup_spawners = {}
	arg_1_0._teleporting_pickups = {}
	arg_1_0._life_time_pickups = {}
	arg_1_0._limited_owned_pickups = {}
	arg_1_0._pickups_marked_for_consumption = {}

	if not DEDICATED_SERVER then
		-- block empty
	end

	Managers.state.event:register(arg_1_0, "delete_limited_owned_pickups", "event_delete_limited_owned_pickups")
end

function PickupSystem._random(arg_2_0, ...)
	local var_2_0, var_2_1 = Math.next_random(arg_2_0._seed, ...)

	arg_2_0._seed = var_2_0

	return var_2_1
end

function PickupSystem._shuffle(arg_3_0, arg_3_1)
	arg_3_0._seed = table.shuffle(arg_3_1, arg_3_0._seed)
end

function PickupSystem.set_seed(arg_4_0, arg_4_1)
	fassert(arg_4_1 and type(arg_4_1) == "number", "Bad seed input!")

	arg_4_0._seed = arg_4_1
	arg_4_0._starting_seed = arg_4_1
end

function PickupSystem.on_add_extension(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, ...)
	if arg_5_3 ~= "PickupSpawnerExtension" then
		local var_5_0 = POSITION_LOOKUP[arg_5_2]
		local var_5_1 = arg_5_4.pickup_name
		local var_5_2 = Broadphase.add(arg_5_0._broadphase, arg_5_2, var_5_0, 0.1)

		arg_5_0._broadphase_ids[arg_5_2] = var_5_2

		if arg_5_3 == "PlayerTeleportingPickupExtension" then
			local var_5_3 = Managers.time:time("game")
			local var_5_4 = AllPickups[var_5_1]

			arg_5_0._teleporting_pickups[arg_5_2] = {
				line_of_sight_fails = 0,
				init_data = arg_5_4,
				next_line_of_sight_check = var_5_3 + var_5_4.teleport_time
			}
		elseif arg_5_3 == "LifeTimePickupUnitExtension" then
			local var_5_5 = Managers.time:time("game")
			local var_5_6 = AllPickups[var_5_1]

			arg_5_0._life_time_pickups[arg_5_2] = {
				init_data = arg_5_4,
				pickup_settings = var_5_6,
				life_time = var_5_5 + var_5_6.life_time
			}
		elseif arg_5_3 == "LimitedOwnedPickupUnitExtension" then
			local var_5_7 = arg_5_4.owner_peer_id

			if var_5_7 then
				local var_5_8 = arg_5_0._limited_owned_pickups

				if not var_5_8[var_5_7] then
					var_5_8[var_5_7] = {
						spawn_limit = arg_5_4.spawn_limit,
						units = {}
					}
				end

				var_5_8[var_5_7].units[#var_5_8[var_5_7].units + 1] = arg_5_2
			end

			if arg_5_0.is_server then
				Managers.level_transition_handler.transient_package_loader:add_unit(arg_5_2)
			end
		end

		if arg_5_3 == "LifeTimePickupUnitExtension" or arg_5_3 == "LimitedOwnedPickupUnitExtension" or arg_5_3 == "PlayerTeleportingPickupExtension" or arg_5_3 == "PickupUnitExtension" then
			local var_5_9 = arg_5_0._pickup_units_by_type[var_5_1]

			var_5_9[#var_5_9 + 1] = arg_5_2
		end
	end

	return PickupSystem.super.on_add_extension(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, ...)
end

function PickupSystem.game_object_initialized(arg_6_0, arg_6_1, arg_6_2)
	Managers.state.event:trigger("pickup_spawned", arg_6_1)
end

function PickupSystem.on_remove_extension(arg_7_0, arg_7_1, arg_7_2, ...)
	if arg_7_2 ~= "PickupSpawnerExtension" then
		local var_7_0 = arg_7_0._broadphase_ids
		local var_7_1 = var_7_0[arg_7_1]

		Broadphase.remove(arg_7_0._broadphase, var_7_1)

		var_7_0[arg_7_1] = nil

		if arg_7_2 == "PlayerTeleportingPickupExtension" then
			arg_7_0._teleporting_pickups[arg_7_1] = nil
		elseif arg_7_2 == "LifeTimePickupUnitExtension" then
			arg_7_0._life_time_pickups[arg_7_1] = nil
		elseif arg_7_2 == "LimitedOwnedPickupUnitExtension" and arg_7_0.is_server then
			Managers.level_transition_handler.transient_package_loader:remove_unit(arg_7_1)
		end

		if arg_7_2 == "LifeTimePickupUnitExtension" or arg_7_2 == "PlayerTeleportingPickupExtension" or arg_7_2 == "PickupUnitExtension" then
			local var_7_2 = Unit.get_data(arg_7_1, "pickup_name")
			local var_7_3 = arg_7_0._pickup_units_by_type[var_7_2]
			local var_7_4

			for iter_7_0 = 1, #var_7_3 do
				if var_7_3[iter_7_0] == arg_7_1 then
					var_7_4 = iter_7_0

					break
				end
			end

			if var_7_4 then
				table.remove(var_7_3, var_7_4)
			end
		end
	end

	return PickupSystem.super.on_remove_extension(arg_7_0, arg_7_1, arg_7_2, ...)
end

function PickupSystem.move_pickup_local_pose(arg_8_0, arg_8_1, arg_8_2)
	Unit.set_local_pose(arg_8_1, 0, arg_8_2)

	for iter_8_0 = 1, Unit.num_actors(arg_8_1) do
		local var_8_0 = Unit.actor(arg_8_1, iter_8_0 - 1)

		if var_8_0 then
			Actor.teleport_pose(var_8_0, arg_8_2)
		end
	end

	local var_8_1 = arg_8_0._broadphase_ids[arg_8_1]
	local var_8_2 = Matrix4x4.translation(arg_8_2)

	Broadphase.move(arg_8_0._broadphase, var_8_1, var_8_2)
end

function PickupSystem.get_pickups(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	return Broadphase.query(arg_9_0._broadphase, arg_9_1, arg_9_2, arg_9_3)
end

function PickupSystem.get_pickups_by_type(arg_10_0, arg_10_1)
	return arg_10_0._pickup_units_by_type[arg_10_1]
end

function PickupSystem.pickup_gizmo_spawned(arg_11_0, arg_11_1)
	if not arg_11_0.is_server and not LEVEL_EDITOR_TEST then
		return
	end

	if not Unit.is_a(arg_11_1, "units/hub_elements/pickup_spawner") and not Unit.is_a(arg_11_1, "units/hub_elements/training_dummy_spawner") then
		Application.warning("[PickupSystem] Using Old Pickup Spawner at Position %s ", Unit.local_position(arg_11_1, 0))

		return
	end

	local var_11_0 = Unit.get_data(arg_11_1, "guaranteed_spawn")
	local var_11_1 = Unit.get_data(arg_11_1, "triggered_spawn_id")

	if var_11_0 then
		arg_11_0.guaranteed_pickup_spawners[#arg_11_0.guaranteed_pickup_spawners + 1] = arg_11_1

		return
	elseif var_11_1 ~= "" then
		if not arg_11_0.triggered_pickup_spawners[var_11_1] then
			arg_11_0.triggered_pickup_spawners[var_11_1] = {}
		end

		local var_11_2 = arg_11_0.triggered_pickup_spawners[var_11_1]

		var_11_2[#var_11_2 + 1] = arg_11_1

		return
	end

	if Unit.get_data(arg_11_1, "bonus_spawner") then
		arg_11_0.secondary_pickup_spawners[#arg_11_0.secondary_pickup_spawners + 1] = arg_11_1
	else
		arg_11_0.primary_pickup_spawners[#arg_11_0.primary_pickup_spawners + 1] = arg_11_1
	end
end

function PickupSystem.specific_pickup_gizmo_spawned(arg_12_0, arg_12_1)
	if not arg_12_0.is_server and not LEVEL_EDITOR_TEST then
		return
	end

	arg_12_0.specified_pickup_spawners[#arg_12_0.specified_pickup_spawners + 1] = arg_12_1
end

function PickupSystem.activate_triggered_pickup_spawners(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.triggered_pickup_spawners[arg_13_1]

	if not var_13_0 then
		Application.warning("[PickupSystem] Attempted to trigger triggered pickups spawners with event %s but no spawners were registered to the event.", arg_13_1)

		return
	end

	local var_13_1 = #var_13_0
	local var_13_2 = "triggered"
	local var_13_3

	for iter_13_0 = 1, var_13_1 do
		var_13_3 = arg_13_0:_spawn_guaranteed_pickup(var_13_0[iter_13_0], var_13_2)
	end

	return var_13_3
end

function PickupSystem.create_checkpoint_data(arg_14_0)
	return {
		seed = arg_14_0._starting_seed,
		taken = table.clone(arg_14_0._taken)
	}
end

function PickupSystem.remove_pickups_due_to_crossroads(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = {}
	local var_15_1 = #arg_15_1
	local var_15_2 = {
		arg_15_0.primary_pickup_spawners,
		arg_15_0.secondary_pickup_spawners,
		arg_15_0.guaranteed_pickup_spawners,
		arg_15_0.triggered_pickup_spawners
	}

	for iter_15_0 = 1, #var_15_2 do
		local var_15_3 = var_15_2[iter_15_0]

		for iter_15_1 = 1, #var_15_3 do
			local var_15_4 = var_15_3[iter_15_1]
			local var_15_5 = Unit.get_data(var_15_4, "percentage_through_level") * arg_15_2

			for iter_15_2 = 1, var_15_1 do
				local var_15_6 = arg_15_1[iter_15_2]

				if var_15_5 > var_15_6[1] and var_15_5 < var_15_6[2] then
					var_15_0[#var_15_0 + 1] = iter_15_1

					break
				end
			end
		end

		for iter_15_3 = #var_15_0, 1, -1 do
			table.remove(var_15_3, var_15_0[iter_15_3])

			var_15_0[iter_15_3] = nil
		end
	end
end

function PickupSystem.setup_taken_pickups(arg_16_0, arg_16_1)
	if arg_16_1 then
		arg_16_0._taken = arg_16_1.taken
	else
		arg_16_0._taken = {}
	end
end

local var_0_4 = {}
local var_0_5 = {}

function PickupSystem.disable_spawners(arg_17_0, arg_17_1)
	table.clear(var_0_4)
	table.clear(var_0_5)

	arg_17_0._disabled_spawner_types = arg_17_0._disabled_spawner_types or {}

	for iter_17_0, iter_17_1 in ipairs(arg_17_1) do
		if not arg_17_0._disabled_spawner_types[iter_17_1] then
			for iter_17_2, iter_17_3 in pairs(arg_17_0.primary_pickup_spawners) do
				if Unit.get_data(iter_17_3, iter_17_1) then
					var_0_4[#var_0_4 + 1] = iter_17_2
				end
			end

			for iter_17_4, iter_17_5 in pairs(arg_17_0.secondary_pickup_spawners) do
				if Unit.get_data(iter_17_5, iter_17_1) then
					var_0_5[#var_0_5 + 1] = iter_17_4
				end
			end
		end

		arg_17_0._disabled_spawner_types[iter_17_1] = true
	end

	for iter_17_6 = #var_0_4, 1, -1 do
		local var_17_0 = var_0_4[iter_17_6]

		table.remove(arg_17_0.primary_pickup_spawners, var_17_0)
	end

	for iter_17_7 = #var_0_5, 1, -1 do
		local var_17_1 = var_0_5[iter_17_7]

		table.remove(arg_17_0.secondary_pickup_spawners, var_17_1)
	end
end

function PickupSystem.populate_pickups(arg_18_0, arg_18_1)
	if arg_18_1 then
		local var_18_0 = arg_18_1.seed

		arg_18_0:set_seed(var_18_0)
	end

	local var_18_1 = LevelHelper:current_level_settings()
	local var_18_2 = var_18_1.pickup_settings

	if not var_18_2 then
		Application.warning("[PickupSystem] CURRENT LEVEL HAS NO PICKUP DATA IN ITS SETTINGS, NO PICKUPS WILL SPAWN ")

		return
	end

	local var_18_3 = Managers.state.difficulty:get_difficulty()
	local var_18_4 = var_18_2[var_18_3]

	if not var_18_4 then
		Application.warning("[PickupSystem] CURRENT LEVEL HAS NO PICKUP DATA FOR CURRENT DIFFICULTY: %s, USING SETTINGS FOR EASY ", var_18_3)

		var_18_4 = var_18_2.default or var_18_2[1]
	end

	local var_18_5 = var_18_1.ignore_sections_in_pickup_spawning

	local function var_18_6(arg_19_0, arg_19_1)
		local var_19_0 = Unit.get_data(arg_19_0, "percentage_through_level")
		local var_19_1 = Unit.get_data(arg_19_1, "percentage_through_level")

		fassert(var_19_0, "Level Designer working on %s, You need to rebuild paths (pickup spawners broke)", var_18_1.display_name)
		fassert(var_19_1, "Level Designer working on %s, You need to rebuild paths (pickup spawners broke)", var_18_1.display_name)

		return var_19_0 < var_19_1
	end

	arg_18_0:spawn_guarenteed_pickups()

	local var_18_7 = Managers.state.game_mode._mutator_handler
	local var_18_8 = arg_18_0.primary_pickup_spawners
	local var_18_9 = var_18_4.primary or var_18_4
	local var_18_10 = var_18_7:pickup_settings_updated_settings(var_18_9)

	arg_18_0:_spawn_spread_pickups(var_18_8, var_18_10, var_18_6, 1, var_18_5)

	local var_18_11 = arg_18_0.secondary_pickup_spawners
	local var_18_12 = var_18_4.secondary
	local var_18_13 = var_18_7:pickup_settings_updated_settings(var_18_12)

	if var_18_13 then
		arg_18_0:_spawn_spread_pickups(var_18_11, var_18_13, var_18_6, 2, var_18_5)
	end
end

function PickupSystem.populate_specified_pickups(arg_20_0, arg_20_1)
	if arg_20_1 then
		local var_20_0 = arg_20_1.seed

		arg_20_0:set_seed(var_20_0)
	end

	arg_20_0:_spawn_specified_pickups()
end

local var_0_6 = {}
local var_0_7 = {}
local var_0_8 = {}

function PickupSystem._spawn_spread_pickups(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	table.sort(arg_21_1, arg_21_3)

	for iter_21_0, iter_21_1 in pairs(arg_21_2) do
		table.clear(var_0_6)

		if type(iter_21_1) == "table" then
			for iter_21_2, iter_21_3 in pairs(iter_21_1) do
				for iter_21_4 = 1, iter_21_3 do
					var_0_6[#var_0_6 + 1] = iter_21_2
				end
			end
		else
			for iter_21_5 = 1, iter_21_1 do
				local var_21_0 = arg_21_0:_random()
				local var_21_1 = Pickups[iter_21_0]
				local var_21_2 = 0
				local var_21_3 = false

				for iter_21_6, iter_21_7 in pairs(var_21_1) do
					var_21_2 = var_21_2 + iter_21_7.spawn_weighting

					if var_21_0 <= var_21_2 then
						var_0_6[#var_0_6 + 1] = iter_21_6
						var_21_3 = true

						break
					end
				end

				fassert(var_21_3, "Problem selecting a pickup to spawn, spawn_weighting_total = %s, spawn_value = %s", var_21_2, var_21_0)
			end
		end

		local var_21_4 = #var_0_6
		local var_21_5 = 1 / var_21_4
		local var_21_6 = 0
		local var_21_7
		local var_21_8 = 0

		if #arg_21_1 >= 2 then
			local var_21_9 = Unit.get_data(arg_21_1[1], "percentage_through_level")
			local var_21_10 = Unit.get_data(arg_21_1[#arg_21_1], "percentage_through_level")
			local var_21_11 = 1 - var_21_9 - (1 - var_21_10)

			var_21_6, var_21_5 = var_21_9, var_21_11 / var_21_4
		end

		if arg_21_5 then
			var_21_4 = 1
		end

		for iter_21_8 = 1, var_21_4 do
			table.clear(var_0_7)
			table.clear(var_0_8)

			local var_21_12 = var_21_6 + var_21_5
			local var_21_13 = #arg_21_1

			for iter_21_9 = 1, var_21_13 do
				local var_21_14 = arg_21_1[iter_21_9]
				local var_21_15 = Unit.get_data(var_21_14, "percentage_through_level")

				if arg_21_5 or var_21_6 <= var_21_15 and var_21_15 < var_21_12 or var_21_4 == iter_21_8 and var_21_15 == 1 then
					var_0_7[#var_0_7 + 1] = var_21_14
				end
			end

			var_21_6 = var_21_12

			local var_21_16 = #var_0_7

			if var_21_16 > 0 and var_21_8 >= 0 then
				local var_21_17 = var_21_4 - iter_21_8 + 1
				local var_21_18 = math.min(1 + math.ceil(var_21_8 / var_21_17), var_21_16)
				local var_21_19 = arg_21_0:_random()
				local var_21_20 = var_21_17 ~= 1 and var_21_18 == 1 and var_21_19 < NearPickupSpawnChance[iter_21_0]

				var_21_18 = arg_21_5 and #var_0_6 or var_21_18 + (var_21_20 and 1 or 0)

				arg_21_0:_shuffle(var_0_7)

				local var_21_21 = 0
				local var_21_22

				for iter_21_10 = 1, var_21_18 do
					local var_21_23 = #var_0_7
					local var_21_24
					local var_21_25

					if var_21_22 then
						local var_21_26 = Unit.get_data(var_21_22, "percentage_through_level")

						local function var_21_27(arg_22_0, arg_22_1)
							local var_22_0 = Unit.get_data(arg_22_0, "percentage_through_level")
							local var_22_1 = Unit.get_data(arg_22_1, "percentage_through_level")

							return math.abs(var_21_26 - var_22_0) < math.abs(var_21_26 - var_22_1)
						end

						table.sort(var_0_7, var_21_27)
					end

					for iter_21_11 = 1, var_21_23 do
						local var_21_28 = #var_0_6
						local var_21_29 = var_0_7[iter_21_11]

						for iter_21_12 = 1, var_21_28 do
							local var_21_30 = var_0_6[iter_21_12]

							if arg_21_0:_can_spawn(var_21_29, var_21_30) then
								local var_21_31 = AllPickups[var_21_30]
								local var_21_32, var_21_33, var_21_34 = ScriptUnit.extension(var_21_29, "pickup_system"):get_spawn_location_data()
								local var_21_35 = "spawner"
								local var_21_36, var_21_37 = arg_21_0:_spawn_pickup(var_21_31, var_21_30, var_21_32, var_21_33, false, var_21_35)

								var_21_21 = var_21_21 + 1
								var_21_24 = var_21_29
								var_21_25 = iter_21_12

								if var_21_34 then
									var_0_8[#var_0_8 + 1] = var_21_29
								end

								break
							end
						end

						if var_21_24 then
							break
						end
					end

					if var_21_24 then
						local var_21_38 = table.find(var_0_7, var_21_24)

						table.remove(var_0_7, var_21_38)
						table.remove(var_0_6, var_21_25)

						var_21_22 = var_21_24
					end
				end

				var_21_8 = var_21_8 - (var_21_21 - 1)
			else
				var_21_8 = var_21_8 + 1
			end

			local var_21_39 = #var_0_8

			for iter_21_13 = 1, var_21_39 do
				local var_21_40 = var_0_8[iter_21_13]
				local var_21_41 = table.find(arg_21_1, var_21_40)

				table.remove(arg_21_1, var_21_41)
			end
		end

		if var_21_8 > 1 then
			Application.warning("[PickupSystem] Remaining spawn debt when trying to spawn %s pickups %d", iter_21_0, var_21_8)
		end
	end
end

function PickupSystem._debug_add_spread_pickup_spawner(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = arg_23_0._debug_spread_pickup_spawners

	if not var_23_0 then
		var_23_0 = {}
		arg_23_0._debug_spread_pickup_spawners = var_23_0
	end

	local var_23_1 = var_23_0[arg_23_4]

	if not var_23_1 then
		var_23_1 = {}
		var_23_0[arg_23_4] = var_23_1
	end

	local var_23_2 = var_23_1[arg_23_1]

	if not var_23_2 then
		var_23_2 = {}
		var_23_1[arg_23_1] = var_23_2
	end

	local var_23_3 = var_23_2[arg_23_2]

	if not var_23_3 then
		var_23_3 = {}
		var_23_2[arg_23_2] = var_23_3
	end

	var_23_3[#var_23_3 + 1] = arg_23_3
end

function PickupSystem._debug_add_spread_pickup(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._debug_spread_pickups

	if not var_24_0 then
		var_24_0 = {}
		arg_24_0._debug_spread_pickups = var_24_0
	end

	var_24_0[arg_24_1] = arg_24_2
end

function PickupSystem.debug_draw_spread_pickups(arg_25_0)
	if not script_data.debug_pickup_spawners then
		Application.warning("The debug_pickup_spawners option must be set to true from the debug menu when using this feature")

		return
	end

	local var_25_0 = arg_25_0._debug_spread_pickup_spawners
	local var_25_1 = arg_25_0._debug_spread_pickups
	local var_25_2 = arg_25_0._debug_spread_pickups_draw_mode

	if not var_25_0 then
		return
	end

	if var_25_2 then
		var_25_2 = var_25_2 + 1
	else
		var_25_2 = 0
	end

	local var_25_3 = {
		healing = Colors.get("yellow"),
		potions = Colors.get("orange"),
		level_events = Colors.get("red"),
		ammo = Colors.get("green"),
		grenades = Colors.get("blue"),
		improved_grenades = Colors.get("cyan"),
		special = Colors.get("magenta"),
		lorebook_pages = Colors.get("white"),
		undefined = Colors.get("black")
	}
	local var_25_4 = {
		Colors.get("orange"),
		Colors.get("pink"),
		Colors.get("yellow"),
		Colors.get("red"),
		Colors.get("light_green"),
		Colors.get("blue"),
		Colors.get("cyan"),
		Colors.get("magenta"),
		Colors.get("white")
	}
	local var_25_5 = Managers.state.debug:drawer({
		mode = "retained",
		name = "debug_spread_pickups"
	})

	var_25_5:reset()

	if var_25_2 > 0 then
		local var_25_6 = 0
		local var_25_7 = false

		for iter_25_0, iter_25_1 in ipairs(var_25_0) do
			if var_25_7 then
				break
			end

			for iter_25_2, iter_25_3 in pairs(iter_25_1) do
				var_25_6 = var_25_6 + 1

				if var_25_6 == var_25_2 then
					local var_25_8 = 0

					for iter_25_4, iter_25_5 in pairs(iter_25_3) do
						var_25_8 = var_25_8 + 1

						if var_25_8 > #var_25_4 then
							var_25_8 = 1
						end

						local var_25_9 = var_25_4[var_25_8]

						for iter_25_6, iter_25_7 in ipairs(iter_25_5) do
							local var_25_10, var_25_11, var_25_12 = ScriptUnit.extension(iter_25_7, "pickup_system"):get_spawn_location_data()

							var_25_5:line(var_25_10, var_25_10 + Vector3(0, 0, 20), var_25_9)

							if var_25_1 and var_25_1[iter_25_7] == iter_25_2 then
								var_25_5:sphere(var_25_10 + Vector3(0, 0, 20), 0.6, var_25_9)
							end
						end
					end

					var_25_7 = true

					print("Drawing pickup spawner sections for \"" .. iter_25_2 .. "\" of priority " .. iter_25_0)

					break
				end
			end
		end

		if not var_25_7 then
			var_25_2 = 0
		end
	end

	if var_25_2 == 0 then
		print("Drawing all spawners colored by pickup type")

		for iter_25_8, iter_25_9 in ipairs(var_25_0) do
			for iter_25_10, iter_25_11 in pairs(iter_25_9) do
				for iter_25_12, iter_25_13 in pairs(iter_25_11) do
					for iter_25_14, iter_25_15 in ipairs(iter_25_13) do
						local var_25_13, var_25_14, var_25_15 = ScriptUnit.extension(iter_25_15, "pickup_system"):get_spawn_location_data()
						local var_25_16 = var_25_3[iter_25_10] or var_25_3.undefined

						var_25_5:line(var_25_13, var_25_13 + Vector3(0, 0, 20), var_25_16)

						if var_25_1 and var_25_1[iter_25_15] then
							var_25_5:sphere(var_25_13 + Vector3(0, 0, 20), 0.6, var_25_16)
						end
					end
				end
			end
		end
	end

	arg_25_0._debug_spread_pickups_draw_mode = var_25_2
end

function PickupSystem.disable_teleporting_pickups(arg_26_0)
	for iter_26_0, iter_26_1 in pairs(arg_26_0._teleporting_pickups) do
		arg_26_0._teleporting_pickups[iter_26_0] = nil
	end
end

function PickupSystem.spawn_guarenteed_pickups(arg_27_0)
	local var_27_0 = arg_27_0.guaranteed_pickup_spawners
	local var_27_1 = #var_27_0
	local var_27_2 = "guaranteed"

	for iter_27_0 = 1, var_27_1 do
		arg_27_0:_spawn_guaranteed_pickup(var_27_0[iter_27_0], var_27_2)
	end
end

local var_0_9 = {}

function PickupSystem._spawn_guaranteed_pickup(arg_28_0, arg_28_1, arg_28_2)
	table.clear(var_0_9)

	for iter_28_0, iter_28_1 in pairs(AllPickups) do
		if arg_28_0:_can_spawn(arg_28_1, iter_28_0) and iter_28_1.spawn_weighting > 0 then
			var_0_9[#var_0_9 + 1] = iter_28_0
		end
	end

	local var_28_0 = #var_0_9

	if var_28_0 > 0 then
		local var_28_1 = arg_28_0:_random(var_28_0)
		local var_28_2 = var_0_9[var_28_1]
		local var_28_3 = Unit.local_position(arg_28_1, 0)
		local var_28_4 = Unit.local_rotation(arg_28_1, 0)
		local var_28_5 = AllPickups[var_28_2]
		local var_28_6, var_28_7 = arg_28_0:_spawn_pickup(var_28_5, var_28_2, var_28_3, var_28_4, false, arg_28_2)

		return var_28_6
	end
end

function PickupSystem._spawn_specified_pickups(arg_29_0)
	local var_29_0 = arg_29_0.specified_pickup_spawners
	local var_29_1 = #var_29_0
	local var_29_2 = "guaranteed"

	for iter_29_0 = 1, var_29_1 do
		local var_29_3 = var_29_0[iter_29_0]

		table.clear(var_0_9)

		for iter_29_1, iter_29_2 in pairs(AllPickups) do
			if arg_29_0:_can_spawn(var_29_3, iter_29_1) then
				var_0_9[#var_0_9 + 1] = iter_29_1
			end
		end

		local var_29_4 = #var_0_9

		if var_29_4 > 0 then
			local var_29_5 = arg_29_0:_random(var_29_4)
			local var_29_6 = var_0_9[var_29_5]
			local var_29_7 = Unit.local_position(var_29_3, 0)
			local var_29_8 = Unit.local_rotation(var_29_3, 0)
			local var_29_9 = AllPickups[var_29_6]

			arg_29_0:_spawn_pickup(var_29_9, var_29_6, var_29_7, var_29_8, false, var_29_2)
		end
	end
end

function PickupSystem._safe_to_spawn_pickup(arg_30_0, arg_30_1)
	local var_30_0 = AllPickups[arg_30_1]
	local var_30_1 = var_30_0.unit_name

	if not Application.can_get("unit", var_30_1) then
		return false
	end

	local var_30_2 = rawget(ItemMasterList, var_30_0.item_name)

	if var_30_2 then
		local var_30_3 = var_30_2.temporary_template
		local var_30_4 = WeaponUtils.get_weapon_template(var_30_3)
		local var_30_5 = var_30_4.left_hand_unit

		if var_30_5 and (not Application.can_get("unit", var_30_5) or not Application.can_get("unit", var_30_5 .. "_3p")) then
			return false
		end

		local var_30_6 = var_30_4.right_hand_unit

		if var_30_6 and (not Application.can_get("unit", var_30_6) or not Application.can_get("unit", var_30_6 .. "_3p")) then
			return false
		end
	end

	return true
end

function PickupSystem.update(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_1.dt

	if arg_31_0.is_server then
		arg_31_0:_update_life_time_pickups(var_31_0, arg_31_2)
		arg_31_0:_update_teleporting_pickups(var_31_0, arg_31_2)
	end

	arg_31_0:_update_pickups_marked_for_consumption()

	local var_31_1 = arg_31_0._statistics_db
	local var_31_2 = arg_31_0.update_list

	for iter_31_0 = 1, #var_0_3 do
		local var_31_3 = var_0_3[iter_31_0]

		arg_31_0:update_extension(var_31_3, var_31_0, nil, arg_31_2)
	end

	for iter_31_1, iter_31_2 in pairs(arg_31_0.extensions) do
		local var_31_4 = arg_31_0.profiler_names[iter_31_1]

		for iter_31_3, iter_31_4 in pairs(var_31_2[iter_31_1].update) do
			local var_31_5 = iter_31_4.hide_func

			if not DEDICATED_SERVER and var_31_5 and var_31_5(var_31_1) and not iter_31_4.hidden then
				iter_31_4:hide()
			end
		end
	end
end

function PickupSystem.get_and_delete_limited_owned_pickup_with_index(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0._limited_owned_pickups[arg_32_1]

	if not var_32_0 then
		return nil
	end

	local var_32_1 = var_32_0.units
	local var_32_2 = table.remove(var_32_1, arg_32_2)
	local var_32_3 = Managers.state.unit_spawner
	local var_32_4 = var_32_2 and Unit.alive(var_32_2)

	if not var_32_4 or var_32_4 and var_32_3:is_marked_for_deletion(var_32_2) then
		return nil
	end

	if arg_32_0.is_server then
		arg_32_0:_delete_pickup(var_32_2)
	else
		local var_32_5 = Managers.state.network:game_object_or_level_id(var_32_2)

		Managers.state.network.network_transmit:send_rpc_server("rpc_delete_limited_owned_pickup_unit", arg_32_1, var_32_5)
	end

	return var_32_2
end

function PickupSystem.delete_limited_owned_pickup_unit(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0._limited_owned_pickups[arg_33_1]

	if not var_33_0 then
		return
	end

	local var_33_1 = var_33_0.units
	local var_33_2 = table.find(var_33_1, arg_33_2)

	if var_33_2 then
		table.remove(var_33_1, var_33_2)
	end

	local var_33_3 = Managers.state.unit_spawner
	local var_33_4 = arg_33_2 and Unit.alive(arg_33_2)

	if not var_33_4 or var_33_4 and var_33_3:is_marked_for_deletion(arg_33_2) then
		return
	end

	if arg_33_0.is_server then
		arg_33_0:_delete_pickup(arg_33_2)
	else
		local var_33_5 = Managers.state.network:game_object_or_level_id(arg_33_2)

		Managers.state.network.network_transmit:send_rpc_server("rpc_delete_limited_owned_pickup_unit", arg_33_1, var_33_5)
	end
end

function PickupSystem.event_delete_limited_owned_pickups(arg_34_0, arg_34_1)
	if arg_34_0.is_server then
		local var_34_0 = arg_34_0._limited_owned_pickups[arg_34_1]

		if not var_34_0 then
			return
		end

		local var_34_1 = var_34_0.units

		if var_34_1 then
			for iter_34_0, iter_34_1 in pairs(var_34_1) do
				arg_34_0:_delete_pickup(iter_34_1)
			end

			table.clear(var_34_1)
		end
	elseif Managers.state.network:in_game_session() then
		arg_34_0.network_transmit:send_rpc_server("rpc_delete_limited_owned_pickups", arg_34_1)
	end
end

function PickupSystem.delete_limited_owned_pickup_type(arg_35_0, arg_35_1, arg_35_2)
	if arg_35_0.is_server then
		local var_35_0 = arg_35_0._limited_owned_pickups[arg_35_1]

		if not var_35_0 then
			return
		end

		local var_35_1 = var_35_0.units
		local var_35_2 = arg_35_0._pickup_units_by_type[arg_35_2]

		if var_35_1 and var_35_2 then
			for iter_35_0 = 1, #var_35_1 do
				local var_35_3 = var_35_1[iter_35_0]

				if table.index_of(var_35_2, var_35_3) > 0 then
					arg_35_0:_delete_pickup(var_35_3)
				end
			end

			table.clear(var_35_1)
		end
	elseif Managers.state.network:in_game_session() then
		local var_35_4 = NetworkLookup.pickup_names[arg_35_2]

		arg_35_0.network_transmit:send_rpc_server("rpc_delete_limited_owned_pickup_type", arg_35_1, var_35_4)
	end
end

function PickupSystem._update_life_time_pickups(arg_36_0, arg_36_1, arg_36_2)
	for iter_36_0, iter_36_1 in pairs(arg_36_0._life_time_pickups) do
		if arg_36_2 > iter_36_1.life_time and iter_36_1.pickup_settings.on_life_over_func then
			iter_36_1.pickup_settings.on_life_over_func()

			if Unit.alive(iter_36_0) then
				Managers.state.unit_spawner:mark_for_deletion(iter_36_0)
			end
		end
	end
end

local var_0_10 = 4
local var_0_11 = -100
local var_0_12 = 3.5
local var_0_13 = 0.25

function PickupSystem._update_teleporting_pickups(arg_37_0, arg_37_1, arg_37_2)
	for iter_37_0, iter_37_1 in pairs(arg_37_0._teleporting_pickups) do
		if POSITION_LOOKUP[iter_37_0].z < var_0_11 then
			iter_37_1.next_line_of_sight_check = arg_37_2 + var_0_12
			iter_37_1.line_of_sight_fails = 0

			arg_37_0:_teleport_pickup(iter_37_0)
		elseif arg_37_2 > iter_37_1.next_line_of_sight_check then
			iter_37_1.next_line_of_sight_check = arg_37_2 + var_0_12

			if arg_37_0:_check_teleporting_pickup_line_of_sight(iter_37_0) then
				iter_37_1.line_of_sight_fails = 0
			else
				local var_37_0 = iter_37_1.line_of_sight_fails + 1

				if var_37_0 > var_0_10 then
					iter_37_1.line_of_sight_fails = 0

					arg_37_0:_teleport_pickup(iter_37_0, iter_37_1)
				else
					iter_37_1.line_of_sight_fails = var_37_0
				end
			end
		end
	end
end

local var_0_14 = 1.75
local var_0_15 = 0.25
local var_0_16 = 40
local var_0_17 = "throw"

function PickupSystem._check_teleporting_pickup_line_of_sight(arg_38_0, arg_38_1)
	local var_38_0 = Actor.position(Unit.actor(arg_38_1, var_0_17))
	local var_38_1 = World.physics_world(arg_38_0.world)

	for iter_38_0, iter_38_1 in pairs(Managers.player:players()) do
		local var_38_2 = iter_38_1.player_unit

		if HEALTH_ALIVE[var_38_2] then
			local var_38_3 = POSITION_LOOKUP[var_38_2] + Vector3(0, 0, var_0_14)
			local var_38_4 = var_38_0 - var_38_3
			local var_38_5 = Vector3.length(var_38_4)

			if var_38_5 > var_0_16 then
				-- block empty
			elseif var_38_5 > var_0_15 then
				local var_38_6 = var_38_4 / var_38_5

				if not PhysicsWorld.immediate_raycast(var_38_1, var_38_3, var_38_6, var_38_5, "closest", "collision_filter", "filter_player_mover") then
					return true
				end
			else
				return true
			end
		end
	end

	return false
end

function PickupSystem._teleport_pickup(arg_39_0, arg_39_1)
	local var_39_0

	for iter_39_0, iter_39_1 in pairs(Managers.player:human_players()) do
		local var_39_1 = iter_39_1.player_unit

		if HEALTH_ALIVE[var_39_1] then
			var_39_0 = ScriptUnit.extension(var_39_1, "locomotion_system"):last_position_on_navmesh() + Vector3(0, 0, var_0_13)

			break
		end
	end

	if var_39_0 then
		Actor.teleport_position(Unit.actor(arg_39_1, var_0_17), var_39_0)
	end
end

function PickupSystem.destroy(arg_40_0)
	Managers.state.event:unregister("delete_limited_owned_pickups", arg_40_0)
	arg_40_0.network_event_delegate:unregister(arg_40_0)
end

function PickupSystem.hot_join_sync(arg_41_0, arg_41_1)
	return
end

function PickupSystem.spawn_pickup(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7, arg_42_8)
	local var_42_0 = AllPickups[arg_42_1]
	local var_42_1
	local var_42_2
	local var_42_3, var_42_4 = arg_42_0:_spawn_pickup(var_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, var_42_1, var_42_2, arg_42_6, arg_42_7, arg_42_8)

	return var_42_3
end

function PickupSystem.spawn_pickup_async(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6, arg_43_7, arg_43_8)
	local var_43_0 = Managers.level_transition_handler.pickup_package_loader

	arg_43_2 = Vector3Box(arg_43_2)
	arg_43_3 = QuaternionBox(arg_43_3)
	arg_43_6 = arg_43_6 and Vector3Box(arg_43_6) or nil

	var_43_0:request_pickup(arg_43_1, function()
		local var_44_0 = arg_43_0:spawn_pickup(arg_43_1, arg_43_2:unbox(), arg_43_3:unbox(), arg_43_4, arg_43_5, arg_43_6 and arg_43_6:unbox() or nil, arg_43_7, arg_43_8)

		if arg_43_8 then
			arg_43_8(var_44_0)
		end
	end)
end

function PickupSystem.buff_spawn_pickup(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	if not arg_45_2 then
		return
	end

	if arg_45_3 then
		local var_45_0 = World.physics_world(arg_45_0.world)
		local var_45_1 = Vector3.down()
		local var_45_2 = 40
		local var_45_3, var_45_4, var_45_5, var_45_6 = PhysicsWorld.immediate_raycast(var_45_0, arg_45_2, var_45_1, var_45_2, "closest", "collision_filter", "filter_pickup_collision")

		if var_45_3 then
			arg_45_2 = var_45_4
		end
	end

	local var_45_7 = Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360)))
	local var_45_8 = false
	local var_45_9 = "buff"
	local var_45_10 = AllPickups[arg_45_1]
	local var_45_11, var_45_12 = arg_45_0:_spawn_pickup(var_45_10, arg_45_1, arg_45_2, var_45_7, var_45_8, var_45_9)

	if var_45_11 then
		return var_45_11
	end
end

function PickupSystem._spawn_pickup(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8, arg_46_9, arg_46_10, arg_46_11)
	if not arg_46_0.is_server then
		Crashify.print_exception("PickupSystem", "Client tried to spawn a client owned pickup '%s'. Pickups may only be spawned by the server.", arg_46_2)

		return
	end

	local var_46_0 = arg_46_0._next_index

	if arg_46_0._taken[var_46_0] then
		return
	end

	if not Managers.state.network:in_game_session() then
		return
	end

	local var_46_1 = arg_46_1.can_spawn_func

	if var_46_1 and not var_46_1(nil, arg_46_6 == "debug") then
		return
	end

	local var_46_2 = {
		pickup_system = {
			pickup_name = arg_46_2,
			has_physics = arg_46_5,
			spawn_type = arg_46_6,
			spawn_index = var_46_0,
			owner_peer_id = arg_46_7,
			spawn_limit = arg_46_8
		},
		projectile_locomotion_system = {
			network_position = AiAnimUtils.position_network_scale(arg_46_3, true),
			network_rotation = AiAnimUtils.rotation_network_scale(arg_46_4, true),
			network_velocity = AiAnimUtils.velocity_network_scale(arg_46_9 or Vector3.zero(), true),
			network_angular_velocity = AiAnimUtils.velocity_network_scale(Vector3.zero(), true)
		}
	}

	if arg_46_11 then
		table.merge_recursive(var_46_2, arg_46_11)
	end

	arg_46_0._next_index = var_46_0 + 1

	local var_46_3 = arg_46_10 or arg_46_1.unit_template_name or "pickup_unit"
	local var_46_4 = arg_46_1.additional_data_func

	if var_46_4 then
		local var_46_5
		local var_46_6 = arg_46_0[var_46_4](arg_46_0, arg_46_1, arg_46_3, arg_46_4)

		table.merge(var_46_2, var_46_6)
	end

	local var_46_7 = arg_46_1.additional_data

	if var_46_7 then
		table.merge(var_46_2, var_46_7)
	end

	local var_46_8
	local var_46_9
	local var_46_10 = arg_46_1.unit_name
	local var_46_11 = arg_46_1.spawn_override_func

	if var_46_11 then
		var_46_8, var_46_9 = var_46_11(arg_46_1, var_46_2, arg_46_3, arg_46_4)
	else
		var_46_8, var_46_9 = Managers.state.unit_spawner:spawn_network_unit(var_46_10, var_46_3, var_46_2, arg_46_3, arg_46_4)
	end

	arg_46_0:_update_limited_limited_owned_pickups(arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7)

	return var_46_8, var_46_9
end

function PickupSystem._update_limited_limited_owned_pickups(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5, arg_47_6, arg_47_7)
	local var_47_0 = arg_47_0._limited_owned_pickups[arg_47_7]

	if not var_47_0 then
		return
	end

	local var_47_1 = var_47_0.spawn_limit
	local var_47_2 = var_47_0.units

	if var_47_1 < #var_47_2 then
		local var_47_3 = 1
		local var_47_4 = table.remove(var_47_2, var_47_3)

		arg_47_0:_delete_pickup(var_47_4)
	end
end

function PickupSystem._can_spawn(arg_48_0, arg_48_1, arg_48_2)
	return Unit.get_data(arg_48_1, arg_48_2) or Managers.mechanism:can_spawn_pickup(arg_48_1, arg_48_2)
end

function PickupSystem.mark_for_consumption(arg_49_0, arg_49_1, arg_49_2)
	if not Unit.get_data(arg_49_1, "interaction_data", "only_once") then
		return
	end

	if Unit.get_data(arg_49_1, "interaction_data", "individual_pickup") then
		return
	end

	arg_49_0._pickups_marked_for_consumption[arg_49_1] = arg_49_2
end

function PickupSystem.marked_for_consumption(arg_50_0, arg_50_1)
	return arg_50_0._pickups_marked_for_consumption[arg_50_1]
end

function PickupSystem.finalize_consumption(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	if not Unit.get_data(arg_51_1, "interaction_data", "only_once") then
		return
	end

	if Unit.get_data(arg_51_1, "interaction_data", "individual_pickup") then
		return
	end

	if arg_51_0.is_server then
		if arg_51_2 then
			local var_51_0 = BLACKBOARDS[arg_51_1]

			if var_51_0 then
				Managers.state.conflict:destroy_unit(arg_51_1, var_51_0, "picked_up_interactable")
			else
				Managers.state.unit_spawner:mark_for_deletion(arg_51_1)
			end
		else
			arg_51_0._pickups_marked_for_consumption[arg_51_1] = nil
		end

		if arg_51_3 and arg_51_3 ~= "n/a" then
			local var_51_1 = Unit.local_position(arg_51_1, 0)
			local var_51_2 = Unit.local_rotation(arg_51_1, 0)
			local var_51_3 = AllPickups[arg_51_3]

			arg_51_0:_spawn_pickup(var_51_3, arg_51_3, var_51_1, var_51_2, false, "dropped", Network.peer_id())
		end
	else
		if arg_51_2 then
			Unit.set_unit_visibility(arg_51_1, false, nil, true)
		end

		local var_51_4 = Managers.state.unit_storage:go_id(arg_51_1)

		if var_51_4 then
			local var_51_5 = NetworkLookup.pickup_names[arg_51_3 or "n/a"]

			Managers.state.network.network_transmit:send_rpc_server("rpc_finalize_consumption", var_51_4, arg_51_2, var_51_5)
		end
	end
end

function PickupSystem._update_pickups_marked_for_consumption(arg_52_0)
	for iter_52_0, iter_52_1 in pairs(arg_52_0._pickups_marked_for_consumption) do
		if not ALIVE[iter_52_0] or not ALIVE[iter_52_1] then
			arg_52_0._pickups_marked_for_consumption[iter_52_0] = nil
		end
	end
end

function PickupSystem.rpc_spawn_pickup_with_physics(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	local var_53_0 = NetworkLookup.pickup_names[arg_53_2]

	fassert(AllPickups[var_53_0], "pickup name %s does not exist in Pickups table", var_53_0)

	local var_53_1 = AllPickups[var_53_0]
	local var_53_2 = NetworkLookup.pickup_spawn_types[arg_53_5]

	arg_53_0:_spawn_pickup(var_53_1, var_53_0, arg_53_3, arg_53_4, true, var_53_2)
end

function PickupSystem.rpc_spawn_pickup(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
	local var_54_0 = NetworkLookup.pickup_names[arg_54_2]

	fassert(AllPickups[var_54_0], "pickup name %s does not exist in Pickups table", var_54_0)

	local var_54_1 = CHANNEL_TO_PEER_ID[arg_54_1] or Network.peer_id()
	local var_54_2 = AllPickups[var_54_0]
	local var_54_3 = NetworkLookup.pickup_spawn_types[arg_54_5]

	arg_54_0:_spawn_pickup(var_54_2, var_54_0, arg_54_3, arg_54_4, false, var_54_3, var_54_1)
end

function PickupSystem.rpc_finalize_consumption(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	local var_55_0 = Managers.state.unit_storage:unit(arg_55_2)

	if not var_55_0 then
		return
	end

	local var_55_1 = NetworkLookup.pickup_names[arg_55_4]

	arg_55_0:finalize_consumption(var_55_0, arg_55_3, var_55_1)
end

function PickupSystem.rpc_spawn_linked_pickup(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6, arg_56_7, arg_56_8, arg_56_9, arg_56_10)
	fassert(arg_56_0.is_server, "Can only spawn linked pickups on the server!")

	local var_56_0 = NetworkLookup.pickup_names[arg_56_2]
	local var_56_1 = NetworkLookup.pickup_spawn_types[arg_56_5]
	local var_56_2 = NetworkLookup.material_settings_templates[arg_56_10]

	fassert(AllPickups[var_56_0], "pickup name %s does not exist in Pickups table", var_56_0)

	local var_56_3 = Managers.state.unit_spawner
	local var_56_4 = Managers.state.network:game_object_or_level_unit(arg_56_6, arg_56_8)
	local var_56_5 = false
	local var_56_6 = true

	if var_56_4 and Unit.alive(var_56_4) and not var_56_3:is_marked_for_deletion(var_56_4) then
		var_56_5 = true
		var_56_6 = false
	end

	local var_56_7 = {
		pickup_system = {
			material_settings_name = var_56_2
		}
	}
	local var_56_8 = CHANNEL_TO_PEER_ID[arg_56_1 or Network.peer_id()]
	local var_56_9 = AllPickups[var_56_0]
	local var_56_10, var_56_11 = arg_56_0:_spawn_pickup(var_56_9, var_56_0, arg_56_3, arg_56_4, var_56_6, var_56_1, var_56_8, arg_56_9, nil, nil, var_56_7)

	if var_56_5 then
		Managers.state.entity:system("projectile_linker_system"):link_pickup(var_56_10, arg_56_3, arg_56_4, var_56_4, arg_56_7)
		arg_56_0._network_manager.network_transmit:send_rpc_clients("rpc_link_pickup", var_56_11, arg_56_3, arg_56_4, arg_56_6, arg_56_7, arg_56_8)
	end
end

function PickupSystem._delete_pickup(arg_57_0, arg_57_1)
	local var_57_0 = Managers.state.unit_spawner

	if arg_57_1 and Unit.alive(arg_57_1) and not var_57_0:is_marked_for_deletion(arg_57_1) then
		var_57_0:mark_for_deletion(arg_57_1)
	end
end

function PickupSystem.rpc_delete_pickup(arg_58_0, arg_58_1, arg_58_2)
	local var_58_0 = Managers.state.network:game_object_or_level_unit(arg_58_2)

	arg_58_0:_delete_pickup(var_58_0)
end

function PickupSystem.rpc_delete_limited_owned_pickup_unit(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	local var_59_0 = Managers.state.network:game_object_or_level_unit(arg_59_3)

	arg_59_0:delete_limited_owned_pickup_unit(arg_59_2, var_59_0)
end

function PickupSystem.rpc_delete_limited_owned_pickups(arg_60_0, arg_60_1, arg_60_2)
	arg_60_0:event_delete_limited_owned_pickups(arg_60_2)
end

function PickupSystem.rpc_delete_limited_owned_pickup_type(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	local var_61_0 = NetworkLookup.pickup_names[arg_61_3]

	arg_61_0:delete_limited_owned_pickup_type(arg_61_2, var_61_0)
end

function PickupSystem.rpc_force_use_pickup(arg_62_0, arg_62_1, arg_62_2)
	local var_62_0 = Managers.player.is_server

	if var_62_0 then
		arg_62_0.network_transmit:send_rpc_clients("rpc_force_use_pickup", arg_62_2)
	end

	local var_62_1 = Managers.player:local_player()

	if not var_62_1 then
		return
	end

	local var_62_2 = var_62_1.player_unit

	if not var_62_2 or not Unit.alive(var_62_2) then
		return
	end

	if var_62_1.bot_player then
		return
	end

	local var_62_3 = NetworkLookup.pickup_names[arg_62_2]
	local var_62_4 = AllPickups[var_62_3]
	local var_62_5 = var_62_4.on_pick_up_func

	if var_62_5 then
		local var_62_6 = Application.main_world()

		var_62_5(var_62_6, var_62_2, var_62_0)
	end

	local var_62_7 = ScriptUnit.extension(var_62_2, "inventory_system")
	local var_62_8 = ScriptUnit.extension(var_62_2, "career_system")
	local var_62_9 = var_62_4.slot_name
	local var_62_10 = var_62_4.item_name
	local var_62_11 = var_62_7:get_wielded_slot_name()

	if var_62_4.wield_on_pickup or var_62_11 == var_62_9 then
		CharacterStateHelper.stop_weapon_actions(var_62_7, "picked_up_object")
		CharacterStateHelper.stop_career_abilities(var_62_8, "picked_up_object")
	end

	local var_62_12 = var_62_7:get_slot_data(var_62_9)
	local var_62_13 = ItemMasterList[var_62_10]

	if var_62_12 then
		var_62_7:drop_level_event_item(var_62_12)
	end

	local var_62_14
	local var_62_15 = {}

	var_62_7:add_equipment(var_62_9, var_62_13, var_62_14, var_62_15)

	if var_62_4.wield_on_pickup or var_62_11 == var_62_9 then
		local var_62_16 = var_62_4.action_on_wield

		if var_62_16 then
			BackendUtils.get_item_template(var_62_13).next_action = var_62_16
		end

		var_62_7:wield(var_62_9)
	end
end

function PickupSystem.explosive_barrel(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	local var_63_0 = AiAnimUtils.position_network_scale(arg_63_2, true)
	local var_63_1 = AiAnimUtils.rotation_network_scale(arg_63_3, true)
	local var_63_2 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
	local var_63_3 = var_63_2
	local var_63_4 = "explosive_barrel"

	return {
		projectile_locomotion_system = {
			network_position = var_63_0,
			network_rotation = var_63_1,
			network_velocity = var_63_2,
			network_angular_velocity = var_63_3
		},
		health_system = {
			in_hand = false,
			item_name = var_63_4
		}
	}
end

function PickupSystem.wizards_barrel(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	local var_64_0 = AiAnimUtils.position_network_scale(arg_64_2, true)
	local var_64_1 = AiAnimUtils.rotation_network_scale(arg_64_3, true)
	local var_64_2 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
	local var_64_3 = var_64_2
	local var_64_4 = "wizards_barrel"

	return {
		projectile_locomotion_system = {
			network_position = var_64_0,
			network_rotation = var_64_1,
			network_velocity = var_64_2,
			network_angular_velocity = var_64_3
		},
		health_system = {
			in_hand = false,
			item_name = var_64_4
		}
	}
end

function PickupSystem.training_dummy(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	local var_65_0 = AiAnimUtils.position_network_scale(arg_65_2, true)
	local var_65_1 = AiAnimUtils.rotation_network_scale(arg_65_3, true)
	local var_65_2 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
	local var_65_3 = var_65_2
	local var_65_4 = "training_dummy"

	return {
		projectile_locomotion_system = {
			network_position = var_65_0,
			network_rotation = var_65_1,
			network_velocity = var_65_2,
			network_angular_velocity = var_65_3
		},
		health_system = {
			in_hand = false,
			item_name = var_65_4
		}
	}
end

function PickupSystem.set_taken(arg_66_0, arg_66_1)
	if arg_66_0.is_server then
		arg_66_0._taken[arg_66_1] = true
	end
end
