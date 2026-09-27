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

GenericCharacterStateMachineExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.network_transmit = arg_1_1.network_transmit
	self.unit_storage = arg_1_1.unit_storage
	self.unit = arg_1_2
	self.player = arg_1_3.player
	self.start_state = arg_1_3.start_state
	self.character_state_class_list = arg_1_3.character_state_class_list
	self.nav_world = arg_1_3.nav_world
	self.state_machine = GenericStateMachine:new(self.world, self.unit)
end

GenericCharacterStateMachineExtension.extensions_ready = function (self)
	-- function 2
	local tbl = {
		world = self.world,
		unit = self.unit,
		player = self.player,
		csm = self.state_machine,
		network_transmit = self.network_transmit,
		unit_storage = self.unit_storage,
		nav_world = self.nav_world
	}
	local tbl_2 = {}
	local character_state_class_list = self.character_state_class_list

	for i = 1, #character_state_class_list do
		local var_2_3 = character_state_class_list[i]:new(tbl)
		local name = var_2_3.name

		assert(not name and tbl_2[name] == nil)

		tbl_2[name] = var_2_3
	end

	local start_state = self.start_state

	self.state_machine:post_init(tbl_2, start_state)
end

GenericCharacterStateMachineExtension.destroy = function (self)
	-- function 3
	local flag = true

	self.state_machine:exit_current_state(flag)
end

GenericCharacterStateMachineExtension.reset = function (self)
	-- function 4
	self.state_machine:reset()
end

GenericCharacterStateMachineExtension.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	self.state_machine:update(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
end

GenericCharacterStateMachineExtension.current_state = function (self)
	-- function 6
	return self.state_machine:current_state()
end
