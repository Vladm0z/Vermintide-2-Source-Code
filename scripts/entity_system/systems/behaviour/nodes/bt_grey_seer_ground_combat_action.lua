-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_grey_seer_ground_combat_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTGreySeerGroundCombatAction = class(BTGreySeerGroundCombatAction, BTNode)

function BTGreySeerGroundCombatAction.init(arg_1_0, ...)
	BTGreySeerGroundCombatAction.super.init(arg_1_0, ...)
end

BTGreySeerGroundCombatAction.name = "BTGreySeerGroundCombatAction"

function BTGreySeerGroundCombatAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0

	Managers.state.network:anim_event(arg_2_1, "idle_eat_warpstone")

	local var_2_1 = arg_2_2.current_phase
	local var_2_2 = arg_2_2.breed
	local var_2_3 = arg_2_2.spell_data or {}

	var_2_3.warp_lightning_spell_cooldown = var_2_0.warp_lightning_spell_cooldown[var_2_1]
	var_2_3.vermintide_spell_cooldown = var_2_0.vermintide_spell_cooldown[var_2_1]
	var_2_3.teleport_spell_cooldown = var_2_0.teleport_spell_cooldown[var_2_1]
	var_2_3.warp_lightning_spell_timer = var_2_3.warp_lightning_spell_timer or arg_2_3 + 2
	var_2_3.vermintide_spell_timer = var_2_3.vermintide_spell_timer or arg_2_3 + 5
	var_2_3.teleport_spell_timer = var_2_3.teleport_spell_timer or arg_2_3 + 6
	arg_2_2.spell_data = var_2_3

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local var_2_4 = arg_2_2.final_phase_data or {}

	arg_2_2.final_phase_data = var_2_4
	var_2_4.num_teleports = var_2_4.num_teleports or 1
	var_2_4.spawn_allies_timer = var_2_4.spawn_allies_timer or arg_2_3 + 3
	var_2_4.teleport_timer = var_2_4.teleport_timer or arg_2_3
	ScriptUnit.extension(arg_2_1, "health_system").is_invincible = false
end

function BTGreySeerGroundCombatAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.action = nil

	arg_3_2.navigation_extension:set_enabled(true)
end

local var_0_0 = Unit.alive

function BTGreySeerGroundCombatAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_0:update_spells(arg_4_1, arg_4_2, arg_4_3) then
		arg_4_2.ready_to_summon = true

		return "done"
	else
		return "running"
	end
end

function BTGreySeerGroundCombatAction.update_spells(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_2.current_phase
	local var_5_1 = false
	local var_5_2 = POSITION_LOOKUP[arg_5_1]
	local var_5_3 = arg_5_2.target_unit and var_5_2 - POSITION_LOOKUP[arg_5_2.target_unit]

	arg_5_0:update_warp_lightning_spell(arg_5_1, arg_5_2, arg_5_3, var_5_2, var_5_3)
	arg_5_0:update_vermintide_spell(arg_5_1, arg_5_2, arg_5_3, var_5_2, var_5_3)

	if var_5_0 < 4 then
		var_5_1 = arg_5_0:update_regular_spells(arg_5_1, arg_5_2, arg_5_3)
	elseif var_5_0 == 4 then
		var_5_1 = arg_5_0:update_final_phase(arg_5_1, arg_5_2, arg_5_3)
	end

	return var_5_1
end

function BTGreySeerGroundCombatAction.update_final_phase(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_2.action
	local var_6_1
	local var_6_2 = arg_6_2.final_phase_data
	local var_6_3 = ScriptUnit.extension_input(arg_6_1, "dialogue_system")
	local var_6_4 = arg_6_2.current_phase
	local var_6_5 = var_6_2.num_teleports or 1
	local var_6_6 = arg_6_2.defensive_teleport_positions[var_6_5]:unbox()
	local var_6_7 = var_6_2.teleport_timer
	local var_6_8 = var_6_2.special_spawn_timer

	if var_6_4 == 4 and (var_6_7 and var_6_7 < arg_6_3 or arg_6_2.stagger_count >= var_6_0.staggers_until_teleport) then
		local var_6_9 = LocomotionUtils.pos_on_mesh(arg_6_2.nav_world, var_6_6, 1, 1)

		arg_6_2.quick_teleport_exit_pos = Vector3Box(var_6_9)
		arg_6_2.quick_teleport = true
		var_6_2.teleport_timer = arg_6_3 + var_6_0.final_phase_teleport_cooldown
		arg_6_2.current_spell_name = "teleport"
		arg_6_2.stagger_count = 0
		var_6_2.num_teleports = var_6_2.num_teleports and var_6_2.num_teleports + 1 or 1

		if var_6_2.num_teleports > 4 then
			var_6_2.num_teleports = 1
		end

		local var_6_10 = FrameTable.alloc_table()

		var_6_3:trigger_networked_dialogue_event("egs_teleport_away", var_6_10)

		return true
	end

	if arg_6_3 > var_6_2.spawn_allies_timer then
		arg_6_0:spawn_allies(arg_6_1, arg_6_2, arg_6_3)

		var_6_2.spawn_allies_timer = arg_6_3 + var_6_0.spawn_allies_cooldown

		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_6_1, "egs_summon", DialogueSettings.default_hear_distance)

		local var_6_11 = FrameTable.alloc_table()

		var_6_3:trigger_networked_dialogue_event("egs_cast_vermintide", var_6_11)
	end

	return (arg_6_0:update_regular_spells(arg_6_1, arg_6_2, arg_6_3))
end

function BTGreySeerGroundCombatAction.update_regular_spells(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_2.spell_data
	local var_7_1
	local var_7_2 = ScriptUnit.extension_input(arg_7_1, "dialogue_system")
	local var_7_3 = var_7_0.warp_lightning_spell_timer
	local var_7_4 = var_7_0.vermintide_spell_timer
	local var_7_5 = var_7_0.teleport_spell_timer
	local var_7_6 = arg_7_2.current_phase

	if var_7_3 < arg_7_3 then
		arg_7_2.current_spell_name = "warp_lightning"
		var_7_1 = true
		var_7_0.warp_lightning_spell_timer = arg_7_3 + var_7_0.warp_lightning_spell_cooldown

		local var_7_7 = FrameTable.alloc_table()

		var_7_2:trigger_networked_dialogue_event("egs_cast_lightning", var_7_7)
	elseif var_7_4 < arg_7_3 then
		arg_7_2.current_spell_name = "vermintide"
		var_7_1 = true
		var_7_0.vermintide_spell_timer = arg_7_3 + var_7_0.vermintide_spell_cooldown

		local var_7_8 = FrameTable.alloc_table()

		var_7_2:trigger_networked_dialogue_event("egs_cast_vermintide", var_7_8)
	end

	return var_7_1
end

function BTGreySeerGroundCombatAction.update_warp_lightning_spell(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_2.magic_missile_data

	var_8_0.throw_pos:store(arg_8_4 + Vector3.up() * 2)

	if arg_8_5 then
		var_8_0.target_direction:store(arg_8_5)
	end
end

function BTGreySeerGroundCombatAction.update_vermintide_spell(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = arg_9_2.plague_wave_data

	var_9_0.target_starting_pos:store(arg_9_4)

	if arg_9_5 then
		var_9_0.plague_wave_rot:store(Quaternion.look(arg_9_5))
	end
end

function BTGreySeerGroundCombatAction.update_teleport_spell(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_2.quick_teleport_timer or arg_10_3

	arg_10_2.quick_teleport_timer = var_10_0

	if var_10_0 and var_10_0 < arg_10_3 then
		local var_10_1 = arg_10_2.skulk_data or {}

		arg_10_2.skulk_data = var_10_1
		var_10_1.direction = var_10_1.direction or 1 - math.random(0, 1) * 2
		var_10_1.radius = var_10_1.radius or arg_10_2.target_dist

		local var_10_2 = BTChaosSorcererPlagueSkulkAction:get_skulk_target(arg_10_1, arg_10_2, true)

		if var_10_2 then
			arg_10_2.quick_teleport_exit_pos = Vector3Box(var_10_2)
			arg_10_2.quick_teleport = true
			arg_10_2.move_pos = nil
			arg_10_2.quick_teleport_timer = arg_10_3 + 2.5
		end
	end
end

function BTGreySeerGroundCombatAction.spawn_allies(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = Managers.state.difficulty:get_difficulty()
	local var_11_1 = arg_11_2.action
	local var_11_2 = true
	local var_11_3 = true
	local var_11_4 = var_11_1.difficulty_spawn and var_11_1.difficulty_spawn[var_11_0] or var_11_1.spawn
	local var_11_5
	local var_11_6 = var_11_1.terror_event_id
	local var_11_7 = Managers.state.conflict
	local var_11_8 = arg_11_2.side.side_id

	var_11_7.horde_spawner:execute_event_horde(arg_11_3, var_11_6, var_11_8, var_11_4, var_11_5, var_11_3, nil, var_11_2)
end
