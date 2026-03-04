-- chunkname: @scripts/settings/mutators/mutator_skulls_2023.lua

local var_0_0 = "skulls_2023"
local var_0_1 = 5
local var_0_2 = {
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
		local var_1_0 = Managers.state.entity:system("pickup_system")
		local var_1_1 = {}
		local var_1_2 = false
		local var_1_3 = "spawner"
		local var_1_4 = var_1_0.primary_pickup_spawners

		for iter_1_0 = 1, #var_1_4 do
			local var_1_5 = var_1_4[iter_1_0]
			local var_1_6, var_1_7 = ScriptUnit.extension(var_1_5, "pickup_system"):get_spawn_location_data()

			var_1_1[var_1_0:spawn_pickup(var_0_0, var_1_6, var_1_7, var_1_2, var_1_3)] = true
		end

		local var_1_8 = var_1_0.secondary_pickup_spawners

		for iter_1_1 = 1, #var_1_8 do
			local var_1_9 = var_1_8[iter_1_1]
			local var_1_10, var_1_11 = ScriptUnit.extension(var_1_9, "pickup_system"):get_spawn_location_data()

			var_1_1[var_1_0:spawn_pickup(var_0_0, var_1_10, var_1_11, var_1_2, var_1_3)] = true
		end

		arg_1_1.pickup_units = var_1_1
		arg_1_1.num_skulls_picked = 0
		arg_1_1.mission_giver_unit = Managers.state.entity:system("surrounding_aware_system"):request_global_listener("inn_keeper", "player")

		arg_1_1.on_skull_picked_up = function ()
			arg_1_1.num_skulls_picked = arg_1_1.num_skulls_picked + 1

			if arg_1_1.num_skulls_picked >= var_0_1 then
				local var_2_0 = Managers.state.game_mode._mutator_handler

				var_2_0:initialize_mutators(var_0_2)

				for iter_2_0 = 1, #var_0_2 do
					var_2_0:activate_mutator(var_0_2[iter_2_0])
				end

				Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_skulls_event_mutator_extra_hordes")
				Managers.state.event:unregister("register_skulls_2023_pickup", arg_1_1)
			end
		end

		Managers.state.event:register(arg_1_1, "register_skulls_2023_pickup", "on_skull_picked_up")
	end,
	server_stop_function = function (arg_3_0, arg_3_1)
		if arg_3_1.pickup_units then
			for iter_3_0 in pairs(arg_3_1.pickup_units) do
				if Unit.alive(iter_3_0) then
					Managers.state.unit_spawner:mark_for_deletion(iter_3_0)
				end
			end

			arg_3_1.pickup_units = nil
		end

		if arg_3_1.mission_giver_unit then
			Managers.state.unit_spawner:mark_for_deletion(arg_3_1.mission_giver_unit)
		end

		Managers.state.event:unregister("register_skulls_2023_pickup", arg_3_1)
	end
}
