-- chunkname: @scripts/settings/mutators/mutator_curse_bolt_of_change.lua

local scripts_settings_mutators_mutator_lightning_strike = require("scripts/settings/mutators/mutator_lightning_strike")
local clone = table.clone(scripts_settings_mutators_mutator_lightning_strike)
local num = 5

clone.packages = {
	"resource_packages/mutators/mutator_curse_bolt_of_change"
}
clone.display_name = "curse_bolt_of_change_name"
clone.description = "curse_bolt_of_change_desc"
clone.icon = "deus_curse_tzeentch_01"
clone.spawn_rate = 40
clone.max_spawns = math.huge

local num_2 = 0.3
local num_3 = 2
local num_4 = 3
local num_5 = 4
local num_6 = 5
local num_7 = 6
local tbl = {
	bolt_amount = {
		[num_3] = 1,
		[num_4] = 2,
		[num_5] = 2,
		[num_6] = 2,
		[num_7] = 2
	},
	change_limit = {
		[num_3] = 1,
		[num_4] = 2,
		[num_5] = 3,
		[num_6] = 3,
		[num_7] = 3
	}
}
local str = "morris_bolt_of_change_laughter"
local tbl_2 = {
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
local tbl_3 = {
	chaos_spawn = 1
}
local num_8 = 2
local tbl_4 = {
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
local tbl_5 = {
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

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local main_path_info = arg_1_2.main_path_info
	local var_1_1
	local flag

	flag = main_path_info.ahead_unit or not 0 or arg_1_2.main_path_player_info[main_path_info.ahead_unit].travel_dist

	return flag >= arg_1_1 - arg_1_0
end

clone.server_start_function = function (arg_2_0, arg_2_1)
	-- function 2
	arg_2_1.seed = Managers.mechanism:get_level_seed("mutator")
	arg_2_1.change_cooldown = 1
	arg_2_1.spawn_delay = 0.25
	arg_2_1.spawn_queue = {}
	arg_2_1.spawned_units_data = {}
	arg_2_1.explosion_template_name = "generic_mutator_explosion"

	arg_2_1.cb_enemy_spawned_function = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		local var_3_0 = BLACKBOARDS[arg_3_0]

		if not arg_3_1.special then
			var_3_0.spawn_type = "horde"
			var_3_0.spawning_finished = true
		end

		local tbl = {
			unit = arg_3_0,
			breed_name = arg_3_1.name
		}

		table.insert(arg_2_1.spawned_units_data, tbl)
	end

	scripts_settings_mutators_mutator_lightning_strike.server_start_function(arg_2_0, arg_2_1)

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

clone.server_stop_function = function (arg_4_0, arg_4_1)
	-- function 4
	local unit_spawner = Managers.state.unit_spawner

	if not (#arg_4_1.units > 0) or not unit_spawner then
		for i, v in ipairs(arg_4_1.units) do
			if not ALIVE[v] then
				unit_spawner:mark_for_deletion(v)

				arg_4_1.units[i] = nil
			end
		end
	end
end

local function fn_2(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local tbl = {}

	for i, v in ipairs(arg_5_0) do
		local unit_owner = arg_5_1:unit_owner(v)
		local peer_id = unit_owner.peer_id
		local local_player_id = unit_owner:local_player_id()

		if arg_5_2:get_player_health_state(peer_id, local_player_id) ~= "respawning" then
			table.insert(tbl, v)
		end
	end

	return tbl
end

clone.spawn_lightning_strike_unit = function (self)
	-- function 6
	local var_6_0 = tbl.bolt_amount[self.difficulty_rank]

	var_6_0 = var_6_0 or 1

	local num = 0
	local side = Managers.state.side
	local get_side_from_name = side:get_side_from_name("heroes")
	local clone = table.clone(get_side_from_name.PLAYER_UNITS)
	local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
	local player = Managers.player
	local var_6_7 = fn_2(clone, player, get_deus_run_controller)

	self.seed = table.shuffle(var_6_7, self.seed)

	table.clear(self.units)

	for i, v in ipairs(var_6_7) do
		if var_6_0 <= num then
			break
		end

		self.extension_init_data.area_damage_system.follow_unit = v

		local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(self.decal_unit_name, "timed_explosion_unit", self.extension_init_data, Unit.local_position(v, 0))
		local lighting_strike_callback = self.lighting_strike_callback
		local has_extension = ScriptUnit.has_extension(spawn_network_unit, "area_damage_system")

		if not lighting_strike_callback and not has_extension then
			has_extension:add_on_explode_callback(lighting_strike_callback)
		end

		local side_id = side:get_side_from_name("neutral").side_id

		side:add_unit_to_side(spawn_network_unit, side_id)
		self.audio_system:play_audio_unit_event("Play_winds_heavens_gameplay_spawn", spawn_network_unit)

		self.units[#self.units + 1] = spawn_network_unit
		num = num + 1
		self.lock_played = false
		self.charge_played = false
		self.hit_played = false
	end

	if #var_6_7 > 0 then
		local var_6_12 = var_6_7[1]
		local extension_input = ScriptUnit.extension_input(var_6_12, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event("curse_danger_spotted", alloc_table)
	end
end

clone.server_players_left_safe_zone = function (arg_7_0, arg_7_1)
	-- function 7
	arg_7_1.has_left_safe_zone = true
end

clone.server_update_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	if not arg_8_1.has_left_safe_zone and not global_is_inside_inn then
		return
	end

	local conflict = Managers.state.conflict
	local total_path_dist = MainPathUtils.total_path_dist()

	if not fn(num, total_path_dist, conflict) then
		return
	end

	scripts_settings_mutators_mutator_lightning_strike.server_update_function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)

	local var_8_2
	local spawn_queue = arg_8_1.spawn_queue

	for i = 1, #spawn_queue do
		local var_8_4 = spawn_queue[i]

		if arg_8_3 > var_8_4.spawn_at_t then
			local breed = var_8_4.breed
			local position_box = var_8_4.position_box
			local rotation_box = var_8_4.rotation_box
			local str = "mutator"
			local tbl = {
				spawned_func = arg_8_1.cb_enemy_spawned_function
			}

			Managers.state.conflict:spawn_queued_unit(breed, position_box, rotation_box, str, nil, "terror_event", tbl)

			var_8_2 = i

			break
		end
	end

	if not var_8_2 then
		table.swap_delete(spawn_queue, var_8_2)
	end

	local spawned_units_data = arg_8_1.spawned_units_data

	for j = #spawned_units_data, 1, -1 do
		local unit = spawned_units_data[j].unit

		if not HEALTH_ALIVE[unit] then
			table.swap_delete(spawned_units_data, j)
		end
	end
end

clone.modify_player_base_damage = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local owner = Managers.player:owner(arg_9_2)

	if not (not owner and owner.bot_player) then
		return arg_9_4 * num_2
	else
		return arg_9_4
	end
end

clone.populate_available_breeds = function (arg_10_0, arg_10_1)
	-- function 10
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local var_10_1 = CurrentConflictSettings.contained_breeds[get_difficulty]

	var_10_1 = var_10_1 or CurrentConflictSettings.contained_breeds[2]

	local available_breeds = arg_10_1.available_breeds

	for k, v in pairs(var_10_1) do
		local var_10_3

		if not CHAOS[k] then
			var_10_3 = "chaos"
		elseif not SKAVEN[k] then
			var_10_3 = "skaven"
		elseif not BEASTMEN[k] then
			var_10_3 = "beastmen"
		elseif not CRITTER[k] then
			var_10_3 = "critter"
		end

		if not var_10_3 then
			arg_10_1.all_available_breeds[k] = true
			available_breeds[var_10_3][k] = true
		end
	end

	table.merge_recursive(arg_10_1.all_available_breeds, CRITTER)
	table.merge_recursive(available_breeds.critter, CRITTER)
end

clone.cb_on_explode = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local radius = ExplosionUtils.get_template(arg_11_2).explosion.radius
	local tbl_2 = {}

	AiUtils.broadphase_query(arg_11_3, radius, tbl_2)

	local var_11_2 = tbl.change_limit[arg_11_1.difficulty_rank]

	var_11_2 = var_11_2 or 1

	local num = 0

	for i, v in ipairs(tbl_2) do
		if var_11_2 <= num then
			break
		end

		if not self.change_ai(arg_11_1, v) then
			num = num + 1
		end
	end

	Managers.state.entity:system("audio_system"):play_2d_audio_event(str)
end

clone.get_overridden_breed = function (self, arg_12_1, arg_12_2)
	-- function 12
	local var_12_0 = tbl_2[arg_12_2]

	if not var_12_0 then
		local var_12_1

		if not var_12_0.chance then
			local var_12_2
			local var_12_3

			self.seed, var_12_3 = Math.next_random(self.seed)

			if var_12_3 <= var_12_0.chance then
				var_12_1 = var_12_0.breed
			end
		else
			var_12_1 = var_12_0.breed
		end

		if not arg_12_1[var_12_1] then
			return nil
		elseif not self.all_available_breeds[var_12_1] then
			return var_12_1
		end
	end

	return nil
end

local function fn_3(arg_13_0)
	-- function 13
	local tbl = {}
	local tbl_2 = {}

	for i, v in ipairs(arg_13_0) do
		local breed_name = v.breed_name
		local var_13_3 = tbl_3[breed_name]

		if not var_13_3 then
			local var_13_4 = tbl_2[breed_name]

			var_13_4 = var_13_4 or var_13_3

			local num = var_13_4 - 1

			tbl_2[breed_name] = num

			if num <= 0 then
				tbl[breed_name] = true
			end
		end
	end

	return tbl
end

local function fn_4(self, arg_14_1, arg_14_2)
	-- function 14
	local tbl = {}

	for k, v in pairs(self[arg_14_1]) do
		if not not arg_14_2[k] then
			tbl[k] = true
		end
	end

	return tbl
end

local function fn_5(arg_15_0)
	-- function 15
	local var_15_0 = BLACKBOARDS[arg_15_0]

	Managers.state.conflict:destroy_unit(arg_15_0, var_15_0, "mutator")
end

local function fn_6(arg_16_0, arg_16_1)
	-- function 16
	local size = table.size(arg_16_1)

	if size > 0 then
		local next_random, var_16_2 = Math.next_random(arg_16_0, 1, size)
		local var_16_3 = table.keys(arg_16_1)[var_16_2]

		return next_random, var_16_3
	end

	return arg_16_0, nil
end

local function fn_7(self, arg_17_1)
	-- function 17
	local alive_specials_count = self:alive_specials_count()

	for i, v in ipairs(arg_17_1) do
		if not v.breed.special then
			alive_specials_count = alive_specials_count + 1
		end
	end

	return alive_specials_count
end

local function fn_8(arg_18_0)
	-- function 18
	local tbl = {}

	for i, v in ipairs(arg_18_0) do
		tbl[v] = true
	end

	return tbl
end

clone.spawn_new_breed = function (self, arg_19_1, arg_19_2)
	-- function 19
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()
	local spawn_queue = self.spawn_queue
	local var_19_2 = BLACKBOARDS[arg_19_1]
	local var_19_3 = POSITION_LOOKUP[arg_19_1]

	if not var_19_3 then
		local explosion_template_name = self.explosion_template_name

		AiUtils.generic_mutator_explosion(arg_19_1, var_19_2, explosion_template_name)

		local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_19_3, 1, 1)

		if not pos_on_mesh then
			local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, var_19_3, 6, 6, 8, 0.5)

			if not inside_position_from_outside_position then
				pos_on_mesh = inside_position_from_outside_position
			end
		end

		local time = Managers.time:time("game")
		local num = time + self.spawn_delay
		local local_rotation = Unit.local_rotation(arg_19_1, 0)

		if not pos_on_mesh then
			local tbl = {
				breed = Breeds[arg_19_2],
				breed_name = arg_19_2,
				rotation_box = QuaternionBox(local_rotation),
				spawn_at_t = num,
				position_box = Vector3Box(pos_on_mesh)
			}

			table.insert(spawn_queue, tbl)

			local num_2 = time + self.change_cooldown

			Unit.set_data(arg_19_1, "can_change_at", num_2)
		end
	end
end

clone.change_ai = function (self, arg_20_1)
	-- function 20
	local time = Managers.time:time("game")
	local get_data = Unit.get_data(arg_20_1, "can_change_at")

	get_data = get_data or 0

	local flag = time <= get_data
	local get_data_2 = Unit.get_data(arg_20_1, "breed")
	local var_20_4 = tbl_4[get_data_2.name]

	if flag or not var_20_4 then
		return
	end

	local clone = table.clone(tbl_5)

	clone[get_data_2.name] = true

	local var_20_6 = fn_3(self.spawned_units_data)
	local var_20_7 = fn_3(self.spawn_queue)

	table.merge(clone, var_20_7)
	table.merge(clone, var_20_6)

	if fn_7(Managers.state.conflict, self.spawn_queue) >= num_8 then
		local var_20_8 = fn_8(CurrentSpecialsSettings.breeds)

		table.merge(clone, var_20_8)
	end

	local race = get_data_2.race
	local var_20_10 = fn_4(self.available_breeds, race, clone)
	local var_20_11
	local var_20_12

	self.seed, var_20_12 = fn_6(self.seed, var_20_10)

	if not var_20_12 then
		local template = self.template

		var_20_12 = template.get_overridden_breed(self, var_20_6, get_data_2.name) or var_20_12

		template.spawn_new_breed(self, arg_20_1, var_20_12)
		fn_5(arg_20_1)

		return true
	else
		print("Bolt of Change: No available breed found.")

		return false
	end
end

clone.server_player_hit_function = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	if arg_21_4[2] == "bolt_of_change" then
		local extension_input = ScriptUnit.extension_input(arg_21_2, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_dialogue_event("curse_damage_taken", alloc_table)
	end
end

return clone
