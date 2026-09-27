-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_poison_wind_globadier_throw.lua

CareerAbilityPoisonWindGlobadierThrow = class(CareerAbilityPoisonWindGlobadierThrow, CareerAbilityDarkPactBase)

CareerAbilityPoisonWindGlobadierThrow.extensions_ready = function (self, arg_1_1, arg_1_2)
	-- function 1
	CareerAbilityPoisonWindGlobadierThrow.super.extensions_ready(self, arg_1_1, arg_1_2)

	local _ability_data = self._ability_data

	self._career_extension:setup_extra_ability_uses(0, _ability_data.cooldown, 0, _ability_data.max_stacks)
	self._career_extension:modify_extra_ability_uses(_ability_data.starting_stack_count)
end

CareerAbilityPoisonWindGlobadierThrow.ability_ready = function (self)
	-- function 2
	self.super.ability_ready(self)

	if not self._status_extension:get_in_ghost_mode() then
		local _unit = self._unit
		local extension = ScriptUnit.extension(_unit, "inventory_system")

		Unit.flow_event(_unit, "reload_finished")
		CharacterStateHelper.show_inventory_3p(_unit, true, false, self._is_server, extension)
	end
end

CareerAbilityPoisonWindGlobadierThrow.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	CareerAbilityPoisonWindGlobadierThrow.super.update(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	self._career_extension:modify_extra_ability_charge(arg_3_3)
end

CareerAbilityPoisonWindGlobadierThrow.start_cooldown_anim = function (self)
	-- function 4
	local _first_person_extension = self._first_person_extension
	local _unit = self._unit

	if not _first_person_extension then
		CharacterStateHelper.play_animation_event(_unit, "reload_start")
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "reload_start")
		Unit.flow_event(_unit, "reload_start")
		_first_person_extension:animation_set_variable("armed", 1)
		_first_person_extension:unhide_weapons("catapulted")
	end
end
