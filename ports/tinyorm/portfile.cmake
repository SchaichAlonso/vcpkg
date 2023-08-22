vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO silverqx/TinyORM
    REF dddc80c8712fd4eca892120d7d787ab067300643
    SHA512 990dec9a3bfc59a31c574dd1f3f49ae476e244997fc13e4f7e32fc55b55f9b19fdcaafbd37a18bfb06b912dfa306da4c512628a411fd7d43e395c671c098f908
    HEAD_REF main
    PATCHES
        0001-install-tom.patch
        0003-reduce-assert-scopes.patch
        0004-remove-interface-warnings.patch
)

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    PREFIX TINYORM
    FEATURES
        mysqlping MYSQL_PING
        tool TOM_EXAMPLE
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DBUILD_TESTS:BOOL=OFF
        -DMATCH_EQUAL_EXPORTED_BUILDTREE:BOOL=ON
        -DTINY_VCPKG:BOOL=ON
        -DVERBOSE_CONFIGURE:BOOL=ON
        ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
include(tiny_cmake_config_fixup)
tiny_cmake_config_fixup()

if("tool" IN_LIST FEATURES)
    vcpkg_copy_tools(TOOL_NAMES tom AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# Install license and usage
file(INSTALL "${SOURCE_PATH}/LICENSE"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)

configure_file("${CMAKE_CURRENT_LIST_DIR}/usage"
    "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage"
    @ONLY
)
