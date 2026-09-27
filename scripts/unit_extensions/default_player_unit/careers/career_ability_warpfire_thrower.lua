-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_warpfire_thrower.lua

CareerAbilityWarpfireThrower = class(CareerAbilityWarpfireThrower, CareerAbilityDarkPactBase)

CareerAbilityWarpfireThrower.ability_ready = function (self)
	-- function 1
	self.super.ability_ready(self)

	local _first_person_extension = self._first_person_extension

	if not _first_person_extension then
		local _unit = self._unit
		local _wwise_world = self._wwise_world

		WwiseWorld.trigger_event(_wwise_world, "player_enemy_warpfire_steam_after_flame_stop", _unit)
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "cooldown_ready")
		CharacterStateHelper.play_animation_event(_unit, "cooldown_ready")
	end
end
