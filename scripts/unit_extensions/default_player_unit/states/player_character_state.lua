-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state.lua

PlayerCharacterState = class(PlayerCharacterState)

PlayerCharacterState.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local unit = arg_1_1.unit

	self.name = arg_1_2
	self.world = arg_1_1.world
	self.physics_world = World.get_data(self.world, "physics_world")
	self.wwise_world = Managers.world:wwise_world(self.world)
	self.unit = unit
	self.csm = arg_1_1.csm
	self.player = arg_1_1.player
	self.network_transmit = arg_1_1.network_transmit
	self.unit_storage = arg_1_1.unit_storage
	self.nav_world = arg_1_1.nav_world
	self.is_server = Managers.player.is_server
	self.temp_params = {}
	self.buff_extension = ScriptUnit.extension(unit, "buff_system")
	self.talent_extension = ScriptUnit.extension(unit, "talent_system")
	self.input_extension = ScriptUnit.extension(unit, "input_system")
	self.interactor_extension = ScriptUnit.extension(unit, "interactor_system")
	self.inventory_extension = ScriptUnit.extension(unit, "inventory_system")
	self.career_extension = ScriptUnit.extension(unit, "career_system")
	self.health_extension = ScriptUnit.extension(unit, "health_system")
	self.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	self.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self.status_extension = ScriptUnit.extension(unit, "status_system")
	self.cosmetic_extension = ScriptUnit.extension(unit, "cosmetic_system")

	local has_extension = ScriptUnit.has_extension(unit, "ai_system")

	has_extension = not has_extension and ScriptUnit.extension(unit, "ai_system")
	self.ai_extension = has_extension
end
