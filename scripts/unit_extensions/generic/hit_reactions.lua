-- chunkname: @scripts/unit_extensions/generic/hit_reactions.lua

HitReactions = {}

local var_0_0 = DamageDataIndex
local var_0_1 = {
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

local function var_0_2(arg_1_0, arg_1_1)
	local var_1_0 = Managers.player

	if arg_1_0 ~= arg_1_1 and var_1_0:is_player_unit(arg_1_1) then
		local var_1_1 = ScriptUnit.extension(arg_1_0, "dialogue_system").context.player_profile
		local var_1_2 = ScriptUnit.extension(arg_1_1, "dialogue_system").context.player_profile
		local var_1_3 = ScriptUnit.extension_input(arg_1_0, "dialogue_system")
		local var_1_4 = FrameTable.alloc_table()

		var_1_4.target = var_1_1
		var_1_4.player_profile = var_1_2

		var_1_3:trigger_dialogue_event("friendly_fire", var_1_4)
	end
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = Managers.player
	local var_2_1 = var_2_0:unit_owner(arg_2_1)

	if var_2_0:is_player_unit(arg_2_1) and not var_2_1.remote and arg_2_1 ~= arg_2_0 and Unit.alive(arg_2_0) and ScriptUnit.extension(arg_2_1, "buff_system"):has_buff_perk("potion_armor_penetration") == false and arg_2_2 < 0.5 then
		local var_2_2 = Unit.get_data(arg_2_0, "breed")

		if var_2_2 and var_2_2.armor_category == 2 and arg_2_3[4] ~= "head" and arg_2_3[4] ~= "neck" then
			SurroundingAwareSystem.add_event(arg_2_1, "armor_hit", DialogueSettings.armor_hit_broadcast_range, "profile_name", ScriptUnit.extension(arg_2_1, "dialogue_system").context.player_profile)
		end
	end
end

local var_0_4 = {
	bleed = true,
	burninating = true,
	arrow_poison_dot = true
}

HitReactions.templates = {
	ai_default = {
		unit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
			local var_3_0 = arg_3_4[var_0_0.ATTACKER]
			local var_3_1 = arg_3_4[var_0_0.DAMAGE_TYPE]
			local var_3_2 = arg_3_4[var_0_0.DAMAGE_AMOUNT]
			local var_3_3 = arg_3_0 ~= var_3_0

			if var_3_1 ~= "push" and var_3_3 then
				ScriptUnit.extension(arg_3_0, "ai_system"):attacked(var_3_0, arg_3_3, arg_3_4)
				var_0_3(arg_3_0, var_3_0, var_3_2, arg_3_4)
			end

			Managers.state.game_mode:ai_hit_by_player(arg_3_0, var_3_0, arg_3_4)
		end,
		husk = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
			local var_4_0 = arg_4_4[var_0_0.ATTACKER]

			Managers.state.game_mode:ai_hit_by_player(arg_4_0, var_4_0, arg_4_4)
		end
	},
	player = {
		unit = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			local var_5_0 = arg_5_4[var_0_0.DAMAGE_TYPE]

			if not var_0_1[var_5_0] then
				local var_5_1 = ScriptUnit.extension(arg_5_0, "first_person_system")

				if arg_5_4[var_0_0.DAMAGE_AMOUNT] > 0 and Development.parameter("screen_space_player_camera_reactions") ~= false then
					var_5_1:animation_event("shake_get_hit")
				end

				local var_5_2 = arg_5_4[var_0_0.ATTACKER]

				if not var_0_4[var_5_0] then
					var_0_2(arg_5_0, var_5_2)
				end
			end
		end,
		husk = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
			local var_6_0 = arg_6_4[var_0_0.ATTACKER]
			local var_6_1 = arg_6_4[var_0_0.DAMAGE_TYPE]

			if not var_0_1[var_6_1] and not var_0_4[var_6_1] then
				var_0_2(arg_6_0, var_6_0)
			end
		end
	},
	level_object = {
		unit = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
			local var_7_0 = ScriptUnit.extension(arg_7_0, "health_system"):current_health()

			Unit.set_flow_variable(arg_7_0, "current_health", var_7_0)
			Unit.flow_event(arg_7_0, "lua_on_damage_taken")
		end,
		husk = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
			local var_8_0 = ScriptUnit.extension(arg_8_0, "health_system"):current_health()

			Unit.set_flow_variable(arg_8_0, "current_health", var_8_0)
			Unit.flow_event(arg_8_0, "lua_on_damage_taken")
		end
	},
	dummy = {
		unit = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
			local var_9_0 = arg_9_4[2]
			local var_9_1 = false

			if var_9_0 then
				var_9_1 = var_0_4[var_9_0]
			end

			if not var_9_1 then
				local var_9_2 = ScriptUnit.extension(arg_9_0, "health_system"):current_health()

				Unit.set_flow_variable(arg_9_0, "current_health", var_9_2)
				Unit.flow_event(arg_9_0, "lua_on_damage_taken")
			end
		end,
		husk = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
			local var_10_0 = arg_10_4[2]
			local var_10_1 = false

			if var_10_0 then
				var_10_1 = var_0_4[var_10_0]
			end

			if not var_10_1 then
				local var_10_2 = ScriptUnit.extension(arg_10_0, "health_system"):current_health()

				Unit.set_flow_variable(arg_10_0, "current_health", var_10_2)
				Unit.flow_event(arg_10_0, "lua_on_damage_taken")
			end
		end
	},
	ai_ethereal_skull_knock_back = {
		unit = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
			local var_11_0 = arg_11_4[var_0_0.ATTACKER]

			if not Managers.player:is_player_unit(var_11_0) then
				return
			end

			local var_11_1 = arg_11_4[var_0_0.DAMAGE_TYPE]
			local var_11_2 = arg_11_4[var_0_0.DAMAGE_AMOUNT]
			local var_11_3 = arg_11_4[var_0_0.DIRECTION]
			local var_11_4 = arg_11_4[var_0_0.POSITION]
			local var_11_5 = arg_11_0 ~= var_11_0

			if var_11_1 ~= "push" and var_11_5 then
				ScriptUnit.extension(arg_11_0, "ai_system"):attacked(var_11_0, arg_11_3, arg_11_4)
				var_0_3(arg_11_0, var_11_0, var_11_2, arg_11_4)
			end

			local var_11_6 = ScriptUnit.extension(arg_11_0, "projectile_locomotion_system")

			if var_11_6 and arg_11_4[2] ~= "bleed" and arg_11_4[7] ~= "dot_debuff" then
				var_11_6:set_knockback(var_11_0, var_11_3, var_11_4, arg_11_3)
			end

			Managers.state.game_mode:ai_hit_by_player(arg_11_0, var_11_0, arg_11_4)
		end,
		husk = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
			local var_12_0 = arg_12_4[var_0_0.ATTACKER]

			if not Managers.player:is_player_unit(var_12_0) then
				return
			end

			Managers.state.game_mode:ai_hit_by_player(arg_12_0, var_12_0, arg_12_4)
		end
	},
	chaos_bulwark = {
		unit = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
			HitReactions.templates.ai_default.unit(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)

			if arg_13_4[var_0_0.HIT_ZONE] == "weakspot" and not ScriptUnit.extension(arg_13_0, "ai_shield_system").is_blocking then
				Unit.flow_event(arg_13_0, "lua_on_weakspot_hit")
			end
		end,
		husk = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
			HitReactions.templates.ai_default.husk(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)

			if arg_14_4[var_0_0.HIT_ZONE] == "weakspot" and not ScriptUnit.extension(arg_14_0, "ai_shield_system"):get_is_blocking() then
				Unit.flow_event(arg_14_0, "lua_on_weakspot_hit")
			end
		end
	}
}

HitReactions.get_reaction = function (arg_15_0, arg_15_1)
	local var_15_0 = HitReactions.templates[arg_15_0]

	if arg_15_1 and var_15_0.husk ~= nil then
		return var_15_0.husk
	end

	return var_15_0.unit
end
