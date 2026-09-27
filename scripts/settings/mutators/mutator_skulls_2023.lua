-- chunkname: @scripts/settings/mutators/mutator_skulls_2023.lua

local str = "skulls_2023"
local num = 5
local tbl = {
	"hordes_galore"
}

return {
	description = "description_mutator_skulls_2023",
	display_name = "display_name_mutator_skulls_2023",
	icon = "mutator_icon_skulls_2023",
	packages = {
		"resource_packages/dlcs/skulls_2023_event"
	},
	dialogue_settings = {
		"dialogues/generated/npc_dlc_event_skulls"
	},
	server_start_function = function (arg_1_0, arg_1_1)
		-- function 1
		local system = Managers.state.entity:system("pickup_system")
		local tbl_2 = {}
		local flag = false
		local str_2 = "spawner"
		local primary_pickup_spawners = system.primary_pickup_spawners

		for i = 1, #primary_pickup_spawners do
			local var_1_5 = primary_pickup_spawners[i]
			local get_spawn_location_data, var_1_7 = ScriptUnit.extension(var_1_5, "pickup_system"):get_spawn_location_data()

			tbl_2[system:spawn_pickup(str, get_spawn_location_data, var_1_7, flag, str_2)] = true
		end

		local secondary_pickup_spawners = system.secondary_pickup_spawners

		for j = 1, #secondary_pickup_spawners do
			local var_1_9 = secondary_pickup_spawners[j]
			local get_spawn_location_data_2, var_1_11 = ScriptUnit.extension(var_1_9, "pickup_system"):get_spawn_location_data()

			tbl_2[system:spawn_pickup(str, get_spawn_location_data_2, var_1_11, flag, str_2)] = true
		end

		arg_1_1.pickup_units = tbl_2
		arg_1_1.num_skulls_picked = 0
		arg_1_1.mission_giver_unit = Managers.state.entity:system("surrounding_aware_system"):request_global_listener("inn_keeper", "player")

		arg_1_1.on_skull_picked_up = function ()
			-- function 2
			arg_1_1.num_skulls_picked = arg_1_1.num_skulls_picked + 1

			if arg_1_1.num_skulls_picked >= num then
				local _mutator_handler = Managers.state.game_mode._mutator_handler

				_mutator_handler:initialize_mutators(tbl)

				for i = 1, #tbl do
					_mutator_handler:activate_mutator(tbl[i])
				end

				Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_skulls_event_mutator_extra_hordes")
				Managers.state.event:unregister("register_skulls_2023_pickup", arg_1_1)
			end
		end

		Managers.state.event:register(arg_1_1, "register_skulls_2023_pickup", "on_skull_picked_up")
	end,
	server_stop_function = function (arg_3_0, arg_3_1)
		-- function 3
		if not arg_3_1.pickup_units then
			for k in pairs(arg_3_1.pickup_units) do
				if not Unit.alive(k) then
					Managers.state.unit_spawner:mark_for_deletion(k)
				end
			end

			arg_3_1.pickup_units = nil
		end

		if not arg_3_1.mission_giver_unit then
			Managers.state.unit_spawner:mark_for_deletion(arg_3_1.mission_giver_unit)
		end

		Managers.state.event:unregister("register_skulls_2023_pickup", arg_3_1)
	end
}
