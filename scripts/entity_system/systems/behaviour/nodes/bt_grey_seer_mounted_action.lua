-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_grey_seer_mounted_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTGreySeerMountedAction = class(BTGreySeerMountedAction, BTNode)

BTGreySeerMountedAction.init = function (arg_1_0, ...)
	-- function 1
	BTGreySeerMountedAction.super.init(arg_1_0, ...)
end

BTGreySeerMountedAction.name = "BTGreySeerMountedAction"

BTGreySeerMountedAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(arg_2_1)

	arg_2_2.move_state = "moving"

	local network = Managers.state.network
	local extension = ScriptUnit.extension(arg_2_1, "health_system")
	local hit_reaction_extension = arg_2_2.hit_reaction_extension
	local network_transmit = network.network_transmit

	hit_reaction_extension:set_hit_effect_template_id("HitEffectsSkavenGreySeerMounted")

	extension.is_invincible = true

	GameSession.set_game_object_field(game, go_id, "show_health_bar", false)
	network_transmit:send_rpc_clients("rpc_set_hit_reaction_template", go_id, "HitEffectsSkavenGreySeerMounted")

	arg_2_2.current_hit_reaction_type = "mounted"
end

BTGreySeerMountedAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.navigation_extension:set_enabled(true)

	local network = Managers.state.network
	local game = network:game()
	local go_id = Managers.state.unit_storage:go_id(arg_3_1)
	local extension = ScriptUnit.extension(arg_3_1, "health_system")
	local hit_reaction_extension = arg_3_2.hit_reaction_extension
	local network_transmit = network.network_transmit

	hit_reaction_extension:set_hit_effect_template_id("HitEffectsSkavenGreySeer")

	extension.is_invincible = false

	GameSession.set_game_object_field(game, go_id, "show_health_bar", true)
	network_transmit:send_rpc_clients("rpc_set_hit_reaction_template", go_id, "HitEffectsSkavenGreySeer")

	arg_3_2.current_hit_reaction_type = "on_ground"
end

local alive = Unit.alive

BTGreySeerMountedAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local mounted_data = arg_4_2.mounted_data

	if not (not Unit.alive(mounted_data.mount_unit) and mounted_data.knocked_off_mounted_timer or arg_4_2.knocked_off_mount) then
		local local_rotation = Unit.local_rotation(mounted_data.mount_unit, 0)
		local local_position = Unit.local_position(mounted_data.mount_unit, 0)

		Unit.set_local_position(arg_4_1, 0, local_position)
		Unit.set_local_rotation(arg_4_1, 0, local_rotation)
	end

	return "running"
end
