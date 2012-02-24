# doxygen.cmake
#
# a ctest script used to generate and install documentaion for SimpleITK
#
set( CTEST_SITE "victoria.nlm" )
set( CTEST_BUILD_NAME "MacOSX-SimpleITK-doxygen" )
set( CTEST_CMAKE_GENERATOR "Unix Makefiles" )


#
# Set some configuration variables
#
SET ( DOXYGEN_INSTALL_DIRECTORY "blowekamp@erie.nih.nih.gov:/Users/blowek1/Sites/SimpleITK" )

SET ( CTEST_SOURCE_DIRECTORY "$ENV{HOME}/temp/SimpleITK" )
SET ( CTEST_BINARY_DIRECTORY "$ENV{HOME}/temp/SimpleITKBUILD" )
FIND_PROGRAM(CTEST_GIT_COMMAND NAMES git)
#SET ( CTEST_GIT_COMMAND "/usr/local/git/bin/git" )

SET ( GIT_URL "http://itk.org/SimpleITK.git" )
SET ( GIT_TAG "next" )

IF(NOT EXISTS "${CTEST_SOURCE_DIRECTORY}")
  SET ( CTEST_CHECKOUT_COMMAND  "${CTEST_GIT_COMMAND} clone -b ${GIT_TAG} --recursive -- ${GIT_URL} ${CTEST_SOURCE_DIRECTORY}")
ENDIF(NOT EXISTS "${CTEST_SOURCE_DIRECTORY}")
SET ( CTEST_UPDATE_COMMAND "${CTEST_GIT_COMMAND}" )

SET ( CTEST_BUILD_COMMAND "make Documentation" )


SET( CTEST_CMAKE_GENERATOR "Unix Makefiles" )


#
# Prepare a clean binary directory with configuration
#
CTEST_EMPTY_BINARY_DIRECTORY( "${CTEST_BINARY_DIRECTORY}" )
FILE( WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "
      ITK_DIR:PATH=$ENV{HOME}/local/lib/InsightToolkit
      DOXYGEN_DOT_EXECUTABLE:FILEPATH=/usr/local/bin/dot
      DOXYGEN_DOT_PATH:FILEPATH=/usr/local/bin
      DOXYGEN_EXECUTABLE:FILEPATH=/nfs/Users/blowekamp/Applications/Doxygen.app/Contents/Resources/doxygen
      BUILD_DOXYGEN:BOOL=ON
" )


# Send this main script as a note.
list ( APPEND CTEST_NOTES_FILES
  "${CMAKE_CURRENT_LIST_FILE}"
  )

#
# Start the config and generation process
#
CTEST_START( CONTINUOUS )
CTEST_UPDATE( SOURCE "${CTEST_SOURCE_DIRECTORY}" )
CTEST_CONFIGURE( BUILD "${CTEST_BINARY_DIRECTORY}" )
CTEST_BUILD( BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE BUILD_RETURN_VALUE )
CTEST_SUBMIT()


#
# Install the generated doxygen
#
IF( NOT ${BUILD_RETURN_VALUE} )

    EXECUTE_PROCESS( COMMAND rsync -avz  "${CTEST_BINARY_DIRECTORY}/Documentation/html/"  "blowek1@erie.nlm.nih.gov:/Users/blowek1/Sites/SimpleITK" )

ELSE( NOT ${BUILD_RETURN_VALUE} )
      MESSAGE( "Error during doxygen generation!" )
ENDIF( NOT ${BUILD_RETURN_VALUE} )
