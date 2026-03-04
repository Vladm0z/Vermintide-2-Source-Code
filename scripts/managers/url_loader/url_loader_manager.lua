-- chunkname: @scripts/managers/url_loader/url_loader_manager.lua

UrlLoaderManager = class(UrlLoaderManager)

if not UrlLoader then
	Application.warning("[UrlLoaderManager] UrlLoader doesnt exist in this engine branch!")

	UrlLoader = {}

	UrlLoader.init = function (arg_1_0)
		return
	end

	UrlLoader.load_texture = function (arg_2_0, arg_2_1)
		return 0
	end

	UrlLoader.unload = function (arg_3_0, arg_3_1)
		return
	end

	UrlLoader.done = function (arg_4_0, arg_4_1)
		return false
	end

	UrlLoader.success = function (arg_5_0, arg_5_1)
		return false
	end

	UrlLoader.texture = function (arg_6_0, arg_6_1)
		return nil
	end

	UrlLoader.update = function (arg_7_0)
		return
	end

	UrlLoader.destroy = function (arg_8_0)
		return
	end

	UrlLoader.is_stub = true
end

UrlLoaderManager.init = function (arg_9_0)
	if not UrlLoader.is_stub then
		arg_9_0._url_loader = UrlLoader()
	end

	arg_9_0._jobs = {}
	arg_9_0._url_jobs = {}
	arg_9_0._texture_resources = {}
	arg_9_0._reference_counters = {}
	arg_9_0._reference_callbacks = {}
	arg_9_0._cleanup = false
end

UrlLoaderManager.load_resource = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	arg_10_4 = arg_10_4 or arg_10_2
	arg_10_5 = arg_10_5 or "1"
	arg_10_6 = arg_10_6 or "downloaded_textures"

	if not arg_10_0._jobs[arg_10_4] then
		local var_10_0 = UrlLoader.load_texture(arg_10_0._url_loader, arg_10_2, arg_10_4, arg_10_5, arg_10_6)
		local var_10_1 = {
			url_job = var_10_0,
			cache_key = arg_10_4,
			cache_version = arg_10_5,
			texture_category = arg_10_6
		}

		arg_10_0._jobs[arg_10_4] = var_10_1
		arg_10_0._url_jobs[arg_10_4] = var_10_0
	end

	if not arg_10_0._reference_counters[arg_10_4] then
		arg_10_0._reference_counters[arg_10_4] = {}
	end

	if not arg_10_0._reference_callbacks[arg_10_4] then
		arg_10_0._reference_callbacks[arg_10_4] = {}
	end

	arg_10_0._reference_counters[arg_10_4][arg_10_1] = true
	arg_10_0._reference_callbacks[arg_10_4][arg_10_1] = arg_10_3
end

UrlLoaderManager.unload_resource = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._reference_counters
	local var_11_1 = arg_11_0._reference_callbacks
	local var_11_2

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		if iter_11_1[arg_11_1] then
			var_11_2 = iter_11_0
			iter_11_1[arg_11_1] = nil
			var_11_1[iter_11_0][arg_11_1] = nil

			if next(iter_11_1) then
				return
			else
				break
			end
		end
	end

	fassert(var_11_2, "Could not find any Cache key for reference (%s)", arg_11_1)

	local var_11_3 = arg_11_0._jobs
	local var_11_4 = arg_11_0._url_jobs
	local var_11_5 = var_11_4[var_11_2]
	local var_11_6 = arg_11_0._url_loader

	UrlLoader.unload(var_11_6, var_11_5)

	var_11_3[var_11_2] = nil
	var_11_4[var_11_2] = nil
	arg_11_0._texture_resources[var_11_2] = nil
	arg_11_0._cleanup = true
end

UrlLoaderManager._on_job_complete = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._url_loader
	local var_12_1 = arg_12_1.url_job
	local var_12_2 = arg_12_1.cache_key

	if arg_12_2 then
		local var_12_3 = UrlLoader.texture(var_12_0, var_12_1)

		arg_12_0._texture_resources[var_12_2] = var_12_3
	else
		local var_12_4 = arg_12_0._reference_counters[var_12_2]
		local var_12_5 = arg_12_0._reference_callbacks[var_12_2]

		for iter_12_0, iter_12_1 in pairs(var_12_5) do
			iter_12_1(nil)

			var_12_5[iter_12_0] = nil
			var_12_4[iter_12_0] = nil
		end

		UrlLoader.unload(var_12_0, var_12_1)

		arg_12_0._url_jobs[var_12_2] = nil
	end

	arg_12_0._jobs[var_12_2] = nil
end

UrlLoaderManager.update = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._url_loader
	local var_13_1 = arg_13_0._jobs

	for iter_13_0, iter_13_1 in pairs(var_13_1) do
		local var_13_2 = iter_13_1.url_job

		if UrlLoader.done(var_13_0, var_13_2) then
			local var_13_3 = UrlLoader.success(var_13_0, var_13_2)

			arg_13_0:_on_job_complete(iter_13_1, var_13_3)
		end
	end

	local var_13_4 = arg_13_0._texture_resources
	local var_13_5 = arg_13_0._reference_callbacks

	for iter_13_2, iter_13_3 in pairs(var_13_5) do
		local var_13_6 = var_13_4[iter_13_2]

		if var_13_6 then
			for iter_13_4, iter_13_5 in pairs(iter_13_3) do
				iter_13_5(var_13_6)

				iter_13_3[iter_13_4] = nil
			end
		end
	end
end

UrlLoaderManager.post_render = function (arg_14_0)
	if arg_14_0._cleanup then
		local var_14_0 = arg_14_0._url_loader

		UrlLoader.update(var_14_0)

		arg_14_0._cleanup = false
	end
end

UrlLoaderManager.destroy = function (arg_15_0)
	local var_15_0 = arg_15_0._url_loader
	local var_15_1 = arg_15_0._url_jobs
	local var_15_2 = arg_15_0._texture_resources

	for iter_15_0, iter_15_1 in pairs(var_15_2) do
		local var_15_3 = var_15_1[iter_15_0]

		UrlLoader.unload(var_15_0, var_15_3)
	end

	local var_15_4 = arg_15_0._reference_counters

	for iter_15_2, iter_15_3 in pairs(var_15_4) do
		for iter_15_4, iter_15_5 in pairs(iter_15_3) do
			Application.warning(string.format("[UrlLoaderManager] - [Destroy] - Found existing reference to Cache key: (%s), Reference name: (%s)", iter_15_2, iter_15_4))
		end
	end

	UrlLoader.update(var_15_0)
	UrlLoader.destroy(var_15_0)

	arg_15_0._url_loader = nil
	arg_15_0._jobs = nil
	arg_15_0._url_jobs = nil
	arg_15_0._texture_resources = nil
	arg_15_0._reference_counters = nil
	arg_15_0._reference_callbacks = nil
end
