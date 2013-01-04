
if ( ${dashboard_git_branch} EQUAL "master" OR
    ${dashboard_git_branch} EQUAL "release" )

  # set cmake flag to remove git hash for name
  set( SimpleITK_BUILD_DISTRIBUTE 1 )
endif()


macro ( dashboard_hook_end )
  message( "build_number_errors: ${build_number_errors}" )
  if ( ${build_number_errors} EQUAL "0" )
    message ( "dashboard_git_branch: ${dashboard_git_branch}" )
    file ( GLOB PY_EGG "${CTEST_DASHBOARD_ROOT}/SimpleITK-build/SimpleITK-build/Wrapping/dist/*.egg" )
    set ( packages ${PY_EGG} )
    foreach( f ${packages} )
      message( "UPLOADING: ${f}" )
      execute_process ( COMMAND scp "${f}" "blowek1@erie.nlm.nih.gov:/Users/blowek1/Sites/SimpleITKPackages" )
    endforeach()

  else()
    message( "Build failure, not uploading!" )
  endif()
endmacro()
