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

local Breeds = Breeds

Breeds = Breeds or {}
Breeds = Breeds

local BreedActions = BreedActions

BreedActions = BreedActions or {}
BreedActions = BreedActions

local BreedHitZonesLookup = BreedHitZonesLookup

BreedHitZonesLookup = BreedHitZonesLookup or {}
BreedHitZonesLookup = BreedHitZonesLookup

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

local tbl = {
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
local tbl_2 = {
	plague_wave = 20,
	mutator_heavens_zone = 1,
	lamp_oil_fire = 10,
	warpfire_thrower_warpfire = 20,
	vortex_near = 1,
	stormfiend_warpfire = 30,
	vortex_danger_zone = 1,
	troll_bile = 20
}
local clone = table.clone(tbl)
local clone_2 = table.clone(tbl_2)

for k, v in pairs(Breeds) do
	local var_0_7 = BreedHitZonesLookup[k]

	if not var_0_7 then
		v.hit_zones_lookup = var_0_7

		fassert(v.debug_color, "breed needs a debug color")
	end

	local allowed_layers = v.allowed_layers

	if not allowed_layers then
		table.merge(clone, allowed_layers)
	end

	local nav_cost_map_allowed_layers = v.nav_cost_map_allowed_layers

	if not nav_cost_map_allowed_layers then
		table.merge(clone_2, nav_cost_map_allowed_layers)
	end

	BreedUtils.inject_breed_category_mask(v)

	if not v.aoe_height then
		v.aoe_height = DEFAULT_BREED_AOE_HEIGHT
	end
end

for k_2, v_2 in pairs(BreedActions) do
	for k_3, v_3 in pairs(v_2) do
		v_3.name = k_3
	end
end

local function fn(self, arg_1_1)
	-- function 1
	if not self.duration then
		self.max_start_delay = math.min(arg_1_1, self.duration * 0.9)
	elseif not self.bot_threat_duration then
		self.bot_threat_max_start_delay = math.min(arg_1_1, self.bot_threat_duration * 0.9)
	end
end

local function fn_2(self)
	-- function 2
	local bot_threat_difficulty_data = self.bot_threat_difficulty_data

	if not bot_threat_difficulty_data then
		local max_start_delay = Managers.state.difficulty:get_difficulty_value_from_table(bot_threat_difficulty_data).max_start_delay

		if not self.bot_threats then
			local bot_threats = self.bot_threats

			if not bot_threats[1] then
				local count = #bot_threats

				for i = 1, count do
					local var_2_4 = bot_threats[i]

					fn(var_2_4, max_start_delay)
				end
			else
				for k, v in pairs(bot_threats) do
					local count_2 = #v

					for l = 1, count_2 do
						local var_2_6 = v[l]

						fn(var_2_6, max_start_delay)
					end
				end
			end
		elseif not self.bot_threat_duration then
			fn(self, max_start_delay)
		end
	else
		for k_2, v_2 in pairs(self) do
			if type(v_2) == "table" then
				fn_2(v_2)
			end
		end
	end
end

function SET_BREED_DIFFICULTY()
	-- function 3
	local difficulty = Managers.state.difficulty

	for k, v in pairs(BreedActions) do
		for k_2, v_2 in pairs(v) do
			local difficulty_diminishing_damage = v_2.difficulty_diminishing_damage

			if not difficulty_diminishing_damage then
				local get_difficulty_value_from_table = difficulty:get_difficulty_value_from_table(difficulty_diminishing_damage)

				v_2.diminishing_damage = table.clone(get_difficulty_value_from_table)
			end

			local difficulty_damage = v_2.difficulty_damage

			if not difficulty_damage then
				v_2.damage = difficulty:get_difficulty_value_from_table(difficulty_damage)
			end

			local blocked_difficulty_damage = v_2.blocked_difficulty_damage

			if not blocked_difficulty_damage then
				v_2.blocked_damage = difficulty:get_difficulty_value_from_table(blocked_difficulty_damage)
			end

			fn_2(v_2)
		end
	end
end

table.merge(clone, BotNavTransitionManager.TRANSITION_LAYERS)
table.merge(clone_2, BotNavTransitionManager.NAV_COST_MAP_LAYERS)

LAYER_ID_MAPPING = {}

for k_4, v_4 in pairs(clone) do
	LAYER_ID_MAPPING[#LAYER_ID_MAPPING + 1] = k_4
end

NAV_COST_MAP_LAYER_ID_MAPPING = {}

for k_5, v_5 in pairs(clone_2) do
	NAV_COST_MAP_LAYER_ID_MAPPING[#NAV_COST_MAP_LAYER_ID_MAPPING + 1] = k_5
end

fassert(#LAYER_ID_MAPPING < NavTagVolumeStartLayer, "Nav tag volume layers are conflicting with layers used by other systems.")

for i10 = #LAYER_ID_MAPPING + 1, NavTagVolumeStartLayer - 1 do
	LAYER_ID_MAPPING[i10] = "dummy_layer" .. i10
end

DEFAULT_NAV_TAG_VOLUME_LAYER_COST_AI = {}
DEFAULT_NAV_TAG_VOLUME_LAYER_COST_BOTS = {
	NO_BOTS_NO_SPAWN = 0,
	NO_BOTS = 0
}

local NAV_TAG_VOLUME_LAYER_COST_AI = NAV_TAG_VOLUME_LAYER_COST_AI

NAV_TAG_VOLUME_LAYER_COST_AI = NAV_TAG_VOLUME_LAYER_COST_AI or {}
NAV_TAG_VOLUME_LAYER_COST_AI = NAV_TAG_VOLUME_LAYER_COST_AI

local NAV_TAG_VOLUME_LAYER_COST_BOTS = NAV_TAG_VOLUME_LAYER_COST_BOTS

NAV_TAG_VOLUME_LAYER_COST_BOTS = NAV_TAG_VOLUME_LAYER_COST_BOTS or {}
NAV_TAG_VOLUME_LAYER_COST_BOTS = NAV_TAG_VOLUME_LAYER_COST_BOTS

for i, v_6 in ipairs(NavTagVolumeLayers) do
	LAYER_ID_MAPPING[#LAYER_ID_MAPPING + 1] = v_6

	local var_0_14 = DEFAULT_NAV_TAG_VOLUME_LAYER_COST_AI[v_6]

	var_0_14 = var_0_14 or 1

	local var_0_15 = DEFAULT_NAV_TAG_VOLUME_LAYER_COST_BOTS[v_6]

	var_0_15 = var_0_15 or 1

	local NAV_TAG_VOLUME_LAYER_COST_AI_2 = NAV_TAG_VOLUME_LAYER_COST_AI
	local var_0_17 = NAV_TAG_VOLUME_LAYER_COST_AI[v_6]

	var_0_17 = var_0_17 or var_0_14
	NAV_TAG_VOLUME_LAYER_COST_AI_2[v_6] = var_0_17

	local NAV_TAG_VOLUME_LAYER_COST_BOTS_2 = NAV_TAG_VOLUME_LAYER_COST_BOTS
	local var_0_19 = NAV_TAG_VOLUME_LAYER_COST_BOTS[v_6]

	var_0_19 = var_0_19 or var_0_15
	NAV_TAG_VOLUME_LAYER_COST_BOTS_2[v_6] = var_0_19
end

table.mirror_array_inplace(LAYER_ID_MAPPING)
table.mirror_array_inplace(NAV_COST_MAP_LAYER_ID_MAPPING)

local tbl_3 = {
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
local tbl_4 = {
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

for k_6, v_7 in pairs(Breeds) do
	v_7.name = k_6
	v_7.is_ai = true

	if not v_7.allowed_layers then
		v_7.allowed_layers = table.clone(tbl)
	end

	if not v_7.nav_cost_map_allowed_layers then
		v_7.nav_cost_map_allowed_layers = table.clone(tbl_2)
	end

	if not (not v_7.perception and tbl_3[v_7.perception]) then
		error("Bad perception type '" .. v_7.perception .. "' specified in breed .. '" .. v_7.name .. "'.")
	end

	if not (not v_7.target_selection and tbl_4[v_7.target_selection]) then
		error("Bad 'target_selection' type '" .. v_7.target_selection .. "' specified in breed .. '" .. v_7.name .. "'.")
	end

	if v_7.smart_object_template == nil then
		v_7.smart_object_template = "fallback"
	end

	if v_7.race == "chaos" then
		CHAOS[v_7.name] = true
	elseif v_7.race == "skaven" then
		SKAVEN[v_7.name] = true
	elseif v_7.race == "beastmen" then
		BEASTMEN[v_7.name] = true
	elseif v_7.race == "undead" then
		UNDEAD[v_7.name] = true
	elseif v_7.race == "critter" then
		CRITTER[v_7.name] = true
	elseif v_7.race == "dummy" then
		-- Nothing
	elseif not v_7.race then
		error("Bad race type '" .. v_7.race .. "' specified in breed .. '" .. v_7.name .. "'.")
	else
		error("Missing 'race' type in breed .. '" .. v_7.name .. "'.")
	end

	if not v_7.elite then
		ELITES[v_7.name] = true
	end

	local status_effect_settings = v_7.status_effect_settings
	local flag = not status_effect_settings and status_effect_settings.ignored_statuses

	if not flag then
		flag[StatusEffectNames.burning_balefire] = flag[StatusEffectNames.burning]
		flag[StatusEffectNames.burning_balefire_death_critical] = flag[StatusEffectNames.burning_death_critical]
	end

	local networked_animation_variables = v_7.networked_animation_variables

	if not networked_animation_variables then
		local tbl_5 = {}

		for i_2, v_8 in ipairs(networked_animation_variables) do
			local anims = v_8.anims
			local variables = v_8.variables

			for i17 = 1, #anims do
				local var_0_28 = anims[i17]
				local var_0_29 = tbl_5[var_0_28]

				var_0_29 = var_0_29 or {}
				tbl_5[var_0_28] = var_0_29

				for k_7, v_9 in pairs(variables) do
					fassert(not var_0_29[k_7], "[Breeds] The variable '%s' for anim '%s' in breed '%s' was already defined in a previous animation group.", k_7, var_0_28, v_7.name)

					var_0_29[k_7] = v_9
				end
			end
		end

		v_7.networked_animation_variables = tbl_5
	end
end
