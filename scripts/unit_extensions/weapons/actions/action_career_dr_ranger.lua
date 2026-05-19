-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_dr_ranger.lua

ActionCareerDRRanger = class(ActionCareerDRRanger, ActionBase)

function ActionCareerDRRanger.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerDRRanger.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0.input_extension = ScriptUnit.extension(arg_1_4, "input_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
end

function ActionCareerDRRanger.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionCareerDRRanger.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0.current_action = arg_2_1
	arg_2_0.action_time_started = arg_2_2
	arg_2_0.thrown = nil
	arg_2_0._cooldown_started = false

	local var_2_0 = arg_2_1.slot_to_wield

	arg_2_0.inventory_extension:wield(var_2_0)

	arg_2_0.power_level = arg_2_4

	ScriptUnit.extension(arg_2_0.owner_unit, "inventory_system"):check_and_drop_pickups("career_ability")
end

function ActionCareerDRRanger._create_smoke_screen(arg_3_0)
	local var_3_0 = arg_3_0.owner_unit
	local var_3_1 = Managers.state.network.network_transmit
	local var_3_2 = ScriptUnit.extension(var_3_0, "status_system")
	local var_3_3 = ScriptUnit.extension(var_3_0, "career_system")
	local var_3_4 = ScriptUnit.extension(var_3_0, "buff_system")
	local var_3_5 = "bardin_ranger_activated_ability"
	local var_3_6 = ScriptUnit.extension(var_3_0, "talent_system")

	if var_3_6:has_talent("bardin_ranger_ability_free_grenade", "dwarf_ranger", true) then
		var_3_4:add_buff("bardin_ranger_ability_free_grenade_buff")
	end

	if var_3_6:has_talent("bardin_ranger_smoke_attack", "dwarf_ranger", true) then
		var_3_4:add_buff("bardin_ranger_smoke_attack")
		var_3_4:add_buff("bardin_ranger_smoke_heal")
	end

	if var_3_6:has_talent("bardin_ranger_activated_ability_stealth_outside_of_smoke", "dwarf_ranger", true) then
		var_3_4:add_buff("bardin_ranger_activated_ability_stealth_outside_of_smoke")

		return
	end

	var_3_4:add_buff(var_3_5, {
		attacker_unit = var_3_0
	})
end

function ActionCareerDRRanger._play_vo(arg_4_0)
	local var_4_0 = arg_4_0.owner_unit
	local var_4_1 = ScriptUnit.extension_input(var_4_0, "dialogue_system")
	local var_4_2 = FrameTable.alloc_table()

	var_4_1:trigger_networked_dialogue_event("activate_ability", var_4_2)
end

function ActionCareerDRRanger.client_owner_post_update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_0.thrown then
		return
	end

	local var_5_0 = arg_5_0.current_action

	if arg_5_2 >= arg_5_0.action_time_started + var_5_0.throw_time then
		arg_5_0:_throw()
	end
end

function ActionCareerDRRanger._stagger_explosion(arg_6_0)
	local var_6_0 = arg_6_0.owner_unit
	local var_6_1 = arg_6_0.world
	local var_6_2 = arg_6_0.is_server
	local var_6_3 = Managers.state.network
	local var_6_4 = var_6_3.network_transmit
	local var_6_5 = var_6_3:unit_game_object_id(var_6_0)
	local var_6_6 = "bardin_ranger_activated_ability_stagger"
	local var_6_7 = ExplosionUtils.get_template(var_6_6)
	local var_6_8 = 1
	local var_6_9 = "career_ability"
	local var_6_10 = false
	local var_6_11 = POSITION_LOOKUP[var_6_0]
	local var_6_12 = Quaternion.identity()
	local var_6_13 = NetworkLookup.explosion_templates[var_6_6]
	local var_6_14 = NetworkLookup.damage_sources[var_6_9]

	if var_6_2 then
		var_6_4:send_rpc_clients("rpc_create_explosion", var_6_5, false, var_6_11, var_6_12, var_6_13, var_6_8, var_6_14, arg_6_0.power_level, false, var_6_5)
	else
		var_6_4:send_rpc_server("rpc_create_explosion", var_6_5, false, var_6_11, var_6_12, var_6_13, var_6_8, var_6_14, arg_6_0.power_level, false, var_6_5)
	end

	DamageUtils.create_explosion(var_6_1, var_6_0, var_6_11, var_6_12, var_6_7, var_6_8, var_6_9, var_6_2, var_6_10, var_6_0, arg_6_0.power_level, false, var_6_0)
end

function ActionCareerDRRanger._throw(arg_7_0)
	arg_7_0:_create_smoke_screen()
	arg_7_0:_stagger_explosion()
	arg_7_0:_play_vo()

	arg_7_0.thrown = true
end

function ActionCareerDRRanger.finish(arg_8_0, arg_8_1)
	ActionCareerDRRanger.super.finish(arg_8_0, arg_8_1)

	if not arg_8_0.thrown then
		arg_8_0:_throw()
	end

	if not arg_8_0._cooldown_started then
		arg_8_0._cooldown_started = true

		arg_8_0.career_extension:start_activated_ability_cooldown()
	end

	arg_8_0.inventory_extension:wield_previous_non_level_slot()
end
