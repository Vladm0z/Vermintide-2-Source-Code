-- chunkname: @foundation/scripts/managers/replay/replay_manager.lua

ReplayManager = class(ReplayManager)

ReplayManager.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._playing = true
	self._level_name = nil
	self._frame = 0
	self._frame_needs_drawing = false
	self._stories = {}
	self._current_story_index = nil
	self._current_story_id = nil
	self._frame_time = 0.016666666666666666
	self._have_had_proper_level = false
end

ReplayManager.update = function (self, arg_2_1)
	-- function 2
	local num = 0

	if not self._playing then
		local num_frames = ExtendedReplay.num_frames()

		self._frame = self._frame + 1

		if self._frame == num_frames then
			self._frame = 0
		end

		self:move_to_current_frame()

		num = ExtendedReplay.delta_time()
	end

	if not self._frame_needs_drawing then
		self:move_to_current_frame()
	end

	return num
end

ReplayManager.move_to_current_frame = function (self)
	-- function 3
	ExtendedReplay.set_frame(self._frame)

	self._frame_needs_drawing = false

	self:report_frame()

	local var_3_0

	for i, v in ipairs(self._stories) do
		if not (not (self._frame >= v.framestart) or not (self._frame < v.frameend)) then
			var_3_0 = i

			break
		end
	end

	local storyteller = self._world:storyteller()

	if var_3_0 ~= self._current_story_index then
		if self._current_story_id == nil or not storyteller:is_playing(self._current_story_id) then
			storyteller:stop(self._current_story_id)
		end

		self._current_story_index = var_3_0
		self._current_story_id = nil
	end

	if self._current_story_index ~= nil then
		local level_by_name = self._world:level_by_name(self._level_name)

		if level_by_name == nil then
			if not self._have_had_proper_level then
				local tbl = {
					action = "close",
					message = "error",
					type = "replay",
					reason = "Level " .. self._level_name .. " can't be found in the world. Have you loaded the correct level for this replay session?"
				}

				Application.console_send(tbl)

				self._have_had_proper_level = true
			end
		else
			self._have_had_proper_level = true
		end

		if level_by_name ~= nil then
			if not (self._current_story_id == nil or storyteller:is_playing(self._current_story_id)) then
				self._current_story_id = storyteller:play_level_story(level_by_name, self._stories[self._current_story_index].name)

				storyteller:set_speed(self._current_story_id, 0)
			end

			storyteller:set_time(self._current_story_id, (self._frame - self._stories[self._current_story_index].framestart) * self._frame_time)
		end
	end
end

ReplayManager.report_frame = function (self)
	-- function 4
	local tbl = {
		message = "frame",
		type = "replay",
		frame = self._frame
	}

	Application.console_send(tbl)
end

ReplayManager.overriding_camera = function (self)
	-- function 5
	if self._current_story_id ~= nil then
		return self._world:storyteller():first_camera(self._current_story_id)
	end
end

ReplayManager.reload = function (self)
	-- function 6
	self._current_story_id = nil
	self._frame_needs_drawing = true
end

ReplayManager.play = function (self, arg_7_1)
	-- function 7
	self._playing = arg_7_1
end

ReplayManager.set_frame = function (self, arg_8_1)
	-- function 8
	self._frame = arg_8_1
	self._frame_needs_drawing = true
end

ReplayManager.set_level = function (self, arg_9_1)
	-- function 9
	self._level_name = arg_9_1
end

ReplayManager.set_stories = function (self, arg_10_1)
	-- function 10
	self._stories = arg_10_1
end
