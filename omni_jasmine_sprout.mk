
# Release name
PRODUCT_RELEASE_NAME := jasmine_sprout

# Inherit some common Omni stuff.
$(call inherit-product, build/target/product/embedded.mk)
$(call inherit-product, vendor/pb/config/common.mk)

# Device identifier. This must come after all inclusions
PRODUCT_DEVICE := jasmine_sprout
PRODUCT_NAME := omni_jasmine_sprout
PRODUCT_BRAND := xiaomi
PRODUCT_MODEL := Mi A2
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=jasmine_sprout \
    BUILD_PRODUCT=jasmine_sprout \
    TARGET_DEVICE=jasmine_sprout

# HACK: Set vendor patch level
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.build.security_patch=2099-12-31

# A/B updater
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    system \
    vendor

PRODUCT_PACKAGES += \
    bootctrl.sdm660

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier

PRODUCT_STATIC_BOOT_CONTROL_HAL := \
    bootctrl.sdm660 \
    libgptutils \
    libz \
    libcutils

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service \
