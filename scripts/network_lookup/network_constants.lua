-- chunkname: @scripts/network_lookup/network_constants.lua

NetworkConstants = NetworkConstants or {}

local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = Network.type_info(arg_1_0)

	if arg_1_2 == nil or arg_1_2 then
		NetworkConstants[arg_1_0] = var_1_0
	end

	local var_1_1 = #NetworkLookup[arg_1_1]
	local var_1_2 = var_1_0.max

	fassert(var_1_1 <= var_1_2, "Too many entries in NetworkLookup.%s (%d, max:%d), raise global.network_config value for %s by a factor 2.", arg_1_1, var_1_1, var_1_2, arg_1_0)
end

NetworkConstants.damage = Network.type_info("damage")
NetworkConstants.damage_hotjoin_sync = Network.type_info("damage_hotjoin_sync")
NetworkConstants.health = Network.type_info("health")
NetworkConstants.velocity = Network.type_info("velocity")
NetworkConstants.enemy_velocity = Network.type_info("enemy_velocity")
NetworkConstants.VELOCITY_EPSILON = Vector3.length(Vector3(NetworkConstants.velocity.tolerance, NetworkConstants.velocity.tolerance, NetworkConstants.velocity.tolerance)) * 1.1
NetworkConstants.position = Network.type_info("position")
NetworkConstants.rotation = Network.type_info("rotation")
NetworkConstants.enemy_rotation = Network.type_info("enemy_rotation")
NetworkConstants.max_attachments = 4
NetworkConstants.clock_time = Network.type_info("clock_time")
NetworkConstants.ping = Network.type_info("ping")
NetworkConstants.animation_variable_float = Network.type_info("animation_variable_float")
NetworkConstants.number = Network.type_info("number")
NetworkConstants.game_object_id_max = Network.type_info("game_object_id").max
NetworkConstants.invalid_game_object_id = NetworkConstants.game_object_id_max
NetworkConstants.max_overcharge = Network.type_info("max_overcharge")
NetworkConstants.max_energy = Network.type_info("max_energy")
NetworkConstants.weave_score = Network.type_info("weave_score")
NetworkConstants.statistics_path_max_size = Network.type_info("statistics_path").max_size

var_0_0("damage_profile", "damage_profiles")
var_0_0("anim_event", "anims")
var_0_0("bt_action_name", "bt_action_names")
var_0_0("surface_material_effect", "surface_material_effects")
var_0_0("vfx", "effects")
var_0_0("light_weight_projectile_lookup", "light_weight_projectile_effects")

NetworkConstants.light_weight_projectile_speed = Network.type_info("light_weight_projectile_speed")
NetworkConstants.light_weight_projectile_index = Network.type_info("light_weight_projectile_index")
NetworkConstants.weapon_id = Network.type_info("weapon_id")

local var_0_1 = #ItemMasterList

fassert(var_0_1 <= NetworkConstants.weapon_id.max, "Too many weapons in ItemMasterList, global.network_config value weapon_id needs to be raised.")

NetworkConstants.weight_array = Network.type_info("weight_array")

fassert(#NetworkLookup.level_keys <= NetworkConstants.weight_array.max_size, "Too many levels in LevelSettings, global.network_config value weight_array needs to be raised.")

local var_0_2 = #NetworkLookup.damage_sources

NetworkConstants.damage_source_id = Network.type_info("damage_source_id")

fassert(var_0_2 <= NetworkConstants.damage_source_id.max, "Too many damage sources, global.network_config value damage_source_id needs to be raised.")
fassert(var_0_1 <= var_0_2, "weapon_id lookup is set higher than damage_source_id lookup despite all weapons being damage sources.")
var_0_0("lookup", "weapon_skins")
var_0_0("action", "actions")
var_0_0("sub_action", "sub_actions")
var_0_0("item_template_name", "item_template_names")
var_0_0("buff_weapon_types", "buff_weapon_types")
var_0_0("terror_flow_event", "terror_flow_events")

NetworkConstants.story_time = Network.type_info("story_time")

var_0_0("fatigue_points", "fatigue_types")

local var_0_3 = NetworkConstants.damage_hotjoin_sync.max

for iter_0_0, iter_0_1 in pairs(Breeds) do
	local var_0_4 = iter_0_1.max_health

	if var_0_4 then
		for iter_0_2, iter_0_3 in ipairs(var_0_4) do
			fassert(iter_0_3 < var_0_3, "Assert, breed %s is unkillable since his health (%d) is bigger then max damage (%f) sent over the network. Raise global.network_config value for damage by a factor of 2", iter_0_0, iter_0_3, var_0_3)
		end
	end
end

NetworkConstants.teleports = Network.type_info("teleports")

var_0_0("marker_lookup", "markers")
var_0_0("dialogue_lookup", "dialogues")
var_0_0("player_status", "statuses")

NetworkConstants.uint_16 = Network.type_info("uint_16")
NetworkConstants.server_controlled_buff_id = Network.type_info("server_controlled_buff_id")

local var_0_5 = Network.type_info("uint_8")

fassert(var_0_5.bits == 8, "uint_8 is not 8 bits.")

local var_0_6 = Network.type_info("uint_16")

fassert(var_0_6.bits == 16, "uint_16 is not 16 bits.")

local var_0_7 = Network.type_info("uint_19")

fassert(var_0_7.bits == 19, "uint_19 is not 19 bits.")

local var_0_8 = Network.type_info("uint_32")

fassert(var_0_8.bits == 32, "uint_32 is not 32 bits.")

local var_0_9 = Network.type_info("int_32")

fassert(var_0_9.bits == 32, "int_32 is not 32 bits.")

NetworkConstants.max_breed_freezer_units_per_rpc = Network.type_info("packed_breed_go_ids").max_size

var_0_0("mutator_lookup", "mutator_templates")
var_0_0("buff_lookup", "buff_templates")
var_0_0("statistics_path_lookup", "statistics_path_names")

local var_0_10 = Network.type_info("mechanism_id")

fassert(table.size(MechanismSettings) <= var_0_10.max, "Too many mechanism settings, please up mechanism_id value in global.network_config")

local var_0_11 = Network.type_info("party_slot_id")

NetworkConstants.INVALID_PARTY_SLOT_ID = var_0_11.min

fassert(NetworkConstants.INVALID_PARTY_SLOT_ID == 0, "party_slot_ids should start at one because we need an invalid slot id for syncing purposes.")

local var_0_12 = Network.type_info("statistics_path_lookup").max
local var_0_13 = #NetworkLookup.statistics_path_names

fassert(var_0_13 <= var_0_12, "Too many entries in statistics_path lookup (%d, max:%d), raise global.network_config value for statistics_path by a factor 2", var_0_13, var_0_12)

NetworkConstants.mutator_array = Network.type_info("mutator_array")
NetworkConstants.buff_array = Network.type_info("buff_array")
NetworkConstants.buff_variable_type_array = Network.type_info("buff_variable_type_array")
NetworkConstants.buff_variable_data_array = Network.type_info("buff_variable_data_array")

local var_0_14 = Network.type_info("players_session_score").max_size
local var_0_15 = #ScoreboardHelper.scoreboard_topic_stats_versus * 8

fassert(var_0_15 <= var_0_14, "'ScoreboardHelper.scoreboard_topic_stats_versus' contains too many entries. Current: %s, Needed: %s", var_0_14, var_0_15)

local var_0_16 = Network.type_info("ready_request_id")

NetworkConstants.READY_REQUEST_ID_MAX = var_0_16.max

var_0_0("health_status_lookup", "health_statuses")
var_0_0("interaction_lookup", "interactions")
var_0_0("interaction_state_lookup", "interaction_states")
var_0_0("proc_function_lookup", "proc_functions")
var_0_0("difficulty_lookup", "difficulties")
var_0_0("objective_name_lookup", "objective_names")

local var_0_17 = Network.type_info("game_mode_state_id").max

for iter_0_4, iter_0_5 in pairs(GameModeSettings) do
	local var_0_18 = #iter_0_5.game_mode_states

	fassert(var_0_18 <= var_0_17, "Too many game mode states in %s, it has %u maximum is %u", iter_0_4, var_0_18, var_0_17)
end

require("scripts/settings/objective_lists")

local function var_0_19(arg_2_0)
	local var_2_0 = 1

	if arg_2_0.sub_objectives then
		for iter_2_0, iter_2_1 in pairs(arg_2_0.sub_objectives) do
			var_2_0 = var_2_0 + var_0_19(arg_2_0)
		end
	end

	return var_2_0
end

local var_0_20 = var_0_8.bits

for iter_0_6, iter_0_7 in pairs(ObjectiveLists) do
	for iter_0_8, iter_0_9 in ipairs(iter_0_7) do
		fassert(var_0_20 >= var_0_19(iter_0_9), "[ObjectiveLists] List '%s' contains more than %s objectives. Replace networked type for 'rpc_activate_objective' with an array that supports %s elements")
	end
end
