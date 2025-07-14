set_project("My_template")

set_languages("cxx17")

set_config("sdk","D:/Portable/msys64/ucrt64")
set_config("plat","mingw")
set_config("archs","x64")
set_config("toolchain","clang")
set_config("mode","release")
set_config("builddir", "build")

add_rules("mode.release","mode.debug")

package("python3")
    on_fetch(function (package,opt)
        local result={}
        import("detect.tools.find_python")
        local py,version = find_python({version=true})
        local inc,err=os.iorunv(py,{"-c","import sysconfig;print(sysconfig.get_path(\"include\"),end=\"\")"})
        local root,err=os.iorunv(py,{"-c","import sysconfig;print(sysconfig.get_config_var(\"prefix\"),end=\"\")"})
        local version,err=os.iorunv(py,{"-c","import sysconfig;print(sysconfig.get_config_var(\"VERSION\"),end=\"\")"})
        result.includedirs=inc
        result.linkdirs=root
        result.links="python"..version
        -- print(result)
        return result
    end)
package_end()


package("fmt")
    -- on_fetch(function (package,opt)
    --     local result={}
    --     local conda_prefix=os.getenv("CONDA_PREFIX")
    --     print(conda_prefix)
    --     local incs=path.join(conda_prefix,"Library/include")
    --     local linkdirs=path.join(conda_prefix,"Library/lib")
    --     local links="fmt"
    --     result.includedirs=incs 
    --     result.linkdirs=linkdirs 
    --     result.links=links
    --     print(result)
    --     return result
    -- end)

    set_urls(path.join(os.projectdir(),"/externals/fmt-$(version).zip"))
    add_versions("11.2.0",string.lower("203EB4E8AA0D746C62D8F903DF58E0419E3751591BB53FF971096EAA0EBD4EC3"))
    set_installdir(path.join(os.projectdir(),"externals/fmt"))

    on_install(function (package,opt)
        local configs = {"-DFMT_TEST=OFF", "-DFMT_DOC=OFF", "-DFMT_FUZZ=OFF", "-DCMAKE_CXX_VISIBILITY_PRESET=default"}
        table.insert(configs, "-DBUILD_SHARED_LIBS=OFF")
        table.insert(configs, "-DCMAKE_BUILD_TYPE=Release")
        table.insert(configs, "-DFMT_UNICODE=ON")
        -- package:add("cxxflags", "/utf-8")
        import("package.tools.cmake").install(package, configs)
    end) 
package_end()

package("xtensor")
    set_urls(path.join(os.projectdir(),"/externals/xtensor-$(version).zip"))
    add_versions("0.26.0",string.lower("9CE5AAF30E3FB16F4EEDF0E9388C9128EA3E1F2ED52006253244773BC313D1FE"))
    set_installdir(path.join(os.projectdir(),"externals/xtensor"))

    on_install(function (package,opt)
        local configs = {"-DFMT_TEST=OFF", "-DFMT_DOC=OFF", "-DFMT_FUZZ=OFF", "-DCMAKE_CXX_VISIBILITY_PRESET=default"}
        table.insert(configs, "-DBUILD_SHARED_LIBS=OFF")
        table.insert(configs, "-DCMAKE_BUILD_TYPE=Release")
        table.insert(configs, "-DFMT_UNICODE=ON")
        -- package:add("cxxflags", "/utf-8")
        import("package.tools.cmake").install(package, configs)
    end) 
package_end()

package("eigen")
    set_urls(path.join(os.projectdir(),"/externals/eigen-$(version).zip"))
    add_versions("3.4.0",string.lower("EBA3F3D414D2F8CBA2919C78EC6DAAB08FC71BA2BA4AE502B7E5D4D99FC02CDA"))
    set_installdir(path.join(os.projectdir(),"/externals/eigen"))

    on_load(function (package)
        package:set("kind", "library", {headeronly = true})
    end)

    on_install(function (package)
        import("package.tools.cmake").install(package, {"-DBUILD_TESTING=OFF"}) 
    end)
package_end()

package("pybind11")
    set_urls(path.join(os.projectdir(),"/externals/pybind11-$(version).zip"))
    add_versions("3.0.0",string.lower("DFE152AF2F454A9D8CD771206C014AECB8C3977822B5756123F29FD488648334"))
    set_installdir(path.join(os.projectdir(),"/externals/pybind11"))

    on_install("windows|native", "macosx", "linux","mingw", function (package)
        -- import("detect.tools.find_python3")

        -- local configs = {"-DPYBIND11_TEST=OFF"}
        -- local python = find_python3()
        -- if python and path.is_absolute(python) then
        --     table.insert(configs, "-DPython_EXECUTABLE=" .. python)
        -- end
        import("package.tools.cmake").install(package, configs)
    end)
package_end()

add_requires("python3",{system=true ,configs = {shared = true}})
add_requires("fmt 11.2.0",{system=false  })
add_requires("eigen 3.4.0",{system=false })
add_requires("pybind11 3.0.0",{system=false })

target("main")
    set_kind("binary")
    add_files("src/main.cpp")
    set_targetdir("out")
    add_packages("python3")
    add_packages("fmt")
    add_packages("eigen")
    add_packages("pybind11")
    -- add_ldflags("-static", {force = true})
    -- add_ldflags("-static-libgcc", {force = true})
    -- add_ldflags("-static-libstdc++", {force = true})
target_end()

target("example")
    
    add_rules("python.module")
    
    -- add_shflags("-static-libgcc")
    -- add_shflags("-static-libstdc++")
    -- add_shflags("-Wl,-Bstatic -lpthread -Wl,-Bdynamic")
    add_shflags("-static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -lpthread -Wl,-Bdynamic ")
    add_files("src/pymodule.cpp")

    set_targetdir("out")
    add_packages("python3")
    add_packages("pybind11")

target_end()

