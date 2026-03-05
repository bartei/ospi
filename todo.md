# OSPI - Trixie Upgrade TODO

---

## 5. Stage 2 — Network Tweaks

### 5.1 `stage2/02-net-tweaks/`
- [x] Remove `wpa_supplicant.conf`
- [ ] Verify `raspberrypi-net-mods` is still available in Trixie
- [ ] Review wireless firmware packages for Trixie compatibility

---

## 10. Remaining Items — Not Yet Done

### 10.1 Unstaged changes to review and stage
- [ ] `.github/workflows/release.yml` — Remove `bookworm` branch trigger
- [ ] `stage-base/01-boot-files/files/cmdline.txt` — Add `resize` kernel param

### 10.2 `kivy.conf` cleanup
- [ ] Replace `DEPLOY_ZIP='1'` with `DEPLOY_COMPRESSION='zip'` (DEPLOY_ZIP is deprecated but functionally equivalent)

### 10.4 Verification needed
- [ ] Verify `raspberrypi-net-mods` is available in Trixie repos
- [ ] Verify wireless firmware packages for Trixie compatibility
- [ ] Test full build end-to-end

---

## Priority Order

1. **High** (may break the build):
   - Item 10.4 — package availability verification

2. **Medium** (recommended):
   - Item 10.1 — stage unstaged changes
   - Item 10.2 — kivy.conf deprecation cleanup
   - Item 10.3 — config.txt review

3. **Low** (nice to have):
   - Full end-to-end build test