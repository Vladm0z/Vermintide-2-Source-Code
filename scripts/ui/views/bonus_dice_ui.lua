-- chunkname: @scripts/ui/views/bonus_dice_ui.lua

local var_0_0 = local_require("scripts/ui/views/bonus_dice_ui_definitions")
local easeInCubic = math.easeInCubic

BonusDiceUI = class(BonusDiceUI)

BonusDiceUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager
	self.dice_keeper = arg_1_2.dice_keeper
	self.active_dice_widgets = 0
	self.dice_widgets = {}
	self.die_types = {}
	self.die_count = {}

	local get_dice = arg_1_2.dice_keeper:get_dice()
	local num = 0

	for k, v in pairs(get_dice) do
		num = num + 1
		self.die_types[num] = k
		self.die_count[k] = 0
	end

	self.die_types_n = num

	self:create_ui_elements()
end

BonusDiceUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	for i = 1, 10 do
		self.dice_widgets[i] = UIWidget.init(var_0_0.dice_widget_definition)
	end
end

BonusDiceUI.add_die = function (self, arg_3_1)
	-- function 3
	local num = self.active_dice_widgets + 1
	local var_3_1 = self.dice_widgets[num]

	var_3_1 = var_3_1 or UIWidget.init(var_0_0.dice_widget_definition)

	local num_dice_columns = var_0_0.num_dice_columns
	local dice_size = var_0_0.dice_size
	local gap = var_0_0.gap
	local num_2 = 0
	local num_3 = 0
	local num_4 = (num - 1) % num_dice_columns
	local floor = math.floor((num - 1) / num_dice_columns)
	local num_5 = num_4 * dice_size[1] + gap * num_4
	local num_6 = -(floor * dice_size[2] + gap * floor)

	var_3_1.style.offset[1] = num_5
	var_3_1.style.offset[2] = num_6
	var_3_1.content.texture_id = var_0_0.get_die_texture(arg_3_1)

	UIWidget.animate(var_3_1, UIAnimation.init(UIAnimation.function_by_time, var_3_1.style.color, 1, 0, 255, 1, easeInCubic))

	self.die_count[arg_3_1] = self.die_count[arg_3_1] + 1
	self.dice_widgets[num] = var_3_1
	self.active_dice_widgets = num
end

BonusDiceUI.destroy = function (self)
	-- function 4
	self.dice_keeper = nil
end

BonusDiceUI.update = function (self, arg_5_1)
	-- function 5
	do return end

	if not DebugKeyHandler.key_pressed("f3", "asdasd", "dadsa") then
		self.dice_keeper:add_die("normal", 1)
	end

	self:update_dices()

	if self.active_dice_widgets > 0 then
		self:draw(arg_5_1)
	end
end

BonusDiceUI.update_dices = function (self)
	-- function 6
	local dice_keeper = self.dice_keeper
	local die_count = self.die_count
	local die_types = self.die_types
	local die_types_n = self.die_types_n

	for i = 1, die_types_n do
		local var_6_4 = die_types[i]
		local var_6_5 = die_count[var_6_4]
		local num = dice_keeper:num_new_dices(var_6_4) - var_6_5

		if num > 0 then
			for j = 1, num do
				self:add_die(var_6_4)
			end
		end
	end
end

BonusDiceUI.draw = function (self, arg_7_1)
	-- function 7
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_7_1)

	local dice_widgets = self.dice_widgets
	local active_dice_widgets = self.active_dice_widgets

	for i = 1, active_dice_widgets do
		UIRenderer.draw_widget(ui_renderer, dice_widgets[i])
	end

	UIRenderer.end_pass(ui_renderer)
end
