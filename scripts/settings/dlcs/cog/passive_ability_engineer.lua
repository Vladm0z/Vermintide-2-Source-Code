-- chunkname: @scripts/settings/dlcs/cog/passive_ability_engineer.lua

PassiveAbilityEngineer = class(PassiveAbilityEngineer)

local var_0_0 = Unit.alive
local var_0_1 = Unit.set_flow_variable
local var_0_2 = Unit.flow_event
local var_0_3 = GameSession.set_game_object_field
local var_0_4 = GameSession.game_object_field
local var_0_5 = 1
local var_0_6 = 0.05
local var_0_7 = 0.01
local var_0_8 = 0.2
local var_0_9 = 5
local var_0_10 = 10
local var_0_11 = 0.3
local var_0_12 = 1

function PassiveAbilityEngineer.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._owner_unit = arg_1_2
	arg_1_0._player = arg_1_3.player
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._player_unique_id = arg_1_3.player:unique_id()
	arg_1_0._world = arg_1_1.world
	arg_1_0._heat_cooldown_pause_t = 0
	arg_1_0._weapon_visual_heat = 0
	arg_1_0._prev_weapon_visual_heat = 0
	arg_1_0._visual_heat_cooldown_speed = WeaponUtils.get_weapon_template("bardin_engineer_career_skill_weapon").visual_heat_cooldown_speed
	arg_1_0._heat_particles_spawned = false
	arg_1_0._last_ability_charge = 0
	arg_1_0._wind_down_progress = 0
	arg_1_0._wind_down_cooldown_pause_t = 0
	arg_1_0._is_local_player = arg_1_0._player.local_player
	arg_1_0._game = Managers.state.network:game()
end

function PassiveAbilityEngineer.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._inventory_extension = ScriptUnit.has_extension(arg_2_2, "inventory_system")
	arg_2_0._career_extension = ScriptUnit.has_extension(arg_2_2, "career_system")
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	arg_2_0._talent_extension = ScriptUnit.extension(arg_2_2, "talent_system")

	arg_2_0:_register_events()
end

function PassiveAbilityEngineer.destroy(arg_3_0)
	arg_3_0:_unregister_events()

	arg_3_0._game_object_id = nil
end

function PassiveAbilityEngineer._register_events(arg_4_0)
	Managers.state.event:register(arg_4_0, "on_engineer_weapon_fire", "on_engineer_weapon_fire")
	Managers.state.event:register(arg_4_0, "on_engineer_weapon_spin_up", "on_engineer_weapon_spin_up")
	Managers.state.event:register(arg_4_0, "level_start_local_player_spawned", "on_level_start_local_player_spawned")
	Managers.state.event:register(arg_4_0, "on_talents_changed", "on_talents_changed")
end

function PassiveAbilityEngineer.game_object_initialized(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:on_talents_changed(arg_5_1, arg_5_0._talent_extension, true)
end

function PassiveAbilityEngineer._unregister_events(arg_6_0)
	if Managers.state.event then
		Managers.state.event:unregister("on_engineer_weapon_fire", arg_6_0)
		Managers.state.event:unregister("on_engineer_weapon_spin_up", arg_6_0)
		Managers.state.event:unregister("level_start_local_player_spawned", arg_6_0)
		Managers.state.event:unregister("on_talents_changed", arg_6_0)
	end
end

function PassiveAbilityEngineer.update(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._game_object_id
	local var_7_1 = arg_7_0._game

	if var_7_1 and var_7_0 then
		if arg_7_0._is_local_player then
			local var_7_2 = arg_7_0._weapon_visual_heat

			if arg_7_2 > arg_7_0._heat_cooldown_pause_t then
				var_7_2 = math.clamp(var_7_2 - arg_7_0._visual_heat_cooldown_speed * arg_7_1, 0, 1)
			end

			if arg_7_2 > arg_7_0._wind_down_cooldown_pause_t then
				arg_7_0._wind_down_progress = math.clamp(math.lerp(arg_7_0._wind_down_progress, 0, var_0_12 * arg_7_1), 0, 1)
			end

			if arg_7_0._prev_weapon_visual_heat ~= var_7_2 then
				arg_7_0._prev_weapon_visual_heat = var_7_2
				arg_7_0._weapon_visual_heat = var_7_2

				var_0_3(var_7_1, var_7_0, "visual_heat", var_7_2)
			end
		elseif arg_7_0._game_object_id then
			local var_7_3 = var_0_4(var_7_1, var_7_0, "visual_heat")

			arg_7_0._weapon_visual_heat = math.clamp(math.lerp(arg_7_0._weapon_visual_heat, var_7_3, var_0_9 * arg_7_1), 0, 1)
		end
	end

	local var_7_4 = arg_7_0._inventory_extension
	local var_7_5 = var_7_4:get_wielded_slot_data()

	if var_7_5 and var_7_5.id == "slot_career_skill_weapon" then
		local var_7_6 = var_7_4:equipment()

		arg_7_0:_update_career_weapon_particles(var_7_4)
		arg_7_0:_update_career_weapon(var_7_6.right_hand_wielded_unit)
		arg_7_0:_update_career_weapon(var_7_6.right_hand_wielded_unit_3p)
		arg_7_0:_update_weapon_anim_variables(arg_7_1)
	else
		arg_7_0._heat_particles_spawned = false
		arg_7_0._wind_down_progress = 0
	end
end

function PassiveAbilityEngineer._update_career_weapon_particles(arg_8_0, arg_8_1)
	if not arg_8_0._heat_particles_spawned and arg_8_0._weapon_visual_heat >= var_0_6 then
		arg_8_1:start_weapon_fx("heat_shimmer")

		arg_8_0._heat_particles_spawned = true
	elseif arg_8_0._heat_particles_spawned and arg_8_0._weapon_visual_heat <= var_0_7 then
		arg_8_1:stop_weapon_fx("heat_shimmer")

		arg_8_0._heat_particles_spawned = false
	end
end

function PassiveAbilityEngineer._update_career_weapon(arg_9_0, arg_9_1)
	if not arg_9_1 or not var_0_0(arg_9_1) then
		return
	end

	var_0_1(arg_9_1, "visual_heat", arg_9_0._weapon_visual_heat)
	var_0_2(arg_9_1, "lua_update_visual_heat")
end

function PassiveAbilityEngineer._update_weapon_anim_variables(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._first_person_extension

	if var_10_0 then
		local var_10_1 = arg_10_0._career_extension:current_ability_cooldown_percentage()
		local var_10_2 = math.clamp(math.lerp(arg_10_0._last_ability_charge, var_10_1, arg_10_1 * var_0_10), 0, 1)

		arg_10_0._last_ability_charge = var_10_2

		var_10_0:animation_set_variable("ammo_count", var_10_2)
		var_10_0:animation_set_variable("wind_down_progress", arg_10_0._wind_down_progress)
	end
end

function PassiveAbilityEngineer.on_engineer_weapon_fire(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._weapon_visual_heat + (arg_11_1 or 0)

	arg_11_0._weapon_visual_heat = math.clamp(var_11_0, 0, var_0_8)

	local var_11_1 = Managers.time:time("game")

	arg_11_0._heat_cooldown_pause_t = var_11_1 + var_0_5
	arg_11_0._wind_down_progress = 1
	arg_11_0._wind_down_cooldown_pause_t = var_11_1 + var_0_11
end

function PassiveAbilityEngineer.on_engineer_weapon_spin_up(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = Managers.time:time("game")

	if not arg_12_2 then
		arg_12_1 = (arg_12_1 or 0) / 2 + 0.5
	end

	arg_12_0._wind_down_progress = math.max(arg_12_1 or 0, arg_12_0._wind_down_progress)
	arg_12_0._wind_down_cooldown_pause_t = var_12_0 + var_0_11
end

function PassiveAbilityEngineer.on_level_start_local_player_spawned(arg_13_0, arg_13_1)
	if arg_13_0._is_local_player and not arg_13_0._game_object_id then
		arg_13_0:create_game_object()
	end
end

function PassiveAbilityEngineer.create_game_object(arg_14_0)
	local var_14_0 = Managers.state.network
	local var_14_1 = arg_14_0._owner_unit
	local var_14_2 = var_14_0:unit_game_object_id(var_14_1)
	local var_14_3 = {
		go_type = NetworkLookup.go_types.engineer_career_data,
		unit_game_object_id = var_14_2,
		visual_heat = arg_14_0._weapon_visual_heat
	}
	local var_14_4 = callback(arg_14_0, "cb_game_session_disconnect")

	arg_14_0._game_object_id = var_14_0:create_game_object("engineer_career_data", var_14_3, var_14_4)
end

function PassiveAbilityEngineer.on_talents_changed(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_1 ~= arg_15_0._owner_unit then
		return
	end

	arg_15_0:_add_5_2_bombs()
end

function PassiveAbilityEngineer._add_5_2_bombs(arg_16_0)
	if not arg_16_0._is_server then
		return
	end

	if not arg_16_0._talent_extension:has_talent("bardin_engineer_upgraded_grenades") then
		return
	end

	local var_16_0 = arg_16_0._player:unique_id()
	local var_16_1 = Managers.party:get_status_from_unique_id(var_16_0)

	if not global_is_inside_inn and var_16_1.game_mode_data._engineer_upgraded_grenades_added then
		return
	end

	var_16_1.game_mode_data._engineer_upgraded_grenades_added = true

	local var_16_2 = "grenade_frag_01"
	local var_16_3 = "slot_grenade"
	local var_16_4 = arg_16_0._inventory_extension
	local var_16_5 = CareerConstants.dr_engineer.num_starting_bombs

	if Managers.mechanism:current_mechanism_name() == "versus" then
		var_16_5 = 1
	end

	for iter_16_0 = var_16_4:get_total_item_count(var_16_3) + 1, var_16_5 do
		local var_16_6 = NetworkConstants.invalid_game_object_id
		local var_16_7 = Managers.state.unit_storage:go_id(arg_16_0._owner_unit)
		local var_16_8 = NetworkLookup.equipment_slots[var_16_3]
		local var_16_9 = NetworkLookup.item_names[var_16_2]

		Managers.state.network.network_transmit:send_rpc_server("rpc_give_equipment", var_16_6, var_16_7, var_16_8, var_16_9, Vector3.zero())
	end
end

function PassiveAbilityEngineer.set_career_game_object_id(arg_17_0, arg_17_1)
	arg_17_0._game_object_id = arg_17_1
end

function PassiveAbilityEngineer.cb_game_session_disconnect(arg_18_0)
	arg_18_0._game_object_id = nil
end
