-- chunkname: @scripts/unit_extensions/generic/generic_character_state_machine_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_helper")
require("scripts/unit_extensions/default_player_unit/states/player_character_state")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_dead")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_interacting")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_jumping")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_leaping")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_ledge_hanging")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_leave_ledge_hanging_falling")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_leave_ledge_hanging_pull_up")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_climbing_ladder")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_leaving_ladder_top")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_enter_ladder_top")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_falling")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_knocked_down")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_pounced_down")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_standing")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_inspecting")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_emote")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_walking")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_dodging")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_lunging")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_waiting_for_assisted_respawn")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_catapulted")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_stunned")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_overpowered")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_using_transport")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_grabbed_by_pack_master")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_grabbed_by_corruptor")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_grabbed_by_tentacle")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_grabbed_by_chaos_spawn")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_in_hanging_cage")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_in_vortex")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_overcharge_exploding")
require("scripts/unit_extensions/default_player_unit/states/player_character_state_charged")
DLCUtils.dofile_list("character_states")

GenericCharacterStateMachineExtension = class(GenericCharacterStateMachineExtension)

GenericCharacterStateMachineExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.network_transmit = arg_1_1.network_transmit
	arg_1_0.unit_storage = arg_1_1.unit_storage
	arg_1_0.unit = arg_1_2
	arg_1_0.player = arg_1_3.player
	arg_1_0.start_state = arg_1_3.start_state
	arg_1_0.character_state_class_list = arg_1_3.character_state_class_list
	arg_1_0.nav_world = arg_1_3.nav_world
	arg_1_0.state_machine = GenericStateMachine:new(arg_1_0.world, arg_1_0.unit)
end

GenericCharacterStateMachineExtension.extensions_ready = function (arg_2_0)
	local var_2_0 = {
		world = arg_2_0.world,
		unit = arg_2_0.unit,
		player = arg_2_0.player,
		csm = arg_2_0.state_machine,
		network_transmit = arg_2_0.network_transmit,
		unit_storage = arg_2_0.unit_storage,
		nav_world = arg_2_0.nav_world
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.character_state_class_list

	for iter_2_0 = 1, #var_2_2 do
		local var_2_3 = var_2_2[iter_2_0]:new(var_2_0)
		local var_2_4 = var_2_3.name

		assert(var_2_4 and var_2_1[var_2_4] == nil)

		var_2_1[var_2_4] = var_2_3
	end

	local var_2_5 = arg_2_0.start_state

	arg_2_0.state_machine:post_init(var_2_1, var_2_5)
end

GenericCharacterStateMachineExtension.destroy = function (arg_3_0)
	local var_3_0 = true

	arg_3_0.state_machine:exit_current_state(var_3_0)
end

GenericCharacterStateMachineExtension.reset = function (arg_4_0)
	arg_4_0.state_machine:reset()
end

GenericCharacterStateMachineExtension.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_0.state_machine:update(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
end

GenericCharacterStateMachineExtension.current_state = function (arg_6_0)
	return arg_6_0.state_machine:current_state()
end
