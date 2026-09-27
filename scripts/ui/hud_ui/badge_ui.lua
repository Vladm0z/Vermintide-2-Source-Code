-- chunkname: @scripts/ui/hud_ui/badge_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/badge_ui_definitions")
local badge_widget_definition = var_0_0.badge_widget_definition
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

BadgeUI = class(BadgeUI)

BadgeUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._input_manager = arg_1_2.input_manager
	self._player_manager = arg_1_2.player_manager
	self._local_unique_id = arg_1_2.player:unique_id()
	self._world = arg_1_2.world_manager:world("level_world")
	self._wwise_world = arg_1_2.world_manager:wwise_world(self._world)
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._ingame_ui_context = arg_1_2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
	self._has_active_badge = false
	self._animations = {}
	self._badges_queue = {}

	self:_create_ui_elements()
	Managers.state.event:register(self, "add_local_badge", "event_add_local_badge")
end

BadgeUI.destroy = function (self)
	-- function 2
	GarbageLeakDetector.register_object(self, "badge_ui")
	Managers.state.event:unregister("add_badge", self)

	self.ui_animator = nil
end

BadgeUI._create_ui_elements = function (self)
	-- function 3
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._badge_widget = UIWidget.init(badge_widget_definition)
end

BadgeUI.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_4_1)

	for k, v in pairs(_animations) do
		local id = v.id

		if not _ui_animator:is_animation_completed(id) then
			_ui_animator:stop_animation(id)
			self:_remove_active_badge(k)
			self:_add_badge_from_queue()
		end
	end

	self:_draw(arg_4_1)
end

BadgeUI._draw = function (self, arg_5_1)
	-- function 5
	if not self._has_active_badge then
		return
	end

	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("ingame_menu")
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_5_1, nil, _render_settings)
	UIRenderer.draw_widget(_ui_renderer, self._badge_widget)
	UIRenderer.end_pass(_ui_renderer)
end

BadgeUI._get_badge = function (arg_6_0, arg_6_1)
	-- function 6
	local var_6_0 = NetworkLookup.badges[arg_6_1]
	local var_6_1 = BadgeDefinitions[var_6_0]

	fassert(var_6_1, "Unknown badge_id '%s'", arg_6_1)

	return var_6_1
end

BadgeUI.event_add_local_badge = function (self, arg_7_1)
	-- function 7
	self:add_badge(self._local_unique_id .. "_" .. arg_7_1, self:_get_badge(arg_7_1))
end

BadgeUI.event_add_remote_player_badge = function (self, arg_8_1, arg_8_2)
	-- function 8
	self:add_badge(arg_8_1 .. "_" .. arg_8_2, self:_get_badge(arg_8_2))
end

BadgeUI._add_to_queue = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _badges_queue = self._badges_queue

	for i, v in ipairs(_badges_queue) do
		if v.hash == arg_9_1 then
			v.amount = v.amount + 1

			return
		end
	end

	_badges_queue[#_badges_queue + 1] = {
		amount = 1,
		hash = arg_9_1,
		badge = arg_9_2
	}
end

BadgeUI.add_badge = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	arg_10_3 = arg_10_3 ~= nil or not true or arg_10_3
	arg_10_4 = arg_10_4 ~= nil or not 1 or arg_10_4

	if not arg_10_3 and not self._has_active_badge then
		self:_add_to_queue(arg_10_1, arg_10_2)

		return
	end

	self._has_active_badge = true

	local _badge_widget = self._badge_widget
	local content = _badge_widget.content
	local gui = self._ui_renderer.gui

	Material.set_texture(Gui.material(gui, "versus_badge_icon"), "diffuse_map", "gui/1080p/single_textures/carousel/badge_icons/" .. arg_10_2.texture_id .. "_icon")
	Material.set_texture(Gui.material(gui, "versus_badge_glow"), "diffuse_map", "gui/1080p/single_textures/carousel/badge_icons/" .. arg_10_2.texture_id .. "_glow")

	_badge_widget.style.frame_glow.color = arg_10_2.color
	_badge_widget.style.icon_glow.color = arg_10_2.color
	content.text_name = arg_10_2.text
	content.text_desc = arg_10_2.description

	if arg_10_4 > 1 then
		content.text_name = content.text_name .. " x" .. arg_10_4
	end

	self:_start_animation("on_enter", 1, _badge_widget)
end

BadgeUI._start_animation = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings,
		ui_scenegraph = self._ui_scenegraph
	}
	local start_animation = self._ui_animator:start_animation(arg_11_1, arg_11_3, scenegraph_definition, tbl)

	self._animations[arg_11_2] = {
		id = start_animation,
		name = arg_11_1
	}
end

BadgeUI._remove_active_badge = function (self, arg_12_1)
	-- function 12
	self._animations[arg_12_1] = nil
	self._has_active_badge = false
end

BadgeUI._add_badge_from_queue = function (self)
	-- function 13
	if not self._has_active_badge then
		return
	end

	local remove = table.remove(self._badges_queue, 1)

	if not remove then
		return
	end

	local badge = remove.badge
	local hash = remove.hash

	self:add_badge(hash, badge, false, remove.amount)
end
