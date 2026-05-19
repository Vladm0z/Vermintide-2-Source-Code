-- chunkname: @scripts/settings/mutators/mutator_curse_bolt_of_change.lua

local var_0_0 = require("scripts/settings/mutators/mutator_lightning_strike")
local var_0_1 = table.clone(var_0_0)
local var_0_2 = 5

var_0_1.packages = {
	"resource_packages/mutators/mutator_curse_bolt_of_change"
}
var_0_1.display_name = "curse_bolt_of_change_name"
var_0_1.description = "curse_bolt_of_change_desc"
var_0_1.icon = "deus_curse_tzeentch_01"
var_0_1.spawn_rate = 40
var_0_1.max_spawns = math.huge

local var_0_3 = 0.3
local var_0_4 = 2
local var_0_5 = 3
local var_0_6 = 4
local var_0_7 = 5
local var_0_8 = 6
local var_0_9 = {
	bolt_amount = {
		[var_0_4] = 1,
		[var_0_5] = 2,
		[var_0_6] = 2,
		[var_0_7] = 2,
		[var_0_8] = 2
	},
	change_limit = {
		[var_0_4] = 1,
		[var_0_5] = 2,
		[var_0_6] = 3,
		[var_0_7] = 3,
		[var_0_8] = 3
	}
}
local var_0_10 = "morris_bolt_of_change_laughter"
local var_0_11 = {
	chaos_warrior = {
		chance = 0.3,
		breed = "chaos_spawn"
	},
	beastmen_bestigor = {
		chance = 0.3,
		breed = "chaos_spawn"
	},
	skaven_slave = {
		chance = 0.005,
		breed = "critter_rat"
	}
}
local var_0_12 = {
	chaos_spawn = 1
}
local var_0_13 = 2
local var_0_14 = {
	chaos_troll = true,
	chaos_spawn_exalted_champion_warcamp = true,
	chaos_exalted_champion_warcamp = true,
	chaos_exalted_sorcerer = true,
	skaven_storm_vermin_warlord = true,
	pet_rat = true,
	chaos_exalted_champion_norsca = true,
	beastmen_minotaur = true,
	skaven_stormfiend = true,
	skaven_grey_seer = true,
	skaven_rat_ogre = true,
	pet_pig = true,
	chaos_spawn = true,
	chaos_exalted_sorcerer_drachenfels = true,
	skaven_stormfiend_boss = true,
	pet_wolf = true,
	skaven_storm_vermin_champion = true
}
local var_0_15 = {
	chaos_spawn_exalted_champion_warcamp = true,
	chaos_exalted_champion_warcamp = true,
	chaos_exalted_sorcerer = true,
	beastmen_ungor = true,
	skaven_storm_vermin_warlord = true,
	pet_pig = true,
	pet_rat = true,
	chaos_exalted_champion_norsca = true,
	beastmen_minotaur = true,
	chaos_fanatic = true,
	skaven_slave = true,
	skaven_stormfiend = true,
	skaven_grey_seer = true,
	skaven_rat_ogre = true,
	chaos_troll = true,
	chaos_spawn = true,
	chaos_exalted_sorcerer_drachenfels = true,
	skaven_stormfiend_boss = true,
	pet_wolf = true,
	skaven_storm_vermin_champion = true
}

local function var_0_16(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_2.main_path_info
	local var_1_1

	return (not var_1_0.ahead_unit and 0 or arg_1_2.main_path_player_info[var_1_0.ahead_unit].travel_dist) >= arg_1_1 - arg_1_0
end

function var_0_1.server_start_function(arg_2_0, arg_2_1)
	arg_2_1.seed = Managers.mechanism:get_level_seed("mutator")
	arg_2_1.change_cooldown = 1
	arg_2_1.spawn_delay = 0.25
	arg_2_1.spawn_queue = {}
	arg_2_1.spawned_units_data = {}
	arg_2_1.explosion_template_name = "generic_mutator_explosion"

	function arg_2_1.cb_enemy_spawned_function(arg_3_0, arg_3_1, arg_3_2)
		local var_3_0 = BLACKBOARDS[arg_3_0]

		if not arg_3_1.special then
			var_3_0.spawn_type = "horde"
			var_3_0.spawning_finished = true
		end

		local var_3_1 = {
			unit = arg_3_0,
			breed_name = arg_3_1.name
		}

		table.insert(arg_2_1.spawned_units_data, var_3_1)
	end

	var_0_0.server_start_function(arg_2_0, arg_2_1)

	arg_2_1.lighting_strike_callback = callback(arg_2_1.template, "cb_on_explode", arg_2_1)
	arg_2_1.explosion_template = ExplosionUtils.get_template("bolt_of_change")
	arg_2_1.decal_unit_name = "units/decals/deus_decal_aoe_bluefire_02"
	arg_2_1.follow_time = arg_2_1.explosion_template.follow_time
	arg_2_1.time_to_explode = arg_2_1.explosion_template.time_to_explode
	arg_2_1.extension_init_data = {
		area_damage_system = {
			explosion_template_name = "bolt_of_change"
		}
	}
	arg_2_1.all_available_breeds = {}
	arg_2_1.available_breeds = {
		skaven = {},
		chaos = {},
		beastmen = {},
		undead = {},
		critter = {}
	}
	arg_2_1.difficulty_rank = Managers.state.difficulty:get_difficulty_rank()

	arg_2_1.template.populate_available_breeds(arg_2_0, arg_2_1)
end

function var_0_1.server_stop_function(arg_4_0, arg_4_1)
	local var_4_0 = Managers.state.unit_spawner

	if #arg_4_1.units > 0 and var_4_0 then
		for iter_4_0, iter_4_1 in ipairs(arg_4_1.units) do
			if ALIVE[iter_4_1] then
				var_4_0:mark_for_deletion(iter_4_1)

				arg_4_1.units[iter_4_0] = nil
			end
		end
	end
end

local function var_0_17(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = {}

	for iter_5_0, iter_5_1 in ipairs(arg_5_0) do
		local var_5_1 = arg_5_1:unit_owner(iter_5_1)
		local var_5_2 = var_5_1.peer_id
		local var_5_3 = var_5_1:local_player_id()

		if arg_5_2:get_player_health_state(var_5_2, var_5_3) ~= "respawning" then
			table.insert(var_5_0, iter_5_1)
		end
	end

	return var_5_0
end

function var_0_1.spawn_lightning_strike_unit(arg_6_0)
	local var_6_0 = var_0_9.bolt_amount[arg_6_0.difficulty_rank] or 1
	local var_6_1 = 0
	local var_6_2 = Managers.state.side
	local var_6_3 = var_6_2:get_side_from_name("heroes")
	local var_6_4 = table.clone(var_6_3.PLAYER_UNITS)
	local var_6_5 = Managers.mechanism:game_mechanism():get_deus_run_controller()
	local var_6_6 = Managers.player
	local var_6_7 = var_0_17(var_6_4, var_6_6, var_6_5)

	arg_6_0.seed = table.shuffle(var_6_7, arg_6_0.seed)

	table.clear(arg_6_0.units)

	for iter_6_0, iter_6_1 in ipairs(var_6_7) do
		if var_6_0 <= var_6_1 then
			break
		end

		arg_6_0.extension_init_data.area_damage_system.follow_unit = iter_6_1

		local var_6_8 = Managers.state.unit_spawner:spawn_network_unit(arg_6_0.decal_unit_name, "timed_explosion_unit", arg_6_0.extension_init_data, Unit.local_position(iter_6_1, 0))
		local var_6_9 = arg_6_0.lighting_strike_callback
		local var_6_10 = ScriptUnit.has_extension(var_6_8, "area_damage_system")

		if var_6_9 and var_6_10 then
			var_6_10:add_on_explode_callback(var_6_9)
		end

		local var_6_11 = var_6_2:get_side_from_name("neutral").side_id

		var_6_2:add_unit_to_side(var_6_8, var_6_11)
		arg_6_0.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_spawn", var_6_8)

		arg_6_0.units[#arg_6_0.units + 1] = var_6_8
		var_6_1 = var_6_1 + 1
		arg_6_0.lock_played = false
		arg_6_0.charge_played = false
		arg_6_0.hit_played = false
	end

	if #var_6_7 > 0 then
		local var_6_12 = var_6_7[1]
		local var_6_13 = ScriptUnit.extension_input(var_6_12, "dialogue_system")
		local var_6_14 = FrameTable.alloc_table()

		var_6_13:trigger_networked_dialogue_event("curse_danger_spotted", var_6_14)
	end
end

function var_0_1.server_players_left_safe_zone(arg_7_0, arg_7_1)
	arg_7_1.has_left_safe_zone = true
end

function var_0_1.server_update_function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if not arg_8_1.has_left_safe_zone or global_is_inside_inn then
		return
	end

	local var_8_0 = Managers.state.conflict
	local var_8_1 = MainPathUtils.total_path_dist()

	if var_0_16(var_0_2, var_8_1, var_8_0) then
		return
	end

	var_0_0.server_update_function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)

	local var_8_2
	local var_8_3 = arg_8_1.spawn_queue

	for iter_8_0 = 1, #var_8_3 do
		local var_8_4 = var_8_3[iter_8_0]

		if arg_8_3 > var_8_4.spawn_at_t then
			local var_8_5 = var_8_4.breed
			local var_8_6 = var_8_4.position_box
			local var_8_7 = var_8_4.rotation_box
			local var_8_8 = "mutator"
			local var_8_9 = {
				spawned_func = arg_8_1.cb_enemy_spawned_function
			}

			Managers.state.conflict:spawn_queued_unit(var_8_5, var_8_6, var_8_7, var_8_8, nil, "terror_event", var_8_9)

			var_8_2 = iter_8_0

			break
		end
	end

	if var_8_2 then
		table.swap_delete(var_8_3, var_8_2)
	end

	local var_8_10 = arg_8_1.spawned_units_data

	for iter_8_1 = #var_8_10, 1, -1 do
		local var_8_11 = var_8_10[iter_8_1].unit

		if not HEALTH_ALIVE[var_8_11] then
			table.swap_delete(var_8_10, iter_8_1)
		end
	end
end

function var_0_1.modify_player_base_damage(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = Managers.player:owner(arg_9_2)

	if var_9_0 and var_9_0.bot_player then
		return arg_9_4 * var_0_3
	else
		return arg_9_4
	end
end

function var_0_1.populate_available_breeds(arg_10_0, arg_10_1)
	local var_10_0 = Managers.state.difficulty:get_difficulty()
	local var_10_1 = CurrentConflictSettings.contained_breeds[var_10_0] or CurrentConflictSettings.contained_breeds[2]
	local var_10_2 = arg_10_1.available_breeds

	for iter_10_0, iter_10_1 in pairs(var_10_1) do
		local var_10_3

		if CHAOS[iter_10_0] then
			var_10_3 = "chaos"
		elseif SKAVEN[iter_10_0] then
			var_10_3 = "skaven"
		elseif BEASTMEN[iter_10_0] then
			var_10_3 = "beastmen"
		elseif CRITTER[iter_10_0] then
			var_10_3 = "critter"
		end

		if var_10_3 then
			arg_10_1.all_available_breeds[iter_10_0] = true
			var_10_2[var_10_3][iter_10_0] = true
		end
	end

	table.merge_recursive(arg_10_1.all_available_breeds, CRITTER)
	table.merge_recursive(var_10_2.critter, CRITTER)
end

function var_0_1.cb_on_explode(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = ExplosionUtils.get_template(arg_11_2).explosion.radius
	local var_11_1 = {}

	AiUtils.broadphase_query(arg_11_3, var_11_0, var_11_1)

	local var_11_2 = var_0_9.change_limit[arg_11_1.difficulty_rank] or 1
	local var_11_3 = 0

	for iter_11_0, iter_11_1 in ipairs(var_11_1) do
		if var_11_2 <= var_11_3 then
			break
		end

		if arg_11_0.change_ai(arg_11_1, iter_11_1) then
			var_11_3 = var_11_3 + 1
		end
	end

	Managers.state.entity:system("audio_system"):play_2d_audio_event(var_0_10)
end

function var_0_1.get_overridden_breed(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = var_0_11[arg_12_2]

	if var_12_0 then
		local var_12_1

		if var_12_0.chance then
			local var_12_2
			local var_12_3

			arg_12_0.seed, var_12_3 = Math.next_random(arg_12_0.seed)

			if var_12_3 <= var_12_0.chance then
				var_12_1 = var_12_0.breed
			end
		else
			var_12_1 = var_12_0.breed
		end

		if arg_12_1[var_12_1] then
			return nil
		elseif arg_12_0.all_available_breeds[var_12_1] then
			return var_12_1
		end
	end

	return nil
end

local function var_0_18(arg_13_0)
	local var_13_0 = {}
	local var_13_1 = {}

	for iter_13_0, iter_13_1 in ipairs(arg_13_0) do
		local var_13_2 = iter_13_1.breed_name
		local var_13_3 = var_0_12[var_13_2]

		if var_13_3 then
			local var_13_4 = (var_13_1[var_13_2] or var_13_3) - 1

			var_13_1[var_13_2] = var_13_4

			if var_13_4 <= 0 then
				var_13_0[var_13_2] = true
			end
		end
	end

	return var_13_0
end

local function var_0_19(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = {}

	for iter_14_0, iter_14_1 in pairs(arg_14_0[arg_14_1]) do
		if not arg_14_2[iter_14_0] then
			var_14_0[iter_14_0] = true
		end
	end

	return var_14_0
end

local function var_0_20(arg_15_0)
	local var_15_0 = BLACKBOARDS[arg_15_0]

	Managers.state.conflict:destroy_unit(arg_15_0, var_15_0, "mutator")
end

local function var_0_21(arg_16_0, arg_16_1)
	local var_16_0 = table.size(arg_16_1)

	if var_16_0 > 0 then
		local var_16_1, var_16_2 = Math.next_random(arg_16_0, 1, var_16_0)
		local var_16_3 = table.keys(arg_16_1)[var_16_2]

		return var_16_1, var_16_3
	end

	return arg_16_0, nil
end

local function var_0_22(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0:alive_specials_count()

	for iter_17_0, iter_17_1 in ipairs(arg_17_1) do
		if iter_17_1.breed.special then
			var_17_0 = var_17_0 + 1
		end
	end

	return var_17_0
end

local function var_0_23(arg_18_0)
	local var_18_0 = {}

	for iter_18_0, iter_18_1 in ipairs(arg_18_0) do
		var_18_0[iter_18_1] = true
	end

	return var_18_0
end

function var_0_1.spawn_new_breed(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = Managers.state.entity:system("ai_system"):nav_world()
	local var_19_1 = arg_19_0.spawn_queue
	local var_19_2 = BLACKBOARDS[arg_19_1]
	local var_19_3 = POSITION_LOOKUP[arg_19_1]

	if var_19_3 then
		local var_19_4 = arg_19_0.explosion_template_name

		AiUtils.generic_mutator_explosion(arg_19_1, var_19_2, var_19_4)

		local var_19_5 = LocomotionUtils.pos_on_mesh(var_19_0, var_19_3, 1, 1)

		if not var_19_5 then
			local var_19_6 = GwNavQueries.inside_position_from_outside_position(var_19_0, var_19_3, 6, 6, 8, 0.5)

			if var_19_6 then
				var_19_5 = var_19_6
			end
		end

		local var_19_7 = Managers.time:time("game")
		local var_19_8 = var_19_7 + arg_19_0.spawn_delay
		local var_19_9 = Unit.local_rotation(arg_19_1, 0)

		if var_19_5 then
			local var_19_10 = {
				breed = Breeds[arg_19_2],
				breed_name = arg_19_2,
				rotation_box = QuaternionBox(var_19_9),
				spawn_at_t = var_19_8,
				position_box = Vector3Box(var_19_5)
			}

			table.insert(var_19_1, var_19_10)

			local var_19_11 = var_19_7 + arg_19_0.change_cooldown

			Unit.set_data(arg_19_1, "can_change_at", var_19_11)
		end
	end
end

function var_0_1.change_ai(arg_20_0, arg_20_1)
	local var_20_0 = Managers.time:time("game") <= (Unit.get_data(arg_20_1, "can_change_at") or 0)
	local var_20_1 = Unit.get_data(arg_20_1, "breed")
	local var_20_2 = var_0_14[var_20_1.name]

	if var_20_0 or var_20_2 then
		return
	end

	local var_20_3 = table.clone(var_0_15)

	var_20_3[var_20_1.name] = true

	local var_20_4 = var_0_18(arg_20_0.spawned_units_data)
	local var_20_5 = var_0_18(arg_20_0.spawn_queue)

	table.merge(var_20_3, var_20_5)
	table.merge(var_20_3, var_20_4)

	if var_0_22(Managers.state.conflict, arg_20_0.spawn_queue) >= var_0_13 then
		local var_20_6 = var_0_23(CurrentSpecialsSettings.breeds)

		table.merge(var_20_3, var_20_6)
	end

	local var_20_7 = var_20_1.race
	local var_20_8 = var_0_19(arg_20_0.available_breeds, var_20_7, var_20_3)
	local var_20_9
	local var_20_10

	arg_20_0.seed, var_20_10 = var_0_21(arg_20_0.seed, var_20_8)

	if var_20_10 then
		local var_20_11 = arg_20_0.template

		var_20_10 = var_20_11.get_overridden_breed(arg_20_0, var_20_4, var_20_1.name) or var_20_10

		var_20_11.spawn_new_breed(arg_20_0, arg_20_1, var_20_10)
		var_0_20(arg_20_1)

		return true
	else
		print("Bolt of Change: No available breed found.")

		return false
	end
end

function var_0_1.server_player_hit_function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	if arg_21_4[2] == "bolt_of_change" then
		local var_21_0 = ScriptUnit.extension_input(arg_21_2, "dialogue_system")
		local var_21_1 = FrameTable.alloc_table()

		var_21_0:trigger_dialogue_event("curse_damage_taken", var_21_1)
	end
end

return var_0_1
