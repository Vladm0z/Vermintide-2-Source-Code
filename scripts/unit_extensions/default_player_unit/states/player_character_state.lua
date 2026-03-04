-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state.lua

PlayerCharacterState = class(PlayerCharacterState)

PlayerCharacterState.init = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.unit

	arg_1_0.name = arg_1_2
	arg_1_0.world = arg_1_1.world
	arg_1_0.physics_world = World.get_data(arg_1_0.world, "physics_world")
	arg_1_0.wwise_world = Managers.world:wwise_world(arg_1_0.world)
	arg_1_0.unit = var_1_0
	arg_1_0.csm = arg_1_1.csm
	arg_1_0.player = arg_1_1.player
	arg_1_0.network_transmit = arg_1_1.network_transmit
	arg_1_0.unit_storage = arg_1_1.unit_storage
	arg_1_0.nav_world = arg_1_1.nav_world
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.temp_params = {}
	arg_1_0.buff_extension = ScriptUnit.extension(var_1_0, "buff_system")
	arg_1_0.talent_extension = ScriptUnit.extension(var_1_0, "talent_system")
	arg_1_0.input_extension = ScriptUnit.extension(var_1_0, "input_system")
	arg_1_0.interactor_extension = ScriptUnit.extension(var_1_0, "interactor_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(var_1_0, "inventory_system")
	arg_1_0.career_extension = ScriptUnit.extension(var_1_0, "career_system")
	arg_1_0.health_extension = ScriptUnit.extension(var_1_0, "health_system")
	arg_1_0.locomotion_extension = ScriptUnit.extension(var_1_0, "locomotion_system")
	arg_1_0.first_person_extension = ScriptUnit.extension(var_1_0, "first_person_system")
	arg_1_0.status_extension = ScriptUnit.extension(var_1_0, "status_system")
	arg_1_0.cosmetic_extension = ScriptUnit.extension(var_1_0, "cosmetic_system")
	arg_1_0.ai_extension = ScriptUnit.has_extension(var_1_0, "ai_system") and ScriptUnit.extension(var_1_0, "ai_system")
end
