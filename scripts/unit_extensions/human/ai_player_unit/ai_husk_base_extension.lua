-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_husk_base_extension.lua

AiHuskBaseExtension = class(AiHuskBaseExtension)

AiHuskBaseExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.is_husk = true
	self.unit = arg_1_2
	self.game = arg_1_3.game
	self.go_id = arg_1_3.go_id

	local get_data = Unit.get_data(arg_1_2, "breed")

	self._breed = get_data

	if not get_data.hit_zones_lookup then
		DamageUtils.create_hit_zone_lookup(arg_1_2, get_data)
	end

	local blackboard_init_data = get_data.blackboard_init_data

	if not (not blackboard_init_data and blackboard_init_data.player_locomotion_constrain_radius == nil) then
		local player_locomotion_constrain_radius = blackboard_init_data.player_locomotion_constrain_radius

		player_locomotion_constrain_radius = player_locomotion_constrain_radius or nil
		self.player_locomotion_constrain_radius = player_locomotion_constrain_radius
	else
		local player_locomotion_constrain_radius_2 = get_data.player_locomotion_constrain_radius

		player_locomotion_constrain_radius_2 = player_locomotion_constrain_radius_2 or nil
		self.player_locomotion_constrain_radius = player_locomotion_constrain_radius_2
	end

	local run_on_husk_spawn = get_data.run_on_husk_spawn

	if not run_on_husk_spawn then
		run_on_husk_spawn(arg_1_2)
	end

	if not get_data.special_on_spawn_stinger then
		WwiseUtils.trigger_unit_event(arg_1_1.world, get_data.special_on_spawn_stinger, arg_1_2, 0)
	end

	self._side_id = arg_1_3.side_id
	self.attributes = nil
end

AiHuskBaseExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	local _side_id = self._side_id
	local side = Managers.state.side

	side:add_unit_to_side(arg_2_2, _side_id)

	local has_extension = ScriptUnit.has_extension(arg_2_2, "health_system")

	if not has_extension then
		local broadphase = Managers.state.entity:system("ai_system").broadphase
		local get_side = side:get_side(_side_id)

		self.broadphase_id = Broadphase.add(broadphase, arg_2_2, Unit.local_position(arg_2_2, 0), 1, get_side.broadphase_category)
		self.broadphase = broadphase
		self._health_extension = has_extension
	end

	Unit.flow_event(arg_2_2, "lua_trigger_variation")

	local climate_type = LevelSettings[Managers.state.game_mode:level_key()].climate_type

	climate_type = climate_type or "default"

	Unit.set_flow_variable(arg_2_2, "climate_type", climate_type)
	Unit.flow_event(arg_2_2, "climate_type_set")
end

AiHuskBaseExtension.freeze = function (self)
	-- function 3
	self._side_id = nil
end

AiHuskBaseExtension.unfreeze = function (self, arg_4_1, arg_4_2)
	-- function 4
	local side_id = arg_4_2[7].side_id

	self._side_id = side_id

	Managers.state.side:add_unit_to_side(arg_4_1, side_id)

	if not self.attributes then
		table.clear(self.attributes)
	end

	local run_on_husk_spawn = self._breed.run_on_husk_spawn

	if not run_on_husk_spawn then
		run_on_husk_spawn(self.unit)
	end
end

AiHuskBaseExtension.current_action_name = function (self)
	-- function 5
	local game = self.game
	local go_id = self.go_id

	return NetworkLookup.bt_action_names[GameSession.game_object_field(game, go_id, "bt_action_name")]
end

AiHuskBaseExtension.breed = function (self)
	-- function 6
	return self._breed
end

AiHuskBaseExtension.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	if not self.broadphase_id and not HEALTH_ALIVE[arg_7_1] then
		Broadphase.move(self.broadphase, self.broadphase_id, POSITION_LOOKUP[arg_7_1])
	end
end

AiHuskBaseExtension.unit_removed_from_game = function (self)
	-- function 8
	Managers.state.side:remove_unit_from_side(self.unit)

	self._side_id = nil
end

AiHuskBaseExtension.destroy = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end
