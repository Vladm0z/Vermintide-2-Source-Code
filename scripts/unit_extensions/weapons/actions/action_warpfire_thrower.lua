-- chunkname: @scripts/unit_extensions/weapons/actions/action_warpfire_thrower.lua

ActionWarpfireThrower = class(ActionWarpfireThrower, ActionBase)

function ActionWarpfireThrower.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionWarpfireThrower.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0.buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	arg_1_0.targets = {}
	arg_1_0.old_targets = {}
	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0.stop_sound_event = "Stop_player_combat_weapon_drakegun_flamethrower_shoot"
	arg_1_0.unit_id = Managers.state.network.unit_storage:go_id(arg_1_4)
	arg_1_0.weapon_unit = arg_1_7
	arg_1_0.owner_unit = arg_1_4
	arg_1_0.physics_world = World.physics_world(arg_1_1)
	arg_1_0._current_flame_time = 0
end

function ActionWarpfireThrower.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionWarpfireThrower.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0.current_action = arg_2_1
	arg_2_0.state = "shooting"
	arg_2_0.overcharge_timer = 0

	local var_2_0 = PlayerUnitStatusSettings.overcharge_values[arg_2_0.current_action.overcharge_type]

	arg_2_0.overcharge_extension:add_charge(var_2_0)
end

function ActionWarpfireThrower.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0.owner_unit
	local var_3_1 = arg_3_0.current_action

	arg_3_0.overcharge_timer = arg_3_0.overcharge_timer + arg_3_1

	if arg_3_0.state == "shooting" and arg_3_0.overcharge_timer >= var_3_1.overcharge_interval then
		local var_3_2 = PlayerUnitStatusSettings.overcharge_values[var_3_1.overcharge_type]

		arg_3_0.overcharge_extension:add_charge(var_3_2)

		arg_3_0.overcharge_timer = 0
	end

	local var_3_3 = arg_3_0.overcharge_extension.max_value - 1 <= arg_3_0.overcharge_extension:get_overcharge_value()

	if arg_3_0.state == "shooting" and not var_3_3 then
		arg_3_0._current_flame_time = arg_3_1 + arg_3_0._current_flame_time or 0

		if arg_3_2 > (arg_3_0.next_fire_tick or 0) then
			arg_3_0:fire(var_3_0, var_3_1, arg_3_2)

			arg_3_0.next_fire_tick = arg_3_2 + var_3_1.shoot_warpfire_close_attack_cooldown
		end
	elseif var_3_3 and arg_3_0.state == "shooting" then
		arg_3_0.state = "shot"

		arg_3_0.weapon_extension:stop_action("action_complete")
	end
end

function ActionWarpfireThrower.finish(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0.state ~= "shot" then
		arg_4_0:_proc_spell_used(arg_4_0.buff_extension)
	end
end

function ActionWarpfireThrower._stop_fx(arg_5_0)
	local var_5_0 = ScriptUnit.has_extension(arg_5_0.owner_unit, "hud_system")

	if var_5_0 then
		var_5_0.show_critical_indication = false
	end
end

function ActionWarpfireThrower.destroy(arg_6_0)
	if arg_6_0._flamethrower_effect then
		World.destroy_particles(arg_6_0.world, arg_6_0._flamethrower_effect)

		arg_6_0._flamethrower_effect = nil
	end
end

function ActionWarpfireThrower.fire(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = Managers.state.entity:system("buff_system")
	local var_7_1 = EnemyCharacterStateHelper.get_enemies_in_line_of_sight(arg_7_1, arg_7_0.first_person_unit, arg_7_0.physics_world)

	if not var_7_1 then
		return
	end

	for iter_7_0 = 1, #var_7_1 do
		local var_7_2 = var_7_1[iter_7_0]
		local var_7_3 = var_7_2.unit

		if DamageUtils.is_enemy(arg_7_1, var_7_3) then
			local var_7_4 = var_7_2.distance <= arg_7_2.shoot_warpfire_close_attack_range and arg_7_2.buff_name_close or arg_7_2.buff_name_far

			var_7_0:add_buff(var_7_3, var_7_4, arg_7_1)
			var_7_0:add_buff(var_7_3, "warpfire_thrower_fire_slowdown", arg_7_1)
		end
	end
end
