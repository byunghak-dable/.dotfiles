return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	opts = function()
		local jdtls = require("jdtls")
		local registry = require("mason-registry")
		local jdtls_path = registry.get_package("jdtls"):get_install_path()

		-- test & debug bundles
		local bundles = {}
		local test_path = require("mason-registry").get_package("java-test"):get_install_path()
		local test_bundle = vim.split(vim.fn.glob(test_path .. "/extension/server/*.jar"), "\n")
		local debug_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()
		local debug_bundle =
			vim.split(vim.fn.glob(debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
		if test_bundle[1] ~= "" then vim.list_extend(bundles, test_bundle) end
		if debug_bundle[1] ~= "" then vim.list_extend(bundles, debug_bundle) end

		-- capabilities
		local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			ok and cmp_lsp.default_capabilities() or {}
		)
		jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

		return {
			cmd = {
				"java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-javaagent:" .. jdtls_path .. "/lombok.jar",
				"-Xms1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
				"-configuration",
				jdtls_path .. "/config_" .. (vim.fn.has("mac") == 1 and "mac" or "linux"),
				"-data",
				os.getenv("HOME") .. "/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"), -- project name
			},
			root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
			capabilities = capabilities,
			on_attach = function(_, bufnr)
				local buf_opts = { buffer = bufnr, noremap = true }

				vim.keymap.set("n", "<leader>tc", jdtls.test_class, buf_opts)
				vim.keymap.set("n", "<leader>tm", jdtls.test_nearest_method, buf_opts)
				vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, buf_opts)
				vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, buf_opts)
				vim.keymap.set("n", "<leader>ec", jdtls.extract_constant, buf_opts)
				vim.keymap.set("v", "<leader>ev", "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", buf_opts)
				vim.keymap.set("v", "<leader>ec", "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", buf_opts)
				vim.keymap.set("v", "<leader>em", "<esc><cmd>lua require('jdtls').extract_method(true)<cr>", buf_opts)

				-- debug
				jdtls.setup_dap({ hotcodereplace = "auto" })
				jdtls.setup.add_commands()
				jdtls.dap.setup_dap_main_class_configs()

				-- codelens
				pcall(vim.lsp.codelens.refresh)
				vim.api.nvim_create_autocmd("BufWritePost", {
					buffer = bufnr,
					callback = function() pcall(vim.lsp.codelens.refresh) end,
				})
			end,
			settings = {
				java = {
					configuration = {
						updateBuildConfiguration = "interactive",
						runtimes = {
							{
								name = "JavaSE-17",
								path = "~/.sdkman/candidates/java/17.0.5-tem",
							},
						},
					},
					eclipse = { downloadSources = true },
					maven = { downloadSources = true },
					implementationsCodeLens = { enabled = true },
					referencesCodeLens = { enabled = true },
					references = { includeDecompiledSources = true },
					inlayHints = { parameterNames = { enabled = "all" } },
					format = { enabled = true },
				},
				completion = {
					favoriteStaticMembers = {
						"org.hamcrest.MatcherAssert.assertThat",
						"org.hamcrest.Matchers.*",
						"org.hamcrest.CoreMatchers.*",
						"org.junit.jupiter.api.Assertions.*",
						"java.util.Objects.requireNonNull",
						"java.util.Objects.requireNonNullElse",
						"org.mockito.Mockito.*",
					},
				},
				signatureHelp = { enabled = true },
				contentProvider = { preferred = "fernflower" },
				sources = {
					organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
				},
				codeGeneration = {
					toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
					useBlocks = true,
				},
			},
			flags = { allow_incremental_sync = true },
			init_options = { bundles = bundles },
		}
	end,
	config = function(_, opts)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function() require("jdtls").start_or_attach(opts) end,
		})
	end,
}
