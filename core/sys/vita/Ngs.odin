#+build vita
package vita

import "core:c"

foreign import ngs "sceNgs_stub"

SceNgsHRack :: SceUInt32
#assert(size_of(SceNgsHRack) == 4)
SceNgsHPatch :: SceUInt32
#assert(size_of(SceNgsHPatch) == 4)
SceNgsHSynSystem :: SceUInt32 
#assert(size_of(SceNgsHSynSystem) == 4)
SceNgsHVoice :: SceUInt32
#assert(size_of(SceNgsHVoice) == 4)
SulphaNgsModuleQueryType :: SceUInt32
#assert(size_of(SulphaNgsModuleQueryType) == 4)
SceNgsModuleID :: SceUInt32
#assert(size_of(SceNgsModuleID) == 4)
SceNgsSulphaUpdateCallback :: rawptr

SceNgsCallbackFunc :: #type ^proc "c" (#by_ptr callback_info: SceNgsCallbackInfo)

SceNgsRackReleaseCallbackFunc :: SceNgsCallbackFunc
SceNgsModuleCallbackFunc :: SceNgsCallbackFunc
SceNgsParamsErrorCallbackFunc :: SceNgsCallbackFunc

// missing structs
SceNgsVoicePreset :: struct{}
SceNgsBufferInfo :: struct{}
SceNgsSystemInitParams :: struct{}
SceNgsCallbackListInfo :: struct{}
SulphaNgsModuleQuery :: struct{}
SulphaNgsRegistration :: struct{}
SceNgsRackDescription :: struct{}
SceNgsPatchSetupInfo :: struct{}
SceNgsParamsDescriptor :: struct{}
SceNgsCallbackInfo :: struct{}
SceNgsVoiceDefinition :: struct{}

foreign ngs {
  sceNgsModuleCheckParamsInRangeInternal :: proc(handle: SceNgsHVoice, module_id: SceNgsModuleID, #by_ptr descriptor: SceNgsParamsDescriptor, size: SceUInt32) -> SceInt32 ---
  sceNgsModuleGetNumPresetsInternal :: proc(handle: SceNgsHSynSystem, module_id: SceNgsModuleID, num_presets: ^SceUInt32) -> SceInt32 ---
  sceNgsModuleGetPresetInternal :: proc(handle: SceNgsHSynSystem, module_id: SceNgsModuleID, preset_index: SceUInt32, info: ^SceNgsBufferInfo) -> SceInt32 ---
  sceNgsPatchCreateRoutingInternal :: proc(#by_ptr info: SceNgsPatchSetupInfo, handle: ^SceNgsHPatch) -> SceInt32 ---
  sceNgsPatchRemoveRoutingInternal :: proc(handle: SceNgsHPatch) -> SceInt32 ---
  sceNgsRackGetRequiredMemorySizeInternal :: proc(handle: SceNgsHSynSystem, #by_ptr rack_description: SceNgsRackDescription, user_size: ^SceUInt32) -> SceInt32 ---
  sceNgsRackGetVoiceHandleInternal :: proc(rack_handle: SceNgsHRack, index: SceUInt32, voice_handle: ^SceNgsHVoice) -> SceInt32 ---
  sceNgsRackInitInternal :: proc(system_handle: SceNgsHSynSystem, rack_buffer: ^SceNgsBufferInfo, #by_ptr rack_description: SceNgsRackDescription, rack_handle: ^SceNgsHRack) -> SceInt32 ---
  sceNgsRackReleaseInternal :: proc(handle: SceNgsHRack, callback: SceNgsRackReleaseCallbackFunc) -> SceInt32 ---
  sceNgsRackSetParamErrorCallbackInternal :: proc(rack_handle: SceNgsHRack, callback: SceNgsParamsErrorCallbackFunc) -> SceInt32 ---
  sceNgsSulphaGetInfoInternal :: proc(#by_ptr obj_reg: SulphaNgsRegistration, info: ^SceNgsBufferInfo) -> SceInt32 ---
  sceNgsSulphaGetModuleListInternal :: proc(module_ids: ^SceUInt32, in_array_count: SceUInt32, count: ^SceUInt32) -> SceInt32 ---
  sceNgsSulphaGetSynthUpdateCallbackInternal :: proc(handle: SceNgsHSynSystem, update_callback: ^SceNgsSulphaUpdateCallback, info: ^SceNgsBufferInfo) -> SceInt32 ---
  sceNgsSulphaQueryModuleInternal :: proc(type: SulphaNgsModuleQueryType, debug: ^SulphaNgsModuleQuery) -> SceInt32 ---
  sceNgsSulphaSetSynthUpdateCallbackInternal :: proc(handle: SceNgsHSynSystem, update_callback: SceNgsSulphaUpdateCallback, info: ^SceNgsBufferInfo) -> SceInt32 ---
  sceNgsSystemGetCallbackListInternal :: proc(handle: SceNgsHSynSystem, array: ^[^]SceNgsCallbackListInfo, array_size: ^SceUInt32) -> SceInt32 ---
  sceNgsSystemGetRequiredMemorySizeInternal :: proc(#by_ptr params: SceNgsSystemInitParams, size: ^SceUInt32) -> SceInt32 ---
  sceNgsSystemInitInternal :: proc(buffer_info: ^SceNgsBufferInfo, compiled_sdk_version: SceUInt32, #by_ptr params: SceNgsSystemInitParams, handle: ^SceNgsHSynSystem) -> SceInt32 ---
  sceNgsSystemLockInternal :: proc(handle: SceNgsHSynSystem) -> SceInt32 ---
  sceNgsSystemPullDataInternal :: proc(handle: SceNgsHSynSystem, dirty_flags_a: SceUInt32, dirty_flags_b: SceUInt32) -> SceInt32 ---
  sceNgsSystemPushDataInternal :: proc(handle: SceNgsHSynSystem) -> SceInt32 ---
  sceNgsSystemReleaseInternal :: proc(handle: SceNgsHSynSystem) -> SceInt32 ---
  sceNgsSystemSetFlagsInternal :: proc(handle: SceNgsHSynSystem, system_flags: SceUInt32) -> SceInt32 ---
  sceNgsSystemSetParamErrorCallbackInternal :: proc(handle: SceNgsHSynSystem, callback_id: SceNgsParamsErrorCallbackFunc) -> SceInt32 ---
  sceNgsSystemUnlockInternal :: proc(handle: SceNgsHSynSystem) -> SceInt32 ---
  sceNgsSystemUpdateInternal :: proc(handle: SceNgsHSynSystem) -> SceInt32 ---
  sceNgsVoiceBypassModuleInternal :: proc(handle: SceNgsHVoice, module: SceUInt32, flag: SceUInt32) -> SceInt32 ---
  sceNgsVoiceClearDirtyFlagInternal :: proc(handle: SceNgsHVoice, param_bit_flag: SceUInt32) -> SceInt32 ---
  sceNgsVoiceDefinitionGetPresetInternal :: proc(#by_ptr definition: SceNgsVoiceDefinition, index: SceUInt32, presets: ^^SceNgsVoicePreset) -> SceInt32 ---
  sceNgsVoiceGetModuleBypassInternal :: proc(handle: SceNgsHVoice, module: SceUInt32, flag: ^SceUInt32) -> SceInt32 ---
  sceNgsVoiceGetOutputPatchInternal :: proc(handle: SceNgsHVoice, nOutputIndex: SceInt32, nSubIndex: SceInt32, pPatchHandle: ^SceNgsHPatch) -> SceInt32 ---
  sceNgsVoiceGetParamsOutOfRangeBufferedInternal :: proc(handle: SceNgsHVoice, module: SceUInt32, message_buffer: [^]c.char) -> SceInt32 ---
  sceNgsVoiceInitInternal :: proc(handle: SceNgsHVoice, #by_ptr preset: SceNgsVoicePreset, flags: SceUInt32) -> SceInt32 ---
  sceNgsVoiceKeyOffInternal :: proc(handle: SceNgsHVoice) -> SceInt32 ---
  sceNgsVoiceKillInternal :: proc(handle: SceNgsHVoice) -> SceInt32 ---
  sceNgsVoicePauseInternal :: proc(handle: SceNgsHVoice) -> SceInt32 ---
  sceNgsVoicePlayInternal :: proc(handle: SceNgsHVoice) -> SceInt32 ---
  sceNgsVoiceResumeInternal :: proc(handle: SceNgsHVoice) -> SceInt32 ---
  sceNgsVoiceSetAllBypassesInternal :: proc(handle: SceNgsHVoice, bitflag: SceUInt32) -> SceInt32 ---
  sceNgsVoiceSetFinishedCallbackInternal :: proc(handle: SceNgsHVoice, callback: SceNgsCallbackFunc, userdata: rawptr) -> SceInt32 ---
  sceNgsVoiceSetModuleCallbackInternal :: proc(handle: SceNgsHVoice, module: SceUInt32, callback: SceNgsModuleCallbackFunc, callback_userdata: rawptr) -> SceInt32 ---
  sceNgsVoiceSetPresetInternal :: proc(handle: SceNgsHVoice, #by_ptr preset: SceNgsVoicePreset) -> SceInt32 ---

  sceNgsVoiceDefGetAtrac9VoiceInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetCompressorBussInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetCompressorSideChainBussInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetDelayBussInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetDistortionBussInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetEnvelopeBussInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetEqBussInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetMasterBussInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetMixerBussInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetPauserBussInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetPitchshiftBussInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetReverbBussInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetSasEmuVoiceInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetScreamVoiceAT9Internal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetScreamVoiceInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetSimpleAtrac9VoiceInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetSimpleVoiceInternal :: proc() -> ^SceNgsVoiceDefinition ---
  sceNgsVoiceDefGetTemplate1Internal :: proc() -> ^SceNgsVoiceDefinition ---
}

