-- chunkname: @scripts/managers/backend/statistics_util.lua

local alive = Unit.alive
local get_data = Unit.get_data

StatisticsUtil = {}

local StatisticsUtil = StatisticsUtil
local tbl = {
	we_1h_axe = {
		"holly"
	},
	bw_1h_crowbill = {
		"holly"
	},
	wh_dual_wield_axe_falchion = {
		"holly"
	},
	dr_dual_wield_hammers = {
		"holly"
	},
	es_dual_wield_hammer_sword = {
		"holly"
	},
	bw_1h_flail_flaming = {
		"scorpion"
	},
	dr_1h_throwing_axes = {
		"scorpion"
	},
	we_1h_spears_shield = {
		"scorpion"
	},
	es_2h_heavy_spear = {
		"scorpion"
	},
	wh_2h_billhook = {
		"scorpion"
	}
}

DLCUtils.dofile_list("statistics_util")

StatisticsUtil.generate_weapon_kill_stats_dlc = function (self, arg_1_1, arg_1_2)
	-- function 1
	for k, v in pairs(tbl) do
		if not table.contains(v, arg_1_1) then
			local clone = table.clone(arg_1_2)
			local str = arg_1_1 .. "_kills_" .. k

			clone.database_name = str
			self[str] = clone
		end
	end
end

local function fn(self, arg_2_1, arg_2_2)
	-- function 2
	local name = arg_2_2.name
	local var_2_1 = tbl[name]

	if arg_2_2.rarity == "magic" then
		local required_unlock_item = arg_2_2.required_unlock_item

		var_2_1 = tbl[required_unlock_item]
		name = required_unlock_item
	end

	if not var_2_1 then
		local unlock = Managers.unlock

		for i = 1, #var_2_1 do
			local var_2_4 = var_2_1[i]

			if not unlock:is_dlc_unlocked(var_2_4) then
				self:increment_stat(arg_2_1, var_2_4 .. "_kills_" .. name)
			end
		end
	end
end

DLCUtils.merge("_tracked_weapon_kill_stats", tbl)

local tbl_2 = {
	warcamp = {
		"scorpion"
	},
	skaven_stronghold = {
		"scorpion"
	},
	ground_zero = {
		"scorpion"
	},
	skittergate = {
		"scorpion"
	}
}
local tbl_3 = {
	bw_1h_flail_flaming = {
		"scorpion"
	},
	dr_1h_throwing_axes = {
		"scorpion"
	},
	we_1h_spears_shield = {
		"scorpion"
	},
	es_2h_heavy_spear = {
		"scorpion"
	},
	wh_2h_billhook = {
		"scorpion"
	}
}

StatisticsUtil.generate_level_complete_with_weapon_stats_dlc = function (self, arg_3_1, arg_3_2)
	-- function 3
	for k, v in pairs(tbl_2) do
		if not table.contains(v, arg_3_1) then
			for k_2, v_2 in pairs(tbl_3) do
				if not table.contains(v_2, arg_3_1) then
					local clone = table.clone(arg_3_2)
					local str = arg_3_1 .. "_" .. k .. "_" .. k_2

					clone.database_name = str
					self[str] = clone
				end
			end
		end
	end
end

local function fn_2(self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local var_4_0 = DifficultySettings[arg_4_4]

	if not var_4_0 then
		return
	end

	if not (not arg_4_2 and tbl_2[arg_4_2]) then
		local flag = not arg_4_3 and tbl_3[arg_4_3]

		if not flag then
			local unlock = Managers.unlock

			for i = 1, #flag do
				local var_4_3 = flag[i]

				if not unlock:is_dlc_unlocked(var_4_3) then
					local str = var_4_3 .. "_" .. arg_4_2 .. "_" .. arg_4_3

					if self:get_persistent_stat(arg_4_1, str) < var_4_0.rank then
						self:set_stat(arg_4_1, str, var_4_0.rank)
					end
				end
			end
		end
	end
end

StatisticsUtil.register_kill = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local has_extension = ScriptUnit.has_extension(arg_5_0, "health_system")
	local last_damage_data = has_extension.last_damage_data

	if not last_damage_data then
		return
	end

	local player = Managers.player
	local owner = player:owner(arg_5_0)
	local var_5_4 = get_data(arg_5_0, "breed")
	local flag = not var_5_4 and var_5_4.name
	local breed = last_damage_data.breed
	local attacker_side = last_damage_data.attacker_side
	local attacker_unique_id = last_damage_data.attacker_unique_id
	local player_from_unique_id = player:player_from_unique_id(attacker_unique_id)
	local side = Managers.state.side
	local var_5_11 = side.side_by_unit[arg_5_0]
	local local_player = Managers.player:local_player()
	local flag_2 = not owner and has_extension:was_attacked_by(not local_player and local_player:unique_id())

	if not flag_2 and owner == local_player or not side:is_enemy_by_side(attacker_side, var_5_11) then
		local stats_id = local_player:stats_id()
		local name = flag_2.attacker_breed.name

		arg_5_2:increment_stat(stats_id, "eliminations_as_breed", name)
		Managers.state.event:trigger("add_player_kill_confirmation", attacker_side:name(), owner)
	end

	if not (not player_from_unique_id and player_from_unique_id == owner) then
		local stats_id_2 = player_from_unique_id:stats_id()

		arg_5_2:increment_stat(stats_id_2, "kills_total")

		if not var_5_4 then
			Managers.state.achievement:trigger_event("register_kill", stats_id_2, arg_5_0, arg_5_1, var_5_4)

			local race = var_5_4.race

			if Breeds[flag] or not PlayerBreeds[flag] or not Managers.state.side:is_enemy_by_side(attacker_side, var_5_11) then
				local get_difficulty = Managers.state.difficulty:get_difficulty()

				arg_5_2:increment_stat(stats_id_2, "kills_per_breed", flag)
				arg_5_2:increment_stat(stats_id_2, "kills_per_breed_difficulty", flag, get_difficulty)
			end

			arg_5_2:increment_stat(stats_id_2, "kills_per_breed_persistent", flag)

			if not race then
				arg_5_2:increment_stat(stats_id_2, "kills_per_race", race)

				if race == "critter" then
					local human_players = Managers.player:human_players()

					for k, v in pairs(human_players) do
						local stats_id_3 = v:stats_id()

						if not stats_id_3 then
							arg_5_2:increment_stat(stats_id_3, "kills_critter_total")
						end
					end
				end
			end

			local var_5_21 = arg_5_1[DamageDataIndex.DAMAGE_SOURCE_NAME]
			local var_5_22 = rawget(ItemMasterList, var_5_21)

			if not var_5_22 then
				local slot_type = var_5_22.slot_type
				local var_5_24 = arg_5_1[DamageDataIndex.ATTACK_TYPE]

				if not var_5_24 then
					slot_type = var_5_24 == "heavy_attack" or var_5_24 == "light_attack" or "melee" or "ranged"
				end

				if not slot_type then
					local template = var_5_22.template

					if not template then
						local get_weapon_template = WeaponUtils.get_weapon_template(template)
						local flag_3 = not get_weapon_template and get_weapon_template.buff_type

						if not MeleeBuffTypes[flag_3] then
							slot_type = "melee"
						elseif not RangedBuffTypes[flag_3] then
							slot_type = "ranged"
						end
					end
				end

				if slot_type == "melee" then
					arg_5_2:increment_stat(stats_id_2, "kills_melee")
				elseif slot_type == "ranged" then
					arg_5_2:increment_stat(stats_id_2, "kills_ranged")
				end

				fn(arg_5_2, stats_id_2, var_5_22)
			end
		end
	end

	if not var_5_4 and not breed and not var_5_4.awards_positive_reinforcement_message then
		local setting = Managers.state.game_mode:setting("positive_reinforcement_check")
		local str = "killed_special"

		if not setting and not setting(str, breed, var_5_4) then
			local name_2 = breed.name
			local flag_4 = false
			local str_2 = ""

			if not player_from_unique_id then
				flag_4 = player_from_unique_id.local_player
				str_2 = player_from_unique_id:stats_id()
			end

			local var_5_33 = str_2
			local killfeed_fold_with = var_5_4.killfeed_fold_with

			killfeed_fold_with = killfeed_fold_with or flag

			local str_3 = var_5_33 .. killfeed_fold_with

			Managers.state.event:trigger("add_coop_feedback_kill", str_3, flag_4, str, name_2, flag, player_from_unique_id, owner)
		end
	end

	if not var_5_4 and var_5_4.elite and not var_5_4.boss then
		local var_5_36 = Managers.state.side.side_by_unit[arg_5_0]

		if not (not attacker_side and attacker_side == var_5_36) then
			local occupied_slots = attacker_side.party.occupied_slots

			for i, v_2 in ipairs(occupied_slots) do
				local player_2 = v_2.player

				if player_2 ~= player_from_unique_id then
					local stats_id_4 = player_2:stats_id()

					if not arg_5_2:is_registered(stats_id_4) then
						local get_difficulty_2 = Managers.state.difficulty:get_difficulty()

						arg_5_2:increment_stat(stats_id_4, "kill_assists_per_breed", flag)
						arg_5_2:increment_stat(stats_id_4, "kill_assists_per_breed_difficulty", flag, get_difficulty_2)
					end
				end
			end
		end
	end
end

StatisticsUtil.register_knockdown = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local has_extension = ScriptUnit.has_extension(arg_6_0, "health_system")
	local last_damage_data = has_extension.last_damage_data

	if not last_damage_data then
		return
	end

	local player = Managers.player
	local owner = player:owner(arg_6_0)
	local var_6_4 = get_data(arg_6_0, "breed")
	local flag = not var_6_4 and var_6_4.name
	local breed = last_damage_data.breed
	local attacker_unique_id = last_damage_data.attacker_unique_id
	local player_from_unique_id = player:player_from_unique_id(attacker_unique_id)
	local local_player = Managers.player:local_player()

	if not flag then
		if not (not player_from_unique_id and player_from_unique_id == owner) then
			local stats_id = player_from_unique_id:stats_id()

			arg_6_2:increment_stat(stats_id, "vs_knockdowns_per_breed", flag)
		end

		local was_attacked_by = has_extension:was_attacked_by(not local_player and local_player:unique_id())

		if not (not was_attacked_by and owner == local_player) then
			local name = was_attacked_by.attacker_breed.name
			local stats_id_2 = local_player:stats_id()

			arg_6_2:increment_stat(stats_id_2, "eliminations_as_breed", name)
			arg_6_2:increment_stat(stats_id_2, "vs_knockdowns_per_breed", flag)
			Managers.state.event:trigger("add_player_knock_confirmation", local_player, owner)
		end
	end

	if not var_6_4 and not breed and not var_6_4.awards_positive_reinforcement_message then
		local name_2 = breed.name
		local str = "player_knocked_down"
		local flag_2 = false
		local str_2 = ""

		if not player_from_unique_id then
			flag_2 = player_from_unique_id.local_player
			str_2 = player_from_unique_id:stats_id()
		end

		Managers.state.event:trigger("add_coop_feedback_kill", str_2 .. flag, flag_2, str, name_2, flag)

		if not owner and not player_from_unique_id then
			Managers.state.achievement:trigger_event("register_knockdown", str_2, arg_6_0, player_from_unique_id, var_6_4)
		end
	end
end

StatisticsUtil.check_save = function (arg_7_0, arg_7_1)
	-- function 7
	local target_unit = BLACKBOARDS[arg_7_1].target_unit
	local player = Managers.player

	if not (not arg_7_0 and target_unit) then
		return
	end

	local is_player_unit = player:is_player_unit(arg_7_0)
	local is_player_unit_2 = player:is_player_unit(target_unit)

	if not (not is_player_unit and is_player_unit_2) then
		return
	end

	local owner = player:owner(arg_7_0)
	local owner_2 = player:owner(target_unit)

	if owner == owner_2 then
		return
	end

	local var_7_6
	local network = Managers.state.network
	local game = network:game()
	local flag = not game and network:unit_game_object_id(target_unit)

	if not flag then
		var_7_6 = Vector3.normalize(Vector3.flat(GameSession.game_object_field(game, flag, "aim_direction")))
	else
		var_7_6 = Quaternion.forward(Unit.local_rotation(target_unit, 0))
	end

	local forward = Quaternion.forward(Unit.local_rotation(arg_7_1, 0))
	local var_7_11 = POSITION_LOOKUP[target_unit]
	local var_7_12 = POSITION_LOOKUP[arg_7_1]
	local num = var_7_11 - var_7_12
	local flag_2 = not (Vector3.distance(var_7_11, var_7_12) < 3) or not (Vector3.dot(num, var_7_6) > 0) or Vector3.dot(num, forward) > 0
	local extension = ScriptUnit.extension(target_unit, "status_system")
	local get_pouncer_unit = extension:get_pouncer_unit()

	get_pouncer_unit = get_pouncer_unit or extension:get_pack_master_grabber()

	local is_disabled = extension:is_disabled()
	local var_7_18
	local statistics_db = player:statistics_db()
	local stats_id = owner:stats_id()

	if arg_7_1 == get_pouncer_unit then
		var_7_18 = "save"

		statistics_db:increment_stat(stats_id, "saves")
	elseif flag_2 or not is_disabled then
		var_7_18 = "aid"

		statistics_db:increment_stat(stats_id, "aidings")
	end

	if not var_7_18 then
		local flag_3 = not not owner.remote or not owner.bot_player

		Managers.state.event:trigger("add_coop_feedback", stats_id .. owner_2:stats_id(), flag_3, var_7_18, owner, owner_2)
		ScriptUnit.extension(target_unit, "buff_system"):trigger_procs("on_assisted", arg_7_0, arg_7_1)
		ScriptUnit.extension(arg_7_0, "buff_system"):trigger_procs("on_assisted_ally", target_unit, arg_7_1)

		local network_transmit = Managers.state.network.network_transmit
		local network_id = owner:network_id()
		local local_player_id = owner:local_player_id()
		local network_id_2 = owner_2:network_id()
		local local_player_id_2 = owner_2:local_player_id()
		local var_7_27 = NetworkLookup.coop_feedback[var_7_18]
		local unit_game_object_id = network:unit_game_object_id(arg_7_1)

		network_transmit:send_rpc_clients("rpc_assist", network_id, local_player_id, network_id_2, local_player_id_2, var_7_27, unit_game_object_id)
	end
end

StatisticsUtil.register_pull_up = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local player = Managers.player
	local owner = player:owner(arg_8_0)
	local owner_2 = player:owner(arg_8_1)

	if not owner and not owner_2 then
		local str = "assisted_respawn"
		local flag = not not owner.remote or not owner.bot_player

		Managers.state.event:trigger("add_coop_feedback", owner:stats_id() .. owner_2:stats_id(), flag, str, owner, owner_2)
	end
end

StatisticsUtil.register_assisted_respawn = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local player = Managers.player
	local owner = player:owner(arg_9_0)
	local owner_2 = player:owner(arg_9_1)

	if not owner and not owner_2 then
		local str = "assisted_respawn"
		local flag = not not owner.remote or not owner.bot_player

		Managers.state.event:trigger("add_coop_feedback", owner:stats_id() .. owner_2:stats_id(), flag, str, owner, owner_2)
	end
end

StatisticsUtil.register_revive = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local player = Managers.player
	local owner = player:owner(arg_10_0)

	if not owner then
		local stats_id = owner:stats_id()

		arg_10_2:increment_stat(stats_id, "revives")
	end

	local owner_2 = player:owner(arg_10_1)

	if not owner_2 then
		local stats_id_2 = owner_2:stats_id()

		arg_10_2:increment_stat(stats_id_2, "times_revived")
	end

	if not owner and not owner_2 then
		local str = "revive"
		local flag = not not owner.remote or not owner.bot_player

		Managers.state.event:trigger("add_coop_feedback", owner:stats_id() .. owner_2:stats_id(), flag, str, owner, owner_2)
		Managers.state.achievement:trigger_event("register_revive", arg_10_0, arg_10_1)
	end
end

StatisticsUtil.register_heal = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local player = Managers.player
	local owner = player:owner(arg_11_0)
	local owner_2 = player:owner(arg_11_1)

	if not (not owner and not owner_2 and owner == owner_2) then
		local str = "heal"
		local flag = not not owner.remote or not owner.bot_player

		Managers.state.event:trigger("add_coop_feedback", owner:stats_id() .. owner_2:stats_id(), flag, str, owner, owner_2)

		local stats_id = owner:stats_id()

		arg_11_2:increment_stat(stats_id, "times_friend_healed")
	end
end

StatisticsUtil.register_damage = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local var_12_0 = arg_12_1[DamageDataIndex.ATTACKER]
	local var_12_1 = arg_12_1[DamageDataIndex.DAMAGE_SOURCE_NAME]
	local var_12_2 = var_12_0
	local player = Managers.player
	local get_actual_attacker_player = AiUtils.get_actual_attacker_player(var_12_2, arg_12_0, var_12_1)

	if not get_actual_attacker_player then
		var_12_2 = get_actual_attacker_player.player_unit
	else
		var_12_2 = arg_12_1[DamageDataIndex.SOURCE_ATTACKER_UNIT] or var_12_2
		var_12_2 = AiUtils.get_actual_attacker_unit(var_12_2)
		get_actual_attacker_player = player:owner(var_12_2)
	end

	local var_12_5 = alive(arg_12_0)

	var_12_5 = not var_12_5 and get_data(arg_12_0, "breed")

	local var_12_6 = alive(var_12_2)

	var_12_6 = not var_12_6 and get_data(var_12_2, "breed")

	local get_actual_attacker_breed = AiUtils.get_actual_attacker_breed(var_12_6, arg_12_0, var_12_1, var_12_0, get_actual_attacker_player)

	if not (not var_12_6 and var_12_6 == get_actual_attacker_breed) then
		var_12_2 = nil

		if not (not get_actual_attacker_breed and get_actual_attacker_breed.is_player) then
			get_actual_attacker_player = nil
		end
	end

	local var_12_8 = get_actual_attacker_breed

	if not (not get_actual_attacker_player and arg_12_2:is_registered(get_actual_attacker_player:stats_id())) then
		return
	end

	local owner = player:owner(arg_12_0)
	local var_12_10 = arg_12_1[DamageDataIndex.DAMAGE_AMOUNT]

	if not owner then
		local stats_id = owner:stats_id()

		arg_12_2:modify_stat_by_amount(stats_id, "damage_taken", var_12_10)

		local extension = ScriptUnit.extension(arg_12_0, "health_system")
		local current_health = extension:current_health()
		local get_max_health = extension:get_max_health()
		local num = (current_health - var_12_10) / get_max_health
		local extension_2 = ScriptUnit.extension(arg_12_0, "career_system")
		local career_name = extension_2:career_name()

		if not extension_2:get_breed().is_hero then
			Managers.state.achievement:trigger_event("register_damage_taken", arg_12_0, arg_12_1)

			if num < arg_12_2:get_stat(stats_id, "min_health_percentage", career_name) then
				arg_12_2:set_stat(stats_id, "min_health_percentage", career_name, num)
			end
		end
	end

	if not get_actual_attacker_player and not var_12_5 then
		local name = var_12_5.name
		local current_health_2 = ScriptUnit.extension(arg_12_0, "health_system"):current_health()

		if current_health_2 > 0 then
			local side = Managers.state.side
			local stats_id_2 = get_actual_attacker_player:stats_id()

			Managers.state.achievement:trigger_event("register_damage", stats_id_2, arg_12_0, arg_12_1, var_12_2, var_12_5)

			var_12_10 = math.clamp(var_12_10, 0, current_health_2)

			arg_12_2:modify_stat_by_amount(stats_id_2, "damage_dealt", var_12_10)

			local get_side_from_player_unique_id = side:get_side_from_player_unique_id(get_actual_attacker_player:unique_id())
			local var_12_23 = side.side_by_unit[arg_12_0]
			local is_enemy_by_side = side:is_enemy_by_side(get_side_from_player_unique_id, var_12_23)

			if Breeds[name] or not PlayerBreeds[name] or not is_enemy_by_side then
				arg_12_2:modify_stat_by_amount(stats_id_2, "damage_dealt_per_breed", name, var_12_10)
			end

			if arg_12_1[DamageDataIndex.HIT_ZONE] == "head" then
				arg_12_2:increment_stat(stats_id_2, "headshots")
			end

			local flag = not var_12_8 and var_12_8.name

			if not is_enemy_by_side then
				if Managers.mechanism:current_mechanism_name() == "versus" then
					if get_side_from_player_unique_id:name() == "heroes" then
						arg_12_2:modify_stat_by_amount(stats_id_2, "vs_damage_dealt_to_pactsworn", var_12_10)
					end

					if not (not var_12_8 and get_side_from_player_unique_id:name() ~= "dark_pact") then
						arg_12_2:modify_stat_by_amount(stats_id_2, "state_damage_dealt_as_pactsworn_breed", flag, var_12_10)
					end
				end

				if not owner and not get_side_from_player_unique_id.show_damage_feedback and not HEALTH_ALIVE[arg_12_0] then
					local owner_2 = player:owner(arg_12_0)
					local flag_2 = not not get_actual_attacker_player.remote or not get_actual_attacker_player.bot_player
					local flag_3

					flag_3 = not flag_2 and "dealing_damage" and "other_dealing_damage"

					local var_12_29 = arg_12_1[DamageDataIndex.DAMAGE_TYPE]

					Managers.state.event:trigger("add_damage_feedback_event", stats_id_2 .. name, flag_2, flag_3, get_actual_attacker_player, owner_2, var_12_10, var_12_29)
				end
			end

			if not flag then
				arg_12_2:modify_stat_by_amount(stats_id_2, "damage_dealt_as_breed", flag, var_12_10)
			end
		end
	end

	if var_12_1 ~= "skaven_ratling_gunner" or not owner then
		local stats_id_3 = owner:stats_id()

		arg_12_2:modify_stat_by_amount(stats_id_3, "damage_taken_from_ratling_gunner", var_12_10)
	end
end

StatisticsUtil.won_games = function (self)
	-- function 13
	local stats_id = Managers.player:local_player():stats_id()
	local num = 0

	for i, v in ipairs(UnlockableLevels) do
		num = num + self:get_persistent_stat(stats_id, "completed_levels", v)
	end

	return num
end

StatisticsUtil.register_collected_grimoires = function (arg_14_0, arg_14_1)
	-- function 14
	local stats_id = Managers.player:local_player():stats_id()

	for i = 1, arg_14_0 do
		arg_14_1:increment_stat(stats_id, "total_collected_grimoires")
	end

	local level_id = LevelHelper:current_level_settings().level_id

	if not table.find(UnlockableLevels, level_id) then
		return
	end

	if arg_14_0 > arg_14_1:get_persistent_stat(stats_id, "collected_grimoires", level_id) then
		arg_14_1:set_stat(stats_id, "collected_grimoires", level_id, arg_14_0)
	end
end

StatisticsUtil.register_collected_tomes = function (arg_15_0, arg_15_1)
	-- function 15
	local stats_id = Managers.player:local_player():stats_id()

	for i = 1, arg_15_0 do
		arg_15_1:increment_stat(stats_id, "total_collected_tomes")
	end

	local level_id = LevelHelper:current_level_settings().level_id

	if not table.find(UnlockableLevels, level_id) then
		return
	end

	if arg_15_0 > arg_15_1:get_persistent_stat(stats_id, "collected_tomes", level_id) then
		arg_15_1:set_stat(stats_id, "collected_tomes", level_id, arg_15_0)
	end
end

StatisticsUtil.register_collected_dice = function (arg_16_0, arg_16_1)
	-- function 16
	local stats_id = Managers.player:local_player():stats_id()

	for i = 1, arg_16_0 do
		arg_16_1:increment_stat(stats_id, "total_collected_dice")
	end

	local level_id = LevelHelper:current_level_settings().level_id

	if not table.find(UnlockableLevels, level_id) then
		return
	end

	if arg_16_0 > arg_16_1:get_persistent_stat(stats_id, "collected_dice", level_id) then
		arg_16_1:set_stat(stats_id, "collected_dice", level_id, arg_16_0)
	end
end

StatisticsUtil.register_complete_level = function (self)
	-- function 17
	local level_id = LevelHelper:current_level_settings().level_id

	if not table.find(UnlockableLevels, level_id) then
		return
	end

	local game_mode_key = Managers.state.game_mode:game_mode_key()
	local local_player = Managers.player:local_player()
	local stats_id = local_player:stats_id()
	local var_17_4
	local var_17_5

	if game_mode_key == "versus" then
		local preferred_profile_index = Managers.party:get_status_from_unique_id(stats_id).preferred_profile_index

		if not preferred_profile_index then
			return
		end

		var_17_4 = SPProfiles[preferred_profile_index]
		var_17_5 = var_17_4.display_name
	else
		local profile_index = local_player:profile_index()

		var_17_4 = SPProfiles[profile_index]
		var_17_5 = var_17_4.display_name
	end

	self:increment_stat(stats_id, "completed_levels_" .. var_17_5, level_id)

	local system = Managers.state.entity:system("mission_system")
	local get_level_end_mission_data = system:get_level_end_mission_data("grimoire_hidden_mission")
	local get_level_end_mission_data_2 = system:get_level_end_mission_data("tome_bonus_mission")
	local get_level_end_mission_data_3 = system:get_level_end_mission_data("bonus_dice_hidden_mission")

	if not get_level_end_mission_data then
		StatisticsUtil.register_collected_grimoires(get_level_end_mission_data.current_amount, self)
	end

	if not get_level_end_mission_data_2 then
		StatisticsUtil.register_collected_tomes(get_level_end_mission_data_2.current_amount, self)
	end

	if not get_level_end_mission_data_3 then
		StatisticsUtil.register_collected_dice(get_level_end_mission_data_3.current_amount, self)
	end

	self:increment_stat(stats_id, "completed_levels", level_id)

	if not Managers.deed and not Managers.deed:has_deed() then
		self:increment_stat(stats_id, "completed_heroic_deeds")
	end

	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local career_index = local_player:career_index()
	local name = var_17_4.careers[career_index].name

	StatisticsUtil._register_completed_level_difficulty(self, level_id, name, get_difficulty)

	local get_interface = Managers.backend:get_interface("items")
	local get_loadout_item_id = BackendUtils.get_loadout_item_id(name, "slot_melee")
	local flag = not get_loadout_item_id and get_interface:get_item_name(get_loadout_item_id)
	local get_loadout_item_id_2 = BackendUtils.get_loadout_item_id(name, "slot_ranged")
	local flag_2 = not get_loadout_item_id_2 and get_interface:get_item_name(get_loadout_item_id_2)

	fn_2(self, stats_id, level_id, flag, get_difficulty)
	fn_2(self, stats_id, level_id, flag_2, get_difficulty)

	if not Managers.unlock:is_dlc_unlocked("holly") then
		local rank = DifficultySettings.hardest.rank
		local rank_2

		if not DifficultySettings[get_difficulty] then
			rank_2 = DifficultySettings[get_difficulty].rank

			if not rank_2 then
				-- Nothing
			end
		end

		rank_2 = 0

		::label_17_0::

		local flag_3 = rank <= rank_2
		local flag_4 = level_id == "ground_zero" or level_id == "warcamp" or level_id == "skaven_stronghold" or level_id == "skittergate"

		if not flag_3 and not flag_4 then
			local tbl = {
				"we_1h_axe",
				"bw_1h_crowbill",
				"wh_dual_wield_axe_falchion",
				"dr_dual_wield_hammers",
				"es_dual_wield_hammer_sword"
			}
			local var_17_25

			if not table.contains(tbl, flag) then
				var_17_25 = flag
			elseif not table.contains(tbl, flag_2) then
				var_17_25 = flag_2
			end

			if not var_17_25 then
				local str = "holly_completed_level_" .. level_id .. "_with_" .. var_17_25

				self:increment_stat(stats_id, str)
			end
		end
	end
end

StatisticsUtil.register_versus_game_won = function (self, arg_18_1, arg_18_2)
	-- function 18
	local stats_id = arg_18_1:stats_id()
	local var_18_1 = self
	local increment_stat = self.increment_stat
	local var_18_3 = stats_id
	local flag

	flag = not arg_18_2 and "vs_game_won" and "vs_game_lost"

	increment_stat(var_18_1, var_18_3, flag)
end

StatisticsUtil.register_weave_complete = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	local stats_id = arg_19_1:stats_id()
	local weave = Managers.weave
	local get_weave_tier = weave:get_weave_tier()
	local get_active_weave = weave:get_active_weave()
	local get_active_wind = weave:get_active_wind()
	local get_score = weave:get_score()
	local get_num_players = weave:get_num_players()
	local profile_index = arg_19_1:profile_index()
	local var_19_8 = SPProfiles[profile_index]
	local career_index = arg_19_1:career_index()
	local name = var_19_8.careers[career_index].name
	local get_stat = self:get_stat(stats_id, "min_health_percentage", name)
	local get_persistent_stat = self:get_persistent_stat(stats_id, "min_health_completed", name)

	if not (not get_persistent_stat and not get_stat and not (get_persistent_stat <= get_stat)) then
		self:set_stat(stats_id, "min_health_completed", name, get_stat)
	end

	if not arg_19_2 then
		local str = "weave_quickplay_wins"

		self:increment_stat(stats_id, ScorpionSeasonalSettings.current_season_name, str)
		self:increment_stat(stats_id, "scorpion_weaves_won")

		if not (ScorpionSeasonalSettings.current_season_id == 1 or IS_WINDOWS) then
			local str_2 = "weave_quickplay_" .. arg_19_3 .. "_wins"

			self:increment_stat(stats_id, "season_1", str_2)
		end
	else
		if not (ScorpionSeasonalSettings.current_season_id == 1 or IS_WINDOWS) then
			local str_3 = "weave_rainbow_" .. get_active_wind .. "_" .. name .. "_season_1"

			self:set_stat(stats_id, "season_1", str_3, 1)

			local str_4 = "weaves_complete_" .. name .. "_season_1"

			self:increment_stat(stats_id, "season_1", str_4)
			StatisticsUtil._register_mutator_challenges(self, stats_id, get_active_wind)
			self:increment_stat(stats_id, "season_1", "weave_won", get_weave_tier)
		end

		self:increment_stat(stats_id, "completed_weaves", get_active_weave)
		self:increment_stat(stats_id, "scorpion_weaves_won")

		local get_weave_score_stat = ScorpionSeasonalSettings.get_weave_score_stat(get_weave_tier, get_num_players)

		if get_score > self:get_persistent_stat(stats_id, ScorpionSeasonalSettings.current_season_name, get_weave_score_stat) then
			self:set_stat(stats_id, ScorpionSeasonalSettings.current_season_name, get_weave_score_stat, get_score)
		end
	end
end

StatisticsUtil._register_mutator_challenges = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not (ScorpionSeasonalSettings.current_season_id == 1 or IS_WINDOWS) then
		if arg_20_2 == "life" then
			local str = "weave_life_stepped_in_bush"

			if self:get_persistent_stat(arg_20_1, "season_1", str) == 0 then
				local str_2 = "scorpion_weaves_life_season_1"

				self:increment_stat(arg_20_1, "season_1", str_2)
			end
		elseif arg_20_2 == "death" then
			local str_3 = "weave_death_hit_by_spirit"

			if self:get_persistent_stat(arg_20_1, "season_1", str_3) == 0 then
				local str_4 = "scorpion_weaves_death_season_1"

				self:increment_stat(arg_20_1, "season_1", str_4)
			end
		elseif arg_20_2 == "beasts" then
			local str_5 = "weave_beasts_destroyed_totems"

			if self:get_persistent_stat(arg_20_1, "season_1", str_5) == 0 then
				local str_6 = "scorpion_weaves_beasts_season_1"

				self:increment_stat(arg_20_1, "season_1", str_6)
			end
		elseif arg_20_2 == "light" then
			local str_7 = "weave_light_low_curse"

			if self:get_persistent_stat(arg_20_1, "season_1", str_7) == 0 then
				local str_8 = "scorpion_weaves_light_season_1"

				self:increment_stat(arg_20_1, "season_1", str_8)
			end
		elseif arg_20_2 == "shadow" then
			local str_9 = "weave_shadow_kill_no_shrouded"

			if self:get_persistent_stat(arg_20_1, "season_1", str_9) == 0 then
				local str_10 = "scorpion_weaves_shadow_season_1"

				self:increment_stat(arg_20_1, "season_1", str_10)
			end
		end
	end
end

StatisticsUtil.register_journey_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	StatisticsUtil._register_completed_journey_difficulty(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
end

StatisticsUtil.register_complete_tutorial = function (self)
	-- function 22
	local current_level_settings = LevelHelper:current_level_settings()
	local stats_id = Managers.player:local_player():stats_id()
	local level_id = current_level_settings.level_id

	self:increment_stat(stats_id, "completed_levels", level_id)
end

StatisticsUtil.register_played_quickplay_level = function (self, arg_23_1, arg_23_2)
	-- function 23
	if not table.find(UnlockableLevels, arg_23_2) then
		return
	end

	self:increment_stat(arg_23_1:stats_id(), "played_levels_quickplay", arg_23_2)
	StatisticsUtil.register_last_played_level_id(self, arg_23_1, arg_23_2)
end

StatisticsUtil.register_played_weekly_event_level = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	if not table.find(UnlockableLevels, arg_24_2) then
		return
	end

	local stats_id = arg_24_1:stats_id()

	self:increment_stat(stats_id, "played_levels_weekly_event", arg_24_2)

	local get_difficulty = Managers.state.difficulty:get_difficulty()

	self:increment_stat(stats_id, "completed_weekly_event_difficulty", get_difficulty)
end

StatisticsUtil.register_last_played_level_id = function (self, arg_25_1, arg_25_2)
	-- function 25
	local find = table.find(UnlockableLevels, arg_25_2)

	if not find then
		self:set_stat(arg_25_1:stats_id(), "last_played_level_id", find)
	end
end

StatisticsUtil.get_game_progress = function (self)
	-- function 26
	local stats_id = Managers.player:local_player():stats_id()
	local num = #MainGameLevels * 5
	local num_2 = 0
	local var_26_3
	local var_26_4

	for k, v in pairs(MainGameLevels) do
		local var_26_5 = LevelDifficultyDBNames[v]
		local get_persistent_stat = self:get_persistent_stat(stats_id, "completed_levels_difficulty", var_26_5)

		print("Completed Level Difficulty", var_26_5, get_persistent_stat, v)

		num_2 = num_2 + get_persistent_stat
	end

	return num_2 / num * 100
end

StatisticsUtil._register_completed_level_difficulty = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local local_player = Managers.player:local_player()
	local stats_id = local_player:stats_id()
	local var_27_2 = LevelDifficultyDBNames[arg_27_1]
	local get_persistent_stat = self:get_persistent_stat(stats_id, "completed_levels_difficulty", var_27_2)
	local get_default_difficulties = Managers.state.difficulty:get_default_difficulties()
	local find = table.find(get_default_difficulties, arg_27_3)

	if not find then
		Managers.state.achievement:trigger_event("register_completed_level", arg_27_3, arg_27_1, arg_27_2, local_player)

		if get_persistent_stat < find then
			self:set_stat(stats_id, "completed_levels_difficulty", var_27_2, find)
		end

		if not (not self:has_stat("mission_streak", arg_27_2) and not (find > self:get_persistent_stat(stats_id, "mission_streak", arg_27_2, arg_27_1))) then
			self:set_stat(stats_id, "mission_streak", arg_27_2, arg_27_1, find)
		end
	end

	self:increment_stat(stats_id, "completed_career_levels", arg_27_2, arg_27_1, arg_27_3)

	local get_stat = self:get_stat(stats_id, "min_health_percentage", arg_27_2)
	local get_persistent_stat_2 = self:get_persistent_stat(stats_id, "min_health_completed", arg_27_2)

	if not (not get_persistent_stat_2 and not get_stat and not (get_persistent_stat_2 < get_stat)) then
		self:set_stat(stats_id, "min_health_completed", arg_27_2, get_stat)
	end

	self:increment_stat(stats_id, "played_difficulty", arg_27_3)
end

StatisticsUtil._register_completed_journey_difficulty = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local stats_id = arg_28_1:stats_id()
	local profile_index = arg_28_1:profile_index()
	local var_28_2 = SPProfilesAbbreviation[profile_index]
	local var_28_3 = JourneyDifficultyDBNames[arg_28_2]
	local var_28_4 = JourneyDominantGodDifficultyDBNames[arg_28_3]
	local get_persistent_stat = self:get_persistent_stat(stats_id, "completed_journeys_difficulty", var_28_3)
	local get_persistent_stat_2 = self:get_persistent_stat(stats_id, "completed_journey_dominant_god_difficulty", var_28_4)
	local get_persistent_stat_3 = self:get_persistent_stat(stats_id, "completed_hero_journey_difficulty", var_28_2, var_28_3)
	local get_default_difficulties = Managers.state.difficulty:get_default_difficulties()
	local find = table.find(get_default_difficulties, arg_28_4)

	if get_persistent_stat < find then
		if find > #DefaultDifficulties then
			ferror("This shouldn't happen. \ndifficulties: %s\ndifficulty_name: %s\ndifficulty_index: %s\nDefaultDifficulties: %s\ncurrent_completed_difficulty: %s", table.tostring(get_default_difficulties), arg_28_4, find, table.tostring(DefaultDifficulties), get_persistent_stat)
		end

		self:set_stat(stats_id, "completed_journeys_difficulty", var_28_3, find)
	end

	if get_persistent_stat_2 < find then
		if find > #DefaultDifficulties then
			ferror("This shouldn't happen. \ndifficulties: %s\ndifficulty_name: %s\ndifficulty_index: %s\nDefaultDifficulties: %s\ncurrent_completed_journey_dominant_god_difficulty: %s", table.tostring(get_default_difficulties), arg_28_4, find, table.tostring(DefaultDifficulties), get_persistent_stat_2)
		end

		self:set_stat(stats_id, "completed_journey_dominant_god_difficulty", var_28_4, find)
	end

	if get_persistent_stat_3 < find then
		if find > #DefaultDifficulties then
			ferror("This shouldn't happen. \ndifficulties: %s\ndifficulty_name: %s\ndifficulty_index: %s\nDefaultDifficulties: %s\ncurrent_completed_hero_journey_difficulty: %s", table.tostring(get_default_difficulties), arg_28_4, find, table.tostring(DefaultDifficulties), get_persistent_stat_3)
		end

		self:set_stat(stats_id, "completed_hero_journey_difficulty", var_28_2, var_28_3, find)
	end
end

StatisticsUtil.unlock_lorebook_page = function (arg_29_0, arg_29_1)
	-- function 29
	local local_player = Managers.player:local_player()

	if not local_player then
		local stats_id = local_player:stats_id()

		print("unlock_lorebook_page", arg_29_0)
		arg_29_1:set_array_stat(stats_id, "lorebook_unlocks", arg_29_0, true)

		local var_29_2 = LorebookCategoryNames[arg_29_0]

		LoreBookHelper.mark_page_id_as_new(var_29_2)
	end
end

local function fn_3(arg_30_0, arg_30_1, arg_30_2)
	-- function 30
	assert(arg_30_2 == "waves" or arg_30_2 == "time" or arg_30_2 == "kills")

	return (string.format("survival_%s_%s_%s", arg_30_0, arg_30_1, arg_30_2))
end

StatisticsUtil.get_survival_stat = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	-- function 31
	local var_31_0 = fn_3(arg_31_1, arg_31_2, arg_31_3)
	local local_player = Managers.player:local_player()

	arg_31_4 = arg_31_4 or local_player:stats_id()

	return (self:get_persistent_stat(arg_31_4, var_31_0))
end

StatisticsUtil._set_survival_stat = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	-- function 32
	local var_32_0 = fn_3(arg_32_1, arg_32_2, arg_32_3)
	local stats_id = Managers.player:local_player():stats_id()

	self:set_stat(stats_id, var_32_0, arg_32_4)
end

StatisticsUtil.reset_mission_streak = function (self, arg_33_1, arg_33_2)
	-- function 33
	local profile_index = self:profile_index()
	local var_33_1 = SPProfiles[profile_index]
	local career_index = self:career_index()
	local name = var_33_1.careers[career_index].name
	local level_id = LevelHelper:current_level_settings().level_id

	if not arg_33_1:has_stat("mission_streak", name) then
		for i = 1, 3 do
			local str = "act_" .. i
			local var_33_6 = GameActs[str]
			local flag = false

			for j = 1, #var_33_6 do
				if arg_33_1:get_persistent_stat(arg_33_2, "mission_streak", name, var_33_6[j]) == 0 then
					flag = true

					break
				end
			end

			if not flag and not table.contains(var_33_6, level_id) then
				for k = 1, #var_33_6 do
					arg_33_1:set_stat(arg_33_2, "mission_streak", name, var_33_6[k], 0)
				end
			end
		end
	end
end

StatisticsUtil._modify_survival_stat = function (self, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	-- function 34
	local var_34_0 = fn_3(arg_34_1, arg_34_2, arg_34_3)
	local stats_id = Managers.player:local_player():stats_id()

	self:modify_stat_by_amount(stats_id, var_34_0, arg_34_4)
end

StatisticsUtil.register_complete_survival_level = function (self)
	-- function 35
	local get_missions, var_35_1 = Managers.state.entity:system("mission_system"):get_missions()
	local survival_wave = get_missions.survival_wave

	if not survival_wave then
		return
	end

	local stats_id = Managers.player:local_player():stats_id()
	local level_id = LevelHelper:current_level_settings().level_id
	local starting_wave = survival_wave.starting_wave
	local var_35_6 = SurvivalDifficultyByStartWave[starting_wave]
	local get_stat = self:get_stat(stats_id, "kills_total")

	StatisticsUtil._modify_survival_stat(self, level_id, var_35_6, "kills", get_stat)

	local wave_completed = survival_wave.wave_completed

	if wave_completed ~= 0 then
		local num = wave_completed - starting_wave
		local get_survival_stat = StatisticsUtil.get_survival_stat(self, level_id, var_35_6, "waves")

		if get_survival_stat < num then
			StatisticsUtil._set_survival_stat(self, level_id, var_35_6, "waves", num)
		end

		local num_2 = survival_wave.wave_completed_time - survival_wave.start_time
		local get_survival_stat_2 = StatisticsUtil.get_survival_stat(self, level_id, var_35_6, "time")

		if not (get_survival_stat < num or num ~= get_survival_stat or not (num_2 < get_survival_stat_2)) then
			StatisticsUtil._set_survival_stat(self, level_id, var_35_6, "time", num_2)
		end

		local var_35_13
		local difficulty = Managers.state.difficulty
		local get_default_difficulties = difficulty:get_default_difficulties()
		local find = table.find(get_default_difficulties, var_35_6)
		local var_35_17 = LevelDifficultyDBNames[level_id]

		if not (self:get_persistent_stat(stats_id, "completed_levels_difficulty", var_35_17) >= find - 1) then
			local get_difficulty = difficulty:get_difficulty()
			local find_2 = table.find(get_default_difficulties, get_difficulty)
			local flag = find_2 ~= #get_default_difficulties or not (num >= 13 * (find_2 - find + 1)) or not find_2 or find_2 - 1

			if flag > 0 then
				var_35_13 = get_default_difficulties[flag]
			end

			if not (not flag and not (flag < 3) or not (num >= 13)) then
				Crashify.print_exception("StatisticsUtil", "Error in survival mode data. completed_difficulty_index = %s, completed_waves = %s, started_on_unlocked_difficulty = true", flag, num)
			end
		else
			local var_35_21

			for i = #get_default_difficulties, 1, -1 do
				local var_35_22 = get_default_difficulties[i]

				if wave_completed >= SurvivalEndWaveByDifficulty[var_35_22] then
					var_35_21 = i
					var_35_13 = var_35_22

					break
				end
			end

			if not (not var_35_21 and not (var_35_21 < 3) or not (num >= 13)) then
				Crashify.print_exception("StatisticsUtil", "Error in survival mode data. completed_difficulty_index = %s, completed_waves = %s, started_on_unlocked_difficulty = false", var_35_21, num)
			end
		end

		if not var_35_13 then
			StatisticsUtil._register_completed_level_difficulty(self, level_id, var_35_13)
		end
	end
end

StatisticsUtil.register_disable = function (self, arg_36_1, arg_36_2)
	-- function 36
	if Managers.mechanism:current_mechanism_name() == "versus" then
		local stats_id = self:stats_id()

		arg_36_1:increment_stat(stats_id, "vs_disables_per_breed", arg_36_2)
	end
end
