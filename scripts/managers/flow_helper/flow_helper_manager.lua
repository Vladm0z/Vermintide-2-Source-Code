-- chunkname: @scripts/managers/flow_helper/flow_helper_manager.lua

FlowHelperManager = class(FlowHelperManager)

FlowHelperManager.init = function (self, arg_1_1)
	-- function 1
	self._line_of_sight_checks = {}
	self._physics_world = World.physics_world(arg_1_1)
end

FlowHelperManager.update = function (self, arg_2_1)
	-- function 2
	self:_update_line_of_sight_checks(arg_2_1)
end

local num = 1
local num_2 = 4

FlowHelperManager._update_line_of_sight_checks = function (self, arg_3_1)
	-- function 3
	for k, v in pairs(self._line_of_sight_checks) do
		for k_2, v_2 in pairs(v) do
			local source_unit = v_2.source_unit

			if not (arg_3_1 > v_2.last_t + v_2.time_between_checks) then
				v_2.last_t = arg_3_1

				if not (not Unit.alive(source_unit) and Unit.alive(k_2)) then
					self:unregister_line_of_sight_check(source_unit, k_2)
				else
					local world_position = Unit.world_position(source_unit, v_2.source_node)
					local world_position_2 = Unit.world_position(k_2, v_2.target_node)
					local num_3 = world_position_2 - world_position
					local length = Vector3.length(num_3)
					local normalize = Vector3.normalize(num_3)
					local var_3_6 = world_position_2
					local flag = true
					local is_in_los = v_2.is_in_los
					local ignore_if_invisible = v_2.ignore_if_invisible

					ignore_if_invisible = not ignore_if_invisible and ScriptUnit.has_extension(k_2, "status_system")

					if not ignore_if_invisible and not ignore_if_invisible:is_invisible() then
						flag = false
					else
						local immediate_raycast = PhysicsWorld.immediate_raycast(self._physics_world, world_position, normalize, length, "all", "collision_filter", v_2.collision_filter)

						if not immediate_raycast then
							for i4 = 1, #immediate_raycast do
								local var_3_11 = immediate_raycast[i4]
								local var_3_12 = var_3_11[num_2]
								local unit = Actor.unit(var_3_12)

								if unit ~= source_unit then
									flag = unit == k_2

									local var_3_14 = var_3_11[num]

									break
								end
							end
						end
					end

					if is_in_los ~= flag then
						v_2.is_in_los = flag

						local flow_event = Unit.flow_event
						local var_3_16 = k
						local flow_cb_enter

						if not flag then
							flow_cb_enter = v_2.flow_cb_enter

							if not flow_cb_enter then
								-- Nothing
							end
						end

						flow_cb_enter = v_2.flow_cb_leave

						::label_3_0::

						flow_event(var_3_16, flow_cb_enter)
					end
				end
			end
		end
	end
end

FlowHelperManager.register_line_of_sight_check = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9)
	-- function 4
	local _line_of_sight_checks = self._line_of_sight_checks
	local var_4_1 = _line_of_sight_checks[arg_4_1]

	var_4_1 = var_4_1 or {}
	_line_of_sight_checks[arg_4_1] = var_4_1

	local tbl = {
		is_in_los = false,
		last_t = 0,
		time_between_checks = 0.3,
		flow_cb_enter = arg_4_6,
		flow_cb_leave = arg_4_7,
		ignore_if_invisible = arg_4_5,
		source_unit = arg_4_2,
		source_node = arg_4_3,
		collision_filter = arg_4_8
	}
	local node

	if not Unit.has_node(arg_4_4, "j_spine") then
		node = Unit.node(arg_4_4, "j_spine")

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_4_0::

	tbl.target_node = node
	tbl.debug_draw = not arg_4_9 and {
		from = Vector3Box(),
		to = Vector3Box()
	}
	var_4_1[arg_4_4] = tbl
end

FlowHelperManager.unregister_line_of_sight_check = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _line_of_sight_checks = self._line_of_sight_checks
	local var_5_1 = _line_of_sight_checks[arg_5_1]

	if not var_5_1 then
		var_5_1[arg_5_2] = nil

		if not table.is_empty(var_5_1) then
			_line_of_sight_checks[arg_5_1] = nil
		end
	end
end
