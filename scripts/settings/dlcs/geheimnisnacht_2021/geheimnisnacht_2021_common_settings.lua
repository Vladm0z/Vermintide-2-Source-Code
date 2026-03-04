-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_common_settings.lua

local var_0_0 = DLCSettings.geheimnisnacht_2021

var_0_0.anim_lookup = {
	"idle_pray_01",
	"idle_pray_02",
	"idle_pray_03",
	"idle_pray_04",
	"idle_pray_05",
	"to_ritual_skull"
}
var_0_0.effects = {}
var_0_0.unlock_settings = {}
var_0_0.dialogue_lookup = {}
var_0_0.dialogue_settings = {}
var_0_0.auto_load_files = {}
var_0_0.network_sound_events = {
	"enemy_skaven_halloween_ritual_loop",
	"enemy_skaven_halloween_ritual_loop_stop",
	"enemy_marauder_halloween_ritual_loop",
	"enemy_marauder_halloween_ritual_loop_stop",
	"halloween_event_ritual_loop",
	"halloween_event_ritual_loop_stop",
	"Play_event_stinger_geheimnisnacht_ritual_broken"
}
var_0_0.entity_extensions = {
	"scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_altar_extension"
}
var_0_0.prop_extension = {
	"Geheimnisnacht2021AltarExtension"
}
var_0_0.death_reactions = {
	"scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_death_reactions"
}
var_0_0.interactions = {
	"geheimnisnacht_2021_altar"
}
var_0_0.interactions_filenames = {
	"scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_interactions"
}
var_0_0.unit_extension_templates = {
	"scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_unit_extension_templates"
}
var_0_0.husk_lookup = {
	"units/gameplay/ritual_site_01",
	"units/weapons/player/pup_ritual_site_01/pup_ritual_site_01"
}
var_0_0.generic_terror_event_files = {
	"scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_generic_terror_events"
}
var_0_0.mutators = {
	"geheimnisnacht_2021",
	"geheimnisnacht_2021_hard_mode"
}
var_0_0.missions = {
	mission_geheimnisnacht_2021_event = {
		mission_template_name = "goal",
		text = "mission_geheimnisnacht_2021_event"
	}
}
var_0_0.network_go_types = {
	"geheimnisnacht_2021_altar"
}
var_0_0.item_master_list_file_names = {
	"scripts/settings/dlcs/geheimnisnacht_2021/item_master_list_geheimnisnacht_2021"
}
var_0_0.weapon_skins_file_names = {
	"scripts/settings/dlcs/geheimnisnacht_2021/weapon_skins_geheimnisnacht_2021"
}
var_0_0.pickups = {
	level_events = {
		geheimnisnacht_2021_side_objective = {
			only_once = true,
			individual_pickup = false,
			slot_name = "slot_potion",
			item_description = "chaos_artifact",
			spawn_weighting = 1,
			debug_pickup_category = "special",
			pickup_sound_event = "pickup_medkit",
			type = "inventory_item",
			item_name = "wpn_geheimnisnacht_2021_side_objective",
			unit_name = "units/weapons/player/pup_ritual_site_01/pup_ritual_site_01",
			local_pickup_sound = true,
			hud_description = "chaos_artifact",
			disallow_bot_pickup = true
		}
	}
}
var_0_0.action_template_file_names = {
	"scripts/settings/dlcs/geheimnisnacht_2021/action_throw_geheimnisnacht_2021",
	"scripts/settings/dlcs/geheimnisnacht_2021/action_inspect_geheimnisnacht_2021"
}
var_0_0.action_classes_lookup = {
	throw_geheimnisnacht_2021 = "ActionThrowGeheimnisnacht2021",
	inspect_geheimnisnacht_2021 = "ActionInspectGeheimnisnacht2021"
}
var_0_0.game_object_templates = {
	geheimnisnacht_2021_altar = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit"
	}
}
var_0_0.game_object_initializers = {
	geheimnisnacht_2021_altar = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		local var_1_0 = ScriptUnit.has_extension(arg_1_0, "health_system")
		local var_1_1 = ScriptUnit.has_extension(arg_1_0, "props_system")

		return {
			go_type = NetworkLookup.go_types.geheimnisnacht_2021_altar,
			husk_unit = NetworkLookup.husks[arg_1_1],
			position = Unit.local_position(arg_1_0, 0),
			rotation = Unit.local_rotation(arg_1_0, 0),
			health = var_1_0:get_max_health(),
			state = var_1_1:get_current_state()
		}
	end
}
var_0_0.game_object_extractors = {
	geheimnisnacht_2021_altar = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		local var_2_0 = GameSession.game_object_field(arg_2_0, arg_2_1, "health")
		local var_2_1 = GameSession.game_object_field(arg_2_0, arg_2_1, "state")
		local var_2_2 = "geheimnisnacht_2021_altar"
		local var_2_3 = {
			health_system = {
				health = var_2_0
			},
			death_system = {
				death_reaction_template = "geheimnisnacht_2021_altar",
				is_husk = true
			},
			hit_reaction_system = {
				is_husk = true,
				hit_reaction_template = "level_object"
			},
			props_system = {
				state = var_2_1
			}
		}

		return var_2_2, var_2_3
	end
}
var_0_0.ai_group_templates = {
	geheimnisnacht_2021_altar_cultists = {
		setup_group = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			arg_3_2.idle = true
		end,
		init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			return
		end,
		update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			return
		end,
		destroy = function (arg_6_0, arg_6_1, arg_6_2)
			Managers.state.event:trigger("geheimnisnacht_2021_altar_cultists_killed", arg_6_2.id)
		end,
		wake_up_group = function (arg_7_0, arg_7_1)
			arg_7_0.idle = false, Managers.state.event:trigger("geheimnisnacht_2021_altar_cultists_aggroed", arg_7_0.id)

			Managers.state.entity:system("ai_group_system"):run_func_on_all_members(arg_7_0, AIGroupTemplates.geheimnisnacht_2021_altar_cultists.wake_up_unit, arg_7_1)
		end,
		wake_up_unit = function (arg_8_0, arg_8_1, arg_8_2)
			Managers.state.network:anim_event(arg_8_0, "idle")

			local var_8_0 = ScriptUnit.extension(arg_8_0, "ai_system")

			var_8_0:enemy_aggro(nil, arg_8_2)

			local var_8_1 = var_8_0._breed

			var_8_0:set_perception(var_8_1.perception, var_8_1.target_selection)

			local var_8_2 = BLACKBOARDS[arg_8_0]

			var_8_2.ignore_interest_points = false
			var_8_2.only_trust_your_own_eyes = false

			local var_8_3 = var_8_2.optional_spawn_data

			if var_8_3 then
				var_8_3.idle_animation = nil
			end
		end
	},
	critter_nurglings = {
		setup_group = function (arg_9_0, arg_9_1, arg_9_2)
			return
		end,
		init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			return
		end,
		update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			return
		end,
		destroy = function (arg_12_0, arg_12_1, arg_12_2)
			return
		end,
		wake_up_group = function (arg_13_0)
			Managers.state.entity:system("ai_group_system"):run_func_on_all_members(arg_13_0, AIGroupTemplates.critter_nurglings.wake_up_unit)
		end,
		wake_up_unit = function (arg_14_0, arg_14_1)
			BLACKBOARDS[arg_14_0].is_fleeing = true
		end
	}
}
