-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_common_settings.lua

local geheimnisnacht_2021 = DLCSettings.geheimnisnacht_2021

geheimnisnacht_2021.anim_lookup = {
	"idle_pray_01",
	"idle_pray_02",
	"idle_pray_03",
	"idle_pray_04",
	"idle_pray_05",
	"to_ritual_skull"
}
geheimnisnacht_2021.effects = {}
geheimnisnacht_2021.unlock_settings = {}
geheimnisnacht_2021.dialogue_lookup = {}
geheimnisnacht_2021.dialogue_settings = {}
geheimnisnacht_2021.auto_load_files = {}
geheimnisnacht_2021.network_sound_events = {
	"enemy_skaven_halloween_ritual_loop",
	"enemy_skaven_halloween_ritual_loop_stop",
	"enemy_marauder_halloween_ritual_loop",
	"enemy_marauder_halloween_ritual_loop_stop",
	"halloween_event_ritual_loop",
	"halloween_event_ritual_loop_stop",
	"Play_event_stinger_geheimnisnacht_ritual_broken"
}
geheimnisnacht_2021.entity_extensions = {
	"scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_altar_extension"
}
geheimnisnacht_2021.prop_extension = {
	"Geheimnisnacht2021AltarExtension"
}
geheimnisnacht_2021.death_reactions = {
	"scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_death_reactions"
}
geheimnisnacht_2021.interactions = {
	"geheimnisnacht_2021_altar"
}
geheimnisnacht_2021.interactions_filenames = {
	"scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_interactions"
}
geheimnisnacht_2021.unit_extension_templates = {
	"scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_unit_extension_templates"
}
geheimnisnacht_2021.husk_lookup = {
	"units/gameplay/ritual_site_01",
	"units/weapons/player/pup_ritual_site_01/pup_ritual_site_01"
}
geheimnisnacht_2021.generic_terror_event_files = {
	"scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_generic_terror_events"
}
geheimnisnacht_2021.mutators = {
	"geheimnisnacht_2021",
	"geheimnisnacht_2021_hard_mode"
}
geheimnisnacht_2021.missions = {
	mission_geheimnisnacht_2021_event = {
		mission_template_name = "goal",
		text = "mission_geheimnisnacht_2021_event"
	}
}
geheimnisnacht_2021.network_go_types = {
	"geheimnisnacht_2021_altar"
}
geheimnisnacht_2021.item_master_list_file_names = {
	"scripts/settings/dlcs/geheimnisnacht_2021/item_master_list_geheimnisnacht_2021"
}
geheimnisnacht_2021.weapon_skins_file_names = {
	"scripts/settings/dlcs/geheimnisnacht_2021/weapon_skins_geheimnisnacht_2021"
}
geheimnisnacht_2021.pickups = {
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
geheimnisnacht_2021.action_template_file_names = {
	"scripts/settings/dlcs/geheimnisnacht_2021/action_throw_geheimnisnacht_2021",
	"scripts/settings/dlcs/geheimnisnacht_2021/action_inspect_geheimnisnacht_2021"
}
geheimnisnacht_2021.action_classes_lookup = {
	throw_geheimnisnacht_2021 = "ActionThrowGeheimnisnacht2021",
	inspect_geheimnisnacht_2021 = "ActionInspectGeheimnisnacht2021"
}
geheimnisnacht_2021.game_object_templates = {
	geheimnisnacht_2021_altar = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit"
	}
}
geheimnisnacht_2021.game_object_initializers = {
	geheimnisnacht_2021_altar = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		local has_extension = ScriptUnit.has_extension(arg_1_0, "health_system")
		local has_extension_2 = ScriptUnit.has_extension(arg_1_0, "props_system")

		return {
			go_type = NetworkLookup.go_types.geheimnisnacht_2021_altar,
			husk_unit = NetworkLookup.husks[arg_1_1],
			position = Unit.local_position(arg_1_0, 0),
			rotation = Unit.local_rotation(arg_1_0, 0),
			health = has_extension:get_max_health(),
			state = has_extension_2:get_current_state()
		}
	end
}
geheimnisnacht_2021.game_object_extractors = {
	geheimnisnacht_2021_altar = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		local game_object_field = GameSession.game_object_field(arg_2_0, arg_2_1, "health")
		local game_object_field_2 = GameSession.game_object_field(arg_2_0, arg_2_1, "state")
		local str = "geheimnisnacht_2021_altar"
		local tbl = {
			health_system = {
				health = game_object_field
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
				state = game_object_field_2
			}
		}

		return str, tbl
	end
}
geheimnisnacht_2021.ai_group_templates = {
	geheimnisnacht_2021_altar_cultists = {
		setup_group = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			-- function 3
			arg_3_2.idle = true
		end,
		init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			-- function 4
			return
		end,
		update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			-- function 5
			return
		end,
		destroy = function (arg_6_0, arg_6_1, arg_6_2)
			-- function 6
			Managers.state.event:trigger("geheimnisnacht_2021_altar_cultists_killed", arg_6_2.id)
		end,
		wake_up_group = function (self, arg_7_1)
			-- function 7
			self.idle = false, Managers.state.event:trigger("geheimnisnacht_2021_altar_cultists_aggroed", self.id)

			Managers.state.entity:system("ai_group_system"):run_func_on_all_members(self, AIGroupTemplates.geheimnisnacht_2021_altar_cultists.wake_up_unit, arg_7_1)
		end,
		wake_up_unit = function (arg_8_0, arg_8_1, arg_8_2)
			-- function 8
			Managers.state.network:anim_event(arg_8_0, "idle")

			local extension = ScriptUnit.extension(arg_8_0, "ai_system")

			extension:enemy_aggro(nil, arg_8_2)

			local _breed = extension._breed

			extension:set_perception(_breed.perception, _breed.target_selection)

			local var_8_2 = BLACKBOARDS[arg_8_0]

			var_8_2.ignore_interest_points = false
			var_8_2.only_trust_your_own_eyes = false

			local optional_spawn_data = var_8_2.optional_spawn_data

			if not optional_spawn_data then
				optional_spawn_data.idle_animation = nil
			end
		end
	},
	critter_nurglings = {
		setup_group = function (arg_9_0, arg_9_1, arg_9_2)
			-- function 9
			return
		end,
		init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			-- function 10
			return
		end,
		update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			-- function 11
			return
		end,
		destroy = function (arg_12_0, arg_12_1, arg_12_2)
			-- function 12
			return
		end,
		wake_up_group = function (arg_13_0)
			-- function 13
			Managers.state.entity:system("ai_group_system"):run_func_on_all_members(arg_13_0, AIGroupTemplates.critter_nurglings.wake_up_unit)
		end,
		wake_up_unit = function (arg_14_0, arg_14_1)
			-- function 14
			BLACKBOARDS[arg_14_0].is_fleeing = true
		end
	}
}
