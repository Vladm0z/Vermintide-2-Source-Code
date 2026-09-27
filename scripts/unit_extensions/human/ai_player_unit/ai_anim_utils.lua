-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_anim_utils.lua

local AiAnimUtils = AiAnimUtils

AiAnimUtils = AiAnimUtils or {}
AiAnimUtils = AiAnimUtils

local POSITION_LOOKUP = POSITION_LOOKUP

AiAnimUtils.get_animation_rotation_scale = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local var_1_0 = POSITION_LOOKUP[arg_1_0]
	local local_rotation = Unit.local_rotation(arg_1_0, 0)
	local forward = Quaternion.forward(local_rotation, 0)
	local normalize = Vector3.normalize(arg_1_1 - var_1_0)
	local atan2 = math.atan2(forward.y, forward.x)
	local num = (math.atan2(normalize.y, normalize.x) - atan2) * arg_1_3[arg_1_2].dir

	if num < 0 then
		num = num + 2 * math.pi
	end

	return num / arg_1_3[arg_1_2].rad
end

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

AiAnimUtils.get_start_move_animation = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0
	local var_3_1 = POSITION_LOOKUP[arg_3_0]
	local normalize = Vector3.normalize(Vector3.flat(arg_3_1 - var_3_1))
	local local_rotation = Unit.local_rotation(arg_3_0, 0)
	local normalize_2 = Vector3.normalize(Vector3.flat(Quaternion.forward(local_rotation)))
	local dot = Vector3.dot(normalize_2, normalize)
	local num = 0.707

	if num <= dot then
		var_3_0 = arg_3_2.fwd
	elseif dot > -num then
		var_3_0 = not (Vector3.cross(normalize_2, normalize).z > 0) and arg_3_2.left and arg_3_2.right
	else
		var_3_0 = arg_3_2.bwd
	end

	return (fn(var_3_0))
end

AiAnimUtils.set_idle_animation_merge = function (arg_4_0, arg_4_1)
	-- function 4
	local animation_merge_options = arg_4_1.breed.animation_merge_options
	local flag = not animation_merge_options and animation_merge_options.idle_animation_merge_options

	if not flag then
		Unit.set_animation_merge_options(arg_4_0, unpack(flag))
	end
end

AiAnimUtils.set_move_animation_merge = function (arg_5_0, arg_5_1)
	-- function 5
	local animation_merge_options = arg_5_1.breed.animation_merge_options
	local flag = not animation_merge_options and animation_merge_options.move_animation_merge_options

	if not flag then
		Unit.set_animation_merge_options(arg_5_0, unpack(flag))
	end
end

AiAnimUtils.set_walk_animation_merge = function (arg_6_0, arg_6_1)
	-- function 6
	local animation_merge_options = arg_6_1.breed.animation_merge_options
	local flag = not animation_merge_options and animation_merge_options.walk_animation_merge_options

	if not flag then
		Unit.set_animation_merge_options(arg_6_0, unpack(flag))
	end
end

AiAnimUtils.set_interest_point_animation_merge = function (arg_7_0, arg_7_1)
	-- function 7
	local animation_merge_options = arg_7_1.breed.animation_merge_options
	local flag = not animation_merge_options and animation_merge_options.interest_point_animation_merge_options

	if not flag then
		Unit.set_animation_merge_options(arg_7_0, unpack(flag))
	end
end

AiAnimUtils.reset_animation_merge = function (arg_8_0)
	-- function 8
	Unit.set_animation_merge_options(arg_8_0)
end

AiAnimUtils._animation_merge_debug = function (arg_9_0, arg_9_1)
	-- function 9
	local str = "animation_merge"

	Managers.state.debug_text:clear_unit_text(arg_9_0, str)

	if not arg_9_1 then
		local node = Unit.node(arg_9_0, "c_head")
		local str_2 = "player_1"
		local var_9_3 = Vector3(25, 255, 25)
		local var_9_4 = Vector3(0, 0, 1)
		local num = 0.5

		Managers.state.debug_text:output_unit_text(arg_9_1, num, arg_9_0, node, var_9_4, nil, str, var_9_3, str_2)
	end
end

local num = 10
local num_2 = 0.1

AiAnimUtils.velocity_network_scale = function (self, arg_10_1)
	-- function 10
	if not arg_10_1 then
		self = self * num

		return {
			math.round(self.x),
			math.round(self.y),
			math.round(self.z)
		}
	else
		return (Vector3(self[1] * num_2, self[2] * num_2, self[3] * num_2))
	end
end

local num_3 = 100
local num_4 = 0.01

AiAnimUtils.position_network_scale = function (self, arg_11_1)
	-- function 11
	if not arg_11_1 then
		self = self * num_3

		return {
			math.round(self.x),
			math.round(self.y),
			math.round(self.z)
		}
	else
		return (Vector3(self[1] * num_4, self[2] * num_4, self[3] * num_4))
	end
end

local num_5 = 100
local num_6 = 0.01

AiAnimUtils.rotation_network_scale = function (self, arg_12_1)
	-- function 12
	if not arg_12_1 then
		local to_elements, var_12_1, var_12_2, var_12_3 = Quaternion.to_elements(self)

		return {
			math.round(to_elements * num_5),
			math.round(var_12_1 * num_5),
			math.round(var_12_2 * num_5),
			math.round(var_12_3 * num_5)
		}
	else
		return (Quaternion.from_elements(self[1] * num_6, self[2] * num_6, self[3] * num_6, self[4] * num_6))
	end
end

AiAnimUtils.cycle_anims = function (self, arg_13_1, arg_13_2)
	-- function 13
	local count = #arg_13_1
	local num = self[arg_13_2] % count + 1
	local var_13_2 = arg_13_1[num]

	self[arg_13_2] = num

	return var_13_2
end
