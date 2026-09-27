-- chunkname: @scripts/unit_extensions/default_player_unit/versus_horde_ability_husk_extension.lua

VersusHordeAbilityHuskExtension = class(VersusHordeAbilityHuskExtension)

VersusHordeAbilityHuskExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._horde_ability_system = Managers.state.entity:system("versus_horde_ability_system")
	self._unit = arg_1_2
	self.game = Managers.state.network:game()
end

VersusHordeAbilityHuskExtension.update = function (arg_2_0)
	-- function 2
	return
end

VersusHordeAbilityHuskExtension.set_ability_game_object_id = function (self, arg_3_1)
	-- function 3
	self.ability_go_id = arg_3_1
end

VersusHordeAbilityHuskExtension.get_ability_charge = function (self)
	-- function 4
	local game = self.game
	local ability_go_id = self.ability_go_id

	if not game and not ability_go_id then
		return (GameSession.game_object_field(game, ability_go_id, "ability_charge"))
	end

	return 0
end
