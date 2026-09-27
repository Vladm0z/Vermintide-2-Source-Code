-- chunkname: @scripts/ui/hud_ui/damage_numbers_ui.lua

local num = 1920
local num_2 = 1080
local tbl = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
		}
	},
	text_root = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			3
		},
		size = {
			0,
			0
		}
	},
	damage_text = {
		vertical_alignment = "center",
		parent = "text_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			300,
			150
		}
	}
}
local min_streak_font_size

if not GameModeSettings.versus then
	min_streak_font_size = GameModeSettings.versus.min_streak_font_size

	if not min_streak_font_size then
		-- Nothing
	end
end

min_streak_font_size = 36

do
	local max_streak_font_size
end

::label_0_0::

if not GameModeSettings.versus then
	max_streak_font_size = GameModeSettings.versus.max_streak_font_size

	if not max_streak_font_size then
		-- Nothing
	end
end

max_streak_font_size = 64

::label_0_1::

local tbl_2 = {
	word_wrap = false,
	font_size = 24,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		1
	}
}
local tbl_3 = {
	damage_text = UIWidgets.create_simple_text("0", "damage_text", nil, nil, tbl_2)
}

DamageNumbersUI = class(DamageNumbersUI)

DamageNumbersUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.camera = Managers.camera
	self.input_manager = arg_1_2.input_manager
	self._time = 0
	self._unit_text_size = 0.2
	self._unit_text_time = math.huge
	self._unit_texts = {}
	self._unit_texts_summed = {}

	local world = Managers.world
	local str = "player_1"
	local str_2 = "level_world"
	local world_2 = world:world(str_2)
	local viewport = ScriptWorld.viewport(world_2, str)

	self.camera = ScriptViewport.camera(viewport)

	self:create_ui_elements()
	Managers.state.event:register(self, "add_damage_number", "event_add_damage_number")
	Managers.state.event:register(self, "alter_damage_number", "event_alter_damage_number")

	local settings = Managers.state.game_mode:settings()
end

DamageNumbersUI.update = function (self, arg_2_1)
	-- function 2
	self._time = self._time + arg_2_1

	self:draw(arg_2_1)
end

DamageNumbersUI.event_alter_damage_number = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	if not arg_3_2 then
		arg_3_2.text = arg_3_3.text

		local _time = self._time
		local time = arg_3_3.time

		time = time or self._unit_text_time
		arg_3_2.time = _time + time
		arg_3_2.starting_time = self._time

		local color = arg_3_3.color

		color = color or arg_3_2.color
		arg_3_2.color = color
		arg_3_2.color_saved = arg_3_3.color

		local size = arg_3_3.size

		size = size or arg_3_2.size
		arg_3_2.size = size

		local damage = arg_3_3.damage

		damage = damage or arg_3_2.damage
		arg_3_2.damage = damage
	end
end

local tbl_4 = {}
local tbl_5 = {
	default = function (self, arg_4_1, arg_4_2)
		-- function 4
		self.random_x_offset = math.random(-60, 60)
		self.random_y_offset = math.random(-60, 60)
	end,
	floating_damage = function (self, arg_5_1)
		-- function 5
		local num = 50
		local num_2 = 125
		local num_3 = math.random() - 0.5

		self.random_x_offset = num_3 * num
		self.random_y_offset = math.sin(2 * num_3 + math.pi * 0.5) * num_2
	end,
	critical_strike = function (self, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		self.unit = arg_6_3
	end,
	streak_damage = function (self, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		self.unit = arg_7_3
	end,
	floating_radial_damage = function (self, arg_8_1, arg_8_2)
		-- function 8
		local angle = self.angle

		angle = angle or (arg_8_2 - 1) * 0.5

		local num = 150
		local random = math.random(200, 700)
		local cos = math.cos(angle)

		self.random_x_offset = cos * num
		self.floating_speed_x = cos * random

		local sin = math.sin(angle)

		self.random_y_offset = sin * num
		self.floating_speed_y = sin * random
	end
}

local function fn(arg_9_0, arg_9_1)
	-- function 9
	return true
end

DamageNumbersUI.event_add_damage_number = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8)
	-- function 10
	arg_10_8 = arg_10_8 or tbl_4

	local world_position = Camera.world_position(self.camera)
	local world_position_2 = Unit.world_position(arg_10_3, 0)
	local normalize = Vector3.normalize(world_position_2 - world_position)
	local forward = Quaternion.forward(Camera.world_rotation(self.camera))
	local dot = Vector3.dot(forward, normalize)

	if not (not (dot >= 0) or dot <= 1) then
		arg_10_2 = arg_10_2 or 1
		arg_10_5 = arg_10_5 or Vector3(255, 255, 255)

		local DamageNumberVariants = DamageNumberVariants

		if not self._unit_texts[arg_10_3] then
			self._unit_texts[arg_10_3] = {}
		end

		local num = #self._unit_texts[arg_10_3] + 1
		local variant_name = arg_10_8.variant_name

		variant_name = variant_name or "default"

		local var_10_8 = DamageNumberVariants[variant_name]
		local var_10_9
		local tbl = {
			random_y_offset = 0,
			alpha = 255,
			floating_speed_x = 0,
			random_x_offset = 0,
			floating_speed_y = 150,
			size = arg_10_2,
			text = arg_10_1,
			color = {
				255,
				arg_10_5.x,
				arg_10_5.y,
				arg_10_5.z
			},
			time = self._time + (arg_10_4 or self._unit_text_time)
		}
		local floating_speed = arg_10_8.floating_speed

		floating_speed = floating_speed or 150
		tbl.floating_speed = floating_speed
		tbl.starting_time = self._time
		tbl.z_offset = arg_10_7
		tbl.update_function = var_10_8.update

		local complete = var_10_8.complete

		complete = complete or fn
		tbl.complete_function = complete
		tbl.start_function = var_10_8.start
		tbl.damage = arg_10_8.damage
		tbl.using_bucket_damage = arg_10_8.using_bucket_damage

		tbl_5[variant_name](tbl, arg_10_8, num, arg_10_3)

		if not arg_10_6 then
			arg_10_8.update_function = DamageNumberVariants.critical_strike.update
		end

		tbl.color_saved = tbl.color
		self._unit_texts[arg_10_3][num] = tbl

		if not arg_10_8.ref then
			arg_10_8.ref = tbl
		end
	end
end

DamageNumbersUI.destroy = function (self)
	-- function 11
	for k, v in pairs(self._unit_texts) do
		self:_destroy_unit_texts(k)
	end

	if not Managers.state.event then
		Managers.state.event:unregister("add_damage_number", self)
		Managers.state.event:unregister(self, "alter_damage_number")
	end
end

DamageNumbersUI._destroy_unit_texts = function (arg_12_0, arg_12_1)
	-- function 12
	arg_12_0._unit_texts[arg_12_1] = nil
end

DamageNumbersUI.create_ui_elements = function (self)
	-- function 13
	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self.damage_text = UIWidget.init(tbl_3.damage_text)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
end

DamageNumberVariants = {
	default = {
		update = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
			-- function 14
			local size = self.size

			arg_14_2.style.text.font_size = size
			arg_14_2.style.text_shadow.font_size = size
		end
	},
	floating_damage = {
		update = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
			-- function 15
			local size = self.size

			arg_15_2.style.text.font_size = size
			arg_15_2.style.text_shadow.font_size = size

			local num = arg_15_4.x * arg_15_3
			local num_2 = arg_15_4.z * arg_15_3
			local offset = arg_15_2.offset

			offset[1] = num + self.random_x_offset
			offset[2] = num_2 + self.random_y_offset + arg_15_6 * self.floating_speed
		end
	},
	critical_strike = {
		update = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
			-- function 16
			local size = self.size
			local easeOutCubic = math.easeOutCubic(math.min(arg_16_5 * 7, 1))
			local num = size + math.ease_pulse(easeOutCubic) * 60

			arg_16_2.style.text.font_size = num
			arg_16_2.style.text_shadow.font_size = num
		end
	},
	streak_damage = {
		update = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
			-- function 17
			local size = self.size
			local num = arg_17_4.x * arg_17_3
			local num_2 = arg_17_4.z * arg_17_3

			arg_17_2.offset[1] = num
			arg_17_2.offset[2] = num_2 + 60

			local num_3 = 255

			arg_17_2.style.text.text_color[1] = num_3
			arg_17_2.style.text_shadow.text_color[1] = num_3
		end,
		complete = function (self, arg_18_1, arg_18_2)
			-- function 18
			self.update_function = DamageNumberVariants.streak_damage.pop_update
			self.complete_function = DamageNumberVariants.streak_damage.pop_complete
			self.time = arg_18_1 + 0.4
			self.starting_time = arg_18_1

			if not self.using_bucket_damage then
				local damage = self.damage
				local floor = math.floor(damage)
				local num = damage % 1 * 100

				self.dmg_int = floor
				self.dmg_dec = num

				local auto_lerp = math.auto_lerp(0, 75, min_streak_font_size, max_streak_font_size, damage)

				self.size = auto_lerp

				if num > 0 then
					self.text = string.format("{#size(%s)}%s{#size(%s)}.%s", auto_lerp, floor, math.floor(auto_lerp / 2), num)
				end
			end

			return false
		end,
		pop_update = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
			-- function 19
			local size = self.size

			arg_19_2.style.text.font_size = size

			local num = size + (35 * math.sin(arg_19_5 * math.pi - math.pi * 2) + 0)
			local dmg_int = self.dmg_int
			local dmg_dec = self.dmg_dec

			if dmg_dec > 0 then
				self.text = string.format("{#size(%s)}%s{#size(%s)}.%s", num, dmg_int, math.floor(num / 2), dmg_dec)
			else
				self.text = string.format("{#size(%s)}%s", num, dmg_int)
			end

			local num_2 = 255

			arg_19_2.style.text.text_color[1] = num_2
			arg_19_2.style.text_shadow.text_color[1] = num_2

			local num_3 = arg_19_4.x * arg_19_3
			local num_4 = arg_19_4.z * arg_19_3

			arg_19_2.offset[1] = num_3
			arg_19_2.offset[2] = num_4 + 60
		end,
		pop_complete = function (self, arg_20_1, arg_20_2)
			-- function 20
			self.update_function = DamageNumberVariants.streak_damage_fadeout.update
			self.complete_function = fn
			self.time = arg_20_1 + 2
			self.starting_time = arg_20_1
			self.floating_speed = 150

			if not self.using_bucket_damage then
				local damage = self.damage
				local floor = math.floor(damage)
				local num = damage % 1 * 100

				if num > 0 then
					local auto_lerp = math.auto_lerp(0, 75, min_streak_font_size, max_streak_font_size, damage)

					self.text = string.format("{#size(%s)}%s{#size(%s)}.%s", auto_lerp, floor, auto_lerp / 2, num)
				end
			end

			return false
		end
	},
	streak_damage_fadeout = {
		update = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
			-- function 21
			arg_21_2.style.text.text_color = self.color

			local size = self.size

			arg_21_2.style.text.font_size = size
			arg_21_2.style.text_shadow.font_size = size

			local num = arg_21_4.x * arg_21_3
			local num_2 = arg_21_4.z * arg_21_3

			arg_21_2.offset[1] = num
			arg_21_2.offset[2] = num_2 + 60 + arg_21_6 * self.floating_speed
		end
	},
	floating_radial_damage = {
		update = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
			-- function 22
			local size = self.size

			arg_22_2.style.text.font_size = size
			arg_22_2.style.text_shadow.font_size = size

			local num = arg_22_4.x * arg_22_3
			local num_2 = arg_22_4.z * arg_22_3

			arg_22_2.offset[1] = num + arg_22_6 * self.floating_speed_x
			arg_22_2.offset[2] = num_2 + arg_22_6 * self.floating_speed_y

			if arg_22_5 > 0.5 then
				local num_3 = arg_22_2.style.text.text_color[1] * 0.99

				arg_22_2.style.text.text_color[1] = num_3
				arg_22_2.style.text_shadow.text_color[1] = num_3
			end
		end
	}
}

DamageNumbersUI.draw = function (self, arg_23_1)
	-- function 23
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_23_1)

	local damage_text = self.damage_text
	local content = damage_text.content
	local offset = damage_text.offset
	local world_to_screen = Camera.world_to_screen
	local inv_scale = RESOLUTION_LOOKUP.inv_scale
	local world_position = Unit.world_position
	local easeOutCubic = math.easeOutCubic
	local camera = self.camera

	for k, v in pairs(self._unit_texts) do
		if not Unit.alive(k) then
			local var_23_11 = world_position(k, 0)
			local z_offset

			if not v[1] then
				z_offset = v[1].z_offset

				if not z_offset then
					-- Nothing
				end
			end

			z_offset = 1.85

			::label_23_0::

			var_23_11[3] = var_23_11[3] + z_offset

			local var_23_13 = world_to_screen(camera, var_23_11)

			for k_2 = #v, 1, -1 do
				local var_23_14 = v[k_2]

				if not (self._time > var_23_14.time) or not var_23_14.complete_function(var_23_14, self._time, damage_text) then
					table.swap_delete(v, k_2)
				else
					local text = var_23_14.text
					local floating_lerp = var_23_14.floating_lerp
					local num = 1 - (var_23_14.time - self._time) / (var_23_14.time - var_23_14.starting_time)
					local var_23_18 = easeOutCubic(num)
					local num_2 = var_23_13.x * inv_scale
					local num_3 = var_23_13.z * inv_scale

					offset[1] = num_2 + var_23_14.random_x_offset
					offset[2] = num_3 + var_23_14.random_y_offset + var_23_18 * var_23_14.floating_speed

					local num_4 = (1 - var_23_18) * 255

					content.text = text
					damage_text.style.text.text_color = var_23_14.color
					damage_text.style.text.text_color[1] = num_4
					damage_text.style.text_shadow.text_color[1] = num_4

					var_23_14.update_function(var_23_14, self._time, damage_text, inv_scale, var_23_13, num, var_23_18)
					UIRenderer.draw_widget(ui_renderer, damage_text)
				end
			end
		else
			self:_destroy_unit_texts(k)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end
