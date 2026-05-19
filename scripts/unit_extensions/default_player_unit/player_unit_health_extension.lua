-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_health_extension.lua

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

PlayerUnitHealthExtension = class(PlayerUnitHealthExtension, GenericHealthExtension)

function PlayerUnitHealthExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	PlayerUnitHealthExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	local var_1_0 = arg_1_3.player
	local var_1_1 = var_1_0.local_player
	local var_1_2 = not var_1_0:is_player_controlled()

	arg_1_0.player = var_1_0
	arg_1_0.is_bot = var_1_2
	arg_1_0.is_local_player = var_1_1
	arg_1_0.network_manager = Managers.state.network
	arg_1_0.game = arg_1_0.network_manager:game()
	arg_1_0.unit_storage = arg_1_1.unit_storage
	arg_1_0._profile_index = arg_1_3.profile_index
	arg_1_0._career_index = arg_1_3.career_index
	arg_1_0._shield_amount = 0
	arg_1_0._shield_duration_left = 0
	arg_1_0._end_reason = ""
	arg_1_0.wounded_degen_timer = 0
	arg_1_0._is_husk = var_1_0.remote or var_1_0.bot_player

	arg_1_0:update_options()

	if arg_1_0.is_server and not var_1_1 and not var_1_2 then
		arg_1_0:create_health_game_object()
	end

	arg_1_0._display_data = {}
	arg_1_0._streak_debug_duration = -10
	arg_1_0._streak_debug_damage = 0

	Managers.state.event:register(arg_1_0, "on_game_options_changed", "update_options")
end

function PlayerUnitHealthExtension.update_options(arg_2_0)
	local var_2_0 = Managers.state.game_mode:settings()

	arg_2_0._use_floating_damage_numbers = var_2_0.use_floating_damage_numbers and not DEDICATED_SERVER

	local var_2_1 = Application.user_setting("vs_floating_damage")

	arg_2_0._show_floating_damage = var_2_1 == "floating" or var_2_1 == "both"
	arg_2_0._show_floating_streak_damage = var_2_1 == "streak" or var_2_1 == "both"
	arg_2_0._min_streak_font_size = var_2_0.min_streak_font_size or 30
	arg_2_0._max_streak_font_size = var_2_0.max_streak_font_size or 60

	local var_2_2 = Managers.state.difficulty:get_difficulty_settings()

	arg_2_0._temp_hp_degen_delay_when_wounded = var_2_2.no_wound_dependent_temp_hp_degen
	arg_2_0._percent_health_on_revive = var_2_2.percent_health_on_revive or 0
	arg_2_0._percent_temp_health_on_revive = var_2_2.percent_temp_health_on_revive or 0.5
end

function PlayerUnitHealthExtension.hot_join_sync(arg_3_0, arg_3_1)
	return
end

function PlayerUnitHealthExtension.cb_game_session_disconnect(arg_4_0)
	arg_4_0.health_game_object_id = nil
end

function PlayerUnitHealthExtension.set_health_game_object_id(arg_5_0, arg_5_1)
	arg_5_0.health_game_object_id = arg_5_1
end

function PlayerUnitHealthExtension.create_health_game_object(arg_6_0)
	fassert(arg_6_0.is_server, "Trying to create health game object on a client")

	local var_6_0 = arg_6_0.unit
	local var_6_1 = Managers.state.difficulty:get_difficulty_settings()
	local var_6_2 = arg_6_0:_get_base_max_health()
	local var_6_3 = arg_6_0.network_manager:unit_game_object_id(var_6_0)
	local var_6_4 = var_6_1.wounds
	local var_6_5, var_6_6, var_6_7 = Managers.mechanism:mechanism_try_call("get_setting", "wounds_amount")

	if var_6_5 and var_6_7 then
		var_6_4 = var_6_6 + 1
	end

	local var_6_8 = {
		current_temporary_health = 0,
		go_type = NetworkLookup.go_types.player_unit_health,
		unit_game_object_id = var_6_3,
		current_health = var_6_2,
		max_health = var_6_2,
		uncursed_max_health = var_6_2,
		current_wounds = var_6_4,
		max_wounds = var_6_4
	}
	local var_6_9 = callback(arg_6_0, "cb_game_session_disconnect")

	arg_6_0.health_game_object_id = arg_6_0.network_manager:create_game_object("player_unit_health", var_6_8, var_6_9)
	arg_6_0.previous_max_health = var_6_2
	arg_6_0.previous_state = arg_6_0.state
end

function PlayerUnitHealthExtension.sync_health_state(arg_7_0)
	local var_7_0 = arg_7_0.player
	local var_7_1 = Managers.party:get_player_status(var_7_0:network_id(), var_7_0:local_player_id()).game_mode_data
	local var_7_2 = var_7_1.health_state
	local var_7_3 = var_7_1.health_percentage
	local var_7_4 = var_7_1.temporary_health_percentage
	local var_7_5 = var_7_1.ammo.slot_melee
	local var_7_6 = var_7_1.ammo.slot_ranged

	if script_data.network_debug then
		printf("PlayerUnitHealthExtension:sync_health_state() health_state (%s) health_percentage (%s) temporary_health_percentage (%s) melee slot ammo (%s) ranged slot ammo (%s)", var_7_2, tostring(var_7_3), tostring(var_7_4), tostring(var_7_5), tostring(var_7_6))
	end

	if var_7_2 == nil then
		print("[PlayerUnitHealthExtension] Spawn manager returned nil value for spawn state, killing character. player:", var_7_0)
		table.dump(var_7_0)
	else
		arg_7_0.set_health_percentage = var_7_3
		arg_7_0.set_temporary_health_percentage = var_7_4

		if var_7_2 == "knocked_down" then
			arg_7_0.set_knocked_down = true
		end
	end
end

function PlayerUnitHealthExtension._get_base_max_health(arg_8_0)
	local var_8_0 = arg_8_0._profile_index
	local var_8_1 = arg_8_0._career_index
	local var_8_2 = SPProfiles[var_8_0].careers[var_8_1]
	local var_8_3 = var_8_2.attributes.max_hp
	local var_8_4 = var_8_2.name .. "_hp"
	local var_8_5, var_8_6, var_8_7 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", var_8_4)

	if var_8_5 and var_8_7 and var_8_6 then
		return var_8_6
	end

	return var_8_3
end

function PlayerUnitHealthExtension._calculate_buffed_max_health(arg_9_0)
	local var_9_0 = arg_9_0.buff_extension
	local var_9_1 = arg_9_0.state
	local var_9_2

	if var_9_1 == "alive" then
		local var_9_3 = arg_9_0:_get_base_max_health()

		var_9_2 = var_9_0:apply_buffs_to_value(var_9_3, "max_health_alive")
	else
		local var_9_4 = Managers.state.game_mode:settings().max_health_kd

		var_9_2 = var_9_0:apply_buffs_to_value(var_9_4, "max_health_kd")
	end

	return (var_9_0:apply_buffs_to_value(var_9_2, "max_health"))
end

function PlayerUnitHealthExtension.get_buffed_max_health(arg_10_0)
	return (arg_10_0:_calculate_buffed_max_health())
end

function PlayerUnitHealthExtension._calculate_max_health(arg_11_0)
	local var_11_0 = arg_11_0.buff_extension
	local var_11_1 = arg_11_0.state
	local var_11_2 = 1
	local var_11_3 = var_11_0:num_buff_perk("skaven_grimoire")
	local var_11_4 = var_11_0:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
	local var_11_5 = var_11_0:num_buff_perk("twitch_grimoire")
	local var_11_6 = var_11_0:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
	local var_11_7 = var_11_0:num_buff_perk("slayer_curse")
	local var_11_8 = var_11_0:apply_buffs_to_value(PlayerUnitDamageSettings.SLAYER_CURSE_HEALTH_DEBUFF, "curse_protection")
	local var_11_9 = Managers.state.difficulty:get_difficulty()
	local var_11_10 = var_11_0:num_buff_perk("mutator_curse")
	local var_11_11 = var_11_0:apply_buffs_to_value(WindSettings.light.curse_settings.value[var_11_9], "curse_protection")
	local var_11_12 = var_11_0:apply_buffs_to_value(0, "health_curse")
	local var_11_13 = var_11_0:apply_buffs_to_value(var_11_12, "curse_protection")

	if var_11_1 == "knocked_down" then
		var_11_7 = 0
		var_11_13 = 0
	end

	if var_11_3 + var_11_5 + var_11_7 + var_11_10 + -var_11_13 > 0 then
		var_11_2 = 1 + var_11_3 * var_11_4 + var_11_5 * var_11_6 + var_11_7 * var_11_8 + var_11_10 * var_11_11 + var_11_13
	end

	return arg_11_0:_calculate_buffed_max_health() * math.max(var_11_2, 0.01)
end

function PlayerUnitHealthExtension.extensions_ready(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0._world = arg_12_1
	arg_12_0.status_extension = ScriptUnit.extension(arg_12_2, "status_system")
	arg_12_0.buff_extension = ScriptUnit.extension(arg_12_2, "buff_system")

	if not DEDICATED_SERVER then
		arg_12_0._outline_extension = ScriptUnit.extension(arg_12_2, "outline_system")
	end

	if arg_12_0.is_server and not arg_12_0.is_bot then
		arg_12_0:sync_health_state()
	end
end

function PlayerUnitHealthExtension.knock_down(arg_13_0, arg_13_1)
	assert(arg_13_0.is_server, "[PlayerUnitHealthExtension] 'knock_down' is a server only function")

	arg_13_0.state = "knocked_down"

	StatusUtils.set_knocked_down_network(arg_13_1, true)
	StatusUtils.set_wounded_network(arg_13_1, false, "knocked_down")

	local var_13_0 = arg_13_0:recent_damages()
	local var_13_1 = var_13_0[DamageDataIndex.SOURCE_ATTACKER_UNIT] or var_13_0[DamageDataIndex.ATTACKER]
	local var_13_2 = Managers.player:owner(var_13_1)

	if var_13_2 and Managers.mechanism:current_mechanism_name() == "versus" then
		local var_13_3 = var_13_2:stats_id()
		local var_13_4 = Managers.player:statistics_db()

		Managers.state.entity:system("versus_horde_ability_system"):server_ability_recharge_boost(var_13_2.peer_id, "hero_downed")

		local var_13_5 = Unit.get_data(arg_13_1, "breed")

		var_13_4:increment_stat(var_13_3, "vs_badge_knocked_down_target_per_breed", var_13_5.name)

		local var_13_6 = Managers.state.side
		local var_13_7 = var_13_6:versus_is_dark_pact(var_13_1)
		local var_13_8 = var_13_6:versus_is_hero(arg_13_1)

		if var_13_7 and var_13_8 then
			local var_13_9 = ScriptUnit.extension_input(var_13_1, "dialogue_system")
			local var_13_10 = var_13_6.side_by_unit[arg_13_1]
			local var_13_11 = 0
			local var_13_12 = var_13_10.PLAYER_AND_BOT_UNITS

			for iter_13_0 = 1, #var_13_12 do
				local var_13_13 = ScriptUnit.has_extension(var_13_12[iter_13_0], "status_system")

				if var_13_13 and var_13_13:is_knocked_down() then
					var_13_11 = var_13_11 + 1
				end
			end

			if var_13_11 >= DialogueSettings.vs_many_heroes_incapacitated_num then
				var_13_9:trigger_dialogue_event("vs_many_heroes_incapacitated")
			else
				var_13_9:trigger_dialogue_event("vs_downed_hero")
			end
		end
	end
end

function PlayerUnitHealthExtension._revive(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.state = "alive"

	StatusUtils.set_knocked_down_network(arg_14_1, false)
	StatusUtils.set_wounded_network(arg_14_1, true, "revived", arg_14_2)
	StatusUtils.set_revived_network(arg_14_1, false)
end

function PlayerUnitHealthExtension.update(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_0.status_extension
	local var_15_1 = arg_15_0.unit

	if arg_15_0._shield_duration_left > 0 then
		arg_15_0._shield_duration_left = arg_15_0._shield_duration_left - arg_15_1
	elseif not arg_15_0._end_reason then
		arg_15_0:remove_assist_shield("timed_out")
	end

	if arg_15_0.is_server then
		if arg_15_0.set_knocked_down then
			if not var_15_0:is_knocked_down() then
				arg_15_0:knock_down(var_15_1)
			end

			arg_15_0.set_knocked_down = false
		elseif arg_15_0.state == "alive" then
			if not arg_15_0:_is_alive() and not var_15_0:is_knocked_down() then
				arg_15_0:knock_down(var_15_1)
			end
		elseif arg_15_0.state == "knocked_down" and arg_15_0:_is_alive() and var_15_0:is_revived() then
			arg_15_0:_revive(var_15_1, arg_15_3)
		end

		local var_15_2 = arg_15_0.game
		local var_15_3 = arg_15_0.health_game_object_id

		if var_15_2 or var_15_3 then
			local var_15_4 = arg_15_0:_calculate_max_health()
			local var_15_5 = DamageUtils.networkify_health(var_15_4)
			local var_15_6 = arg_15_0:_calculate_buffed_max_health()
			local var_15_7 = DamageUtils.networkify_health(var_15_6)

			GameSession.set_game_object_field(var_15_2, var_15_3, "max_health", var_15_5)
			GameSession.set_game_object_field(var_15_2, var_15_3, "uncursed_max_health", var_15_7)

			local var_15_8 = arg_15_0.state
			local var_15_9 = arg_15_0.previous_state
			local var_15_10 = arg_15_0.previous_max_health
			local var_15_11 = GameSession.game_object_field(var_15_2, var_15_3, "current_health")
			local var_15_12 = GameSession.game_object_field(var_15_2, var_15_3, "current_temporary_health")

			if var_15_9 and var_15_8 ~= var_15_9 then
				if var_15_8 == "knocked_down" then
					var_15_11 = 0
					var_15_12 = var_15_5
				elseif var_15_8 == "alive" then
					local var_15_13 = arg_15_0.buff_extension
					local var_15_14 = var_15_13 and var_15_13:has_buff_perk("temp_to_permanent_health")

					var_15_11 = arg_15_0._percent_health_on_revive * var_15_5
					var_15_12 = arg_15_0._percent_temp_health_on_revive * var_15_5

					if var_15_14 then
						var_15_11 = var_15_11 + var_15_12
						var_15_12 = 0
					end

					if var_15_13:has_buff_perk(var_0_0.full_health_revive) then
						var_15_11 = var_15_5
						var_15_12 = 0
					end
				end
			elseif var_15_5 ~= var_15_10 then
				local var_15_15
				local var_15_16
				local var_15_17

				if var_15_10 == 0 then
					var_15_15 = 0
					var_15_17 = 0
				else
					var_15_15 = var_15_11 / var_15_10
					var_15_17 = var_15_12 / var_15_10
				end

				var_15_11 = var_15_5 * var_15_15
				var_15_12 = var_15_5 * var_15_17
			end

			local var_15_18 = arg_15_0.set_health_percentage

			if var_15_18 then
				var_15_11 = var_15_5 * var_15_18
				arg_15_0.set_health_percentage = nil
			end

			local var_15_19 = arg_15_0.set_temporary_health_percentage

			if var_15_19 then
				var_15_12 = var_15_5 * var_15_19
				arg_15_0.set_temporary_health_percentage = nil
			end

			local var_15_20 = DamageUtils.networkify_health(var_15_11)
			local var_15_21 = DamageUtils.networkify_health(var_15_12)

			GameSession.set_game_object_field(var_15_2, var_15_3, "current_health", var_15_20)
			GameSession.set_game_object_field(var_15_2, var_15_3, "current_temporary_health", var_15_21)

			if arg_15_3 >= arg_15_0.wounded_degen_timer then
				local var_15_22 = var_15_0:is_wounded()
				local var_15_23 = PlayerUnitStatusSettings.WOUNDED_DEGEN_AMOUNT
				local var_15_24 = PlayerUnitStatusSettings.WOUNDED_DEGEN_DELAY

				if not var_15_22 then
					var_15_23, var_15_24 = arg_15_0:health_degen_settings()
				end

				if var_15_21 > 0 and var_15_8 == "alive" then
					if Managers.mechanism:current_mechanism_name() == "versus" then
						local var_15_25 = {
							degen_delay = 0.8,
							degen_amount = 1.5
						}

						var_15_23 = PlayerUnitStatusSettings.WOUNDED_DEGEN_AMOUNT * var_15_25.degen_amount
						var_15_24 = PlayerUnitStatusSettings.WOUNDED_DEGEN_DELAY * var_15_25.degen_delay
					end

					local var_15_26 = var_15_21 - var_15_23
					local var_15_27 = var_15_20 <= 0 and 1 or 0
					local var_15_28 = var_15_21 - math.max(var_15_26, var_15_27)

					if var_15_28 > 0 then
						DamageUtils.add_damage_network(var_15_1, var_15_1, var_15_28, "torso", "temporary_health_degen", nil, Vector3(1, 0, 0), "temporary_health_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
					end
				end

				arg_15_0.wounded_degen_timer = arg_15_3 + var_15_24
			end

			arg_15_0.previous_state = var_15_8
			arg_15_0.previous_max_health = var_15_5

			if var_15_5 <= 0 then
				Managers.state.entity:system("death_system"):forced_kill(var_15_1, "forced")
			end
		end
	end
end

function PlayerUnitHealthExtension._update_outline_color(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = Managers.player:local_player()

	if not var_16_0 then
		return
	end

	local var_16_1 = var_16_0:network_id()
	local var_16_2 = var_16_0:local_player_id()
	local var_16_3
	local var_16_4 = arg_16_0._outline_extension
	local var_16_5 = arg_16_0.status_extension:is_disabled()
	local var_16_6 = arg_16_0:current_health_percent()
	local var_16_7 = Managers.party:get_party_from_player_id(var_16_1, var_16_2)

	if not var_16_7 then
		return
	end

	local var_16_8 = Managers.state.side.side_by_party[var_16_7]:name() == "dark_pact"
	local var_16_9 = Managers.state.side.side_by_unit[arg_16_0.unit]
	local var_16_10 = var_16_9:name() == "heroes"

	if not var_16_8 or not var_16_9 or not var_16_10 then
		var_16_3 = nil
	elseif var_16_5 then
		var_16_3 = OutlineSettingsVS.colors.hero_dying
	elseif var_16_6 >= 0.66 then
		var_16_3 = OutlineSettingsVS.colors.hero_healthy
	elseif var_16_6 >= 0.33 then
		var_16_3 = OutlineSettingsVS.colors.hero_hurt
	else
		var_16_3 = OutlineSettingsVS.colors.hero_dying
	end

	if not var_16_3 then
		if arg_16_0._outline_id then
			var_16_4:remove_outline(arg_16_0._outline_id)

			arg_16_0._outline_id = nil
		end
	elseif not arg_16_0._outline_id then
		arg_16_0._outline_id = var_16_4:add_outline({
			priority = 2,
			method = "always",
			outline_color = var_16_3,
			flag = OutlineSettings.flags.non_wall_occluded
		})
	elseif arg_16_0._current_outline_color ~= var_16_3 then
		var_16_4:update_outline({
			outline_color = var_16_3
		}, arg_16_0._outline_id)
	end

	arg_16_0._current_outline_color = var_16_3
end

local var_0_1 = {
	death_explosion = true
}

function PlayerUnitHealthExtension.apply_client_predicted_damage(arg_17_0, arg_17_1)
	return
end

local var_0_2 = true
local var_0_3 = 2.2

function PlayerUnitHealthExtension.create_streak_damage(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = math.auto_lerp(0, 30, arg_18_0._min_streak_font_size, arg_18_0._max_streak_font_size, arg_18_1)
	local var_18_1 = var_0_3
	local var_18_2 = DamageUtils.get_color_from_damage(arg_18_1)
	local var_18_3 = arg_18_2.z_onscreen_damage_offset
	local var_18_4 = Vector3(var_18_2[2], var_18_2[3], var_18_2[4])
	local var_18_5 = math.floor(arg_18_1)
	local var_18_6 = arg_18_1 % 1 * 100
	local var_18_7 = arg_18_0._display_data

	var_18_7.floating_speed = 0
	var_18_7.ref = true
	var_18_7.using_bucket_damage = var_0_2
	var_18_7.damage = arg_18_1
	var_18_7.variant_name = "streak_damage"

	local var_18_8 = false
	local var_18_9

	if var_0_2 and var_18_5 >= 1 then
		var_18_9 = string.format("{#size(%s)}%s", var_18_0, var_18_5)
	else
		var_18_9 = string.format("{#size(%s)}%s{#size(%s)}%s", var_18_0, var_18_5, math.floor(var_18_0 / 2), var_18_6)
	end

	Managers.state.event:trigger("add_damage_number", var_18_9, var_18_0, arg_18_0.unit, var_18_1, var_18_4, var_18_8, var_18_3, var_18_7)

	if type(var_18_7.ref) == "table" then
		arg_18_0._streak_ref = var_18_7.ref
	end
end

function PlayerUnitHealthExtension.add_damage(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13, arg_19_14, arg_19_15, arg_19_16, arg_19_17)
	if DamageUtils.is_in_inn then
		return
	end

	local var_19_0 = arg_19_0.status_extension

	if var_19_0:is_ready_for_assisted_respawn() then
		return
	end

	local var_19_1 = arg_19_0.unit
	local var_19_2 = AiUtils.get_actual_attacker_player(arg_19_1, var_19_1, arg_19_7)

	if not arg_19_9 then
		if var_19_2 and ALIVE[var_19_2.player_unit] then
			arg_19_9 = var_19_2.player_unit
		end

		arg_19_9 = AiUtils.get_actual_attacker_unit(arg_19_9 or arg_19_1)

		if not arg_19_9 then
			local var_19_3 = arg_19_0.last_damage_data.attacker_unit_id

			arg_19_9 = var_19_3 and Managers.state.unit_storage:unit(var_19_3)
		end
	end

	local var_19_4 = BLACKBOARDS[arg_19_9]
	local var_19_5 = ALIVE[arg_19_9] and Unit.get_data(arg_19_9, "breed") or var_19_4 and var_19_4.breed or ALIVE[arg_19_1] and Unit.get_data(arg_19_1, "breed")
	local var_19_6 = AiUtils.get_actual_attacker_breed(var_19_5, var_19_1, arg_19_7, arg_19_1, var_19_2)

	if var_19_2 then
		local var_19_7 = var_19_2:unique_id()

		if var_19_7 ~= Managers.player:owner(var_19_1):unique_id() then
			local var_19_8 = Managers.time:time("game")

			arg_19_0:_register_attacker(var_19_7, var_19_6, var_19_8)
		end
	end

	if var_19_6 then
		if arg_19_0._use_floating_damage_numbers then
			local var_19_9 = Application.user_setting("hud_damage_feedback_in_world")

			if var_19_2 and var_19_2.local_player and var_19_6.is_player and not var_19_6.is_hero and var_19_9 then
				local var_19_10 = arg_19_0._streak_damage or 0
				local var_19_11 = arg_19_0._streak_damage_time or 0
				local var_19_12 = Managers.time:time("game")

				if var_19_12 - var_19_11 > 1 and arg_19_2 > 0 then
					var_19_10 = arg_19_2

					if arg_19_0._show_floating_streak_damage then
						arg_19_0:create_streak_damage(var_19_10, var_19_6)
					end
				else
					var_19_10 = var_19_10 + arg_19_2

					if arg_19_0._streak_ref then
						local var_19_13 = math.floor(var_19_10)
						local var_19_14 = math.auto_lerp(0, 30, arg_19_0._min_streak_font_size, arg_19_0._max_streak_font_size, var_19_10)
						local var_19_15 = DamageUtils.get_color_from_damage(var_19_10)
						local var_19_16

						if var_0_2 and var_19_10 >= 1 then
							local var_19_17 = string.format("{#size(%s)}%s", var_19_14, var_19_13)

							Managers.state.event:trigger("alter_damage_number", var_19_1, arg_19_0._streak_ref, {
								text = var_19_17,
								time = var_0_3,
								color = var_19_15,
								damage = var_19_10
							})
						else
							local var_19_18 = var_19_10 % 1 * 100
							local var_19_19 = string.format("{#size(%s)}%s{#size(%s)}%s", var_19_14, var_19_13, math.floor(var_19_14 / 2), var_19_18)

							Managers.state.event:trigger("alter_damage_number", var_19_1, arg_19_0._streak_ref, {
								text = var_19_19,
								time = var_0_3,
								color = var_19_15,
								damage = var_19_10
							})
						end
					end
				end

				arg_19_0._streak_damage_time = var_19_12
				arg_19_0._streak_damage = var_19_10

				if arg_19_0._show_floating_damage then
					DamageUtils.add_unit_floating_damage_numbers(var_19_1, arg_19_4, arg_19_2, arg_19_11, var_19_10, var_19_6.z_onscreen_damage_offset, var_19_6.damage_numbers_font_override, {
						variant_name = "floating_damage",
						using_streak_damage = arg_19_0._show_floating_streak_damage
					})
				end
			end
		end

		local var_19_20 = Managers.state.entity:system("ai_system"):get_attributes(arg_19_1)

		if var_19_6.boss or var_19_20.grudge_marked then
			local var_19_21 = Managers.player:owner(arg_19_0.unit)
			local var_19_22 = var_19_21 and var_19_21.local_player and not var_19_21.bot_player

			if var_19_21 and var_19_2 and var_19_21 ~= var_19_2 and var_19_22 then
				Managers.state.event:trigger("boss_health_bar_register_unit", arg_19_1, "damage_taken")
			end

			QuestSettings.handle_bastard_block(arg_19_0.unit, arg_19_1, false)
		end
	end

	if arg_19_7 == "ground_impact" and not var_19_6.is_hero then
		return
	end

	fassert(arg_19_4, "No damage_type!")

	local var_19_23 = arg_19_0:_add_to_damage_history_buffer(var_19_1, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_13, arg_19_14, arg_19_15, nil, arg_19_17)

	if arg_19_4 ~= "temporary_health_degen" and arg_19_4 ~= "knockdown_bleed" then
		StatisticsUtil.register_damage(var_19_1, var_19_23, arg_19_0.statistics_db)
	end

	arg_19_0:save_kill_feed_data(arg_19_1, var_19_23, arg_19_3, arg_19_4, arg_19_7, arg_19_9)

	arg_19_0._recent_damage_type = arg_19_4
	arg_19_0._recent_hit_react_type = arg_19_10

	local var_19_24 = Managers.state.controller_features

	if var_19_24 and arg_19_0.player.local_player and arg_19_2 > 0 and arg_19_4 ~= "temporary_health_degen" then
		var_19_24:add_effect("hit_rumble", {
			damage_amount = arg_19_2,
			unit = var_19_1
		})
	end

	if Script.type_name(arg_19_2) == "number" and arg_19_2 > 0 and arg_19_4 ~= "temporary_health_degen" and arg_19_7 ~= "temporary_health_degen" then
		local var_19_25 = Managers.player:owner(var_19_1)
		local var_19_26 = POSITION_LOOKUP[var_19_1]

		Managers.telemetry_events:player_damaged(var_19_25, arg_19_4, arg_19_7 or "n/a", arg_19_2, var_19_26)

		if not DEDICATED_SERVER and var_19_2 then
			local var_19_27 = Managers.player:local_player()

			if var_19_2:unique_id() == var_19_27:unique_id() then
				local var_19_28 = POSITION_LOOKUP[arg_19_1]
				local var_19_29 = Unit.get_data(var_19_1, "breed")

				Managers.telemetry_events:local_player_damaged_player(var_19_2, var_19_29.name, arg_19_2, var_19_28, var_19_26)
			end
		end
	end

	local var_19_30 = ScriptUnit.extension(var_19_1, "buff_system")

	if arg_19_2 > 0 and arg_19_7 ~= "temporary_health_degen" then
		var_19_30:trigger_procs("on_damage_taken", arg_19_1, arg_19_2, arg_19_4)
	end

	local var_19_31 = var_19_30:has_buff_perk("ignore_death") and 1 or 0

	if arg_19_7 ~= "dot_debuff" and arg_19_4 ~= "temporary_health_degen" and arg_19_4 ~= "overcharge" then
		local var_19_32 = Managers.state.side:is_enemy(arg_19_9, var_19_1)
		local var_19_33 = var_19_32 and DamageUtils.is_player_unit(arg_19_9)

		if var_19_33 then
			EffectHelper.vs_play_hit_sound(arg_19_0._world, var_19_1, arg_19_15, arg_19_4, arg_19_7)
		end

		local var_19_34 = ScriptUnit.has_extension(arg_19_1, "ai_inventory_system")

		if var_19_34 then
			var_19_34:play_hit_sound(var_19_1, arg_19_4)
		elseif not arg_19_0._is_husk then
			if var_19_33 then
				local var_19_35 = SPProfiles[arg_19_0._profile_index]

				if HEALTH_ALIVE[var_19_1] then
					local var_19_36 = Managers.state.camera

					if var_19_35.role == "boss" then
						var_19_36:camera_effect_shake_event("damaged_boss", Managers.time:time("game"), 2)
					elseif var_19_35.role ~= "boss" then
						var_19_36:camera_effect_shake_event("damaged", Managers.time:time("game"), 2)
					end
				end
			end

			if var_19_32 then
				EffectHelper.play_local_damage_taken_sound(arg_19_0._world, var_19_1, arg_19_7)
			end
		end

		if arg_19_0.player.local_player and (var_19_30:has_buff_type("bardin_ironbreaker_activated_ability") or var_19_30:has_buff_type("bardin_ironbreaker_activated_ability_taunt_range_and_duration")) then
			ScriptUnit.extension(var_19_1, "first_person_system"):play_hud_sound_event("Play_career_ability_bardin_ironbreaker_hit")
		end
	elseif arg_19_7 == "dot_debuff" then
		local var_19_37 = Managers.state.side:is_enemy(arg_19_9, var_19_1)

		if var_19_37 and DamageUtils.is_player_unit(arg_19_9) then
			EffectHelper.vs_play_hit_sound(arg_19_0._world, var_19_1, arg_19_15, arg_19_4, arg_19_7)

			if not arg_19_0._is_husk then
				local var_19_38 = SPProfiles[arg_19_0._profile_index]

				if HEALTH_ALIVE[var_19_1] then
					local var_19_39 = Managers.state.camera

					if var_19_38.role == "boss" then
						var_19_39:camera_effect_shake_event("damaged_boss", Managers.time:time("game"), 2)
					elseif var_19_38.role ~= "boss" then
						var_19_39:camera_effect_shake_event("damaged", Managers.time:time("game"), 2)
					end
				end
			end
		end

		if var_19_37 and not arg_19_0._is_husk then
			EffectHelper.play_local_damage_taken_sound(arg_19_0._world, var_19_1, arg_19_7)
		end
	end

	DamageUtils.handle_hit_indication(arg_19_1, var_19_1, arg_19_2, arg_19_3, arg_19_12)

	local var_19_40 = Managers.weave

	if var_19_40:get_active_weave() and arg_19_0.is_server and arg_19_2 > 0 then
		var_19_40:player_damaged(arg_19_2)
	end

	if arg_19_0.is_server and not arg_19_0:get_is_invincible() and not script_data.player_invincible then
		local var_19_41 = arg_19_0.game
		local var_19_42 = arg_19_0.health_game_object_id

		if var_19_41 and var_19_42 then
			local var_19_43 = var_0_1[arg_19_4]
			local var_19_44 = GameSession.game_object_field(var_19_41, var_19_42, "current_health")
			local var_19_45 = GameSession.game_object_field(var_19_41, var_19_42, "current_temporary_health")
			local var_19_46
			local var_19_47
			local var_19_48 = var_19_44 + var_19_45
			local var_19_49 = var_19_48 <= arg_19_2 and var_19_48 - var_19_31 or arg_19_2

			if var_19_43 then
				var_19_46 = var_19_44 < var_19_49 and var_19_44 or var_19_49
				var_19_47 = var_19_44 < var_19_49 and var_19_49 - var_19_44 or 0
			else
				var_19_46 = var_19_45 < var_19_49 and var_19_49 - var_19_45 or 0
				var_19_47 = var_19_45 < var_19_49 and var_19_45 or var_19_49
			end

			local var_19_50 = var_19_44 < var_19_46 and 0 or var_19_44 - var_19_46

			if script_data.player_unkillable then
				var_19_50 = math.max(var_19_50, 1)
			end

			GameSession.set_game_object_field(var_19_41, var_19_42, "current_health", var_19_50)

			local var_19_51 = var_19_45 < var_19_47 and 0 or var_19_45 - var_19_47

			GameSession.set_game_object_field(var_19_41, var_19_42, "current_temporary_health", var_19_51)

			local var_19_52 = var_19_50 + var_19_51 <= 0 and (arg_19_0.state ~= "alive" or not var_19_0:has_wounds_remaining())

			if var_19_52 and arg_19_0.state ~= "dead" then
				Managers.state.entity:system("death_system"):kill_unit(var_19_1, var_19_23)
			end

			local var_19_53 = arg_19_0.unit_storage:go_id(var_19_1)
			local var_19_54, var_19_55 = arg_19_0.network_manager:game_object_or_level_id(arg_19_1)
			local var_19_56 = arg_19_0.network_manager:unit_game_object_id(arg_19_9) or var_19_54
			local var_19_57 = NetworkLookup.hit_zones[arg_19_3]
			local var_19_58 = NetworkLookup.damage_types[arg_19_4]
			local var_19_59 = NetworkLookup.damage_sources[arg_19_7 or "n/a"]
			local var_19_60 = NetworkLookup.hit_ragdoll_actors[arg_19_8 or "n/a"]
			local var_19_61 = NetworkLookup.hit_react_types[arg_19_10 or "light"]
			local var_19_62 = NetworkLookup.buff_attack_types[arg_19_15 or "n/a"]

			arg_19_11 = arg_19_11 or false
			arg_19_12 = arg_19_12 or false
			arg_19_13 = arg_19_13 or false
			arg_19_14 = arg_19_14 or 1
			arg_19_16 = arg_19_16 or 1
			arg_19_17 = arg_19_17 or 1

			arg_19_0.network_transmit:send_rpc_clients("rpc_add_damage", var_19_53, false, var_19_54, var_19_55, var_19_56, arg_19_2, var_19_57, var_19_58, arg_19_5, arg_19_6, var_19_59, var_19_60, var_19_61, var_19_52, arg_19_11, arg_19_12, arg_19_13, arg_19_14, var_19_62, arg_19_16, arg_19_17)
		end
	end
end

function PlayerUnitHealthExtension.add_heal(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	local var_20_0 = arg_20_0.unit
	local var_20_1 = arg_20_0.status_extension

	arg_20_0:_add_to_damage_history_buffer(var_20_0, arg_20_1, -arg_20_2, nil, "heal", nil, arg_20_3, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)

	if var_20_1 and var_20_1:heal_can_remove_wounded(arg_20_4) then
		Managers.razer_chroma:play_animation("health_potion", false, RAZER_ADD_ANIMATION_TYPE.REPLACE)
	end

	Managers.state.achievement:trigger_event("register_heal", arg_20_1, var_20_0, arg_20_2, arg_20_4)

	if arg_20_0.is_server then
		local var_20_2 = arg_20_0.game
		local var_20_3 = arg_20_0.health_game_object_id

		if var_20_2 and var_20_3 then
			local var_20_4 = GameSession.game_object_field(var_20_2, var_20_3, "current_health")
			local var_20_5 = GameSession.game_object_field(var_20_2, var_20_3, "current_temporary_health")
			local var_20_6 = GameSession.game_object_field(var_20_2, var_20_3, "max_health")

			if var_20_1:is_permanent_heal(arg_20_4) and not var_20_1:is_knocked_down() then
				local var_20_7 = var_20_5 < arg_20_2 and 0 or var_20_5 - arg_20_2

				GameSession.set_game_object_field(var_20_2, var_20_3, "current_temporary_health", var_20_7)

				local var_20_8 = var_20_6 < var_20_4 + var_20_7 + arg_20_2 and var_20_6 or var_20_4 + arg_20_2

				GameSession.set_game_object_field(var_20_2, var_20_3, "current_health", var_20_8)
			else
				local var_20_9 = var_20_6 < var_20_4 + var_20_5 + arg_20_2 and var_20_6 - var_20_4 or var_20_5 + arg_20_2

				GameSession.set_game_object_field(var_20_2, var_20_3, "current_temporary_health", var_20_9)
			end

			if arg_20_4 ~= "career_passive" and (not var_20_1:is_wounded() or arg_20_0._temp_hp_degen_delay_when_wounded) then
				local var_20_10 = Managers.time:time("game")
				local var_20_11, var_20_12, var_20_13 = arg_20_0:health_degen_settings()

				arg_20_0.wounded_degen_timer = var_20_10 + var_20_13
			end

			local var_20_14 = arg_20_0.unit_storage:go_id(var_20_0)

			if var_20_14 then
				local var_20_15 = arg_20_0.network_transmit
				local var_20_16, var_20_17 = Managers.state.network:game_object_or_level_id(arg_20_1)
				local var_20_18 = NetworkLookup.heal_types[arg_20_4]

				var_20_15:send_rpc_clients("rpc_heal", var_20_14, false, var_20_16, var_20_17, arg_20_2, var_20_18)
			end
		end
	end
end

function PlayerUnitHealthExtension.die(arg_21_0, arg_21_1)
	if not arg_21_0.is_server then
		return
	end

	arg_21_1 = arg_21_1 or "undefined"

	local var_21_0 = arg_21_0.unit

	if arg_21_0.is_bot and arg_21_1 == "volume_insta_kill" then
		local var_21_1 = BLACKBOARDS[var_21_0]
		local var_21_2 = var_21_1.nav_world
		local var_21_3 = Managers.state.side.side_by_unit[var_21_0].PLAYER_POSITIONS
		local var_21_4 = #var_21_3

		for iter_21_0 = 1, var_21_4 do
			local var_21_5 = var_21_3[iter_21_0]
			local var_21_6 = LocomotionUtils.new_random_goal_uniformly_distributed(var_21_2, nil, var_21_5, 2, 5, 5)

			if var_21_6 then
				var_21_1.locomotion_extension:teleport_to(var_21_6)
				var_21_1.navigation_extension:teleport(var_21_6)
				var_21_1.ai_extension:clear_failed_paths()

				return
			end
		end
	end

	if arg_21_0.state ~= "dead" then
		local var_21_7 = arg_21_0.game
		local var_21_8 = arg_21_0.health_game_object_id

		if var_21_7 and var_21_8 then
			GameSession.set_game_object_field(var_21_7, var_21_8, "current_health", 0)
			GameSession.set_game_object_field(var_21_7, var_21_8, "current_temporary_health", 0)
			Managers.state.entity:system("death_system"):forced_kill(var_21_0, arg_21_1)
		end
	end
end

function PlayerUnitHealthExtension.entered_kill_volume(arg_22_0, arg_22_1)
	if arg_22_0.is_local_player then
		local var_22_0 = arg_22_0.unit_storage:go_id(arg_22_0.unit)

		if var_22_0 then
			local var_22_1 = arg_22_0.network_transmit
			local var_22_2 = NetworkLookup.damage_types.volume_insta_kill

			var_22_1:send_rpc_server("rpc_request_insta_kill", var_22_0, var_22_2)
		end
	end
end

function PlayerUnitHealthExtension.destroy(arg_23_0)
	if arg_23_0.is_server and arg_23_0.health_game_object_id then
		arg_23_0.network_manager:destroy_game_object(arg_23_0.health_game_object_id)
	end

	arg_23_0.health_game_object_id = nil
end

function PlayerUnitHealthExtension.reset(arg_24_0)
	if arg_24_0.is_server then
		arg_24_0.state = "alive"

		local var_24_0 = arg_24_0.game
		local var_24_1 = arg_24_0.health_game_object_id

		if var_24_0 and var_24_1 then
			local var_24_2 = GameSession.game_object_field(var_24_0, var_24_1, "max_health")

			GameSession.set_game_object_field(var_24_0, var_24_1, "current_health", var_24_2)
			GameSession.set_game_object_field(var_24_0, var_24_1, "current_temporary_health", 0)
		end
	end
end

function PlayerUnitHealthExtension.is_alive(arg_25_0)
	return arg_25_0.state ~= "dead"
end

function PlayerUnitHealthExtension._is_alive(arg_26_0)
	local var_26_0 = arg_26_0.game
	local var_26_1 = arg_26_0.health_game_object_id

	if var_26_0 and var_26_1 then
		return GameSession.game_object_field(var_26_0, var_26_1, "current_health") + GameSession.game_object_field(var_26_0, var_26_1, "current_temporary_health") > 0
	end

	return true
end

function PlayerUnitHealthExtension.current_health_percent(arg_27_0)
	local var_27_0 = arg_27_0.game
	local var_27_1 = arg_27_0.health_game_object_id

	if var_27_0 and var_27_1 then
		local var_27_2 = GameSession.game_object_field(var_27_0, var_27_1, "current_health")
		local var_27_3 = GameSession.game_object_field(var_27_0, var_27_1, "current_temporary_health")
		local var_27_4 = GameSession.game_object_field(var_27_0, var_27_1, "max_health")

		if var_27_4 == 0 then
			return 0
		else
			return (var_27_2 + var_27_3) / var_27_4
		end
	end

	return 1
end

function PlayerUnitHealthExtension.current_permanent_health_percent(arg_28_0)
	local var_28_0 = arg_28_0.game
	local var_28_1 = arg_28_0.health_game_object_id

	if var_28_0 and var_28_1 then
		local var_28_2 = GameSession.game_object_field(var_28_0, var_28_1, "current_health")
		local var_28_3 = GameSession.game_object_field(var_28_0, var_28_1, "max_health")

		if var_28_3 == 0 then
			return 0
		else
			return var_28_2 / var_28_3
		end
	end

	return 1
end

function PlayerUnitHealthExtension.current_temporary_health_percent(arg_29_0)
	local var_29_0 = arg_29_0.game
	local var_29_1 = arg_29_0.health_game_object_id

	if var_29_0 and var_29_1 then
		local var_29_2 = GameSession.game_object_field(var_29_0, var_29_1, "current_temporary_health")
		local var_29_3 = GameSession.game_object_field(var_29_0, var_29_1, "max_health")

		if var_29_3 == 0 then
			return 0
		else
			return var_29_2 / var_29_3
		end
	end

	return 1
end

function PlayerUnitHealthExtension.current_health(arg_30_0)
	local var_30_0 = arg_30_0.game
	local var_30_1 = arg_30_0.health_game_object_id

	if var_30_0 and var_30_1 then
		return GameSession.game_object_field(var_30_0, var_30_1, "current_health") + GameSession.game_object_field(var_30_0, var_30_1, "current_temporary_health")
	end

	local var_30_2 = arg_30_0:_calculate_max_health()

	return (DamageUtils.networkify_health(var_30_2))
end

function PlayerUnitHealthExtension.current_permanent_health(arg_31_0)
	local var_31_0 = arg_31_0.game
	local var_31_1 = arg_31_0.health_game_object_id

	if var_31_0 and var_31_1 then
		return (GameSession.game_object_field(var_31_0, var_31_1, "current_health"))
	end

	local var_31_2 = arg_31_0:_calculate_max_health()

	return (DamageUtils.networkify_health(var_31_2))
end

function PlayerUnitHealthExtension.current_temporary_health(arg_32_0)
	local var_32_0 = arg_32_0.game
	local var_32_1 = arg_32_0.health_game_object_id

	if var_32_0 and var_32_1 then
		return (GameSession.game_object_field(var_32_0, var_32_1, "current_temporary_health"))
	end

	local var_32_2 = arg_32_0:_calculate_max_health()

	return (DamageUtils.networkify_health(var_32_2))
end

function PlayerUnitHealthExtension.get_max_health(arg_33_0)
	local var_33_0 = arg_33_0.game
	local var_33_1 = arg_33_0.health_game_object_id

	if var_33_0 and var_33_1 then
		return (GameSession.game_object_field(var_33_0, var_33_1, "max_health"))
	end

	local var_33_2 = arg_33_0:_calculate_max_health()

	return (DamageUtils.networkify_health(var_33_2))
end

function PlayerUnitHealthExtension.get_base_max_health(arg_34_0)
	return (arg_34_0:_get_base_max_health())
end

function PlayerUnitHealthExtension.get_uncursed_max_health(arg_35_0)
	local var_35_0 = arg_35_0.game
	local var_35_1 = arg_35_0.health_game_object_id

	if var_35_0 and var_35_1 then
		return (GameSession.game_object_field(var_35_0, var_35_1, "uncursed_max_health"))
	end

	local var_35_2 = arg_35_0:_calculate_max_health()

	return (DamageUtils.networkify_health(var_35_2))
end

function PlayerUnitHealthExtension.get_damage_taken(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0.game
	local var_36_1 = arg_36_0.health_game_object_id

	if var_36_0 and var_36_1 then
		local var_36_2 = GameSession.game_object_field(var_36_0, var_36_1, "current_health")

		return GameSession.game_object_field(var_36_0, var_36_1, arg_36_1 or "max_health") - var_36_2
	end

	return 0
end

function PlayerUnitHealthExtension.convert_permanent_to_temporary_health(arg_37_0)
	local var_37_0 = arg_37_0.game
	local var_37_1 = arg_37_0.health_game_object_id

	if var_37_0 and var_37_1 then
		local var_37_2 = GameSession.game_object_field(var_37_0, var_37_1, "current_health")
		local var_37_3 = GameSession.game_object_field(var_37_0, var_37_1, "current_temporary_health")

		GameSession.set_game_object_field(var_37_0, var_37_1, "current_health", 0)
		GameSession.set_game_object_field(var_37_0, var_37_1, "current_temporary_health", var_37_2 + var_37_3)
	end
end

function PlayerUnitHealthExtension.convert_temporary_to_permanent_health(arg_38_0)
	local var_38_0 = arg_38_0.game
	local var_38_1 = arg_38_0.health_game_object_id

	if var_38_0 and var_38_1 then
		local var_38_2 = GameSession.game_object_field(var_38_0, var_38_1, "current_health")
		local var_38_3 = GameSession.game_object_field(var_38_0, var_38_1, "current_temporary_health")

		GameSession.set_game_object_field(var_38_0, var_38_1, "current_health", var_38_2 + var_38_3)
		GameSession.set_game_object_field(var_38_0, var_38_1, "current_temporary_health", 0)
	end
end

function PlayerUnitHealthExtension.convert_to_temp(arg_39_0, arg_39_1)
	arg_39_1 = DamageUtils.networkify_damage(arg_39_1)

	if arg_39_0.is_server then
		local var_39_0 = arg_39_0.game
		local var_39_1 = arg_39_0.health_game_object_id

		if var_39_0 and var_39_1 then
			local var_39_2 = GameSession.game_object_field(var_39_0, var_39_1, "current_health")
			local var_39_3 = GameSession.game_object_field(var_39_0, var_39_1, "current_temporary_health")
			local var_39_4 = math.min(var_39_2, arg_39_1)

			GameSession.set_game_object_field(var_39_0, var_39_1, "current_health", var_39_2 - var_39_4)
			GameSession.set_game_object_field(var_39_0, var_39_1, "current_temporary_health", var_39_3 + var_39_4)
		end
	else
		local var_39_5 = arg_39_0.unit_storage:go_id(arg_39_0.unit)

		if var_39_5 then
			arg_39_0.network_transmit:send_rpc_server("rpc_request_convert_temp", var_39_5, arg_39_1)
		end
	end
end

function PlayerUnitHealthExtension.switch_permanent_and_temporary_health(arg_40_0)
	local var_40_0 = arg_40_0.game
	local var_40_1 = arg_40_0.health_game_object_id

	if var_40_0 and var_40_1 then
		local var_40_2 = GameSession.game_object_field(var_40_0, var_40_1, "current_health")
		local var_40_3 = GameSession.game_object_field(var_40_0, var_40_1, "current_temporary_health")

		GameSession.set_game_object_field(var_40_0, var_40_1, "current_health", var_40_3)
		GameSession.set_game_object_field(var_40_0, var_40_1, "current_temporary_health", var_40_2)
	end
end

function PlayerUnitHealthExtension.shield(arg_41_0, arg_41_1)
	arg_41_0._shield_amount = arg_41_1
	arg_41_0._shield_duration_left = 10
	arg_41_0._end_reason = nil

	if script_data.damage_debug then
		printf("[PlayerUnitHealthExtension] shield %.1f to %s", arg_41_1, tostring(arg_41_0.unit))
	end
end

function PlayerUnitHealthExtension.has_assist_shield(arg_42_0)
	return arg_42_0._shield_duration_left > 0 and arg_42_0._shield_amount > 0, arg_42_0._shield_amount
end

function PlayerUnitHealthExtension.remove_assist_shield(arg_43_0, arg_43_1)
	arg_43_0._shield_duration_left = 0
	arg_43_0._shield_amount = 0
	arg_43_0._end_reason = arg_43_1
end

function PlayerUnitHealthExtension.previous_shield_end_reason(arg_44_0)
	return arg_44_0._end_reason
end

function PlayerUnitHealthExtension.set_dead(arg_45_0)
	arg_45_0.state = "dead"

	arg_45_0.status_extension:set_dead(true)

	local var_45_0 = arg_45_0.unit

	HEALTH_ALIVE[var_45_0] = nil

	if ScriptUnit.has_extension(var_45_0, "dialogue_system") then
		local var_45_1 = DialogueSettings.death_discover_distance
		local var_45_2 = ScriptUnit.extension(var_45_0, "dialogue_system").context.player_profile

		SurroundingAwareSystem.add_event(var_45_0, "player_death", var_45_1, "target", var_45_0, "target_name", var_45_2)
	end

	local var_45_3 = arg_45_0:recent_damages()
	local var_45_4 = Managers.player:owner(var_45_0):stats_id()

	Managers.state.event:trigger("on_player_death", var_45_4, var_45_0, var_45_3)
end

function PlayerUnitHealthExtension.set_max_health(arg_46_0, arg_46_1)
	return arg_46_0.health
end

function PlayerUnitHealthExtension.set_current_damage(arg_47_0, arg_47_1)
	return
end

function PlayerUnitHealthExtension.health_degen_settings(arg_48_0)
	local var_48_0 = arg_48_0.buff_extension
	local var_48_1 = PlayerUnitStatusSettings.NOT_WOUNDED_DEGEN_AMOUNT
	local var_48_2 = PlayerUnitStatusSettings.NOT_WOUNDED_DEGEN_DELAY
	local var_48_3 = PlayerUnitStatusSettings.NOT_WOUNDED_DEGEN_START

	if var_48_0 then
		if var_48_0:has_buff_perk("smiter_healing") then
			var_48_1 = PlayerUnitStatusSettings.SMITER_DEGEN_AMOUNT
			var_48_2 = PlayerUnitStatusSettings.SMITER_DEGEN_DELAY
			var_48_3 = PlayerUnitStatusSettings.SMITER_DEGEN_START
		elseif var_48_0:has_buff_perk("linesman_healing") then
			var_48_1 = PlayerUnitStatusSettings.LINESMAN_DEGEN_AMOUNT
			var_48_2 = PlayerUnitStatusSettings.LINESMAN_DEGEN_DELAY
			var_48_3 = PlayerUnitStatusSettings.LINESMAN_DEGEN_START
		elseif var_48_0:has_buff_perk("tank_healing") then
			var_48_1 = PlayerUnitStatusSettings.TANK_DEGEN_AMOUNT
			var_48_2 = PlayerUnitStatusSettings.TANK_DEGEN_DELAY
			var_48_3 = PlayerUnitStatusSettings.TANK_DEGEN_START
		elseif var_48_0:has_buff_perk("ninja_healing") then
			var_48_1 = PlayerUnitStatusSettings.NINJA_DEGEN_AMOUNT
			var_48_2 = PlayerUnitStatusSettings.NINJA_DEGEN_DELAY
			var_48_3 = PlayerUnitStatusSettings.NINJA_DEGEN_START
		end
	end

	if Managers.weave:get_active_wind() == "death" then
		var_48_1 = var_48_1 * 2
		var_48_3 = 0
	end

	return var_48_1, var_48_2, var_48_3
end
