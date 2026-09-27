-- chunkname: @scripts/settings/dlcs/skulls_2023/skulls_2023_common_settings.lua

local skulls_2023 = DLCSettings.skulls_2023

skulls_2023.anim_lookup = {}
skulls_2023.effects = {}
skulls_2023.unlock_settings = {}
skulls_2023.dialogue_lookup = {
	"dialogues/generated/lookup_npc_dlc_event_skulls"
}
skulls_2023.dialogue_events = {
	"deus_using_a_weapon_shrine"
}
skulls_2023.dialogue_settings = {}
skulls_2023.auto_load_files = {}
skulls_2023.network_sound_events = {}
skulls_2023.entity_extensions = {}
skulls_2023.prop_extension = {}
skulls_2023.death_reactions = {}
skulls_2023.interactions = {}
skulls_2023.interactions_filenames = {}
skulls_2023.unit_extension_templates = {}
skulls_2023.husk_lookup = {
	"units/mutator/skulls_2023/pup_skull_of_fury"
}
skulls_2023.generic_terror_event_files = {}
skulls_2023.mutators = {
	"skulls_2023"
}
skulls_2023.missions = {}
skulls_2023.network_go_types = {}
skulls_2023.item_master_list_file_names = {
	"scripts/settings/dlcs/skulls_2023/item_master_list_skulls_2023",
	"scripts/settings/dlcs/morris_2024/item_master_list_morris_2024"
}
skulls_2023.weapon_skins_file_names = {
	"scripts/settings/dlcs/skulls_2023/weapon_skins_skulls_2023",
	"scripts/settings/dlcs/morris_2024/weapon_skins_morris_2024"
}
skulls_2023.pickups = {
	level_events = {
		skulls_2023 = {
			only_once = true,
			individual_pickup = false,
			hide_on_pickup = true,
			item_description = "skulls_2023_pickup_name",
			spawn_weighting = 1,
			debug_pickup_category = "special",
			pickup_sound_event = "Play_skulls_event_skull_pickup",
			type = "custom",
			unit_name = "units/mutator/skulls_2023/pup_skull_of_fury",
			local_pickup_sound = true,
			hud_description = "skulls_2023_pickup_name",
			disallow_bot_pickup = true,
			on_pick_up_func = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
				-- function 1
				if not arg_1_4 then
					Managers.state.entity:system("buff_system"):add_buff_synced(arg_1_1, "skulls_2023_buff", BuffSyncType.LocalAndServer)
				end

				Managers.state.achievement:trigger_event("register_skulls_2023_pickup")
				Managers.state.event:trigger("register_skulls_2023_pickup")

				for k, v in pairs(Managers.player:human_and_bot_players()) do
					local has_extension = ScriptUnit.has_extension(v.player_unit, "buff_system")

					if not has_extension then
						has_extension:trigger_procs("on_mutator_skull_picked_up", arg_1_1, arg_1_3)
					end
				end
			end
		}
	}
}
skulls_2023.action_template_file_names = {}
skulls_2023.action_classes_lookup = {}
skulls_2023.game_object_templates = {}
skulls_2023.game_object_initializers = {}
skulls_2023.game_object_extractors = {}
skulls_2023.ai_group_templates = {}
