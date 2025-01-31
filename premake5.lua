PROJECT_GENERATOR_VERSION = 3

newoption({
	trigger = "gmcommon",
	description = "Sets the path to the garrysmod_common (https://github.com/danielga/garrysmod_common) directory",
	value = "path to garrysmod_common directory"
})

local gmcommon = assert(_OPTIONS.gmcommon or os.getenv("GARRYSMOD_COMMON"),
	"you didn't provide a path to your garrysmod_common (https://github.com/danielga/garrysmod_common) directory")
include(gmcommon)

local REDIS_FOLDER = "cpp_redis"
local TACOPIE_FOLDER = "cpp_redis/tacopie"

CreateWorkspace({name = "redis.core"})
	CreateProject({serverside = true})
		links({"cpp_redis", "tacopie", "pthread"})
		sysincludedirs({REDIS_FOLDER .. "/includes", TACOPIE_FOLDER .. "/includes"})
		IncludeLuaShared()

		filter("system:windows")
			links("ws2_32")

	CreateProject({serverside = false})
		links({"cpp_redis", "tacopie", "pthread"})
		sysincludedirs({REDIS_FOLDER .. "/includes", TACOPIE_FOLDER .. "/includes"})
		IncludeLuaShared()

		filter("system:windows")
			links("ws2_32")

	project("cpp_redis")
		kind("StaticLib")
		includedirs({
			REDIS_FOLDER .. "/includes",
			TACOPIE_FOLDER .. "/includes"
		})
		files({
			REDIS_FOLDER .. "/sources/**.cpp",
			REDIS_FOLDER .. "/includes/cpp_redis/**"
		})
		vpaths({
			["Source files/*"] = REDIS_FOLDER .. "/sources/**.cpp",
			["Header files/*"] = REDIS_FOLDER .. "/includes/cpp_redis/**"
		})
		links({"tacopie", "pthread"})

		filter("system:windows")
			files(REDIS_FOLDER .. "/sources/network/windows_impl/*.cpp")

		filter("system:not windows")
			files(REDIS_FOLDER .. "/sources/network/unix_impl/*.cpp")

	project("tacopie")
		kind("StaticLib")
		includedirs(TACOPIE_FOLDER .. "/includes")
		files({
			TACOPIE_FOLDER .. "/sources/utils/*.cpp",
			TACOPIE_FOLDER .. "/sources/network/*.cpp",
			TACOPIE_FOLDER .. "/sources/network/common/*.cpp",
			TACOPIE_FOLDER .. "/includes/tacopie/**"
		})
		vpaths({
			["Source files/*"] = TACOPIE_FOLDER .. "/sources/**.cpp",
			["Header files/*"] = TACOPIE_FOLDER .. "/includes/tacopie/**"
		})

		links("pthread")

		filter("system:windows")
			files(TACOPIE_FOLDER .. "/sources/network/windows/*.cpp")

		filter("system:not windows")
			files(TACOPIE_FOLDER .. "/sources/network/unix/*.cpp")
