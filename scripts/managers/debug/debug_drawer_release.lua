-- chunkname: @scripts/managers/debug/debug_drawer_release.lua

DebugDrawerRelease = class(DebugDrawerRelease)

DebugDrawerRelease.init = function (self, line_object, mode)
	-- function 1
	self._line_object = line_object
	self._mode = mode
end

DebugDrawerRelease.reset = function (self)
	-- function 2
	return
end

DebugDrawerRelease.line_object = function (self)
	-- function 3
	return self._line_object
end

DebugDrawerRelease.line = function (self, from, to, color)
	-- function 4
	return
end

DebugDrawerRelease.sphere = function (self, center, radius, color, segments, parts)
	-- function 5
	return
end

DebugDrawerRelease.capsule_overlap = function (self, position, size, rotation, color)
	-- function 6
	return
end

DebugDrawerRelease.box_sweep = function (self, pose, extents, movement_vector, color1, color2)
	-- function 7
	return
end

DebugDrawerRelease.capsule = function (self, from, to, radius, color)
	-- function 8
	return
end

DebugDrawerRelease.actor = function (self, actor, color, camera_pose)
	-- function 9
	return
end

DebugDrawerRelease.box = function (self, pose, extents, color)
	-- function 10
	return
end

DebugDrawerRelease.cone = function (self, from, to, radius, color, segements, bars)
	-- function 11
	return
end

DebugDrawerRelease.circle = function (self, center, radius, normal, color, segments)
	-- function 12
	return
end

DebugDrawerRelease.arrow_2d = function (self, from, to, color)
	-- function 13
	return
end

DebugDrawerRelease.cylinder = function (self, pos1, pos2, radius, color, segments)
	-- function 14
	return
end

DebugDrawerRelease.vector = function (self, position, vector, color)
	-- function 15
	return
end

DebugDrawerRelease.quaternion = function (self, position, quaternion, scale)
	-- function 16
	return
end

DebugDrawerRelease.matrix4x4 = function (self, matrix, scale)
	-- function 17
	return
end

DebugDrawerRelease.unit = function (self, unit, color)
	-- function 18
	return
end

DebugDrawerRelease.navigation_mesh_search = function (self, mesh)
	-- function 19
	return
end

DebugDrawerRelease.update = function (self, world)
	-- function 20
	return
end
