-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_extension.lua

require("scripts/unit_extensions/default_player_unit/careers/career_utils")

CareerExtension = class(CareerExtension)

local var_0_0 = 1

function CareerExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0.world = arg_1_1.world
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.player = arg_1_3.player
	arg_1_0.input_manager = Managers.input

	local var_1_0 = arg_1_3.profile_index
	local var_1_1 = arg_1_3.career_index
	local var_1_2 = SPProfiles[var_1_0]
	local var_1_3 = var_1_2.careers[var_1_1]

	arg_1_0._profile_index = var_1_0
	arg_1_0._career_index = var_1_1
	arg_1_0._career_name = var_1_3.name
	arg_1_0._profile_name = var_1_2.display_name

	if not DEDICATED_SERVER and arg_1_0._profile_name == "bright_wizard" then
		GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", arg_1_0._career_name == "bw_necromancer")
	end

	arg_1_0._career_data = var_1_3
	arg_1_0._breed = var_1_3.breed or var_1_2.breed

	local var_1_4 = CareerUtils.num_abilities(var_1_0, var_1_1)

	arg_1_0._num_abilities = var_1_4
	arg_1_0._abilities = {}
	arg_1_0._abilities_always_usable_reasons = {}
	arg_1_0._last_ability_ready_t = 0

	for iter_1_0 = 1, var_1_4 do
		local var_1_5 = CareerUtils.get_ability_data(var_1_0, var_1_1, iter_1_0)
		local var_1_6 = var_1_5.ability_class
		local var_1_7 = (var_1_5.spawn_cooldown_percent or 0) * var_1_5.cooldown
		local var_1_8 = arg_1_3.ability_cooldown_percent_int or 100

		if var_1_8 < 100 then
			var_1_7 = var_1_8 * 0.01 * var_1_5.cooldown
		end

		arg_1_0._abilities[iter_1_0] = {
			cooldown_anim_started = false,
			is_ready = false,
			name = var_1_5.name,
			cooldowns = {
				var_1_7
			},
			initial_max_cooldown = var_1_5.cooldown,
			max_cooldown = var_1_5.cooldown,
			activated_ability = var_1_6 and var_1_6:new(arg_1_1, arg_1_2, arg_1_3, var_1_5),
			weapon_name = var_1_5.weapon_name,
			weapon_names_by_index = var_1_5.weapon_names_by_index,
			cooldown_paused = var_1_5.start_paused or false,
			cooldown_anim_time = var_1_5.cooldown_anim_time,
			cost = var_1_5.cost or 1,
			draw_ui_in_ghost_mode = var_1_5.draw_ui_in_ghost_mode or false
		}
	end

	local var_1_9 = CareerUtils.get_passive_ability_by_career(var_1_3).passive_ability_classes
	local var_1_10 = var_1_9 and #var_1_9 or 0

	arg_1_0._passive_abilities = {}
	arg_1_0._passive_abilities_update = {}
	arg_1_0._passive_abilities_by_name = {}
	arg_1_0._num_passive_abilities = var_1_10

	for iter_1_1 = 1, var_1_10 do
		local var_1_11 = var_1_9[iter_1_1]
		local var_1_12 = var_1_11.ability_class:new(arg_1_1, arg_1_2, arg_1_3, var_1_11.init_data)

		arg_1_0._passive_abilities[iter_1_1] = var_1_12

		if var_1_12 and var_1_12.update then
			arg_1_0._passive_abilities_update[iter_1_1] = var_1_12
		end

		arg_1_0._passive_abilities_by_name[var_1_11.name] = var_1_12
	end

	arg_1_0._num_passive_abilities_update = #arg_1_0._passive_abilities_update
	arg_1_0._ability_always_usable = nil

	arg_1_0:setup_extra_ability_uses(0, 0, 0, 0)
	Unit.set_data(arg_1_2, "breed", arg_1_0._breed)
	fassert(arg_1_0._breed.hit_zones, "Player Breed '%s' is missing a 'hit_zones' table.", var_1_2.display_name)
	DamageUtils.create_hit_zone_lookup(arg_1_2, arg_1_0._breed)
end

function CareerExtension.ability_id(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in ipairs(arg_2_0._abilities) do
		if iter_2_1.name == arg_2_1 then
			return iter_2_0
		end
	end

	return nil
end

function CareerExtension.ability_was_triggered(arg_3_0, arg_3_1)
	return arg_3_0._abilities[arg_3_1].activated_ability:was_triggered()
end

function CareerExtension.ability_by_id(arg_4_0, arg_4_1)
	return arg_4_0._abilities[arg_4_1].activated_ability
end

function CareerExtension.ability_name_by_id(arg_5_0, arg_5_1)
	return arg_5_0._abilities[arg_5_1].name
end

function CareerExtension.ability_by_name(arg_6_0, arg_6_1)
	for iter_6_0 = 1, #arg_6_0._abilities do
		local var_6_0 = arg_6_0._abilities[iter_6_0]

		if var_6_0.name == arg_6_1 then
			return var_6_0, iter_6_0
		end
	end
end

function CareerExtension._is_husk(arg_7_0)
	local var_7_0 = arg_7_0.player

	return not var_7_0.local_player and (not arg_7_0.is_server or not var_7_0.bot_player)
end

function CareerExtension.extensions_ready(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = ScriptUnit.extension(arg_8_2, "buff_system")
	local var_8_1 = CareerUtils.get_passive_ability_by_career(arg_8_0._career_data)
	local var_8_2 = var_8_1.buffs
	local var_8_3 = arg_8_0.player

	if var_8_2 and (arg_8_0.is_server or var_8_3.local_player) then
		for iter_8_0 = 1, #var_8_2 do
			local var_8_4 = var_8_2[iter_8_0]

			var_8_0:add_buff(var_8_4)
		end
	end

	local var_8_5 = var_8_1.husk_buffs

	if var_8_5 and not arg_8_0.is_server and not var_8_3.local_player then
		for iter_8_1 = 1, #var_8_5 do
			local var_8_6 = var_8_5[iter_8_1]

			var_8_0:add_buff(var_8_6)
		end
	end

	local var_8_7 = Managers.mechanism:mechanism_setting_for_title("base_career_buffs")

	if var_8_7 then
		for iter_8_2 = 1, #var_8_7 do
			local var_8_8 = var_8_7[iter_8_2]

			var_8_0:add_buff(var_8_8)
		end
	end

	arg_8_0._first_person_extension = ScriptUnit.has_extension(arg_8_2, "first_person_system")
	arg_8_0._buff_extension = ScriptUnit.extension(arg_8_2, "buff_system")

	local var_8_9 = arg_8_0._abilities

	for iter_8_3 = 1, arg_8_0._num_abilities do
		local var_8_10 = var_8_9[iter_8_3].activated_ability

		if var_8_10 then
			var_8_10:extensions_ready(arg_8_1, arg_8_2)
		end
	end

	local var_8_11 = arg_8_0._passive_abilities

	for iter_8_4 = 1, arg_8_0._num_passive_abilities do
		var_8_11[iter_8_4]:extensions_ready(arg_8_1, arg_8_2)
	end

	Managers.state.event:register(arg_8_0, "ingame_menu_opened", "stop_ability")
	Managers.state.event:register(arg_8_0, "gm_event_round_started", "on_round_started")
end

function CareerExtension.game_object_initialized(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._passive_abilities

	for iter_9_0 = 1, arg_9_0._num_passive_abilities do
		local var_9_1 = var_9_0[iter_9_0]

		if var_9_1.game_object_initialized then
			var_9_1:game_object_initialized(arg_9_1, arg_9_2)
		end
	end
end

function CareerExtension.force_trigger_active_ability(arg_10_0)
	local var_10_0 = arg_10_0.player
	local var_10_1 = arg_10_0._abilities

	for iter_10_0 = 1, arg_10_0._num_abilities do
		local var_10_2 = var_10_1[iter_10_0]

		if var_10_2.activated_ability and var_10_2.activated_ability.force_trigger_ability and (arg_10_0.is_server and var_10_0.bot_player or var_10_0.local_player) then
			var_10_2.activated_ability:force_trigger_ability()

			break
		end
	end
end

function CareerExtension.update(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = arg_11_0._abilities
	local var_11_1 = arg_11_0:_cooldown_charge_ready(1)

	for iter_11_0 = 1, arg_11_0._num_abilities do
		local var_11_2 = var_11_0[iter_11_0]

		if not var_11_2.cooldown_paused then
			local var_11_3 = arg_11_0:_cooldown_charge_ready(iter_11_0)
			local var_11_4 = ScriptUnit.extension(arg_11_1, "buff_system"):apply_buffs_to_value(1, "cooldown_regen")

			arg_11_0:reduce_activated_ability_cooldown(arg_11_3 * var_11_4, iter_11_0)
			arg_11_0:check_cooldown_anim(iter_11_0)

			if var_11_3 or arg_11_0._abilities_always_usable then
				local var_11_5 = arg_11_0.player

				if var_11_2.activated_ability and (arg_11_0.is_server and var_11_5.bot_player or var_11_5.local_player) then
					var_11_2.activated_ability:update(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
				end
			elseif arg_11_0:_cooldown_charge_ready(iter_11_0) then
				arg_11_0:_run_ability_ready_feedback(iter_11_0, arg_11_5)
			end
		end
	end

	local var_11_6 = arg_11_0._passive_abilities_update

	for iter_11_1 = 1, arg_11_0._num_passive_abilities_update do
		var_11_6[iter_11_1]:update(arg_11_3, arg_11_5)
	end

	local var_11_7 = arg_11_0:_cooldown_charge_ready(1)

	if not var_11_1 or not var_11_7 then
		arg_11_0:_update_game_object_field(arg_11_1)

		if var_11_7 and arg_11_0._buff_extension then
			arg_11_0._buff_extension:trigger_procs("on_ability_recharged")
		end
	end
end

function CareerExtension.stop_ability(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.is_server
	local var_12_1 = arg_12_0.player

	if var_12_0 and var_12_1.bot_player or var_12_1.local_player then
		arg_12_2 = arg_12_2 or 1

		local var_12_2 = arg_12_0._abilities[arg_12_2].activated_ability

		if var_12_2 then
			var_12_2:stop(arg_12_1)
		end
	end
end

function CareerExtension._update_game_object_field(arg_13_0, arg_13_1)
	if (not arg_13_0.is_server or not arg_13_0.player.bot_player) and not arg_13_0.player.local_player then
		return
	end

	local var_13_0, var_13_1 = arg_13_0:current_ability_cooldown(1)
	local var_13_2 = 1

	if var_13_0 then
		var_13_2 = var_13_0 / var_13_1
	end

	local var_13_3 = Managers.state.network:game()

	if var_13_3 then
		local var_13_4 = Managers.state.unit_storage:go_id(arg_13_1)
		local var_13_5 = math.clamp(var_13_2, 0, 1)

		GameSession.set_game_object_field(var_13_3, var_13_4, "ability_percentage", var_13_5)
	end
end

function CareerExtension.destroy(arg_14_0)
	local var_14_0 = arg_14_0._passive_abilities

	for iter_14_0 = 1, arg_14_0._num_passive_abilities do
		var_14_0[iter_14_0]:destroy()
	end

	local var_14_1 = arg_14_0._abilities

	for iter_14_1 = 1, arg_14_0._num_abilities do
		local var_14_2 = var_14_1[iter_14_1].activated_ability

		if var_14_2 and var_14_2.destroy then
			var_14_2:destroy()
		end
	end
end

function CareerExtension.get_activated_ability_data(arg_15_0, arg_15_1)
	arg_15_1 = arg_15_1 or 1

	return arg_15_0._career_data.activated_ability[arg_15_1]
end

function CareerExtension.start_activated_ability_cooldown(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	arg_16_1 = arg_16_1 or 1

	local var_16_0 = arg_16_0._abilities[arg_16_1]
	local var_16_1 = var_16_0.max_cooldown * (var_16_0.cost * (arg_16_2 or 0))
	local var_16_2 = var_16_0.max_cooldown * var_16_0.cost

	if arg_16_3 then
		var_16_2 = var_16_0.max_cooldown * arg_16_3
	end

	local var_16_3 = arg_16_0._unit
	local var_16_4 = ScriptUnit.extension(var_16_3, "buff_system")

	if var_16_4:has_buff_perk("free_ability") then
		var_16_2 = 0
	end

	if arg_16_0:_cooldown_charge_ready(arg_16_1) or arg_16_0._abilities_always_usable or arg_16_4 then
		local var_16_5 = Managers.player:players_at_peer(Network.peer_id())

		if var_16_5 and var_16_3 then
			for iter_16_0, iter_16_1 in pairs(var_16_5) do
				local var_16_6 = iter_16_1.player_unit

				if ALIVE[var_16_6] then
					local var_16_7 = ScriptUnit.has_extension(var_16_6, "buff_system")

					if var_16_7 then
						var_16_7:trigger_procs("on_ability_activated", var_16_3, arg_16_1)

						local var_16_8 = arg_16_0.player
						local var_16_9 = iter_16_1

						Managers.state.achievement:trigger_event("any_ability_used", var_16_3, arg_16_1, var_16_8, var_16_9)
					end

					local var_16_10 = ScriptUnit.has_extension(var_16_6, "cosmetic_system")

					if var_16_10 then
						var_16_10:trigger_ability_activated_events()
					end
				end
			end
		end
	end

	local var_16_11 = Managers.state.network
	local var_16_12 = var_16_11:unit_game_object_id(var_16_3)

	if var_16_11:game() then
		if arg_16_0.is_server then
			var_16_11.network_transmit:send_rpc_clients("rpc_ability_activated", var_16_12, arg_16_1)
		else
			var_16_11.network_transmit:send_rpc_server("rpc_ability_activated", var_16_12, arg_16_1)
		end
	end

	local var_16_13 = Managers.state.game_mode and Managers.state.game_mode:game_mode()

	if arg_16_0.player.local_player and var_16_13 and var_16_13.activated_ability_telemetry then
		local var_16_14 = arg_16_0:get_activated_ability_data(arg_16_1)
		local var_16_15 = var_16_14.name or var_16_14.display_name

		var_16_13:activated_ability_telemetry(var_16_15, arg_16_0.player)
	end

	if arg_16_0:current_ability_cooldown(arg_16_1) <= var_16_0.max_cooldown * (1 - var_16_0.cost) or var_16_2 <= 0 then
		arg_16_0:increase_activated_ability_cooldown(var_16_2 - var_16_1, arg_16_1)

		local var_16_16 = arg_16_0:current_ability_cooldown(arg_16_1)
		local var_16_17 = var_16_4:apply_buffs_to_value(var_16_16, "activated_cooldown")

		if var_16_16 < var_16_17 then
			arg_16_0:increase_activated_ability_cooldown(var_16_17 - var_16_16, arg_16_1)
		elseif var_16_17 < var_16_16 then
			arg_16_0:reduce_activated_ability_cooldown(var_16_16 - var_16_17, arg_16_1)
		end
	elseif arg_16_0._extra_ability_uses > 0 then
		arg_16_0:modify_extra_ability_uses(-1)
		var_16_4:trigger_procs("on_extra_ability_consumed", var_16_3)
		Managers.state.achievement:trigger_event("free_cast_used", var_16_3, var_16_3)
	end

	var_16_4:trigger_procs("on_ability_cooldown_started")

	var_16_0.cooldown_paused = false
	var_16_0.cooldown_anim_started = false
end

function CareerExtension.reduce_activated_ability_cooldown_percent(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_2 = arg_17_2 or 1

	local var_17_0 = arg_17_0._abilities[arg_17_2]

	arg_17_0:reduce_activated_ability_cooldown(var_17_0.max_cooldown * arg_17_1, arg_17_2, arg_17_3)
end

function CareerExtension.reduce_activated_ability_cooldown(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_2 = arg_18_2 or 1

	local var_18_0 = arg_18_0._abilities[arg_18_2]

	if var_18_0.cooldown_paused and not arg_18_3 then
		return
	end

	if arg_18_1 < 0 then
		return arg_18_0:increase_activated_ability_cooldown(-arg_18_1, arg_18_2, arg_18_3)
	end

	local var_18_1 = arg_18_0:_currently_decaying_cooldown(arg_18_2)
	local var_18_2 = var_18_0.cooldowns

	for iter_18_0 = var_18_1, 1, -1 do
		if arg_18_1 < math.epsilon then
			break
		end

		local var_18_3 = var_18_2[iter_18_0]
		local var_18_4 = math.min(var_18_3, arg_18_1)

		var_18_2[iter_18_0] = math.clamp(var_18_3 - var_18_4, 0, var_18_0.max_cooldown)
		arg_18_1 = arg_18_1 - var_18_4
	end

	local var_18_5 = arg_18_0:_cooldown_charge_ready(arg_18_2)

	if not var_18_5 then
		var_18_0.cooldown_paused = false
	end

	if arg_18_3 and var_18_5 then
		arg_18_0:set_activated_ability_cooldown_unpaused(arg_18_2)
	end
end

function CareerExtension.increase_activated_ability_cooldown(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_2 = arg_19_2 or 1

	local var_19_0 = arg_19_0._abilities[arg_19_2]

	if var_19_0.cooldown_paused and not arg_19_3 then
		return
	end

	if arg_19_1 < 0 then
		return arg_19_0:reduce_activated_ability_cooldown(-arg_19_1, arg_19_2, arg_19_3)
	end

	local var_19_1 = arg_19_0:_currently_decaying_cooldown(arg_19_2)
	local var_19_2 = var_19_0.cooldowns

	for iter_19_0 = var_19_1, #var_19_2 do
		if arg_19_1 < math.epsilon then
			break
		end

		local var_19_3 = var_19_2[iter_19_0]
		local var_19_4 = math.min(var_19_0.max_cooldown - var_19_3, arg_19_1)

		var_19_2[iter_19_0] = math.clamp(var_19_3 + var_19_4, 0, var_19_0.max_cooldown)
		arg_19_1 = arg_19_1 - var_19_4
	end

	if not arg_19_0:_cooldown_charge_ready(arg_19_2) then
		var_19_0.cooldown_paused = false
	end
end

function CareerExtension.modify_max_cooldown(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_1 = arg_20_1 or 1
	arg_20_2 = arg_20_2 or 0
	arg_20_3 = arg_20_3 or 1

	local var_20_0 = arg_20_0._abilities[arg_20_1]
	local var_20_1 = var_20_0.max_cooldown

	var_20_0.max_cooldown = var_20_0.max_cooldown + var_20_0.initial_max_cooldown * arg_20_3 + arg_20_2

	local var_20_2 = var_20_0.cooldowns

	for iter_20_0 = 1, #var_20_2 do
		local var_20_3 = var_20_2[iter_20_0]

		var_20_2[iter_20_0] = math.clamp(var_20_3 / var_20_1, 0, 1) * var_20_0.max_cooldown
	end
end

function CareerExtension.uses_cooldown(arg_21_0, arg_21_1)
	arg_21_1 = arg_21_1 or 1

	local var_21_0 = arg_21_0._abilities[arg_21_1].max_cooldown

	return var_21_0 and var_21_0 > 0
end

function CareerExtension.set_activated_ability_cooldown_paused(arg_22_0, arg_22_1)
	arg_22_1 = arg_22_1 or 1
	arg_22_0._abilities[arg_22_1].cooldown_paused = true
end

function CareerExtension.set_activated_ability_cooldown_unpaused(arg_23_0, arg_23_1)
	arg_23_1 = arg_23_1 or 1
	arg_23_0._abilities[arg_23_1].cooldown_paused = false
end

function CareerExtension.abilities_always_usable(arg_24_0)
	return arg_24_0._abilities_always_usable
end

function CareerExtension.set_abilities_always_usable(arg_25_0, arg_25_1, arg_25_2)
	if arg_25_1 then
		arg_25_0._abilities_always_usable_reasons[arg_25_2] = arg_25_1
	else
		arg_25_0._abilities_always_usable_reasons[arg_25_2] = nil
	end

	arg_25_0._abilities_always_usable = next(arg_25_0._abilities_always_usable_reasons) ~= nil
end

function CareerExtension.has_abilities_always_usable_reason(arg_26_0, arg_26_1)
	return arg_26_0._abilities_always_usable_reasons[arg_26_1] ~= nil
end

function CareerExtension.modify_extra_ability_uses(arg_27_0, arg_27_1)
	arg_27_0._extra_ability_uses = math.max(arg_27_0._extra_ability_uses + arg_27_1, 0)

	arg_27_0:set_abilities_always_usable(arg_27_0._extra_ability_uses > 0, "extra_ability_uses")
end

function CareerExtension.get_extra_ability_uses(arg_28_0)
	return arg_28_0._extra_ability_uses, arg_28_0._extra_ability_uses_max
end

function CareerExtension.get_extra_ability_charge(arg_29_0)
	return arg_29_0._extra_ability_use_charge, arg_29_0._extra_ability_use_required_charge
end

function CareerExtension.modify_extra_ability_charge(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0._extra_ability_use_charge

	if arg_30_0._extra_ability_uses >= arg_30_0._extra_ability_uses_max then
		var_30_0 = 0
	else
		var_30_0 = math.max(var_30_0 + arg_30_1, 0)

		if var_30_0 >= arg_30_0._extra_ability_use_required_charge then
			var_30_0 = var_30_0 - arg_30_0._extra_ability_use_required_charge

			arg_30_0:modify_extra_ability_uses(1)
		end
	end

	arg_30_0._extra_ability_use_charge = var_30_0
end

function CareerExtension.update_extra_ability_charge(arg_31_0, arg_31_1)
	arg_31_0._extra_ability_use_required_charge = arg_31_1
end

function CareerExtension.setup_extra_ability_uses(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	arg_32_0._extra_ability_use_charge = math.min(arg_32_1, arg_32_2)
	arg_32_0._extra_ability_use_required_charge = arg_32_2
	arg_32_0._extra_ability_uses = math.min(arg_32_3, arg_32_4)
	arg_32_0._extra_ability_uses_max = arg_32_4

	if arg_32_0._extra_ability_uses == arg_32_0._extra_ability_uses_max then
		arg_32_0._extra_ability_use_charge = 0
	end
end

function CareerExtension.update_extra_ability_uses_max(arg_33_0, arg_33_1)
	arg_33_0._extra_ability_uses = math.min(arg_33_0._extra_ability_uses, arg_33_1)
	arg_33_0._extra_ability_uses_max = arg_33_1

	if arg_33_0._extra_ability_uses == arg_33_0._extra_ability_uses_max then
		arg_33_0._extra_ability_use_charge = 0
	end
end

function CareerExtension.reset_cooldown(arg_34_0, arg_34_1)
	arg_34_1 = arg_34_1 or 1

	local var_34_0 = arg_34_0._abilities[arg_34_1]
	local var_34_1 = var_34_0.cooldowns

	for iter_34_0 = 1, #var_34_1 do
		var_34_1[iter_34_0] = var_34_0.max_cooldown
	end
end

function CareerExtension.can_use_activated_ability(arg_35_0, arg_35_1)
	if not Managers.state.network:game() then
		return false
	end

	arg_35_1 = arg_35_1 or 1

	local var_35_0 = arg_35_0._abilities[arg_35_1]
	local var_35_1 = 1 - arg_35_0:current_ability_cooldown_percentage(arg_35_1)

	return (arg_35_0:_cooldown_charge_ready(arg_35_1) or var_35_1 >= var_35_0.cost or arg_35_0._abilities_always_usable) and not var_35_0.cooldown_paused
end

function CareerExtension._cooldown_charge_ready(arg_36_0, arg_36_1)
	return arg_36_0:current_ability_cooldown(arg_36_1) == 0
end

function CareerExtension.current_ability_cooldown(arg_37_0, arg_37_1)
	arg_37_1 = arg_37_1 or 1

	local var_37_0 = arg_37_0._abilities[arg_37_1]
	local var_37_1 = var_37_0.cooldowns
	local var_37_2 = #var_37_1
	local var_37_3 = arg_37_0._buff_extension:apply_buffs_to_value(1, "extra_ability_charges")

	for iter_37_0 = var_37_2 + 1, var_37_3 do
		arg_37_0:_add_cooldown_charge(arg_37_1)

		var_37_2 = var_37_2 + 1
	end

	for iter_37_1 = var_37_3 + 1, var_37_2 do
		arg_37_0:_remove_cooldown_charge(arg_37_1)

		var_37_2 = var_37_2 - 1
	end

	return var_37_1[var_37_2], var_37_0.max_cooldown > 0 and var_37_0.max_cooldown or 1
end

function CareerExtension._add_cooldown_charge(arg_38_0, arg_38_1)
	arg_38_1 = arg_38_1 or 1

	local var_38_0 = arg_38_0._abilities[arg_38_1].cooldowns

	table.insert(var_38_0, 0)
end

function CareerExtension._remove_cooldown_charge(arg_39_0, arg_39_1)
	arg_39_1 = arg_39_1 or 1

	local var_39_0 = arg_39_0._abilities[arg_39_1].cooldowns

	table.remove(var_39_0, 1)
end

function CareerExtension._currently_decaying_cooldown(arg_40_0, arg_40_1)
	arg_40_1 = arg_40_1 or 1

	local var_40_0 = arg_40_0._abilities[arg_40_1].cooldowns

	for iter_40_0 = #var_40_0, 1, -1 do
		if var_40_0[iter_40_0] ~= 0 then
			return iter_40_0
		end
	end

	return 1
end

function CareerExtension.get_number_of_ability_cooldowns(arg_41_0, arg_41_1)
	arg_41_1 = arg_41_1 or 1

	return #arg_41_0._abilities[arg_41_1].cooldowns or 1
end

function CareerExtension.num_charges_ready(arg_42_0, arg_42_1)
	arg_42_1 = arg_42_1 or 1

	local var_42_0 = arg_42_0._abilities[arg_42_1].cooldowns
	local var_42_1 = #var_42_0
	local var_42_2 = 0

	for iter_42_0 = var_42_1, 1, -1 do
		if var_42_0[iter_42_0] > 0 then
			break
		end

		var_42_2 = var_42_2 + 1
	end

	return var_42_2, var_42_1
end

function CareerExtension.current_ability_cooldown_percentage(arg_43_0, arg_43_1)
	if arg_43_0:_is_husk() then
		local var_43_0 = Managers.state.network
		local var_43_1 = var_43_0 and var_43_0:game()

		if not var_43_1 then
			return 0
		end

		local var_43_2 = Managers.state.unit_storage:go_id(arg_43_0._unit)

		return GameSession.game_object_field(var_43_1, var_43_2, "ability_percentage")
	else
		arg_43_1 = arg_43_1 or 1

		local var_43_3, var_43_4 = arg_43_0:current_ability_cooldown(arg_43_1)

		return var_43_3 / var_43_4
	end
end

function CareerExtension.get_max_ability_cooldown(arg_44_0, arg_44_1)
	arg_44_1 = arg_44_1 or 1

	return arg_44_0._abilities[arg_44_1].max_cooldown
end

function CareerExtension.current_ability_paused(arg_45_0, arg_45_1)
	arg_45_1 = arg_45_1 or 1

	return arg_45_0._abilities[arg_45_1].cooldown_paused
end

function CareerExtension.profile_index(arg_46_0)
	return arg_46_0._profile_index
end

function CareerExtension.career_index(arg_47_0)
	return arg_47_0._career_index
end

function CareerExtension.career_name(arg_48_0)
	return arg_48_0._career_name
end

function CareerExtension.career_settings(arg_49_0)
	return arg_49_0._career_data
end

function CareerExtension.career_skill_weapon_name(arg_50_0, arg_50_1, arg_50_2)
	arg_50_1 = arg_50_1 or 1

	local var_50_0 = arg_50_0._abilities[arg_50_1]

	if arg_50_2 then
		local var_50_1 = var_50_0.weapon_names_by_index

		if var_50_1 and var_50_1[arg_50_2] then
			return var_50_1[arg_50_2]
		end
	end

	return var_50_0.weapon_name
end

function CareerExtension.get_base_critical_strike_chance(arg_51_0)
	return arg_51_0._career_data.attributes.base_critical_strike_chance or 0
end

function CareerExtension.has_melee_boost(arg_52_0)
	local var_52_0 = arg_52_0._buff_extension:has_buff_perk("shade_melee_boost")
	local var_52_1 = false
	local var_52_2 = var_52_0 and 4 or var_52_1 and 1 or 0

	return var_52_0 or var_52_1, var_52_2
end

function CareerExtension.has_ranged_boost(arg_53_0)
	local var_53_0 = arg_53_0._buff_extension
	local var_53_1 = var_53_0:has_buff_type("markus_huntsman_activated_ability") or var_53_0:has_buff_type("markus_huntsman_activated_ability_duration")
	local var_53_2 = var_53_0:has_buff_type("bardin_ranger_activated_ability_buff")
	local var_53_3 = var_53_1 and 1.5 or var_53_2 and 1 or 0

	return var_53_1 or var_53_2, var_53_3
end

function CareerExtension.get_career_power_level(arg_54_0)
	local var_54_0 = arg_54_0.player
	local var_54_1 = arg_54_0._career_name
	local var_54_2 = arg_54_0._profile_name
	local var_54_3 = MIN_POWER_LEVEL
	local var_54_4 = Managers.state.game_mode
	local var_54_5 = var_54_4 and var_54_4:game_mode_key()

	if var_54_5 == "versus" and var_54_0.bot_player then
		local var_54_6 = GameModeSettings[var_54_5]

		if var_54_6 and var_54_6.power_level_override then
			var_54_3 = var_54_6.power_level_override
		end
	else
		if var_54_0.bot_player then
			local var_54_7 = Managers.player:party_leader_player()

			if var_54_7 then
				var_54_0 = var_54_7
				var_54_2 = var_54_7:profile_display_name()
				var_54_1 = var_54_7:career_name()
			end
		end

		if var_54_0.remote then
			var_54_3 = var_54_0:get_data("power_level") or MIN_POWER_LEVEL
		else
			var_54_3 = BackendUtils.get_total_power_level(var_54_2, var_54_1)
		end
	end

	local var_54_8 = arg_54_0._buff_extension

	if var_54_8 then
		var_54_3 = var_54_8:apply_buffs_to_value(var_54_3, "flat_power_level")
	end

	return (math.clamp(var_54_3, MIN_POWER_LEVEL, MAX_POWER_LEVEL))
end

function CareerExtension.set_state(arg_55_0, arg_55_1)
	arg_55_0._state = arg_55_1
end

function CareerExtension.get_state(arg_56_0)
	return arg_56_0._state or "default"
end

function CareerExtension.get_breed(arg_57_0)
	return arg_57_0._breed
end

function CareerExtension.ability_amount(arg_58_0)
	return arg_58_0._num_abilities
end

function CareerExtension._run_ability_ready_feedback(arg_59_0, arg_59_1, arg_59_2)
	local var_59_0 = arg_59_0._abilities[arg_59_1]

	if var_59_0 and var_59_0.activated_ability and var_59_0.activated_ability.ability_ready then
		var_59_0.activated_ability:ability_ready()
	else
		local var_59_1 = arg_59_0._first_person_extension

		if var_59_1 then
			if arg_59_2 > arg_59_0._last_ability_ready_t + var_0_0 then
				var_59_1:play_hud_sound_event("Play_hud_ability_ready")
			end

			arg_59_0._last_ability_ready_t = arg_59_2
		end
	end
end

function CareerExtension.check_cooldown_anim(arg_60_0, arg_60_1)
	local var_60_0 = arg_60_0._abilities[arg_60_1]

	if not var_60_0.cooldown_anim_started and var_60_0.cooldown_anim_time and arg_60_0:current_ability_cooldown(arg_60_1) - var_60_0.cooldown_anim_time < 0 then
		var_60_0.cooldown_anim_started = true

		var_60_0.activated_ability:start_cooldown_anim()
	end
end

function CareerExtension.should_reload_career_weapon(arg_61_0)
	return arg_61_0._career_data.should_reload_career_weapon
end

function CareerExtension.set_career_game_object_id(arg_62_0, arg_62_1)
	local var_62_0 = arg_62_0._passive_abilities

	for iter_62_0 = 1, arg_62_0._num_passive_abilities do
		local var_62_1 = var_62_0[iter_62_0]

		if var_62_1 and var_62_1.set_career_game_object_id then
			var_62_1:set_career_game_object_id(arg_62_1)
		end
	end
end

function CareerExtension.get_passive_ability(arg_63_0, arg_63_1)
	local var_63_0 = arg_63_0._passive_abilities

	return var_63_0 and var_63_0[arg_63_1 or 1]
end

function CareerExtension.get_passive_ability_by_name(arg_64_0, arg_64_1)
	return arg_64_0._passive_abilities_by_name[arg_64_1]
end

function CareerExtension.on_round_started(arg_65_0)
	arg_65_0:set_activated_ability_cooldown_unpaused()
end
