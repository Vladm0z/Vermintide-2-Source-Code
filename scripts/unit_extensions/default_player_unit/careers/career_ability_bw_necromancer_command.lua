-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_bw_necromancer_command.lua

local var_0_0 = {
	"rpc_necromancer_command_sacrifice",
	"rpc_necromancer_command_charge"
}
local var_0_1 = table.mirror_array({
	"pet",
	"player",
	"enemy"
})

CareerAbilityBWNecromancerCommand = class(CareerAbilityBWNecromancerCommand)

function CareerAbilityBWNecromancerCommand.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._owner_unit = arg_1_2
	arg_1_0._player = arg_1_3.player
	arg_1_0._is_local = arg_1_3.player.local_player
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._command_explosion_params = {
		source_attacker_unit = arg_1_2
	}
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._network_event_delegate = arg_1_0._network_transmit.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_0))

	arg_1_0._unit_storage = arg_1_1.unit_storage
	arg_1_0._outline_data = nil
	arg_1_0._target_unit = nil
end

function CareerAbilityBWNecromancerCommand.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	arg_2_0._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	arg_2_0._buff_system = Managers.state.entity:system("buff_system")

	if arg_2_0._is_local then
		arg_2_0._input_extension = ScriptUnit.extension(arg_2_2, "input_system")
		arg_2_0._fp_extension = ScriptUnit.extension(arg_2_2, "first_person_system")
		arg_2_0._inventory_extension = ScriptUnit.has_extension(arg_2_2, "inventory_system")
	end

	if arg_2_0._is_local or arg_2_0._is_server then
		arg_2_0._commander_extension = ScriptUnit.extension(arg_2_2, "ai_commander_system")
	end

	Managers.state.event:register(arg_2_0, "on_talents_changed", "_on_talents_changed")
	arg_2_0:_on_talents_changed(arg_2_2, ScriptUnit.extension(arg_2_2, "talent_system"))
end

function CareerAbilityBWNecromancerCommand._on_talents_changed(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1 ~= arg_3_0._owner_unit then
		return
	end

	arg_3_0._has_charge = arg_3_2:has_talent("sienna_necromancer_6_3")

	if arg_3_0._is_local then
		arg_3_0:_cleanup_talent_buffs(arg_3_1)
		arg_3_0:_add_talent_buffs(arg_3_1)
	end
end

function CareerAbilityBWNecromancerCommand.update(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_0._is_local and not arg_4_0._is_server then
		return
	end

	arg_4_0:_update_outlines(arg_4_2)

	if arg_4_0._is_local then
		arg_4_0:_update_vent_command_target(arg_4_2)
	end
end

function CareerAbilityBWNecromancerCommand.destroy(arg_5_0)
	arg_5_0._network_event_delegate:unregister(arg_5_0)

	if Managers.state.event then
		Managers.state.event:unregister("on_talents_changed", arg_5_0)
	end
end

function CareerAbilityBWNecromancerCommand._update_outlines(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._outline_data

	if var_6_0 then
		local var_6_1 = ScriptUnit.has_extension(var_6_0.unit, "status_system")

		if not HEALTH_ALIVE[var_6_0.unit] or var_6_1 and var_6_1:is_invisible() or var_6_0.command_type == var_0_1.player and not var_6_1:is_knocked_down() then
			if ALIVE[var_6_0.unit] then
				var_6_0.extension:remove_outline(var_6_0.id)
			end

			arg_6_0._outline_data = nil
		end
	end
end

function CareerAbilityBWNecromancerCommand._command_sacrifice_pet(arg_7_0, arg_7_1)
	local var_7_0 = Unit.has_node(arg_7_1, "j_spine") and Unit.node(arg_7_1, "j_spine") or 0
	local var_7_1 = Managers.state.network
	local var_7_2 = NetworkLookup.effects["fx/necromancer_skeleton_sacrifice"]
	local var_7_3 = var_7_1:unit_game_object_id(arg_7_1)

	var_7_1:rpc_play_particle_effect(nil, var_7_2, var_7_3, var_7_0, Vector3.zero(), Quaternion.identity(), false)

	local var_7_4 = BLACKBOARDS[arg_7_1].locomotion_extension

	var_7_4.death_velocity_boxed = Vector3Box(var_7_4:current_velocity())

	AiUtils.kill_unit(arg_7_1)

	if arg_7_0._has_explode then
		local var_7_5 = POSITION_LOOKUP[arg_7_1]
		local var_7_6 = arg_7_0._owner_unit
		local var_7_7 = ScriptUnit.has_extension(var_7_6, "career_system")
		local var_7_8 = var_7_7 and var_7_7:get_career_power_level() or DefaultPowerLevel

		Managers.state.entity:system("area_damage_system"):create_explosion(var_7_6, var_7_5, Quaternion.identity(), "sienna_necromancer_passive_explosion", 1, "buff", var_7_8, false)
	end
end

function CareerAbilityBWNecromancerCommand._trigger_charge_sound(arg_8_0)
	arg_8_0._fp_extension:play_hud_sound_event("Play_career_necro_skeleton_charge")
end

function CareerAbilityBWNecromancerCommand._start_charge_cooldown(arg_9_0)
	local var_9_0 = arg_9_0._buff_extension
	local var_9_1 = var_9_0:get_buff_type("sienna_necromancer_6_3_available_charge")

	arg_9_0._charge_cooldown_id = var_9_0:add_buff("sienna_necromancer_6_3_cooldown_charge")

	var_9_0:remove_buff(var_9_1.id)
end

function CareerAbilityBWNecromancerCommand._add_talent_buffs(arg_10_0, arg_10_1)
	if arg_10_0._has_charge then
		arg_10_0._buff_extension:add_buff("sienna_necromancer_6_3_available_charge")
	end
end

function CareerAbilityBWNecromancerCommand._cleanup_talent_buffs(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._buff_extension

	if arg_11_0._charge_cooldown_id then
		var_11_0:remove_buff(arg_11_0._charge_cooldown_id)

		arg_11_0._charge_cooldown_id = nil
	end

	local var_11_1 = var_11_0:get_buff_type("sienna_necromancer_6_3_available_charge")

	if var_11_1 then
		var_11_0:remove_buff(arg_11_1, var_11_1.id)
	end
end

function CareerAbilityBWNecromancerCommand._add_outline(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = ScriptUnit.has_extension(arg_12_1, "outline_system")

	if var_12_0 then
		local var_12_1 = arg_12_0._outline_data

		if var_12_1 and ALIVE[var_12_1.unit] then
			var_12_1.extension:remove_outline(var_12_1.id)
		end

		local var_12_2 = var_12_0:add_outline(OutlineSettings.templates.necromancer_command)

		arg_12_0._outline_data = {
			id = var_12_2,
			unit = arg_12_1,
			extension = var_12_0,
			command_type = arg_12_2
		}
	end
end

function CareerAbilityBWNecromancerCommand.command_attack_enemy(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if not HEALTH_ALIVE[arg_13_1] then
		return
	end

	if arg_13_0._is_local then
		Managers.telemetry_events:necromancer_used_command_item(arg_13_0._player, "attack")
	end

	local var_13_0 = POSITION_LOOKUP[arg_13_0._owner_unit]
	local var_13_1 = math.huge
	local var_13_2
	local var_13_3 = arg_13_0._commander_extension
	local var_13_4 = var_13_3:get_controlled_units()

	for iter_13_0 in pairs(var_13_4) do
		local var_13_5 = Unit.get_data(iter_13_0, "breed")
		local var_13_6 = var_13_3:command_state(iter_13_0) == CommandStates.StandingGround

		if var_13_5.name ~= "pet_skeleton_with_shield" or not var_13_6 then
			local var_13_7 = POSITION_LOOKUP[iter_13_0]

			if var_13_7 then
				var_13_3:command_attack(iter_13_0, arg_13_1)

				local var_13_8 = Vector3.distance_squared(var_13_7, var_13_0)

				if var_13_8 < var_13_1 then
					var_13_1 = var_13_8
					var_13_2 = iter_13_0
				end
			end
		end
	end

	arg_13_0:_play_command_sound()

	if var_13_2 then
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_career_necro_skeleton_charge", var_13_2)
	end

	arg_13_0:_add_outline(arg_13_1, var_0_1.enemy)

	if arg_13_2 then
		arg_13_0:_trigger_charge_sound()
		arg_13_0:_start_charge_cooldown()

		local var_13_9 = arg_13_0._unit_storage:go_id(arg_13_1)

		arg_13_0._network_transmit:send_rpc_server("rpc_necromancer_command_charge", var_13_9)
	end
end

function CareerAbilityBWNecromancerCommand.any_skeleton_targeting_enemy(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._commander_extension:get_controlled_units()

	for iter_14_0 in pairs(var_14_0) do
		local var_14_1 = BLACKBOARDS[iter_14_0]

		if var_14_1.commander_target == arg_14_1 or var_14_1.target_unit == arg_14_1 then
			return true
		end
	end
end

function CareerAbilityBWNecromancerCommand.rpc_necromancer_command_charge(arg_15_0, arg_15_1, arg_15_2)
	if CHANNEL_TO_PEER_ID[arg_15_1] ~= arg_15_0._player.peer_id then
		return
	end

	local var_15_0 = arg_15_0._unit_storage:unit(arg_15_2)
	local var_15_1 = arg_15_0._commander_extension:get_controlled_units()

	for iter_15_0 in pairs(var_15_1) do
		local var_15_2 = BLACKBOARDS[iter_15_0]

		if var_15_2.breed.name == "pet_skeleton_armored" then
			var_15_2.charge_target = var_15_0
		end
	end
end

function CareerAbilityBWNecromancerCommand.command_sacrifice(arg_16_0, arg_16_1)
	if arg_16_0._is_local then
		Managers.telemetry_events:necromancer_used_command_item(arg_16_0._player, "sacrifice")
	end

	if not arg_16_0._is_server then
		local var_16_0 = arg_16_0._unit_storage:go_id(arg_16_1)

		arg_16_0._network_transmit:send_rpc_server("rpc_necromancer_command_sacrifice", var_16_0, var_0_1.pet)

		return
	end

	arg_16_0:_command_sacrifice_pet(arg_16_1)
end

function CareerAbilityBWNecromancerCommand.rpc_necromancer_command_sacrifice(arg_17_0, arg_17_1, arg_17_2)
	if CHANNEL_TO_PEER_ID[arg_17_1] ~= arg_17_0._player.peer_id then
		return
	end

	local var_17_0 = arg_17_0._unit_storage:unit(arg_17_2)

	arg_17_0:command_sacrifice(var_17_0)
end

function CareerAbilityBWNecromancerCommand._update_vent_command_target(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._vent_command_target
	local var_18_1 = arg_18_0._inventory_extension:get_wielded_slot_item_template()
	local var_18_2 = var_18_1 and var_18_1.is_command_utility_weapon
	local var_18_3
	local var_18_4

	if var_18_2 then
		local var_18_5, var_18_6 = arg_18_0._commander_extension:hovered_friendly_unit()

		var_18_4 = not var_18_5 and not not var_18_6

		if not var_18_5 then
			local var_18_7 = arg_18_0._commander_extension:get_controlled_units()
			local var_18_8 = math.huge

			for iter_18_0, iter_18_1 in pairs(var_18_7) do
				local var_18_9 = iter_18_1.template.duration

				if var_18_9 then
					local var_18_10 = (iter_18_1.start_t or math.huge) + var_18_9 - arg_18_1

					if var_18_10 < var_18_8 then
						var_18_8 = var_18_10
						var_18_5 = iter_18_0
					end
				end
			end
		end

		var_18_3 = var_18_5 or var_18_6
	end

	if arg_18_0._vent_outline_id and var_18_4 or var_18_3 ~= var_18_0 then
		if ALIVE[var_18_0] then
			local var_18_11 = ScriptUnit.has_extension(var_18_0, "outline_system")

			if var_18_11 then
				var_18_11:remove_outline(arg_18_0._vent_outline_id)

				arg_18_0._vent_outline_id = nil
			end
		end

		if var_18_3 and not var_18_4 then
			local var_18_12 = Managers.state.network:game()
			local var_18_13 = Managers.state.unit_storage:go_id(var_18_3)

			if var_18_13 then
				local var_18_14 = GameSession.game_object_field(var_18_12, var_18_13, "bt_action_name")

				if NetworkLookup.bt_action_names[var_18_14] ~= "spawn" then
					arg_18_0._vent_outline_id = ScriptUnit.extension(var_18_3, "outline_system"):add_outline(OutlineSettings.templates.necromancer_command)
				end
			end
		end
	end

	arg_18_0._vent_command_target = var_18_3
end

function CareerAbilityBWNecromancerCommand.vent_command_target(arg_19_0)
	return arg_19_0._vent_command_target
end

function CareerAbilityBWNecromancerCommand.command_stand_ground(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = table.keys(arg_20_0._commander_extension:get_controlled_units(), FrameTable.alloc_table())

	table.array_remove_if(var_20_0, function(arg_21_0)
		if arg_20_0._commander_extension:command_state(arg_21_0) == CommandStates.Following then
			return false
		end

		return Unit.get_data(arg_21_0, "breed").name == "pet_skeleton_armored"
	end)
	arg_20_0:_play_command_sound()

	if arg_20_0._is_local then
		Managers.telemetry_events:necromancer_used_command_item(arg_20_0._player, "defend")
	end

	local var_20_1 = Managers.state.entity:system("audio_system")

	for iter_20_0 = 1, #var_20_0 do
		local var_20_2 = var_20_0[iter_20_0]

		if ALIVE[var_20_2] then
			var_20_1:play_audio_unit_event("Play_career_necro_skeleton_defend", var_20_2)
		end
	end

	arg_20_0._commander_extension:command_stand_ground_group(var_20_0, arg_20_1, arg_20_2)
end

function CareerAbilityBWNecromancerCommand._play_command_sound(arg_22_0)
	if arg_22_0._fp_extension then
		arg_22_0._fp_extension:play_hud_sound_event("Play_weapon_necro_command_command")
	end
end
