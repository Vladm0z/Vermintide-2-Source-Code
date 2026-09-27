-- chunkname: @scripts/settings/mutators/mutator_geheimnisnacht_2021.lua

local scripts_settings_dlcs_geheimnisnacht_2025_geheimnisnacht_utils = require("scripts/settings/dlcs/geheimnisnacht_2025/geheimnisnacht_utils")
local scripts_settings_dlcs_geheimnisnacht_2025_geheimnisnacht_map_settings = require("scripts/settings/dlcs/geheimnisnacht_2025/geheimnisnacht_map_settings")
local tbl = {
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
local keys = table.keys(tbl)
local tbl_2 = {
	"geheimnisnacht_2021_hard_mode"
}

local function fn()
	-- function 1
	local _mutator_handler = Managers.state.game_mode._mutator_handler

	_mutator_handler:initialize_mutators(tbl_2)

	for i = 1, #tbl_2 do
		_mutator_handler:activate_mutator(tbl_2[i])
	end
end

local function fn_2()
	-- function 2
	local _mutator_handler = Managers.state.game_mode._mutator_handler

	for i = 1, #tbl_2 do
		local var_2_1 = tbl_2[i]

		if not _mutator_handler:has_activated_mutator(var_2_1) then
			_mutator_handler:deactivate_mutator(var_2_1)
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
		-- function 3
		local get_interface = Managers.backend:get_interface("live_events")
		local flag = not get_interface and get_interface:get_active_events()
		local var_3_2
		local var_3_3

		if not flag then
			for i = 1, #flag do
				local var_3_4 = flag[i]

				var_3_2 = scripts_settings_dlcs_geheimnisnacht_2025_geheimnisnacht_utils.maps_by_event(var_3_4, true)

				if var_3_3 or not string.find(var_3_4, "geheimnisnacht_%d+") then
					var_3_3 = var_3_4
				end
			end
		end

		if var_3_2 or not var_3_3 then
			var_3_2 = scripts_settings_dlcs_geheimnisnacht_2025_geheimnisnacht_utils.maps_by_event(var_3_3, true)
		end

		if not var_3_2 then
			return
		end

		local level_key = Managers.state.game_mode:level_key()

		if not table.contains(var_3_2, level_key) then
			return
		end

		local ritual_locations = scripts_settings_dlcs_geheimnisnacht_2025_geheimnisnacht_map_settings[level_key].ritual_locations
		local up = Vector3.up()

		for j = 1, #ritual_locations do
			local var_3_8 = ritual_locations[j]
			local var_3_9 = Vector3(var_3_8[1], var_3_8[2], var_3_8[3])
			local axis_angle = Quaternion.axis_angle(up, math.rad(var_3_8[4]))

			arg_3_1.template.spawn_ritual_ring(var_3_9, axis_angle)
		end

		Managers.state.entity:system("inventory_system"):register_event_objective("wpn_geheimnisnacht_2021_side_objective", fn, fn_2)
	end,
	spawn_ritual_ring = function (arg_4_0, arg_4_1)
		-- function 4
		local str = "units/gameplay/ritual_site_01"
		local tbl_2 = {
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
		local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "geheimnisnacht_2021_altar", tbl_2, arg_4_0, arg_4_1)
		local num = 2.5
		local tbl_3 = {
			"idle_pray_01",
			"idle_pray_02",
			"idle_pray_03",
			"idle_pray_04",
			"idle_pray_05"
		}
		local tbl_4 = {
			far_off_despawn_immunity = true,
			ignore_breed_limits = true,
			spawned_func = function (arg_5_0, arg_5_1, arg_5_2)
				-- function 5
				ScriptUnit.extension(arg_5_0, "ai_system"):set_perception("perception_regular", "pick_closest_target_with_spillover_wakeup_group")

				local var_5_0 = BLACKBOARDS[arg_5_0]

				if not var_5_0 then
					var_5_0.ignore_interest_points = true
					var_5_0.only_trust_your_own_eyes = true
				end

				Managers.state.entity:system("buff_system"):add_buff(arg_5_0, "geheimnisnacht_2021_event_cultist_buff", arg_5_0)

				if arg_5_1 ~= Breeds.chaos_marauder or not ScriptUnit.has_extension(arg_5_0, "ai_inventory_system") then
					local network = Managers.state.network
					local unit_game_object_id = network:unit_game_object_id(arg_5_0)

					network.network_transmit:send_rpc_all("rpc_ai_inventory_wield", unit_game_object_id, 1)
				end
			end
		}
		local str_2 = "event"
		local str_3 = "event"
		local var_4_8 = keys[math.random(#keys)]
		local var_4_9 = tbl[var_4_8]
		local count = #var_4_9
		local var_4_11
		local conflict = Managers.state.conflict
		local num_2 = Vector3.forward() * num
		local up = Vector3.up()
		local axis_angle = Quaternion.axis_angle(up, math.pi)
		local num_3 = math.pi * 2 / count
		local tbl_5 = {
			template = "geheimnisnacht_2021_altar_cultists",
			id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
			size = count
		}

		for i = 1, count do
			local var_4_18 = Breeds[var_4_9[i]]
			local shallow_copy = table.shallow_copy(tbl_4)

			shallow_copy.idle_animation = tbl_3[math.random(#tbl_3)]

			local multiply = Quaternion.multiply(arg_4_1, Quaternion.axis_angle(up, num_3 * (i - 1)))
			local num_4 = arg_4_0 + Quaternion.rotate(multiply, num_2)
			local multiply_2 = Quaternion.multiply(multiply, axis_angle)

			conflict:spawn_queued_unit(var_4_18, Vector3Box(num_4), QuaternionBox(multiply_2), str_2, var_4_11, str_3, shallow_copy, tbl_5)
		end

		local extension = ScriptUnit.extension(spawn_network_unit, "props_system")

		extension:assign_cultist_group_id(tbl_5.id)
		extension:setup_faction(var_4_8)
	end
}
