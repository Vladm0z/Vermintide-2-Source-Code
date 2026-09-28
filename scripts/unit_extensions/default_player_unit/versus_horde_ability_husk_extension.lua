-- chunkname: @scripts/unit_extensions/default_player_unit/versus_horde_ability_husk_extension.lua

VersusHordeAbilityHuskExtension = class(VersusHordeAbilityHuskExtension)

VersusHordeAbilityHuskExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self._horde_ability_system = Managers.state.entity:system("versus_horde_ability_system")
	self._unit = unit
	self.game = Managers.state.network:game()
end

VersusHordeAbilityHuskExtension.update = function (self)
	-- function 2
	return
end

VersusHordeAbilityHuskExtension.set_ability_game_object_id = function (self, go_id)
	-- function 3
	self.ability_go_id = go_id
end

VersusHordeAbilityHuskExtension.get_ability_charge = function (self)
	-- function 4
	local game = self.game
	local game_object_id = self.ability_go_id

	if game and game_object_id then
		local ability_charge = GameSession.game_object_field(game, game_object_id, "ability_charge")

		return ability_charge
	end

	return 0
end
