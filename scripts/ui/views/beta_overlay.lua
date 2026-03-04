-- chunkname: @scripts/ui/views/beta_overlay.lua

script_data.text_watermark = script_data.text_watermark or script_data.settings.text_watermark
script_data.qr_watermark = script_data.qr_watermark or script_data.settings.qr_watermark

local var_0_0 = Vector3
local var_0_1 = Gui

BetaOverlay = class(BetaOverlay)

local var_0_2 = true

BetaOverlay.init = function (arg_1_0, arg_1_1)
	var_0_2 = true

	local var_1_0 = Managers.world:world("top_ingame_view")

	arg_1_0._label, arg_1_0._world = script_data.text_watermark, arg_1_1
	arg_1_0._watermark = script_data.watermark
	arg_1_0._watermark_condition = script_data.watermark_condition

	if script_data.qr_watermark then
		arg_1_0._data = arg_1_0:_generate_qr()
	end

	arg_1_0._mechanism_key = Managers.mechanism:current_mechanism_name()

	local var_1_1 = script_data.text_watermark_disclaimer

	arg_1_0._disclaimer = type(var_1_1) ~= "string" and "May not be representative of final product." or var_1_1

	print("beta overlay got watermark:", arg_1_0._watermark, arg_1_0._label, arg_1_0._disclaimer)
end

BetaOverlay._destroy_gui = function (arg_2_0)
	if not arg_2_0._gui then
		return
	end

	World.destroy_gui(arg_2_0._world, arg_2_0._gui)

	arg_2_0._gui = nil
end

BetaOverlay.destroy = function (arg_3_0)
	return arg_3_0:_destroy_gui()
end

BetaOverlay._render_qr = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	local var_4_0 = arg_4_0._gui
	local var_4_1 = arg_4_0._data
	local var_4_2 = #var_4_1
	local var_4_3 = #var_4_1[1]

	arg_4_6 = arg_4_6 or Color(255, 255, 255)
	arg_4_7 = arg_4_7 or Color(0, 0, 0)

	local var_4_4 = arg_4_2 * (arg_4_5 or 10)
	local var_4_5 = Vector2(var_4_4, var_4_4)
	local var_4_6 = var_0_0(0, 0, 1000)
	local var_4_7 = (arg_4_1[1] - (var_4_3 + 2) * var_4_4) * arg_4_3
	local var_4_8 = (arg_4_1[2] - (var_4_2 + 2) * var_4_4) * arg_4_4

	for iter_4_0 = 1, var_4_2 do
		local var_4_9 = var_4_1[iter_4_0]

		var_0_0.set_y(var_4_6, var_4_8 + iter_4_0 * var_4_4)

		for iter_4_1 = 1, var_4_2 do
			local var_4_10 = arg_4_7

			if var_4_9[iter_4_1] < 0 then
				var_4_10 = arg_4_6
			end

			var_0_0.set_x(var_4_6, var_4_7 + iter_4_1 * var_4_4)
			var_0_1.rect(var_4_0, var_4_6, var_4_5, var_4_10)
		end
	end
end

BetaOverlay._render_watermark = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._gui
	local var_5_1 = arg_5_0._label
	local var_5_2 = "materials/fonts/gw_head"
	local var_5_3 = 65 * arg_5_2
	local var_5_4, var_5_5, var_5_6 = var_0_1.text_extents(var_5_0, var_5_1, var_5_2, var_5_3)
	local var_5_7 = var_0_0(arg_5_1[1] - var_5_6.x - arg_5_2 * 35, arg_5_1[2] - arg_5_2 * 116, 1000)

	if arg_5_0._label_id then
		var_0_1.update_text(var_5_0, arg_5_0._label_id, var_5_1)
	else
		arg_5_0._label_id = var_0_1.text(var_5_0, var_5_1, var_5_2, var_5_3, nil, var_5_7, Color(100, 255, 255, 255))
	end
end

BetaOverlay._render_disclaimer = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._gui
	local var_6_1 = arg_6_0._disclaimer
	local var_6_2 = "materials/fonts/gw_head"
	local var_6_3 = 35 * arg_6_2
	local var_6_4, var_6_5, var_6_6 = var_0_1.text_extents(var_6_0, var_6_1, var_6_2, var_6_3)
	local var_6_7 = var_0_0(arg_6_1[1] - var_6_6.x - arg_6_2 * 35, arg_6_1[2] - arg_6_2 * 150, 1000)

	if arg_6_0._disclaimer_id then
		var_0_1.update_text(var_6_0, arg_6_0._disclaimer_id, var_6_1)
	else
		arg_6_0._disclaimer_id = var_0_1.text(var_6_0, var_6_1, var_6_2, var_6_3, nil, var_6_7, Color(100, 255, 255, 255))
	end
end

BetaOverlay._generate_qr = function (arg_7_0)
	local var_7_0 = string.format("%16s:%8s:%12s:%08x", HAS_STEAM and Steam.user_id() or "", script_data.settings.content_revision or "", script_data.build_identifier or "", os.time()):gsub(" ", "0")
	local var_7_1, var_7_2 = dofile("scripts/ui/qr/qrencode").qrcode(var_7_0)

	if var_7_1 then
		return var_7_2
	end

	error(var_7_2)
end

local var_0_3 = {
	default = function (arg_8_0)
		arg_8_0:_create_gui()
	end,
	mechanism = function (arg_9_0)
		if arg_9_0._mechanism_key == arg_9_0._watermark_condition then
			arg_9_0:_create_gui()
		end
	end
}

BetaOverlay._create_gui = function (arg_10_0)
	arg_10_0._gui = World.create_screen_gui(arg_10_0._world)

	local var_10_0 = arg_10_0._screen_width
	local var_10_1 = arg_10_0._screen_height
	local var_10_2 = math.min(var_10_0 / 1920, var_10_1 / 1080, 1)
	local var_10_3 = Vector2(var_10_0, var_10_1)

	if arg_10_0._label then
		arg_10_0:_render_watermark(var_10_3, var_10_2)
	end

	if arg_10_0._disclaimer then
		arg_10_0:_render_disclaimer(var_10_3, var_10_2)
	end

	if script_data.qr_watermark then
		local var_10_4 = 5

		arg_10_0:_render_qr(var_10_3, var_10_2, 0, 0, 10, Color(var_10_4, 255, 255, 0), Color(var_10_4, 0, 0, 255))
		arg_10_0:_render_qr(var_10_3, var_10_2, 0, 1, 10, Color(var_10_4, 255, 0, 255), Color(var_10_4, 0, 255, 0))
		arg_10_0:_render_qr(var_10_3, var_10_2, 1, 1, 10, Color(var_10_4, 0, 255, 255), Color(var_10_4, 255, 0, 0))
		arg_10_0:_render_qr(var_10_3, var_10_2, 1, 0, 10, Color(var_10_4, 255, 0, 0), Color(var_10_4, 0, 255, 0))
		arg_10_0:_render_qr(var_10_3, var_10_2, 0.5, 0.5, 10, Color(var_10_4, 0, 0, 0), Color(var_10_4, 255, 255, 255))
	end
end

BetaOverlay._reload = function (arg_11_0)
	arg_11_0._mechanism_key = Managers.mechanism:current_mechanism_name()

	arg_11_0:_destroy_gui()

	arg_11_0._label_id = nil
	arg_11_0._disclaimer_id = nil

	local var_11_0 = arg_11_0._watermark or script_data.watermark

	if var_11_0 then
		local var_11_1 = var_0_3[var_11_0]

		if var_11_1 then
			var_11_1(arg_11_0)
		end
	end
end

BetaOverlay.refresh = function (arg_12_0)
	arg_12_0:_reload()
end

BetaOverlay.update = function (arg_13_0)
	local var_13_0 = arg_13_0._mechanism_key ~= Managers.mechanism:current_mechanism_name()
	local var_13_1, var_13_2 = var_0_1.resolution()

	if var_13_1 ~= arg_13_0._screen_width or var_13_2 ~= arg_13_0._screen_height or var_0_2 or var_13_0 then
		arg_13_0._screen_width = var_13_1
		arg_13_0._screen_height = var_13_2
		var_0_2 = false

		arg_13_0:_reload()
	end
end
