cmake_minimum_required(VERSION 3.15)
set_property(GLOBAL PROPERTY USE_FOLDERS OFF)
project(bosca C CXX)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
source_group("_cmake/rules" REGULAR_EXPRESSION "\\.rule$")
source_group("_cmake" REGULAR_EXPRESSION "CMakeLists\.txt")

add_library(project_options INTERFACE)
add_library(project_warnings INTERFACE)
target_compile_features(project_options INTERFACE cxx_std_17)
# set_project_warnings(project_warnings)
# enable_sanitizers(project_options)
add_library(bosca::options ALIAS project_options)
add_library(bosca::warnings ALIAS project_warnings)


set(src
    src/bar.cc src/bar.h
    src/palette.cc
    src/help.cc
    src/arrangementclass.cc
    src/drumkit.cc
    # src/musicphrase.cc # needs control
    # src/voicelist.cc # needs gfx
)
source_group("" FILES ${src})
add_executable(
    bosca WIN32 MACOSX_BUNDLE
	${src}
)
target_link_libraries(bosca
    PRIVATE
        project_options
        project_warnings
        # si::sion
)


# add_subdirectory(external)
