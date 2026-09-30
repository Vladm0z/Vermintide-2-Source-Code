-- chunkname: @core/wwise/lua/wwise_flow_callbacks.lua

local WwiseVisualization = require("core/wwise/lua/wwise_visualization")
local WwiseBankReference = require("core/wwise/lua/wwise_bank_reference")

WwiseFlowCallbacks = WwiseFlowCallbacks

local M = WwiseFlowCallbacks
local Application = stingray.Application
local Matrix4x4 = stingray.Matrix4x4
local Quaternion = stingray.Quaternion
local Script = stingray.Script
local Unit = stingray.Unit
local Vector3 = stingray.Vector3
local Wwise = stingray.Wwise
local WwiseWorld = stingray.WwiseWorld
local listener_map

if Wwise then
	listener_map = {
		Listener0 = Wwise.LISTENER_0,
		Listener1 = Wwise.LISTENER_1,
		Listener2 = Wwise.LISTENER_2,
		Listener3 = Wwise.LISTENER_3,
		Listener4 = Wwise.LISTENER_4,
		Listener5 = Wwise.LISTENER_5,
		Listener6 = Wwise.LISTENER_6,
		Listener7 = Wwise.LISTENER_7
	}
end

M.wwise_load_bank = function (t)
	-- function 1
	local name = t.Name

	if name == "" then
		return
	end

	Wwise.load_bank(name)

	local use_ref_count = t.Reference_Count

	if use_ref_count and use_ref_count == true then
		WwiseBankReference:add(name)
	end
end

M.wwise_unit_load_bank = function (t)
	-- function 2
	local name = t.Name
	local unit = t.Unit

	if unit then
		if name == "" then
			name = Unit.get_data(unit, "Wwise", "bank_name")
		end

		if name ~= "" then
			Wwise.load_bank(name)

			local use_ref_count = t.Reference_Count

			if use_ref_count and use_ref_count == true then
				WwiseBankReference:add(name)
			end
		end
	end
end

M.wwise_unload_bank = function (t)
	-- function 3
	local name = t.Name

	if name == "" then
		local unit = Application.flow_callback_context_unit()

		if unit then
			name = Unit.get_data(unit, "Wwise", "bank_name")
		end

		if name == nil or name == "" then
			return
		end
	end

	local use_ref_count = t.Reference_Count

	if use_ref_count and use_ref_count == true then
		WwiseBankReference:remove(name)

		if WwiseBankReference:count(name) == 0 then
			Wwise.unload_bank(name)
		end
	else
		Wwise.unload_bank(name)
	end
end

M.wwise_set_language = function (t)
	-- function 4
	local name = t.Name

	Wwise.set_language(name)
end

M.wwise_set_listener_pose = function (t)
	-- function 5
	local position = t.Position

	if not position then
		return
	end

	local listener = listener_map[t.Listener]
	local rotation = t.Rotation
	local pose = Matrix4x4.from_quaternion_position(rotation, position)
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_listener(wwise_world, listener, pose)
end

M.wwise_move_listener_to_unit = function (t)
	-- function 6
	local unit = t.Unit

	if not unit then
		return
	end

	local listener = listener_map[t.Listener]
	local unit_node_index = Script.index_offset()

	if t.Unit_Node or t.unit_node then
		unit_node_index = Unit.node(unit, t.Unit_Node)
	end

	local pose = Unit.world_pose(unit, unit_node_index)
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_listener(wwise_world, listener, pose)
end

M.wwise_trigger_event = function (t)
	-- function 7
	local name = t.Name
	local unit = t.Unit
	local use_occlusion = t.use_occlusion
	local r1, r2
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if unit then
		if name == "" then
			name = Unit.get_data(unit, "Wwise", "event_name") or ""
		end

		local unit_node_index = Script.index_offset()

		if t.Unit_Node or t.unit_node then
			unit_node_index = Unit.node(unit, t.Unit_Node)
		end

		r1, r2 = WwiseWorld.trigger_event(wwise_world, name, use_occlusion, unit, unit_node_index)
	else
		local position = t.Position

		if position then
			r1, r2 = WwiseWorld.trigger_event(wwise_world, name, use_occlusion, position)
		else
			local source_id = t.Existing_Source_Id

			if source_id then
				r1, r2 = WwiseWorld.trigger_event(wwise_world, name, use_occlusion, source_id)
			else
				r1, r2 = WwiseWorld.trigger_event(wwise_world, name)
			end
		end
	end

	return {
		playing_id = r1,
		source_id = r2,
		Playing_Id = r1,
		Source_Id = r2
	}
end

local function make_source(t, wwise_world_function)
	-- function 8
	local unit = t.Unit
	local r1
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if unit then
		local unit_node_index = Script.index_offset()

		if t.Unit_Node or t.unit_node then
			unit_node_index = Unit.node(unit, t.Unit_Node)
		end

		r1 = wwise_world_function(wwise_world, unit, unit_node_index)
	else
		local position = t.Position

		if position then
			r1 = wwise_world_function(wwise_world, position)
		else
			local source_id = t.Source_Id

			if source_id then
				r1 = wwise_world_function(wwise_world, source_id)
			else
				r1 = wwise_world_function(wwise_world)
			end
		end
	end

	return r1
end

M.wwise_make_auto_source = function (t)
	-- function 9
	local id = make_source(t, WwiseWorld.make_auto_source)

	return {
		source_id = id,
		Source_Id = id
	}
end

M.wwise_make_manual_source = function (t)
	-- function 10
	local id = make_source(t, WwiseWorld.make_manual_source)

	return {
		source_id = id,
		Source_Id = id
	}
end

M.wwise_destroy_manual_source = function (t)
	-- function 11
	local id = t.Source_Id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.destroy_manual_source(wwise_world, id)
end

M.wwise_stop_event = function (t)
	-- function 12
	local id = t.Playing_Id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.stop_event(wwise_world, id)
end

M.wwise_pause_event = function (t)
	-- function 13
	local id = t.Playing_Id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.pause_event(wwise_world, id)
end

M.wwise_resume_event = function (t)
	-- function 14
	local id = t.Playing_Id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.resume_event(wwise_world, id)
end

M.wwise_set_source_position = function (t)
	-- function 15
	local id = t.Source_Id
	local val = t.Position
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_source_position(wwise_world, id, val)
end

M.wwise_set_source_parameter = function (t)
	-- function 16
	local id = t.Source_Id
	local name = t.Parameter_Name
	local val = t.Value
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_source_parameter(wwise_world, id, name, val)
end

M.wwise_set_global_parameter = function (t)
	-- function 17
	local name = t.Parameter_Name
	local val = t.Value
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_global_parameter(wwise_world, name, val)
end

M.wwise_set_state = function (t)
	-- function 18
	local group = t.Group
	local state = t.State

	if not group or not state then
		return
	end

	Wwise.set_state(group, state)
end

M.wwise_set_switch = function (t)
	-- function 19
	local group = t.Group
	local state = t.State

	if not group or not state then
		return
	end

	local id = t.Source_Id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_switch(wwise_world, group, state, id)
end

M.wwise_post_trigger = function (t)
	-- function 20
	local id = t.Source_Id
	local name = t.Name

	if id and name then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.post_trigger(wwise_world, id, name)
	end
end

M.wwise_has_source = function (t)
	-- function 21
	local id = t.Source_Id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if WwiseWorld.has_source(wwise_world, id) then
		return {
			yes = true,
			Yes = true
		}
	else
		return {
			No = true,
			no = true
		}
	end
end

M.wwise_is_playing = function (t)
	-- function 22
	local id = t.Playing_Id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if WwiseWorld.is_playing(wwise_world, id) then
		return {
			yes = true,
			Yes = true
		}
	else
		return {
			No = true,
			no = true
		}
	end
end

M.wwise_get_playing_elapsed = function (t)
	-- function 23
	local id = t.Playing_Id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())
	local elapsed_in_ms = WwiseWorld.get_playing_elapsed(wwise_world, id)

	elapsed_in_ms = elapsed_in_ms or 0

	local seconds = elapsed_in_ms / 1000

	return {
		seconds = seconds,
		Seconds = seconds
	}
end

M.wwise_add_soundscape_source = function (t)
	-- function 24
	local name = t.Name
	local unit = t.Unit
	local shape = t.Shape
	local positioning = t.Positioning
	local trigger_range = t.Trigger_Range
	local result_id = -1

	if unit then
		if name == "" then
			name = Unit.get_data(unit, "Wwise", "event_name") or ""

			if name == "" then
				return {
					ss_source_id = result_id,
					SS_Source_Id = result_id
				}
			end
		end

		shape = shape or Unit.get_data(unit, "Wwise", "shape") or "point"
		shape = string.lower(shape)

		local shape_map = {
			point = Wwise.SHAPE_POINT,
			sphere = Wwise.SHAPE_SPHERE,
			box = Wwise.SHAPE_BOX
		}

		shape = shape_map[shape] or Wwise.SHAPE_POINT
		positioning = positioning or string.lower(Unit.get_data(unit, "Wwise", "positioning")) or "closest"

		local default_scale = 10
		local scale = default_scale

		if shape == Wwise.SHAPE_SPHERE then
			scale = t.Sphere_Radius or t.sphere_radius

			if not scale then
				scale = Unit.get_data(unit, "Wwise", "sphere_radius") or default_scale
			end
		elseif shape == Wwise.SHAPE_BOX then
			scale = t.Box_Scale or t.box_scale

			if not scale then
				scale = Vector3(0, 0, 0)
				scale.x = Unit.get_data(unit, "Wwise", "box_extents", 0)
				scale.y = Unit.get_data(unit, "Wwise", "box_extents", 1)
				scale.z = Unit.get_data(unit, "Wwise", "box_extents", 2)
			end
		end

		local positioning_map = {
			closest = Wwise.POSITIONING_CLOSEST_TO_LISTENER,
			["random in shape"] = Wwise.POSITIONING_RANDOM_IN_SHAPE,
			["random around listener"] = Wwise.POSITIONING_RANDOM_AROUND_LISTENER
		}

		positioning = positioning_map[positioning] or Wwise.POSITIONING_CLOSEST_TO_LISTENER

		local unit_node_index = Script.index_offset()

		if t.Unit_Node or t.unit_node then
			unit_node_index = Unit.node(unit, t.Unit_Node)
		end

		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		result_id = WwiseWorld.add_soundscape_unit_source(wwise_world, name, unit, unit_node_index, shape, scale, positioning, 0, 5, trigger_range)
	end

	return {
		ss_source_id = result_id,
		SS_Source_Id = result_id
	}
end

M.wwise_remove_soundscape_source = function (t)
	-- function 25
	local id = t.SS_Source_Id

	if not id then
		print("Error: nil soundscape source id, removing soundscape source failed.")

		return
	end

	if id == -1 then
		return
	end

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.remove_soundscape_source(wwise_world, id)
end

M.wwise_set_obstruction_and_occlusion_for_soundscape_source = function (t)
	-- function 26
	local id = t.SS_Source_Id
	local obstruction = t.Obstruction
	local occlusion = t.Occlusion

	if id then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_obstruction_and_occlusion_for_soundscape_source(wwise_world, id, obstruction, occlusion)
	end
end

M.wwise_add_soundscape_render_unit = function (t)
	-- function 27
	local unit = t.Unit

	if unit then
		WwiseVisualization.add_soundscape_unit(unit)
	end
end

M.wwise_set_environment = function (t)
	-- function 28
	local name = t.Aux_Bus
	local value = t.Value

	if name and value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_environment(wwise_world, name, value)
	end
end

M.wwise_set_dry_environment = function (t)
	-- function 29
	local value = t.Value

	if value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_dry_environment(wwise_world, value)
	end
end

M.wwise_reset_environment = function (t)
	-- function 30
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.reset_environment(wwise_world)
end

M.wwise_set_source_environment = function (t)
	-- function 31
	local id = t.Source_Id
	local name = t.Aux_Bus
	local value = t.Value

	if id and name and value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_environment_for_source(wwise_world, id, name, value)
	end
end

M.wwise_set_source_dry_environment = function (t)
	-- function 32
	local id = t.Source_Id
	local value = t.Value

	if id and value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_dry_environment_for_source(wwise_world, id, value)
	end
end

M.wwise_reset_source_environment = function (t)
	-- function 33
	local id = t.Source_Id

	if id then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.reset_environment_for_source(wwise_world, id)
	end
end

M.wwise_set_obstruction_and_occlusion = function (t)
	-- function 34
	local id = t.Source_Id
	local listener = listener_map[t.Listener]
	local obstruction = t.Obstruction
	local occlusion = t.Occlusion

	if id and listener then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_obstruction_and_occlusion(wwise_world, listener, id, obstruction, occlusion)
	end
end

if not Wwise then
	for k, v in pairs(M) do
		M[k] = function (t)
			-- function 35
			return
		end
	end
end

M.dialogue_silence_unit = function (t)
	-- function 36
	local unit = t.Unit
	local new_silenced_value = t.set_silenced

	if unit then
		if Unit.alive(unit) then
			local dialogue_extension = ScriptUnit.has_extension(unit, "dialogue_system")

			if dialogue_extension then
				dialogue_extension.input:set_silenced(new_silenced_value)
			else
				print("Warning: dialogue silence unit: can't find dialogue_system extension in ", unit)
			end
		else
			print("Warning: dialogue silence unit: omit non alive unit ", unit)
		end
	else
		print("Warning: dialogue silence unit: nil unit doing nothing.")
	end
end
