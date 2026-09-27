-- chunkname: @scripts/managers/camera/transitions/camera_transition_rotation_lerp.lua

require("scripts/managers/camera/transitions/camera_transition_base")

CameraTransitionRotationLerp = class(CameraTransitionRotationLerp, CameraTransitionBase)

CameraTransitionRotationLerp.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	CameraTransitionBase.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)

	self._freeze_node_1 = arg_1_5.freeze_start_node

	if not self._freeze_node_1 then
		local rotation = arg_1_1:rotation()

		self._node_1_rot_table = QuaternionBox(rotation)
	end
end

CameraTransitionRotationLerp.update = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	CameraTransitionBase.update(self, arg_2_1, arg_2_3)

	local unbox

	if not self._freeze_node_1 then
		unbox = self._node_1_rot_table:unbox()

		if not unbox then
			-- Nothing
		end
	end

	unbox = arg_2_2

	::label_2_0::

	local rotation = self._node_2:rotation()
	local _duration = self._duration
	local num = self._time / self._duration
	local flag = num >= 1

	return Quaternion.lerp(unbox, rotation, math.min(num, 1)), flag
end
