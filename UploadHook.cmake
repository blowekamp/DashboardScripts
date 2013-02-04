
if ( dashboard_git_branch STREQUAL "master" OR
    dashboard_git_branch STREQUAL "release" )

  # set cmake flag to remove git hash for name
  set( dashboard_cache "${dashboard_cache}
  SimpleITK_BUILD_DISTRIBUTE:BOOL=ON" )
endif()

find_program(SCP_EXECUTABLE
  NAMES scp
  PATH_SUFFIXES Git/cmd Git/bin
  DOC "scp executable"
  )

macro ( dashboard_hook_end )
  message( "build_number_errors: ${build_number_errors}" )

  # build the distribution target to make the packages to upload
  ctest_build( BUILD "${CTEST_BINARY_DIRECTORY}/SimpleITK-build" TARGET dist )

  if ( ${build_number_errors} EQUAL "0" )
    message ( "dashboard_git_branch: ${dashboard_git_branch}" )
    file ( GLOB PY_EGG "${CTEST_DASHBOARD_ROOT}/SimpleITK-build/SimpleITK-build/Wrapping/dist/*.egg" )
    file ( GLOB ZIPS "${CTEST_DASHBOARD_ROOT}/SimpleITK-build/SimpleITK-build/Wrapping/dist/*.zip" )
    set ( packages ${PY_EGG} ${ZIPS} )
    foreach( f ${packages} )
      get_filename_component( d "${f}" PATH )
      get_filename_component( f "${f}" NAME )
      message( "EXECUTING: \"${SCP_EXECUTABLE}\" -p \"${f}\" \"blowek1@erie.nlm.nih.gov:/Users/blowek1/Sites/SimpleITKPackages\"")
      execute_process ( COMMAND "${SCP_EXECUTABLE}" -p "${f}" "blowek1@erie.nlm.nih.gov:/Users/blowek1/Sites/SimpleITKPackages"
      WORKING_DIRECTORY "${d}"
      RESULT_VARIABLE _r
      OUTPUT_VARIABLE _o
      ERROR_VARIABLE _e )

      message("results: ${_r}")
      message("output: ${_o}")
      message("error: ${_e}")
    endforeach()

  else()
    message( "Build failure, not uploading!" )
  endif()
endmacro()
