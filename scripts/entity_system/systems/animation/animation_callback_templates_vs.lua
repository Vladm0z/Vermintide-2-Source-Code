-- chunkname: @scripts/entity_system/systems/animation/animation_callback_templates_vs.lua

local var_0_0 = BLACKBOARDS

function AnimationCallbackTemplates.server.anim_cb_direct_damage_vs(arg_1_0, arg_1_1)
	print("anim_cb_direct_damage_vs finished")
end

function AnimationCallbackTemplates.server.anim_cb_jump_start_finished_vs(arg_2_0, arg_2_1)
	print("anim_cb_jump_start_finished_vs finished")
end

function AnimationCallbackTemplates.server.anim_cb_spawn_projectile_vs(arg_3_0, arg_3_1)
	print("anim_cb_spawn_projectile finished")
end

function AnimationCallbackTemplates.server.anim_cb_throw_vs(arg_4_0, arg_4_1)
	print("anim_cb_throw finished")
end

function AnimationCallbackTemplates.server.anim_cb_damage_vs(arg_5_0, arg_5_1)
	print("anim_cb_damage_vs finished")
end

function AnimationCallbackTemplates.server.anim_cb_attack_finished_vs(arg_6_0, arg_6_1)
	print("anim_cb_attack_finished_vs finished")
end

function AnimationCallbackTemplates.server.anim_cb_move_vs(arg_7_0, arg_7_1)
	print("anim_cb_move_vs finished")
end

function AnimationCallbackTemplates.server.anim_cb_transition_camera(arg_8_0, arg_8_1)
	local var_8_0 = var_0_0[arg_8_0]

	if var_8_0 then
		var_8_0.jump_camera_transition = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_jump_give_control(arg_9_0, arg_9_1)
	local var_9_0 = var_0_0[arg_9_0]

	if var_9_0 then
		var_9_0.jump_give_control = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_tunneling_begin(arg_10_0, arg_10_1)
	local var_10_0 = var_0_0[arg_10_0]

	if var_10_0 then
		var_10_0.tunneling_started = true
	end
end

function AnimationCallbackTemplates.server.anim_cb_tunneling_finished(arg_11_0, arg_11_1)
	local var_11_0 = var_0_0[arg_11_0]

	if var_11_0 then
		var_11_0.tunneling_finished = true
	end
end

function AnimationCallbackTemplates.client.anim_cb_jump_start_finished(arg_12_0, arg_12_1)
	local var_12_0 = var_0_0[arg_12_0]

	if var_12_0 then
		var_12_0.jump_start_finished = true
	end
end

function AnimationCallbackTemplates.client.anim_cb_jump_climb_finished(arg_13_0, arg_13_1)
	local var_13_0 = var_0_0[arg_13_0]

	if var_13_0 then
		var_13_0.jump_climb_finished = true
	end
end

function AnimationCallbackTemplates.client.anim_cb_transition_camera(arg_14_0, arg_14_1)
	local var_14_0 = var_0_0[arg_14_0]

	if var_14_0 then
		var_14_0.jump_camera_transition = true
	end
end

function AnimationCallbackTemplates.client.anim_cb_jump_give_control(arg_15_0, arg_15_1)
	local var_15_0 = var_0_0[arg_15_0]

	if var_15_0 then
		var_15_0.jump_give_control = true
	end
end

function AnimationCallbackTemplates.client.anim_cb_tunneling_begin(arg_16_0, arg_16_1)
	local var_16_0 = var_0_0[arg_16_0]

	if var_16_0 then
		var_16_0.tunneling_begin = true
	end
end

function AnimationCallbackTemplates.client.anim_cb_tunneling_finished(arg_17_0, arg_17_1)
	local var_17_0 = var_0_0[arg_17_0]

	if var_17_0 then
		var_17_0.tunneling_finished = true
	end
end
