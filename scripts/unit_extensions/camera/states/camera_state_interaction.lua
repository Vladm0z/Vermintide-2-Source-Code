-- chunkname: @scripts/unit_extensions/camera/states/camera_state_interaction.lua

CameraStateInteraction = class(CameraStateInteraction, CameraState)

function CameraStateInteraction.init(arg_1_0, arg_1_1)
	CameraState.init(arg_1_0, arg_1_1, "camera_state_interaction")
end

function CameraStateInteraction.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_7.camera_interaction_name
	local var_2_1 = Managers.world

	if var_2_1:has_world("level_world") then
		local var_2_2
		local var_2_3 = var_2_1:world("level_world")
		local var_2_4 = Managers.mechanism:game_mechanism():get_hub_level_key()
		local var_2_5 = LevelSettings[var_2_4].level_name
		local var_2_6 = ScriptWorld.level(var_2_3, var_2_5)

		if var_2_6 then
			local var_2_7 = Level.units(var_2_6)

			for iter_2_0, iter_2_1 in ipairs(var_2_7) do
				if Unit.has_data(iter_2_1, "camera_interaction_name") and Unit.get_data(iter_2_1, "camera_interaction_name") == var_2_0 then
					var_2_2 = iter_2_1

					break
				end
			end
		end

		arg_2_0.camera_target_unit = var_2_2
		arg_2_0.total_lerp_time = UISettings.map.camera_time_enter
		arg_2_0.lerp_time = 0
		arg_2_0.progress = 0
		arg_2_0.calculate_lerp = true
		arg_2_0.camera_start_pose = Matrix4x4Box(Unit.world_pose(arg_2_1, 0))
	end
end

function CameraStateInteraction.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0.camera_target_unit = nil
end

function CameraStateInteraction.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.unit
	local var_4_2 = arg_4_0.camera_extension
	local var_4_3 = arg_4_0.camera_target_unit

	if not Unit.alive(var_4_3) then
		var_4_0:change_state("idle")

		return
	end

	local var_4_4 = var_4_2.external_state_change
	local var_4_5 = var_4_2.external_state_change_params

	if var_4_4 and var_4_4 ~= arg_4_0.name then
		var_4_0:change_state(var_4_4, var_4_5)
		var_4_2:set_external_state_change(nil)

		return
	end

	if arg_4_0.calculate_lerp and var_4_3 then
		local var_4_6 = arg_4_0.total_lerp_time
		local var_4_7 = arg_4_0.lerp_time
		local var_4_8 = arg_4_0.progress
		local var_4_9 = math.min(var_4_7 + arg_4_3, var_4_6)
		local var_4_10 = var_4_9 / var_4_6
		local var_4_11 = math.smoothstep(var_4_10, 0, 1)
		local var_4_12 = Unit.world_pose(var_4_3, 0)
		local var_4_13 = arg_4_0.camera_start_pose:unbox()
		local var_4_14 = Matrix4x4.lerp(var_4_13, var_4_12, var_4_11)

		assert(Matrix4x4.is_valid(var_4_14), "Camera lerp pose invalid.")
		Unit.set_local_pose(var_4_1, 0, var_4_14)

		if var_4_8 == 1 then
			arg_4_0.calculate_lerp = nil
			arg_4_0.camera_start_pose = nil
			arg_4_0.total_lerp_time = nil
			arg_4_0.lerp_time = nil
			arg_4_0.progress = nil
		else
			arg_4_0.progress = var_4_10
			arg_4_0.lerp_time = var_4_9
		end
	end
end
