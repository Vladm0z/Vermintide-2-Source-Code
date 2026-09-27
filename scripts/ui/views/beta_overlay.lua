-- chunkname: @scripts/ui/views/beta_overlay.lua

local script_data = script_data
local text_watermark = script_data.text_watermark

text_watermark = text_watermark or script_data.settings.text_watermark
script_data.text_watermark = text_watermark

local script_data_2 = script_data
local qr_watermark = script_data.qr_watermark

qr_watermark = qr_watermark or script_data.settings.qr_watermark
script_data_2.qr_watermark = qr_watermark

local Vector3 = Vector3
local Gui = Gui

BetaOverlay = class(BetaOverlay)

local flag = true

BetaOverlay.init = function (self, arg_1_1)
	-- function 1
	flag = true

	local world = Managers.world:world("top_ingame_view")

	self._label, self._world = script_data.text_watermark, arg_1_1
	self._watermark = script_data.watermark
	self._watermark_condition = script_data.watermark_condition

	if not script_data.qr_watermark then
		self._data = self:_generate_qr()
	end

	self._mechanism_key = Managers.mechanism:current_mechanism_name()

	local text_watermark_disclaimer = script_data.text_watermark_disclaimer
	local flag_2

	flag_2 = type(text_watermark_disclaimer) == "string" or not "May not be representative of final product." or text_watermark_disclaimer
	self._disclaimer = flag_2

	print("beta overlay got watermark:", self._watermark, self._label, self._disclaimer)
end

BetaOverlay._destroy_gui = function (self)
	-- function 2
	if not self._gui then
		return
	end

	World.destroy_gui(self._world, self._gui)

	self._gui = nil
end

BetaOverlay.destroy = function (self)
	-- function 3
	return self:_destroy_gui()
end

BetaOverlay._render_qr = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	-- function 4
	local _gui = self._gui
	local _data = self._data
	local count = #_data
	local count_2 = #_data[1]

	arg_4_6 = arg_4_6 or Color(255, 255, 255)
	arg_4_7 = arg_4_7 or Color(0, 0, 0)

	local num = arg_4_2 * (arg_4_5 or 10)
	local var_4_5 = Vector2(num, num)
	local var_4_6 = Vector3(0, 0, 1000)
	local num_2 = (arg_4_1[1] - (count_2 + 2) * num) * arg_4_3
	local num_3 = (arg_4_1[2] - (count + 2) * num) * arg_4_4

	for i = 1, count do
		local var_4_9 = _data[i]

		Vector3.set_y(var_4_6, num_3 + i * num)

		for j = 1, count do
			local var_4_10 = arg_4_7

			if var_4_9[j] < 0 then
				var_4_10 = arg_4_6
			end

			Vector3.set_x(var_4_6, num_2 + j * num)
			Gui.rect(_gui, var_4_6, var_4_5, var_4_10)
		end
	end
end

BetaOverlay._render_watermark = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _gui = self._gui
	local _label = self._label
	local str = "materials/fonts/gw_head"
	local num = 65 * arg_5_2
	local text_extents, var_5_5, var_5_6 = Gui.text_extents(_gui, _label, str, num)
	local var_5_7 = Vector3(arg_5_1[1] - var_5_6.x - arg_5_2 * 35, arg_5_1[2] - arg_5_2 * 116, 1000)

	if not self._label_id then
		Gui.update_text(_gui, self._label_id, _label)
	else
		self._label_id = Gui.text(_gui, _label, str, num, nil, var_5_7, Color(100, 255, 255, 255))
	end
end

BetaOverlay._render_disclaimer = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _gui = self._gui
	local _disclaimer = self._disclaimer
	local str = "materials/fonts/gw_head"
	local num = 35 * arg_6_2
	local text_extents, var_6_5, var_6_6 = Gui.text_extents(_gui, _disclaimer, str, num)
	local var_6_7 = Vector3(arg_6_1[1] - var_6_6.x - arg_6_2 * 35, arg_6_1[2] - arg_6_2 * 150, 1000)

	if not self._disclaimer_id then
		Gui.update_text(_gui, self._disclaimer_id, _disclaimer)
	else
		self._disclaimer_id = Gui.text(_gui, _disclaimer, str, num, nil, var_6_7, Color(100, 255, 255, 255))
	end
end

BetaOverlay._generate_qr = function (arg_7_0)
	-- function 7
	local format = string.format
	local str = "%16s:%8s:%12s:%08x"
	local user_id

	if not HAS_STEAM then
		user_id = Steam.user_id()

		if not user_id then
			-- Nothing
		end
	end

	user_id = ""

	::label_7_0::

	local content_revision = script_data.settings.content_revision

	content_revision = content_revision or ""

	local build_identifier = script_data.build_identifier

	build_identifier = build_identifier or ""

	local gsub = format(str, user_id, content_revision, build_identifier, os.time()):gsub(" ", "0")
	local qrcode, var_7_7 = dofile("scripts/ui/qr/qrencode").qrcode(gsub)

	if not qrcode then
		return var_7_7
	end

	error(var_7_7)
end

local tbl = {
	default = function (self)
		-- function 8
		self:_create_gui()
	end,
	mechanism = function (self)
		-- function 9
		if self._mechanism_key == self._watermark_condition then
			self:_create_gui()
		end
	end
}

BetaOverlay._create_gui = function (self)
	-- function 10
	self._gui = World.create_screen_gui(self._world)

	local _screen_width = self._screen_width
	local _screen_height = self._screen_height
	local min = math.min(_screen_width / 1920, _screen_height / 1080, 1)
	local var_10_3 = Vector2(_screen_width, _screen_height)

	if not self._label then
		self:_render_watermark(var_10_3, min)
	end

	if not self._disclaimer then
		self:_render_disclaimer(var_10_3, min)
	end

	if not script_data.qr_watermark then
		local num = 5

		self:_render_qr(var_10_3, min, 0, 0, 10, Color(num, 255, 255, 0), Color(num, 0, 0, 255))
		self:_render_qr(var_10_3, min, 0, 1, 10, Color(num, 255, 0, 255), Color(num, 0, 255, 0))
		self:_render_qr(var_10_3, min, 1, 1, 10, Color(num, 0, 255, 255), Color(num, 255, 0, 0))
		self:_render_qr(var_10_3, min, 1, 0, 10, Color(num, 255, 0, 0), Color(num, 0, 255, 0))
		self:_render_qr(var_10_3, min, 0.5, 0.5, 10, Color(num, 0, 0, 0), Color(num, 255, 255, 255))
	end
end

BetaOverlay._reload = function (self)
	-- function 11
	self._mechanism_key = Managers.mechanism:current_mechanism_name()

	self:_destroy_gui()

	self._label_id = nil
	self._disclaimer_id = nil

	local _watermark = self._watermark

	_watermark = _watermark or script_data.watermark

	if not _watermark then
		local var_11_1 = tbl[_watermark]

		if not var_11_1 then
			var_11_1(self)
		end
	end
end

BetaOverlay.refresh = function (self)
	-- function 12
	self:_reload()
end

BetaOverlay.update = function (self)
	-- function 13
	local flag_2 = self._mechanism_key ~= Managers.mechanism:current_mechanism_name()
	local resolution, var_13_2 = Gui.resolution()

	if resolution ~= self._screen_width or var_13_2 ~= self._screen_height or flag or not flag_2 then
		self._screen_width = resolution
		self._screen_height = var_13_2
		flag = false

		self:_reload()
	end
end
