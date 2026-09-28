-- chunkname: @core/wwise/lua/wwise_flow_callbacks.lua

local WwiseVisualization = require("core/wwise/lua/wwise_visualization")
local WwiseBankReference = require("core/wwise/lua/wwise_bank_reference")
local WwiseFlowCallbacks = WwiseFlowCallbacks

WwiseFlowCallbacks = not not WwiseFlowCallbacks or not not {}
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
	local Name = t.Name

	if not Name then
		-- Nothing
	end

	Name = t.name

	if not Name then
		-- Nothing
	end

	Name = ""

	local name = Name

	::label_1_0::

	if name == "" then
		return
	end

	Wwise.load_bank(name)

	local Reference_Count = t.Reference_Count

	if not Reference_Count then
		-- Nothing
	end

	Reference_Count = false

	local use_ref_count = Reference_Count

	::label_1_1::

	if use_ref_count and use_ref_count == true then
		WwiseBankReference:add(name)
	end
end

M.wwise_unit_load_bank = function (t)
	-- function 2
	local Name = t.Name

	if not Name then
		-- Nothing
	end

	Name = t.name

	if not Name then
		-- Nothing
	end

	Name = ""

	local name = Name

	::label_2_0::

	local Unit_2 = t.Unit

	if not Unit_2 then
		-- Nothing
	end

	Unit_2 = t.unit

	local unit = Unit_2

	::label_2_1::

	if unit then
		if name == "" then
			name = Unit.get_data(unit, "Wwise", "bank_name")
		end

		if name ~= "" then
			Wwise.load_bank(name)

			local Reference_Count = t.Reference_Count

			if not Reference_Count then
				-- Nothing
			end

			Reference_Count = false

			local use_ref_count = Reference_Count

			::label_2_2::

			if use_ref_count and use_ref_count == true then
				WwiseBankReference:add(name)
			end
		end
	end
end

M.wwise_unload_bank = function (t)
	-- function 3
	local Name = t.Name

	if not Name then
		-- Nothing
	end

	Name = t.name

	if not Name then
		-- Nothing
	end

	Name = ""

	local name = Name

	::label_3_0::

	if name == "" then
		local unit = Application.flow_callback_context_unit()

		if unit then
			name = Unit.get_data(unit, "Wwise", "bank_name")
		end

		if name == nil or name == "" then
			return
		end
	end

	local Reference_Count = t.Reference_Count

	if not Reference_Count then
		-- Nothing
	end

	Reference_Count = false

	local use_ref_count = Reference_Count

	::label_3_1::

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
	local Name = t.Name

	if not Name then
		-- Nothing
	end

	Name = t.name

	if not Name then
		-- Nothing
	end

	Name = ""

	local name = Name

	::label_4_0::

	Wwise.set_language(name)
end

M.wwise_set_listener_pose = function (t)
	-- function 5
	local Position = t.Position

	if not Position then
		-- Nothing
	end

	Position = t.position

	local position = Position

	::label_5_0::

	if not position then
		return
	end

	local var_5_1 = listener_map
	local Listener = t.Listener

	Listener = not not Listener or not not t.listener

	local listener = var_5_1[Listener]
	local Rotation = t.Rotation

	if not Rotation then
		-- Nothing
	end

	Rotation = t.rotation

	if not Rotation then
		-- Nothing
	end

	Rotation = Quaternion.identity()

	local rotation = Rotation

	::label_5_1::

	local pose = Matrix4x4.from_quaternion_position(rotation, position)
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_listener(wwise_world, listener, pose)
end

M.wwise_move_listener_to_unit = function (t)
	-- function 6
	local Unit_2 = t.Unit

	if not Unit_2 then
		-- Nothing
	end

	Unit_2 = t.unit

	local unit = Unit_2

	::label_6_0::

	if not unit then
		return
	end

	local var_6_1 = listener_map
	local Listener = t.Listener

	Listener = not not Listener or not not t.listener

	local listener = var_6_1[Listener]
	local unit_node_index = Script.index_offset()

	if t.Unit_Node or t.unit_node then
		local node = Unit.node
		local var_6_4 = unit
		local Unit_Node = t.Unit_Node

		Unit_Node = not not Unit_Node or not not t.unit_node
		unit_node_index = node(var_6_4, Unit_Node)
	end

	local pose = Unit.world_pose(unit, unit_node_index)
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_listener(wwise_world, listener, pose)
end

M.wwise_trigger_event = function (t)
	-- function 7
	local Name = t.Name

	if not Name then
		-- Nothing
	end

	Name = t.name

	if not Name then
		-- Nothing
	end

	Name = ""

	local name = Name

	::label_7_0::

	local Unit_2 = t.Unit

	if not Unit_2 then
		-- Nothing
	end

	Unit_2 = t.unit

	local unit = Unit_2

	::label_7_1::

	local use_occlusion_2 = t.use_occlusion

	if not use_occlusion_2 then
		-- Nothing
	end

	use_occlusion_2 = false

	local use_occlusion = use_occlusion_2

	::label_7_2::

	local r1, r2
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if unit then
		if name == "" then
			name = not not Unit.get_data(unit, "Wwise", "event_name") or not not ""
		end

		local unit_node_index = Script.index_offset()

		if t.Unit_Node or t.unit_node then
			local node = Unit.node
			local var_7_4 = unit
			local Unit_Node = t.Unit_Node

			Unit_Node = not not Unit_Node or not not t.unit_node
			unit_node_index = node(var_7_4, Unit_Node)
		end

		r1, r2 = WwiseWorld.trigger_event(wwise_world, name, use_occlusion, unit, unit_node_index)
	else
		local Position = t.Position

		if not Position then
			-- Nothing
		end

		Position = t.position

		local position = Position

		::label_7_3::

		if position then
			r1, r2 = WwiseWorld.trigger_event(wwise_world, name, use_occlusion, position)
		else
			local Existing_Source_Id = t.Existing_Source_Id

			if not Existing_Source_Id then
				-- Nothing
			end

			Existing_Source_Id = t.existing_source_id

			local source_id = Existing_Source_Id

			::label_7_4::

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
	local Unit_2 = t.Unit

	if not Unit_2 then
		-- Nothing
	end

	Unit_2 = t.unit

	local unit = Unit_2

	::label_8_0::

	local r1
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if unit then
		local unit_node_index = Script.index_offset()

		if t.Unit_Node or t.unit_node then
			local node = Unit.node
			local var_8_2 = unit
			local Unit_Node = t.Unit_Node

			Unit_Node = not not Unit_Node or not not t.unit_node
			unit_node_index = node(var_8_2, Unit_Node)
		end

		r1 = wwise_world_function(wwise_world, unit, unit_node_index)
	else
		local Position = t.Position

		if not Position then
			-- Nothing
		end

		Position = t.position

		local position = Position

		::label_8_1::

		if position then
			r1 = wwise_world_function(wwise_world, position)
		else
			local Source_Id = t.Source_Id

			if not Source_Id then
				-- Nothing
			end

			Source_Id = t.source_id

			local source_id = Source_Id

			::label_8_2::

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
	local Source_Id = t.Source_Id

	if not Source_Id then
		-- Nothing
	end

	Source_Id = t.source_id

	local id = Source_Id

	::label_11_0::

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.destroy_manual_source(wwise_world, id)
end

M.wwise_stop_event = function (t)
	-- function 12
	local Playing_Id = t.Playing_Id

	if not Playing_Id then
		-- Nothing
	end

	Playing_Id = t.playing_id

	local id = Playing_Id

	::label_12_0::

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.stop_event(wwise_world, id)
end

M.wwise_pause_event = function (t)
	-- function 13
	local Playing_Id = t.Playing_Id

	if not Playing_Id then
		-- Nothing
	end

	Playing_Id = t.playing_id

	local id = Playing_Id

	::label_13_0::

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.pause_event(wwise_world, id)
end

M.wwise_resume_event = function (t)
	-- function 14
	local Playing_Id = t.Playing_Id

	if not Playing_Id then
		-- Nothing
	end

	Playing_Id = t.playing_id

	local id = Playing_Id

	::label_14_0::

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.resume_event(wwise_world, id)
end

M.wwise_set_source_position = function (t)
	-- function 15
	local Source_Id = t.Source_Id

	if not Source_Id then
		-- Nothing
	end

	Source_Id = t.source_id

	local id = Source_Id

	::label_15_0::

	local Position = t.Position

	if not Position then
		-- Nothing
	end

	Position = t.position

	local val = Position

	::label_15_1::

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_source_position(wwise_world, id, val)
end

M.wwise_set_source_parameter = function (t)
	-- function 16
	local Source_Id = t.Source_Id

	if not Source_Id then
		-- Nothing
	end

	Source_Id = t.source_id

	local id = Source_Id

	::label_16_0::

	local Parameter_Name = t.Parameter_Name

	if not Parameter_Name then
		-- Nothing
	end

	Parameter_Name = t.parameter_name

	if not Parameter_Name then
		-- Nothing
	end

	Parameter_Name = ""

	local name = Parameter_Name

	::label_16_1::

	local Value = t.Value

	if not Value then
		-- Nothing
	end

	Value = t.value

	local val = Value

	::label_16_2::

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_source_parameter(wwise_world, id, name, val)
end

M.wwise_set_global_parameter = function (t)
	-- function 17
	local Parameter_Name = t.Parameter_Name

	if not Parameter_Name then
		-- Nothing
	end

	Parameter_Name = t.parameter_name

	if not Parameter_Name then
		-- Nothing
	end

	Parameter_Name = ""

	local name = Parameter_Name

	::label_17_0::

	local Value = t.Value

	if not Value then
		-- Nothing
	end

	Value = t.value

	local val = Value

	::label_17_1::

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_global_parameter(wwise_world, name, val)
end

M.wwise_set_state = function (t)
	-- function 18
	local Group = t.Group

	if not Group then
		-- Nothing
	end

	Group = t.group

	local group = Group

	::label_18_0::

	local State = t.State

	if not State then
		-- Nothing
	end

	State = t.state

	local state = State

	::label_18_1::

	if not group or not state then
		return
	end

	Wwise.set_state(group, state)
end

M.wwise_set_switch = function (t)
	-- function 19
	local Group = t.Group

	if not Group then
		-- Nothing
	end

	Group = t.group

	local group = Group

	::label_19_0::

	local State = t.State

	if not State then
		-- Nothing
	end

	State = t.state

	local state = State

	::label_19_1::

	if not group or not state then
		return
	end

	local Source_Id = t.Source_Id

	if not Source_Id then
		-- Nothing
	end

	Source_Id = t.source_id

	local id = Source_Id

	::label_19_2::

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_switch(wwise_world, group, state, id)
end

M.wwise_post_trigger = function (t)
	-- function 20
	local Source_Id = t.Source_Id

	if not Source_Id then
		-- Nothing
	end

	Source_Id = t.source_id

	local id = Source_Id

	::label_20_0::

	local Name = t.Name

	if not Name then
		-- Nothing
	end

	Name = t.name

	local name = Name

	::label_20_1::

	if id and name then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.post_trigger(wwise_world, id, name)
	end
end

M.wwise_has_source = function (t)
	-- function 21
	local Source_Id = t.Source_Id

	if not Source_Id then
		-- Nothing
	end

	Source_Id = t.source_id

	local id = Source_Id

	::label_21_0::

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
	local Playing_Id = t.Playing_Id

	if not Playing_Id then
		-- Nothing
	end

	Playing_Id = t.playing_id

	local id = Playing_Id

	::label_22_0::

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
	local Playing_Id = t.Playing_Id

	if not Playing_Id then
		-- Nothing
	end

	Playing_Id = t.playing_id

	local id = Playing_Id

	::label_23_0::

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())
	local elapsed_in_ms = WwiseWorld.get_playing_elapsed(wwise_world, id)

	elapsed_in_ms = not not elapsed_in_ms or not not 0

	local seconds = elapsed_in_ms / 1000

	return {
		seconds = seconds,
		Seconds = seconds
	}
end

M.wwise_add_soundscape_source = function (t)
	-- function 24
	local Name = t.Name

	if not Name then
		-- Nothing
	end

	Name = t.name

	if not Name then
		-- Nothing
	end

	Name = ""

	local name = Name

	::label_24_0::

	local Unit_2 = t.Unit

	if not Unit_2 then
		-- Nothing
	end

	Unit_2 = t.unit

	local unit = Unit_2

	::label_24_1::

	local Shape = t.Shape

	if not Shape then
		-- Nothing
	end

	Shape = t.shape

	local shape = Shape

	::label_24_2::

	local Positioning = t.Positioning

	if not Positioning then
		-- Nothing
	end

	Positioning = t.positioning

	local positioning = Positioning

	::label_24_3::

	local Trigger_Range = t.Trigger_Range

	if not Trigger_Range then
		-- Nothing
	end

	Trigger_Range = t.trigger_range

	local trigger_range = Trigger_Range

	::label_24_4::

	local result_id = -1

	if unit then
		if name == "" then
			name = not not Unit.get_data(unit, "Wwise", "event_name") or not not ""

			if name == "" then
				return {
					ss_source_id = result_id,
					SS_Source_Id = result_id
				}
			end
		end

		shape = not not shape or not not Unit.get_data(unit, "Wwise", "shape") or not not "point"
		shape = string.lower(shape)

		local shape_map = {
			point = Wwise.SHAPE_POINT,
			sphere = Wwise.SHAPE_SPHERE,
			box = Wwise.SHAPE_BOX
		}

		shape = not not shape_map[shape] or not not Wwise.SHAPE_POINT
		positioning = not not positioning or not not string.lower(Unit.get_data(unit, "Wwise", "positioning")) or not not "closest"

		local default_scale = 10
		local scale = default_scale

		if shape == Wwise.SHAPE_SPHERE then
			scale = not not t.Sphere_Radius or not not t.sphere_radius

			if not scale then
				scale = not not Unit.get_data(unit, "Wwise", "sphere_radius") or not not default_scale
			end
		elseif shape == Wwise.SHAPE_BOX then
			scale = not not t.Box_Scale or not not t.box_scale

			if not scale then
				scale = Vector3(0, 0, 0)

				local get_data = Unit.get_data(unit, "Wwise", "box_extents", 0)

				get_data = not not get_data or not not default_scale
				scale.x = get_data

				local get_data_2 = Unit.get_data(unit, "Wwise", "box_extents", 1)

				get_data_2 = not not get_data_2 or not not default_scale
				scale.y = get_data_2

				local get_data_3 = Unit.get_data(unit, "Wwise", "box_extents", 2)

				get_data_3 = not not get_data_3 or not not default_scale
				scale.z = get_data_3
			end
		end

		local positioning_map = {
			closest = Wwise.POSITIONING_CLOSEST_TO_LISTENER,
			["random in shape"] = Wwise.POSITIONING_RANDOM_IN_SHAPE,
			["random around listener"] = Wwise.POSITIONING_RANDOM_AROUND_LISTENER
		}

		positioning = not not positioning_map[positioning] or not not Wwise.POSITIONING_CLOSEST_TO_LISTENER

		local unit_node_index = Script.index_offset()

		if t.Unit_Node or t.unit_node then
			local node = Unit.node
			local var_24_9 = unit
			local Unit_Node = t.Unit_Node

			Unit_Node = not not Unit_Node or not not t.unit_node
			unit_node_index = node(var_24_9, Unit_Node)
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
	local SS_Source_Id = t.SS_Source_Id

	if not SS_Source_Id then
		-- Nothing
	end

	SS_Source_Id = t.ss_source_id

	local id = SS_Source_Id

	::label_25_0::

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
	local SS_Source_Id = t.SS_Source_Id

	if not SS_Source_Id then
		-- Nothing
	end

	SS_Source_Id = t.ss_source_id

	local id = SS_Source_Id

	::label_26_0::

	local Obstruction = t.Obstruction

	if not Obstruction then
		-- Nothing
	end

	Obstruction = t.obstruction

	if not Obstruction then
		-- Nothing
	end

	Obstruction = 0

	local obstruction = Obstruction

	::label_26_1::

	local Occlusion = t.Occlusion

	if not Occlusion then
		-- Nothing
	end

	Occlusion = t.occlusion

	if not Occlusion then
		-- Nothing
	end

	Occlusion = 0

	local occlusion = Occlusion

	::label_26_2::

	if id then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_obstruction_and_occlusion_for_soundscape_source(wwise_world, id, obstruction, occlusion)
	end
end

M.wwise_add_soundscape_render_unit = function (t)
	-- function 27
	local Unit = t.Unit

	if not Unit then
		-- Nothing
	end

	Unit = t.unit

	local unit = Unit

	::label_27_0::

	if unit then
		WwiseVisualization.add_soundscape_unit(unit)
	end
end

M.wwise_set_environment = function (t)
	-- function 28
	local Aux_Bus = t.Aux_Bus

	if not Aux_Bus then
		-- Nothing
	end

	Aux_Bus = t.aux_bus

	local name = Aux_Bus

	::label_28_0::

	local Value = t.Value

	if not Value then
		-- Nothing
	end

	Value = t.value

	local value = Value

	::label_28_1::

	if name and value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_environment(wwise_world, name, value)
	end
end

M.wwise_set_dry_environment = function (t)
	-- function 29
	local Value = t.Value

	if not Value then
		-- Nothing
	end

	Value = t.value

	local value = Value

	::label_29_0::

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
	local Source_Id = t.Source_Id

	if not Source_Id then
		-- Nothing
	end

	Source_Id = t.source_id

	local id = Source_Id

	::label_31_0::

	local Aux_Bus = t.Aux_Bus

	if not Aux_Bus then
		-- Nothing
	end

	Aux_Bus = t.aux_bus

	local name = Aux_Bus

	::label_31_1::

	local Value = t.Value

	if not Value then
		-- Nothing
	end

	Value = t.value

	local value = Value

	::label_31_2::

	if id and name and value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_environment_for_source(wwise_world, id, name, value)
	end
end

M.wwise_set_source_dry_environment = function (t)
	-- function 32
	local Source_Id = t.Source_Id

	if not Source_Id then
		-- Nothing
	end

	Source_Id = t.source_id

	local id = Source_Id

	::label_32_0::

	local Value = t.Value

	if not Value then
		-- Nothing
	end

	Value = t.value

	local value = Value

	::label_32_1::

	if id and value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_dry_environment_for_source(wwise_world, id, value)
	end
end

M.wwise_reset_source_environment = function (t)
	-- function 33
	local Source_Id = t.Source_Id

	if not Source_Id then
		-- Nothing
	end

	Source_Id = t.source_id

	local id = Source_Id

	::label_33_0::

	if id then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.reset_environment_for_source(wwise_world, id)
	end
end

M.wwise_set_obstruction_and_occlusion = function (t)
	-- function 34
	local Source_Id = t.Source_Id

	if not Source_Id then
		-- Nothing
	end

	Source_Id = t.source_id

	local id = Source_Id

	::label_34_0::

	local var_34_1 = listener_map
	local Listener = t.Listener

	Listener = not not Listener or not not t.listener

	local listener = var_34_1[Listener]
	local Obstruction = t.Obstruction

	if not Obstruction then
		-- Nothing
	end

	Obstruction = t.obstruction

	if not Obstruction then
		-- Nothing
	end

	Obstruction = 0

	local obstruction = Obstruction

	::label_34_1::

	local Occlusion = t.Occlusion

	if not Occlusion then
		-- Nothing
	end

	Occlusion = t.occlusion

	if not Occlusion then
		-- Nothing
	end

	Occlusion = 0

	local occlusion = Occlusion

	::label_34_2::

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
	local Unit_2 = t.Unit

	if not Unit_2 then
		-- Nothing
	end

	Unit_2 = t.unit

	local unit = Unit_2

	::label_36_0::

	local set_silenced = t.set_silenced

	if not set_silenced then
		-- Nothing
	end

	set_silenced = false

	local new_silenced_value = set_silenced

	::label_36_1::

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
