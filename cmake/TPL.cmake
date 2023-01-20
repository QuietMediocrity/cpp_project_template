include(FindPkgConfig)

option(TPL_SDL       "Include sdl2"        OFF)
option(TPL_SDL_GFX   "Include SDL2_gfx"    OFF)
option(TPL_SFML      "Include sfml-all"    OFF)
option(TPL_FMT       "Include fmt"         OFF)

if(TPL_SDL)
        PKG_SEARCH_MODULE(SDL2 REQUIRED sdl2)
endif()

if(TPL_SDL_GFX)
        PKG_SEARCH_MODULE(SDL2_GFX REQUIRED SDL2_gfx)
endif()

if(TPL_SFML)
        PKG_SEARCH_MODULE(SFML REQUIRED sfml-all)
endif()

if(TPL_FMT)
        PKG_SEARCH_MODULE(FMT REQUIRED fmt)
endif()

