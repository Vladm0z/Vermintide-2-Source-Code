-- chunkname: @scripts/settings/dlcs/skulls_2023/skulls_2023_common_settings.lua

local var_0_0 = DLCSettings.skulls_2023

var_0_0.anim_lookup = {}
var_0_0.effects = {}
var_0_0.unlock_settings = {}
var_0_0.dialogue_lookup = {
	"dialogues/generated/lookup_npc_dlc_event_skulls"
}
var_0_0.dialogue_events = {
	"deus_using_a_weapon_shrine"
}
var_0_0.dialogue_settings = {}
var_0_0.auto_load_files = {}
var_0_0.network_sound_events = {}
var_0_0.entity_extensions = {}
var_0_0.prop_extension = {}
var_0_0.death_reactions = {}
var_0_0.interactions = {}
var_0_0.interactions_filenames = {}
var_0_0.unit_extension_templates = {}
var_0_0.husk_lookup = {
	"units/mutator/skulls_2023/pup_skull_of_fury"
}
var_0_0.generic_terror_event_files = {}
var_0_0.mutators = {
	"skulls_2023"
}
var_0_0.missions = {}
var_0_0.network_go_types = {}
var_0_0.item_master_list_file_names = {
	"scripts/settings/dlcs/skulls_2023/item_master_list_skulls_2023",
	"scripts/settings/dlcs/morris_2024/item_master_list_morris_2024"
}
var_0_0.weapon_skins_file_names = {
	"scripts/settings/dlcs/skulls_2023/weapon_skins_skulls_2023",
	"scripts/settings/dlcs/morris_2024/weapon_skins_morris_2024"
}
var_0_0.pickups = {
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
			on_pick_up_func = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
				if not arg_1_4 then
					Managers.state.entity:system("buff_system"):add_buff_synced(arg_1_1, "skulls_2023_buff", BuffSyncType.LocalAndServer)
				end

				Managers.state.achievement:trigger_event("register_skulls_2023_pickup")
				Managers.state.event:trigger("register_skulls_2023_pickup")

				for iter_1_0, iter_1_1 in pairs(Managers.player:human_and_bot_players()) do
					local var_1_0 = ScriptUnit.has_extension(iter_1_1.player_unit, "buff_system")

					if var_1_0 then
						var_1_0:trigger_procs("on_mutator_skull_picked_up", arg_1_1, arg_1_3)
					end
				end
			end
		}
	}
}
var_0_0.action_template_file_names = {}
var_0_0.action_classes_lookup = {}
var_0_0.game_object_templates = {}
var_0_0.game_object_initializers = {}
var_0_0.game_object_extractors = {}
var_0_0.ai_group_templates = {}
