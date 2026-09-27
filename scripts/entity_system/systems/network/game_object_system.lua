-- chunkname: @scripts/entity_system/systems/network/game_object_system.lua

local tbl = {
	"GameObjectExtension"
}

GameObjectSystem = class(GameObjectSystem, ExtensionSystemBase)

GameObjectSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	arg_1_1.entity_manager:register_system(self, arg_1_2, tbl)

	self.is_server = arg_1_1.is_server
	self.unit_storage = arg_1_1.unit_storage
	self.world = arg_1_1.world
	self.name = arg_1_2
	self.own_peer_id = Network.peer_id()
	self.unit_extension_data = {}
	self.units_to_sync = {}
end

GameObjectSystem.destroy = function (arg_2_0)
	-- function 2
	return
end

local tbl_2 = {}

GameObjectSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local tbl = {}

	if arg_3_3 == "GameObjectExtension" then
		local current_level = LevelHelper:current_level(self.world)
		local flag = Level.unit_index(current_level, arg_3_2) ~= nil

		tbl.ignored = flag

		if not flag then
			local sync_name = arg_3_4.sync_name

			sync_name = sync_name or Unit.get_data(arg_3_2, "sync_name")

			local go_type = arg_3_4.go_type

			go_type = go_type or Unit.get_data(arg_3_2, "go_type")

			fassert(sync_name, "Game object extension couldn't find sync_name for unit %s", arg_3_2)
			fassert(go_type, "Game object extension couldn't find go_type for unit %s", arg_3_2)
			fassert(NetworkLookup.sync_names[sync_name], "Sync name %s on unit %s didn't exist in NetworkLookup", sync_name, arg_3_2)

			tbl.sync_name = sync_name
			tbl.go_type = go_type

			if not self.is_server then
				fassert(self.units_to_sync[sync_name] == nil, "Tried to register unit %s with sync_name %s but it was already set by %s", arg_3_2, sync_name, self.units_to_sync[sync_name])

				self.units_to_sync[sync_name] = arg_3_2
			end
		end
	end

	ScriptUnit.set_extension(arg_3_2, "game_object_system", tbl, tbl_2)

	self.unit_extension_data[arg_3_2] = tbl

	return tbl
end

GameObjectSystem.extensions_ready = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if arg_4_3 == "GameObjectExtension" then
		local var_4_0 = self.unit_extension_data[arg_4_2]

		if not (not self.is_server and var_4_0.ignored) then
			NetworkUnit.add_unit(arg_4_2)
			NetworkUnit.set_is_husk_unit(arg_4_2, false)

			local var_4_1
			local var_4_2
			local var_4_3
			local game = Managers.state.network:game()
			local go_type = var_4_0.go_type
			local var_4_6 = Managers.state.unit_spawner.gameobject_initializers[go_type]

			fassert(var_4_6, "Couldn't find initializer function for go_type %s on unit %s", go_type, arg_4_2)

			local var_4_7 = var_4_6(arg_4_2, var_4_1, var_4_2, var_4_3)
			local create_game_object = GameSession.create_game_object(game, go_type, var_4_7)

			var_4_0.game_object_id = create_game_object

			self.unit_storage:add_unit_info(arg_4_2, create_game_object, go_type, self.own_peer_id)
		end
	end
end

GameObjectSystem.on_remove_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = self.unit_extension_data[arg_5_1]

	if not var_5_0.ignored then
		local game = Managers.state.network:game()
		local game_object_id = var_5_0.game_object_id

		if not game and not self.is_server then
			GameSession.destroy_game_object(game, game_object_id)
		end

		if not game_object_id then
			self.unit_storage:remove(arg_5_1, game_object_id)
		end

		if not NetworkUnit.is_network_unit(arg_5_1) then
			NetworkUnit.remove_unit(arg_5_1)
		end
	end

	self.unit_extension_data[arg_5_1] = nil

	ScriptUnit.remove_extension(arg_5_1, self.NAME)
end

GameObjectSystem.game_object_created = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local game = Managers.state.network:game()
	local game_object_field = GameSession.game_object_field(game, arg_6_1, "sync_name")
	local var_6_2 = NetworkLookup.sync_names[game_object_field]
	local var_6_3 = self.units_to_sync[var_6_2]

	fassert(var_6_3, "Couldn't find unit with sync name %s and game_object_id %s", var_6_2, arg_6_1)
	NetworkUnit.add_unit(var_6_3)
	NetworkUnit.set_is_husk_unit(var_6_3, true)

	local go_type = arg_6_3.go_type

	self.unit_storage:add_unit_info(var_6_3, arg_6_1, go_type, arg_6_2)

	local var_6_5 = self.unit_extension_data[var_6_3]

	var_6_5.game_object_id = arg_6_1

	fassert(not var_6_5.ignored, "Client got game_object_created for unit %s with sync_name %s that should be ignored...", var_6_3, var_6_2)
end

GameObjectSystem.update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

GameObjectSystem.hot_join_sync = function (arg_8_0, arg_8_1)
	-- function 8
	return
end
