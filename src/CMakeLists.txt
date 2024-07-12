
# Enable CUDA
find_package(CUDA REQUIRED)
set(CUDA_SEPARABLE_COMPILATION ON)
set(CUDA_PROPAGATE_HOST_FLAGS OFF)


# Include directories and link libraries for GPU
include_directories(${CUDA_INCLUDE_DIRS})
link_libraries(${CUDA_LIBRARIES})

# Define preprocessor macros for CUDA
add_definitions(-DGGML_USE_CUDA)



add_executable(chat chat.cpp header.h utils.h parse_json.h ../phoenix/llmodel.h)
target_link_libraries(chat PRIVATE  llmodel llama 
	#llama-mainline-kompute
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

# Enable GPU backend if needed
#if(GGML_USE_VULKAN)
 #   find_package(Vulkan REQUIRED)
  #  target_link_libraries(LLModelExecutable Vulkan::Vulkan)
  #  add_definitions(-DGGML_USE_VULKAN)
#endif()




#llama-mainline-kompute gptj-kompute llama-mainline-kompute-avxonly gptj-kompute-avxonly llama-mainline-cuda llama-mainline-cuda-avxonly
	#		llamamodel-mainline-cuda-avxonly llamamodel-mainline-cuda llamamodel-mainline-kompute-avxonly
