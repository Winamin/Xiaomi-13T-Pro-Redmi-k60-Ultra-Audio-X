SKIPUNZIP=0

[ ! "$MODPATH" ] && MODPATH=${0%/*}
DEVICE=$(getprop ro.product.vendor.device)
VERSION=$(getprop ro.build.version.release)
FILE_PATH="/system/vendor/etc/dolby/dax-default.xml"

# 获取设备型号
device_model=$(getprop ro.product.model)

# 定义允许安装的设备型号
allowed_model="23078RKD5C"

# 检查设备型号是否符合要求
if [ "$device_model" != "$allowed_model" ]; then
    ui_print "此模块不支持您的设备型号！停止安装!"
    exit 1
fi

echo "Device model ($DEVICE MODEL) 机型检测正常！"
ui_print ""
ui_print ""

ui_print "本音效模块只适合Redmi K60 Ultra使用，伪机型可能会判断错误！"

key_click() {
    kc=""
    while [ "$kc" = "" ]; do
        kc="$(getevent -qlc 1 | awk '{ print $3 }' | grep 'KEY_')"
        sleep 0.2
    done
}

#参考于skai
audio_prop() {
    ui_print ""
    ui_print ""
    ui_print "           是否加载模块system.prop"
    ui_print "  +不加载prop可避免某些奇怪的bug，开启有利于提升音效+"
    ui_print "               音量↑:是│音量↓:否"
    key_click
    case "$kc" in
        "KEY_VOLUMEUP")
            ui_print "           ✓"
            ui_print ""
            ui_print ""
            ui_print "- 加载成功！"
            sleep 0.3
            ;;
        "KEY_VOLUMEDOWN")
            ui_print "                       ✓"
            ui_print ""
            ui_print ""
            ui_print "- 已取消加载!"
            rm -rf $MODPATH/system.prop
            rm -rf $MODPATH/system/vendor/etc/audio_spatial_db_reduce.xml
            sleep 0.3
            ;;
    esac
}

audio_hiaudiox() {
    ui_print ""
    ui_print ""
    ui_print "                     是否添加HiAudioX通路"
    ui_print "     +提供高质量DIRECT音频输出，但会导致某些不可预测的场景爆音+"
    ui_print "                   音量↑:开启│音量↓:关闭"
    key_click
    case "$kc" in
        "KEY_VOLUMEUP")
            ui_print "            ✓"
            ui_print ""
            ui_print ""
            ui_print "- 已添加HiAudioX通路！"
            rm -rf $MODPATH/system/vendor/etc/audio_policy.conf
            rm -rf $MODPATH/system/vendor/etc/audio_policy_configuration.xml
            rm -rf $MODPATH/system/vendor/etc/audio_policy_configuration_a2dp_offload_disabled.xml
            rm -rf $MODPATH/system/vendor/etc/audio_policy_configuration_a2dp_offload_disabled_cg_enabled.xml
            rm -rf $MODPATH/system/vendor/etc/audio_policy_configuration_a2dp_offload_enable_cg_enable.xml
            rm -rf $MODPATH/system/vendor/etc/audio_policy_configuration_bluetooth_legacy_hal.xml
            rm -rf $MODPATH/system/system_ext/etc/audio_policy_configuration.xml
            rm -rf $MODPATH/system/system_ext/etc/audio_policy_configuration_bluetooth_legacy_hal.xml
            mv $MODPATH/system/vendor/etc/Taudio_policy.conf $MODPATH/system/vendor/etc/audio_policy.conf
            mv $MODPATH/system/vendor/etc/Taudio_policy_configuration.xml $MODPATH/system/vendor/etc/audio_policy_configuration.xml
            mv $MODPATH/system/vendor/etc/Taudio_policy_configuration_a2dp_offload_disabled.xml $MODPATH/system/vendor/etc/audio_policy_configuration_a2dp_offload_disabled.xml
            mv $MODPATH/system/vendor/etc/Taudio_policy_configuration_a2dp_offload_disabled_cg_enabled.xml $MODPATH/system/vendor/etc/audio_policy_configuration_a2dp_offload_disabled_cg_enabled.xml
            mv $MODPATH/system/vendor/etc/Taudio_policy_configuration_a2dp_offload_enable_cg_enable.xml $MODPATH/system/vendor/etc/audio_policy_configuration_a2dp_offload_enable_cg_enable.xml
            mv $MODPATH/system/vendor/etc/Taudio_policy_configuration_bluetooth_legacy_hal.xml $MODPATH/system/vendor/etc/audio_policy_configuration_bluetooth_legacy_hal.xml
            mv $MODPATH/system/system_ext/etc/Taudio_policy_configuration.xml $MODPATH/system/system_ext/etc/audio_policy_configuration.xml
            mv $MODPATH/system/system_ext/etc/Taudio_policy_configuration_bluetooth_legacy_hal.xml $MODPATH/system/system_ext/etc/audio_policy_configuration_bluetooth_legacy_hal.xml
            sleep 0.3
            ;;
        "KEY_VOLUMEDOWN")
            ui_print "                               ✓"
            ui_print ""
            ui_print ""
            ui_print "- 已取消添加HiAudioX通路，将使用默认高解析输出!"
            rm -rf $MODPATH/system/vendor/etc/Taudio_policy.conf
            rm -rf $MODPATH/system/vendor/etc/Taudio_policy_configuration.xml
            rm -rf $MODPATH/system/vendor/etc/Taudio_policy_configuration_a2dp_offload_disabled.xml
            rm -rf $MODPATH/system/vendor/etc/Taudio_policy_configuration_a2dp_offload_disabled_cg_enabled.xml
            rm -rf $MODPATH/system/vendor/etc/Taudio_policy_configuration_a2dp_offload_enable_cg_enable.xml
            rm -rf $MODPATH/system/vendor/etc/Taudio_policy_configuration_bluetooth_legacy_hal.xml
            rm -rf $MODPATH/system/system_ext/etc/Taudio_policy_configuration.xml
            rm -rf $MODPATH/system/system_ext/etc/Taudio_policy_configuration_bluetooth_legacy_hal.xml
            sleep 0.3
            ;;
    esac
}

audio_perfer() {
    ui_print ""
    ui_print ""
    ui_print "                 是否启用纯Dolby Atmos模式"
    ui_print "  +不加载音质音效，音质更加清脆，但会导致无法关闭杜比和无法使用音质音效+"
    ui_print "                   音量↑:启用│音量↓:禁用"
    key_click
    case "$kc" in
        "KEY_VOLUMEUP")
            ui_print "                ✓"
            ui_print ""
            ui_print ""
            ui_print "- 已启用纯Dolby Atmos模式！"
            sleep 0.3
            ;;
        "KEY_VOLUMEDOWN")
            ui_print "                               ✓"
            ui_print ""
            ui_print ""
            ui_print "- 已禁用纯Dolby Atmos模式!"
            rm -rf $MODPATH/system/vendor/etc/audio_effects.xml
            sleep 0.3
            ;;
    esac
}

audio_misound() {
    ui_print ""
    ui_print ""
    ui_print "           是否替换为MIUI音质音效配置文件"
    ui_print "          +开启有利于优化平衡，优化音效♬ +"
    ui_print "                 音量↑:是│音量↓:否"
    key_click
    case "$kc" in
        "KEY_VOLUMEUP")
            ui_print "               ✓"
            ui_print ""
            ui_print ""
            ui_print "- 已替换!"
            sleep 0.3
            ;;
        "KEY_VOLUMEDOWN")
            ui_print "                          ✓"
            ui_print ""
            ui_print ""
            ui_print "- 已取消替换!"
            rm -rf $MODPATH/system/vendor/etc/misound_res.bin
            rm -rf $MODPATH/system/vendor/etc/misound_res_headphone.bin
            rm -rf $MODPATH/system/vendor/etc/misound_res_spk.bin
            sleep 0.3
            ;;
    esac
}

dolby_dax() {
    ui_print ""
    ui_print ""
    ui_print "                 请选择你的 Dolby Atmos DAX"
    ui_print "+超重低音：可媲美现在的游戏手机的虚拟低音，可能会增加耗电量+"
    ui_print "+均衡听感：更强的高音量解析力，更好听的高频，极大的动态范围，省电+"
    ui_print "                音量↑:超重低音│音量↓:均衡听感"
    key_click
    case "$kc" in
        "KEY_VOLUMEUP")
            ui_print "               ✓"
            ui_print "- 已选择：超重低音"
            rm -rf $MODPATH/system/vendor/etc/dolby/balance.xml
            mv $MODPATH/system/vendor/etc/dolby/bass.xml $MODPATH/system/vendor/etc/dolby/dax-default.xml
            ui_print ""
            ui_print ""
            ui_print "- Bass Boost！"
            sleep 0.4
            ;;
        "KEY_VOLUMEDOWN")
            ui_print "                              ✓"
            ui_print "- 已选择：均衡听感"
            rm -rf $MODPATH/system/vendor/etc/dolby/bass.xml
            mv $MODPATH/system/vendor/etc/dolby/balance.xml $MODPATH/system/vendor/etc/dolby/dax-default.xml
            ui_print ""
            ui_print ""
            ui_print "- Clear Sound"
            sleep 0.4
            ;;
    esac
}

if [ -f $FILE_PATH ]; then
m_t() {
    ui_print "————————————————————————"
    ui_print "- 当前设备：$DEVICE"
    ui_print "- 当前Android版本：$VERSION"
    ui_print "————————————————————————"
    ui_print ""
    sleep 0.5
    ui_print "————————————————————————"
    ui_print "如果遇到铃声失效bug"
    ui_print "可以尝试用耳机等相关的东西插拔充电口即可解决"
    ui_print "注意！务必打开西米露相关软件的原生录屏选项"
    ui_print "————————————————————————"
    sleep 0.5
    ui_print "正在清理package_cache......"
    sleep 0.5
    ui_print ""
    ui_print "清理完成♬ "
    ui_print ""
    ui_print ""
}
#不存在dax不安装        
else
    ui_print "*************************************"
    ui_print "- 杜比配置文件不存在，已取消安装"
    ui_print "*************************************"
    abort
fi

rm -rf /data/system/package_cache/*

version_check() {
    if [[ $KSU_VER_CODE != "" ]] && [[ $KSU_VER_CODE -lt 11874 || $KSU_KERNEL_VER_CODE -lt 11874 ]]; then
        abort "不支持的KSU版本 (需versionCode >= 11874)"
    elif [[ $KSU_VER_CODE == "" && $MAGISK_VER_CODE != "" && $MAGISK_VER_CODE -lt 26000 ]]; then
		abort "不支持的Magisk版本(需versionCode >= 26000)"
    elif [[ $API -lt 33 ]]; then
        abort "不支持的安卓版本 (需apiVersion >= 33)"
    fi
}

set_permissions() {
	set_perm_recursive $MODPATH 0 0 0755 0644
	set_perm_recursive $MODPATH/system/system_ext/etc 0 0 0755 0644
	set_perm_recursive $MODPATH/system/vendor/etc 0 0 0755 0644 u:object_r:vendor_configs_file:s0
}

set_permissions
version_check
audio_prop
audio_hiaudiox
audio_perfer
audio_misound
dolby_dax
m_t