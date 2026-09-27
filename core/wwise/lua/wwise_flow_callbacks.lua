-- chunkname: @core/wwise/lua/wwise_flow_callbacks.lua

local core_wwise_lua_wwise_visualization = require("core/wwise/lua/wwise_visualization")
local core_wwise_lua_wwise_bank_reference = require("core/wwise/lua/wwise_bank_reference")
local WwiseFlowCallbacks = WwiseFlowCallbacks

WwiseFlowCallbacks = WwiseFlowCallbacks or {}
WwiseFlowCallbacks = WwiseFlowCallbacks

local WwiseFlowCallbacks_2 = WwiseFlowCallbacks
local Application = stingray.Application
local Matrix4x4 = stingray.Matrix4x4
local Quaternion = stingray.Quaternion
local Script = stingray.Script
local Unit = stingray.Unit
local Vector3 = stingray.Vector3
local Wwise = stingray.Wwise
local WwiseWorld = stingray.WwiseWorld
local var_0_12

if not Wwise then
	var_0_12 = {
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

WwiseFlowCallbacks_2.wwise_load_bank = function (self)
	-- function 1
	local Name = self.Name

	if not Name then
		Name = self.name
		Name = Name or ""
	end

	if Name == "" then
		return
	end

	Wwise.load_bank(Name)

	local Reference_Count = self.Reference_Count

	Reference_Count = Reference_Count or false

	if not (not Reference_Count and Reference_Count ~= true) then
		core_wwise_lua_wwise_bank_reference:add(Name)
	end
end

WwiseFlowCallbacks_2.wwise_unit_load_bank = function (self)
	-- function 2
	local Name = self.Name

	if not Name then
		Name = self.name
		Name = Name or ""
	end

	local Unit_2 = self.Unit

	Unit_2 = Unit_2 or self.unit

	if not Unit_2 then
		if Name == "" then
			Name = Unit.get_data(Unit_2, "Wwise", "bank_name")
		end

		if Name ~= "" then
			Wwise.load_bank(Name)

			local Reference_Count = self.Reference_Count

			Reference_Count = Reference_Count or false

			if not (not Reference_Count and Reference_Count ~= true) then
				core_wwise_lua_wwise_bank_reference:add(Name)
			end
		end
	end
end

WwiseFlowCallbacks_2.wwise_unload_bank = function (self)
	-- function 3
	local Name = self.Name

	if not Name then
		Name = self.name
		Name = Name or ""
	end

	if Name == "" then
		local flow_callback_context_unit = Application.flow_callback_context_unit()

		if not flow_callback_context_unit then
			Name = Unit.get_data(flow_callback_context_unit, "Wwise", "bank_name")
		end

		if not (Name == nil or Name ~= "") then
			return
		end
	end

	local Reference_Count = self.Reference_Count

	Reference_Count = Reference_Count or false

	if not (not Reference_Count and Reference_Count ~= true) then
		core_wwise_lua_wwise_bank_reference:remove(Name)

		if core_wwise_lua_wwise_bank_reference:count(Name) == 0 then
			Wwise.unload_bank(Name)
		end
	else
		Wwise.unload_bank(Name)
	end
end

WwiseFlowCallbacks_2.wwise_set_language = function (self)
	-- function 4
	local Name = self.Name

	if not Name then
		Name = self.name
		Name = Name or ""
	end

	Wwise.set_language(Name)
end

WwiseFlowCallbacks_2.wwise_set_listener_pose = function (self)
	-- function 5
	local Position = self.Position

	Position = Position or self.position

	if not Position then
		return
	end

	local var_5_1 = var_0_12
	local Listener = self.Listener

	Listener = Listener or self.listener

	local var_5_3 = var_5_1[Listener]
	local Rotation = self.Rotation

	if not Rotation then
		Rotation = self.rotation
		Rotation = Rotation or Quaternion.identity()
	end

	local from_quaternion_position = Matrix4x4.from_quaternion_position(Rotation, Position)
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_listener(wwise_world, var_5_3, from_quaternion_position)
end

WwiseFlowCallbacks_2.wwise_move_listener_to_unit = function (self)
	-- function 6
	local Unit_2 = self.Unit

	Unit_2 = Unit_2 or self.unit

	if not Unit_2 then
		return
	end

	local var_6_1 = var_0_12
	local Listener = self.Listener

	Listener = Listener or self.listener

	local var_6_3 = var_6_1[Listener]
	local index_offset = Script.index_offset()

	if self.Unit_Node or not self.unit_node then
		local node = Unit.node
		local var_6_6 = Unit_2
		local Unit_Node = self.Unit_Node

		Unit_Node = Unit_Node or self.unit_node
		index_offset = node(var_6_6, Unit_Node)
	end

	local world_pose = Unit.world_pose(Unit_2, index_offset)
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_listener(wwise_world, var_6_3, world_pose)
end

WwiseFlowCallbacks_2.wwise_trigger_event = function (self)
	-- function 7
	local Name = self.Name

	if not Name then
		Name = self.name
		Name = Name or ""
	end

	local Unit_2 = self.Unit

	Unit_2 = Unit_2 or self.unit

	local use_occlusion = self.use_occlusion

	use_occlusion = use_occlusion or false

	local var_7_3
	local var_7_4
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if not Unit_2 then
		if Name == "" then
			Name = Unit.get_data(Unit_2, "Wwise", "event_name") or ""
		end

		local index_offset = Script.index_offset()

		if self.Unit_Node or not self.unit_node then
			local node = Unit.node
			local var_7_8 = Unit_2
			local Unit_Node = self.Unit_Node

			Unit_Node = Unit_Node or self.unit_node
			index_offset = node(var_7_8, Unit_Node)
		end

		var_7_3, var_7_4 = WwiseWorld.trigger_event(wwise_world, Name, use_occlusion, Unit_2, index_offset)
	else
		local Position = self.Position

		Position = Position or self.position

		if not Position then
			var_7_3, var_7_4 = WwiseWorld.trigger_event(wwise_world, Name, use_occlusion, Position)
		else
			local Existing_Source_Id = self.Existing_Source_Id

			Existing_Source_Id = Existing_Source_Id or self.existing_source_id

			if not Existing_Source_Id then
				var_7_3, var_7_4 = WwiseWorld.trigger_event(wwise_world, Name, use_occlusion, Existing_Source_Id)
			else
				var_7_3, var_7_4 = WwiseWorld.trigger_event(wwise_world, Name)
			end
		end
	end

	return {
		playing_id = var_7_3,
		source_id = var_7_4,
		Playing_Id = var_7_3,
		Source_Id = var_7_4
	}
end

local function fn(self, arg_8_1)
	-- function 8
	local Unit_2 = self.Unit

	Unit_2 = Unit_2 or self.unit

	local var_8_1
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if not Unit_2 then
		local index_offset = Script.index_offset()

		if self.Unit_Node or not self.unit_node then
			local node = Unit.node
			local var_8_5 = Unit_2
			local Unit_Node = self.Unit_Node

			Unit_Node = Unit_Node or self.unit_node
			index_offset = node(var_8_5, Unit_Node)
		end

		var_8_1 = arg_8_1(wwise_world, Unit_2, index_offset)
	else
		local Position = self.Position

		Position = Position or self.position

		if not Position then
			var_8_1 = arg_8_1(wwise_world, Position)
		else
			local Source_Id = self.Source_Id

			Source_Id = Source_Id or self.source_id

			if not Source_Id then
				var_8_1 = arg_8_1(wwise_world, Source_Id)
			else
				var_8_1 = arg_8_1(wwise_world)
			end
		end
	end

	return var_8_1
end

WwiseFlowCallbacks_2.wwise_make_auto_source = function (arg_9_0)
	-- function 9
	local var_9_0 = fn(arg_9_0, WwiseWorld.make_auto_source)

	return {
		source_id = var_9_0,
		Source_Id = var_9_0
	}
end

WwiseFlowCallbacks_2.wwise_make_manual_source = function (arg_10_0)
	-- function 10
	local var_10_0 = fn(arg_10_0, WwiseWorld.make_manual_source)

	return {
		source_id = var_10_0,
		Source_Id = var_10_0
	}
end

WwiseFlowCallbacks_2.wwise_destroy_manual_source = function (self)
	-- function 11
	local Source_Id = self.Source_Id

	Source_Id = Source_Id or self.source_id

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.destroy_manual_source(wwise_world, Source_Id)
end

WwiseFlowCallbacks_2.wwise_stop_event = function (self)
	-- function 12
	local Playing_Id = self.Playing_Id

	Playing_Id = Playing_Id or self.playing_id

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.stop_event(wwise_world, Playing_Id)
end

WwiseFlowCallbacks_2.wwise_pause_event = function (self)
	-- function 13
	local Playing_Id = self.Playing_Id

	Playing_Id = Playing_Id or self.playing_id

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.pause_event(wwise_world, Playing_Id)
end

WwiseFlowCallbacks_2.wwise_resume_event = function (self)
	-- function 14
	local Playing_Id = self.Playing_Id

	Playing_Id = Playing_Id or self.playing_id

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.resume_event(wwise_world, Playing_Id)
end

WwiseFlowCallbacks_2.wwise_set_source_position = function (self)
	-- function 15
	local Source_Id = self.Source_Id

	Source_Id = Source_Id or self.source_id

	local Position = self.Position

	Position = Position or self.position

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_source_position(wwise_world, Source_Id, Position)
end

WwiseFlowCallbacks_2.wwise_set_source_parameter = function (self)
	-- function 16
	local Source_Id = self.Source_Id

	Source_Id = Source_Id or self.source_id

	local Parameter_Name = self.Parameter_Name

	if not Parameter_Name then
		Parameter_Name = self.parameter_name
		Parameter_Name = Parameter_Name or ""
	end

	local Value = self.Value

	Value = Value or self.value

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_source_parameter(wwise_world, Source_Id, Parameter_Name, Value)
end

WwiseFlowCallbacks_2.wwise_set_global_parameter = function (self)
	-- function 17
	local Parameter_Name = self.Parameter_Name

	if not Parameter_Name then
		Parameter_Name = self.parameter_name
		Parameter_Name = Parameter_Name or ""
	end

	local Value = self.Value

	Value = Value or self.value

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_global_parameter(wwise_world, Parameter_Name, Value)
end

WwiseFlowCallbacks_2.wwise_set_state = function (self)
	-- function 18
	local Group = self.Group

	Group = Group or self.group

	local State = self.State

	State = State or self.state

	if not (not Group and State) then
		return
	end

	Wwise.set_state(Group, State)
end

WwiseFlowCallbacks_2.wwise_set_switch = function (self)
	-- function 19
	local Group = self.Group

	Group = Group or self.group

	local State = self.State

	State = State or self.state

	if not (not Group and State) then
		return
	end

	local Source_Id = self.Source_Id

	Source_Id = Source_Id or self.source_id

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_switch(wwise_world, Group, State, Source_Id)
end

WwiseFlowCallbacks_2.wwise_post_trigger = function (self)
	-- function 20
	local Source_Id = self.Source_Id

	Source_Id = Source_Id or self.source_id

	local Name = self.Name

	Name = Name or self.name

	if not Source_Id and not Name then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.post_trigger(wwise_world, Source_Id, Name)
	end
end

WwiseFlowCallbacks_2.wwise_has_source = function (self)
	-- function 21
	local Source_Id = self.Source_Id

	Source_Id = Source_Id or self.source_id

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if not WwiseWorld.has_source(wwise_world, Source_Id) then
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

WwiseFlowCallbacks_2.wwise_is_playing = function (self)
	-- function 22
	local Playing_Id = self.Playing_Id

	Playing_Id = Playing_Id or self.playing_id

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if not WwiseWorld.is_playing(wwise_world, Playing_Id) then
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

WwiseFlowCallbacks_2.wwise_get_playing_elapsed = function (self)
	-- function 23
	local Playing_Id = self.Playing_Id

	Playing_Id = Playing_Id or self.playing_id

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())
	local get_playing_elapsed = WwiseWorld.get_playing_elapsed(wwise_world, Playing_Id)

	get_playing_elapsed = get_playing_elapsed or 0

	local num = get_playing_elapsed / 1000

	return {
		seconds = num,
		Seconds = num
	}
end

WwiseFlowCallbacks_2.wwise_add_soundscape_source = function (self)
	-- function 24
	local Name = self.Name

	if not Name then
		Name = self.name
		Name = Name or ""
	end

	local Unit_2 = self.Unit

	Unit_2 = Unit_2 or self.unit

	local Shape = self.Shape

	Shape = Shape or self.shape

	local Positioning = self.Positioning

	Positioning = Positioning or self.positioning

	local Trigger_Range = self.Trigger_Range

	Trigger_Range = Trigger_Range or self.trigger_range

	local num = -1

	if not Unit_2 then
		if Name == "" then
			Name = Unit.get_data(Unit_2, "Wwise", "event_name") or ""

			if Name == "" then
				return {
					ss_source_id = num,
					SS_Source_Id = num
				}
			end
		end

		Shape = Shape or Unit.get_data(Unit_2, "Wwise", "shape") or "point"

		local lower = string.lower(Shape)
		local flag

		flag = ({
			point = Wwise.SHAPE_POINT,
			sphere = Wwise.SHAPE_SPHERE,
			box = Wwise.SHAPE_BOX
		})[lower] or Wwise.SHAPE_POINT
		Positioning = Positioning or string.lower(Unit.get_data(Unit_2, "Wwise", "positioning")) or "closest"

		local num_2 = 10
		local var_24_9 = num_2

		if flag == Wwise.SHAPE_SPHERE then
			var_24_9 = self.Sphere_Radius or self.sphere_radius

			if not var_24_9 then
				var_24_9 = Unit.get_data(Unit_2, "Wwise", "sphere_radius") or num_2
			end
		elseif flag == Wwise.SHAPE_BOX then
			var_24_9 = self.Box_Scale or self.box_scale

			if not var_24_9 then
				var_24_9 = Vector3(0, 0, 0)

				local get_data = Unit.get_data(Unit_2, "Wwise", "box_extents", 0)

				get_data = get_data or num_2
				var_24_9.x = get_data

				local get_data_2 = Unit.get_data(Unit_2, "Wwise", "box_extents", 1)

				get_data_2 = get_data_2 or num_2
				var_24_9.y = get_data_2

				local get_data_3 = Unit.get_data(Unit_2, "Wwise", "box_extents", 2)

				get_data_3 = get_data_3 or num_2
				var_24_9.z = get_data_3
			end
		end

		local flag_2

		flag_2 = ({
			closest = Wwise.POSITIONING_CLOSEST_TO_LISTENER,
			["random in shape"] = Wwise.POSITIONING_RANDOM_IN_SHAPE,
			["random around listener"] = Wwise.POSITIONING_RANDOM_AROUND_LISTENER
		})[Positioning] or Wwise.POSITIONING_CLOSEST_TO_LISTENER

		local index_offset = Script.index_offset()

		if self.Unit_Node or not self.unit_node then
			local node = Unit.node
			local var_24_16 = Unit_2
			local Unit_Node = self.Unit_Node

			Unit_Node = Unit_Node or self.unit_node
			index_offset = node(var_24_16, Unit_Node)
		end

		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		num = WwiseWorld.add_soundscape_unit_source(wwise_world, Name, Unit_2, index_offset, flag, var_24_9, flag_2, 0, 5, Trigger_Range)
	end

	return {
		ss_source_id = num,
		SS_Source_Id = num
	}
end

WwiseFlowCallbacks_2.wwise_remove_soundscape_source = function (self)
	-- function 25
	local SS_Source_Id = self.SS_Source_Id

	SS_Source_Id = SS_Source_Id or self.ss_source_id

	if not SS_Source_Id then
		print("Error: nil soundscape source id, removing soundscape source failed.")

		return
	end

	if SS_Source_Id == -1 then
		return
	end

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.remove_soundscape_source(wwise_world, SS_Source_Id)
end

WwiseFlowCallbacks_2.wwise_set_obstruction_and_occlusion_for_soundscape_source = function (self)
	-- function 26
	local SS_Source_Id = self.SS_Source_Id

	SS_Source_Id = SS_Source_Id or self.ss_source_id

	local Obstruction = self.Obstruction

	if not Obstruction then
		Obstruction = self.obstruction
		Obstruction = Obstruction or 0
	end

	local Occlusion = self.Occlusion

	if not Occlusion then
		Occlusion = self.occlusion
		Occlusion = Occlusion or 0
	end

	if not SS_Source_Id then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_obstruction_and_occlusion_for_soundscape_source(wwise_world, SS_Source_Id, Obstruction, Occlusion)
	end
end

WwiseFlowCallbacks_2.wwise_add_soundscape_render_unit = function (self)
	-- function 27
	local Unit = self.Unit

	Unit = Unit or self.unit

	if not Unit then
		core_wwise_lua_wwise_visualization.add_soundscape_unit(Unit)
	end
end

WwiseFlowCallbacks_2.wwise_set_environment = function (self)
	-- function 28
	local Aux_Bus = self.Aux_Bus

	Aux_Bus = Aux_Bus or self.aux_bus

	local Value = self.Value

	Value = Value or self.value

	if not Aux_Bus and not Value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_environment(wwise_world, Aux_Bus, Value)
	end
end

WwiseFlowCallbacks_2.wwise_set_dry_environment = function (self)
	-- function 29
	local Value = self.Value

	Value = Value or self.value

	if not Value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_dry_environment(wwise_world, Value)
	end
end

WwiseFlowCallbacks_2.wwise_reset_environment = function (arg_30_0)
	-- function 30
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.reset_environment(wwise_world)
end

WwiseFlowCallbacks_2.wwise_set_source_environment = function (self)
	-- function 31
	local Source_Id = self.Source_Id

	Source_Id = Source_Id or self.source_id

	local Aux_Bus = self.Aux_Bus

	Aux_Bus = Aux_Bus or self.aux_bus

	local Value = self.Value

	Value = Value or self.value

	if not Source_Id and not Aux_Bus and not Value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_environment_for_source(wwise_world, Source_Id, Aux_Bus, Value)
	end
end

WwiseFlowCallbacks_2.wwise_set_source_dry_environment = function (self)
	-- function 32
	local Source_Id = self.Source_Id

	Source_Id = Source_Id or self.source_id

	local Value = self.Value

	Value = Value or self.value

	if not Source_Id and not Value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_dry_environment_for_source(wwise_world, Source_Id, Value)
	end
end

WwiseFlowCallbacks_2.wwise_reset_source_environment = function (self)
	-- function 33
	local Source_Id = self.Source_Id

	Source_Id = Source_Id or self.source_id

	if not Source_Id then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.reset_environment_for_source(wwise_world, Source_Id)
	end
end

WwiseFlowCallbacks_2.wwise_set_obstruction_and_occlusion = function (self)
	-- function 34
	local Source_Id = self.Source_Id

	Source_Id = Source_Id or self.source_id

	local var_34_1 = var_0_12
	local Listener = self.Listener

	Listener = Listener or self.listener

	local var_34_3 = var_34_1[Listener]
	local Obstruction = self.Obstruction

	if not Obstruction then
		Obstruction = self.obstruction
		Obstruction = Obstruction or 0
	end

	local Occlusion = self.Occlusion

	if not Occlusion then
		Occlusion = self.occlusion
		Occlusion = Occlusion or 0
	end

	if not Source_Id and not var_34_3 then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_obstruction_and_occlusion(wwise_world, var_34_3, Source_Id, Obstruction, Occlusion)
	end
end

if not Wwise then
	for k, v in pairs(WwiseFlowCallbacks_2) do
		WwiseFlowCallbacks_2[k] = function (arg_35_0)
			-- function 35
			return
		end
	end
end

WwiseFlowCallbacks_2.dialogue_silence_unit = function (self)
	-- function 36
	local Unit_2 = self.Unit

	Unit_2 = Unit_2 or self.unit

	local set_silenced = self.set_silenced

	set_silenced = set_silenced or false

	if not Unit_2 then
		if not Unit.alive(Unit_2) then
			local has_extension = ScriptUnit.has_extension(Unit_2, "dialogue_system")

			if not has_extension then
				has_extension.input:set_silenced(set_silenced)
			else
				print("Warning: dialogue silence unit: can't find dialogue_system extension in ", Unit_2)
			end
		else
			print("Warning: dialogue silence unit: omit non alive unit ", Unit_2)
		end
	else
		print("Warning: dialogue silence unit: nil unit doing nothing.")
	end
end
