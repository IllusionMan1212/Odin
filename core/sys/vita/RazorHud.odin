#+build vita
package vita

import "core:c"

foreign import razorhud "system:SceRazorHud_stub"

/** Enumeration for the gpu live metrics groups */
SceRazorGpuLiveMetricsGroup :: enum c.int {
	PBUFFER_USAGE,
	OVERVIEW_1,
	OVERVIEW_2,
	OVERVIEW_3
}

/** Enumeration for the gpu live results entry types */
SceRazorLiveTraceMetricEntryType :: enum c.int {
	JOB,
	PARAMETER_BUFFER,
	FRAME
}

/** Enumeration for the gpu live results job types */
SceRazorLiveTraceMetricJobType :: enum c.int {
	FIRMWARE,
	VERTEX1,
	FRAGMENT1,
	VERTEX2,
	FRAGMENT2,
	VERTEX3,
	FRAGMENT3,
	VERTEX0,
	FRAGMENT0
}

SceRazorGpuLiveResultInfo :: struct {
  result_data: rawptr,      //!< Pointer to the raw data results entries.
	entry_count: SceSize,    //!< Number of elements stored in the results buffer
	overflow_count: SceSize, //|< Number of results elements not included in the results buffer due to buffer overflow
	buffer_size: SceSize,    //!< Size of the results buffer in bytes
	start_time: c.uint64_t,    //!< Start time of the results collection in microseconds
	end_time: c.uint64_t,      //!< End time of the results collection in microseconds
	metric_group: c.uint32_t,  //!< Metrics group used for the results
	reserved: c.int,           //!< Reserved data
}

SceRazorGpuLiveEntryHeader :: struct {
  entry_size: c.uint16_t,  //!< Entry size in bytes
	entry_type: c.uint16_t,  //!< Entry type (One of ::SceRazorLiveTraceMetricEntryType)
	reserved: c.int,         //!< Reserved data
}
#assert(size_of(SceRazorGpuLiveEntryHeader) == 8)

SceRazorGpuLiveEntryJobVertexValues1 :: struct {
  usse_vertex_processing_percent: c.float, //!< USSE vertex processing percentage
}
#assert(size_of(SceRazorGpuLiveEntryJobVertexValues1) == 4)

SceRazorGpuLiveEntryJobFragmentValues1 :: struct {
  usse_fragment_processing_percent: c.float,         //!< USSE fragment processing percentage
	usse_dependent_texture_reads_percent: c.float,     //!< USSE dependant texture reads requests percentage
	usse_non_dependent_texture_reads_percent: c.float, //!< USSE non-dependant texture reads requests percentage
}
#assert(size_of(SceRazorGpuLiveEntryJobFragmentValues1) == 0xC)

SceRazorGpuLiveEntryJobVertexValues2 :: struct {
  vdm_primitives_input_num: c.uint32_t,  //!< VDM input primitives  number
	mte_primitives_output_num: c.uint32_t, //!< MTE output primitives number
	vdm_vertices_input_num: c.uint32_t,    //!< VDM input vertices number
	mte_vertices_output_num: c.uint32_t,   //!< MTE output vertices number
}
#assert(size_of(SceRazorGpuLiveEntryJobVertexValues2) == 0x10)

SceRazorGpuLiveEntryJobFragmentValues2 :: struct {
  rasterized_pixels_before_hsr_num: c.uint32_t, //!< Number of rasterized pixels before Hidden Surface Removal
	rasterized_output_pixels_num: c.uint32_t,     //!< Number of rasterized pixels
	rasterized_output_samples_num: c.uint32_t,    //!< Number of rasterized samples
}
#assert(size_of(SceRazorGpuLiveEntryJobFragmentValues2) == 0xC)

SceRazorGpuLiveEntryJobVertexValues3 :: struct {
  tiling_accelerated_mem_writes: c.uint32_t, //!< Amount of tiling accelerated memory writes in bytes
}
#assert(size_of(SceRazorGpuLiveEntryJobVertexValues3) == 4)

SceRazorGpuLiveEntryJobFragmentValues3 :: struct {
  isp_parameter_fetches_mem_reads: c.uint32_t, //!< Amount of ISP parameter fetches memory reads in bytes
}
#assert(size_of(SceRazorGpuLiveEntryJobFragmentValues3) == 4)

SceRazorGpuLiveEntryJobValues :: struct {
  vertex_values_type1: SceRazorGpuLiveEntryJobVertexValues1,     //!< Values for a job of SCE_RAZOR_LIVE_TRACE_METRIC_JOB_TYPE_VERTEX1 type
	fragment_values_type1: SceRazorGpuLiveEntryJobFragmentValues1, //!< Values for a job of SCE_RAZOR_LIVE_TRACE_METRIC_JOB_TYPE_FRAGMENT1 type
	vertex_values_type2: SceRazorGpuLiveEntryJobVertexValues2,     //!< Values for a job of SCE_RAZOR_LIVE_TRACE_METRIC_JOB_TYPE_VERTEX2 type
	fragment_values_type2: SceRazorGpuLiveEntryJobFragmentValues2, //!< Values for a job of SCE_RAZOR_LIVE_TRACE_METRIC_JOB_TYPE_FRAGMENT2 type
	vertex_values_type3: SceRazorGpuLiveEntryJobVertexValues3,     //!< Values for a job of SCE_RAZOR_LIVE_TRACE_METRIC_JOB_TYPE_VERTEX3 type
	fragment_values_type3: SceRazorGpuLiveEntryJobFragmentValues3, //!< Values for a job of SCE_RAZOR_LIVE_TRACE_METRIC_JOB_TYPE_FRAGMENT3 type
	reserved: [8]c.int,                                              //!< Reserved data
}
#assert(size_of(SceRazorGpuLiveEntryJobValues) == 0x54)

SceRazorGpuLiveEntryJob :: struct {
  header: SceRazorGpuLiveEntryHeader,        //!< Distinguishing header for the entry
	start_time: c.uint64_t,                      //!< Start time of the entry in microseconds
	end_time: c.uint64_t,                        //!< End time of the entry in microseconds
	type: c.uint8_t,                             //!< The type of the job (One of ::SceRazorLiveTraceMetricJobType)
	core: c.int8_t,                              //!< Core number on which the job got executed
	scene_index: c.uint16_t,                     //!< Index of the scene in which the job got executed
	frame_number: c.uint32_t,                    //!< Frame number in which the job got executed
	job_values: SceRazorGpuLiveEntryJobValues, //!< Reported values by the job
	process_id: c.uint32_t,                      //!< ID of the process which executed the job
	unk: c.int,                                  //!< Unknown data
}

SceRazorGpuLiveEntryParameterBuffer :: struct {
  header: SceRazorGpuLiveEntryHeader,       //!< Distinguishing header for the entry
	peak_usage_timestamp: c.uint64_t,           //!< Time of param buffer peak usage in microseconds
	peak_usage_value: c.uint32_t,               //!< Memory peak usage of the param buffer in bytes
	partial_render: c.uint8_t,                  //!< Flag indicating wether a partial render occurred or not
	vertex_job_paused: c.uint8_t,               //!< Flag indicating wether a vertex job had been paused or not
}
#assert(size_of(SceRazorGpuLiveEntryParameterBuffer) == 0x18)

SceRazorGpuLiveEntryFrame :: struct {
  header: SceRazorGpuLiveEntryHeader,       //!< Distinguishing header for the entry
	start_time: c.uint64_t,                     //!< Start time of the entry in microseconds
	duration: c.uint32_t,                       //!< Duration of the frame in microseconds
	frame_number: c.uint32_t,                   //!< Number of the frame
	gpu_activity_duration_time: c.uint32_t,     //!< Duration of GPU activity for the frame in microseconds
	reserved: c.int,                            //!< Reserved data
}
#assert(size_of(SceRazorGpuLiveEntryFrame) == 0x20)

foreign razorhud {
	/**
	* Sets a metrics group to use for gpu live debugging
	*
	* @param[in] metrics - The metrics group to use (One of ::SceRazorGpuLiveMetricsGroup)
	*
	* @return 0, <0 on error.
	*/
	sceRazorGpuLiveSetMetricsGroup :: proc(metrics: c.uint32_t) -> c.int ---

	/**
	* Sets the buffer in which to store gpu live debugging results for the current frame
	*
	* @param[in] buffer - The buffer to use
	* @param[in] buf_size - The buffer size in bytes
	* @param[out] results - The debugging results of the previous frame
	*
	* @return 0, <0 on error.
	*/
	sceRazorGpuLiveSetBuffer :: proc(buffer: rawptr, buf_size: SceSize, results: ^SceRazorGpuLiveResultInfo) -> c.int ---

	/**
	* Starts gpu live debugging
	*
	* @return 0, <0 on error.
	*/
	sceRazorGpuLiveStart :: proc() -> c.int ---

	/**
	* Stops gpu live debugging
	*
	* @return 0, <0 on error.
	*/
	sceRazorGpuLiveStop :: proc() -> c.int ---
}

