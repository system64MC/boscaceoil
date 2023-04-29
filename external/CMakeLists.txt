###################################################################################################
# imgui
add_library(imgui STATIC
    imgui/imconfig.h
    imgui/imgui_demo.cpp
    imgui/imgui_draw.cpp
    imgui/imgui_internal.h
    imgui/imgui_tables.cpp
    imgui/imgui_widgets.cpp
    imgui/imgui.cpp
    imgui/imgui.h
    imgui/imstb_rectpack.h
    imgui/imstb_textedit.h
    imgui/imstb_truetype.h

    imgui/backends/imgui_impl_sdl2.cpp
    imgui/backends/imgui_impl_sdl2.h
    imgui/backends/imgui_impl_opengl3.cpp
    imgui/backends/imgui_impl_opengl3.h
)
target_include_directories(imgui SYSTEM
    PUBLIC
        imgui/
        imgui/backends/
)

target_link_libraries(imgui
    PUBLIC
        external::opengl
        external::sdl2
)
add_library(external::imgui ALIAS imgui)




###################################################################################################
# SDL2
find_package(SDL2 REQUIRED)
add_library(sdl2 INTERFACE)
target_include_directories(sdl2 SYSTEM
    INTERFACE
        ${SDL2_INCLUDE_DIR}
)
target_link_libraries(sdl2
    INTERFACE
        ${SDL2_LIBRARY}
        ${CMAKE_DL_LIBS}
)
if(WIN32)
target_link_libraries(sdl2
    INTERFACE
    Setupapi.lib
    # SDL2.lib(SDL_hidapi.obj) : error LNK2019: unresolved external symbol __imp_SetupDiEnumDeviceInfo referenced in function PLATFORM_hid_enumerate
    # SDL2.lib(SDL_hidapi.obj) : error LNK2019: unresolved external symbol __imp_SetupDiDestroyDeviceInfoList referenced in function PLATFORM_hid_enumerate
    # SDL2.lib(SDL_hidapi.obj) : error LNK2019: unresolved external symbol __imp_SetupDiEnumDeviceInterfaces referenced in function PLATFORM_hid_enumerate
    # SDL2.lib(SDL_hidapi.obj) : error LNK2019: unresolved external symbol __imp_SetupDiGetDeviceInterfaceDetailA referenced in function PLATFORM_hid_enumerate
    # SDL2.lib(SDL_hidapi.obj) : error LNK2019: unresolved external symbol __imp_SetupDiGetClassDevsA referenced in function PLATFORM_hid_enumerate
    # SDL2.lib(SDL_hidapi.obj) : error LNK2019: unresolved external symbol __imp_SetupDiGetDeviceRegistryPropertyA referenced in function PLATFORM_hid_enumerate
    # SDL2.lib(SDL_windows_gaming_input.obj) : error LNK2019: unresolved external symbol __imp_CM_Get_Device_IDA referenced in function SDL_IsXInputDevice
    # SDL2.lib(SDL_windows_gaming_input.obj) : error LNK2019: unresolved external symbol __imp_CM_Get_Parent referenced in function SDL_IsXInputDevice
    # SDL2.lib(SDL_windows_gaming_input.obj) : error LNK2019: unresolved external symbol __imp_CM_Locate_DevNodeA referenced in function SDL_IsXInputDevice
)
endif()
add_library(external::sdl2 ALIAS sdl2)


###################################################################################################
# OpenGL
set(OpenGL_GL_PREFERENCE "GLVND")
find_package(OpenGL REQUIRED)
add_library(opengl INTERFACE)
target_link_libraries(opengl INTERFACE OpenGL::GL)
add_library(external::opengl ALIAS opengl)

