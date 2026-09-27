-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_spawn/bt_chew_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChewAttackAction = class(BTChewAttackAction, BTNode)
BTChewAttackAction.name = "BTChewAttackAction"

BTChewAttackAction.init = function (arg_1_0, ...)
	-- function 1
	BTChewAttackAction.super.init(arg_1_0, ...)
end

BTChewAttackAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local network = Managers.state.network

	arg_2_2.action = self._tree_node.action_data
	arg_2_2.active_node = self

	if not Unit.alive(arg_2_2.victim_grabbed) then
		return
	end

	if arg_2_2.grabbed_state ~= "chew" then
		local str = "attack_grabbed_eat_start"

		network:anim_event(arg_2_1, str)
		arg_2_2.navigation_extension:set_enabled(false)
		arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
		StatusUtils.set_grabbed_by_chaos_spawn_status_network(arg_2_2.victim_grabbed, "chewed_on")
	end

	arg_2_2.is_chewing = true
	arg_2_2.grabbed_state = "chew"

	local victim_grabbed = arg_2_2.victim_grabbed
	local player_profile = ScriptUnit.extension(victim_grabbed, "dialogue_system").context.player_profile

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_2_1, "enemy_attack", DialogueSettings.discover_enemy_attack_distance, "attack_tag", "chaos_spawn_eating", "target_name", player_profile)
end

BTChewAttackAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.is_chewing = false
	arg_3_2.active_node = nil
	arg_3_2.action = nil
	arg_3_2.attacks_done = 0

	if arg_3_4 ~= "aborted" or not Unit.alive(arg_3_2.victim_grabbed) then
		StatusUtils.set_grabbed_by_chaos_spawn_network(arg_3_2.victim_grabbed, false, arg_3_1)

		arg_3_2.has_grabbed_victim = nil
		arg_3_2.victim_grabbed = nil
	else
		arg_3_2.wants_to_throw = true
	end

	if not HEALTH_ALIVE[arg_3_2.victim_grabbed] then
		arg_3_2.has_grabbed_victim = nil
		arg_3_2.victim_grabbed = nil
	end
end

local alive = Unit.alive

BTChewAttackAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local victim_grabbed = arg_4_2.victim_grabbed

	if not (not victim_grabbed and HEALTH_ALIVE[victim_grabbed]) then
		return "done"
	end

	if not arg_4_2.anim_cb_chew_attack_finished then
		arg_4_2.anim_cb_chew_attack_finished = false
	end

	if not (not (arg_4_2.target_dist < 4) or not (arg_4_2.chew_attacks_done >= arg_4_2.action.max_chew_attacks)) then
		return "done"
	end

	return "running"
end

BTChewAttackAction.anim_cb_chew_attack = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local action = arg_5_2.action
	local damage_target = AiUtils.damage_target(arg_5_2.victim_grabbed, arg_5_1, action, action.damage)

	arg_5_2.chew_attacks_done = arg_5_2.chew_attacks_done + 1

	if damage_target > 0 then
		local str = "leech"
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local num = damage_target * action.health_leech_multiplier[get_difficulty] * arg_5_2.chew_attacks_done
		local networkify_damage = DamageUtils.networkify_damage(num)

		ScriptUnit.extension(arg_5_1, "health_system"):add_heal(arg_5_1, networkify_damage, nil, str)
	end

	if arg_5_2.chew_attacks_done >= action.max_chew_attacks then
		arg_5_2.wants_to_throw = true
	end
end
