-- chunkname: @core/wwise/lua/wwise_flow_callbacks.lua

local var_0_0 = require("core/wwise/lua/wwise_visualization")
local var_0_1 = require("core/wwise/lua/wwise_bank_reference")

WwiseFlowCallbacks = WwiseFlowCallbacks or {}

local var_0_2 = WwiseFlowCallbacks
local var_0_3 = stingray.Application
local var_0_4 = stingray.Matrix4x4
local var_0_5 = stingray.Quaternion
local var_0_6 = stingray.Script
local var_0_7 = stingray.Unit
local var_0_8 = stingray.Vector3
local var_0_9 = stingray.Wwise
local var_0_10 = stingray.WwiseWorld
local var_0_11

if var_0_9 then
	var_0_11 = {
		Listener0 = var_0_9.LISTENER_0,
		Listener1 = var_0_9.LISTENER_1,
		Listener2 = var_0_9.LISTENER_2,
		Listener3 = var_0_9.LISTENER_3,
		Listener4 = var_0_9.LISTENER_4,
		Listener5 = var_0_9.LISTENER_5,
		Listener6 = var_0_9.LISTENER_6,
		Listener7 = var_0_9.LISTENER_7
	}
end

var_0_2.wwise_load_bank = function (arg_1_0)
	local var_1_0 = arg_1_0.Name or arg_1_0.name or ""

	if var_1_0 == "" then
		return
	end

	var_0_9.load_bank(var_1_0)

	local var_1_1 = arg_1_0.Reference_Count or false

	if var_1_1 and var_1_1 == true then
		var_0_1:add(var_1_0)
	end
end

var_0_2.wwise_unit_load_bank = function (arg_2_0)
	local var_2_0 = arg_2_0.Name or arg_2_0.name or ""
	local var_2_1 = arg_2_0.Unit or arg_2_0.unit

	if var_2_1 then
		if var_2_0 == "" then
			var_2_0 = var_0_7.get_data(var_2_1, "Wwise", "bank_name")
		end

		if var_2_0 ~= "" then
			var_0_9.load_bank(var_2_0)

			local var_2_2 = arg_2_0.Reference_Count or false

			if var_2_2 and var_2_2 == true then
				var_0_1:add(var_2_0)
			end
		end
	end
end

var_0_2.wwise_unload_bank = function (arg_3_0)
	local var_3_0 = arg_3_0.Name or arg_3_0.name or ""

	if var_3_0 == "" then
		local var_3_1 = var_0_3.flow_callback_context_unit()

		if var_3_1 then
			var_3_0 = var_0_7.get_data(var_3_1, "Wwise", "bank_name")
		end

		if var_3_0 == nil or var_3_0 == "" then
			return
		end
	end

	local var_3_2 = arg_3_0.Reference_Count or false

	if var_3_2 and var_3_2 == true then
		var_0_1:remove(var_3_0)

		if var_0_1:count(var_3_0) == 0 then
			var_0_9.unload_bank(var_3_0)
		end
	else
		var_0_9.unload_bank(var_3_0)
	end
end

var_0_2.wwise_set_language = function (arg_4_0)
	local var_4_0 = arg_4_0.Name or arg_4_0.name or ""

	var_0_9.set_language(var_4_0)
end

var_0_2.wwise_set_listener_pose = function (arg_5_0)
	local var_5_0 = arg_5_0.Position or arg_5_0.position

	if not var_5_0 then
		return
	end

	local var_5_1 = var_0_11[arg_5_0.Listener or arg_5_0.listener]
	local var_5_2 = arg_5_0.Rotation or arg_5_0.rotation or var_0_5.identity()
	local var_5_3 = var_0_4.from_quaternion_position(var_5_2, var_5_0)
	local var_5_4 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	var_0_10.set_listener(var_5_4, var_5_1, var_5_3)
end

var_0_2.wwise_move_listener_to_unit = function (arg_6_0)
	local var_6_0 = arg_6_0.Unit or arg_6_0.unit

	if not var_6_0 then
		return
	end

	local var_6_1 = var_0_11[arg_6_0.Listener or arg_6_0.listener]
	local var_6_2 = var_0_6.index_offset()

	if arg_6_0.Unit_Node or arg_6_0.unit_node then
		var_6_2 = var_0_7.node(var_6_0, arg_6_0.Unit_Node or arg_6_0.unit_node)
	end

	local var_6_3 = var_0_7.world_pose(var_6_0, var_6_2)
	local var_6_4 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	var_0_10.set_listener(var_6_4, var_6_1, var_6_3)
end

var_0_2.wwise_trigger_event = function (arg_7_0)
	local var_7_0 = arg_7_0.Name or arg_7_0.name or ""
	local var_7_1 = arg_7_0.Unit or arg_7_0.unit
	local var_7_2 = arg_7_0.use_occlusion or false
	local var_7_3
	local var_7_4
	local var_7_5 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	if var_7_1 then
		if var_7_0 == "" then
			var_7_0 = var_0_7.get_data(var_7_1, "Wwise", "event_name") or ""
		end

		local var_7_6 = var_0_6.index_offset()

		if arg_7_0.Unit_Node or arg_7_0.unit_node then
			var_7_6 = var_0_7.node(var_7_1, arg_7_0.Unit_Node or arg_7_0.unit_node)
		end

		var_7_3, var_7_4 = var_0_10.trigger_event(var_7_5, var_7_0, var_7_2, var_7_1, var_7_6)
	else
		local var_7_7 = arg_7_0.Position or arg_7_0.position

		if var_7_7 then
			var_7_3, var_7_4 = var_0_10.trigger_event(var_7_5, var_7_0, var_7_2, var_7_7)
		else
			local var_7_8 = arg_7_0.Existing_Source_Id or arg_7_0.existing_source_id

			if var_7_8 then
				var_7_3, var_7_4 = var_0_10.trigger_event(var_7_5, var_7_0, var_7_2, var_7_8)
			else
				var_7_3, var_7_4 = var_0_10.trigger_event(var_7_5, var_7_0)
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

local function var_0_12(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.Unit or arg_8_0.unit
	local var_8_1
	local var_8_2 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	if var_8_0 then
		local var_8_3 = var_0_6.index_offset()

		if arg_8_0.Unit_Node or arg_8_0.unit_node then
			var_8_3 = var_0_7.node(var_8_0, arg_8_0.Unit_Node or arg_8_0.unit_node)
		end

		var_8_1 = arg_8_1(var_8_2, var_8_0, var_8_3)
	else
		local var_8_4 = arg_8_0.Position or arg_8_0.position

		if var_8_4 then
			var_8_1 = arg_8_1(var_8_2, var_8_4)
		else
			local var_8_5 = arg_8_0.Source_Id or arg_8_0.source_id

			if var_8_5 then
				var_8_1 = arg_8_1(var_8_2, var_8_5)
			else
				var_8_1 = arg_8_1(var_8_2)
			end
		end
	end

	return var_8_1
end

var_0_2.wwise_make_auto_source = function (arg_9_0)
	local var_9_0 = var_0_12(arg_9_0, var_0_10.make_auto_source)

	return {
		source_id = var_9_0,
		Source_Id = var_9_0
	}
end

var_0_2.wwise_make_manual_source = function (arg_10_0)
	local var_10_0 = var_0_12(arg_10_0, var_0_10.make_manual_source)

	return {
		source_id = var_10_0,
		Source_Id = var_10_0
	}
end

var_0_2.wwise_destroy_manual_source = function (arg_11_0)
	local var_11_0 = arg_11_0.Source_Id or arg_11_0.source_id
	local var_11_1 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	var_0_10.destroy_manual_source(var_11_1, var_11_0)
end

var_0_2.wwise_stop_event = function (arg_12_0)
	local var_12_0 = arg_12_0.Playing_Id or arg_12_0.playing_id
	local var_12_1 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	var_0_10.stop_event(var_12_1, var_12_0)
end

var_0_2.wwise_pause_event = function (arg_13_0)
	local var_13_0 = arg_13_0.Playing_Id or arg_13_0.playing_id
	local var_13_1 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	var_0_10.pause_event(var_13_1, var_13_0)
end

var_0_2.wwise_resume_event = function (arg_14_0)
	local var_14_0 = arg_14_0.Playing_Id or arg_14_0.playing_id
	local var_14_1 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	var_0_10.resume_event(var_14_1, var_14_0)
end

var_0_2.wwise_set_source_position = function (arg_15_0)
	local var_15_0 = arg_15_0.Source_Id or arg_15_0.source_id
	local var_15_1 = arg_15_0.Position or arg_15_0.position
	local var_15_2 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	var_0_10.set_source_position(var_15_2, var_15_0, var_15_1)
end

var_0_2.wwise_set_source_parameter = function (arg_16_0)
	local var_16_0 = arg_16_0.Source_Id or arg_16_0.source_id
	local var_16_1 = arg_16_0.Parameter_Name or arg_16_0.parameter_name or ""
	local var_16_2 = arg_16_0.Value or arg_16_0.value
	local var_16_3 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	var_0_10.set_source_parameter(var_16_3, var_16_0, var_16_1, var_16_2)
end

var_0_2.wwise_set_global_parameter = function (arg_17_0)
	local var_17_0 = arg_17_0.Parameter_Name or arg_17_0.parameter_name or ""
	local var_17_1 = arg_17_0.Value or arg_17_0.value
	local var_17_2 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	var_0_10.set_global_parameter(var_17_2, var_17_0, var_17_1)
end

var_0_2.wwise_set_state = function (arg_18_0)
	local var_18_0 = arg_18_0.Group or arg_18_0.group
	local var_18_1 = arg_18_0.State or arg_18_0.state

	if not var_18_0 or not var_18_1 then
		return
	end

	var_0_9.set_state(var_18_0, var_18_1)
end

var_0_2.wwise_set_switch = function (arg_19_0)
	local var_19_0 = arg_19_0.Group or arg_19_0.group
	local var_19_1 = arg_19_0.State or arg_19_0.state

	if not var_19_0 or not var_19_1 then
		return
	end

	local var_19_2 = arg_19_0.Source_Id or arg_19_0.source_id
	local var_19_3 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	var_0_10.set_switch(var_19_3, var_19_0, var_19_1, var_19_2)
end

var_0_2.wwise_post_trigger = function (arg_20_0)
	local var_20_0 = arg_20_0.Source_Id or arg_20_0.source_id
	local var_20_1 = arg_20_0.Name or arg_20_0.name

	if var_20_0 and var_20_1 then
		local var_20_2 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

		var_0_10.post_trigger(var_20_2, var_20_0, var_20_1)
	end
end

var_0_2.wwise_has_source = function (arg_21_0)
	local var_21_0 = arg_21_0.Source_Id or arg_21_0.source_id
	local var_21_1 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	if var_0_10.has_source(var_21_1, var_21_0) then
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

var_0_2.wwise_is_playing = function (arg_22_0)
	local var_22_0 = arg_22_0.Playing_Id or arg_22_0.playing_id
	local var_22_1 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	if var_0_10.is_playing(var_22_1, var_22_0) then
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

var_0_2.wwise_get_playing_elapsed = function (arg_23_0)
	local var_23_0 = arg_23_0.Playing_Id or arg_23_0.playing_id
	local var_23_1 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())
	local var_23_2 = (var_0_10.get_playing_elapsed(var_23_1, var_23_0) or 0) / 1000

	return {
		seconds = var_23_2,
		Seconds = var_23_2
	}
end

var_0_2.wwise_add_soundscape_source = function (arg_24_0)
	local var_24_0 = arg_24_0.Name or arg_24_0.name or ""
	local var_24_1 = arg_24_0.Unit or arg_24_0.unit
	local var_24_2 = arg_24_0.Shape or arg_24_0.shape
	local var_24_3 = arg_24_0.Positioning or arg_24_0.positioning
	local var_24_4 = arg_24_0.Trigger_Range or arg_24_0.trigger_range
	local var_24_5 = -1

	if var_24_1 then
		if var_24_0 == "" then
			var_24_0 = var_0_7.get_data(var_24_1, "Wwise", "event_name") or ""

			if var_24_0 == "" then
				return {
					ss_source_id = var_24_5,
					SS_Source_Id = var_24_5
				}
			end
		end

		var_24_2 = var_24_2 or var_0_7.get_data(var_24_1, "Wwise", "shape") or "point"

		local var_24_6 = string.lower(var_24_2)
		local var_24_7

		var_24_7 = ({
			point = var_0_9.SHAPE_POINT,
			sphere = var_0_9.SHAPE_SPHERE,
			box = var_0_9.SHAPE_BOX
		})[var_24_6] or var_0_9.SHAPE_POINT
		var_24_3 = var_24_3 or string.lower(var_0_7.get_data(var_24_1, "Wwise", "positioning")) or "closest"

		local var_24_8 = 10
		local var_24_9 = var_24_8

		if var_24_7 == var_0_9.SHAPE_SPHERE then
			var_24_9 = arg_24_0.Sphere_Radius or arg_24_0.sphere_radius

			if not var_24_9 then
				var_24_9 = var_0_7.get_data(var_24_1, "Wwise", "sphere_radius") or var_24_8
			end
		elseif var_24_7 == var_0_9.SHAPE_BOX then
			var_24_9 = arg_24_0.Box_Scale or arg_24_0.box_scale

			if not var_24_9 then
				var_24_9 = var_0_8(0, 0, 0)
				var_24_9.x = var_0_7.get_data(var_24_1, "Wwise", "box_extents", 0) or var_24_8
				var_24_9.y = var_0_7.get_data(var_24_1, "Wwise", "box_extents", 1) or var_24_8
				var_24_9.z = var_0_7.get_data(var_24_1, "Wwise", "box_extents", 2) or var_24_8
			end
		end

		local var_24_10

		var_24_10 = ({
			closest = var_0_9.POSITIONING_CLOSEST_TO_LISTENER,
			["random in shape"] = var_0_9.POSITIONING_RANDOM_IN_SHAPE,
			["random around listener"] = var_0_9.POSITIONING_RANDOM_AROUND_LISTENER
		})[var_24_3] or var_0_9.POSITIONING_CLOSEST_TO_LISTENER

		local var_24_11 = var_0_6.index_offset()

		if arg_24_0.Unit_Node or arg_24_0.unit_node then
			var_24_11 = var_0_7.node(var_24_1, arg_24_0.Unit_Node or arg_24_0.unit_node)
		end

		local var_24_12 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

		var_24_5 = var_0_10.add_soundscape_unit_source(var_24_12, var_24_0, var_24_1, var_24_11, var_24_7, var_24_9, var_24_10, 0, 5, var_24_4)
	end

	return {
		ss_source_id = var_24_5,
		SS_Source_Id = var_24_5
	}
end

var_0_2.wwise_remove_soundscape_source = function (arg_25_0)
	local var_25_0 = arg_25_0.SS_Source_Id or arg_25_0.ss_source_id

	if not var_25_0 then
		print("Error: nil soundscape source id, removing soundscape source failed.")

		return
	end

	if var_25_0 == -1 then
		return
	end

	local var_25_1 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	var_0_10.remove_soundscape_source(var_25_1, var_25_0)
end

var_0_2.wwise_set_obstruction_and_occlusion_for_soundscape_source = function (arg_26_0)
	local var_26_0 = arg_26_0.SS_Source_Id or arg_26_0.ss_source_id
	local var_26_1 = arg_26_0.Obstruction or arg_26_0.obstruction or 0
	local var_26_2 = arg_26_0.Occlusion or arg_26_0.occlusion or 0

	if var_26_0 then
		local var_26_3 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

		var_0_10.set_obstruction_and_occlusion_for_soundscape_source(var_26_3, var_26_0, var_26_1, var_26_2)
	end
end

var_0_2.wwise_add_soundscape_render_unit = function (arg_27_0)
	local var_27_0 = arg_27_0.Unit or arg_27_0.unit

	if var_27_0 then
		var_0_0.add_soundscape_unit(var_27_0)
	end
end

var_0_2.wwise_set_environment = function (arg_28_0)
	local var_28_0 = arg_28_0.Aux_Bus or arg_28_0.aux_bus
	local var_28_1 = arg_28_0.Value or arg_28_0.value

	if var_28_0 and var_28_1 then
		local var_28_2 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

		var_0_10.set_environment(var_28_2, var_28_0, var_28_1)
	end
end

var_0_2.wwise_set_dry_environment = function (arg_29_0)
	local var_29_0 = arg_29_0.Value or arg_29_0.value

	if var_29_0 then
		local var_29_1 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

		var_0_10.set_dry_environment(var_29_1, var_29_0)
	end
end

var_0_2.wwise_reset_environment = function (arg_30_0)
	local var_30_0 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

	var_0_10.reset_environment(var_30_0)
end

var_0_2.wwise_set_source_environment = function (arg_31_0)
	local var_31_0 = arg_31_0.Source_Id or arg_31_0.source_id
	local var_31_1 = arg_31_0.Aux_Bus or arg_31_0.aux_bus
	local var_31_2 = arg_31_0.Value or arg_31_0.value

	if var_31_0 and var_31_1 and var_31_2 then
		local var_31_3 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

		var_0_10.set_environment_for_source(var_31_3, var_31_0, var_31_1, var_31_2)
	end
end

var_0_2.wwise_set_source_dry_environment = function (arg_32_0)
	local var_32_0 = arg_32_0.Source_Id or arg_32_0.source_id
	local var_32_1 = arg_32_0.Value or arg_32_0.value

	if var_32_0 and var_32_1 then
		local var_32_2 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

		var_0_10.set_dry_environment_for_source(var_32_2, var_32_0, var_32_1)
	end
end

var_0_2.wwise_reset_source_environment = function (arg_33_0)
	local var_33_0 = arg_33_0.Source_Id or arg_33_0.source_id

	if var_33_0 then
		local var_33_1 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

		var_0_10.reset_environment_for_source(var_33_1, var_33_0)
	end
end

var_0_2.wwise_set_obstruction_and_occlusion = function (arg_34_0)
	local var_34_0 = arg_34_0.Source_Id or arg_34_0.source_id
	local var_34_1 = var_0_11[arg_34_0.Listener or arg_34_0.listener]
	local var_34_2 = arg_34_0.Obstruction or arg_34_0.obstruction or 0
	local var_34_3 = arg_34_0.Occlusion or arg_34_0.occlusion or 0

	if var_34_0 and var_34_1 then
		local var_34_4 = var_0_9.wwise_world(var_0_3.flow_callback_context_world())

		var_0_10.set_obstruction_and_occlusion(var_34_4, var_34_1, var_34_0, var_34_2, var_34_3)
	end
end

if not var_0_9 then
	for iter_0_0, iter_0_1 in pairs(var_0_2) do
		var_0_2[iter_0_0] = function (arg_35_0)
			return
		end
	end
end

var_0_2.dialogue_silence_unit = function (arg_36_0)
	local var_36_0 = arg_36_0.Unit or arg_36_0.unit
	local var_36_1 = arg_36_0.set_silenced or false

	if var_36_0 then
		if var_0_7.alive(var_36_0) then
			local var_36_2 = ScriptUnit.has_extension(var_36_0, "dialogue_system")

			if var_36_2 then
				var_36_2.input:set_silenced(var_36_1)
			else
				print("Warning: dialogue silence unit: can't find dialogue_system extension in ", var_36_0)
			end
		else
			print("Warning: dialogue silence unit: omit non alive unit ", var_36_0)
		end
	else
		print("Warning: dialogue silence unit: nil unit doing nothing.")
	end
end
