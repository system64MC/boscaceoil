cmake_minimum_required(VERSION 3.15)
set_property(GLOBAL PROPERTY USE_FOLDERS OFF)
project(bosca C CXX)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

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
    src/si-voice.h
    src/rect.h

    src/bar.cc src/bar.h

    src/palette.cc
    src/help.cc
    src/arrangementclass.cc
    src/drumkit.cc
    src/instrument.cc
    src/list.cc
    src/musicphrase.cc
    src/voicelist.cc
    src/guibutton.cc

    src/sdl2-opengl-main.cc
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
        external::imgui
)


add_subdirectory(external)
