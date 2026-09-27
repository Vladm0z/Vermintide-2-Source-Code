-- chunkname: @scripts/unit_extensions/ai_supplementary/beastmen_standard_extension.lua

BeastmenStandardExtension = class(BeastmenStandardExtension)

BeastmenStandardExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world

	self.world = world
	self.unit = arg_1_2
	self.is_server = Managers.player.is_server

	local local_position = Unit.local_position(arg_1_2, 0)

	self.self_position_boxed = Vector3Box(local_position)

	local standard_template_name = arg_1_3.standard_template_name
	local var_1_3 = BeastmenStandardTemplates[standard_template_name]

	self.standard_template = var_1_3
	self.standard_template_name = standard_template_name
	self.standard_template_buff_name = var_1_3.buff_template_name
	self.standard_bearer_unit = arg_1_3.standard_bearer_unit
	self.side = Managers.state.side.side_by_unit[self.standard_bearer_unit]
	self.apply_buff_frequency = 0.5

	local time = Managers.time:time("game")

	self.next_apply_buff_t = time
	self.affected_units_effects = {}
	self.ai_units_broadphase_result = {}
	self.ai_units_inside = {}
	self.standard_data = {}
	self.standard_data.challenge_time = time + QuestSettings.standard_bearer_alive_seconds
	self.standard_data.is_server = self.is_server
	self.standard_data.standard_bearer_unit = self.standard_bearer_unit

	local side = Managers.state.side
	local var_1_6 = side.side_by_unit[self.standard_bearer_unit]

	var_1_6 = var_1_6 or side:get_side_from_name("dark_pact")

	side:add_unit_to_side(self.unit, var_1_6.side_id)

	if not self.is_server then
		local astar_check_frequency = var_1_3.astar_check_frequency

		astar_check_frequency = astar_check_frequency or 15
		self.astar_check_frequency = astar_check_frequency
		self.nav_world = Managers.state.entity:system("ai_system"):nav_world()

		local tbl = {
			ledges = 1,
			ledges_with_fence = 1,
			doors = 1,
			bot_poison_wind = 1,
			planks = 1,
			bot_ratling_gun_fire = 1,
			fire_grenade = 1
		}
		local var_1_9 = GwNavTagLayerCostTable.create()

		table.merge(tbl, NAV_TAG_VOLUME_LAYER_COST_AI)
		AiUtils.initialize_cost_table(var_1_9, tbl)

		self.player_astar_traverse_logic, self.player_astar_navtag_layer_cost_table = GwNavTraverseLogic.create(self.nav_world, var_1_9), var_1_9
		self.player_astar_data = {
			{
				next_astar_check_t = time + self.astar_check_frequency
			},
			{
				next_astar_check_t = time + self.astar_check_frequency
			},
			{
				next_astar_check_t = time + self.astar_check_frequency
			},
			{
				next_astar_check_t = time + self.astar_check_frequency
			}
		}

		Managers.state.conflict:add_unit_to_standards(arg_1_2)

		self.next_vo_trigger_event_t = time + 15

		LevelHelper:flow_event(self.world, "standard_placed")
	end

	local sfx_placed = var_1_3.sfx_placed

	if not sfx_placed then
		WwiseUtils.trigger_unit_event(world, sfx_placed, arg_1_2, 0)
	end

	local sfx_loop = var_1_3.sfx_loop

	if not sfx_loop then
		WwiseUtils.trigger_unit_event(world, sfx_loop, arg_1_2, 0)
	end
end

BeastmenStandardExtension.destroy = function (self)
	-- function 2
	Managers.state.side:remove_unit_from_side(self.unit)

	if not self.dead then
		self:on_death()
	end
end

BeastmenStandardExtension.on_death = function (self, arg_3_1)
	-- function 3
	if not self.is_server then
		local system = Managers.state.entity:system("buff_system")

		for k, v in pairs(self.ai_units_inside) do
			if not Unit.alive(k) then
				local extension = ScriptUnit.extension(k, "buff_system")

				if not extension:has_buff_type(self.standard_template_buff_name) then
					extension:get_non_stacking_buff(self.standard_template_buff_name).standard_is_destroyed = true
				end

				if not system:has_server_controlled_buff(k, v) then
					system:remove_server_controlled_buff(k, v)
				end
			end
		end

		for k_2 = 1, #self.player_astar_data do
			local var_3_2 = self.player_astar_data[k_2]

			if not var_3_2.astar then
				local astar = var_3_2.astar

				GwNavAStar.destroy(astar)
			end
		end

		Managers.state.conflict:remove_unit_from_standards(self.unit)
		GwNavTagLayerCostTable.destroy(self.player_astar_navtag_layer_cost_table)
		GwNavTraverseLogic.destroy(self.player_astar_traverse_logic)
		table.clear(self.ai_units_inside)
		table.clear(self.ai_units_broadphase_result)
		LevelHelper:flow_event(self.world, "standard_destroyed")
	end

	self.dead = true

	table.clear(self.standard_data)

	if not (not Unit.alive(arg_3_1) and arg_3_1 == self.unit) then
		local local_position = Unit.local_position(self.unit, 0)
		local get_template = ExplosionUtils.get_template("standard_death_explosion")
		local str = "beastmen_standard_bearer"

		DamageUtils.create_explosion(self.world, arg_3_1 or self.unit, local_position, Quaternion.identity(), get_template, 1, str, self.is_server, false, self.unit, false)
		Unit.flow_event(self.unit, "destroy")

		if not self.is_server then
			Managers.state.entity:system("surrounding_aware_system"):add_system_event(self.unit, "standard_bearer_buff_deactivated", DialogueSettings.special_proximity_distance_heard)
		end
	else
		local vfx_picked_up_standard = self.standard_template.vfx_picked_up_standard

		World.create_particles(self.world, vfx_picked_up_standard, self.self_position_boxed:unbox())
		Unit.flow_event(self.unit, "picked_up")
	end

	local sfx_loop_stop = self.standard_template.sfx_loop_stop

	if not sfx_loop_stop then
		WwiseUtils.trigger_unit_event(self.world, sfx_loop_stop, self.unit, 0)
	end

	local sfx_destroyed = self.standard_template.sfx_destroyed

	if not sfx_destroyed then
		WwiseUtils.trigger_unit_event(self.world, sfx_destroyed, self.unit, 0)
	end

	self.world = nil
	self.self_position_boxed = nil
	self.standard_template = nil
end

BeastmenStandardExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not self.dead then
		return
	end

	local standard_template = self.standard_template

	if not (not self.is_server and not standard_template.apply_buff_to_ai and not (arg_4_5 >= self.next_apply_buff_t)) then
		local ai_units_inside = self.ai_units_inside
		local ai_units_broadphase_result = self.ai_units_broadphase_result

		table.clear(ai_units_broadphase_result)

		local system = Managers.state.entity:system("buff_system")
		local buff_template_name = standard_template.buff_template_name
		local radius = standard_template.radius
		local unbox = self.self_position_boxed:unbox()
		local broadphase_query = AiUtils.broadphase_query(unbox, radius, ai_units_broadphase_result)

		for i = 1, broadphase_query do
			local var_4_8 = ai_units_broadphase_result[i]
			local has_extension = ScriptUnit.has_extension(var_4_8, "buff_system")
			local var_4_10 = BLACKBOARDS[var_4_8]

			if not (not (not var_4_10 and var_4_10.breed.race == "beastmen") and not has_extension and ai_units_inside[var_4_8] or has_extension:get_non_stacking_buff(self.standard_template_buff_name)) then
				ai_units_inside[var_4_8] = system:add_buff(var_4_8, buff_template_name, var_4_8, true)
			end
		end

		for k, v in pairs(ai_units_inside) do
			local flag = false

			for l = 1, broadphase_query do
				if k == ai_units_broadphase_result[l] then
					flag = true

					break
				end
			end

			if not (not flag and HEALTH_ALIVE[k]) then
				if not Unit.alive(k) and not system:has_server_controlled_buff(k, v) then
					system:remove_server_controlled_buff(k, v)
				end

				ai_units_inside[k] = nil
			end
		end

		self.next_apply_buff_t = arg_4_5 + self.apply_buff_frequency
	end

	if not standard_template.custom_update_func then
		standard_template.custom_update_func(standard_template, self.standard_data, arg_4_5, arg_4_3, arg_4_1, self.ai_units_inside)
	end

	if not (not self.is_server and not (arg_4_5 > self.next_vo_trigger_event_t)) then
		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_4_1, "standard_bearer_buff_active", DialogueSettings.special_proximity_distance_heard)

		self.next_vo_trigger_event_t = arg_4_5 + 15
	end

	if not self.is_server then
		self:_update_self_destruction(arg_4_1, arg_4_3, arg_4_5)
	end
end

BeastmenStandardExtension._update_self_destruction = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local player_astar_data = self.player_astar_data
	local nav_world = self.nav_world
	local ENEMY_PLAYER_UNITS = self.side.ENEMY_PLAYER_UNITS
	local count = #ENEMY_PLAYER_UNITS

	for i = 1, count do
		local var_5_4 = ENEMY_PLAYER_UNITS[i]

		if not HEALTH_ALIVE[var_5_4] then
			local var_5_5 = player_astar_data[i]
			local astar = var_5_5.astar
			local player_astar_traverse_logic = self.player_astar_traverse_logic

			if not astar then
				if not GwNavAStar.processing_finished(astar) then
					local path_found = GwNavAStar.path_found(astar)

					var_5_5.has_calculated_path = true

					if not path_found then
						var_5_5.path_found = true

						for j = 1, #player_astar_data do
							local var_5_9 = player_astar_data[j]
							local astar_2 = var_5_9.astar

							if not astar_2 then
								GwNavAStar.destroy(astar_2)
							end

							var_5_9.astar = nil
						end

						break
					end

					GwNavAStar.destroy(astar)

					var_5_5.astar = nil
				end
			elseif arg_5_3 > var_5_5.next_astar_check_t then
				local var_5_11 = POSITION_LOOKUP[var_5_4]
				local triangle_from_position, var_5_13 = GwNavQueries.triangle_from_position(nav_world, var_5_11, 1, 1)

				if not triangle_from_position then
					local var_5_14 = Vector3(var_5_11[1], var_5_11[2], var_5_13)
					local var_5_15 = GwNavAStar.create(nav_world)
					local local_position = Unit.local_position(arg_5_1, 0)

					GwNavAStar.start(var_5_15, nav_world, var_5_14, local_position, player_astar_traverse_logic)

					var_5_5.astar = var_5_15
					var_5_5.next_astar_check_t = arg_5_3 + self.astar_check_frequency
					var_5_5.has_calculated_path = nil
					var_5_5.path_found = nil
				else
					var_5_5.next_astar_check_t = arg_5_3 + 1.5
				end
			end
		else
			local var_5_17 = player_astar_data[i]

			if not var_5_17 and not var_5_17.astar then
				local astar_3 = var_5_17.astar

				GwNavAStar.destroy(astar_3)
			end
		end
	end

	local var_5_19
	local num = 0

	for k = 1, #player_astar_data do
		local var_5_21 = player_astar_data[k]

		if not var_5_21.path_found then
			var_5_19 = true
		elseif not var_5_21.has_calculated_path then
			num = num + 1
		end
	end

	if not (var_5_19 or not (count <= num)) then
		AiUtils.kill_unit(self.unit, self.unit, nil, nil, nil, "suicide")
	end
end
