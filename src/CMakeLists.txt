
if(APPLE)
	
elseif(UNIX)
   
elseif(WIN32)
	# Enable CUDA
	find_package(CUDA REQUIRED)
	set(CUDA_SEPARABLE_COMPILATION ON)
	set(CUDA_PROPAGATE_HOST_FLAGS OFF)

	# Include directories and link libraries for GPU
	include_directories(${CUDA_INCLUDE_DIRS})
	link_libraries(${CUDA_LIBRARIES})

	# Define preprocessor macros for CUDA
	add_definitions(-DGGML_USE_CUDA)
endif()


add_executable(chat chat.cpp header.h utils.h parse_json.h ../phoenix/llmodel.h)


if(APPLE)

	add_dependencies(chat ggml-metal)

	target_link_libraries(chat PRIVATE  llmodel 
		llamamodel-mainline-cpu
        llamamodel-mainline-cpu-avxonly
        #gptj-cpu
        #gptj-cpu-avxonly
		llamamodel-mainline-metal
	)
elseif(UNIX)
   
elseif(WIN32)

	target_link_libraries(chat PRIVATE  llmodel 
		llama-mainline-kompute
		llama-mainline-kompute-avxonly
		llamamodel-mainline-kompute
		llamamodel-mainline-kompute-avxonly

		llama-mainline-cuda 
		llamamodel-mainline-cuda
		llama-mainline-cuda-avxonly
		llamamodel-mainline-kompute-avxonly
		${CUDA_LIBRARIES} 
	)
	
	# Set CUDA architecture (optional, adjust according to your GPU)
	set_target_properties(chat PROPERTIES CUDA_ARCHITECTURES "52;60;61;70;75;80;86")

	# Set CUDA runtime library (static or shared)
	set_target_properties(chat PROPERTIES CUDA_RUNTIME_LIBRARY Static)
endif()
