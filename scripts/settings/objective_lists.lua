-- chunkname: @scripts/settings/objective_lists.lua

local scripts_entity_system_systems_objective_objective_types = require("scripts/entity_system/systems/objective/objective_types")
local scripts_entity_system_systems_objective_objective_tags = require("scripts/entity_system/systems/objective/objective_tags")

ObjectiveLists = {}

local num = 1
local num_2 = 10
local num_3 = 10
local num_4 = 1
local num_5 = 1
local num_6 = 10
local num_7 = 20
local num_8 = 10
local num_9 = 1
local num_10 = 10

local function fn(arg_1_0)
	-- function 1
	return (arg_1_0 or 0) + 1
end

ObjectiveLists.bell_pvp_set_1 = {
	{
		versus_volume_objective_SZ01 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_SZ_01",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_01 = {
			description = "level_objective_description_bell_01",
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_01",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_capture_objective_01 = {
			description = "level_objective_description_bell_02",
			play_arrive_vo = true,
			num_sections = 90,
			capture_time = 180,
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_capture_point,
			score_per_section = num_5,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_2_0, arg_2_1)
				-- function 2
				local var_2_0 = arg_2_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_2_0):get_percentage_done() > 0.75 then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_alley = {
			description = "level_objective_description_bell_alley",
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_alley",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_008 = {
			description = "level_objective_description_bell_02_B",
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_01_B",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_02 = {
			description = "level_objective_description_bell_03",
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_02",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_socket_objective_01 = {
			description = "level_objective_description_bell_04",
			num_sockets = 3,
			play_arrive_vo = true,
			play_complete_vo = true,
			close_to_win_on_section = 3,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
			score_per_socket = num_7,
			vo_context_on_complete = {
				current_objective = "safe_room"
			},
			almost_done = function (self, arg_3_1)
				-- function 3
				local num_sockets = self.num_sockets
				local var_3_1 = arg_3_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_3_1):get_percentage_done() >= (num_sockets - 1.5) / num_sockets then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_03 = {
			description = "level_objective_description_bell_05",
			volume_type = "all_alive",
			play_safehouse_vo = true,
			volume_name = "versus_reach_waystone_round_1",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_6
		}
	}
}
ObjectiveLists.bell_pvp_set_2 = {
	{
		versus_volume_objective_SZ02 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_SZ_02",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_04 = {
			description = "level_objective_description_bell_06",
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_03",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_payload_objective_01 = {
			description = "level_objective_description_bell_07",
			num_sections = 90,
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_payload,
			score_per_section = num_4,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_4_0, arg_4_1)
				-- function 4
				local var_4_0 = arg_4_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_4_0):get_percentage_done() > 0.8 then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_07_B = {
			description = "level_objective_description_bell_07_B",
			volume_type = "any_alive",
			volume_name = "versus_reach_objective_04_B",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_07 = {
			description = "level_objective_description_bell_08A",
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_04",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_05 = {
			description = "level_objective_description_bell_08",
			volume_type = "any_alive",
			volume_name = "versus_reach_bell",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		sub_objective_container_01 = {
			description = "level_objective_description_bell_09",
			play_complete_vo = true,
			close_to_win_on_section = 3,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
			vo_context_on_complete = {
				current_objective = "waystone"
			},
			almost_done = function (arg_5_0, arg_5_1)
				-- function 5
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 3 then
					return true
				end
			end,
			sub_objectives = {
				sub_sub_objective_container_01 = {
					description = "level_objective_description_bell_09",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8 * 3,
					sub_objectives = {
						versus_target_objective_bell_01 = {
							description = "level_objective_description_bell_09",
							objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_chains,
							objective_type = scripts_entity_system_systems_objective_objective_types.objective_target
						},
						versus_target_objective_bell_02 = {
							description = "level_objective_description_bell_09",
							objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_chains,
							objective_type = scripts_entity_system_systems_objective_objective_types.objective_target
						},
						versus_target_objective_bell_03 = {
							description = "level_objective_description_bell_09",
							objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_chains,
							objective_type = scripts_entity_system_systems_objective_objective_types.objective_target
						}
					}
				},
				sub_sub_objective_container_02 = {
					description = "level_objective_description_bell_09",
					score_for_completion = num_8 * 3,
					sub_objectives = {
						versus_target_objective_bell_04 = {
							description = "level_objective_description_bell_09",
							objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_chains,
							objective_type = scripts_entity_system_systems_objective_objective_types.objective_target
						},
						versus_target_objective_bell_05 = {
							description = "level_objective_description_bell_09",
							objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_chains,
							objective_type = scripts_entity_system_systems_objective_objective_types.objective_target
						},
						versus_target_objective_bell_06 = {
							description = "level_objective_description_bell_09",
							objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_chains,
							objective_type = scripts_entity_system_systems_objective_objective_types.objective_target
						}
					}
				},
				sub_sub_objective_container_03 = {
					description = "level_objective_description_bell_09",
					score_for_completion = num_8 * 3,
					sub_objectives = {
						versus_target_objective_bell_07 = {
							description = "level_objective_description_bell_09",
							objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_chains,
							objective_type = scripts_entity_system_systems_objective_objective_types.objective_target
						},
						versus_target_objective_bell_08 = {
							description = "level_objective_description_bell_09",
							objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_chains,
							objective_type = scripts_entity_system_systems_objective_objective_types.objective_target
						},
						versus_target_objective_bell_09 = {
							description = "level_objective_description_bell_09",
							objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_chains,
							objective_type = scripts_entity_system_systems_objective_objective_types.objective_target
						}
					}
				}
			}
		}
	},
	{
		versus_volume_objective_08 = {
			description = "level_objective_description_bell_10",
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_05",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_06 = {
			description = "level_objective_description_bell_10",
			volume_type = "all_alive",
			play_arrive_vo = true,
			volume_name = "versus_reach_waystone",
			play_waystone_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_10
		}
	}
}
ObjectiveLists.military_pvp_set_1 = {
	{
		versus_volume_objective_sz_01 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_military_sz_01",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_first_alley = {
			description = "level_objective_description_military_alley",
			volume_type = "any_alive",
			volume_name = "versus_military_reach_first_alley",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_franz = {
			description = "level_objective_description_military_01",
			volume_type = "any_alive",
			volume_name = "versus_military_reach_franz",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_socket_objective_01 = {
			description = "level_objective_description_military_02",
			num_sockets = 2,
			play_arrive_vo = true,
			play_complete_vo = true,
			close_to_win_on_section = 2,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
			score_per_socket = num_7,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (self, arg_6_1)
				-- function 6
				local num_sockets = self.num_sockets
				local var_6_1 = arg_6_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_6_1):get_percentage_done() >= (num_sockets - 1.5) / num_sockets then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_02 = {
			description = "level_objective_description_military_03",
			volume_type = "any_alive",
			volume_name = "versus_military_reach_02",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_interact_objective_military_001 = {
			description = "level_objective_description_military_04",
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3
		}
	},
	{
		versus_survive_objective_01 = {
			description = "level_objective_description_military_05",
			num_sections = 40,
			time_for_completion = 90,
			score_for_completion = 0,
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_survive,
			score_per_section = num_9,
			vo_context_on_complete = {
				current_objective = "safe_room"
			}
		}
	},
	{
		versus_volume_objective_02B = {
			description = "level_objective_description_military_06",
			volume_type = "all_alive",
			play_safehouse_vo = true,
			volume_name = "versus_military_reach_02B",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_6
		}
	}
}
ObjectiveLists.military_pvp_set_2 = {
	{
		versus_volume_objective_sz_02 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_military_sz_02",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_03 = {
			description = "level_objective_description_military_07",
			volume_type = "any_alive",
			volume_name = "versus_military_reach_03",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_03_B = {
			description = "level_objective_description_military_07_B",
			volume_type = "any_alive",
			volume_name = "versus_military_reach_03_B",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_04 = {
			description = "level_objective_description_military_09",
			volume_type = "any_alive",
			volume_name = "versus_military_reach_04",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_capture_point_objective_003 = {
			description = "level_objective_description_military_10",
			play_arrive_vo = true,
			num_sections = 90,
			capture_time = 180,
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_capture_point,
			score_per_section = num_5,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_7_0, arg_7_1)
				-- function 7
				local var_7_0 = arg_7_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_7_0):get_percentage_done() > 0.75 then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_05 = {
			description = "level_objective_description_military_11",
			volume_type = "any_alive",
			volume_name = "versus_military_reach_05",
			close_to_win_on_completion = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_interact_objective_military_002 = {
			description = "level_objective_description_military_12",
			mission_name = "military_move_along_wall",
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3,
			vo_context_on_activate = {
				objective_part = 1
			},
			on_leaf_complete_sound_event = {
				heroes = "versus_hud_sub_objective_completed_heroes",
				dark_pact = "versus_hud_sub_objective_completed_pactsworn"
			}
		}
	},
	{
		versus_survive_objective_03 = {
			description = "level_objective_description_military_12_B",
			num_sections = 20,
			time_for_completion = 33,
			play_complete_vo = true,
			score_for_completion = 0,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_survive,
			score_per_section = num_9,
			vo_context_on_complete = {
				objective_part = 2
			},
			on_leaf_complete_sound_event = {
				heroes = "versus_hud_sub_objective_completed_heroes",
				dark_pact = "versus_hud_sub_objective_completed_pactsworn"
			}
		}
	},
	{
		versus_socket_objective_02 = {
			description = "level_objective_description_military_13",
			play_arrive_vo = true,
			num_sockets = 1,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
			score_per_socket = num_7,
			on_leaf_complete_sound_event = {
				heroes = "versus_hud_sub_objective_completed_heroes",
				dark_pact = "versus_hud_sub_objective_completed_pactsworn"
			}
		}
	},
	{
		versus_mission_objective_002 = {
			description = "level_objective_description_military_14",
			mission_name = "military_open_gate",
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3,
			vo_context_on_complete = {
				current_objective = "safe_room"
			}
		}
	},
	{
		versus_volume_objective_06 = {
			description = "level_objective_description_military_15",
			volume_type = "all_alive",
			play_safehouse_vo = true,
			volume_name = "versus_military_reach_06",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_6
		}
	}
}
ObjectiveLists.military_pvp_set_3 = {
	{
		versus_volume_objective_sz_03 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_military_sz_03",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_07 = {
			description = "level_objective_description_military_16",
			volume_type = "any_alive",
			volume_name = "versus_military_reach_07",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_capture_point_objective_004 = {
			description = "level_objective_description_military_17",
			play_arrive_vo = true,
			num_sections = 95,
			capture_time = 210,
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_capture_point,
			score_per_section = num_5,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_8_0, arg_8_1)
				-- function 8
				local var_8_0 = arg_8_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_8_0):get_percentage_done() > 0.75 then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_08 = {
			description = "level_objective_description_military_18",
			volume_type = "any_alive",
			volume_name = "versus_military_reach_08",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_mission_objective_004 = {
			description = "level_objective_description_military_19",
			mission_name = "military_ring_bell",
			play_arrive_vo = true,
			score_for_completion = num_3,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact
		}
	},
	{
		versus_survive_objective_02 = {
			description = "level_objective_description_military_20",
			time_for_completion = 190,
			num_sections = 95,
			play_complete_vo = true,
			score_for_completion = 0,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_survive,
			score_per_section = num_9,
			vo_context_on_complete = {
				current_objective = "waystone"
			},
			almost_done = function (arg_9_0, arg_9_1)
				-- function 9
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_09 = {
			description = "level_objective_description_military_21",
			volume_type = "all_alive",
			play_waystone_vo = true,
			volume_name = "versus_military_reach_09",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_2
		}
	}
}
ObjectiveLists.farmlands_pvp_set_1 = {
	{
		versus_volume_objective_farmlands_sz_01 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_sz_01",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_farmlands_01 = {
			description = "level_objective_description_farmlands_01",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_001",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_farmlands_01_farm = {
			description = "level_objective_description_farmlands_01_farm",
			volume_type = "any_alive",
			volume_name = "versus_reach_001_farm",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_farmlands_02_road = {
			description = "level_objective_description_farmlands_02_road",
			volume_type = "any_alive",
			volume_name = "versus_reach_02_road",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_farmlands_02 = {
			description = "level_objective_description_farmlands_03",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_002",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		sub_objective_container_01 = {
			description = "level_objective_description_farmlands_04",
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_10_0, arg_10_1)
				-- function 10
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_target_objective_001 = {
					description = "level_objective_description_farmlands_04",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8
				},
				versus_target_objective_002 = {
					description = "level_objective_description_farmlands_04",
					score_for_completion = num_8,
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target
				},
				versus_target_objective_003 = {
					description = "level_objective_description_farmlands_04",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8
				},
				versus_target_objective_004 = {
					description = "level_objective_description_farmlands_04",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8
				},
				versus_target_objective_005 = {
					description = "level_objective_description_farmlands_04",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8
				},
				versus_target_objective_006 = {
					description = "level_objective_description_farmlands_04",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8
				}
			}
		}
	},
	{
		versus_volume_objective_farmlands_03 = {
			description = "level_objective_description_farmlands_05",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_003",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_farmlands_04 = {
			description = "level_objective_description_farmlands_06",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_004",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_mission_objective_farmlands_key = {
			description = "level_objective_description_farmlands_07",
			mission_name = "versus_mission_farmlands_key",
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3
		}
	},
	{
		versus_mission_objective_open_barn = {
			description = "level_objective_description_farmlands_08",
			mission_name = "versus_mission_objective_barn",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3
		}
	},
	{
		versus_mission_objective_monster = {
			description = "level_objective_description_farmlands_09",
			mission_name = "versus_mission_monster",
			play_complete_vo = true,
			score_for_completion = 30,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_survive,
			vo_context_on_activate = {
				current_objective = "three"
			},
			vo_context_on_complete = {
				current_objective = "safe_room"
			}
		}
	},
	{
		versus_socket_objective_01 = {
			description = "level_objective_description_farmlands_09_B",
			num_sockets = 1,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
			score_per_socket = num_7,
			almost_done = function (self, arg_11_1)
				-- function 11
				local num_sockets = self.num_sockets
				local var_11_1 = arg_11_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_11_1):get_percentage_done() >= (num_sockets - 1.5) / num_sockets then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_farmlands_05 = {
			description = "level_objective_description_farmlands_10",
			volume_type = "all_alive",
			play_safehouse_vo = true,
			volume_name = "volume_versus_reach_005",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_6
		}
	}
}
ObjectiveLists.farmlands_pvp_set_2 = {
	{
		versus_volume_objective_farmlands_sz_02 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_name = "volume_versus_reach_sz_02",
			volume_type = "any_alive",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_farmlands_06 = {
			description = "level_objective_description_farmlands_11",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_006",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_capture_point_objective_road = {
			description = "level_objective_description_farmlands_12",
			play_arrive_vo = true,
			num_sections = 80,
			capture_time = 180,
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_capture_point,
			score_per_section = num_5,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_12_0, arg_12_1)
				-- function 12
				local var_12_0 = arg_12_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_12_0):get_percentage_done() > 0.75 then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_farmlands_06_B = {
			description = "level_objective_description_farmlands_11_B",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_006_B",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_farmlands_07 = {
			description = "level_objective_description_farmlands_13",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_007",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_farmlands_08 = {
			description = "level_objective_description_farmlands_14",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_008",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_interact_objective_prisoners_streets = {
			description = "level_objective_description_farmlands_15",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
			score_for_completion = num_3
		}
	},
	{
		sub_objective_container_prisoners_01 = {
			description = "level_objective_description_farmlands_16",
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			almost_done = function (arg_13_0, arg_13_1)
				-- function 13
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_interact_objective_prisoners_001 = {
					description = "level_objective_description_farmlands_16",
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					score_for_completion = num_3
				},
				versus_interact_objective_prisoners_002 = {
					description = "level_objective_description_farmlands_16",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				},
				versus_interact_objective_prisoners_003 = {
					description = "level_objective_description_farmlands_16",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				},
				versus_interact_objective_prisoners_004 = {
					description = "level_objective_description_farmlands_16",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				}
			}
		}
	},
	{
		sub_objective_container_prisoners_02 = {
			description = "level_objective_description_farmlands_17",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			almost_done = function (arg_14_0, arg_14_1)
				-- function 14
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_interact_objective_prisoners_005 = {
					description = "level_objective_description_farmlands_17",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				},
				versus_interact_objective_prisoners_006 = {
					description = "level_objective_description_farmlands_17",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				}
			}
		}
	},
	{
		sub_objective_container_prisoners_03 = {
			description = "level_objective_description_farmlands_18",
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
			vo_context_on_complete = {
				current_objective = "waystone"
			},
			almost_done = function (arg_15_0, arg_15_1)
				-- function 15
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_interact_objective_prisoners_007 = {
					description = "level_objective_description_farmlands_18",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				},
				versus_interact_objective_prisoners_008 = {
					description = "level_objective_description_farmlands_18",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				},
				versus_interact_objective_prisoners_009 = {
					description = "level_objective_description_farmlands_18",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				},
				versus_interact_objective_prisoners_010 = {
					description = "level_objective_description_farmlands_18",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				}
			}
		}
	},
	{
		versus_volume_objective_farmlands_end = {
			description = "level_objective_description_farmlands_19",
			volume_type = "all_alive",
			play_waystone_vo = true,
			volume_name = "volume_versus_reach_009",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_10
		}
	}
}
ObjectiveLists.fort_pvp_set_1 = {
	{
		versus_volume_objective_001 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_reach_001",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_002 = {
			description = "level_objective_description_fort_01",
			volume_type = "any_alive",
			volume_name = "versus_reach_002",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_capture_point_objective_001 = {
			description = "level_objective_description_fort_02",
			play_arrive_vo = true,
			num_sections = 50,
			capture_time = 120,
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_capture_point,
			score_per_section = num_5,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_16_0, arg_16_1)
				-- function 16
				local var_16_0 = arg_16_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_16_0):get_percentage_done() > 0.75 then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_002_B_road = {
			description = "level_objective_description_fort_02_B",
			volume_type = "any_alive",
			volume_name = "versus_reach_002_B_road",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_003 = {
			description = "level_objective_description_fort_03",
			volume_type = "any_alive",
			volume_name = "versus_reach_003",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_payload_objective_01 = {
			description = "level_objective_description_fort_04",
			num_sections = 70,
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_payload,
			score_per_section = num_4,
			vo_context_on_complete = {
				current_objective = "safe_room"
			},
			almost_done = function (arg_17_0, arg_17_1)
				-- function 17
				local var_17_0 = arg_17_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_17_0):get_percentage_done() > 0.8 then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_004 = {
			description = "level_objective_description_fort_05",
			volume_type = "any_alive",
			volume_name = "versus_reach_004",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_005 = {
			description = "level_objective_description_vs_reach_safe_zone",
			volume_type = "all_alive",
			play_safehouse_vo = true,
			volume_name = "versus_reach_005",
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_6
		}
	}
}
ObjectiveLists.fort_pvp_set_2 = {
	{
		versus_volume_objective_006 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_reach_006",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_007 = {
			description = "level_objective_description_fort_06",
			volume_type = "any_alive",
			volume_name = "versus_reach_007",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_fort_interact_001 = {
			description = "level_objective_description_fort_07",
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3,
			vo_context_on_activate = {
				objective_part = 1
			},
			vo_context_on_complete = {
				objective_part = 2
			}
		}
	},
	{
		sub_objective_container_bells = {
			play_complete_vo = true,
			play_arrive_vo = true,
			description = "level_objective_description_fort_07_B",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			sub_objectives = {
				versus_interact_fort_tower_001 = {
					description = "level_objective_description_fort_07_B",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					score_for_completion = num_3
				},
				versus_interact_fort_tower_002 = {
					description = "level_objective_description_fort_07_B",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					score_for_completion = num_3
				},
				versus_interact_fort_tower_003 = {
					description = "level_objective_description_fort_07_B",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					score_for_completion = num_3
				}
			},
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_18_0, arg_18_1)
				-- function 18
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_008 = {
			description = "level_objective_description_fort_08",
			volume_type = "any_alive",
			volume_name = "versus_reach_008",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_009 = {
			description = "level_objective_description_fort_09",
			volume_type = "any_alive",
			volume_name = "versus_reach_009",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_payload_objective_02 = {
			description = "level_objective_description_fort_10",
			num_sections = 90,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_payload,
			score_per_section = num_4,
			almost_done = function (arg_19_0, arg_19_1)
				-- function 19
				local var_19_0 = arg_19_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_19_0):get_percentage_done() > 0.8 then
					return true
				end
			end
		}
	},
	{
		versus_mission_objective_breach_wall = {
			description = "level_objective_description_fort_11",
			mission_name = "mission_fort_breach_wall",
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3,
			vo_context_on_complete = {
				current_objective = "safe_room"
			}
		}
	},
	{
		versus_volume_objective_010 = {
			description = "level_objective_description_vs_reach_safe_zone",
			volume_type = "all_alive",
			play_safehouse_vo = true,
			volume_name = "versus_reach_010",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_6
		}
	}
}
ObjectiveLists.fort_pvp_set_3 = {
	{
		versus_volume_objective_011 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_reach_011",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_012 = {
			description = "level_objective_description_fort_12",
			volume_type = "any_alive",
			volume_name = "versus_reach_012",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		sub_objective_container_cannon_balls = {
			description = "level_objective_description_fort_13",
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_20_0, arg_20_1)
				-- function 20
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_socket_objective_01 = {
					description = "level_objective_description_fort_13",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
					score_for_completion = num_7
				},
				versus_socket_objective_02 = {
					description = "level_objective_description_fort_13",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
					score_for_completion = num_7
				}
			}
		}
	},
	{
		versus_interact_objective_elevator = {
			description = "level_objective_description_fort_14",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3
		}
	},
	{
		versus_volume_objective_013 = {
			description = "level_objective_description_fort_15",
			volume_type = "any_alive",
			volume_name = "versus_reach_013",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_014 = {
			description = "level_objective_description_fort_16",
			volume_type = "any_alive",
			volume_name = "versus_reach_014",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_interaction_fort_portcullis = {
			description = "level_objective_description_fort_17",
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3,
			vo_context_on_activate = {
				objective_part = 1
			},
			vo_context_on_complete = {
				objective_part = 2
			}
		}
	},
	{
		versus_survive_objective_fort_portcullis = {
			description = "level_objective_description_military_20",
			time_for_completion = 25,
			num_sections = 10,
			play_complete_vo = true,
			score_for_completion = 0,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_survive,
			score_per_section = num_9,
			vo_context_on_complete = {
				current_objective = "three",
				objective_part = 1
			}
		}
	},
	{
		versus_volume_objective_015 = {
			description = "level_objective_description_fort_17_B",
			volume_type = "any_alive",
			volume_name = "versus_reach_015",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		sub_objective_container_cannons = {
			description = "level_objective_description_fort_18",
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			sub_objectives = {
				versus_interact_cannon_01 = {
					description = "level_objective_description_fort_18",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					score_for_completion = num_7 + num_3
				},
				versus_interact_cannon_02 = {
					description = "level_objective_description_fort_18",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					score_for_completion = num_7 + num_3
				}
			}
		}
	},
	{
		versus_socket_objective_fort = {
			description = "level_objective_description_military_13",
			num_sockets = 1,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
			score_per_socket = num_7,
			on_last_leaf_complete_sound_event = {
				heroes = "versus_hud_sub_objective_completed_heroes",
				dark_pact = "versus_hud_sub_objective_completed_pactsworn"
			}
		}
	},
	{
		versus_interact_cannon_03 = {
			description = "level_objective_description_fort_20",
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3,
			vo_context_on_complete = {
				current_objective = "waystone"
			}
		}
	},
	{
		versus_volume_objective_016 = {
			description = "level_objective_description_fort_21",
			volume_type = "all_alive",
			play_waystone_vo = true,
			volume_name = "volume_versus_reach_end_dome",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_10
		}
	}
}
ObjectiveLists.forest_ambush_pvp_set_1 = {
	{
		versus_volume_objective_01 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_001",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_02 = {
			description = "level_objective_description_forest_ambush_01",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_002",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		sub_objective_container_01 = {
			description = "level_objective_description_forest_ambush_02",
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_21_0, arg_21_1)
				-- function 21
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_target_objective_001 = {
					description = "level_objective_description_forest_ambush_02",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8
				},
				versus_target_objective_002 = {
					description = "level_objective_description_forest_ambush_02",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8
				},
				versus_target_objective_003 = {
					description = "level_objective_description_forest_ambush_02",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8
				},
				versus_target_objective_004 = {
					description = "level_objective_description_forest_ambush_02",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8
				},
				versus_target_objective_005 = {
					description = "level_objective_description_forest_ambush_02",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8
				}
			}
		}
	},
	{
		versus_volume_objective_03 = {
			description = "level_objective_description_forest_ambush_03",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_003",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_04 = {
			description = "level_objective_description_forest_ambush_04",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_004",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_payload_objective_01 = {
			description = "level_objective_description_forest_ambush_05",
			num_sections = 20,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_payload,
			score_per_section = num_4,
			vo_context_on_activate = {
				objective_part = 1
			},
			vo_context_on_complete = {
				objective_part = 2
			},
			almost_done = function (arg_22_0, arg_22_1)
				-- function 22
				local var_22_0 = arg_22_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_22_0):get_percentage_done() > 0.8 then
					return true
				end
			end
		}
	},
	{
		versus_survive_objective_02 = {
			description = "mission_bastion_survive",
			time_for_completion = 120,
			num_sections = 30,
			play_complete_vo = true,
			score_for_completion = 0,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_survive,
			score_per_section = num_9,
			vo_context_on_complete = {
				current_objective = "safe_room"
			}
		}
	},
	{
		versus_volume_objective_05 = {
			description = "level_objective_description_vs_reach_safe_zone",
			volume_type = "all_alive",
			play_safehouse_vo = true,
			volume_name = "versus_forest_ambush_reach_005",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_6
		}
	}
}
ObjectiveLists.forest_ambush_pvp_set_2 = {
	{
		versus_volume_objective_06 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_006",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_07 = {
			description = "level_objective_description_forest_ambush_07",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_007",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		sub_objective_container_doomwheels_01 = {
			description = "level_objective_description_forest_ambush_08",
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_23_0, arg_23_1)
				-- function 23
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_socket_objective_doomwheels_001 = {
					description = "level_objective_description_forest_ambush_08",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
					score_for_completion = num_7
				},
				versus_socket_objective_doomwheels_002 = {
					description = "level_objective_description_forest_ambush_08",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
					score_for_completion = num_7
				},
				versus_socket_objective_doomwheels_003 = {
					description = "level_objective_description_forest_ambush_08",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
					score_for_completion = num_7
				}
			}
		}
	},
	{
		versus_volume_objective_08_B = {
			description = "level_objective_description_forest_ambush_08_B",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_008_B",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_08 = {
			description = "level_objective_description_forest_ambush_09",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_008",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		sub_objective_container_gargoyle_heads_01 = {
			description = "level_objective_description_forest_ambush_11",
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
			vo_context_on_complete = {
				current_objective = "three"
			},
			almost_done = function (arg_24_0, arg_24_1)
				-- function 24
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_socket_objective_gargoyles_001 = {
					description = "level_objective_description_forest_ambush_11",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
					score_for_completion = num_7
				},
				versus_socket_objective_gargoyles_002 = {
					description = "level_objective_description_forest_ambush_11",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_socket,
					score_for_completion = num_7
				}
			}
		}
	},
	{
		versus_volume_objective_09 = {
			description = "level_objective_description_forest_ambush_10",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_009",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		sub_objective_container_prisoners_01 = {
			description = "level_objective_description_forest_ambush_11_B",
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			vo_context_on_complete = {
				current_objective = "safe_room"
			},
			almost_done = function (arg_25_0, arg_25_1)
				-- function 25
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_interact_objective_prisoners_001 = {
					description = "level_objective_description_forest_ambush_11_B",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				},
				versus_interact_objective_prisoners_002 = {
					description = "level_objective_description_forest_ambush_11_B",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				},
				versus_interact_objective_prisoners_003 = {
					description = "level_objective_description_forest_ambush_11_B",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				},
				versus_interact_objective_prisoners_004 = {
					description = "level_objective_description_forest_ambush_11_B",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				},
				versus_interact_objective_prisoners_005 = {
					description = "level_objective_description_forest_ambush_11_B",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
					objective_tag = scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner,
					score_for_completion = num_3
				}
			}
		}
	},
	{
		versus_volume_objective_010 = {
			description = "level_objective_description_vs_reach_safe_zone",
			volume_type = "all_alive",
			play_safehouse_vo = true,
			volume_name = "versus_forest_ambush_reach_010",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_6
		}
	}
}
ObjectiveLists.forest_ambush_pvp_set_3 = {
	{
		versus_volume_objective_011 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_011",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_012 = {
			description = "level_objective_description_forest_ambush_12",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_012",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_capture_point_001 = {
			description = "level_objective_description_forest_ambush_12_B",
			num_sections = 80,
			play_arrive_vo = true,
			capture_time = 180,
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_capture_point,
			score_per_section = num_5,
			vo_context_on_complete = {
				current_objective = "two"
			}
		}
	},
	{
		versus_volume_objective_013 = {
			description = "level_objective_description_forest_ambush_13",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_013",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_interact_ring_bell = {
			description = "level_objective_description_forest_ambush_14",
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3
		}
	},
	{
		versus_survive_objective_01 = {
			description = "level_objective_description_forest_ambush_15",
			time_for_completion = 180,
			num_sections = 100,
			play_complete_vo = true,
			score_for_completion = 0,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_survive,
			score_per_section = num_9,
			vo_context_on_complete = {
				current_objective = "waystone"
			},
			almost_done = function (arg_26_0, arg_26_1)
				-- function 26
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_014 = {
			description = "level_objective_description_forest_ambush_16",
			volume_type = "all_alive",
			play_waystone_vo = true,
			volume_name = "versus_forest_ambush_reach_014",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_10
		}
	}
}
ObjectiveLists.dwarf_exterior_pvp_set_1 = {
	{
		versus_volume_objective_exterior_sz01 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_sz01",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_exterior_001 = {
			description = "level_objective_description_exterior_01",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_001",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_exterior_002 = {
			description = "level_objective_description_exterior_02",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_002",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_exterior_003 = {
			description = "level_objective_description_exterior_03",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_003",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_capture_objective_01 = {
			description = "level_objective_description_exterior_04",
			play_arrive_vo = true,
			num_sections = 25,
			capture_time = 180,
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_capture_point,
			score_per_section = num_5,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_27_0, arg_27_1)
				-- function 27
				local var_27_0 = arg_27_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_27_0):get_percentage_done() > 0.75 then
					return true
				end
			end
		}
	},
	{
		versus_volume_objective_exterior_005 = {
			description = "level_objective_description_exterior_05",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_005",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_interact_objective_exterior_001 = {
			description = "level_objective_description_exterior_06_A",
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3,
			vo_context_on_activate = {
				objective_part = 1
			}
		}
	},
	{
		versus_survive_objective_01 = {
			description = "level_objective_description_exterior_07_A",
			num_sections = 5,
			score_for_completion = 0,
			dialogue_event = "vs_mg_dwarf_external_windlass_reminder",
			time_for_completion = 20,
			play_dialogue_event_on_complete = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_survive,
			score_per_section = num_9,
			on_last_leaf_complete_sound_event = {
				heroes = "versus_hud_sub_objective_completed_heroes",
				dark_pact = "versus_hud_sub_objective_completed_pactsworn"
			}
		}
	},
	{
		versus_interact_objective_exterior_002 = {
			description = "level_objective_description_exterior_06_B",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3,
			vo_context_on_activate = {
				objective_part = 2
			}
		}
	},
	{
		versus_survive_objective_02 = {
			description = "level_objective_description_exterior_07_B",
			num_sections = 5,
			score_for_completion = 0,
			dialogue_event = "vs_mg_dwarf_external_windlass_reminder",
			time_for_completion = 20,
			play_dialogue_event_on_complete = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_survive,
			score_per_section = num_9,
			on_last_leaf_complete_sound_event = {
				heroes = "versus_hud_sub_objective_completed_heroes",
				dark_pact = "versus_hud_sub_objective_completed_pactsworn"
			}
		}
	},
	{
		versus_interact_objective_exterior_003 = {
			description = "level_objective_description_exterior_06_C",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3
		}
	},
	{
		versus_survive_objective_03 = {
			description = "level_objective_description_exterior_07_C",
			num_sections = 5,
			time_for_completion = 20,
			score_for_completion = 0,
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_survive,
			score_per_section = num_9,
			vo_context_on_complete = {
				current_objective = "safe_room"
			}
		}
	},
	{
		versus_volume_objective_exterior_006 = {
			description = "level_objective_description_vs_reach_safe_zone",
			volume_type = "all_alive",
			play_safehouse_vo = true,
			volume_name = "versus_exterior_reach_006",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_6
		}
	}
}
ObjectiveLists.dwarf_exterior_pvp_set_2 = {
	{
		versus_volume_objective_exterior_007 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_007",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_exterior_008 = {
			description = "level_objective_description_exterior_08",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_008",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_payload_objective_exterior_01 = {
			description = "level_objective_description_exterior_09",
			num_sections = 70,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_payload,
			score_per_section = num_4,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function (arg_28_0, arg_28_1)
				-- function 28
				local var_28_0 = arg_28_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_28_0):get_percentage_done() > 0.8 then
					return true
				end
			end
		}
	},
	{
		versus_interact_objective_black_powder = {
			description = "level_objective_description_exterior_09_B",
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3
		}
	},
	{
		versus_volume_objective_exterior_011 = {
			description = "level_objective_description_exterior_11",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_011",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		sub_objective_container_mad_dog = {
			description = "level_objective_description_exterior_12",
			close_to_win_on_sub_objective = 2,
			play_arrive_vo = true,
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
			vo_context_on_activate = {
				objective_part = 1
			},
			vo_context_on_complete = {
				current_objective = "safe_room"
			},
			almost_done = function (arg_29_0, arg_29_1)
				-- function 29
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_capture_objective_mine_001 = {
					always_show_objective_marker = true,
					capture_time = 80,
					num_sections = 30,
					description = "level_objective_description_exterior_12",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_capture_points_reminder",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_capture_point,
					score_per_section = num_5,
					vo_context_on_complete = {
						objective_part = fn
					}
				},
				versus_capture_objective_mine_002 = {
					always_show_objective_marker = true,
					capture_time = 80,
					num_sections = 30,
					description = "level_objective_description_exterior_12",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_capture_points_reminder",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_capture_point,
					score_per_section = num_5,
					vo_context_on_complete = {
						objective_part = fn
					}
				},
				versus_capture_objective_mine_003 = {
					always_show_objective_marker = true,
					capture_time = 80,
					num_sections = 30,
					description = "level_objective_description_exterior_12",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_capture_points_reminder",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_capture_point,
					score_per_section = num_5,
					vo_context_on_complete = {
						objective_part = fn
					}
				}
			}
		}
	},
	{
		versus_volume_objective_exterior_012 = {
			description = "level_objective_description_vs_reach_safe_zone",
			volume_type = "all_alive",
			play_safehouse_vo = true,
			volume_name = "versus_exterior_reach_012",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_6
		}
	}
}
ObjectiveLists.dwarf_exterior_pvp_set_3 = {
	{
		versus_volume_objective_sz_03 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_013",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			vo_context_on_activate = {
				current_objective = "start_zone"
			},
			vo_context_on_complete = {
				current_objective = "one"
			}
		}
	},
	{
		versus_volume_objective_exterior_014 = {
			description = "level_objective_description_exterior_14",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_014",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_exterior_015 = {
			description = "level_objective_description_exterior_15",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_015",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_interact_objective_bombcart = {
			description = "level_objective_description_exterior_20",
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3,
			vo_context_on_complete = {
				current_objective = "two",
				objective_part = 0
			}
		}
	},
	{
		versus_volume_objective_exterior_016 = {
			description = "level_objective_description_exterior_16",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_016",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		versus_volume_objective_exterior_017 = {
			description = "level_objective_description_exterior_17",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_017",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2,
			vo_context_on_complete = {
				objective_part = 1
			}
		}
	},
	{
		versus_volume_objective_exterior_018 = {
			description = "level_objective_description_exterior_18",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_018",
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_reach,
			score_for_completion = num_2
		}
	},
	{
		sub_objective_container_01 = {
			description = "level_objective_description_exterior_19",
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
			vo_context_on_activate = {
				destroyed_chains = 0,
				objective_part = 2
			},
			vo_context_on_complete = {
				objective_part = 3
			},
			almost_done = function (arg_30_0, arg_30_1)
				-- function 30
				local system = Managers.state.entity:system("objective_system")

				if system:num_current_sub_objectives() - system:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_target_objective_001 = {
					description = "level_objective_description_exterior_19",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_chains_reminder",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8,
					vo_context_on_complete = {
						destroyed_chains = fn
					}
				},
				versus_target_objective_002 = {
					description = "level_objective_description_exterior_19",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_chains_reminder",
					score_for_completion = num_8,
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					vo_context_on_complete = {
						destroyed_chains = fn
					}
				},
				versus_target_objective_003 = {
					description = "level_objective_description_exterior_19",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_chains_reminder",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8,
					vo_context_on_complete = {
						destroyed_chains = fn
					}
				},
				versus_target_objective_004 = {
					description = "level_objective_description_exterior_19",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_chains_reminder",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8,
					vo_context_on_complete = {
						destroyed_chains = fn
					}
				},
				versus_target_objective_005 = {
					description = "level_objective_description_exterior_19",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_chains_reminder",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8,
					vo_context_on_complete = {
						destroyed_chains = fn
					}
				},
				versus_target_objective_006 = {
					description = "level_objective_description_exterior_19",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_chains_reminder",
					objective_type = scripts_entity_system_systems_objective_objective_types.objective_target,
					score_for_completion = num_8,
					vo_context_on_complete = {
						destroyed_chains = fn
					}
				}
			}
		}
	},
	{
		versus_interact_objective_bombcart_again = {
			description = "level_objective_description_exterior_20",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3,
			vo_context_on_complete = {
				objective_part = 4
			}
		}
	},
	{
		versus_survive_objective_05 = {
			description = "level_objective_description_exterior_20_B",
			num_sections = 50,
			time_for_completion = 30,
			score_for_completion = 0,
			play_dialogue_event_on_complete = true,
			dialogue_event = "vs_mg_dwarf_external_ignite_bomb",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_survive,
			score_per_section = num_9
		}
	},
	{
		versus_interact_objective_ignite_bomb = {
			description = "level_objective_description_exterior_21",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_interact,
			score_for_completion = num_3
		}
	},
	{
		versus_survive_objective_04 = {
			description = "level_objective_description_exterior_22",
			num_sections = 40,
			time_for_completion = 20,
			score_for_completion = 0,
			play_complete_vo = true,
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_survive,
			score_per_section = num_9,
			vo_context_on_complete = {
				current_objective = "waystone"
			}
		}
	},
	{
		versus_volume_objective_exterior_019 = {
			description = "level_objective_description_exterior_23",
			volume_type = "all_alive",
			play_waystone_vo = true,
			volume_name = "versus_exterior_reach_019",
			objective_type = scripts_entity_system_systems_objective_objective_types.objective_safehouse,
			score_for_each_player_inside = num_2
		}
	}
}
ObjectiveLists.weave_1 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_2 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_3 = {
	{
		kill_enemies = {},
		capture_point_004 = {
			is_scored = true,
			on_start_func = function (arg_31_0)
				-- function 31
				local get_data = Unit.get_data(arg_31_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_3_event", get_data)
			end,
			on_complete_func = function (arg_32_0)
				-- function 32
				local get_data = Unit.get_data(arg_32_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_3_event", get_data)
			end
		},
		capture_point_002 = {
			is_scored = true,
			on_start_func = function (arg_33_0)
				-- function 33
				local get_data = Unit.get_data(arg_33_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", get_data)
			end,
			on_complete_func = function (arg_34_0)
				-- function 34
				local get_data = Unit.get_data(arg_34_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_small", get_data)
			end
		},
		capture_point_005 = {
			is_scored = true,
			on_start_func = function (arg_35_0)
				-- function 35
				local get_data = Unit.get_data(arg_35_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large", get_data)
			end,
			on_complete_func = function (arg_36_0)
				-- function 36
				local get_data = Unit.get_data(arg_36_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large", get_data)
			end
		}
	}
}
ObjectiveLists.weave_4 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_5 = {
	{
		kill_enemies = {},
		capture_point_003 = {
			is_scored = true,
			sort_index = 3,
			on_start_func = function (arg_37_0)
				-- function 37
				local get_data = Unit.get_data(arg_37_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_3_event", get_data)
			end,
			on_complete_func = function (arg_38_0)
				-- function 38
				local get_data = Unit.get_data(arg_38_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_3_event", get_data)
			end
		},
		capture_point_001 = {
			is_scored = true,
			sort_index = 1,
			on_start_func = function (arg_39_0)
				-- function 39
				local get_data = Unit.get_data(arg_39_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", get_data)
			end,
			on_complete_func = function (arg_40_0)
				-- function 40
				local get_data = Unit.get_data(arg_40_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_small", get_data)
			end
		},
		capture_point_002 = {
			is_scored = true,
			sort_index = 2,
			on_start_func = function (arg_41_0)
				-- function 41
				local get_data = Unit.get_data(arg_41_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large", get_data)
			end,
			on_complete_func = function (arg_42_0)
				-- function 42
				local get_data = Unit.get_data(arg_42_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large", get_data)
			end
		}
	}
}
ObjectiveLists.weave_6 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_7 = {
	{
		kill_enemies = {},
		weave_prop_skaven_doom_wheel_01_spawner_002 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function (arg_43_0)
				-- function 43
				local get_data = Unit.get_data(arg_43_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_skaven_gutter_runner", get_data)
			end
		},
		weave_limited_item_track_spawner_002 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function (arg_44_0)
				-- function 44
				local get_data = Unit.get_data(arg_44_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", get_data)
			end
		}
	},
	{
		kill_enemies = {},
		weave_prop_skaven_doom_wheel_01_spawner_001 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function (arg_45_0)
				-- function 45
				local get_data = Unit.get_data(arg_45_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_minotaur", get_data)
			end
		},
		weave_limited_item_track_spawner_003 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function (arg_46_0)
				-- function 46
				local get_data = Unit.get_data(arg_46_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_chaos_spawn_nodelay", get_data)
			end
		}
	}
}
ObjectiveLists.weave_8 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_9 = {
	{
		kill_enemies = {},
		capture_point_001 = {
			is_scored = true,
			on_start_func = function (arg_47_0)
				-- function 47
				local get_data = Unit.get_data(arg_47_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_chaos", get_data)
			end,
			on_complete_func = function (arg_48_0)
				-- function 48
				local get_data = Unit.get_data(arg_48_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_chaos", get_data)
			end
		},
		capture_point_002 = {
			is_scored = true,
			on_start_func = function (arg_49_0)
				-- function 49
				local get_data = Unit.get_data(arg_49_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_6_boss_event_skaven", get_data)
			end,
			on_complete_func = function (arg_50_0)
				-- function 50
				local get_data = Unit.get_data(arg_50_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_6_boss_event_skaven", get_data)
			end
		},
		capture_point_003 = {
			is_scored = true,
			on_start_func = function (arg_51_0)
				-- function 51
				local get_data = Unit.get_data(arg_51_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_event_beastmen", get_data)
			end,
			on_complete_func = function (arg_52_0)
				-- function 52
				local get_data = Unit.get_data(arg_52_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_event_beastmen", get_data)
			end
		}
	}
}
ObjectiveLists.weave_10 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_11 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_12 = {
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_004 = {
			is_scored = true
		},
		weave_limited_item_track_spawner_008 = {
			template_name = "gargoyle_head_spawner"
		}
	},
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_008 = {
			is_scored = true
		},
		weave_limited_item_track_spawner_004 = {
			template_name = "gargoyle_head_spawner"
		}
	}
}
ObjectiveLists.weave_13 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_14 = {
	{
		kill_enemies = {},
		capture_point_002 = {
			is_scored = true,
			on_start_func = function (arg_53_0)
				-- function 53
				local get_data = Unit.get_data(arg_53_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_3_event", get_data)
			end,
			on_complete_func = function (arg_54_0)
				-- function 54
				local get_data = Unit.get_data(arg_54_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_3_event", get_data)
			end
		},
		capture_point_001 = {
			is_scored = true,
			on_start_func = function (arg_55_0)
				-- function 55
				local get_data = Unit.get_data(arg_55_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", get_data)
			end,
			on_complete_func = function (arg_56_0)
				-- function 56
				local get_data = Unit.get_data(arg_56_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_small", get_data)
			end
		},
		capture_point_003 = {
			is_scored = true,
			on_start_func = function (arg_57_0)
				-- function 57
				local get_data = Unit.get_data(arg_57_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large", get_data)
			end,
			on_complete_func = function (arg_58_0)
				-- function 58
				local get_data = Unit.get_data(arg_58_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large", get_data)
			end
		}
	}
}
ObjectiveLists.weave_15 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_16 = {
	{
		kill_enemies = {},
		weave_prop_skaven_doom_wheel_01_spawner_001 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function (arg_59_0)
				-- function 59
				local get_data = Unit.get_data(arg_59_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_stormfiend", get_data)
			end
		},
		weave_prop_skaven_doom_wheel_01_spawner_002 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function (arg_60_0)
				-- function 60
				local get_data = Unit.get_data(arg_60_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_chaos_spawn", get_data)
			end
		},
		weave_limited_item_track_spawner_001 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function (arg_61_0)
				-- function 61
				local get_data = Unit.get_data(arg_61_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_medium", get_data)
			end
		},
		weave_limited_item_track_spawner_007 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function (arg_62_0)
				-- function 62
				local get_data = Unit.get_data(arg_62_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_specials_raid", get_data)
			end
		}
	}
}
ObjectiveLists.weave_17 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_18 = {
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_001 = {
			is_scored = true,
			on_start_func = function (arg_63_0)
				-- function 63
				local get_data = Unit.get_data(arg_63_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_specials_raid", get_data)
			end
		},
		weave_limited_item_track_spawner_004 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function (arg_64_0)
				-- function 64
				local get_data = Unit.get_data(arg_64_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_chaos_warriors", get_data)
			end
		}
	},
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_002 = {
			is_scored = true,
			on_start_func = function (arg_65_0)
				-- function 65
				local get_data = Unit.get_data(arg_65_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_event_beastmen", get_data)
			end
		},
		weave_limited_item_track_spawner_007 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function (arg_66_0)
				-- function 66
				local get_data = Unit.get_data(arg_66_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_skaven_specials_small", get_data)
			end
		}
	},
	{
		kill_enemies = {},
		weave_limited_item_track_spawner_006 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function (arg_67_0)
				-- function 67
				local get_data = Unit.get_data(arg_67_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", get_data)
			end
		},
		weave_explosive_barrel_socket_003 = {
			is_scored = true
		}
	}
}
ObjectiveLists.weave_19 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_20 = {
	{
		kill_enemies = {},
		capture_point_006 = {
			is_scored = true,
			on_start_func = function (arg_68_0)
				-- function 68
				local get_data = Unit.get_data(arg_68_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large_skaven", get_data)
			end,
			on_complete_func = function (arg_69_0)
				-- function 69
				local get_data = Unit.get_data(arg_69_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large_skaven", get_data)
			end
		},
		capture_point_002 = {
			is_scored = true,
			on_start_func = function (arg_70_0)
				-- function 70
				local get_data = Unit.get_data(arg_70_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_2_event", get_data)
			end,
			on_complete_func = function (arg_71_0)
				-- function 71
				local get_data = Unit.get_data(arg_71_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_2_event", get_data)
			end
		},
		capture_point_003 = {
			is_scored = true,
			on_start_func = function (arg_72_0)
				-- function 72
				local get_data = Unit.get_data(arg_72_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_event_beastmen", get_data)
			end,
			on_complete_func = function (arg_73_0)
				-- function 73
				local get_data = Unit.get_data(arg_73_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_event_beastmen", get_data)
			end
		}
	}
}
ObjectiveLists.weave_21 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_22 = {
	{
		kill_enemies = {},
		weave_target_spawner_006 = {
			is_scored = true
		},
		weave_target_spawner_040 = {
			is_scored = true
		},
		weave_target_spawner_010 = {
			is_scored = true
		},
		weave_target_spawner_041 = {
			is_scored = true
		},
		weave_target_spawner_011 = {
			is_scored = true
		},
		weave_target_spawner_045 = {
			is_scored = true
		},
		weave_target_spawner_020 = {
			is_scored = true
		},
		weave_target_spawner_024 = {
			is_scored = true
		},
		weave_target_spawner_030 = {
			is_scored = true
		},
		weave_target_spawner_032 = {
			is_scored = true
		}
	}
}
ObjectiveLists.weave_23 = {
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_002 = {
			is_scored = true
		},
		weave_limited_item_track_spawner_002 = {
			template_name = "gargoyle_head_spawner"
		}
	},
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_004 = {
			is_scored = true
		},
		weave_limited_item_track_spawner_009 = {
			template_name = "gargoyle_head_spawner"
		}
	},
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_007 = {
			is_scored = true
		},
		weave_limited_item_track_spawner_008 = {
			template_name = "gargoyle_head_spawner"
		}
	}
}
ObjectiveLists.weave_24 = {
	{
		kill_enemies = {},
		weave_prop_skaven_doom_wheel_01_spawner_002 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function (arg_74_0)
				-- function 74
				local get_data = Unit.get_data(arg_74_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_chaos_spawn", get_data)
			end
		},
		weave_limited_item_track_spawner_009 = {
			template_name = "magic_barrel_spawner",
			on_first_pickup_func = function (arg_75_0)
				-- function 75
				local get_data = Unit.get_data(arg_75_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_3_event", get_data)
			end
		}
	}
}
ObjectiveLists.weave_25 = {
	{
		kill_enemies = {},
		capture_point_007 = {
			is_scored = true,
			on_start_func = function (arg_76_0)
				-- function 76
				local get_data = Unit.get_data(arg_76_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_medium", get_data)
			end,
			on_complete_func = function (arg_77_0)
				-- function 77
				local get_data = Unit.get_data(arg_77_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_medium", get_data)
			end
		},
		capture_point_008 = {
			is_scored = true,
			on_start_func = function (arg_78_0)
				-- function 78
				local get_data = Unit.get_data(arg_78_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_3_event", get_data)
			end,
			on_complete_func = function (arg_79_0)
				-- function 79
				local get_data = Unit.get_data(arg_79_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_3_event", get_data)
			end
		},
		capture_point_005 = {
			is_scored = true,
			on_start_func = function (arg_80_0)
				-- function 80
				local get_data = Unit.get_data(arg_80_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_2_event", get_data)
			end,
			on_complete_func = function (arg_81_0)
				-- function 81
				local get_data = Unit.get_data(arg_81_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_2_event", get_data)
			end
		}
	}
}
ObjectiveLists.weave_26 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_27 = {
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_007 = {
			is_scored = true,
			on_start_func = function (arg_82_0)
				-- function 82
				local get_data = Unit.get_data(arg_82_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", get_data)
			end
		},
		weave_limited_item_track_spawner_001 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function (arg_83_0)
				-- function 83
				local get_data = Unit.get_data(arg_83_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_skaven_specials_small", get_data)
			end
		}
	},
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_003 = {
			is_scored = true,
			on_start_func = function (arg_84_0)
				-- function 84
				local get_data = Unit.get_data(arg_84_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_minotaur_nodelay", get_data)
			end
		},
		weave_limited_item_track_spawner_006 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function (arg_85_0)
				-- function 85
				local get_data = Unit.get_data(arg_85_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_skaven_specials_medium", get_data)
			end
		}
	},
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_004 = {
			is_scored = true,
			on_start_func = function (arg_86_0)
				-- function 86
				local get_data = Unit.get_data(arg_86_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_specials_raid", get_data)
			end
		},
		weave_limited_item_track_spawner_004 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function (arg_87_0)
				-- function 87
				local get_data = Unit.get_data(arg_87_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_event_beastmen", get_data)
			end
		}
	}
}
ObjectiveLists.weave_28 = {
	{
		kill_enemies = {},
		weave_target_spawner_001 = {
			is_scored = true
		},
		weave_target_spawner_005 = {
			is_scored = true
		},
		weave_target_spawner_006 = {
			is_scored = true
		},
		weave_target_spawner_007 = {
			is_scored = true
		},
		weave_target_spawner_016 = {
			is_scored = true,
			on_complete_func = function (arg_88_0)
				-- function 88
				local get_data = Unit.get_data(arg_88_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_skaven", get_data)
			end
		},
		weave_target_spawner_022 = {
			is_scored = true
		},
		weave_target_spawner_031 = {
			is_scored = true
		},
		weave_target_spawner_034 = {
			is_scored = true
		},
		weave_target_spawner_041 = {
			is_scored = true
		},
		weave_target_spawner_043 = {
			is_scored = true,
			on_complete_func = function (arg_89_0)
				-- function 89
				local get_data = Unit.get_data(arg_89_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_skaven", get_data)
			end
		}
	}
}
ObjectiveLists.weave_29 = {
	{
		kill_enemies = {},
		weave_prop_skaven_doom_wheel_01_spawner_001 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function (arg_90_0)
				-- function 90
				local get_data = Unit.get_data(arg_90_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_rat_ogre", get_data)
			end
		},
		weave_prop_skaven_doom_wheel_01_spawner_002 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function (arg_91_0)
				-- function 91
				local get_data = Unit.get_data(arg_91_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_stormfiend", get_data)
			end
		},
		weave_limited_item_track_spawner_001 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function (arg_92_0)
				-- function 92
				local get_data = Unit.get_data(arg_92_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", get_data)
			end
		},
		weave_limited_item_track_spawner_004 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function (arg_93_0)
				-- function 93
				local get_data = Unit.get_data(arg_93_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_specials_raid", get_data)
			end
		}
	}
}
ObjectiveLists.weave_30 = {
	{
		kill_enemies = {},
		weave_target_spawner_004 = {
			is_scored = true,
			on_complete_func = function (arg_94_0)
				-- function 94
				local get_data = Unit.get_data(arg_94_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_rat_ogre_nodelay", get_data)
			end
		},
		weave_target_spawner_006 = {
			is_scored = true,
			on_complete_func = function (arg_95_0)
				-- function 95
				local get_data = Unit.get_data(arg_95_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", get_data)
			end
		},
		weave_target_spawner_028 = {
			is_scored = true,
			on_complete_func = function (arg_96_0)
				-- function 96
				local get_data = Unit.get_data(arg_96_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_minotaur_nodelay", get_data)
			end
		},
		weave_target_spawner_024 = {
			is_scored = true,
			on_complete_func = function (arg_97_0)
				-- function 97
				local get_data = Unit.get_data(arg_97_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_event_beastmen", get_data)
			end
		},
		weave_target_spawner_035 = {
			is_scored = true,
			on_complete_func = function (arg_98_0)
				-- function 98
				local get_data = Unit.get_data(arg_98_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_stormfiend_nodelay", get_data)
			end
		}
	}
}
ObjectiveLists.weave_31 = {
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_007 = {
			is_scored = true
		},
		weave_limited_item_track_spawner_007 = {
			template_name = "gargoyle_head_spawner"
		}
	},
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_004 = {
			is_scored = true
		},
		weave_limited_item_track_spawner_002 = {
			template_name = "gargoyle_head_spawner"
		}
	},
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_002 = {
			is_scored = true
		},
		weave_limited_item_track_spawner_005 = {
			template_name = "gargoyle_head_spawner"
		}
	}
}
ObjectiveLists.weave_32 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_33 = {
	{
		kill_enemies = {},
		weave_target_spawner_001 = {
			is_scored = true,
			on_complete_func = function (arg_99_0)
				-- function 99
				local get_data = Unit.get_data(arg_99_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", get_data)
			end
		},
		weave_target_spawner_005 = {
			is_scored = true,
			on_complete_func = function (arg_100_0)
				-- function 100
				local get_data = Unit.get_data(arg_100_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", get_data)
			end
		},
		weave_target_spawner_009 = {
			is_scored = true,
			on_complete_func = function (arg_101_0)
				-- function 101
				local get_data = Unit.get_data(arg_101_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", get_data)
			end
		},
		weave_target_spawner_013 = {
			is_scored = true,
			on_complete_func = function (arg_102_0)
				-- function 102
				local get_data = Unit.get_data(arg_102_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", get_data)
			end
		},
		weave_target_spawner_011 = {
			is_scored = true,
			on_complete_func = function (arg_103_0)
				-- function 103
				local get_data = Unit.get_data(arg_103_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", get_data)
			end
		},
		weave_target_spawner_012 = {
			is_scored = true,
			on_complete_func = function (arg_104_0)
				-- function 104
				local get_data = Unit.get_data(arg_104_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", get_data)
			end
		},
		weave_target_spawner_022 = {
			is_scored = true,
			on_complete_func = function (arg_105_0)
				-- function 105
				local get_data = Unit.get_data(arg_105_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", get_data)
			end
		},
		weave_target_spawner_028 = {
			is_scored = true,
			on_complete_func = function (arg_106_0)
				-- function 106
				local get_data = Unit.get_data(arg_106_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", get_data)
			end
		},
		weave_target_spawner_016 = {
			is_scored = true,
			on_complete_func = function (arg_107_0)
				-- function 107
				local get_data = Unit.get_data(arg_107_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", get_data)
			end
		},
		weave_target_spawner_015 = {
			is_scored = true,
			on_complete_func = function (arg_108_0)
				-- function 108
				local get_data = Unit.get_data(arg_108_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", get_data)
			end
		}
	}
}
ObjectiveLists.weave_34 = {
	{
		kill_enemies = {},
		capture_point_001 = {
			is_scored = true,
			on_start_func = function (arg_109_0)
				-- function 109
				local get_data = Unit.get_data(arg_109_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_3_event_no_chaos", get_data)
			end,
			on_complete_func = function (arg_110_0)
				-- function 110
				local get_data = Unit.get_data(arg_110_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_3_event_no_chaos", get_data)
			end
		},
		capture_point_002 = {
			is_scored = true,
			on_start_func = function (arg_111_0)
				-- function 111
				local get_data = Unit.get_data(arg_111_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_specials_raid", get_data)
			end,
			on_complete_func = function (arg_112_0)
				-- function 112
				local get_data = Unit.get_data(arg_112_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_specials_raid", get_data)
			end
		},
		capture_point_003 = {
			is_scored = true,
			on_start_func = function (arg_113_0)
				-- function 113
				local get_data = Unit.get_data(arg_113_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large_skaven", get_data)
			end,
			on_complete_func = function (arg_114_0)
				-- function 114
				local get_data = Unit.get_data(arg_114_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large_skaven", get_data)
			end
		},
		capture_point_004 = {
			is_scored = true,
			on_start_func = function (arg_115_0)
				-- function 115
				local get_data = Unit.get_data(arg_115_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_medium_no_chaos", get_data)
			end,
			on_complete_func = function (arg_116_0)
				-- function 116
				local get_data = Unit.get_data(arg_116_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_medium_no_chaos", get_data)
			end
		},
		capture_point_008 = {
			is_scored = true,
			on_start_func = function (arg_117_0)
				-- function 117
				local get_data = Unit.get_data(arg_117_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small_no_chaos", get_data)
			end,
			on_complete_func = function (arg_118_0)
				-- function 118
				local get_data = Unit.get_data(arg_118_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_small_no_chaos", get_data)
			end
		}
	}
}
ObjectiveLists.weave_35 = {
	{
		kill_enemies = {},
		weave_prop_skaven_doom_wheel_01_spawner_001 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function (arg_119_0)
				-- function 119
				local get_data = Unit.get_data(arg_119_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_skaven_gutter_runner", get_data)
			end
		},
		weave_limited_item_track_spawner_003 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function (arg_120_0)
				-- function 120
				local get_data = Unit.get_data(arg_120_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_event_beastmen", get_data)
			end
		}
	}
}
ObjectiveLists.weave_36 = {
	{
		kill_enemies = {},
		weave_target_spawner_001 = {
			is_scored = true
		},
		weave_target_spawner_002 = {
			is_scored = true
		},
		weave_target_spawner_004 = {
			is_scored = true
		},
		weave_target_spawner_005 = {
			is_scored = true
		},
		weave_target_spawner_006 = {
			is_scored = true
		},
		weave_target_spawner_007 = {
			is_scored = true
		},
		weave_target_spawner_008 = {
			is_scored = true
		},
		weave_target_spawner_009 = {
			is_scored = true
		},
		weave_target_spawner_011 = {
			is_scored = true
		},
		weave_target_spawner_010 = {
			is_scored = true
		},
		weave_target_spawner_014 = {
			is_scored = true
		},
		weave_target_spawner_016 = {
			is_scored = true
		},
		weave_target_spawner_018 = {
			is_scored = true
		},
		weave_target_spawner_019 = {
			is_scored = true
		},
		weave_target_spawner_023 = {
			is_scored = true
		},
		weave_target_spawner_024 = {
			is_scored = true
		},
		weave_target_spawner_027 = {
			is_scored = true
		},
		weave_target_spawner_026 = {
			is_scored = true
		}
	}
}
ObjectiveLists.weave_37 = {
	{
		kill_enemies = {},
		weave_prop_skaven_doom_wheel_01_spawner_001 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function (arg_121_0)
				-- function 121
				local get_data = Unit.get_data(arg_121_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_stormfiend", get_data)
			end
		},
		weave_prop_skaven_doom_wheel_01_spawner_002 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function (arg_122_0)
				-- function 122
				local get_data = Unit.get_data(arg_122_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_rat_ogre", get_data)
			end
		},
		weave_limited_item_track_spawner_004 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function (arg_123_0)
				-- function 123
				local get_data = Unit.get_data(arg_123_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_medium", get_data)
			end
		},
		weave_limited_item_track_spawner_002 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function (arg_124_0)
				-- function 124
				local get_data = Unit.get_data(arg_124_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_2_event", get_data)
			end
		}
	}
}
ObjectiveLists.weave_38 = {
	{
		kill_enemies = {},
		capture_point_001 = {
			timer = 25,
			is_scored = true,
			on_start_func = function (arg_125_0)
				-- function 125
				local get_data = Unit.get_data(arg_125_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_chaos", get_data)
			end,
			on_complete_func = function (arg_126_0)
				-- function 126
				local get_data = Unit.get_data(arg_126_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_chaos", get_data)
			end
		},
		capture_point_002 = {
			timer = 25,
			is_scored = true,
			on_start_func = function (arg_127_0)
				-- function 127
				local get_data = Unit.get_data(arg_127_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_2_event", get_data)
			end,
			on_complete_func = function (arg_128_0)
				-- function 128
				local get_data = Unit.get_data(arg_128_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_2_event", get_data)
			end
		},
		capture_point_003_skaven = {
			timer = 25,
			is_scored = true,
			on_start_func = function (arg_129_0)
				-- function 129
				local get_data = Unit.get_data(arg_129_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large_skaven", get_data)
			end,
			on_complete_func = function (arg_130_0)
				-- function 130
				local get_data = Unit.get_data(arg_130_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large_skaven", get_data)
			end
		},
		capture_point_006_skaven = {
			timer = 25,
			is_scored = true,
			on_start_func = function (arg_131_0)
				-- function 131
				local get_data = Unit.get_data(arg_131_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_6_boss_event_skaven", get_data)
			end,
			on_complete_func = function (arg_132_0)
				-- function 132
				local get_data = Unit.get_data(arg_132_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_6_boss_event_skaven", get_data)
			end
		},
		capture_point_007 = {
			timer = 25,
			is_scored = true,
			on_start_func = function (arg_133_0)
				-- function 133
				local get_data = Unit.get_data(arg_133_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large", get_data)
			end,
			on_complete_func = function (arg_134_0)
				-- function 134
				local get_data = Unit.get_data(arg_134_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large", get_data)
			end
		}
	}
}
ObjectiveLists.weave_39 = {
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_006 = {
			is_scored = true
		},
		weave_limited_item_track_spawner_003 = {
			template_name = "gargoyle_head_spawner"
		}
	}
}
ObjectiveLists.weave_40 = {
	{
		kill_enemies = {}
	}
}
ObjectiveLists.weave_woods_3_cps = {
	{
		kill_enemies = {},
		capture_point_001 = {
			is_scored = true,
			on_start_func = function (arg_135_0)
				-- function 135
				local get_data = Unit.get_data(arg_135_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", get_data)
			end,
			on_complete_func = function (arg_136_0)
				-- function 136
				local get_data = Unit.get_data(arg_136_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_small", get_data)
			end
		},
		capture_point_007 = {
			is_scored = true,
			on_start_func = function (arg_137_0)
				-- function 137
				local get_data = Unit.get_data(arg_137_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_medium", get_data)
			end,
			on_complete_func = function (arg_138_0)
				-- function 138
				local get_data = Unit.get_data(arg_138_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_medium", get_data)
			end
		},
		capture_point_008 = {
			is_scored = true,
			on_start_func = function (arg_139_0)
				-- function 139
				local get_data = Unit.get_data(arg_139_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_2_event", get_data)
			end,
			on_complete_func = function (arg_140_0)
				-- function 140
				local get_data = Unit.get_data(arg_140_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_2_event", get_data)
			end
		}
	}
}
ObjectiveLists.weave_woods_3_cps = {
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_007 = {
			is_scored = true,
			on_start_func = function (arg_141_0)
				-- function 141
				local get_data = Unit.get_data(arg_141_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", get_data)
			end
		},
		weave_explosive_barrel_socket_004 = {
			is_scored = true,
			on_start_func = function (arg_142_0)
				-- function 142
				local get_data = Unit.get_data(arg_142_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large_skaven", get_data)
			end
		},
		weave_explosive_barrel_socket_003 = {
			is_scored = true,
			on_start_func = function (arg_143_0)
				-- function 143
				local get_data = Unit.get_data(arg_143_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_chaos_troll", get_data)
			end
		},
		weave_limited_item_track_spawner_001 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function (arg_144_0)
				-- function 144
				local get_data = Unit.get_data(arg_144_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_chaos_warriors", get_data)
			end
		},
		weave_limited_item_track_spawner_006 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function (arg_145_0)
				-- function 145
				local get_data = Unit.get_data(arg_145_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_skaven_specials_medium", get_data)
			end
		},
		weave_limited_item_track_spawner_004 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function (arg_146_0)
				-- function 146
				local get_data = Unit.get_data(arg_146_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_chaos", get_data)
			end
		}
	}
}
ObjectiveLists["weave_27 - Copy"] = {
	{
		kill_enemies = {},
		weave_prop_skaven_doom_wheel_01_spawner_001 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function (arg_147_0)
				-- function 147
				local get_data = Unit.get_data(arg_147_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", get_data)
			end
		},
		weave_prop_skaven_doom_wheel_01_spawner_002 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function (arg_148_0)
				-- function 148
				local get_data = Unit.get_data(arg_148_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", get_data)
			end
		},
		weave_limited_item_track_spawner_003 = {
			template_name = "explosive_barrel_spawner",
			on_pickup_func = function (arg_149_0)
				-- function 149
				local get_data = Unit.get_data(arg_149_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_4_event", get_data)
			end
		},
		weave_limited_item_track_spawner_006 = {
			template_name = "explosive_barrel_spawner",
			on_pickup_func = function (arg_150_0)
				-- function 150
				local get_data = Unit.get_data(arg_150_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large", get_data)
			end
		}
	}
}

local tbl = {}

for k, v in pairs(ObjectiveLists) do
	for i, v_2 in ipairs(v) do
		table.clear(tbl)

		for k_2, v_3 in pairs(v_2) do
			local fassert = fassert
			local is_empty

			if not tbl[k_2] then
				is_empty = table.is_empty(v_3)

				if not is_empty then
					-- Nothing
				end

				if tbl[k_2] ~= v_3 then
					is_empty = false

					goto label_0_0
				end
			end

			is_empty = true

			::label_0_0::

			fassert(is_empty, "[ObjectiveLists] An objective set may not include multiple objectives of the same name, unless they don't contain any data or point to the same objective data reference. %s was found twice in list number %s in %s", k_2, i, k)

			tbl[k_2] = v_3
		end
	end
end
