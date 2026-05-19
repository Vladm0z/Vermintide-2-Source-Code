-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_anim_utils.lua

AiAnimUtils = AiAnimUtils or {}

local var_0_0 = POSITION_LOOKUP

function AiAnimUtils.get_animation_rotation_scale(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = var_0_0[arg_1_0]
	local var_1_1 = Unit.local_rotation(arg_1_0, 0)
	local var_1_2 = Quaternion.forward(var_1_1, 0)
	local var_1_3 = Vector3.normalize(arg_1_1 - var_1_0)
	local var_1_4 = math.atan2(var_1_2.y, var_1_2.x)
	local var_1_5 = (math.atan2(var_1_3.y, var_1_3.x) - var_1_4) * arg_1_3[arg_1_2].dir

	if var_1_5 < 0 then
		var_1_5 = var_1_5 + 2 * math.pi
	end

	return var_1_5 / arg_1_3[arg_1_2].rad
end

local function var_0_1(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

function AiAnimUtils.get_start_move_animation(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0
	local var_3_1 = var_0_0[arg_3_0]
	local var_3_2 = Vector3.normalize(Vector3.flat(arg_3_1 - var_3_1))
	local var_3_3 = Unit.local_rotation(arg_3_0, 0)
	local var_3_4 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_3_3)))
	local var_3_5 = Vector3.dot(var_3_4, var_3_2)
	local var_3_6 = 0.707

	if var_3_6 <= var_3_5 then
		var_3_0 = arg_3_2.fwd
	elseif var_3_5 > -var_3_6 then
		var_3_0 = Vector3.cross(var_3_4, var_3_2).z > 0 and arg_3_2.left or arg_3_2.right
	else
		var_3_0 = arg_3_2.bwd
	end

	return (var_0_1(var_3_0))
end

function AiAnimUtils.set_idle_animation_merge(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1.breed.animation_merge_options
	local var_4_1 = var_4_0 and var_4_0.idle_animation_merge_options

	if var_4_1 then
		Unit.set_animation_merge_options(arg_4_0, unpack(var_4_1))
	end
end

function AiAnimUtils.set_move_animation_merge(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.breed.animation_merge_options
	local var_5_1 = var_5_0 and var_5_0.move_animation_merge_options

	if var_5_1 then
		Unit.set_animation_merge_options(arg_5_0, unpack(var_5_1))
	end
end

function AiAnimUtils.set_walk_animation_merge(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1.breed.animation_merge_options
	local var_6_1 = var_6_0 and var_6_0.walk_animation_merge_options

	if var_6_1 then
		Unit.set_animation_merge_options(arg_6_0, unpack(var_6_1))
	end
end

function AiAnimUtils.set_interest_point_animation_merge(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.breed.animation_merge_options
	local var_7_1 = var_7_0 and var_7_0.interest_point_animation_merge_options

	if var_7_1 then
		Unit.set_animation_merge_options(arg_7_0, unpack(var_7_1))
	end
end

function AiAnimUtils.reset_animation_merge(arg_8_0)
	Unit.set_animation_merge_options(arg_8_0)
end

function AiAnimUtils._animation_merge_debug(arg_9_0, arg_9_1)
	local var_9_0 = "animation_merge"

	Managers.state.debug_text:clear_unit_text(arg_9_0, var_9_0)

	if arg_9_1 then
		local var_9_1 = Unit.node(arg_9_0, "c_head")
		local var_9_2 = "player_1"
		local var_9_3 = Vector3(25, 255, 25)
		local var_9_4 = Vector3(0, 0, 1)
		local var_9_5 = 0.5

		Managers.state.debug_text:output_unit_text(arg_9_1, var_9_5, arg_9_0, var_9_1, var_9_4, nil, var_9_0, var_9_3, var_9_2)
	end
end

local var_0_2 = 10
local var_0_3 = 0.1

function AiAnimUtils.velocity_network_scale(arg_10_0, arg_10_1)
	if arg_10_1 then
		arg_10_0 = arg_10_0 * var_0_2

		return {
			math.round(arg_10_0.x),
			math.round(arg_10_0.y),
			math.round(arg_10_0.z)
		}
	else
		return (Vector3(arg_10_0[1] * var_0_3, arg_10_0[2] * var_0_3, arg_10_0[3] * var_0_3))
	end
end

local var_0_4 = 100
local var_0_5 = 0.01

function AiAnimUtils.position_network_scale(arg_11_0, arg_11_1)
	if arg_11_1 then
		arg_11_0 = arg_11_0 * var_0_4

		return {
			math.round(arg_11_0.x),
			math.round(arg_11_0.y),
			math.round(arg_11_0.z)
		}
	else
		return (Vector3(arg_11_0[1] * var_0_5, arg_11_0[2] * var_0_5, arg_11_0[3] * var_0_5))
	end
end

local var_0_6 = 100
local var_0_7 = 0.01

function AiAnimUtils.rotation_network_scale(arg_12_0, arg_12_1)
	if arg_12_1 then
		local var_12_0, var_12_1, var_12_2, var_12_3 = Quaternion.to_elements(arg_12_0)

		return {
			math.round(var_12_0 * var_0_6),
			math.round(var_12_1 * var_0_6),
			math.round(var_12_2 * var_0_6),
			math.round(var_12_3 * var_0_6)
		}
	else
		return (Quaternion.from_elements(arg_12_0[1] * var_0_7, arg_12_0[2] * var_0_7, arg_12_0[3] * var_0_7, arg_12_0[4] * var_0_7))
	end
end

function AiAnimUtils.cycle_anims(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = #arg_13_1
	local var_13_1 = arg_13_0[arg_13_2] % var_13_0 + 1
	local var_13_2 = arg_13_1[var_13_1]

	arg_13_0[arg_13_2] = var_13_1

	return var_13_2
end
