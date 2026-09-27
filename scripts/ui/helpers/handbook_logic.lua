-- chunkname: @scripts/ui/helpers/handbook_logic.lua

HandbookLogic = class(HandbookLogic)

HandbookLogic.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._context = table.merge({
		layout = self
	}, arg_1_1)

	local reference_name = arg_1_1.reference_name

	reference_name = reference_name or "HandbookLogic"
	self._reference_name = reference_name
	self._blueprints = arg_1_2
	self._video_references = {}
	self._loaded_packages = {}
	self._reusable_material = false
end

HandbookLogic.destroy = function (self)
	-- function 2
	self:_destroy_video_players()
	self:_unload_packages()
end

HandbookLogic.create_video_player = function (self, arg_3_1)
	-- function 3
	local str = self._reference_name .. "@" .. arg_3_1
	local _video_references = self._video_references
	local _context = self._context

	if not _video_references[str] then
		UIRenderer.create_video_player(_context.ui_renderer, str, _context.world, arg_3_1, true)

		_video_references[str] = str
	end

	return str
end

HandbookLogic._destroy_video_players = function (self)
	-- function 4
	if not table.is_empty(self._video_references) then
		return
	end

	local world = self._context.world
	local ui_renderer = self._context.ui_renderer

	for k in pairs(self._video_references) do
		UIRenderer.destroy_video_player(ui_renderer, k, world)
	end

	table.clear(self._video_references)
end

HandbookLogic.load_texture_package = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _reusable_material = self._reusable_material

	if not _reusable_material then
		local gui = self._context.ui_renderer.gui

		Gui.clone_material_from_template(gui, "material_handbook_diffuse", "template_store_diffuse_masked")

		_reusable_material = Gui.material(gui, "material_handbook_diffuse")
		self._reusable_material = _reusable_material
	end

	local function fn()
		-- function 6
		Material.set_texture(_reusable_material, "diffuse_map", arg_5_1)

		arg_5_2.content.texture = _reusable_material
	end

	local flag = true

	Managers.package:load(arg_5_1, self._reference_name, fn, flag)

	self._loaded_packages[arg_5_1] = arg_5_1

	return "material_handbook_diffuse"
end

HandbookLogic._unload_packages = function (self)
	-- function 7
	if not self._reusable_material then
		Material.set_texture(self._reusable_material, "diffuse_map", UISettings.transparent_placeholder_texture)

		self._reusable_material = nil
	end

	local _reference_name = self._reference_name

	for k in pairs(self._loaded_packages) do
		Managers.package:unload(k, _reference_name)
	end

	table.clear(self._loaded_packages)
end

HandbookLogic._create_entry = function (self, arg_8_1)
	-- function 8
	if arg_8_1.condition == false then
		return
	end

	if not (not arg_8_1.condition_func and arg_8_1:condition_func()) then
		return
	end

	local type = arg_8_1.type
	local var_8_1 = self._blueprints[type]

	if not var_8_1 then
		return
	end

	local var_8_2 = var_8_1(self._context, arg_8_1)
	local var_8_3 = UIWidget.init(var_8_2)

	if type == "image" then
		local str = "gui/1080p/single_textures/handbook/" .. arg_8_1.texture

		self:load_texture_package(str, var_8_3)
	end

	return var_8_3
end

HandbookLogic.create_entry_widgets = function (self, arg_9_1)
	-- function 9
	local tbl = {}

	self:_destroy_video_players()
	self:_unload_packages()

	tbl[1] = self:_create_entry({
		padding = 0,
		type = "text",
		text = arg_9_1.display_name,
		style = {
			font_size = 64,
			upper_case = true,
			font_type = "hell_shark_header_masked",
			text_color = Colors.get_color_table_with_alpha("font_title", 255)
		}
	})

	local var_9_1 = tbl[1].content.size[2]

	tbl[1].offset[2] = -var_9_1

	for i = 1, #arg_9_1 do
		local _create_entry = self:_create_entry(arg_9_1[i])

		if not _create_entry then
			tbl[#tbl + 1] = _create_entry

			local content = _create_entry.content
			local var_9_4 = content.size[2]
			local padding = content.padding

			padding = padding or 0
			var_9_1 = var_9_1 + var_9_4 + padding
			_create_entry.offset[2] = -var_9_1
		end
	end

	return tbl, var_9_1
end
