#!/bin/bash -e

IMG_FILE="${STAGE_WORK_DIR}/${IMG_FILENAME}${IMG_SUFFIX}.img"

unmount_image "${IMG_FILE}"

rm -f "${IMG_FILE}"

rm -rf "${ROOTFS_DIR}"
mkdir -p "${ROOTFS_DIR}"

BOOT_P_START=8192
BOOT_P_END=$((BOOT_P_START + 200 * 1024 * 1024 / 512))
ROOTRO_P_START=$((BOOT_P_END + 1))
ROOTRO_P_END=$((ROOTRO_P_START + 2 * 1024 * 1024 * 1024 / 512))

ROOTRW_P_START=$((ROOTRO_P_END + 1))
ROOTRW_P_END=$((ROOTRW_P_START + 1 * 1024 * 1024 * 1024 / 512))

echo "Boot Start Sector: ${BOOT_P_START}"
echo "Boot End Sector: ${BOOT_P_END}"
echo "Root RO Start Sector: ${ROOTRO_P_START}"
echo "Root RO End Sector: ${ROOTRO_P_END}"
echo "Root RW Start Sector: ${ROOTRW_P_START}"
echo "Root RW End Sector: ${ROOTRW_P_END}"

truncate -s "$(((ROOTRW_P_END + 1) * 512))" "${IMG_FILE}"
fdisk -H 255 -S 63 "${IMG_FILE}" <<EOF
o
n
p
1
${BOOT_P_START}
${BOOT_P_END}
p
t
c

n
p
2
${ROOTRO_P_START}
${ROOTRO_P_END}

n
p
3
${ROOTRW_P_START}
${ROOTRW_P_END}

p
w
EOF


PARTED_OUT=$(parted -sm "${IMG_FILE}" unit b print)
BOOT_OFFSET=$(echo "$PARTED_OUT" | grep -e '^1:' | cut -d':' -f 2 | tr -d B)
BOOT_LENGTH=$(echo "$PARTED_OUT" | grep -e '^1:' | cut -d':' -f 4 | tr -d B)

ROOT_RO_OFFSET=$(echo "$PARTED_OUT" | grep -e '^2:' | cut -d':' -f 2 | tr -d B)
ROOT_RO_LENGTH=$(echo "$PARTED_OUT" | grep -e '^2:' | cut -d':' -f 4 | tr -d B)

ROOT_RW_OFFSET=$(echo "$PARTED_OUT" | grep -e '^3:' | cut -d':' -f 2 | tr -d B)
ROOT_RW_LENGTH=$(echo "$PARTED_OUT" | grep -e '^3:' | cut -d':' -f 4 | tr -d B)

BOOT_DEV=$(losetup --show -f -o "${BOOT_OFFSET}" --sizelimit "${BOOT_LENGTH}" "${IMG_FILE}")
ROOT_DEV=$(losetup --show -f -o "${ROOT_RO_OFFSET}" --sizelimit "${ROOT_RO_LENGTH}" "${IMG_FILE}")
ROOT_RW_DEV=$(losetup --show -f -o "${ROOT_RW_OFFSET}" --sizelimit "${ROOT_RW_LENGTH}" "${IMG_FILE}")

echo "/boot: offset $BOOT_OFFSET, length $BOOT_LENGTH"
echo "/:     offset $ROOT_OFFSET, length $ROOT_LENGTH"
echo "/rw:   offset $ROOT_OFFSET, length $ROOT_LENGTH"

ROOT_FEATURES="^huge_file"
for FEATURE in metadata_csum 64bit; do
	if grep -q "$FEATURE" /etc/mke2fs.conf; then
	    ROOT_FEATURES="^$FEATURE,$ROOT_FEATURES"
	fi
done
mkdosfs -n boot -F 32 -v "$BOOT_DEV" > /dev/null
mkfs.ext4 -L rootfs -O "$ROOT_FEATURES" "$ROOT_DEV" > /dev/null
mkfs.ext4 -L rootfs -O "$ROOT_FEATURES" "$ROOT_RW_DEV" > /dev/null

mount -v "$ROOT_DEV" "${ROOTFS_DIR}" -t ext4
mkdir -p "${ROOTFS_DIR}/boot"
# mkdir -p "${ROOTFS_DIR}/mnt/rw"
mount -v "$BOOT_DEV" "${ROOTFS_DIR}/boot" -t vfat
# mount -v "$ROOT_RW_DEV" "${ROOTFS_DIR}/mnt/rw" -t ext4

rsync -aHAXx --exclude /var/cache/apt/archives --exclude /boot "${EXPORT_ROOTFS_DIR}/" "${ROOTFS_DIR}/"
rsync -rtx "${EXPORT_ROOTFS_DIR}/boot/" "${ROOTFS_DIR}/boot/"
