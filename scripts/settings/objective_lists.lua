-- chunkname: @scripts/settings/objective_lists.lua

local var_0_0 = require("scripts/entity_system/systems/objective/objective_types")
local var_0_1 = require("scripts/entity_system/systems/objective/objective_tags")

ObjectiveLists = {}

local var_0_2 = 1
local var_0_3 = 10
local var_0_4 = 10
local var_0_5 = 1
local var_0_6 = 1
local var_0_7 = 10
local var_0_8 = 20
local var_0_9 = 10
local var_0_10 = 1
local var_0_11 = 10

local function var_0_12(arg_1_0)
	return (arg_1_0 or 0) + 1
end

ObjectiveLists.bell_pvp_set_1 = {
	{
		versus_volume_objective_SZ01 = {
			description = "level_objective_description_vs_safe_zone",
			score_for_completion = 0,
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_SZ_01",
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_capture_objective_01 = {
			description = "level_objective_description_bell_02",
			play_arrive_vo = true,
			num_sections = 90,
			capture_time = 180,
			play_complete_vo = true,
			objective_type = var_0_0.objective_capture_point,
			score_per_section = var_0_6,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_2_0, arg_2_1)
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_008 = {
			description = "level_objective_description_bell_02_B",
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_01_B",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_02 = {
			description = "level_objective_description_bell_03",
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_02",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_socket_objective_01 = {
			description = "level_objective_description_bell_04",
			num_sockets = 3,
			play_arrive_vo = true,
			play_complete_vo = true,
			close_to_win_on_section = 3,
			objective_type = var_0_0.objective_socket,
			score_per_socket = var_0_8,
			vo_context_on_complete = {
				current_objective = "safe_room"
			},
			almost_done = function(arg_3_0, arg_3_1)
				local var_3_0 = arg_3_0.num_sockets
				local var_3_1 = arg_3_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_3_1):get_percentage_done() >= (var_3_0 - 1.5) / var_3_0 then
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_7
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_payload_objective_01 = {
			description = "level_objective_description_bell_07",
			num_sections = 90,
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_payload,
			score_per_section = var_0_5,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_4_0, arg_4_1)
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_07 = {
			description = "level_objective_description_bell_08A",
			volume_type = "any_alive",
			volume_name = "versus_bell_reach_04",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_05 = {
			description = "level_objective_description_bell_08",
			volume_type = "any_alive",
			volume_name = "versus_reach_bell",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		sub_objective_container_01 = {
			description = "level_objective_description_bell_09",
			play_complete_vo = true,
			close_to_win_on_section = 3,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_target,
			vo_context_on_complete = {
				current_objective = "waystone"
			},
			almost_done = function(arg_5_0, arg_5_1)
				local var_5_0 = Managers.state.entity:system("objective_system")

				if var_5_0:num_current_sub_objectives() - var_5_0:num_current_completed_sub_objectives() <= 3 then
					return true
				end
			end,
			sub_objectives = {
				sub_sub_objective_container_01 = {
					description = "level_objective_description_bell_09",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9 * 3,
					sub_objectives = {
						versus_target_objective_bell_01 = {
							description = "level_objective_description_bell_09",
							objective_tag = var_0_1.objective_tag_chains,
							objective_type = var_0_0.objective_target
						},
						versus_target_objective_bell_02 = {
							description = "level_objective_description_bell_09",
							objective_tag = var_0_1.objective_tag_chains,
							objective_type = var_0_0.objective_target
						},
						versus_target_objective_bell_03 = {
							description = "level_objective_description_bell_09",
							objective_tag = var_0_1.objective_tag_chains,
							objective_type = var_0_0.objective_target
						}
					}
				},
				sub_sub_objective_container_02 = {
					description = "level_objective_description_bell_09",
					score_for_completion = var_0_9 * 3,
					sub_objectives = {
						versus_target_objective_bell_04 = {
							description = "level_objective_description_bell_09",
							objective_tag = var_0_1.objective_tag_chains,
							objective_type = var_0_0.objective_target
						},
						versus_target_objective_bell_05 = {
							description = "level_objective_description_bell_09",
							objective_tag = var_0_1.objective_tag_chains,
							objective_type = var_0_0.objective_target
						},
						versus_target_objective_bell_06 = {
							description = "level_objective_description_bell_09",
							objective_tag = var_0_1.objective_tag_chains,
							objective_type = var_0_0.objective_target
						}
					}
				},
				sub_sub_objective_container_03 = {
					description = "level_objective_description_bell_09",
					score_for_completion = var_0_9 * 3,
					sub_objectives = {
						versus_target_objective_bell_07 = {
							description = "level_objective_description_bell_09",
							objective_tag = var_0_1.objective_tag_chains,
							objective_type = var_0_0.objective_target
						},
						versus_target_objective_bell_08 = {
							description = "level_objective_description_bell_09",
							objective_tag = var_0_1.objective_tag_chains,
							objective_type = var_0_0.objective_target
						},
						versus_target_objective_bell_09 = {
							description = "level_objective_description_bell_09",
							objective_tag = var_0_1.objective_tag_chains,
							objective_type = var_0_0.objective_target
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_06 = {
			description = "level_objective_description_bell_10",
			volume_type = "all_alive",
			play_arrive_vo = true,
			volume_name = "versus_reach_waystone",
			play_waystone_vo = true,
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_11
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_franz = {
			description = "level_objective_description_military_01",
			volume_type = "any_alive",
			volume_name = "versus_military_reach_franz",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_socket_objective_01 = {
			description = "level_objective_description_military_02",
			num_sockets = 2,
			play_arrive_vo = true,
			play_complete_vo = true,
			close_to_win_on_section = 2,
			objective_type = var_0_0.objective_socket,
			score_per_socket = var_0_8,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_6_0, arg_6_1)
				local var_6_0 = arg_6_0.num_sockets
				local var_6_1 = arg_6_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_6_1):get_percentage_done() >= (var_6_0 - 1.5) / var_6_0 then
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_interact_objective_military_001 = {
			description = "level_objective_description_military_04",
			play_arrive_vo = true,
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4
		}
	},
	{
		versus_survive_objective_01 = {
			description = "level_objective_description_military_05",
			num_sections = 40,
			time_for_completion = 90,
			score_for_completion = 0,
			play_complete_vo = true,
			objective_type = var_0_0.objective_survive,
			score_per_section = var_0_10,
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_7
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_03_B = {
			description = "level_objective_description_military_07_B",
			volume_type = "any_alive",
			volume_name = "versus_military_reach_03_B",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_04 = {
			description = "level_objective_description_military_09",
			volume_type = "any_alive",
			volume_name = "versus_military_reach_04",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_capture_point_objective_003 = {
			description = "level_objective_description_military_10",
			play_arrive_vo = true,
			num_sections = 90,
			capture_time = 180,
			play_complete_vo = true,
			objective_type = var_0_0.objective_capture_point,
			score_per_section = var_0_6,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_7_0, arg_7_1)
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_interact_objective_military_002 = {
			description = "level_objective_description_military_12",
			mission_name = "military_move_along_wall",
			play_arrive_vo = true,
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4,
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
			objective_type = var_0_0.objective_survive,
			score_per_section = var_0_10,
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
			objective_type = var_0_0.objective_socket,
			score_per_socket = var_0_8,
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
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4,
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_7
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_capture_point_objective_004 = {
			description = "level_objective_description_military_17",
			play_arrive_vo = true,
			num_sections = 95,
			capture_time = 210,
			play_complete_vo = true,
			objective_type = var_0_0.objective_capture_point,
			score_per_section = var_0_6,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_8_0, arg_8_1)
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_mission_objective_004 = {
			description = "level_objective_description_military_19",
			mission_name = "military_ring_bell",
			play_arrive_vo = true,
			score_for_completion = var_0_4,
			objective_type = var_0_0.objective_interact
		}
	},
	{
		versus_survive_objective_02 = {
			description = "level_objective_description_military_20",
			time_for_completion = 190,
			num_sections = 95,
			play_complete_vo = true,
			score_for_completion = 0,
			objective_type = var_0_0.objective_survive,
			score_per_section = var_0_10,
			vo_context_on_complete = {
				current_objective = "waystone"
			},
			almost_done = function(arg_9_0, arg_9_1)
				local var_9_0 = Managers.state.entity:system("objective_system")

				if var_9_0:num_current_sub_objectives() - var_9_0:num_current_completed_sub_objectives() <= 1 then
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_3
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_farmlands_01_farm = {
			description = "level_objective_description_farmlands_01_farm",
			volume_type = "any_alive",
			volume_name = "versus_reach_001_farm",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_farmlands_02_road = {
			description = "level_objective_description_farmlands_02_road",
			volume_type = "any_alive",
			volume_name = "versus_reach_02_road",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_farmlands_02 = {
			description = "level_objective_description_farmlands_03",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_002",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		sub_objective_container_01 = {
			description = "level_objective_description_farmlands_04",
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_target,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_10_0, arg_10_1)
				local var_10_0 = Managers.state.entity:system("objective_system")

				if var_10_0:num_current_sub_objectives() - var_10_0:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_target_objective_001 = {
					description = "level_objective_description_farmlands_04",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9
				},
				versus_target_objective_002 = {
					description = "level_objective_description_farmlands_04",
					score_for_completion = var_0_9,
					objective_type = var_0_0.objective_target
				},
				versus_target_objective_003 = {
					description = "level_objective_description_farmlands_04",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9
				},
				versus_target_objective_004 = {
					description = "level_objective_description_farmlands_04",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9
				},
				versus_target_objective_005 = {
					description = "level_objective_description_farmlands_04",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9
				},
				versus_target_objective_006 = {
					description = "level_objective_description_farmlands_04",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9
				}
			}
		}
	},
	{
		versus_volume_objective_farmlands_03 = {
			description = "level_objective_description_farmlands_05",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_003",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_farmlands_04 = {
			description = "level_objective_description_farmlands_06",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_004",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_mission_objective_farmlands_key = {
			description = "level_objective_description_farmlands_07",
			mission_name = "versus_mission_farmlands_key",
			play_arrive_vo = true,
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4
		}
	},
	{
		versus_mission_objective_open_barn = {
			description = "level_objective_description_farmlands_08",
			mission_name = "versus_mission_objective_barn",
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4
		}
	},
	{
		versus_mission_objective_monster = {
			description = "level_objective_description_farmlands_09",
			mission_name = "versus_mission_monster",
			play_complete_vo = true,
			score_for_completion = 30,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_survive,
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
			objective_type = var_0_0.objective_socket,
			score_per_socket = var_0_8,
			almost_done = function(arg_11_0, arg_11_1)
				local var_11_0 = arg_11_0.num_sockets
				local var_11_1 = arg_11_1[1]

				if Managers.state.entity:system("objective_system"):extension_by_objective_name(var_11_1):get_percentage_done() >= (var_11_0 - 1.5) / var_11_0 then
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_7
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_capture_point_objective_road = {
			description = "level_objective_description_farmlands_12",
			play_arrive_vo = true,
			num_sections = 80,
			capture_time = 180,
			play_complete_vo = true,
			objective_type = var_0_0.objective_capture_point,
			score_per_section = var_0_6,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_12_0, arg_12_1)
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_farmlands_07 = {
			description = "level_objective_description_farmlands_13",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_007",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_farmlands_08 = {
			description = "level_objective_description_farmlands_14",
			volume_type = "any_alive",
			volume_name = "volume_versus_reach_008",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_interact_objective_prisoners_streets = {
			description = "level_objective_description_farmlands_15",
			objective_type = var_0_0.objective_interact,
			objective_tag = var_0_1.objective_tag_prisoner,
			score_for_completion = var_0_4
		}
	},
	{
		sub_objective_container_prisoners_01 = {
			description = "level_objective_description_farmlands_16",
			play_arrive_vo = true,
			objective_type = var_0_0.objective_interact,
			almost_done = function(arg_13_0, arg_13_1)
				local var_13_0 = Managers.state.entity:system("objective_system")

				if var_13_0:num_current_sub_objectives() - var_13_0:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_interact_objective_prisoners_001 = {
					description = "level_objective_description_farmlands_16",
					objective_tag = var_0_1.objective_tag_prisoner,
					objective_type = var_0_0.objective_interact,
					score_for_completion = var_0_4
				},
				versus_interact_objective_prisoners_002 = {
					description = "level_objective_description_farmlands_16",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
				},
				versus_interact_objective_prisoners_003 = {
					description = "level_objective_description_farmlands_16",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
				},
				versus_interact_objective_prisoners_004 = {
					description = "level_objective_description_farmlands_16",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
				}
			}
		}
	},
	{
		sub_objective_container_prisoners_02 = {
			description = "level_objective_description_farmlands_17",
			objective_type = var_0_0.objective_interact,
			almost_done = function(arg_14_0, arg_14_1)
				local var_14_0 = Managers.state.entity:system("objective_system")

				if var_14_0:num_current_sub_objectives() - var_14_0:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_interact_objective_prisoners_005 = {
					description = "level_objective_description_farmlands_17",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
				},
				versus_interact_objective_prisoners_006 = {
					description = "level_objective_description_farmlands_17",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
				}
			}
		}
	},
	{
		sub_objective_container_prisoners_03 = {
			description = "level_objective_description_farmlands_18",
			play_complete_vo = true,
			objective_type = var_0_0.objective_interact,
			objective_tag = var_0_1.objective_tag_prisoner,
			vo_context_on_complete = {
				current_objective = "waystone"
			},
			almost_done = function(arg_15_0, arg_15_1)
				local var_15_0 = Managers.state.entity:system("objective_system")

				if var_15_0:num_current_sub_objectives() - var_15_0:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_interact_objective_prisoners_007 = {
					description = "level_objective_description_farmlands_18",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
				},
				versus_interact_objective_prisoners_008 = {
					description = "level_objective_description_farmlands_18",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
				},
				versus_interact_objective_prisoners_009 = {
					description = "level_objective_description_farmlands_18",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
				},
				versus_interact_objective_prisoners_010 = {
					description = "level_objective_description_farmlands_18",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_11
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_capture_point_objective_001 = {
			description = "level_objective_description_fort_02",
			play_arrive_vo = true,
			num_sections = 50,
			capture_time = 120,
			play_complete_vo = true,
			objective_type = var_0_0.objective_capture_point,
			score_per_section = var_0_6,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_16_0, arg_16_1)
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_003 = {
			description = "level_objective_description_fort_03",
			volume_type = "any_alive",
			volume_name = "versus_reach_003",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_payload_objective_01 = {
			description = "level_objective_description_fort_04",
			num_sections = 70,
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_payload,
			score_per_section = var_0_5,
			vo_context_on_complete = {
				current_objective = "safe_room"
			},
			almost_done = function(arg_17_0, arg_17_1)
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_005 = {
			description = "level_objective_description_vs_reach_safe_zone",
			volume_type = "all_alive",
			play_safehouse_vo = true,
			volume_name = "versus_reach_005",
			play_arrive_vo = true,
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_7
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_fort_interact_001 = {
			description = "level_objective_description_fort_07",
			play_arrive_vo = true,
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4,
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
			objective_type = var_0_0.objective_interact,
			sub_objectives = {
				versus_interact_fort_tower_001 = {
					description = "level_objective_description_fort_07_B",
					objective_type = var_0_0.objective_interact,
					score_for_completion = var_0_4
				},
				versus_interact_fort_tower_002 = {
					description = "level_objective_description_fort_07_B",
					objective_type = var_0_0.objective_interact,
					score_for_completion = var_0_4
				},
				versus_interact_fort_tower_003 = {
					description = "level_objective_description_fort_07_B",
					objective_type = var_0_0.objective_interact,
					score_for_completion = var_0_4
				}
			},
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_18_0, arg_18_1)
				local var_18_0 = Managers.state.entity:system("objective_system")

				if var_18_0:num_current_sub_objectives() - var_18_0:num_current_completed_sub_objectives() <= 1 then
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_009 = {
			description = "level_objective_description_fort_09",
			volume_type = "any_alive",
			volume_name = "versus_reach_009",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_payload_objective_02 = {
			description = "level_objective_description_fort_10",
			num_sections = 90,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_payload,
			score_per_section = var_0_5,
			almost_done = function(arg_19_0, arg_19_1)
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
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4,
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_7
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		sub_objective_container_cannon_balls = {
			description = "level_objective_description_fort_13",
			play_complete_vo = true,
			objective_type = var_0_0.objective_socket,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_20_0, arg_20_1)
				local var_20_0 = Managers.state.entity:system("objective_system")

				if var_20_0:num_current_sub_objectives() - var_20_0:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_socket_objective_01 = {
					description = "level_objective_description_fort_13",
					objective_type = var_0_0.objective_socket,
					score_for_completion = var_0_8
				},
				versus_socket_objective_02 = {
					description = "level_objective_description_fort_13",
					objective_type = var_0_0.objective_socket,
					score_for_completion = var_0_8
				}
			}
		}
	},
	{
		versus_interact_objective_elevator = {
			description = "level_objective_description_fort_14",
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4
		}
	},
	{
		versus_volume_objective_013 = {
			description = "level_objective_description_fort_15",
			volume_type = "any_alive",
			volume_name = "versus_reach_013",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_014 = {
			description = "level_objective_description_fort_16",
			volume_type = "any_alive",
			volume_name = "versus_reach_014",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_interaction_fort_portcullis = {
			description = "level_objective_description_fort_17",
			play_arrive_vo = true,
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4,
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
			objective_type = var_0_0.objective_survive,
			score_per_section = var_0_10,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		sub_objective_container_cannons = {
			description = "level_objective_description_fort_18",
			play_arrive_vo = true,
			objective_type = var_0_0.objective_interact,
			sub_objectives = {
				versus_interact_cannon_01 = {
					description = "level_objective_description_fort_18",
					objective_type = var_0_0.objective_interact,
					score_for_completion = var_0_8 + var_0_4
				},
				versus_interact_cannon_02 = {
					description = "level_objective_description_fort_18",
					objective_type = var_0_0.objective_interact,
					score_for_completion = var_0_8 + var_0_4
				}
			}
		}
	},
	{
		versus_socket_objective_fort = {
			description = "level_objective_description_military_13",
			num_sockets = 1,
			objective_type = var_0_0.objective_socket,
			score_per_socket = var_0_8,
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
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4,
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_11
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		sub_objective_container_01 = {
			description = "level_objective_description_forest_ambush_02",
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_target,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_21_0, arg_21_1)
				local var_21_0 = Managers.state.entity:system("objective_system")

				if var_21_0:num_current_sub_objectives() - var_21_0:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_target_objective_001 = {
					description = "level_objective_description_forest_ambush_02",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9
				},
				versus_target_objective_002 = {
					description = "level_objective_description_forest_ambush_02",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9
				},
				versus_target_objective_003 = {
					description = "level_objective_description_forest_ambush_02",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9
				},
				versus_target_objective_004 = {
					description = "level_objective_description_forest_ambush_02",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9
				},
				versus_target_objective_005 = {
					description = "level_objective_description_forest_ambush_02",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9
				}
			}
		}
	},
	{
		versus_volume_objective_03 = {
			description = "level_objective_description_forest_ambush_03",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_003",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_04 = {
			description = "level_objective_description_forest_ambush_04",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_004",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_payload_objective_01 = {
			description = "level_objective_description_forest_ambush_05",
			num_sections = 20,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_payload,
			score_per_section = var_0_5,
			vo_context_on_activate = {
				objective_part = 1
			},
			vo_context_on_complete = {
				objective_part = 2
			},
			almost_done = function(arg_22_0, arg_22_1)
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
			objective_type = var_0_0.objective_survive,
			score_per_section = var_0_10,
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_7
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		sub_objective_container_doomwheels_01 = {
			description = "level_objective_description_forest_ambush_08",
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_socket,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_23_0, arg_23_1)
				local var_23_0 = Managers.state.entity:system("objective_system")

				if var_23_0:num_current_sub_objectives() - var_23_0:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_socket_objective_doomwheels_001 = {
					description = "level_objective_description_forest_ambush_08",
					objective_type = var_0_0.objective_socket,
					score_for_completion = var_0_8
				},
				versus_socket_objective_doomwheels_002 = {
					description = "level_objective_description_forest_ambush_08",
					objective_type = var_0_0.objective_socket,
					score_for_completion = var_0_8
				},
				versus_socket_objective_doomwheels_003 = {
					description = "level_objective_description_forest_ambush_08",
					objective_type = var_0_0.objective_socket,
					score_for_completion = var_0_8
				}
			}
		}
	},
	{
		versus_volume_objective_08_B = {
			description = "level_objective_description_forest_ambush_08_B",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_008_B",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_08 = {
			description = "level_objective_description_forest_ambush_09",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_008",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		sub_objective_container_gargoyle_heads_01 = {
			description = "level_objective_description_forest_ambush_11",
			play_arrive_vo = true,
			objective_type = var_0_0.objective_socket,
			vo_context_on_complete = {
				current_objective = "three"
			},
			almost_done = function(arg_24_0, arg_24_1)
				local var_24_0 = Managers.state.entity:system("objective_system")

				if var_24_0:num_current_sub_objectives() - var_24_0:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_socket_objective_gargoyles_001 = {
					description = "level_objective_description_forest_ambush_11",
					objective_type = var_0_0.objective_socket,
					score_for_completion = var_0_8
				},
				versus_socket_objective_gargoyles_002 = {
					description = "level_objective_description_forest_ambush_11",
					objective_type = var_0_0.objective_socket,
					score_for_completion = var_0_8
				}
			}
		}
	},
	{
		versus_volume_objective_09 = {
			description = "level_objective_description_forest_ambush_10",
			volume_type = "any_alive",
			volume_name = "versus_forest_ambush_reach_009",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		sub_objective_container_prisoners_01 = {
			description = "level_objective_description_forest_ambush_11_B",
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_interact,
			vo_context_on_complete = {
				current_objective = "safe_room"
			},
			almost_done = function(arg_25_0, arg_25_1)
				local var_25_0 = Managers.state.entity:system("objective_system")

				if var_25_0:num_current_sub_objectives() - var_25_0:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_interact_objective_prisoners_001 = {
					description = "level_objective_description_forest_ambush_11_B",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
				},
				versus_interact_objective_prisoners_002 = {
					description = "level_objective_description_forest_ambush_11_B",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
				},
				versus_interact_objective_prisoners_003 = {
					description = "level_objective_description_forest_ambush_11_B",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
				},
				versus_interact_objective_prisoners_004 = {
					description = "level_objective_description_forest_ambush_11_B",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
				},
				versus_interact_objective_prisoners_005 = {
					description = "level_objective_description_forest_ambush_11_B",
					objective_type = var_0_0.objective_interact,
					objective_tag = var_0_1.objective_tag_prisoner,
					score_for_completion = var_0_4
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_7
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_capture_point_001 = {
			description = "level_objective_description_forest_ambush_12_B",
			num_sections = 80,
			play_arrive_vo = true,
			capture_time = 180,
			play_complete_vo = true,
			objective_type = var_0_0.objective_capture_point,
			score_per_section = var_0_6,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_interact_ring_bell = {
			description = "level_objective_description_forest_ambush_14",
			play_arrive_vo = true,
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4
		}
	},
	{
		versus_survive_objective_01 = {
			description = "level_objective_description_forest_ambush_15",
			time_for_completion = 180,
			num_sections = 100,
			play_complete_vo = true,
			score_for_completion = 0,
			objective_type = var_0_0.objective_survive,
			score_per_section = var_0_10,
			vo_context_on_complete = {
				current_objective = "waystone"
			},
			almost_done = function(arg_26_0, arg_26_1)
				local var_26_0 = Managers.state.entity:system("objective_system")

				if var_26_0:num_current_sub_objectives() - var_26_0:num_current_completed_sub_objectives() <= 1 then
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_11
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_exterior_002 = {
			description = "level_objective_description_exterior_02",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_002",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_exterior_003 = {
			description = "level_objective_description_exterior_03",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_003",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_capture_objective_01 = {
			description = "level_objective_description_exterior_04",
			play_arrive_vo = true,
			num_sections = 25,
			capture_time = 180,
			play_complete_vo = true,
			objective_type = var_0_0.objective_capture_point,
			score_per_section = var_0_6,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_27_0, arg_27_1)
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_interact_objective_exterior_001 = {
			description = "level_objective_description_exterior_06_A",
			play_arrive_vo = true,
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4,
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
			objective_type = var_0_0.objective_survive,
			score_per_section = var_0_10,
			on_last_leaf_complete_sound_event = {
				heroes = "versus_hud_sub_objective_completed_heroes",
				dark_pact = "versus_hud_sub_objective_completed_pactsworn"
			}
		}
	},
	{
		versus_interact_objective_exterior_002 = {
			description = "level_objective_description_exterior_06_B",
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4,
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
			objective_type = var_0_0.objective_survive,
			score_per_section = var_0_10,
			on_last_leaf_complete_sound_event = {
				heroes = "versus_hud_sub_objective_completed_heroes",
				dark_pact = "versus_hud_sub_objective_completed_pactsworn"
			}
		}
	},
	{
		versus_interact_objective_exterior_003 = {
			description = "level_objective_description_exterior_06_C",
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4
		}
	},
	{
		versus_survive_objective_03 = {
			description = "level_objective_description_exterior_07_C",
			num_sections = 5,
			time_for_completion = 20,
			score_for_completion = 0,
			play_complete_vo = true,
			objective_type = var_0_0.objective_survive,
			score_per_section = var_0_10,
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_7
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_payload_objective_exterior_01 = {
			description = "level_objective_description_exterior_09",
			num_sections = 70,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_payload,
			score_per_section = var_0_5,
			vo_context_on_complete = {
				current_objective = "two"
			},
			almost_done = function(arg_28_0, arg_28_1)
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
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4
		}
	},
	{
		versus_volume_objective_exterior_011 = {
			description = "level_objective_description_exterior_11",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_011",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		sub_objective_container_mad_dog = {
			description = "level_objective_description_exterior_12",
			close_to_win_on_sub_objective = 2,
			play_arrive_vo = true,
			play_complete_vo = true,
			objective_type = var_0_0.objective_target,
			vo_context_on_activate = {
				objective_part = 1
			},
			vo_context_on_complete = {
				current_objective = "safe_room"
			},
			almost_done = function(arg_29_0, arg_29_1)
				local var_29_0 = Managers.state.entity:system("objective_system")

				if var_29_0:num_current_sub_objectives() - var_29_0:num_current_completed_sub_objectives() <= 1 then
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
					objective_type = var_0_0.objective_capture_point,
					score_per_section = var_0_6,
					vo_context_on_complete = {
						objective_part = var_0_12
					}
				},
				versus_capture_objective_mine_002 = {
					always_show_objective_marker = true,
					capture_time = 80,
					num_sections = 30,
					description = "level_objective_description_exterior_12",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_capture_points_reminder",
					objective_type = var_0_0.objective_capture_point,
					score_per_section = var_0_6,
					vo_context_on_complete = {
						objective_part = var_0_12
					}
				},
				versus_capture_objective_mine_003 = {
					always_show_objective_marker = true,
					capture_time = 80,
					num_sections = 30,
					description = "level_objective_description_exterior_12",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_capture_points_reminder",
					objective_type = var_0_0.objective_capture_point,
					score_per_section = var_0_6,
					vo_context_on_complete = {
						objective_part = var_0_12
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_7
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
			objective_type = var_0_0.objective_reach,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_exterior_015 = {
			description = "level_objective_description_exterior_15",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_015",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_interact_objective_bombcart = {
			description = "level_objective_description_exterior_20",
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		versus_volume_objective_exterior_017 = {
			description = "level_objective_description_exterior_17",
			volume_type = "any_alive",
			volume_name = "versus_exterior_reach_017",
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3,
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
			objective_type = var_0_0.objective_reach,
			score_for_completion = var_0_3
		}
	},
	{
		sub_objective_container_01 = {
			description = "level_objective_description_exterior_19",
			play_complete_vo = true,
			play_arrive_vo = true,
			objective_type = var_0_0.objective_target,
			vo_context_on_activate = {
				destroyed_chains = 0,
				objective_part = 2
			},
			vo_context_on_complete = {
				objective_part = 3
			},
			almost_done = function(arg_30_0, arg_30_1)
				local var_30_0 = Managers.state.entity:system("objective_system")

				if var_30_0:num_current_sub_objectives() - var_30_0:num_current_completed_sub_objectives() <= 1 then
					return true
				end
			end,
			sub_objectives = {
				versus_target_objective_001 = {
					description = "level_objective_description_exterior_19",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_chains_reminder",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9,
					vo_context_on_complete = {
						destroyed_chains = var_0_12
					}
				},
				versus_target_objective_002 = {
					description = "level_objective_description_exterior_19",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_chains_reminder",
					score_for_completion = var_0_9,
					objective_type = var_0_0.objective_target,
					vo_context_on_complete = {
						destroyed_chains = var_0_12
					}
				},
				versus_target_objective_003 = {
					description = "level_objective_description_exterior_19",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_chains_reminder",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9,
					vo_context_on_complete = {
						destroyed_chains = var_0_12
					}
				},
				versus_target_objective_004 = {
					description = "level_objective_description_exterior_19",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_chains_reminder",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9,
					vo_context_on_complete = {
						destroyed_chains = var_0_12
					}
				},
				versus_target_objective_005 = {
					description = "level_objective_description_exterior_19",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_chains_reminder",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9,
					vo_context_on_complete = {
						destroyed_chains = var_0_12
					}
				},
				versus_target_objective_006 = {
					description = "level_objective_description_exterior_19",
					play_dialogue_event_on_complete = true,
					dialogue_event = "vs_mg_dwarf_external_chains_reminder",
					objective_type = var_0_0.objective_target,
					score_for_completion = var_0_9,
					vo_context_on_complete = {
						destroyed_chains = var_0_12
					}
				}
			}
		}
	},
	{
		versus_interact_objective_bombcart_again = {
			description = "level_objective_description_exterior_20",
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4,
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
			objective_type = var_0_0.objective_survive,
			score_per_section = var_0_10
		}
	},
	{
		versus_interact_objective_ignite_bomb = {
			description = "level_objective_description_exterior_21",
			objective_type = var_0_0.objective_interact,
			score_for_completion = var_0_4
		}
	},
	{
		versus_survive_objective_04 = {
			description = "level_objective_description_exterior_22",
			num_sections = 40,
			time_for_completion = 20,
			score_for_completion = 0,
			play_complete_vo = true,
			objective_type = var_0_0.objective_survive,
			score_per_section = var_0_10,
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
			objective_type = var_0_0.objective_safehouse,
			score_for_each_player_inside = var_0_3
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
			on_start_func = function(arg_31_0)
				local var_31_0 = Unit.get_data(arg_31_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_3_event", var_31_0)
			end,
			on_complete_func = function(arg_32_0)
				local var_32_0 = Unit.get_data(arg_32_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_3_event", var_32_0)
			end
		},
		capture_point_002 = {
			is_scored = true,
			on_start_func = function(arg_33_0)
				local var_33_0 = Unit.get_data(arg_33_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", var_33_0)
			end,
			on_complete_func = function(arg_34_0)
				local var_34_0 = Unit.get_data(arg_34_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_small", var_34_0)
			end
		},
		capture_point_005 = {
			is_scored = true,
			on_start_func = function(arg_35_0)
				local var_35_0 = Unit.get_data(arg_35_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large", var_35_0)
			end,
			on_complete_func = function(arg_36_0)
				local var_36_0 = Unit.get_data(arg_36_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large", var_36_0)
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
			on_start_func = function(arg_37_0)
				local var_37_0 = Unit.get_data(arg_37_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_3_event", var_37_0)
			end,
			on_complete_func = function(arg_38_0)
				local var_38_0 = Unit.get_data(arg_38_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_3_event", var_38_0)
			end
		},
		capture_point_001 = {
			is_scored = true,
			sort_index = 1,
			on_start_func = function(arg_39_0)
				local var_39_0 = Unit.get_data(arg_39_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", var_39_0)
			end,
			on_complete_func = function(arg_40_0)
				local var_40_0 = Unit.get_data(arg_40_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_small", var_40_0)
			end
		},
		capture_point_002 = {
			is_scored = true,
			sort_index = 2,
			on_start_func = function(arg_41_0)
				local var_41_0 = Unit.get_data(arg_41_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large", var_41_0)
			end,
			on_complete_func = function(arg_42_0)
				local var_42_0 = Unit.get_data(arg_42_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large", var_42_0)
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
			on_socket_start_func = function(arg_43_0)
				local var_43_0 = Unit.get_data(arg_43_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_skaven_gutter_runner", var_43_0)
			end
		},
		weave_limited_item_track_spawner_002 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function(arg_44_0)
				local var_44_0 = Unit.get_data(arg_44_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", var_44_0)
			end
		}
	},
	{
		kill_enemies = {},
		weave_prop_skaven_doom_wheel_01_spawner_001 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function(arg_45_0)
				local var_45_0 = Unit.get_data(arg_45_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_minotaur", var_45_0)
			end
		},
		weave_limited_item_track_spawner_003 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function(arg_46_0)
				local var_46_0 = Unit.get_data(arg_46_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_chaos_spawn_nodelay", var_46_0)
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
			on_start_func = function(arg_47_0)
				local var_47_0 = Unit.get_data(arg_47_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_chaos", var_47_0)
			end,
			on_complete_func = function(arg_48_0)
				local var_48_0 = Unit.get_data(arg_48_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_chaos", var_48_0)
			end
		},
		capture_point_002 = {
			is_scored = true,
			on_start_func = function(arg_49_0)
				local var_49_0 = Unit.get_data(arg_49_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_6_boss_event_skaven", var_49_0)
			end,
			on_complete_func = function(arg_50_0)
				local var_50_0 = Unit.get_data(arg_50_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_6_boss_event_skaven", var_50_0)
			end
		},
		capture_point_003 = {
			is_scored = true,
			on_start_func = function(arg_51_0)
				local var_51_0 = Unit.get_data(arg_51_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_event_beastmen", var_51_0)
			end,
			on_complete_func = function(arg_52_0)
				local var_52_0 = Unit.get_data(arg_52_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_event_beastmen", var_52_0)
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
			on_start_func = function(arg_53_0)
				local var_53_0 = Unit.get_data(arg_53_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_3_event", var_53_0)
			end,
			on_complete_func = function(arg_54_0)
				local var_54_0 = Unit.get_data(arg_54_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_3_event", var_54_0)
			end
		},
		capture_point_001 = {
			is_scored = true,
			on_start_func = function(arg_55_0)
				local var_55_0 = Unit.get_data(arg_55_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", var_55_0)
			end,
			on_complete_func = function(arg_56_0)
				local var_56_0 = Unit.get_data(arg_56_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_small", var_56_0)
			end
		},
		capture_point_003 = {
			is_scored = true,
			on_start_func = function(arg_57_0)
				local var_57_0 = Unit.get_data(arg_57_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large", var_57_0)
			end,
			on_complete_func = function(arg_58_0)
				local var_58_0 = Unit.get_data(arg_58_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large", var_58_0)
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
			on_socket_start_func = function(arg_59_0)
				local var_59_0 = Unit.get_data(arg_59_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_stormfiend", var_59_0)
			end
		},
		weave_prop_skaven_doom_wheel_01_spawner_002 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function(arg_60_0)
				local var_60_0 = Unit.get_data(arg_60_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_chaos_spawn", var_60_0)
			end
		},
		weave_limited_item_track_spawner_001 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function(arg_61_0)
				local var_61_0 = Unit.get_data(arg_61_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_medium", var_61_0)
			end
		},
		weave_limited_item_track_spawner_007 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function(arg_62_0)
				local var_62_0 = Unit.get_data(arg_62_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_specials_raid", var_62_0)
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
			on_start_func = function(arg_63_0)
				local var_63_0 = Unit.get_data(arg_63_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_specials_raid", var_63_0)
			end
		},
		weave_limited_item_track_spawner_004 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function(arg_64_0)
				local var_64_0 = Unit.get_data(arg_64_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_chaos_warriors", var_64_0)
			end
		}
	},
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_002 = {
			is_scored = true,
			on_start_func = function(arg_65_0)
				local var_65_0 = Unit.get_data(arg_65_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_event_beastmen", var_65_0)
			end
		},
		weave_limited_item_track_spawner_007 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function(arg_66_0)
				local var_66_0 = Unit.get_data(arg_66_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_skaven_specials_small", var_66_0)
			end
		}
	},
	{
		kill_enemies = {},
		weave_limited_item_track_spawner_006 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function(arg_67_0)
				local var_67_0 = Unit.get_data(arg_67_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", var_67_0)
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
			on_start_func = function(arg_68_0)
				local var_68_0 = Unit.get_data(arg_68_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large_skaven", var_68_0)
			end,
			on_complete_func = function(arg_69_0)
				local var_69_0 = Unit.get_data(arg_69_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large_skaven", var_69_0)
			end
		},
		capture_point_002 = {
			is_scored = true,
			on_start_func = function(arg_70_0)
				local var_70_0 = Unit.get_data(arg_70_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_2_event", var_70_0)
			end,
			on_complete_func = function(arg_71_0)
				local var_71_0 = Unit.get_data(arg_71_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_2_event", var_71_0)
			end
		},
		capture_point_003 = {
			is_scored = true,
			on_start_func = function(arg_72_0)
				local var_72_0 = Unit.get_data(arg_72_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_event_beastmen", var_72_0)
			end,
			on_complete_func = function(arg_73_0)
				local var_73_0 = Unit.get_data(arg_73_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_event_beastmen", var_73_0)
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
			on_socket_start_func = function(arg_74_0)
				local var_74_0 = Unit.get_data(arg_74_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_chaos_spawn", var_74_0)
			end
		},
		weave_limited_item_track_spawner_009 = {
			template_name = "magic_barrel_spawner",
			on_first_pickup_func = function(arg_75_0)
				local var_75_0 = Unit.get_data(arg_75_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_3_event", var_75_0)
			end
		}
	}
}
ObjectiveLists.weave_25 = {
	{
		kill_enemies = {},
		capture_point_007 = {
			is_scored = true,
			on_start_func = function(arg_76_0)
				local var_76_0 = Unit.get_data(arg_76_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_medium", var_76_0)
			end,
			on_complete_func = function(arg_77_0)
				local var_77_0 = Unit.get_data(arg_77_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_medium", var_77_0)
			end
		},
		capture_point_008 = {
			is_scored = true,
			on_start_func = function(arg_78_0)
				local var_78_0 = Unit.get_data(arg_78_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_3_event", var_78_0)
			end,
			on_complete_func = function(arg_79_0)
				local var_79_0 = Unit.get_data(arg_79_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_3_event", var_79_0)
			end
		},
		capture_point_005 = {
			is_scored = true,
			on_start_func = function(arg_80_0)
				local var_80_0 = Unit.get_data(arg_80_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_2_event", var_80_0)
			end,
			on_complete_func = function(arg_81_0)
				local var_81_0 = Unit.get_data(arg_81_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_2_event", var_81_0)
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
			on_start_func = function(arg_82_0)
				local var_82_0 = Unit.get_data(arg_82_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", var_82_0)
			end
		},
		weave_limited_item_track_spawner_001 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function(arg_83_0)
				local var_83_0 = Unit.get_data(arg_83_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_skaven_specials_small", var_83_0)
			end
		}
	},
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_003 = {
			is_scored = true,
			on_start_func = function(arg_84_0)
				local var_84_0 = Unit.get_data(arg_84_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_minotaur_nodelay", var_84_0)
			end
		},
		weave_limited_item_track_spawner_006 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function(arg_85_0)
				local var_85_0 = Unit.get_data(arg_85_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_skaven_specials_medium", var_85_0)
			end
		}
	},
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_004 = {
			is_scored = true,
			on_start_func = function(arg_86_0)
				local var_86_0 = Unit.get_data(arg_86_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_specials_raid", var_86_0)
			end
		},
		weave_limited_item_track_spawner_004 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function(arg_87_0)
				local var_87_0 = Unit.get_data(arg_87_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_event_beastmen", var_87_0)
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
			on_complete_func = function(arg_88_0)
				local var_88_0 = Unit.get_data(arg_88_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_skaven", var_88_0)
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
			on_complete_func = function(arg_89_0)
				local var_89_0 = Unit.get_data(arg_89_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_skaven", var_89_0)
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
			on_socket_start_func = function(arg_90_0)
				local var_90_0 = Unit.get_data(arg_90_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_rat_ogre", var_90_0)
			end
		},
		weave_prop_skaven_doom_wheel_01_spawner_002 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function(arg_91_0)
				local var_91_0 = Unit.get_data(arg_91_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_stormfiend", var_91_0)
			end
		},
		weave_limited_item_track_spawner_001 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function(arg_92_0)
				local var_92_0 = Unit.get_data(arg_92_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", var_92_0)
			end
		},
		weave_limited_item_track_spawner_004 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function(arg_93_0)
				local var_93_0 = Unit.get_data(arg_93_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_specials_raid", var_93_0)
			end
		}
	}
}
ObjectiveLists.weave_30 = {
	{
		kill_enemies = {},
		weave_target_spawner_004 = {
			is_scored = true,
			on_complete_func = function(arg_94_0)
				local var_94_0 = Unit.get_data(arg_94_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_rat_ogre_nodelay", var_94_0)
			end
		},
		weave_target_spawner_006 = {
			is_scored = true,
			on_complete_func = function(arg_95_0)
				local var_95_0 = Unit.get_data(arg_95_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", var_95_0)
			end
		},
		weave_target_spawner_028 = {
			is_scored = true,
			on_complete_func = function(arg_96_0)
				local var_96_0 = Unit.get_data(arg_96_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_minotaur_nodelay", var_96_0)
			end
		},
		weave_target_spawner_024 = {
			is_scored = true,
			on_complete_func = function(arg_97_0)
				local var_97_0 = Unit.get_data(arg_97_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_event_beastmen", var_97_0)
			end
		},
		weave_target_spawner_035 = {
			is_scored = true,
			on_complete_func = function(arg_98_0)
				local var_98_0 = Unit.get_data(arg_98_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_stormfiend_nodelay", var_98_0)
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
			on_complete_func = function(arg_99_0)
				local var_99_0 = Unit.get_data(arg_99_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", var_99_0)
			end
		},
		weave_target_spawner_005 = {
			is_scored = true,
			on_complete_func = function(arg_100_0)
				local var_100_0 = Unit.get_data(arg_100_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", var_100_0)
			end
		},
		weave_target_spawner_009 = {
			is_scored = true,
			on_complete_func = function(arg_101_0)
				local var_101_0 = Unit.get_data(arg_101_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", var_101_0)
			end
		},
		weave_target_spawner_013 = {
			is_scored = true,
			on_complete_func = function(arg_102_0)
				local var_102_0 = Unit.get_data(arg_102_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", var_102_0)
			end
		},
		weave_target_spawner_011 = {
			is_scored = true,
			on_complete_func = function(arg_103_0)
				local var_103_0 = Unit.get_data(arg_103_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", var_103_0)
			end
		},
		weave_target_spawner_012 = {
			is_scored = true,
			on_complete_func = function(arg_104_0)
				local var_104_0 = Unit.get_data(arg_104_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", var_104_0)
			end
		},
		weave_target_spawner_022 = {
			is_scored = true,
			on_complete_func = function(arg_105_0)
				local var_105_0 = Unit.get_data(arg_105_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", var_105_0)
			end
		},
		weave_target_spawner_028 = {
			is_scored = true,
			on_complete_func = function(arg_106_0)
				local var_106_0 = Unit.get_data(arg_106_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", var_106_0)
			end
		},
		weave_target_spawner_016 = {
			is_scored = true,
			on_complete_func = function(arg_107_0)
				local var_107_0 = Unit.get_data(arg_107_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", var_107_0)
			end
		},
		weave_target_spawner_015 = {
			is_scored = true,
			on_complete_func = function(arg_108_0)
				local var_108_0 = Unit.get_data(arg_108_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_special_mixed", var_108_0)
			end
		}
	}
}
ObjectiveLists.weave_34 = {
	{
		kill_enemies = {},
		capture_point_001 = {
			is_scored = true,
			on_start_func = function(arg_109_0)
				local var_109_0 = Unit.get_data(arg_109_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_3_event_no_chaos", var_109_0)
			end,
			on_complete_func = function(arg_110_0)
				local var_110_0 = Unit.get_data(arg_110_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_3_event_no_chaos", var_110_0)
			end
		},
		capture_point_002 = {
			is_scored = true,
			on_start_func = function(arg_111_0)
				local var_111_0 = Unit.get_data(arg_111_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_specials_raid", var_111_0)
			end,
			on_complete_func = function(arg_112_0)
				local var_112_0 = Unit.get_data(arg_112_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_specials_raid", var_112_0)
			end
		},
		capture_point_003 = {
			is_scored = true,
			on_start_func = function(arg_113_0)
				local var_113_0 = Unit.get_data(arg_113_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large_skaven", var_113_0)
			end,
			on_complete_func = function(arg_114_0)
				local var_114_0 = Unit.get_data(arg_114_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large_skaven", var_114_0)
			end
		},
		capture_point_004 = {
			is_scored = true,
			on_start_func = function(arg_115_0)
				local var_115_0 = Unit.get_data(arg_115_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_medium_no_chaos", var_115_0)
			end,
			on_complete_func = function(arg_116_0)
				local var_116_0 = Unit.get_data(arg_116_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_medium_no_chaos", var_116_0)
			end
		},
		capture_point_008 = {
			is_scored = true,
			on_start_func = function(arg_117_0)
				local var_117_0 = Unit.get_data(arg_117_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small_no_chaos", var_117_0)
			end,
			on_complete_func = function(arg_118_0)
				local var_118_0 = Unit.get_data(arg_118_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_small_no_chaos", var_118_0)
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
			on_socket_start_func = function(arg_119_0)
				local var_119_0 = Unit.get_data(arg_119_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_skaven_gutter_runner", var_119_0)
			end
		},
		weave_limited_item_track_spawner_003 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function(arg_120_0)
				local var_120_0 = Unit.get_data(arg_120_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("objective_event_beastmen", var_120_0)
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
			on_socket_start_func = function(arg_121_0)
				local var_121_0 = Unit.get_data(arg_121_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_stormfiend", var_121_0)
			end
		},
		weave_prop_skaven_doom_wheel_01_spawner_002 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function(arg_122_0)
				local var_122_0 = Unit.get_data(arg_122_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_rat_ogre", var_122_0)
			end
		},
		weave_limited_item_track_spawner_004 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function(arg_123_0)
				local var_123_0 = Unit.get_data(arg_123_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_medium", var_123_0)
			end
		},
		weave_limited_item_track_spawner_002 = {
			template_name = "explosive_barrel_spawner",
			on_first_pickup_func = function(arg_124_0)
				local var_124_0 = Unit.get_data(arg_124_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_2_event", var_124_0)
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
			on_start_func = function(arg_125_0)
				local var_125_0 = Unit.get_data(arg_125_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_chaos", var_125_0)
			end,
			on_complete_func = function(arg_126_0)
				local var_126_0 = Unit.get_data(arg_126_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_chaos", var_126_0)
			end
		},
		capture_point_002 = {
			timer = 25,
			is_scored = true,
			on_start_func = function(arg_127_0)
				local var_127_0 = Unit.get_data(arg_127_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_2_event", var_127_0)
			end,
			on_complete_func = function(arg_128_0)
				local var_128_0 = Unit.get_data(arg_128_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_2_event", var_128_0)
			end
		},
		capture_point_003_skaven = {
			timer = 25,
			is_scored = true,
			on_start_func = function(arg_129_0)
				local var_129_0 = Unit.get_data(arg_129_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large_skaven", var_129_0)
			end,
			on_complete_func = function(arg_130_0)
				local var_130_0 = Unit.get_data(arg_130_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large_skaven", var_130_0)
			end
		},
		capture_point_006_skaven = {
			timer = 25,
			is_scored = true,
			on_start_func = function(arg_131_0)
				local var_131_0 = Unit.get_data(arg_131_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_6_boss_event_skaven", var_131_0)
			end,
			on_complete_func = function(arg_132_0)
				local var_132_0 = Unit.get_data(arg_132_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_6_boss_event_skaven", var_132_0)
			end
		},
		capture_point_007 = {
			timer = 25,
			is_scored = true,
			on_start_func = function(arg_133_0)
				local var_133_0 = Unit.get_data(arg_133_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large", var_133_0)
			end,
			on_complete_func = function(arg_134_0)
				local var_134_0 = Unit.get_data(arg_134_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_large", var_134_0)
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
			on_start_func = function(arg_135_0)
				local var_135_0 = Unit.get_data(arg_135_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", var_135_0)
			end,
			on_complete_func = function(arg_136_0)
				local var_136_0 = Unit.get_data(arg_136_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_small", var_136_0)
			end
		},
		capture_point_007 = {
			is_scored = true,
			on_start_func = function(arg_137_0)
				local var_137_0 = Unit.get_data(arg_137_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_medium", var_137_0)
			end,
			on_complete_func = function(arg_138_0)
				local var_138_0 = Unit.get_data(arg_138_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_1_event_medium", var_138_0)
			end
		},
		capture_point_008 = {
			is_scored = true,
			on_start_func = function(arg_139_0)
				local var_139_0 = Unit.get_data(arg_139_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_2_event", var_139_0)
			end,
			on_complete_func = function(arg_140_0)
				local var_140_0 = Unit.get_data(arg_140_0, "terror_event_spawner_id")

				Managers.weave:stop_terror_event("capture_point_2_event", var_140_0)
			end
		}
	}
}
ObjectiveLists.weave_woods_3_cps = {
	{
		kill_enemies = {},
		weave_explosive_barrel_socket_007 = {
			is_scored = true,
			on_start_func = function(arg_141_0)
				local var_141_0 = Unit.get_data(arg_141_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", var_141_0)
			end
		},
		weave_explosive_barrel_socket_004 = {
			is_scored = true,
			on_start_func = function(arg_142_0)
				local var_142_0 = Unit.get_data(arg_142_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large_skaven", var_142_0)
			end
		},
		weave_explosive_barrel_socket_003 = {
			is_scored = true,
			on_start_func = function(arg_143_0)
				local var_143_0 = Unit.get_data(arg_143_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_boss_chaos_troll", var_143_0)
			end
		},
		weave_limited_item_track_spawner_001 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function(arg_144_0)
				local var_144_0 = Unit.get_data(arg_144_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_chaos_warriors", var_144_0)
			end
		},
		weave_limited_item_track_spawner_006 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function(arg_145_0)
				local var_145_0 = Unit.get_data(arg_145_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("weave_spot_event_skaven_specials_medium", var_145_0)
			end
		},
		weave_limited_item_track_spawner_004 = {
			template_name = "gargoyle_head_spawner",
			on_first_pickup_func = function(arg_146_0)
				local var_146_0 = Unit.get_data(arg_146_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_chaos", var_146_0)
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
			on_socket_start_func = function(arg_147_0)
				local var_147_0 = Unit.get_data(arg_147_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", var_147_0)
			end
		},
		weave_prop_skaven_doom_wheel_01_spawner_002 = {
			timer = 10,
			is_scored = true,
			on_socket_start_func = function(arg_148_0)
				local var_148_0 = Unit.get_data(arg_148_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_small", var_148_0)
			end
		},
		weave_limited_item_track_spawner_003 = {
			template_name = "explosive_barrel_spawner",
			on_pickup_func = function(arg_149_0)
				local var_149_0 = Unit.get_data(arg_149_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_4_event", var_149_0)
			end
		},
		weave_limited_item_track_spawner_006 = {
			template_name = "explosive_barrel_spawner",
			on_pickup_func = function(arg_150_0)
				local var_150_0 = Unit.get_data(arg_150_0, "terror_event_spawner_id")

				Managers.weave:start_terror_event("capture_point_1_event_large", var_150_0)
			end
		}
	}
}

local var_0_13 = {}

for iter_0_0, iter_0_1 in pairs(ObjectiveLists) do
	for iter_0_2, iter_0_3 in ipairs(iter_0_1) do
		table.clear(var_0_13)

		for iter_0_4, iter_0_5 in pairs(iter_0_3) do
			fassert(not var_0_13[iter_0_4] or table.is_empty(iter_0_5) or var_0_13[iter_0_4] == iter_0_5, "[ObjectiveLists] An objective set may not include multiple objectives of the same name, unless they don't contain any data or point to the same objective data reference. %s was found twice in list number %s in %s", iter_0_4, iter_0_2, iter_0_0)

			var_0_13[iter_0_4] = iter_0_5
		end
	end
end
