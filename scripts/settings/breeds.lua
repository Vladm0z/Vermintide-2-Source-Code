-- chunkname: @scripts/settings/breeds.lua

require("scripts/utils/benchmark/benchmark_handler")
require("scripts/unit_extensions/human/ai_player_unit/ai_utils")
require("scripts/managers/bot_nav_transition/bot_nav_transition_manager")
require("scripts/settings/player_unit_status_settings")
require("scripts/unit_extensions/human/ai_player_unit/debug_breeds/debug_globadier")
require("scripts/unit_extensions/human/ai_player_unit/debug_breeds/debug_gutter_runner")
require("scripts/settings/smartobject_settings")
require("scripts/settings/nav_tag_volume_settings")
require("foundation/scripts/util/table")
require("foundation/scripts/util/error")
require("scripts/unit_extensions/human/ai_player_unit/ai_breed_snippets")
require("scripts/settings/dlc_settings")
require("scripts/settings/infighting_settings")
require("scripts/settings/player_bots_settings")
require("scripts/managers/status_effect/status_effect_templates")
require("scripts/helpers/breed_utils")

DEFAULT_BREED_AOE_HEIGHT = 1.5
DEFAULT_BREED_AOE_RADIUS = 0.3
Breeds = Breeds or {}
BreedActions = BreedActions or {}
BreedHitZonesLookup = BreedHitZonesLookup or {}

dofile("scripts/settings/breeds/breed_tweaks")
dofile("scripts/settings/breeds/breed_skaven_clan_rat")
dofile("scripts/settings/breeds/breed_skaven_clan_rat_with_shield")
dofile("scripts/settings/breeds/breed_skaven_dummy_clan_rat")
dofile("scripts/settings/breeds/breed_skaven_slave")
dofile("scripts/settings/breeds/breed_skaven_dummy_slave")
dofile("scripts/settings/breeds/breed_skaven_storm_vermin")
dofile("scripts/settings/breeds/breed_skaven_storm_vermin_champion")
dofile("scripts/settings/breeds/breed_skaven_storm_vermin_with_shield")
dofile("scripts/settings/breeds/breed_skaven_loot_rat")
dofile("scripts/settings/breeds/breed_skaven_gutter_runner")
dofile("scripts/settings/breeds/breed_skaven_plague_monk")
dofile("scripts/settings/breeds/breed_skaven_pack_master")
dofile("scripts/settings/breeds/breed_skaven_poison_wind_globadier")
dofile("scripts/settings/breeds/breed_skaven_ratling_gunner")
dofile("scripts/settings/breeds/breed_skaven_warpfire_thrower")
dofile("scripts/settings/breeds/breed_skaven_rat_ogre")
dofile("scripts/settings/breeds/breed_skaven_stormfiend")
dofile("scripts/settings/breeds/breed_skaven_stormfiend_demo")
dofile("scripts/settings/breeds/breed_skaven_grey_seer")
dofile("scripts/settings/breeds/breed_skaven_stormfiend_boss")
dofile("scripts/settings/breeds/breed_skaven_storm_vermin_warlord")
dofile("scripts/settings/breeds/breed_chaos_marauder")
dofile("scripts/settings/breeds/breed_chaos_fanatic")
dofile("scripts/settings/breeds/breed_chaos_marauder_with_shield")
dofile("scripts/settings/breeds/breed_chaos_berzerker")
dofile("scripts/settings/breeds/breed_chaos_raider")
dofile("scripts/settings/breeds/breed_chaos_warrior")
dofile("scripts/settings/breeds/breed_chaos_bulwark")
dofile("scripts/settings/breeds/breed_chaos_troll")
dofile("scripts/settings/breeds/breed_chaos_troll_chief")
dofile("scripts/settings/breeds/breed_chaos_dummy_troll")
dofile("scripts/settings/breeds/breed_chaos_tentacle")
dofile("scripts/settings/breeds/breed_chaos_vortex_sorcerer")
dofile("scripts/settings/breeds/breed_chaos_vortex")
dofile("scripts/settings/breeds/breed_chaos_corruptor_sorcerer")
dofile("scripts/settings/breeds/breed_chaos_tether_sorcerer")
dofile("scripts/settings/breeds/breed_chaos_plague_wave_spawner")
dofile("scripts/settings/breeds/breed_chaos_spawn")
dofile("scripts/settings/breeds/breed_chaos_dummy_sorcerer")
dofile("scripts/settings/breeds/breed_chaos_exalted_champion")
dofile("scripts/settings/breeds/breed_chaos_exalted_sorcerer")
dofile("scripts/settings/breeds/breed_chaos_zombie")
dofile("scripts/settings/breeds/breed_chaos_skeleton")
dofile("scripts/settings/breeds/breed_pet_skeleton")
dofile("scripts/settings/breeds/breed_critters")
dofile("scripts/settings/breeds/breed_training_dummy")
DLCUtils.dofile_list("breeds")

CHAOS = {}
SKAVEN = {}
BEASTMEN = {}
UNDEAD = {}
CRITTER = {}
ELITES = {}

local var_0_0 = {
	end_zone = 0,
	ledges = 1.5,
	barrel_explosion = 10,
	jumps = 1.5,
	bot_ratling_gun_fire = 3,
	temporary_wall = 0,
	planks = 1.5,
	big_boy_destructible = 0,
	destructible_wall = 5,
	ledges_with_fence = 1.5,
	doors = 1.5,
	teleporters = 5,
	bot_poison_wind = 1.5,
	fire_grenade = 10
}
local var_0_1 = {
	plague_wave = 20,
	mutator_heavens_zone = 1,
	lamp_oil_fire = 10,
	warpfire_thrower_warpfire = 20,
	vortex_near = 1,
	stormfiend_warpfire = 30,
	vortex_danger_zone = 1,
	troll_bile = 20
}
local var_0_2 = table.clone(var_0_0)
local var_0_3 = table.clone(var_0_1)

for iter_0_0, iter_0_1 in pairs(Breeds) do
	local var_0_4 = BreedHitZonesLookup[iter_0_0]

	if var_0_4 then
		iter_0_1.hit_zones_lookup = var_0_4

		fassert(iter_0_1.debug_color, "breed needs a debug color")
	end

	local var_0_5 = iter_0_1.allowed_layers

	if var_0_5 then
		table.merge(var_0_2, var_0_5)
	end

	local var_0_6 = iter_0_1.nav_cost_map_allowed_layers

	if var_0_6 then
		table.merge(var_0_3, var_0_6)
	end

	BreedUtils.inject_breed_category_mask(iter_0_1)

	if not iter_0_1.aoe_height then
		iter_0_1.aoe_height = DEFAULT_BREED_AOE_HEIGHT
	end
end

for iter_0_2, iter_0_3 in pairs(BreedActions) do
	for iter_0_4, iter_0_5 in pairs(iter_0_3) do
		iter_0_5.name = iter_0_4
	end
end

local function var_0_7(arg_1_0, arg_1_1)
	if arg_1_0.duration then
		arg_1_0.max_start_delay = math.min(arg_1_1, arg_1_0.duration * 0.9)
	elseif arg_1_0.bot_threat_duration then
		arg_1_0.bot_threat_max_start_delay = math.min(arg_1_1, arg_1_0.bot_threat_duration * 0.9)
	end
end

local function var_0_8(arg_2_0)
	local var_2_0 = arg_2_0.bot_threat_difficulty_data

	if var_2_0 then
		local var_2_1 = Managers.state.difficulty:get_difficulty_value_from_table(var_2_0).max_start_delay

		if arg_2_0.bot_threats then
			local var_2_2 = arg_2_0.bot_threats

			if var_2_2[1] then
				local var_2_3 = #var_2_2

				for iter_2_0 = 1, var_2_3 do
					local var_2_4 = var_2_2[iter_2_0]

					var_0_7(var_2_4, var_2_1)
				end
			else
				for iter_2_1, iter_2_2 in pairs(var_2_2) do
					local var_2_5 = #iter_2_2

					for iter_2_3 = 1, var_2_5 do
						local var_2_6 = iter_2_2[iter_2_3]

						var_0_7(var_2_6, var_2_1)
					end
				end
			end
		elseif arg_2_0.bot_threat_duration then
			var_0_7(arg_2_0, var_2_1)
		end
	else
		for iter_2_4, iter_2_5 in pairs(arg_2_0) do
			if type(iter_2_5) == "table" then
				var_0_8(iter_2_5)
			end
		end
	end
end

function SET_BREED_DIFFICULTY()
	local var_3_0 = Managers.state.difficulty

	for iter_3_0, iter_3_1 in pairs(BreedActions) do
		for iter_3_2, iter_3_3 in pairs(iter_3_1) do
			local var_3_1 = iter_3_3.difficulty_diminishing_damage

			if var_3_1 then
				local var_3_2 = var_3_0:get_difficulty_value_from_table(var_3_1)

				iter_3_3.diminishing_damage = table.clone(var_3_2)
			end

			local var_3_3 = iter_3_3.difficulty_damage

			if var_3_3 then
				iter_3_3.damage = var_3_0:get_difficulty_value_from_table(var_3_3)
			end

			local var_3_4 = iter_3_3.blocked_difficulty_damage

			if var_3_4 then
				iter_3_3.blocked_damage = var_3_0:get_difficulty_value_from_table(var_3_4)
			end

			var_0_8(iter_3_3)
		end
	end
end

table.merge(var_0_2, BotNavTransitionManager.TRANSITION_LAYERS)
table.merge(var_0_3, BotNavTransitionManager.NAV_COST_MAP_LAYERS)

LAYER_ID_MAPPING = {}

for iter_0_6, iter_0_7 in pairs(var_0_2) do
	LAYER_ID_MAPPING[#LAYER_ID_MAPPING + 1] = iter_0_6
end

NAV_COST_MAP_LAYER_ID_MAPPING = {}

for iter_0_8, iter_0_9 in pairs(var_0_3) do
	NAV_COST_MAP_LAYER_ID_MAPPING[#NAV_COST_MAP_LAYER_ID_MAPPING + 1] = iter_0_8
end

fassert(#LAYER_ID_MAPPING < NavTagVolumeStartLayer, "Nav tag volume layers are conflicting with layers used by other systems.")

for iter_0_10 = #LAYER_ID_MAPPING + 1, NavTagVolumeStartLayer - 1 do
	LAYER_ID_MAPPING[iter_0_10] = "dummy_layer" .. iter_0_10
end

DEFAULT_NAV_TAG_VOLUME_LAYER_COST_AI = {}
DEFAULT_NAV_TAG_VOLUME_LAYER_COST_BOTS = {
	NO_BOTS_NO_SPAWN = 0,
	NO_BOTS = 0
}
NAV_TAG_VOLUME_LAYER_COST_AI = NAV_TAG_VOLUME_LAYER_COST_AI or {}
NAV_TAG_VOLUME_LAYER_COST_BOTS = NAV_TAG_VOLUME_LAYER_COST_BOTS or {}

for iter_0_11, iter_0_12 in ipairs(NavTagVolumeLayers) do
	LAYER_ID_MAPPING[#LAYER_ID_MAPPING + 1] = iter_0_12

	local var_0_9 = DEFAULT_NAV_TAG_VOLUME_LAYER_COST_AI[iter_0_12] or 1
	local var_0_10 = DEFAULT_NAV_TAG_VOLUME_LAYER_COST_BOTS[iter_0_12] or 1

	NAV_TAG_VOLUME_LAYER_COST_AI[iter_0_12] = NAV_TAG_VOLUME_LAYER_COST_AI[iter_0_12] or var_0_9
	NAV_TAG_VOLUME_LAYER_COST_BOTS[iter_0_12] = NAV_TAG_VOLUME_LAYER_COST_BOTS[iter_0_12] or var_0_10
end

table.mirror_array_inplace(LAYER_ID_MAPPING)
table.mirror_array_inplace(NAV_COST_MAP_LAYER_ID_MAPPING)

local var_0_11 = {
	perception_pack_master = true,
	perception_no_seeing = true,
	perception_all_seeing_boss = true,
	perception_regular = true,
	perception_regular_update_aggro = true,
	perception_all_seeing_re_evaluate = true,
	perception_standard_bearer = true,
	perception_tether_sorcerer = true,
	perception_all_seeing = true,
	perception_rat_ogre = true
}
local var_0_12 = {
	pick_closest_target_with_filter = true,
	pick_ninja_approach_target = true,
	pick_chaos_warrior_target_with_weights = true,
	pick_flee_target = true,
	pick_closest_target_near_detection_source_position = true,
	pick_bestigor_target_with_weights = true,
	pick_rat_ogre_target_idle = true,
	pick_player_controller_allied = true,
	pick_solitary_target = true,
	pick_mutator_sorcerer_target = true,
	pick_closest_target = true,
	pick_corruptor_target = true,
	pick_rat_ogre_target_with_weights = true,
	pick_closest_vortex_target = true,
	pick_closest_target_with_spillover = true,
	horde_pick_closest_target_with_spillover = true,
	pick_pack_master_target = true,
	pick_no_targets = true,
	pick_boss_sorcerer_target = true,
	pick_tether_target = true
}

for iter_0_13, iter_0_14 in pairs(Breeds) do
	iter_0_14.name = iter_0_13
	iter_0_14.is_ai = true

	if not iter_0_14.allowed_layers then
		iter_0_14.allowed_layers = table.clone(var_0_0)
	end

	if not iter_0_14.nav_cost_map_allowed_layers then
		iter_0_14.nav_cost_map_allowed_layers = table.clone(var_0_1)
	end

	if iter_0_14.perception and not var_0_11[iter_0_14.perception] then
		error("Bad perception type '" .. iter_0_14.perception .. "' specified in breed .. '" .. iter_0_14.name .. "'.")
	end

	if iter_0_14.target_selection and not var_0_12[iter_0_14.target_selection] then
		error("Bad 'target_selection' type '" .. iter_0_14.target_selection .. "' specified in breed .. '" .. iter_0_14.name .. "'.")
	end

	if iter_0_14.smart_object_template == nil then
		iter_0_14.smart_object_template = "fallback"
	end

	if iter_0_14.race == "chaos" then
		CHAOS[iter_0_14.name] = true
	elseif iter_0_14.race == "skaven" then
		SKAVEN[iter_0_14.name] = true
	elseif iter_0_14.race == "beastmen" then
		BEASTMEN[iter_0_14.name] = true
	elseif iter_0_14.race == "undead" then
		UNDEAD[iter_0_14.name] = true
	elseif iter_0_14.race == "critter" then
		CRITTER[iter_0_14.name] = true
	elseif iter_0_14.race == "dummy" then
		-- block empty
	elseif iter_0_14.race then
		error("Bad race type '" .. iter_0_14.race .. "' specified in breed .. '" .. iter_0_14.name .. "'.")
	else
		error("Missing 'race' type in breed .. '" .. iter_0_14.name .. "'.")
	end

	if iter_0_14.elite then
		ELITES[iter_0_14.name] = true
	end

	local var_0_13 = iter_0_14.status_effect_settings
	local var_0_14 = var_0_13 and var_0_13.ignored_statuses

	if var_0_14 then
		var_0_14[StatusEffectNames.burning_balefire] = var_0_14[StatusEffectNames.burning]
		var_0_14[StatusEffectNames.burning_balefire_death_critical] = var_0_14[StatusEffectNames.burning_death_critical]
	end

	local var_0_15 = iter_0_14.networked_animation_variables

	if var_0_15 then
		local var_0_16 = {}

		for iter_0_15, iter_0_16 in ipairs(var_0_15) do
			local var_0_17 = iter_0_16.anims
			local var_0_18 = iter_0_16.variables

			for iter_0_17 = 1, #var_0_17 do
				local var_0_19 = var_0_17[iter_0_17]
				local var_0_20 = var_0_16[var_0_19] or {}

				var_0_16[var_0_19] = var_0_20

				for iter_0_18, iter_0_19 in pairs(var_0_18) do
					fassert(not var_0_20[iter_0_18], "[Breeds] The variable '%s' for anim '%s' in breed '%s' was already defined in a previous animation group.", iter_0_18, var_0_19, iter_0_14.name)

					var_0_20[iter_0_18] = iter_0_19
				end
			end
		end

		iter_0_14.networked_animation_variables = var_0_16
	end
end
