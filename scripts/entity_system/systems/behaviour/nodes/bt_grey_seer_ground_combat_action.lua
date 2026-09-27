-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_grey_seer_ground_combat_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTGreySeerGroundCombatAction = class(BTGreySeerGroundCombatAction, BTNode)

BTGreySeerGroundCombatAction.init = function (arg_1_0, ...)
	-- function 1
	BTGreySeerGroundCombatAction.super.init(arg_1_0, ...)
end

BTGreySeerGroundCombatAction.name = "BTGreySeerGroundCombatAction"

BTGreySeerGroundCombatAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	Managers.state.network:anim_event(arg_2_1, "idle_eat_warpstone")

	local current_phase = arg_2_2.current_phase
	local breed = arg_2_2.breed
	local spell_data = arg_2_2.spell_data

	spell_data = spell_data or {}
	spell_data.warp_lightning_spell_cooldown = action_data.warp_lightning_spell_cooldown[current_phase]
	spell_data.vermintide_spell_cooldown = action_data.vermintide_spell_cooldown[current_phase]
	spell_data.teleport_spell_cooldown = action_data.teleport_spell_cooldown[current_phase]

	local warp_lightning_spell_timer = spell_data.warp_lightning_spell_timer

	warp_lightning_spell_timer = warp_lightning_spell_timer or arg_2_3 + 2
	spell_data.warp_lightning_spell_timer = warp_lightning_spell_timer

	local vermintide_spell_timer = spell_data.vermintide_spell_timer

	vermintide_spell_timer = vermintide_spell_timer or arg_2_3 + 5
	spell_data.vermintide_spell_timer = vermintide_spell_timer

	local teleport_spell_timer = spell_data.teleport_spell_timer

	teleport_spell_timer = teleport_spell_timer or arg_2_3 + 6
	spell_data.teleport_spell_timer = teleport_spell_timer
	arg_2_2.spell_data = spell_data

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local final_phase_data = arg_2_2.final_phase_data

	final_phase_data = final_phase_data or {}
	arg_2_2.final_phase_data = final_phase_data

	local num_teleports = final_phase_data.num_teleports

	num_teleports = num_teleports or 1
	final_phase_data.num_teleports = num_teleports

	local spawn_allies_timer = final_phase_data.spawn_allies_timer

	spawn_allies_timer = spawn_allies_timer or arg_2_3 + 3
	final_phase_data.spawn_allies_timer = spawn_allies_timer

	local teleport_timer = final_phase_data.teleport_timer

	teleport_timer = teleport_timer or arg_2_3
	final_phase_data.teleport_timer = teleport_timer
	ScriptUnit.extension(arg_2_1, "health_system").is_invincible = false
end

BTGreySeerGroundCombatAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.action = nil

	arg_3_2.navigation_extension:set_enabled(true)
end

local alive = Unit.alive

BTGreySeerGroundCombatAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not self:update_spells(arg_4_1, arg_4_2, arg_4_3) then
		arg_4_2.ready_to_summon = true

		return "done"
	else
		return "running"
	end
end

BTGreySeerGroundCombatAction.update_spells = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local current_phase = arg_5_2.current_phase
	local flag = false
	local var_5_2 = POSITION_LOOKUP[arg_5_1]
	local target_unit = arg_5_2.target_unit

	target_unit = not target_unit and var_5_2 - POSITION_LOOKUP[arg_5_2.target_unit]

	self:update_warp_lightning_spell(arg_5_1, arg_5_2, arg_5_3, var_5_2, target_unit)
	self:update_vermintide_spell(arg_5_1, arg_5_2, arg_5_3, var_5_2, target_unit)

	if current_phase < 4 then
		flag = self:update_regular_spells(arg_5_1, arg_5_2, arg_5_3)
	elseif current_phase == 4 then
		flag = self:update_final_phase(arg_5_1, arg_5_2, arg_5_3)
	end

	return flag
end

BTGreySeerGroundCombatAction.update_final_phase = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local action = arg_6_2.action
	local var_6_1
	local final_phase_data = arg_6_2.final_phase_data
	local extension_input = ScriptUnit.extension_input(arg_6_1, "dialogue_system")
	local current_phase = arg_6_2.current_phase
	local num_teleports = final_phase_data.num_teleports

	num_teleports = num_teleports or 1

	local unbox = arg_6_2.defensive_teleport_positions[num_teleports]:unbox()
	local teleport_timer = final_phase_data.teleport_timer
	local special_spawn_timer = final_phase_data.special_spawn_timer

	if not (current_phase ~= 4 or not teleport_timer or teleport_timer < arg_6_3 or not (arg_6_2.stagger_count >= action.staggers_until_teleport)) then
		local pos_on_mesh = LocomotionUtils.pos_on_mesh(arg_6_2.nav_world, unbox, 1, 1)

		arg_6_2.quick_teleport_exit_pos = Vector3Box(pos_on_mesh)
		arg_6_2.quick_teleport = true
		final_phase_data.teleport_timer = arg_6_3 + action.final_phase_teleport_cooldown
		arg_6_2.current_spell_name = "teleport"
		arg_6_2.stagger_count = 0

		local num

		if not final_phase_data.num_teleports then
			num = final_phase_data.num_teleports + 1

			if not num then
				-- Nothing
			end
		end

		num = 1

		::label_6_0::

		final_phase_data.num_teleports = num

		if final_phase_data.num_teleports > 4 then
			final_phase_data.num_teleports = 1
		end

		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event("egs_teleport_away", alloc_table)

		return true
	end

	if arg_6_3 > final_phase_data.spawn_allies_timer then
		self:spawn_allies(arg_6_1, arg_6_2, arg_6_3)

		final_phase_data.spawn_allies_timer = arg_6_3 + action.spawn_allies_cooldown

		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_6_1, "egs_summon", DialogueSettings.default_hear_distance)

		local alloc_table_2 = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event("egs_cast_vermintide", alloc_table_2)
	end

	return (self:update_regular_spells(arg_6_1, arg_6_2, arg_6_3))
end

BTGreySeerGroundCombatAction.update_regular_spells = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local spell_data = arg_7_2.spell_data
	local var_7_1
	local extension_input = ScriptUnit.extension_input(arg_7_1, "dialogue_system")
	local warp_lightning_spell_timer = spell_data.warp_lightning_spell_timer
	local vermintide_spell_timer = spell_data.vermintide_spell_timer
	local teleport_spell_timer = spell_data.teleport_spell_timer
	local current_phase = arg_7_2.current_phase

	if warp_lightning_spell_timer < arg_7_3 then
		arg_7_2.current_spell_name = "warp_lightning"
		var_7_1 = true
		spell_data.warp_lightning_spell_timer = arg_7_3 + spell_data.warp_lightning_spell_cooldown

		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event("egs_cast_lightning", alloc_table)
	elseif vermintide_spell_timer < arg_7_3 then
		arg_7_2.current_spell_name = "vermintide"
		var_7_1 = true
		spell_data.vermintide_spell_timer = arg_7_3 + spell_data.vermintide_spell_cooldown

		local alloc_table_2 = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event("egs_cast_vermintide", alloc_table_2)
	end

	return var_7_1
end

BTGreySeerGroundCombatAction.update_warp_lightning_spell = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local magic_missile_data = arg_8_2.magic_missile_data

	magic_missile_data.throw_pos:store(arg_8_4 + Vector3.up() * 2)

	if not arg_8_5 then
		magic_missile_data.target_direction:store(arg_8_5)
	end
end

BTGreySeerGroundCombatAction.update_vermintide_spell = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local plague_wave_data = arg_9_2.plague_wave_data

	plague_wave_data.target_starting_pos:store(arg_9_4)

	if not arg_9_5 then
		plague_wave_data.plague_wave_rot:store(Quaternion.look(arg_9_5))
	end
end

BTGreySeerGroundCombatAction.update_teleport_spell = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local quick_teleport_timer = arg_10_2.quick_teleport_timer

	quick_teleport_timer = quick_teleport_timer or arg_10_3
	arg_10_2.quick_teleport_timer = quick_teleport_timer

	if not (not quick_teleport_timer and not (quick_teleport_timer < arg_10_3)) then
		local skulk_data = arg_10_2.skulk_data

		skulk_data = skulk_data or {}
		arg_10_2.skulk_data = skulk_data

		local direction = skulk_data.direction

		direction = direction or 1 - math.random(0, 1) * 2
		skulk_data.direction = direction

		local radius = skulk_data.radius

		radius = radius or arg_10_2.target_dist
		skulk_data.radius = radius

		local get_skulk_target = BTChaosSorcererPlagueSkulkAction:get_skulk_target(arg_10_1, arg_10_2, true)

		if not get_skulk_target then
			arg_10_2.quick_teleport_exit_pos = Vector3Box(get_skulk_target)
			arg_10_2.quick_teleport = true
			arg_10_2.move_pos = nil
			arg_10_2.quick_teleport_timer = arg_10_3 + 2.5
		end
	end
end

BTGreySeerGroundCombatAction.spawn_allies = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local action = arg_11_2.action
	local flag = true
	local flag_2 = true
	local var_11_4

	if not action.difficulty_spawn then
		var_11_4 = action.difficulty_spawn[get_difficulty]

		if not var_11_4 then
			-- Nothing
		end
	end

	var_11_4 = action.spawn

	::label_11_0::

	local var_11_5
	local terror_event_id = action.terror_event_id
	local conflict = Managers.state.conflict
	local side_id = arg_11_2.side.side_id

	conflict.horde_spawner:execute_event_horde(arg_11_3, terror_event_id, side_id, var_11_4, var_11_5, flag_2, nil, flag)
end
