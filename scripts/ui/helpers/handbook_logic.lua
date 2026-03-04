-- chunkname: @scripts/ui/helpers/handbook_logic.lua

HandbookLogic = class(HandbookLogic)

HandbookLogic.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._context = table.merge({
		layout = arg_1_0
	}, arg_1_1)
	arg_1_0._reference_name = arg_1_1.reference_name or "HandbookLogic"
	arg_1_0._blueprints = arg_1_2
	arg_1_0._video_references = {}
	arg_1_0._loaded_packages = {}
	arg_1_0._reusable_material = false
end

HandbookLogic.destroy = function (arg_2_0)
	arg_2_0:_destroy_video_players()
	arg_2_0:_unload_packages()
end

HandbookLogic.create_video_player = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._reference_name .. "@" .. arg_3_1
	local var_3_1 = arg_3_0._video_references
	local var_3_2 = arg_3_0._context

	if not var_3_1[var_3_0] then
		UIRenderer.create_video_player(var_3_2.ui_renderer, var_3_0, var_3_2.world, arg_3_1, true)

		var_3_1[var_3_0] = var_3_0
	end

	return var_3_0
end

HandbookLogic._destroy_video_players = function (arg_4_0)
	if table.is_empty(arg_4_0._video_references) then
		return
	end

	local var_4_0 = arg_4_0._context.world
	local var_4_1 = arg_4_0._context.ui_renderer

	for iter_4_0 in pairs(arg_4_0._video_references) do
		UIRenderer.destroy_video_player(var_4_1, iter_4_0, var_4_0)
	end

	table.clear(arg_4_0._video_references)
end

HandbookLogic.load_texture_package = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._reusable_material

	if not var_5_0 then
		local var_5_1 = arg_5_0._context.ui_renderer.gui

		Gui.clone_material_from_template(var_5_1, "material_handbook_diffuse", "template_store_diffuse_masked")

		var_5_0 = Gui.material(var_5_1, "material_handbook_diffuse")
		arg_5_0._reusable_material = var_5_0
	end

	local function var_5_2()
		Material.set_texture(var_5_0, "diffuse_map", arg_5_1)

		arg_5_2.content.texture = var_5_0
	end

	local var_5_3 = true

	Managers.package:load(arg_5_1, arg_5_0._reference_name, var_5_2, var_5_3)

	arg_5_0._loaded_packages[arg_5_1] = arg_5_1

	return "material_handbook_diffuse"
end

HandbookLogic._unload_packages = function (arg_7_0)
	if arg_7_0._reusable_material then
		Material.set_texture(arg_7_0._reusable_material, "diffuse_map", UISettings.transparent_placeholder_texture)

		arg_7_0._reusable_material = nil
	end

	local var_7_0 = arg_7_0._reference_name

	for iter_7_0 in pairs(arg_7_0._loaded_packages) do
		Managers.package:unload(iter_7_0, var_7_0)
	end

	table.clear(arg_7_0._loaded_packages)
end

HandbookLogic._create_entry = function (arg_8_0, arg_8_1)
	if arg_8_1.condition == false then
		return
	end

	if arg_8_1.condition_func and not arg_8_1:condition_func() then
		return
	end

	local var_8_0 = arg_8_1.type
	local var_8_1 = arg_8_0._blueprints[var_8_0]

	if not var_8_1 then
		return
	end

	local var_8_2 = var_8_1(arg_8_0._context, arg_8_1)
	local var_8_3 = UIWidget.init(var_8_2)

	if var_8_0 == "image" then
		local var_8_4 = "gui/1080p/single_textures/handbook/" .. arg_8_1.texture

		arg_8_0:load_texture_package(var_8_4, var_8_3)
	end

	return var_8_3
end

HandbookLogic.create_entry_widgets = function (arg_9_0, arg_9_1)
	local var_9_0 = {}

	arg_9_0:_destroy_video_players()
	arg_9_0:_unload_packages()

	var_9_0[1] = arg_9_0:_create_entry({
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

	local var_9_1 = var_9_0[1].content.size[2]

	var_9_0[1].offset[2] = -var_9_1

	for iter_9_0 = 1, #arg_9_1 do
		local var_9_2 = arg_9_0:_create_entry(arg_9_1[iter_9_0])

		if var_9_2 then
			var_9_0[#var_9_0 + 1] = var_9_2

			local var_9_3 = var_9_2.content
			local var_9_4 = var_9_3.size[2]
			local var_9_5 = var_9_3.padding or 0

			var_9_1 = var_9_1 + var_9_4 + var_9_5
			var_9_2.offset[2] = -var_9_1
		end
	end

	return var_9_0, var_9_1
end
