-- chunkname: @foundation/scripts/managers/replay/replay_manager.lua

ReplayManager = class(ReplayManager)

function ReplayManager.init(arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._playing = true
	arg_1_0._level_name = nil
	arg_1_0._frame = 0
	arg_1_0._frame_needs_drawing = false
	arg_1_0._stories = {}
	arg_1_0._current_story_index = nil
	arg_1_0._current_story_id = nil
	arg_1_0._frame_time = 0.016666666666666666
	arg_1_0._have_had_proper_level = false
end

function ReplayManager.update(arg_2_0, arg_2_1)
	local var_2_0 = 0

	if arg_2_0._playing then
		local var_2_1 = ExtendedReplay.num_frames()

		arg_2_0._frame = arg_2_0._frame + 1

		if arg_2_0._frame == var_2_1 then
			arg_2_0._frame = 0
		end

		arg_2_0:move_to_current_frame()

		var_2_0 = ExtendedReplay.delta_time()
	end

	if arg_2_0._frame_needs_drawing then
		arg_2_0:move_to_current_frame()
	end

	return var_2_0
end

function ReplayManager.move_to_current_frame(arg_3_0)
	ExtendedReplay.set_frame(arg_3_0._frame)

	arg_3_0._frame_needs_drawing = false

	arg_3_0:report_frame()

	local var_3_0

	for iter_3_0, iter_3_1 in ipairs(arg_3_0._stories) do
		if arg_3_0._frame >= iter_3_1.framestart and arg_3_0._frame < iter_3_1.frameend then
			var_3_0 = iter_3_0

			break
		end
	end

	local var_3_1 = arg_3_0._world:storyteller()

	if var_3_0 ~= arg_3_0._current_story_index then
		if arg_3_0._current_story_id ~= nil and var_3_1:is_playing(arg_3_0._current_story_id) then
			var_3_1:stop(arg_3_0._current_story_id)
		end

		arg_3_0._current_story_index = var_3_0
		arg_3_0._current_story_id = nil
	end

	if arg_3_0._current_story_index ~= nil then
		local var_3_2 = arg_3_0._world:level_by_name(arg_3_0._level_name)

		if var_3_2 == nil then
			if not arg_3_0._have_had_proper_level then
				local var_3_3 = {
					action = "close",
					message = "error",
					type = "replay",
					reason = "Level " .. arg_3_0._level_name .. " can't be found in the world. Have you loaded the correct level for this replay session?"
				}

				Application.console_send(var_3_3)

				arg_3_0._have_had_proper_level = true
			end
		else
			arg_3_0._have_had_proper_level = true
		end

		if var_3_2 ~= nil then
			if arg_3_0._current_story_id == nil or not var_3_1:is_playing(arg_3_0._current_story_id) then
				arg_3_0._current_story_id = var_3_1:play_level_story(var_3_2, arg_3_0._stories[arg_3_0._current_story_index].name)

				var_3_1:set_speed(arg_3_0._current_story_id, 0)
			end

			var_3_1:set_time(arg_3_0._current_story_id, (arg_3_0._frame - arg_3_0._stories[arg_3_0._current_story_index].framestart) * arg_3_0._frame_time)
		end
	end
end

function ReplayManager.report_frame(arg_4_0)
	local var_4_0 = {
		message = "frame",
		type = "replay",
		frame = arg_4_0._frame
	}

	Application.console_send(var_4_0)
end

function ReplayManager.overriding_camera(arg_5_0)
	if arg_5_0._current_story_id ~= nil then
		return arg_5_0._world:storyteller():first_camera(arg_5_0._current_story_id)
	end
end

function ReplayManager.reload(arg_6_0)
	arg_6_0._current_story_id = nil
	arg_6_0._frame_needs_drawing = true
end

function ReplayManager.play(arg_7_0, arg_7_1)
	arg_7_0._playing = arg_7_1
end

function ReplayManager.set_frame(arg_8_0, arg_8_1)
	arg_8_0._frame = arg_8_1
	arg_8_0._frame_needs_drawing = true
end

function ReplayManager.set_level(arg_9_0, arg_9_1)
	arg_9_0._level_name = arg_9_1
end

function ReplayManager.set_stories(arg_10_0, arg_10_1)
	arg_10_0._stories = arg_10_1
end
