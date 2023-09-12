vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO silverqx/TinyORM
    REF ca8909896247b21bf08d62a5109b23e9f65c89e1
    SHA512 ac0e3e91354a5c12471924a34fa24e4c040125614e1117da1ae50916c70630d217a7df470c1b929aa15f3a6acc6b511ddea808a9f2d6e675f05afa8a2a764e2c
    HEAD_REF main
    PATCHES
        0001-install-tom.patch
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
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

configure_file("${CMAKE_CURRENT_LIST_DIR}/usage"
    "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage"
    @ONLY
)
