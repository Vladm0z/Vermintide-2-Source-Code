-- chunkname: @scripts/managers/flow_helper/flow_helper_manager.lua

FlowHelperManager = class(FlowHelperManager)

function FlowHelperManager.init(arg_1_0, arg_1_1)
	arg_1_0._line_of_sight_checks = {}
	arg_1_0._physics_world = World.physics_world(arg_1_1)
end

function FlowHelperManager.update(arg_2_0, arg_2_1)
	arg_2_0:_update_line_of_sight_checks(arg_2_1)
end

local var_0_0 = 1
local var_0_1 = 4

function FlowHelperManager._update_line_of_sight_checks(arg_3_0, arg_3_1)
	for iter_3_0, iter_3_1 in pairs(arg_3_0._line_of_sight_checks) do
		for iter_3_2, iter_3_3 in pairs(iter_3_1) do
			local var_3_0 = iter_3_3.source_unit

			if arg_3_1 > iter_3_3.last_t + iter_3_3.time_between_checks then
				iter_3_3.last_t = arg_3_1

				if not Unit.alive(var_3_0) or not Unit.alive(iter_3_2) then
					arg_3_0:unregister_line_of_sight_check(var_3_0, iter_3_2)
				else
					local var_3_1 = Unit.world_position(var_3_0, iter_3_3.source_node)
					local var_3_2 = Unit.world_position(iter_3_2, iter_3_3.target_node)
					local var_3_3 = var_3_2 - var_3_1
					local var_3_4 = Vector3.length(var_3_3)
					local var_3_5 = Vector3.normalize(var_3_3)
					local var_3_6 = var_3_2
					local var_3_7 = true
					local var_3_8 = iter_3_3.is_in_los
					local var_3_9 = iter_3_3.ignore_if_invisible and ScriptUnit.has_extension(iter_3_2, "status_system")

					if var_3_9 and var_3_9:is_invisible() then
						var_3_7 = false
					else
						local var_3_10 = PhysicsWorld.immediate_raycast(arg_3_0._physics_world, var_3_1, var_3_5, var_3_4, "all", "collision_filter", iter_3_3.collision_filter)

						if var_3_10 then
							for iter_3_4 = 1, #var_3_10 do
								local var_3_11 = var_3_10[iter_3_4]
								local var_3_12 = var_3_11[var_0_1]
								local var_3_13 = Actor.unit(var_3_12)

								if var_3_13 ~= var_3_0 then
									var_3_7 = var_3_13 == iter_3_2

									local var_3_14 = var_3_11[var_0_0]

									break
								end
							end
						end
					end

					if var_3_8 ~= var_3_7 then
						iter_3_3.is_in_los = var_3_7

						Unit.flow_event(iter_3_0, var_3_7 and iter_3_3.flow_cb_enter or iter_3_3.flow_cb_leave)
					end
				end
			end
		end
	end
end

function FlowHelperManager.register_line_of_sight_check(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9)
	local var_4_0 = arg_4_0._line_of_sight_checks
	local var_4_1 = var_4_0[arg_4_1] or {}

	var_4_0[arg_4_1] = var_4_1
	var_4_1[arg_4_4] = {
		is_in_los = false,
		last_t = 0,
		time_between_checks = 0.3,
		flow_cb_enter = arg_4_6,
		flow_cb_leave = arg_4_7,
		ignore_if_invisible = arg_4_5,
		source_unit = arg_4_2,
		source_node = arg_4_3,
		collision_filter = arg_4_8,
		target_node = Unit.has_node(arg_4_4, "j_spine") and Unit.node(arg_4_4, "j_spine") or 0,
		debug_draw = arg_4_9 and {
			from = Vector3Box(),
			to = Vector3Box()
		}
	}
end

function FlowHelperManager.unregister_line_of_sight_check(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._line_of_sight_checks
	local var_5_1 = var_5_0[arg_5_1]

	if var_5_1 then
		var_5_1[arg_5_2] = nil

		if table.is_empty(var_5_1) then
			var_5_0[arg_5_1] = nil
		end
	end
end
