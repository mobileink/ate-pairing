# CFLAGS = -fPIC -O3 -fomit-frame-pointer -DNDEBUG -msse2 -mfpmath=sse -march=native
# ifeq ($(DBG),on)
# CFLAGS += -O0 -g3 -UNDEBUG
# LDFLAGS += -g3
# endif

CFLAGS_BASE = [
    "-std=c++14 -lstdc++ -fPIC", "-fomit-frame-pointer", "-msse2", "-mfpmath=sse",  "-march=native",
] + select({
    "//:enable_debug" : ["-O0", "-g3"],
    "//conditions:default" : ["-O3", "-g0",
                              "-UDEBUG" # MacOS: bazel adds -DDEBUG by default
    ]
}) + select({
    # if needed, test for 32 bit
    "//conditions:default" : ["-m64"]
})
# + select({
#     "//:vuint_bit_len_1024" : ["-DMIE_ZM_VUINT_BIT_LEN=1024"],
#     "//conditions:default": ["-DMIE_ZM_VUINT_BIT_LEN=576"],
# })

# CFLAGS_WARN=-Wall -Wextra -Wformat=2 -Wcast-qual -Wcast-align -Wwrite-strings -Wfloat-equal -Wpointer-arith #-Wswitch-enum -Wstrict-aliasing=2

CFLAGS_WARN = [
    "-Wall",
    "-Wextra",
    "-Wformat=2",
    "-Wcast-qual",
    "-Wcast-align",
    "-Wwrite-strings",
    "-Wfloat-equal",
    "-Wpointer-arith",
]

CFLAGS = CFLAGS_BASE + CFLAGS_WARN

# CFLAGS_ALWAYS = -D_FILE_OFFSET_BITS=64 -DMIE_ATE_USE_GMP
# ifeq ($(SUPPORT_SNARK),1)
# CFLAGS += -DBN_SUPPORT_SNARK
# endif
# ifneq ($(VUINT_BIT_LEN),)
# CFLAGS += -D"MIE_ZM_VUINT_BIT_LEN=$(VUINT_BIT_LEN)"
# endif

DEFINES = ["_FILE_OFFSET_BITS=64", "MIE_ATE_USE_GMP"]
# ] + select({
#     "@//bzl/config:enable_libgmp" : ["MIE_ATE_USE_GMP"],
#     "//conditions:default": []
DDEBUG = select({
    # clang:  -fdebug-macro
    "//:enable_debug" : ["DEBUG"],
    "//conditions:default": ["NDEBUG"]
})

# forward config: set by clients that depend on ate-pairing
# FIXME: eliminate, make clients set BN_SUPPORT_SNARK
SNARK = select({
    "@//:curve_bn128" : ["BN_SUPPORT_SNARK=1"],
    "@//:curve_alt_bn128" : ["BN_SUPPORT_SNARK=1"],
    "//conditions:default": []
})

LINK_STATIC_ONLY = select({
    "//bzl/host:linux": True,
    "//bzl/host:macos": False,
    "//conditions:default": True
})
