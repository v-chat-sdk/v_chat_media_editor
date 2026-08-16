//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <fc_native_video_thumbnail/fc_native_video_thumbnail_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) fc_native_video_thumbnail_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FcNativeVideoThumbnailPlugin");
  fc_native_video_thumbnail_plugin_register_with_registrar(fc_native_video_thumbnail_registrar);
}
