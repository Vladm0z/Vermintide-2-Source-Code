-- chunkname: @scripts/managers/flow_helper/flow_helper_manager.lua

FlowHelperManager = class(FlowHelperManager)

FlowHelperManager.init = function (self, world)
	-- function 1
	self._line_of_sight_checks = {}
	self._physics_world = World.physics_world(world)
end

FlowHelperManager.update = function (self, t)
	-- function 2
	self:_update_line_of_sight_checks(t)
end

local INDEX_POSITION = 1
local INDEX_ACTOR = 4

FlowHelperManager._update_line_of_sight_checks = function (self, t)
	-- function 3
	for owner_unit, check_units in pairs(self._line_of_sight_checks) do
		for check_unit, data in pairs(check_units) do
			local source_unit = data.source_unit
			local should_update = t > data.last_t + data.time_between_checks

			if should_update then
				data.last_t = t

				if not Unit.alive(source_unit) or not Unit.alive(check_unit) then
					self:unregister_line_of_sight_check(source_unit, check_unit)
				else
					local from = Unit.world_position(source_unit, data.source_node)
					local to = Unit.world_position(check_unit, data.target_node)
					local direction = to - from
					local length = Vector3.length(direction)

					direction = Vector3.normalize(direction)

					local hit_pos = to
					local result = true
					local is_in_los = data.is_in_los
					local ignore_if_invisible = data.ignore_if_invisible

					if ignore_if_invisible then
						-- Nothing
					end

					ignore_if_invisible = ScriptUnit.has_extension(check_unit, "status_system")

					local status_extension = ignore_if_invisible

					::label_3_0::

					if status_extension and status_extension:is_invisible() then
						result = false
					else
						local hits = PhysicsWorld.immediate_raycast(self._physics_world, from, direction, length, "all", "collision_filter", data.collision_filter)

						if hits then
							for i = 1, #hits do
								local hit = hits[i]
								local hit_actor = hit[INDEX_ACTOR]
								local hit_unit = Actor.unit(hit_actor)

								if hit_unit ~= source_unit then
									result = hit_unit == check_unit
									hit_pos = hit[INDEX_POSITION]

									break
								end
							end
						end
					end

					if is_in_los ~= result then
						data.is_in_los = result

						local flow_event = Unit.flow_event
						local var_3_2 = owner_unit
						local flow_cb_enter

						if result then
							flow_cb_enter = data.flow_cb_enter

							if not flow_cb_enter then
								-- Nothing
							end
						end

						flow_cb_enter = data.flow_cb_leave

						::label_3_1::

						flow_event(var_3_2, flow_cb_enter)
					end
				end
			end
		end
	end
end

FlowHelperManager.register_line_of_sight_check = function (self, owner_unit, source_unit, source_node, unit_to_check, ignore_if_invisible, flow_cb_enter, flow_cb_leave, collision_filter, debug_draw)
	-- function 4
	local los_checks = self._line_of_sight_checks
	local var_4_0 = los_checks[owner_unit]

	if not var_4_0 then
		-- Nothing
	end

	var_4_0 = {}

	local source_checks = var_4_0

	::label_4_0::

	los_checks[owner_unit] = source_checks

	local tbl = {
		is_in_los = false,
		last_t = 0,
		time_between_checks = 0.3,
		flow_cb_enter = flow_cb_enter,
		flow_cb_leave = flow_cb_leave,
		ignore_if_invisible = ignore_if_invisible,
		source_unit = source_unit,
		source_node = source_node,
		collision_filter = collision_filter
	}
	local node

	if Unit.has_node(unit_to_check, "j_spine") then
		node = Unit.node(unit_to_check, "j_spine")

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_4_1::

	tbl.target_node = node
	tbl.debug_draw = not not debug_draw and not not {
		from = Vector3Box(),
		to = Vector3Box()
	}
	source_checks[unit_to_check] = tbl
end

FlowHelperManager.unregister_line_of_sight_check = function (self, owner_unit, unit_to_check)
	-- function 5
	local los_checks = self._line_of_sight_checks
	local source_checks = los_checks[owner_unit]

	if source_checks then
		source_checks[unit_to_check] = nil

		if table.is_empty(source_checks) then
			los_checks[owner_unit] = nil
		end
	end
end
