-- chunkname: @scripts/unit_extensions/generic/hit_reactions.lua

HitReactions = {}

local DamageDataIndex = DamageDataIndex
local tbl = {
	temporary_health_degen = true,
	kinetic = true,
	buff_shared_medpack = true,
	buff = true,
	buff_shared_medpack_temp_health = true,
	push = true,
	health_degen = true,
	life_tap = true,
	curse_empathy = true,
	wounded_dot = true,
	heal = true,
	knockdown_bleed = true,
	life_drain = true
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local player = Managers.player

	if arg_1_0 == arg_1_1 or not player:is_player_unit(arg_1_1) then
		local player_profile = ScriptUnit.extension(arg_1_0, "dialogue_system").context.player_profile
		local player_profile_2 = ScriptUnit.extension(arg_1_1, "dialogue_system").context.player_profile
		local extension_input = ScriptUnit.extension_input(arg_1_0, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		alloc_table.target = player_profile
		alloc_table.player_profile = player_profile_2

		extension_input:trigger_dialogue_event("friendly_fire", alloc_table)
	end
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local player = Managers.player
	local unit_owner = player:unit_owner(arg_2_1)

	if not (not player:is_player_unit(arg_2_1) and unit_owner.remote and arg_2_1 == arg_2_0 and not Unit.alive(arg_2_0) and ScriptUnit.extension(arg_2_1, "buff_system"):has_buff_perk("potion_armor_penetration") ~= false and not (arg_2_2 < 0.5)) then
		local get_data = Unit.get_data(arg_2_0, "breed")

		if not (not get_data and get_data.armor_category ~= 2 or arg_2_3[4] == "head" or arg_2_3[4] == "neck") then
			SurroundingAwareSystem.add_event(arg_2_1, "armor_hit", DialogueSettings.armor_hit_broadcast_range, "profile_name", ScriptUnit.extension(arg_2_1, "dialogue_system").context.player_profile)
		end
	end
end

local tbl_2 = {
	bleed = true,
	burninating = true,
	arrow_poison_dot = true
}

HitReactions.templates = {
	ai_default = {
		unit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
			-- function 3
			local var_3_0 = arg_3_4[DamageDataIndex.ATTACKER]
			local var_3_1 = arg_3_4[DamageDataIndex.DAMAGE_TYPE]
			local var_3_2 = arg_3_4[DamageDataIndex.DAMAGE_AMOUNT]
			local flag = arg_3_0 ~= var_3_0

			if var_3_1 == "push" or not flag then
				ScriptUnit.extension(arg_3_0, "ai_system"):attacked(var_3_0, arg_3_3, arg_3_4)
				fn_2(arg_3_0, var_3_0, var_3_2, arg_3_4)
			end

			Managers.state.game_mode:ai_hit_by_player(arg_3_0, var_3_0, arg_3_4)
		end,
		husk = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
			-- function 4
			local var_4_0 = arg_4_4[DamageDataIndex.ATTACKER]

			Managers.state.game_mode:ai_hit_by_player(arg_4_0, var_4_0, arg_4_4)
		end
	},
	player = {
		unit = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			-- function 5
			local var_5_0 = arg_5_4[DamageDataIndex.DAMAGE_TYPE]

			if not tbl[var_5_0] then
				local extension = ScriptUnit.extension(arg_5_0, "first_person_system")

				if not (not (arg_5_4[DamageDataIndex.DAMAGE_AMOUNT] > 0) or Development.parameter("screen_space_player_camera_reactions") == false) then
					extension:animation_event("shake_get_hit")
				end

				local var_5_2 = arg_5_4[DamageDataIndex.ATTACKER]

				if not tbl_2[var_5_0] then
					fn(arg_5_0, var_5_2)
				end
			end
		end,
		husk = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
			-- function 6
			local var_6_0 = arg_6_4[DamageDataIndex.ATTACKER]
			local var_6_1 = arg_6_4[DamageDataIndex.DAMAGE_TYPE]

			if not (tbl[var_6_1] or tbl_2[var_6_1]) then
				fn(arg_6_0, var_6_0)
			end
		end
	},
	level_object = {
		unit = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
			-- function 7
			local current_health = ScriptUnit.extension(arg_7_0, "health_system"):current_health()

			Unit.set_flow_variable(arg_7_0, "current_health", current_health)
			Unit.flow_event(arg_7_0, "lua_on_damage_taken")
		end,
		husk = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
			-- function 8
			local current_health = ScriptUnit.extension(arg_8_0, "health_system"):current_health()

			Unit.set_flow_variable(arg_8_0, "current_health", current_health)
			Unit.flow_event(arg_8_0, "lua_on_damage_taken")
		end
	},
	dummy = {
		unit = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
			-- function 9
			local var_9_0 = arg_9_4[2]
			local flag = false

			if not var_9_0 then
				flag = tbl_2[var_9_0]
			end

			if not flag then
				local current_health = ScriptUnit.extension(arg_9_0, "health_system"):current_health()

				Unit.set_flow_variable(arg_9_0, "current_health", current_health)
				Unit.flow_event(arg_9_0, "lua_on_damage_taken")
			end
		end,
		husk = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
			-- function 10
			local var_10_0 = arg_10_4[2]
			local flag = false

			if not var_10_0 then
				flag = tbl_2[var_10_0]
			end

			if not flag then
				local current_health = ScriptUnit.extension(arg_10_0, "health_system"):current_health()

				Unit.set_flow_variable(arg_10_0, "current_health", current_health)
				Unit.flow_event(arg_10_0, "lua_on_damage_taken")
			end
		end
	},
	ai_ethereal_skull_knock_back = {
		unit = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
			-- function 11
			local var_11_0 = arg_11_4[DamageDataIndex.ATTACKER]

			if not Managers.player:is_player_unit(var_11_0) then
				return
			end

			local var_11_1 = arg_11_4[DamageDataIndex.DAMAGE_TYPE]
			local var_11_2 = arg_11_4[DamageDataIndex.DAMAGE_AMOUNT]
			local var_11_3 = arg_11_4[DamageDataIndex.DIRECTION]
			local var_11_4 = arg_11_4[DamageDataIndex.POSITION]
			local flag = arg_11_0 ~= var_11_0

			if var_11_1 == "push" or not flag then
				ScriptUnit.extension(arg_11_0, "ai_system"):attacked(var_11_0, arg_11_3, arg_11_4)
				fn_2(arg_11_0, var_11_0, var_11_2, arg_11_4)
			end

			local extension = ScriptUnit.extension(arg_11_0, "projectile_locomotion_system")

			if not (not extension and arg_11_4[2] == "bleed" or arg_11_4[7] == "dot_debuff") then
				extension:set_knockback(var_11_0, var_11_3, var_11_4, arg_11_3)
			end

			Managers.state.game_mode:ai_hit_by_player(arg_11_0, var_11_0, arg_11_4)
		end,
		husk = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
			-- function 12
			local var_12_0 = arg_12_4[DamageDataIndex.ATTACKER]

			if not Managers.player:is_player_unit(var_12_0) then
				return
			end

			Managers.state.game_mode:ai_hit_by_player(arg_12_0, var_12_0, arg_12_4)
		end
	},
	chaos_bulwark = {
		unit = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
			-- function 13
			HitReactions.templates.ai_default.unit(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)

			if not (not (arg_13_4[DamageDataIndex.HIT_ZONE] == "weakspot") and ScriptUnit.extension(arg_13_0, "ai_shield_system").is_blocking) then
				Unit.flow_event(arg_13_0, "lua_on_weakspot_hit")
			end
		end,
		husk = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
			-- function 14
			HitReactions.templates.ai_default.husk(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)

			if not (not (arg_14_4[DamageDataIndex.HIT_ZONE] == "weakspot") and ScriptUnit.extension(arg_14_0, "ai_shield_system"):get_is_blocking()) then
				Unit.flow_event(arg_14_0, "lua_on_weakspot_hit")
			end
		end
	}
}

HitReactions.get_reaction = function (arg_15_0, arg_15_1)
	-- function 15
	local var_15_0 = HitReactions.templates[arg_15_0]

	if not (not arg_15_1 and var_15_0.husk == nil) then
		return var_15_0.husk
	end

	return var_15_0.unit
end
