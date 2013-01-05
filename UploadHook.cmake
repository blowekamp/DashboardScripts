
if ( ${dashboard_git_branch} EQUAL "master" OR
    ${dashboard_git_branch} EQUAL "release" )

  # set cmake flag to remove git hash for name
  set( dashboard_cache "${dashboard_cache}
  SimpleITK_BUILD_DISTRIBUTE:BOOL=ON" )
endif()


macro ( dashboard_hook_end )
  message( "build_number_errors: ${build_number_errors}" )
  if ( ${build_number_errors} EQUAL "0" )
    message ( "dashboard_git_branch: ${dashboard_git_branch}" )
    file ( GLOB PY_EGG "${CTEST_DASHBOARD_ROOT}/SimpleITK-build/SimpleITK-build/Wrapping/dist/*.egg" )
    set ( packages ${PY_EGG} )
    foreach( f ${packages} )
      get_filename_component( d "${f}" PATH )
      get_filename_component( f "${f}" NAME )
      message( "UPLOADING: ${d}/${f}" )
      execute_process ( COMMAND scp "${f}" "blowek1@erie.nlm.nih.gov:/Users/blowek1/Sites/SimpleITKPackages" 
      WORKING_DIRECTORY "${d}")
    endforeach()

  else()
    message( "Build failure, not uploading!" )
  endif()
endmacro()
