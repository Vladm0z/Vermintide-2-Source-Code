-- chunkname: @scripts/managers/backend/statistics_util.lua

local var_0_0 = Unit.alive
local var_0_1 = Unit.get_data

StatisticsUtil = {}

local var_0_2 = StatisticsUtil
local var_0_3 = {
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

var_0_2.generate_weapon_kill_stats_dlc = function (arg_1_0, arg_1_1, arg_1_2)
	for iter_1_0, iter_1_1 in pairs(var_0_3) do
		if table.contains(iter_1_1, arg_1_1) then
			local var_1_0 = table.clone(arg_1_2)
			local var_1_1 = arg_1_1 .. "_kills_" .. iter_1_0

			var_1_0.database_name = var_1_1
			arg_1_0[var_1_1] = var_1_0
		end
	end
end

local function var_0_4(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_2.name
	local var_2_1 = var_0_3[var_2_0]

	if arg_2_2.rarity == "magic" then
		local var_2_2 = arg_2_2.required_unlock_item

		var_2_1 = var_0_3[var_2_2]
		var_2_0 = var_2_2
	end

	if var_2_1 then
		local var_2_3 = Managers.unlock

		for iter_2_0 = 1, #var_2_1 do
			local var_2_4 = var_2_1[iter_2_0]

			if var_2_3:is_dlc_unlocked(var_2_4) then
				arg_2_0:increment_stat(arg_2_1, var_2_4 .. "_kills_" .. var_2_0)
			end
		end
	end
end

DLCUtils.merge("_tracked_weapon_kill_stats", var_0_3)

local var_0_5 = {
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
local var_0_6 = {
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

var_0_2.generate_level_complete_with_weapon_stats_dlc = function (arg_3_0, arg_3_1, arg_3_2)
	for iter_3_0, iter_3_1 in pairs(var_0_5) do
		if table.contains(iter_3_1, arg_3_1) then
			for iter_3_2, iter_3_3 in pairs(var_0_6) do
				if table.contains(iter_3_3, arg_3_1) then
					local var_3_0 = table.clone(arg_3_2)
					local var_3_1 = arg_3_1 .. "_" .. iter_3_0 .. "_" .. iter_3_2

					var_3_0.database_name = var_3_1
					arg_3_0[var_3_1] = var_3_0
				end
			end
		end
	end
end

local function var_0_7(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = DifficultySettings[arg_4_4]

	if not var_4_0 then
		return
	end

	if arg_4_2 and var_0_5[arg_4_2] then
		local var_4_1 = arg_4_3 and var_0_6[arg_4_3]

		if var_4_1 then
			local var_4_2 = Managers.unlock

			for iter_4_0 = 1, #var_4_1 do
				local var_4_3 = var_4_1[iter_4_0]

				if var_4_2:is_dlc_unlocked(var_4_3) then
					local var_4_4 = var_4_3 .. "_" .. arg_4_2 .. "_" .. arg_4_3

					if arg_4_0:get_persistent_stat(arg_4_1, var_4_4) < var_4_0.rank then
						arg_4_0:set_stat(arg_4_1, var_4_4, var_4_0.rank)
					end
				end
			end
		end
	end
end

var_0_2.register_kill = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = ScriptUnit.has_extension(arg_5_0, "health_system")
	local var_5_1 = var_5_0.last_damage_data

	if not var_5_1 then
		return
	end

	local var_5_2 = Managers.player
	local var_5_3 = var_5_2:owner(arg_5_0)
	local var_5_4 = var_0_1(arg_5_0, "breed")
	local var_5_5 = var_5_4 and var_5_4.name
	local var_5_6 = var_5_1.breed
	local var_5_7 = var_5_1.attacker_side
	local var_5_8 = var_5_1.attacker_unique_id
	local var_5_9 = var_5_2:player_from_unique_id(var_5_8)
	local var_5_10 = Managers.state.side
	local var_5_11 = var_5_10.side_by_unit[arg_5_0]
	local var_5_12 = Managers.player:local_player()
	local var_5_13 = var_5_3 and var_5_0:was_attacked_by(var_5_12 and var_5_12:unique_id())

	if var_5_13 and var_5_3 ~= var_5_12 and var_5_10:is_enemy_by_side(var_5_7, var_5_11) then
		local var_5_14 = var_5_12:stats_id()
		local var_5_15 = var_5_13.attacker_breed.name

		arg_5_2:increment_stat(var_5_14, "eliminations_as_breed", var_5_15)
		Managers.state.event:trigger("add_player_kill_confirmation", var_5_7:name(), var_5_3)
	end

	if var_5_9 and var_5_9 ~= var_5_3 then
		local var_5_16 = var_5_9:stats_id()

		arg_5_2:increment_stat(var_5_16, "kills_total")

		if var_5_4 then
			Managers.state.achievement:trigger_event("register_kill", var_5_16, arg_5_0, arg_5_1, var_5_4)

			local var_5_17 = var_5_4.race

			if Breeds[var_5_5] or PlayerBreeds[var_5_5] and Managers.state.side:is_enemy_by_side(var_5_7, var_5_11) then
				local var_5_18 = Managers.state.difficulty:get_difficulty()

				arg_5_2:increment_stat(var_5_16, "kills_per_breed", var_5_5)
				arg_5_2:increment_stat(var_5_16, "kills_per_breed_difficulty", var_5_5, var_5_18)
			end

			arg_5_2:increment_stat(var_5_16, "kills_per_breed_persistent", var_5_5)

			if var_5_17 then
				arg_5_2:increment_stat(var_5_16, "kills_per_race", var_5_17)

				if var_5_17 == "critter" then
					local var_5_19 = Managers.player:human_players()

					for iter_5_0, iter_5_1 in pairs(var_5_19) do
						local var_5_20 = iter_5_1:stats_id()

						if var_5_20 then
							arg_5_2:increment_stat(var_5_20, "kills_critter_total")
						end
					end
				end
			end

			local var_5_21 = arg_5_1[DamageDataIndex.DAMAGE_SOURCE_NAME]
			local var_5_22 = rawget(ItemMasterList, var_5_21)

			if var_5_22 then
				local var_5_23 = var_5_22.slot_type
				local var_5_24 = arg_5_1[DamageDataIndex.ATTACK_TYPE]

				if var_5_24 then
					var_5_23 = (var_5_24 == "heavy_attack" or var_5_24 == "light_attack") and "melee" or "ranged"
				end

				if not var_5_23 then
					local var_5_25 = var_5_22.template

					if var_5_25 then
						local var_5_26 = WeaponUtils.get_weapon_template(var_5_25)
						local var_5_27 = var_5_26 and var_5_26.buff_type

						if MeleeBuffTypes[var_5_27] then
							var_5_23 = "melee"
						elseif RangedBuffTypes[var_5_27] then
							var_5_23 = "ranged"
						end
					end
				end

				if var_5_23 == "melee" then
					arg_5_2:increment_stat(var_5_16, "kills_melee")
				elseif var_5_23 == "ranged" then
					arg_5_2:increment_stat(var_5_16, "kills_ranged")
				end

				var_0_4(arg_5_2, var_5_16, var_5_22)
			end
		end
	end

	if var_5_4 and var_5_6 and var_5_4.awards_positive_reinforcement_message then
		local var_5_28 = Managers.state.game_mode:setting("positive_reinforcement_check")
		local var_5_29 = "killed_special"

		if not var_5_28 or var_5_28(var_5_29, var_5_6, var_5_4) then
			local var_5_30 = var_5_6.name
			local var_5_31 = false
			local var_5_32 = ""

			if var_5_9 then
				var_5_31 = var_5_9.local_player
				var_5_32 = var_5_9:stats_id()
			end

			local var_5_33 = var_5_32 .. (var_5_4.killfeed_fold_with or var_5_5)

			Managers.state.event:trigger("add_coop_feedback_kill", var_5_33, var_5_31, var_5_29, var_5_30, var_5_5, var_5_9, var_5_3)
		end
	end

	if var_5_4 and (var_5_4.elite or var_5_4.boss) then
		local var_5_34 = Managers.state.side.side_by_unit[arg_5_0]

		if var_5_7 and var_5_7 ~= var_5_34 then
			local var_5_35 = var_5_7.party.occupied_slots

			for iter_5_2, iter_5_3 in ipairs(var_5_35) do
				local var_5_36 = iter_5_3.player

				if var_5_36 ~= var_5_9 then
					local var_5_37 = var_5_36:stats_id()

					if arg_5_2:is_registered(var_5_37) then
						local var_5_38 = Managers.state.difficulty:get_difficulty()

						arg_5_2:increment_stat(var_5_37, "kill_assists_per_breed", var_5_5)
						arg_5_2:increment_stat(var_5_37, "kill_assists_per_breed_difficulty", var_5_5, var_5_38)
					end
				end
			end
		end
	end
end

var_0_2.register_knockdown = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = ScriptUnit.has_extension(arg_6_0, "health_system")
	local var_6_1 = var_6_0.last_damage_data

	if not var_6_1 then
		return
	end

	local var_6_2 = Managers.player
	local var_6_3 = var_6_2:owner(arg_6_0)
	local var_6_4 = var_0_1(arg_6_0, "breed")
	local var_6_5 = var_6_4 and var_6_4.name
	local var_6_6 = var_6_1.breed
	local var_6_7 = var_6_1.attacker_unique_id
	local var_6_8 = var_6_2:player_from_unique_id(var_6_7)
	local var_6_9 = Managers.player:local_player()

	if var_6_5 then
		if var_6_8 and var_6_8 ~= var_6_3 then
			local var_6_10 = var_6_8:stats_id()

			arg_6_2:increment_stat(var_6_10, "vs_knockdowns_per_breed", var_6_5)
		end

		local var_6_11 = var_6_0:was_attacked_by(var_6_9 and var_6_9:unique_id())

		if var_6_11 and var_6_3 ~= var_6_9 then
			local var_6_12 = var_6_11.attacker_breed.name
			local var_6_13 = var_6_9:stats_id()

			arg_6_2:increment_stat(var_6_13, "eliminations_as_breed", var_6_12)
			arg_6_2:increment_stat(var_6_13, "vs_knockdowns_per_breed", var_6_5)
			Managers.state.event:trigger("add_player_knock_confirmation", var_6_9, var_6_3)
		end
	end

	if var_6_4 and var_6_6 and var_6_4.awards_positive_reinforcement_message then
		local var_6_14 = var_6_6.name
		local var_6_15 = "player_knocked_down"
		local var_6_16 = false
		local var_6_17 = ""

		if var_6_8 then
			var_6_16 = var_6_8.local_player
			var_6_17 = var_6_8:stats_id()
		end

		Managers.state.event:trigger("add_coop_feedback_kill", var_6_17 .. var_6_5, var_6_16, var_6_15, var_6_14, var_6_5)

		if var_6_3 and var_6_8 then
			Managers.state.achievement:trigger_event("register_knockdown", var_6_17, arg_6_0, var_6_8, var_6_4)
		end
	end
end

var_0_2.check_save = function (arg_7_0, arg_7_1)
	local var_7_0 = BLACKBOARDS[arg_7_1].target_unit
	local var_7_1 = Managers.player

	if not arg_7_0 or not var_7_0 then
		return
	end

	local var_7_2 = var_7_1:is_player_unit(arg_7_0)
	local var_7_3 = var_7_1:is_player_unit(var_7_0)

	if not var_7_2 or not var_7_3 then
		return
	end

	local var_7_4 = var_7_1:owner(arg_7_0)
	local var_7_5 = var_7_1:owner(var_7_0)

	if var_7_4 == var_7_5 then
		return
	end

	local var_7_6
	local var_7_7 = Managers.state.network
	local var_7_8 = var_7_7:game()
	local var_7_9 = var_7_8 and var_7_7:unit_game_object_id(var_7_0)

	if var_7_9 then
		var_7_6 = Vector3.normalize(Vector3.flat(GameSession.game_object_field(var_7_8, var_7_9, "aim_direction")))
	else
		var_7_6 = Quaternion.forward(Unit.local_rotation(var_7_0, 0))
	end

	local var_7_10 = Quaternion.forward(Unit.local_rotation(arg_7_1, 0))
	local var_7_11 = POSITION_LOOKUP[var_7_0]
	local var_7_12 = POSITION_LOOKUP[arg_7_1]
	local var_7_13 = var_7_11 - var_7_12
	local var_7_14 = Vector3.distance(var_7_11, var_7_12) < 3 and Vector3.dot(var_7_13, var_7_6) > 0 and Vector3.dot(var_7_13, var_7_10) > 0
	local var_7_15 = ScriptUnit.extension(var_7_0, "status_system")
	local var_7_16 = var_7_15:get_pouncer_unit() or var_7_15:get_pack_master_grabber()
	local var_7_17 = var_7_15:is_disabled()
	local var_7_18
	local var_7_19 = var_7_1:statistics_db()
	local var_7_20 = var_7_4:stats_id()

	if arg_7_1 == var_7_16 then
		var_7_18 = "save"

		var_7_19:increment_stat(var_7_20, "saves")
	elseif var_7_14 or var_7_17 then
		var_7_18 = "aid"

		var_7_19:increment_stat(var_7_20, "aidings")
	end

	if var_7_18 then
		local var_7_21 = not var_7_4.remote and not var_7_4.bot_player

		Managers.state.event:trigger("add_coop_feedback", var_7_20 .. var_7_5:stats_id(), var_7_21, var_7_18, var_7_4, var_7_5)
		ScriptUnit.extension(var_7_0, "buff_system"):trigger_procs("on_assisted", arg_7_0, arg_7_1)
		ScriptUnit.extension(arg_7_0, "buff_system"):trigger_procs("on_assisted_ally", var_7_0, arg_7_1)

		local var_7_22 = Managers.state.network.network_transmit
		local var_7_23 = var_7_4:network_id()
		local var_7_24 = var_7_4:local_player_id()
		local var_7_25 = var_7_5:network_id()
		local var_7_26 = var_7_5:local_player_id()
		local var_7_27 = NetworkLookup.coop_feedback[var_7_18]
		local var_7_28 = var_7_7:unit_game_object_id(arg_7_1)

		var_7_22:send_rpc_clients("rpc_assist", var_7_23, var_7_24, var_7_25, var_7_26, var_7_27, var_7_28)
	end
end

var_0_2.register_pull_up = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = Managers.player
	local var_8_1 = var_8_0:owner(arg_8_0)
	local var_8_2 = var_8_0:owner(arg_8_1)

	if var_8_1 and var_8_2 then
		local var_8_3 = "assisted_respawn"
		local var_8_4 = not var_8_1.remote and not var_8_1.bot_player

		Managers.state.event:trigger("add_coop_feedback", var_8_1:stats_id() .. var_8_2:stats_id(), var_8_4, var_8_3, var_8_1, var_8_2)
	end
end

var_0_2.register_assisted_respawn = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = Managers.player
	local var_9_1 = var_9_0:owner(arg_9_0)
	local var_9_2 = var_9_0:owner(arg_9_1)

	if var_9_1 and var_9_2 then
		local var_9_3 = "assisted_respawn"
		local var_9_4 = not var_9_1.remote and not var_9_1.bot_player

		Managers.state.event:trigger("add_coop_feedback", var_9_1:stats_id() .. var_9_2:stats_id(), var_9_4, var_9_3, var_9_1, var_9_2)
	end
end

var_0_2.register_revive = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = Managers.player
	local var_10_1 = var_10_0:owner(arg_10_0)

	if var_10_1 then
		local var_10_2 = var_10_1:stats_id()

		arg_10_2:increment_stat(var_10_2, "revives")
	end

	local var_10_3 = var_10_0:owner(arg_10_1)

	if var_10_3 then
		local var_10_4 = var_10_3:stats_id()

		arg_10_2:increment_stat(var_10_4, "times_revived")
	end

	if var_10_1 and var_10_3 then
		local var_10_5 = "revive"
		local var_10_6 = not var_10_1.remote and not var_10_1.bot_player

		Managers.state.event:trigger("add_coop_feedback", var_10_1:stats_id() .. var_10_3:stats_id(), var_10_6, var_10_5, var_10_1, var_10_3)
		Managers.state.achievement:trigger_event("register_revive", arg_10_0, arg_10_1)
	end
end

var_0_2.register_heal = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = Managers.player
	local var_11_1 = var_11_0:owner(arg_11_0)
	local var_11_2 = var_11_0:owner(arg_11_1)

	if var_11_1 and var_11_2 and var_11_1 ~= var_11_2 then
		local var_11_3 = "heal"
		local var_11_4 = not var_11_1.remote and not var_11_1.bot_player

		Managers.state.event:trigger("add_coop_feedback", var_11_1:stats_id() .. var_11_2:stats_id(), var_11_4, var_11_3, var_11_1, var_11_2)

		local var_11_5 = var_11_1:stats_id()

		arg_11_2:increment_stat(var_11_5, "times_friend_healed")
	end
end

var_0_2.register_damage = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_1[DamageDataIndex.ATTACKER]
	local var_12_1 = arg_12_1[DamageDataIndex.DAMAGE_SOURCE_NAME]
	local var_12_2 = var_12_0
	local var_12_3 = Managers.player
	local var_12_4 = AiUtils.get_actual_attacker_player(var_12_2, arg_12_0, var_12_1)

	if var_12_4 then
		var_12_2 = var_12_4.player_unit
	else
		var_12_2 = arg_12_1[DamageDataIndex.SOURCE_ATTACKER_UNIT] or var_12_2
		var_12_2 = AiUtils.get_actual_attacker_unit(var_12_2)
		var_12_4 = var_12_3:owner(var_12_2)
	end

	local var_12_5 = var_0_0(arg_12_0) and var_0_1(arg_12_0, "breed")
	local var_12_6 = var_0_0(var_12_2) and var_0_1(var_12_2, "breed")
	local var_12_7 = AiUtils.get_actual_attacker_breed(var_12_6, arg_12_0, var_12_1, var_12_0, var_12_4)

	if var_12_6 and var_12_6 ~= var_12_7 then
		var_12_2 = nil

		if var_12_7 and not var_12_7.is_player then
			var_12_4 = nil
		end
	end

	local var_12_8 = var_12_7

	if var_12_4 and not arg_12_2:is_registered(var_12_4:stats_id()) then
		return
	end

	local var_12_9 = var_12_3:owner(arg_12_0)
	local var_12_10 = arg_12_1[DamageDataIndex.DAMAGE_AMOUNT]

	if var_12_9 then
		local var_12_11 = var_12_9:stats_id()

		arg_12_2:modify_stat_by_amount(var_12_11, "damage_taken", var_12_10)

		local var_12_12 = ScriptUnit.extension(arg_12_0, "health_system")
		local var_12_13 = var_12_12:current_health()
		local var_12_14 = var_12_12:get_max_health()
		local var_12_15 = (var_12_13 - var_12_10) / var_12_14
		local var_12_16 = ScriptUnit.extension(arg_12_0, "career_system")
		local var_12_17 = var_12_16:career_name()

		if var_12_16:get_breed().is_hero then
			Managers.state.achievement:trigger_event("register_damage_taken", arg_12_0, arg_12_1)

			if var_12_15 < arg_12_2:get_stat(var_12_11, "min_health_percentage", var_12_17) then
				arg_12_2:set_stat(var_12_11, "min_health_percentage", var_12_17, var_12_15)
			end
		end
	end

	if var_12_4 and var_12_5 then
		local var_12_18 = var_12_5.name
		local var_12_19 = ScriptUnit.extension(arg_12_0, "health_system"):current_health()

		if var_12_19 > 0 then
			local var_12_20 = Managers.state.side
			local var_12_21 = var_12_4:stats_id()

			Managers.state.achievement:trigger_event("register_damage", var_12_21, arg_12_0, arg_12_1, var_12_2, var_12_5)

			var_12_10 = math.clamp(var_12_10, 0, var_12_19)

			arg_12_2:modify_stat_by_amount(var_12_21, "damage_dealt", var_12_10)

			local var_12_22 = var_12_20:get_side_from_player_unique_id(var_12_4:unique_id())
			local var_12_23 = var_12_20.side_by_unit[arg_12_0]
			local var_12_24 = var_12_20:is_enemy_by_side(var_12_22, var_12_23)

			if Breeds[var_12_18] or PlayerBreeds[var_12_18] and var_12_24 then
				arg_12_2:modify_stat_by_amount(var_12_21, "damage_dealt_per_breed", var_12_18, var_12_10)
			end

			if arg_12_1[DamageDataIndex.HIT_ZONE] == "head" then
				arg_12_2:increment_stat(var_12_21, "headshots")
			end

			local var_12_25 = var_12_8 and var_12_8.name

			if var_12_24 then
				if Managers.mechanism:current_mechanism_name() == "versus" then
					if var_12_22:name() == "heroes" then
						arg_12_2:modify_stat_by_amount(var_12_21, "vs_damage_dealt_to_pactsworn", var_12_10)
					end

					if var_12_8 and var_12_22:name() == "dark_pact" then
						arg_12_2:modify_stat_by_amount(var_12_21, "state_damage_dealt_as_pactsworn_breed", var_12_25, var_12_10)
					end
				end

				if var_12_9 and var_12_22.show_damage_feedback and HEALTH_ALIVE[arg_12_0] then
					local var_12_26 = var_12_3:owner(arg_12_0)
					local var_12_27 = not var_12_4.remote and not var_12_4.bot_player
					local var_12_28 = var_12_27 and "dealing_damage" or "other_dealing_damage"
					local var_12_29 = arg_12_1[DamageDataIndex.DAMAGE_TYPE]

					Managers.state.event:trigger("add_damage_feedback_event", var_12_21 .. var_12_18, var_12_27, var_12_28, var_12_4, var_12_26, var_12_10, var_12_29)
				end
			end

			if var_12_25 then
				arg_12_2:modify_stat_by_amount(var_12_21, "damage_dealt_as_breed", var_12_25, var_12_10)
			end
		end
	end

	if var_12_1 == "skaven_ratling_gunner" and var_12_9 then
		local var_12_30 = var_12_9:stats_id()

		arg_12_2:modify_stat_by_amount(var_12_30, "damage_taken_from_ratling_gunner", var_12_10)
	end
end

var_0_2.won_games = function (arg_13_0)
	local var_13_0 = Managers.player:local_player():stats_id()
	local var_13_1 = 0

	for iter_13_0, iter_13_1 in ipairs(UnlockableLevels) do
		var_13_1 = var_13_1 + arg_13_0:get_persistent_stat(var_13_0, "completed_levels", iter_13_1)
	end

	return var_13_1
end

var_0_2.register_collected_grimoires = function (arg_14_0, arg_14_1)
	local var_14_0 = Managers.player:local_player():stats_id()

	for iter_14_0 = 1, arg_14_0 do
		arg_14_1:increment_stat(var_14_0, "total_collected_grimoires")
	end

	local var_14_1 = LevelHelper:current_level_settings().level_id

	if not table.find(UnlockableLevels, var_14_1) then
		return
	end

	if arg_14_0 > arg_14_1:get_persistent_stat(var_14_0, "collected_grimoires", var_14_1) then
		arg_14_1:set_stat(var_14_0, "collected_grimoires", var_14_1, arg_14_0)
	end
end

var_0_2.register_collected_tomes = function (arg_15_0, arg_15_1)
	local var_15_0 = Managers.player:local_player():stats_id()

	for iter_15_0 = 1, arg_15_0 do
		arg_15_1:increment_stat(var_15_0, "total_collected_tomes")
	end

	local var_15_1 = LevelHelper:current_level_settings().level_id

	if not table.find(UnlockableLevels, var_15_1) then
		return
	end

	if arg_15_0 > arg_15_1:get_persistent_stat(var_15_0, "collected_tomes", var_15_1) then
		arg_15_1:set_stat(var_15_0, "collected_tomes", var_15_1, arg_15_0)
	end
end

var_0_2.register_collected_dice = function (arg_16_0, arg_16_1)
	local var_16_0 = Managers.player:local_player():stats_id()

	for iter_16_0 = 1, arg_16_0 do
		arg_16_1:increment_stat(var_16_0, "total_collected_dice")
	end

	local var_16_1 = LevelHelper:current_level_settings().level_id

	if not table.find(UnlockableLevels, var_16_1) then
		return
	end

	if arg_16_0 > arg_16_1:get_persistent_stat(var_16_0, "collected_dice", var_16_1) then
		arg_16_1:set_stat(var_16_0, "collected_dice", var_16_1, arg_16_0)
	end
end

var_0_2.register_complete_level = function (arg_17_0)
	local var_17_0 = LevelHelper:current_level_settings().level_id

	if not table.find(UnlockableLevels, var_17_0) then
		return
	end

	local var_17_1 = Managers.state.game_mode:game_mode_key()
	local var_17_2 = Managers.player:local_player()
	local var_17_3 = var_17_2:stats_id()
	local var_17_4
	local var_17_5

	if var_17_1 == "versus" then
		local var_17_6 = Managers.party:get_status_from_unique_id(var_17_3).preferred_profile_index

		if not var_17_6 then
			return
		end

		var_17_4 = SPProfiles[var_17_6]
		var_17_5 = var_17_4.display_name
	else
		local var_17_7 = var_17_2:profile_index()

		var_17_4 = SPProfiles[var_17_7]
		var_17_5 = var_17_4.display_name
	end

	arg_17_0:increment_stat(var_17_3, "completed_levels_" .. var_17_5, var_17_0)

	local var_17_8 = Managers.state.entity:system("mission_system")
	local var_17_9 = var_17_8:get_level_end_mission_data("grimoire_hidden_mission")
	local var_17_10 = var_17_8:get_level_end_mission_data("tome_bonus_mission")
	local var_17_11 = var_17_8:get_level_end_mission_data("bonus_dice_hidden_mission")

	if var_17_9 then
		var_0_2.register_collected_grimoires(var_17_9.current_amount, arg_17_0)
	end

	if var_17_10 then
		var_0_2.register_collected_tomes(var_17_10.current_amount, arg_17_0)
	end

	if var_17_11 then
		var_0_2.register_collected_dice(var_17_11.current_amount, arg_17_0)
	end

	arg_17_0:increment_stat(var_17_3, "completed_levels", var_17_0)

	if Managers.deed and Managers.deed:has_deed() then
		arg_17_0:increment_stat(var_17_3, "completed_heroic_deeds")
	end

	local var_17_12 = Managers.state.difficulty:get_difficulty()
	local var_17_13 = var_17_2:career_index()
	local var_17_14 = var_17_4.careers[var_17_13].name

	var_0_2._register_completed_level_difficulty(arg_17_0, var_17_0, var_17_14, var_17_12)

	local var_17_15 = Managers.backend:get_interface("items")
	local var_17_16 = BackendUtils.get_loadout_item_id(var_17_14, "slot_melee")
	local var_17_17 = var_17_16 and var_17_15:get_item_name(var_17_16)
	local var_17_18 = BackendUtils.get_loadout_item_id(var_17_14, "slot_ranged")
	local var_17_19 = var_17_18 and var_17_15:get_item_name(var_17_18)

	var_0_7(arg_17_0, var_17_3, var_17_0, var_17_17, var_17_12)
	var_0_7(arg_17_0, var_17_3, var_17_0, var_17_19, var_17_12)

	if Managers.unlock:is_dlc_unlocked("holly") then
		local var_17_20 = DifficultySettings.hardest.rank <= (DifficultySettings[var_17_12] and DifficultySettings[var_17_12].rank or 0)
		local var_17_21 = var_17_0 == "ground_zero" or var_17_0 == "warcamp" or var_17_0 == "skaven_stronghold" or var_17_0 == "skittergate"

		if var_17_20 and var_17_21 then
			local var_17_22 = {
				"we_1h_axe",
				"bw_1h_crowbill",
				"wh_dual_wield_axe_falchion",
				"dr_dual_wield_hammers",
				"es_dual_wield_hammer_sword"
			}
			local var_17_23

			if table.contains(var_17_22, var_17_17) then
				var_17_23 = var_17_17
			elseif table.contains(var_17_22, var_17_19) then
				var_17_23 = var_17_19
			end

			if var_17_23 then
				local var_17_24 = "holly_completed_level_" .. var_17_0 .. "_with_" .. var_17_23

				arg_17_0:increment_stat(var_17_3, var_17_24)
			end
		end
	end
end

var_0_2.register_versus_game_won = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_1:stats_id()

	arg_18_0:increment_stat(var_18_0, arg_18_2 and "vs_game_won" or "vs_game_lost")
end

var_0_2.register_weave_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = arg_19_1:stats_id()
	local var_19_1 = Managers.weave
	local var_19_2 = var_19_1:get_weave_tier()
	local var_19_3 = var_19_1:get_active_weave()
	local var_19_4 = var_19_1:get_active_wind()
	local var_19_5 = var_19_1:get_score()
	local var_19_6 = var_19_1:get_num_players()
	local var_19_7 = arg_19_1:profile_index()
	local var_19_8 = SPProfiles[var_19_7]
	local var_19_9 = arg_19_1:career_index()
	local var_19_10 = var_19_8.careers[var_19_9].name
	local var_19_11 = arg_19_0:get_stat(var_19_0, "min_health_percentage", var_19_10)
	local var_19_12 = arg_19_0:get_persistent_stat(var_19_0, "min_health_completed", var_19_10)

	if var_19_12 and var_19_11 and var_19_12 <= var_19_11 then
		arg_19_0:set_stat(var_19_0, "min_health_completed", var_19_10, var_19_11)
	end

	if arg_19_2 then
		local var_19_13 = "weave_quickplay_wins"

		arg_19_0:increment_stat(var_19_0, ScorpionSeasonalSettings.current_season_name, var_19_13)
		arg_19_0:increment_stat(var_19_0, "scorpion_weaves_won")

		if ScorpionSeasonalSettings.current_season_id == 1 or not IS_WINDOWS then
			local var_19_14 = "weave_quickplay_" .. arg_19_3 .. "_wins"

			arg_19_0:increment_stat(var_19_0, "season_1", var_19_14)
		end
	else
		if ScorpionSeasonalSettings.current_season_id == 1 or not IS_WINDOWS then
			local var_19_15 = "weave_rainbow_" .. var_19_4 .. "_" .. var_19_10 .. "_season_1"

			arg_19_0:set_stat(var_19_0, "season_1", var_19_15, 1)

			local var_19_16 = "weaves_complete_" .. var_19_10 .. "_season_1"

			arg_19_0:increment_stat(var_19_0, "season_1", var_19_16)
			var_0_2._register_mutator_challenges(arg_19_0, var_19_0, var_19_4)
			arg_19_0:increment_stat(var_19_0, "season_1", "weave_won", var_19_2)
		end

		arg_19_0:increment_stat(var_19_0, "completed_weaves", var_19_3)
		arg_19_0:increment_stat(var_19_0, "scorpion_weaves_won")

		local var_19_17 = ScorpionSeasonalSettings.get_weave_score_stat(var_19_2, var_19_6)

		if var_19_5 > arg_19_0:get_persistent_stat(var_19_0, ScorpionSeasonalSettings.current_season_name, var_19_17) then
			arg_19_0:set_stat(var_19_0, ScorpionSeasonalSettings.current_season_name, var_19_17, var_19_5)
		end
	end
end

var_0_2._register_mutator_challenges = function (arg_20_0, arg_20_1, arg_20_2)
	if ScorpionSeasonalSettings.current_season_id == 1 or not IS_WINDOWS then
		if arg_20_2 == "life" then
			local var_20_0 = "weave_life_stepped_in_bush"

			if arg_20_0:get_persistent_stat(arg_20_1, "season_1", var_20_0) == 0 then
				local var_20_1 = "scorpion_weaves_life_season_1"

				arg_20_0:increment_stat(arg_20_1, "season_1", var_20_1)
			end
		elseif arg_20_2 == "death" then
			local var_20_2 = "weave_death_hit_by_spirit"

			if arg_20_0:get_persistent_stat(arg_20_1, "season_1", var_20_2) == 0 then
				local var_20_3 = "scorpion_weaves_death_season_1"

				arg_20_0:increment_stat(arg_20_1, "season_1", var_20_3)
			end
		elseif arg_20_2 == "beasts" then
			local var_20_4 = "weave_beasts_destroyed_totems"

			if arg_20_0:get_persistent_stat(arg_20_1, "season_1", var_20_4) == 0 then
				local var_20_5 = "scorpion_weaves_beasts_season_1"

				arg_20_0:increment_stat(arg_20_1, "season_1", var_20_5)
			end
		elseif arg_20_2 == "light" then
			local var_20_6 = "weave_light_low_curse"

			if arg_20_0:get_persistent_stat(arg_20_1, "season_1", var_20_6) == 0 then
				local var_20_7 = "scorpion_weaves_light_season_1"

				arg_20_0:increment_stat(arg_20_1, "season_1", var_20_7)
			end
		elseif arg_20_2 == "shadow" then
			local var_20_8 = "weave_shadow_kill_no_shrouded"

			if arg_20_0:get_persistent_stat(arg_20_1, "season_1", var_20_8) == 0 then
				local var_20_9 = "scorpion_weaves_shadow_season_1"

				arg_20_0:increment_stat(arg_20_1, "season_1", var_20_9)
			end
		end
	end
end

var_0_2.register_journey_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	var_0_2._register_completed_journey_difficulty(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
end

var_0_2.register_complete_tutorial = function (arg_22_0)
	local var_22_0 = LevelHelper:current_level_settings()
	local var_22_1 = Managers.player:local_player():stats_id()
	local var_22_2 = var_22_0.level_id

	arg_22_0:increment_stat(var_22_1, "completed_levels", var_22_2)
end

var_0_2.register_played_quickplay_level = function (arg_23_0, arg_23_1, arg_23_2)
	if not table.find(UnlockableLevels, arg_23_2) then
		return
	end

	arg_23_0:increment_stat(arg_23_1:stats_id(), "played_levels_quickplay", arg_23_2)
	var_0_2.register_last_played_level_id(arg_23_0, arg_23_1, arg_23_2)
end

var_0_2.register_played_weekly_event_level = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	if not table.find(UnlockableLevels, arg_24_2) then
		return
	end

	local var_24_0 = arg_24_1:stats_id()

	arg_24_0:increment_stat(var_24_0, "played_levels_weekly_event", arg_24_2)

	local var_24_1 = Managers.state.difficulty:get_difficulty()

	arg_24_0:increment_stat(var_24_0, "completed_weekly_event_difficulty", var_24_1)
end

var_0_2.register_last_played_level_id = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = table.find(UnlockableLevels, arg_25_2)

	if var_25_0 then
		arg_25_0:set_stat(arg_25_1:stats_id(), "last_played_level_id", var_25_0)
	end
end

var_0_2.get_game_progress = function (arg_26_0)
	local var_26_0 = Managers.player:local_player():stats_id()
	local var_26_1 = #MainGameLevels * 5
	local var_26_2 = 0
	local var_26_3
	local var_26_4

	for iter_26_0, iter_26_1 in pairs(MainGameLevels) do
		local var_26_5 = LevelDifficultyDBNames[iter_26_1]
		local var_26_6 = arg_26_0:get_persistent_stat(var_26_0, "completed_levels_difficulty", var_26_5)

		print("Completed Level Difficulty", var_26_5, var_26_6, iter_26_1)

		var_26_2 = var_26_2 + var_26_6
	end

	return var_26_2 / var_26_1 * 100
end

var_0_2._register_completed_level_difficulty = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = Managers.player:local_player()
	local var_27_1 = var_27_0:stats_id()
	local var_27_2 = LevelDifficultyDBNames[arg_27_1]
	local var_27_3 = arg_27_0:get_persistent_stat(var_27_1, "completed_levels_difficulty", var_27_2)
	local var_27_4 = Managers.state.difficulty:get_default_difficulties()
	local var_27_5 = table.find(var_27_4, arg_27_3)

	if var_27_5 then
		Managers.state.achievement:trigger_event("register_completed_level", arg_27_3, arg_27_1, arg_27_2, var_27_0)

		if var_27_3 < var_27_5 then
			arg_27_0:set_stat(var_27_1, "completed_levels_difficulty", var_27_2, var_27_5)
		end

		if arg_27_0:has_stat("mission_streak", arg_27_2) and var_27_5 > arg_27_0:get_persistent_stat(var_27_1, "mission_streak", arg_27_2, arg_27_1) then
			arg_27_0:set_stat(var_27_1, "mission_streak", arg_27_2, arg_27_1, var_27_5)
		end
	end

	arg_27_0:increment_stat(var_27_1, "completed_career_levels", arg_27_2, arg_27_1, arg_27_3)

	local var_27_6 = arg_27_0:get_stat(var_27_1, "min_health_percentage", arg_27_2)
	local var_27_7 = arg_27_0:get_persistent_stat(var_27_1, "min_health_completed", arg_27_2)

	if var_27_7 and var_27_6 and var_27_7 < var_27_6 then
		arg_27_0:set_stat(var_27_1, "min_health_completed", arg_27_2, var_27_6)
	end

	arg_27_0:increment_stat(var_27_1, "played_difficulty", arg_27_3)
end

var_0_2._register_completed_journey_difficulty = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = arg_28_1:stats_id()
	local var_28_1 = arg_28_1:profile_index()
	local var_28_2 = SPProfilesAbbreviation[var_28_1]
	local var_28_3 = JourneyDifficultyDBNames[arg_28_2]
	local var_28_4 = JourneyDominantGodDifficultyDBNames[arg_28_3]
	local var_28_5 = arg_28_0:get_persistent_stat(var_28_0, "completed_journeys_difficulty", var_28_3)
	local var_28_6 = arg_28_0:get_persistent_stat(var_28_0, "completed_journey_dominant_god_difficulty", var_28_4)
	local var_28_7 = arg_28_0:get_persistent_stat(var_28_0, "completed_hero_journey_difficulty", var_28_2, var_28_3)
	local var_28_8 = Managers.state.difficulty:get_default_difficulties()
	local var_28_9 = table.find(var_28_8, arg_28_4)

	if var_28_5 < var_28_9 then
		if var_28_9 > #DefaultDifficulties then
			ferror("This shouldn't happen. \ndifficulties: %s\ndifficulty_name: %s\ndifficulty_index: %s\nDefaultDifficulties: %s\ncurrent_completed_difficulty: %s", table.tostring(var_28_8), arg_28_4, var_28_9, table.tostring(DefaultDifficulties), var_28_5)
		end

		arg_28_0:set_stat(var_28_0, "completed_journeys_difficulty", var_28_3, var_28_9)
	end

	if var_28_6 < var_28_9 then
		if var_28_9 > #DefaultDifficulties then
			ferror("This shouldn't happen. \ndifficulties: %s\ndifficulty_name: %s\ndifficulty_index: %s\nDefaultDifficulties: %s\ncurrent_completed_journey_dominant_god_difficulty: %s", table.tostring(var_28_8), arg_28_4, var_28_9, table.tostring(DefaultDifficulties), var_28_6)
		end

		arg_28_0:set_stat(var_28_0, "completed_journey_dominant_god_difficulty", var_28_4, var_28_9)
	end

	if var_28_7 < var_28_9 then
		if var_28_9 > #DefaultDifficulties then
			ferror("This shouldn't happen. \ndifficulties: %s\ndifficulty_name: %s\ndifficulty_index: %s\nDefaultDifficulties: %s\ncurrent_completed_hero_journey_difficulty: %s", table.tostring(var_28_8), arg_28_4, var_28_9, table.tostring(DefaultDifficulties), var_28_7)
		end

		arg_28_0:set_stat(var_28_0, "completed_hero_journey_difficulty", var_28_2, var_28_3, var_28_9)
	end
end

var_0_2.unlock_lorebook_page = function (arg_29_0, arg_29_1)
	local var_29_0 = Managers.player:local_player()

	if var_29_0 then
		local var_29_1 = var_29_0:stats_id()

		print("unlock_lorebook_page", arg_29_0)
		arg_29_1:set_array_stat(var_29_1, "lorebook_unlocks", arg_29_0, true)

		local var_29_2 = LorebookCategoryNames[arg_29_0]

		LoreBookHelper.mark_page_id_as_new(var_29_2)
	end
end

local function var_0_8(arg_30_0, arg_30_1, arg_30_2)
	assert(arg_30_2 == "waves" or arg_30_2 == "time" or arg_30_2 == "kills")

	return (string.format("survival_%s_%s_%s", arg_30_0, arg_30_1, arg_30_2))
end

var_0_2.get_survival_stat = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	local var_31_0 = var_0_8(arg_31_1, arg_31_2, arg_31_3)
	local var_31_1 = Managers.player:local_player()

	arg_31_4 = arg_31_4 or var_31_1:stats_id()

	return (arg_31_0:get_persistent_stat(arg_31_4, var_31_0))
end

var_0_2._set_survival_stat = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	local var_32_0 = var_0_8(arg_32_1, arg_32_2, arg_32_3)
	local var_32_1 = Managers.player:local_player():stats_id()

	arg_32_0:set_stat(var_32_1, var_32_0, arg_32_4)
end

var_0_2.reset_mission_streak = function (arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0:profile_index()
	local var_33_1 = SPProfiles[var_33_0]
	local var_33_2 = arg_33_0:career_index()
	local var_33_3 = var_33_1.careers[var_33_2].name
	local var_33_4 = LevelHelper:current_level_settings().level_id

	if arg_33_1:has_stat("mission_streak", var_33_3) then
		for iter_33_0 = 1, 3 do
			local var_33_5 = "act_" .. iter_33_0
			local var_33_6 = GameActs[var_33_5]
			local var_33_7 = false

			for iter_33_1 = 1, #var_33_6 do
				if arg_33_1:get_persistent_stat(arg_33_2, "mission_streak", var_33_3, var_33_6[iter_33_1]) == 0 then
					var_33_7 = true

					break
				end
			end

			if var_33_7 and table.contains(var_33_6, var_33_4) then
				for iter_33_2 = 1, #var_33_6 do
					arg_33_1:set_stat(arg_33_2, "mission_streak", var_33_3, var_33_6[iter_33_2], 0)
				end
			end
		end
	end
end

var_0_2._modify_survival_stat = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	local var_34_0 = var_0_8(arg_34_1, arg_34_2, arg_34_3)
	local var_34_1 = Managers.player:local_player():stats_id()

	arg_34_0:modify_stat_by_amount(var_34_1, var_34_0, arg_34_4)
end

var_0_2.register_complete_survival_level = function (arg_35_0)
	local var_35_0, var_35_1 = Managers.state.entity:system("mission_system"):get_missions()
	local var_35_2 = var_35_0.survival_wave

	if not var_35_2 then
		return
	end

	local var_35_3 = Managers.player:local_player():stats_id()
	local var_35_4 = LevelHelper:current_level_settings().level_id
	local var_35_5 = var_35_2.starting_wave
	local var_35_6 = SurvivalDifficultyByStartWave[var_35_5]
	local var_35_7 = arg_35_0:get_stat(var_35_3, "kills_total")

	var_0_2._modify_survival_stat(arg_35_0, var_35_4, var_35_6, "kills", var_35_7)

	local var_35_8 = var_35_2.wave_completed

	if var_35_8 ~= 0 then
		local var_35_9 = var_35_8 - var_35_5
		local var_35_10 = var_0_2.get_survival_stat(arg_35_0, var_35_4, var_35_6, "waves")

		if var_35_10 < var_35_9 then
			var_0_2._set_survival_stat(arg_35_0, var_35_4, var_35_6, "waves", var_35_9)
		end

		local var_35_11 = var_35_2.wave_completed_time - var_35_2.start_time
		local var_35_12 = var_0_2.get_survival_stat(arg_35_0, var_35_4, var_35_6, "time")

		if var_35_10 < var_35_9 or var_35_9 == var_35_10 and var_35_11 < var_35_12 then
			var_0_2._set_survival_stat(arg_35_0, var_35_4, var_35_6, "time", var_35_11)
		end

		local var_35_13
		local var_35_14 = Managers.state.difficulty
		local var_35_15 = var_35_14:get_default_difficulties()
		local var_35_16 = table.find(var_35_15, var_35_6)
		local var_35_17 = LevelDifficultyDBNames[var_35_4]

		if arg_35_0:get_persistent_stat(var_35_3, "completed_levels_difficulty", var_35_17) >= var_35_16 - 1 then
			local var_35_18 = var_35_14:get_difficulty()
			local var_35_19 = table.find(var_35_15, var_35_18)
			local var_35_20 = var_35_19 == #var_35_15 and var_35_9 >= 13 * (var_35_19 - var_35_16 + 1) and var_35_19 or var_35_19 - 1

			if var_35_20 > 0 then
				var_35_13 = var_35_15[var_35_20]
			end

			if var_35_20 and var_35_20 < 3 and var_35_9 >= 13 then
				Crashify.print_exception("StatisticsUtil", "Error in survival mode data. completed_difficulty_index = %s, completed_waves = %s, started_on_unlocked_difficulty = true", var_35_20, var_35_9)
			end
		else
			local var_35_21

			for iter_35_0 = #var_35_15, 1, -1 do
				local var_35_22 = var_35_15[iter_35_0]

				if var_35_8 >= SurvivalEndWaveByDifficulty[var_35_22] then
					var_35_21 = iter_35_0
					var_35_13 = var_35_22

					break
				end
			end

			if var_35_21 and var_35_21 < 3 and var_35_9 >= 13 then
				Crashify.print_exception("StatisticsUtil", "Error in survival mode data. completed_difficulty_index = %s, completed_waves = %s, started_on_unlocked_difficulty = false", var_35_21, var_35_9)
			end
		end

		if var_35_13 then
			var_0_2._register_completed_level_difficulty(arg_35_0, var_35_4, var_35_13)
		end
	end
end

var_0_2.register_disable = function (arg_36_0, arg_36_1, arg_36_2)
	if Managers.mechanism:current_mechanism_name() == "versus" then
		local var_36_0 = arg_36_0:stats_id()

		arg_36_1:increment_stat(var_36_0, "vs_disables_per_breed", arg_36_2)
	end
end
