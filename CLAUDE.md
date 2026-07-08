# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

**YTMusicUltimate** — a Theos/Logos **iOS tweak** that hooks the YouTube Music app
(`com.google.ios.youtubemusic`) at runtime to unlock premium-style features: ad removal,
background playback, audio/cover downloading, SponsorBlock, custom colours/themes, playback
rate, volume bar, casting, selectable lyrics, tab-bar/navbar customization, forced premium
status. Upstream by ginsu & dayanch96.

It runs on a jailbroken iPhone (or injected into a resigned IPA via Azule). **It cannot be
built or run on this Linux box** — the toolchain is Theos + iOS SDK, target is
`iphone:clang:16.5:13.0`, arch `arm64`. Treat work here as source edits + review, not
build/verify. There is no test suite (it's a device tweak).

Note: this `ytmusic/` folder is an untracked subdirectory of the larger `claude` repo, not
its own git root.

## Build

Requires Theos installed (`$THEOS`). From this directory:

```
make clean package                 # rootful jailbreak (.deb)
make clean package ROOTLESS=1      # rootless jailbreak
make clean package ROOTHIDE=1      # roothide
make clean package SIDELOADING=1   # for injecting into a (decrypted) IPA
```

`INSTALL_TARGET_PROCESSES = YouTubeMusic` — the app is killed on install. The GitHub Actions
"Build and Release" flow (see README) builds a tweaked IPA from a user-supplied **decrypted**
YouTube Music IPA; the workflow file lives upstream, not in this checkout.

## Architecture

**One feature = one Logos file in `Source/`.** Each `*.x` / `*.xm` file `%hook`s a handful of
reverse-engineered YTMusic classes to implement a single feature (e.g. `RemoveAds.x`,
`BackgroundPlayback.x`, `Downloading.x`, `SponsorBlock.x`, `Colours.x`). The Makefile
**auto-globs** `Source/*.x` + every `Source/**/*.m`, so **adding a feature = dropping a new
`.x` in `Source/`** — no Makefile edit. (`Sideloading.x` is the one exception: excluded unless
`SIDELOADING=1`.)

**Settings model — the load-bearing convention.** All feature flags live in a *single*
`NSUserDefaults` dictionary under key `@"YTMUltimate"`; each flag is a boolean sub-key. Every
feature file re-declares its own tiny static helper:

```objc
static BOOL YTMU(NSString *key) {
    NSDictionary *d = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"YTMUltimate"];
    return [d[key] boolValue];
}
```

and gates each hook on `YTMU(@"YTMUltimateIsEnabled") && YTMU(@"<featureKey>")`.
`YTMUltimateIsEnabled` is the global master switch. First-run defaults are seeded in the
`%ctor` of `BackgroundPlayback.x` and in `YTMUltimateSettingsController`. When adding a flag,
follow this pattern (copy the helper, gate the hook) rather than inventing a new storage
mechanism.

**Settings UI is not PreferenceLoader.** `Source/Prefs/*SettingsController.{h,m}` are plain
`UITableViewController`s. `Settings.x` hooks `YTMAvatarAccountView` to inject a
"YTMusicUltimate" button into YTMusic's *own* account menu, which presents
`YTMUltimateSettingsController` (the root; the others are its sub-pages). The Apply/checkmark
button writes the dict — most changes require an app **restart** to take effect.

**Reverse-engineered headers.** `Source/Headers/*.h` are hand-written interfaces for private
YTMusic/YT/ELM/Google classes. To hook a class or ivar not yet declared, add/extend a header
here first.

**Localization.** Use the `LOC(key)` macro (`Source/Headers/Localization.h`) →
`NSBundle.ytmu_defaultBundle`. Strings live in
`layout/Library/Application Support/YTMusicUltimate.bundle/<lang>.lproj/Localizable.strings`
(15 languages). `NSBundle+YTMU.m` resolves the bundle for rootful *and* rootless install
paths — don't hardcode a path.

**Downloading pipeline.** `Downloading.x` hooks the now-playing download badge and hands off
to `FFMpegDownloader.m`, which muxes audio + cover art using the **bundled MobileFFmpeg**
static libs in `Source/Utils/lib/*.a` (headers in `Source/Utils/MobileFFmpeg/`), showing
progress via **MBProgressHUD** (`Source/Utils/MBProgressHUD/`). This is why the Makefile links
`bz2 c++ iconv z` and globs `Source/Utils/lib/*.a` into `OBJ_FILES`. Downloaded media is saved
to Photos.

**Sideloading shim.** `Source/Sideloading.x` (only built with `SIDELOADING=1`) fakes the
keychain access group and SSO plumbing so a resigned IPA runs signed-in without a jailbreak.
Keep it out of jailbreak builds.
