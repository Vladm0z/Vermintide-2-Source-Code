-- chunkname: @scripts/entity_system/systems/network/game_object_system.lua

local var_0_0 = {
	"GameObjectExtension"
}

GameObjectSystem = class(GameObjectSystem, ExtensionSystemBase)

function GameObjectSystem.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_1.entity_manager:register_system(arg_1_0, arg_1_2, var_0_0)

	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.unit_storage = arg_1_1.unit_storage
	arg_1_0.world = arg_1_1.world
	arg_1_0.name = arg_1_2
	arg_1_0.own_peer_id = Network.peer_id()
	arg_1_0.unit_extension_data = {}
	arg_1_0.units_to_sync = {}
end

function GameObjectSystem.destroy(arg_2_0)
	return
end

local var_0_1 = {}

function GameObjectSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = {}

	if arg_3_3 == "GameObjectExtension" then
		local var_3_1 = LevelHelper:current_level(arg_3_0.world)
		local var_3_2 = Level.unit_index(var_3_1, arg_3_2) ~= nil

		var_3_0.ignored = var_3_2

		if not var_3_2 then
			local var_3_3 = arg_3_4.sync_name or Unit.get_data(arg_3_2, "sync_name")
			local var_3_4 = arg_3_4.go_type or Unit.get_data(arg_3_2, "go_type")

			fassert(var_3_3, "Game object extension couldn't find sync_name for unit %s", arg_3_2)
			fassert(var_3_4, "Game object extension couldn't find go_type for unit %s", arg_3_2)
			fassert(NetworkLookup.sync_names[var_3_3], "Sync name %s on unit %s didn't exist in NetworkLookup", var_3_3, arg_3_2)

			var_3_0.sync_name = var_3_3
			var_3_0.go_type = var_3_4

			if not arg_3_0.is_server then
				fassert(arg_3_0.units_to_sync[var_3_3] == nil, "Tried to register unit %s with sync_name %s but it was already set by %s", arg_3_2, var_3_3, arg_3_0.units_to_sync[var_3_3])

				arg_3_0.units_to_sync[var_3_3] = arg_3_2
			end
		end
	end

	ScriptUnit.set_extension(arg_3_2, "game_object_system", var_3_0, var_0_1)

	arg_3_0.unit_extension_data[arg_3_2] = var_3_0

	return var_3_0
end

function GameObjectSystem.extensions_ready(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_3 == "GameObjectExtension" then
		local var_4_0 = arg_4_0.unit_extension_data[arg_4_2]

		if arg_4_0.is_server and not var_4_0.ignored then
			NetworkUnit.add_unit(arg_4_2)
			NetworkUnit.set_is_husk_unit(arg_4_2, false)

			local var_4_1
			local var_4_2
			local var_4_3
			local var_4_4 = Managers.state.network:game()
			local var_4_5 = var_4_0.go_type
			local var_4_6 = Managers.state.unit_spawner.gameobject_initializers[var_4_5]

			fassert(var_4_6, "Couldn't find initializer function for go_type %s on unit %s", var_4_5, arg_4_2)

			local var_4_7 = var_4_6(arg_4_2, var_4_1, var_4_2, var_4_3)
			local var_4_8 = GameSession.create_game_object(var_4_4, var_4_5, var_4_7)

			var_4_0.game_object_id = var_4_8

			arg_4_0.unit_storage:add_unit_info(arg_4_2, var_4_8, var_4_5, arg_4_0.own_peer_id)
		end
	end
end

function GameObjectSystem.on_remove_extension(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.unit_extension_data[arg_5_1]

	if not var_5_0.ignored then
		local var_5_1 = Managers.state.network:game()
		local var_5_2 = var_5_0.game_object_id

		if var_5_1 and arg_5_0.is_server then
			GameSession.destroy_game_object(var_5_1, var_5_2)
		end

		if var_5_2 then
			arg_5_0.unit_storage:remove(arg_5_1, var_5_2)
		end

		if NetworkUnit.is_network_unit(arg_5_1) then
			NetworkUnit.remove_unit(arg_5_1)
		end
	end

	arg_5_0.unit_extension_data[arg_5_1] = nil

	ScriptUnit.remove_extension(arg_5_1, arg_5_0.NAME)
end

function GameObjectSystem.game_object_created(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = Managers.state.network:game()
	local var_6_1 = GameSession.game_object_field(var_6_0, arg_6_1, "sync_name")
	local var_6_2 = NetworkLookup.sync_names[var_6_1]
	local var_6_3 = arg_6_0.units_to_sync[var_6_2]

	fassert(var_6_3, "Couldn't find unit with sync name %s and game_object_id %s", var_6_2, arg_6_1)
	NetworkUnit.add_unit(var_6_3)
	NetworkUnit.set_is_husk_unit(var_6_3, true)

	local var_6_4 = arg_6_3.go_type

	arg_6_0.unit_storage:add_unit_info(var_6_3, arg_6_1, var_6_4, arg_6_2)

	local var_6_5 = arg_6_0.unit_extension_data[var_6_3]

	var_6_5.game_object_id = arg_6_1

	fassert(not var_6_5.ignored, "Client got game_object_created for unit %s with sync_name %s that should be ignored...", var_6_3, var_6_2)
end

function GameObjectSystem.update(arg_7_0, arg_7_1, arg_7_2)
	return
end

function GameObjectSystem.hot_join_sync(arg_8_0, arg_8_1)
	return
end
