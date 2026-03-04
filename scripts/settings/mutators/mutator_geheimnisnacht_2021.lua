-- chunkname: @scripts/settings/mutators/mutator_geheimnisnacht_2021.lua

local var_0_0 = require("scripts/settings/dlcs/geheimnisnacht_2025/geheimnisnacht_utils")
local var_0_1 = require("scripts/settings/dlcs/geheimnisnacht_2025/geheimnisnacht_map_settings")
local var_0_2 = {
	skaven = {
		"skaven_plague_monk",
		"skaven_clan_rat",
		"skaven_plague_monk",
		"skaven_clan_rat",
		"skaven_plague_monk",
		"skaven_clan_rat"
	},
	chaos = {
		"chaos_marauder",
		"chaos_marauder",
		"chaos_marauder",
		"chaos_marauder",
		"chaos_marauder"
	}
}
local var_0_3 = table.keys(var_0_2)
local var_0_4 = {
	"geheimnisnacht_2021_hard_mode"
}

local function var_0_5()
	local var_1_0 = Managers.state.game_mode._mutator_handler

	var_1_0:initialize_mutators(var_0_4)

	for iter_1_0 = 1, #var_0_4 do
		var_1_0:activate_mutator(var_0_4[iter_1_0])
	end
end

local function var_0_6()
	local var_2_0 = Managers.state.game_mode._mutator_handler

	for iter_2_0 = 1, #var_0_4 do
		local var_2_1 = var_0_4[iter_2_0]

		if var_2_0:has_activated_mutator(var_2_1) then
			var_2_0:deactivate_mutator(var_2_1)
		end
	end
end

return {
	description = "description_mutator_geheimnisnacht_2021",
	display_name = "display_name_mutator_geheimnisnacht_2021",
	icon = "mutator_icon_death_spirits",
	packages = {
		"resource_packages/dlcs/geheimnisnacht_2021_event"
	},
	server_start_function = function (arg_3_0, arg_3_1)
		local var_3_0 = Managers.backend:get_interface("live_events")
		local var_3_1 = var_3_0 and var_3_0:get_active_events()
		local var_3_2
		local var_3_3

		if var_3_1 then
			for iter_3_0 = 1, #var_3_1 do
				local var_3_4 = var_3_1[iter_3_0]

				var_3_2 = var_0_0.maps_by_event(var_3_4)

				if not var_3_3 and string.find(var_3_4, "geheimnisnacht_%d+") then
					var_3_3 = var_3_4
				end
			end
		end

		if not var_3_2 and var_3_3 then
			var_3_2 = var_0_0.maps_by_event(var_3_3, true)
		end

		if not var_3_2 then
			return
		end

		local var_3_5 = Managers.state.game_mode:level_key()

		if not table.contains(var_3_2, var_3_5) then
			return
		end

		local var_3_6 = var_0_1[var_3_5].ritual_locations
		local var_3_7 = Vector3.up()

		for iter_3_1 = 1, #var_3_6 do
			local var_3_8 = var_3_6[iter_3_1]
			local var_3_9 = Vector3(var_3_8[1], var_3_8[2], var_3_8[3])
			local var_3_10 = Quaternion.axis_angle(var_3_7, math.rad(var_3_8[4]))

			arg_3_1.template.spawn_ritual_ring(var_3_9, var_3_10)
		end

		Managers.state.entity:system("inventory_system"):register_event_objective("wpn_geheimnisnacht_2021_side_objective", var_0_5, var_0_6)
	end,
	spawn_ritual_ring = function (arg_4_0, arg_4_1)
		local var_4_0 = "units/gameplay/ritual_site_01"
		local var_4_1 = {
			health_system = {
				damage_cap_per_hit = 1,
				health = 15
			},
			death_system = {
				death_reaction_template = "geheimnisnacht_2021_altar"
			},
			hit_reaction_system = {
				hit_reaction_template = "level_object"
			}
		}
		local var_4_2 = Managers.state.unit_spawner:spawn_network_unit(var_4_0, "geheimnisnacht_2021_altar", var_4_1, arg_4_0, arg_4_1)
		local var_4_3 = 2.5
		local var_4_4 = {
			"idle_pray_01",
			"idle_pray_02",
			"idle_pray_03",
			"idle_pray_04",
			"idle_pray_05"
		}
		local var_4_5 = {
			far_off_despawn_immunity = true,
			ignore_breed_limits = true,
			spawned_func = function (arg_5_0, arg_5_1, arg_5_2)
				ScriptUnit.extension(arg_5_0, "ai_system"):set_perception("perception_regular", "pick_closest_target_with_spillover_wakeup_group")

				local var_5_0 = BLACKBOARDS[arg_5_0]

				if var_5_0 then
					var_5_0.ignore_interest_points = true
					var_5_0.only_trust_your_own_eyes = true
				end

				Managers.state.entity:system("buff_system"):add_buff(arg_5_0, "geheimnisnacht_2021_event_cultist_buff", arg_5_0)

				if arg_5_1 == Breeds.chaos_marauder and ScriptUnit.has_extension(arg_5_0, "ai_inventory_system") then
					local var_5_1 = Managers.state.network
					local var_5_2 = var_5_1:unit_game_object_id(arg_5_0)

					var_5_1.network_transmit:send_rpc_all("rpc_ai_inventory_wield", var_5_2, 1)
				end
			end
		}
		local var_4_6 = "event"
		local var_4_7 = "event"
		local var_4_8 = var_0_3[math.random(#var_0_3)]
		local var_4_9 = var_0_2[var_4_8]
		local var_4_10 = #var_4_9
		local var_4_11
		local var_4_12 = Managers.state.conflict
		local var_4_13 = Vector3.forward() * var_4_3
		local var_4_14 = Vector3.up()
		local var_4_15 = Quaternion.axis_angle(var_4_14, math.pi)
		local var_4_16 = math.pi * 2 / var_4_10
		local var_4_17 = {
			template = "geheimnisnacht_2021_altar_cultists",
			id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
			size = var_4_10
		}

		for iter_4_0 = 1, var_4_10 do
			local var_4_18 = Breeds[var_4_9[iter_4_0]]
			local var_4_19 = table.shallow_copy(var_4_5)

			var_4_19.idle_animation = var_4_4[math.random(#var_4_4)]

			local var_4_20 = Quaternion.multiply(arg_4_1, Quaternion.axis_angle(var_4_14, var_4_16 * (iter_4_0 - 1)))
			local var_4_21 = arg_4_0 + Quaternion.rotate(var_4_20, var_4_13)
			local var_4_22 = Quaternion.multiply(var_4_20, var_4_15)

			var_4_12:spawn_queued_unit(var_4_18, Vector3Box(var_4_21), QuaternionBox(var_4_22), var_4_6, var_4_11, var_4_7, var_4_19, var_4_17)
		end

		local var_4_23 = ScriptUnit.extension(var_4_2, "props_system")

		var_4_23:assign_cultist_group_id(var_4_17.id)
		var_4_23:setup_faction(var_4_8)
	end
}
