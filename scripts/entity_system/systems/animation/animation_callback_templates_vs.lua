-- chunkname: @scripts/entity_system/systems/animation/animation_callback_templates_vs.lua

local var_0_0 = BLACKBOARDS

AnimationCallbackTemplates.server.anim_cb_direct_damage_vs = function (arg_1_0, arg_1_1)
	print("anim_cb_direct_damage_vs finished")
end

AnimationCallbackTemplates.server.anim_cb_jump_start_finished_vs = function (arg_2_0, arg_2_1)
	print("anim_cb_jump_start_finished_vs finished")
end

AnimationCallbackTemplates.server.anim_cb_spawn_projectile_vs = function (arg_3_0, arg_3_1)
	print("anim_cb_spawn_projectile finished")
end

AnimationCallbackTemplates.server.anim_cb_throw_vs = function (arg_4_0, arg_4_1)
	print("anim_cb_throw finished")
end

AnimationCallbackTemplates.server.anim_cb_damage_vs = function (arg_5_0, arg_5_1)
	print("anim_cb_damage_vs finished")
end

AnimationCallbackTemplates.server.anim_cb_attack_finished_vs = function (arg_6_0, arg_6_1)
	print("anim_cb_attack_finished_vs finished")
end

AnimationCallbackTemplates.server.anim_cb_move_vs = function (arg_7_0, arg_7_1)
	print("anim_cb_move_vs finished")
end

AnimationCallbackTemplates.server.anim_cb_transition_camera = function (arg_8_0, arg_8_1)
	local var_8_0 = var_0_0[arg_8_0]

	if var_8_0 then
		var_8_0.jump_camera_transition = true
	end
end

AnimationCallbackTemplates.server.anim_cb_jump_give_control = function (arg_9_0, arg_9_1)
	local var_9_0 = var_0_0[arg_9_0]

	if var_9_0 then
		var_9_0.jump_give_control = true
	end
end

AnimationCallbackTemplates.server.anim_cb_tunneling_begin = function (arg_10_0, arg_10_1)
	local var_10_0 = var_0_0[arg_10_0]

	if var_10_0 then
		var_10_0.tunneling_started = true
	end
end

AnimationCallbackTemplates.server.anim_cb_tunneling_finished = function (arg_11_0, arg_11_1)
	local var_11_0 = var_0_0[arg_11_0]

	if var_11_0 then
		var_11_0.tunneling_finished = true
	end
end

AnimationCallbackTemplates.client.anim_cb_jump_start_finished = function (arg_12_0, arg_12_1)
	local var_12_0 = var_0_0[arg_12_0]

	if var_12_0 then
		var_12_0.jump_start_finished = true
	end
end

AnimationCallbackTemplates.client.anim_cb_jump_climb_finished = function (arg_13_0, arg_13_1)
	local var_13_0 = var_0_0[arg_13_0]

	if var_13_0 then
		var_13_0.jump_climb_finished = true
	end
end

AnimationCallbackTemplates.client.anim_cb_transition_camera = function (arg_14_0, arg_14_1)
	local var_14_0 = var_0_0[arg_14_0]

	if var_14_0 then
		var_14_0.jump_camera_transition = true
	end
end

AnimationCallbackTemplates.client.anim_cb_jump_give_control = function (arg_15_0, arg_15_1)
	local var_15_0 = var_0_0[arg_15_0]

	if var_15_0 then
		var_15_0.jump_give_control = true
	end
end

AnimationCallbackTemplates.client.anim_cb_tunneling_begin = function (arg_16_0, arg_16_1)
	local var_16_0 = var_0_0[arg_16_0]

	if var_16_0 then
		var_16_0.tunneling_begin = true
	end
end

AnimationCallbackTemplates.client.anim_cb_tunneling_finished = function (arg_17_0, arg_17_1)
	local var_17_0 = var_0_0[arg_17_0]

	if var_17_0 then
		var_17_0.tunneling_finished = true
	end
end
