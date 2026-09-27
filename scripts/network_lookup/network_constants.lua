-- chunkname: @scripts/network_lookup/network_constants.lua

local NetworkConstants = NetworkConstants

NetworkConstants = NetworkConstants or {}
NetworkConstants = NetworkConstants
NetworkConstants.max_string_length = 500

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local type_info = Network.type_info(arg_1_0)

	if arg_1_2 == nil or not arg_1_2 then
		NetworkConstants[arg_1_0] = type_info
	end

	local count = #NetworkLookup[arg_1_1]
	local max = type_info.max

	fassert(count <= max, "Too many entries in NetworkLookup.%s (%d, max:%d), raise global.network_config value for %s by a factor 2.", arg_1_1, count, max, arg_1_0)
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

fn("damage_profile", "damage_profiles")
fn("anim_event", "anims")
fn("bt_action_name", "bt_action_names")
fn("surface_material_effect", "surface_material_effects")
fn("vfx", "effects")
fn("light_weight_projectile_lookup", "light_weight_projectile_effects")

NetworkConstants.light_weight_projectile_speed = Network.type_info("light_weight_projectile_speed")
NetworkConstants.light_weight_projectile_index = Network.type_info("light_weight_projectile_index")
NetworkConstants.weapon_id = Network.type_info("weapon_id")

local count = #ItemMasterList

fassert(count <= NetworkConstants.weapon_id.max, "Too many weapons in ItemMasterList, global.network_config value weapon_id needs to be raised.")

NetworkConstants.weight_array = Network.type_info("weight_array")

fassert(#NetworkLookup.level_keys <= NetworkConstants.weight_array.max_size, "Too many levels in LevelSettings, global.network_config value weight_array needs to be raised.")

local count_2 = #NetworkLookup.damage_sources

NetworkConstants.damage_source_id = Network.type_info("damage_source_id")

fassert(count_2 <= NetworkConstants.damage_source_id.max, "Too many damage sources, global.network_config value damage_source_id needs to be raised.")
fassert(count <= count_2, "weapon_id lookup is set higher than damage_source_id lookup despite all weapons being damage sources.")
fn("lookup", "weapon_skins")
fn("action", "actions")
fn("sub_action", "sub_actions")
fn("item_template_name", "item_template_names")
fn("buff_weapon_types", "buff_weapon_types")
fn("terror_flow_event", "terror_flow_events")

NetworkConstants.story_time = Network.type_info("story_time")

fn("fatigue_points", "fatigue_types")

local max = NetworkConstants.damage_hotjoin_sync.max

for k, v in pairs(Breeds) do
	local max_health = v.max_health

	if not max_health then
		for i, v_2 in ipairs(max_health) do
			fassert(v_2 < max, "Assert, breed %s is unkillable since his health (%d) is bigger then max damage (%f) sent over the network. Raise global.network_config value for damage by a factor of 2", k, v_2, max)
		end
	end
end

NetworkConstants.teleports = Network.type_info("teleports")

fn("marker_lookup", "markers")
fn("dialogue_lookup", "dialogues")
fn("player_status", "statuses")

NetworkConstants.uint_16 = Network.type_info("uint_16")
NetworkConstants.server_controlled_buff_id = Network.type_info("server_controlled_buff_id")

local type_info = Network.type_info("uint_8")

fassert(type_info.bits == 8, "uint_8 is not 8 bits.")

local type_info_2 = Network.type_info("uint_16")

fassert(type_info_2.bits == 16, "uint_16 is not 16 bits.")

local type_info_3 = Network.type_info("uint_19")

fassert(type_info_3.bits == 19, "uint_19 is not 19 bits.")

local type_info_4 = Network.type_info("uint_32")

fassert(type_info_4.bits == 32, "uint_32 is not 32 bits.")

local type_info_5 = Network.type_info("int_32")

fassert(type_info_5.bits == 32, "int_32 is not 32 bits.")

NetworkConstants.max_breed_freezer_units_per_rpc = Network.type_info("packed_breed_go_ids").max_size

fn("mutator_lookup", "mutator_templates")
fn("buff_lookup", "buff_templates")
fn("statistics_path_lookup", "statistics_path_names")

local type_info_6 = Network.type_info("mechanism_id")

fassert(table.size(MechanismSettings) <= type_info_6.max, "Too many mechanism settings, please up mechanism_id value in global.network_config")

local type_info_7 = Network.type_info("party_slot_id")

NetworkConstants.INVALID_PARTY_SLOT_ID = type_info_7.min

fassert(NetworkConstants.INVALID_PARTY_SLOT_ID == 0, "party_slot_ids should start at one because we need an invalid slot id for syncing purposes.")

local max_2 = Network.type_info("statistics_path_lookup").max
local count_3 = #NetworkLookup.statistics_path_names

fassert(count_3 <= max_2, "Too many entries in statistics_path lookup (%d, max:%d), raise global.network_config value for statistics_path by a factor 2", count_3, max_2)

NetworkConstants.mutator_array = Network.type_info("mutator_array")
NetworkConstants.buff_array = Network.type_info("buff_array")
NetworkConstants.buff_variable_type_array = Network.type_info("buff_variable_type_array")
NetworkConstants.buff_variable_data_array = Network.type_info("buff_variable_data_array")

local max_size = Network.type_info("players_session_score").max_size
local num = #ScoreboardHelper.scoreboard_topic_stats_versus * 8

fassert(num <= max_size, "'ScoreboardHelper.scoreboard_topic_stats_versus' contains too many entries. Current: %s, Needed: %s", max_size, num)

local type_info_8 = Network.type_info("ready_request_id")

NetworkConstants.READY_REQUEST_ID_MAX = type_info_8.max

fn("health_status_lookup", "health_statuses")
fn("interaction_lookup", "interactions")
fn("interaction_state_lookup", "interaction_states")
fn("proc_function_lookup", "proc_functions")
fn("difficulty_lookup", "difficulties")
fn("objective_name_lookup", "objective_names")

local max_3 = Network.type_info("game_mode_state_id").max

for k_2, v_3 in pairs(GameModeSettings) do
	local count_4 = #v_3.game_mode_states

	fassert(count_4 <= max_3, "Too many game mode states in %s, it has %u maximum is %u", k_2, count_4, max_3)
end

require("scripts/settings/objective_lists")

local function fn_2(self)
	-- function 2
	local num = 1

	if not self.sub_objectives then
		for k, v in pairs(self.sub_objectives) do
			num = num + fn_2(self)
		end
	end

	return num
end

local bits = type_info_4.bits

for k_3, v_4 in pairs(ObjectiveLists) do
	for i_2, v_5 in ipairs(v_4) do
		fassert(bits >= fn_2(v_5), "[ObjectiveLists] List '%s' contains more than %s objectives. Replace networked type for 'rpc_activate_objective' with an array that supports %s elements")
	end
end
