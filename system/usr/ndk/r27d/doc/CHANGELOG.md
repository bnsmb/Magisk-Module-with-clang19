# Changelog

Report issues to [GitHub].

For Android Studio issues, go to https://b.android.com and file a bug using the
Android Studio component, not the NDK component.

If you're a build system maintainer that needs to use the tools in the NDK
directly, see the [build system maintainers guide].

[GitHub]: https://github.com/android/ndk/issues
[build system maintainers guide]: https://android.googlesource.com/platform/ndk/+/master/docs/BuildSystemMaintainers.md

## Announcements

* Android V will allow OEMs to ship arm64-v8a devices with 16KiB page sizes.
  Devices that use this configuration will not be able to run existing apps that
  use native code. To be compatible with these devices, applications will need
  to rebuild all their native code to be 16KiB aligned, and rewrite any code
  which assumes a specific page size. ndk-build and CMake have options to enable
  this mode (see note about `APP_SUPPORT_FLEXIBLE_PAGE_SIZES` and
  `ANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES` below). A future version of the NDK will
  enable this mode by default. If you're using or maintaining a third-party
  build system, consult the [build system maintainers guide] for instructions.

  See [Support 16 KB page sizes] for more information.

[Support 16 KB page sizes]: https://developer.android.com/guide/practices/page-sizes

## r27d

* Updated LLVM to clang-r522817d. See `clang_source_info.md` in the toolchain
  directory for version information.
  * [Issue 2144]: Fixed issue where `lldb.sh` did not work when installed to a
    path which contained spaces.
* [Issue 2143]: Fixed lldb.sh not finding libpython on macOS.

[Issue 2143]: https://github.com/android/ndk/issues/2143
[Issue 2144]: https://github.com/android/ndk/issues/2144

## r27c

* Updated LLVM to clang-r522817c. See `clang_source_info.md` in the toolchain
  directory for version information.
  * [Issue 2040]: Further fixes for miscompiles of indirect gotos.
  * [Issue 2064]: Fix HWAsan miscompilation.
  * [Issue 2070]: Fix crash in instantiation of function definitions.
  * [Issue 2084]: Fix for incorrect compiler error on overloaded member
    functions with ref-qualifiers.

[Issue 2040]: https://github.com/android/ndk/issues/2040
[Issue 2064]: https://github.com/android/ndk/issues/2064
[Issue 2070]: https://github.com/android/ndk/issues/2070
[Issue 2084]: https://github.com/android/ndk/issues/2084

## r27b

* Updated LLVM to clang-r522817b. See `clang_source_info.md` in the toolchain
  directory for version information.
  * [Issue 2040]: Fixed miscompile with indirect gotos.
  * [Issue 2054]: Fixed crash in x86 fp16 instruction selection.
  * [Issue 2059]: Fixed infinite loop in aarch64 vector instruction selection.
* [Issue 2032]: Fixed compatibility issues with projects that used a very old
  `cmake_minimum_required` version ("Policy CMP0057 is not set: Support new
  IN_LIST if() operator").
* [Issue 2039]: Fixed `LOCAL_STRIP_MODE` not being reset by
  `include $(CLEAR_VARS)`.
* [Issue 2049]: Restored metadata used by CMake in non-toolchain-file use cases
  that used `CMAKE_SYSTEM_PROCESSOR` instead of `CMAKE_ANDROID_ARCH_ABI`. If you
  ran into this problem, you should switch to using `CMAKE_ANDROID_ARCH_ABI`
  because that's what [CMake's docs] say to use. Better still, use the NDK's
  [toolchain file].

[Issue 2032]: https://github.com/android/ndk/issues/2032
[Issue 2039]: https://github.com/android/ndk/issues/2039
[Issue 2040]: https://github.com/android/ndk/issues/2040
[Issue 2049]: https://github.com/android/ndk/issues/2049
[Issue 2054]: https://github.com/android/ndk/issues/2054
[Issue 2059]: https://github.com/android/ndk/issues/2059
[CMake's docs]: https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-android-with-the-ndk
[toolchain file]: https://developer.android.com/ndk/guides/cmake

## Changes

* Updated LLVM to clang-r522817. See `clang_source_info.md` in the toolchain
  directory for version information.
  * [Issue 1728]: Clang now emits an error for invalid Android target versions.
  * [Issue 1853]: `clang-scan-deps` is now included.
  * [Issue 1911]: Fixed inconsistent `std::regex_replace` results.
  * [Issue 1947]: Improved support for AArch64 function multi-versioning in clang.
  * [Issue 1963]: Fixed undefined behavior in `std::unexpected::has_value()`.
  * [Issue 1988]: Added aarch64 support for `preserve_all` calling convention.
  * [Issue 2007]: Fixed crash in class template argument deduction caused by
    self-referential friend declaration.
  * [Issue 2010]: Removed superfluous libraries to reduce disk use.
  * [Issue 2012]: Fixed front end crash when using concepts and modules.
  * [Issue 2013]: Fixed false positive ODR violation in global module fragments.
  * [Issue 2023]: Fixed Clang crashes related to lambda captures in unevaluated
    contexts.
  * [Issue 2024]: Removed invalid `__attribute__((__const__))` from `gettid`.
* A RISC-V sysroot (AKA riscv64, or rv64) has been added. It is **not**
  supported. It is present to aid bringup for OS vendors, but it's not yet a
  supported Android ABI. It will not be built by default.
* [Issue 1856]: Target-prefixed cmd wrappers for clang should now behave
  appropriately when the first argument includes quotes. **You probably do not
  need to use those wrappers.** In most cases where you would use
  `aarch64-linux-android21-clang`, you can instead use `clang -target
  aarch64-linux-android21`, e.g. `CC="clang -target aarch64-linux-android21"
  ./configure`. The wrappers are only needed when working with systems that do
  not properly handle a `CC` that includes arguments.
* [Issue 1898]: ndk-stack now tolerates 0x prefixed addresses.
* [Issue 1921]: `ANDROID_USE_LEGACY_TOOLCHAIN_FILE` value is now preserved
  during try-compile steps when `ON`.
* [Issue 1974]: Unintentionally shipped Vulkan headers have been removed from
  `sources/third_party/vulkan`. The standard Vulkan headers are included in the
  Android sysroot, which Clang will find automatically.
* [Issue 1993]: ndk-stack now tolerates invalid UTF-8 characters in the trace.
* [Issue 1994]: Fixed ndk-gdb/ndk-lldb to use the correct path for
  make and other tools.
* Added `APP_SUPPORT_FLEXIBLE_PAGE_SIZES` for ndk-build and
  `ANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES` for CMake. Set to
  `APP_SUPPORT_FLEXIBLE_PAGE_SIZES := true` in your `Application.mk` or pass
  `-DANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES=ON` to CMake (via
  `android.defaultConfig.externalNativeBuild.cmake.arguments` if you're using
  the Android Gradle Plugin) to build your code to be compatible with devices
  that use a 16KiB page size. Third-party build system users and maintainers
  should consult the [build system maintainers guide].
* Symlinks are now properly preserved in the macOS App Bundle. The NDK installed
  via that method is now the same size as the one installed via the SDK manager.
* The unsupported libclang, libclang-cpp, libLLVM, and libLTO libraries were
  removed to save space.

[Issue 1728]: https://github.com/android/ndk/issues/1728
[Issue 1853]: https://github.com/android/ndk/issues/1853
[Issue 1856]: https://github.com/android/ndk/issues/1856
[Issue 1898]: https://github.com/android/ndk/issues/1898
[Issue 1911]: https://github.com/android/ndk/issues/1911
[Issue 1921]: https://github.com/android/ndk/issues/1921
[Issue 1947]: https://github.com/android/ndk/issues/1947
[Issue 1963]: https://github.com/android/ndk/issues/1963
[Issue 1974]: https://github.com/android/ndk/issues/1974
[Issue 1988]: https://github.com/android/ndk/issues/1988
[Issue 1993]: https://github.com/android/ndk/issues/1993
[Issue 1994]: https://github.com/android/ndk/issues/1994
[Issue 2007]: https://github.com/android/ndk/issues/2007
[Issue 2010]: https://github.com/android/ndk/issues/2010
[Issue 2012]: https://github.com/android/ndk/issues/2012
[Issue 2013]: https://github.com/android/ndk/issues/2013
[Issue 2023]: https://github.com/android/ndk/issues/2023
[Issue 2024]: https://github.com/android/ndk/issues/2024
