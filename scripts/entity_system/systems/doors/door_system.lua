-- chunkname: @scripts/entity_system/systems/doors/door_system.lua

require("scripts/unit_extensions/level/door_extension")
require("scripts/unit_extensions/level/simple_door_extension")
require("scripts/unit_extensions/level/boss_door_extension")
require("scripts/unit_extensions/level/big_boy_destructible_extension")
require("scripts/unit_extensions/level/crawl_space_extension")

DoorSystem = class(DoorSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_sync_door_state",
	"rpc_sync_boss_door_state"
}
local var_0_1 = {
	"DoorExtension",
	"SimpleDoorExtension",
	"BossDoorExtension",
	"BigBoyDestructibleExtension",
	"CrawlSpaceExtension"
}

DoorSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	DoorSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0.unit_extension_data = {}
	arg_1_0._broadphase = Broadphase(127, 1.5)
	arg_1_0._boss_doors = {}
	arg_1_0._active_groups = {}
	arg_1_0._crawl_space_tunnels = {}
	arg_1_0._crawl_space_spawners = {}
end

DoorSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, ...)
	local var_2_0 = DoorSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3)

	arg_2_0.unit_extension_data[arg_2_2] = var_2_0

	local var_2_1 = Unit.world_position(arg_2_2, 0)

	if arg_2_3 ~= "CrawlSpaceExtension" then
		var_2_0.__broadphase_id = Broadphase.add(arg_2_0._broadphase, arg_2_2, var_2_1, 0.5)
	end

	if arg_2_3 == "BossDoorExtension" then
		local var_2_2 = arg_2_0._boss_doors

		for iter_2_0 = 0, 2 do
			repeat
				local var_2_3 = Unit.get_data(arg_2_2, "map_sections", iter_2_0)

				if not var_2_3 or var_2_3 == 0 then
					break
				end

				if not var_2_2[var_2_3] then
					var_2_2[var_2_3] = {}
				end

				local var_2_4 = var_2_2[var_2_3]

				var_2_4[#var_2_4 + 1] = arg_2_2
			until true
		end
	end

	if arg_2_3 == "CrawlSpaceExtension" then
		local var_2_5 = Unit.get_data(arg_2_2, "crawl_space_id")

		if var_2_5 == 0 then
			arg_2_0._crawl_space_spawners[#arg_2_0._crawl_space_spawners + 1] = var_2_0
		elseif arg_2_0._crawl_space_tunnels[var_2_5] then
			var_2_0.partner_unit = arg_2_0._crawl_space_tunnels[var_2_5].unit
			arg_2_0._crawl_space_tunnels[var_2_5].partner_unit = arg_2_2
		else
			arg_2_0._crawl_space_tunnels[var_2_5] = var_2_0
		end
	end

	return var_2_0
end

DoorSystem.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if arg_3_3 == "CrawlSpaceExtension" then
		arg_3_0._crawl_spaces_ready = true
	end
end

local var_0_2 = {}

DoorSystem.update = function (arg_4_0, arg_4_1, arg_4_2)
	DoorSystem.super.update(arg_4_0, arg_4_1, arg_4_2)

	if arg_4_0.is_server then
		table.clear(var_0_2)

		local var_4_0 = arg_4_0._active_groups
		local var_4_1 = Managers.state.entity:system("ai_group_system")

		for iter_4_0, iter_4_1 in pairs(var_4_0) do
			local var_4_2 = false

			for iter_4_2 = 1, #iter_4_1 do
				local var_4_3 = iter_4_1[iter_4_2]
				local var_4_4 = var_4_3.group_id
				local var_4_5 = var_4_3.active
				local var_4_6 = var_4_1:get_ai_group(var_4_4)

				if var_4_6 and not var_4_5 then
					var_4_3.active = true
				elseif var_4_5 and not var_4_6 then
					var_4_2 = true
				elseif var_4_5 and var_4_6 then
					local var_4_7 = var_4_6.members
					local var_4_8 = true

					for iter_4_3, iter_4_4 in pairs(var_4_7) do
						if HEALTH_ALIVE[iter_4_3] then
							local var_4_9 = BLACKBOARDS[iter_4_3]
							local var_4_10 = var_4_9.breed

							if var_4_10 and var_4_10.boss then
								local var_4_11 = arg_4_2 > (ScriptUnit.has_extension(iter_4_3, "health_system"):last_damage_t() or arg_4_2) + 60
								local var_4_12 = var_4_9.navigation_extension
								local var_4_13 = var_4_12 and var_4_12:is_following_path()

								if var_4_11 and not var_4_13 then
									var_4_8 = true
								else
									var_4_8 = false

									break
								end
							else
								var_4_8 = false

								break
							end
						end
					end

					if var_4_8 then
						var_4_2 = true
					end
				end
			end

			if var_4_2 then
				var_0_2[#var_0_2 + 1] = iter_4_0
			end
		end

		for iter_4_5 = 1, #var_0_2 do
			local var_4_14 = var_0_2[iter_4_5]

			arg_4_0:open_boss_doors(var_4_14)

			arg_4_0._active_groups[var_4_14] = nil
		end
	end
end

DoorSystem.get_doors = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	return Broadphase.query(arg_5_0._broadphase, arg_5_1, arg_5_2, arg_5_3)
end

DoorSystem.get_boss_door_units = function (arg_6_0)
	local var_6_0 = arg_6_0._boss_doors
	local var_6_1 = {}

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		for iter_6_2 = 1, #iter_6_1 do
			local var_6_2 = iter_6_1[iter_6_2]

			var_6_1[#var_6_1 + 1] = var_6_2
		end
	end

	return var_6_1
end

DoorSystem.on_remove_extension = function (arg_7_0, arg_7_1, arg_7_2)
	DoorSystem.super.on_remove_extension(arg_7_0, arg_7_1, arg_7_2)

	local var_7_0 = arg_7_0.unit_extension_data[arg_7_1]

	if arg_7_2 ~= "CrawlSpaceExtension" then
		Broadphase.remove(arg_7_0._broadphase, var_7_0.__broadphase_id)
	end

	arg_7_0.unit_extension_data[arg_7_1] = nil
end

DoorSystem.destroy = function (arg_8_0)
	arg_8_0.network_event_delegate:unregister(arg_8_0)

	arg_8_0.network_event_delegate = nil
	arg_8_0.unit_extension_data = nil
	arg_8_0._broadphase = nil
end

DoorSystem.close_boss_doors = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0._boss_doors[arg_9_1]
	local var_9_1 = Managers.state.network.network_transmit

	if var_9_0 then
		for iter_9_0 = 1, #var_9_0 do
			local var_9_2 = var_9_0[iter_9_0]

			ScriptUnit.extension(var_9_2, "door_system"):set_door_state("closed", arg_9_3)

			local var_9_3 = LevelHelper:current_level(arg_9_0.world)
			local var_9_4 = Level.unit_index(var_9_3, var_9_2)
			local var_9_5 = NetworkLookup.door_states.closed
			local var_9_6 = arg_9_3 and NetworkLookup.breeds[arg_9_3] or NetworkLookup.breeds["n/a"]

			var_9_1:send_rpc_clients("rpc_sync_boss_door_state", var_9_4, var_9_5, var_9_6)
		end

		if not arg_9_0._active_groups[arg_9_1] then
			arg_9_0._active_groups[arg_9_1] = {}
		end

		local var_9_7 = arg_9_0._active_groups[arg_9_1]

		var_9_7[#var_9_7 + 1] = {
			active = false,
			group_id = arg_9_2
		}
	end
end

DoorSystem.open_boss_doors = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._boss_doors[arg_10_1]
	local var_10_1 = Managers.state.network.network_transmit

	for iter_10_0 = 1, #var_10_0 do
		local var_10_2 = var_10_0[iter_10_0]

		ScriptUnit.extension(var_10_2, "door_system"):set_door_state("open")

		local var_10_3 = LevelHelper:current_level(arg_10_0.world)
		local var_10_4 = Level.unit_index(var_10_3, var_10_2)
		local var_10_5 = NetworkLookup.door_states.open
		local var_10_6 = NetworkLookup.breeds["n/a"]

		var_10_1:send_rpc_clients("rpc_sync_boss_door_state", var_10_4, var_10_5, var_10_6)
	end
end

DoorSystem.get_boss_door_units = function (arg_11_0)
	local var_11_0 = {}

	for iter_11_0, iter_11_1 in pairs(arg_11_0._boss_doors) do
		for iter_11_2 = 1, #iter_11_1 do
			local var_11_1 = iter_11_1[iter_11_2]

			var_11_0[#var_11_0 + 1] = var_11_1
		end
	end

	return var_11_0
end

DoorSystem.get_crawl_space_tunnel_units = function (arg_12_0, arg_12_1)
	if not arg_12_0._crawl_spaces_ready then
		return
	end

	local var_12_0 = {}

	for iter_12_0, iter_12_1 in pairs(arg_12_0._crawl_space_tunnels) do
		local var_12_1 = iter_12_1.unit
		local var_12_2 = iter_12_1.partner_unit
		local var_12_3 = ScriptUnit.extension(var_12_1, "interactable_system")
		local var_12_4 = ScriptUnit.has_extension(var_12_2, "interactable_system")

		if var_12_3:is_enabled() or arg_12_1 then
			var_12_0[#var_12_0 + 1] = var_12_1
		end

		if var_12_2 and (var_12_4:is_enabled() or arg_12_1) then
			var_12_0[#var_12_0 + 1] = var_12_2
		end
	end

	return var_12_0
end

DoorSystem.get_crawl_space_spawner_units = function (arg_13_0)
	if not arg_13_0._crawl_spaces_ready then
		return
	end

	local var_13_0 = {}

	for iter_13_0, iter_13_1 in pairs(arg_13_0._crawl_space_spawners) do
		var_13_0[#var_13_0 + 1] = iter_13_1.unit
	end

	return var_13_0
end

DoorSystem.rpc_sync_door_state = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = LevelHelper:current_level(arg_14_0.world)
	local var_14_1 = Level.unit_by_index(var_14_0, arg_14_2)
	local var_14_2 = ScriptUnit.has_extension(var_14_1, "door_system")

	if var_14_2 then
		local var_14_3 = NetworkLookup.door_states[arg_14_3]

		var_14_2:set_door_state(var_14_3)
	else
		Application.warning(string.format("[DoorSystem:rpc_sync_door_state] The synced level_object_id (%s) doesn't correspond to a unit with a 'door_system' extension. Unit: %s", arg_14_2, tostring(var_14_1)))
	end
end

DoorSystem.rpc_sync_boss_door_state = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = LevelHelper:current_level(arg_15_0.world)
	local var_15_1 = Level.unit_by_index(var_15_0, arg_15_2)
	local var_15_2 = ScriptUnit.has_extension(var_15_1, "door_system")

	if var_15_2 then
		local var_15_3 = NetworkLookup.door_states[arg_15_3]
		local var_15_4 = NetworkLookup.breeds[arg_15_4]

		var_15_2:set_door_state(var_15_3, var_15_4)
	else
		Application.warning(string.format("[DoorSystem:rpc_sync_boss_door_state] The synced level_object_id (%s) doesn't correspond to a unit with a 'door_system' extension. Unit: %s", arg_15_2, tostring(var_15_1)))
	end
end
