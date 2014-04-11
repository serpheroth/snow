#-------------------------------------------------
#
# Project created by QtCreator 2014-04-06T18:10:31
#
#-------------------------------------------------

QT       += core gui opengl
DEFINES += GL_GLEXT_PROTOTYPES

DEFINES += PROJECT_PATH=\\\"$$_PRO_FILE_PWD_\\\"

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = snow
TEMPLATE = app

SOURCES += main.cpp\
    ui/mainwindow.cpp \
    viewport/viewport.cpp \
    ui/viewpanel.cpp \
    sim/particle.cpp \
    ui/userinput.cpp \
    geometry/mesh.cpp \
    io/objparser.cpp \
    scene/scene.cpp \
    scene/scenenode.cpp \
    tests/tests.cpp \
    ui/infopanel.cpp \
    sim/collider.cpp \
    geometry/bbox.cpp

HEADERS  += ui/mainwindow.h \
    viewport/camera.h \
    viewport/viewport.h \
    common/common.h \
    ui/viewpanel.h \
    sim/particle.h \
    ui/userinput.h \
    cuda/functions.h \
    geometry/mesh.h \
    io/objparser.h \
    scene/scene.h \
    scene/scenenode.h \
    common/renderable.h \
    common/types.h \
    tests/tests.h \
    sim/grid.h \
    ui/infopanel.h \
    sim/collider.h \
    geometry/bbox.h \
    common/math.h

FORMS    += ui/mainwindow.ui

# GLM
INCLUDEPATH += glm/
DEFINES += GLM_FORCE_RADIANS

# C++ flag
QMAKE_CXXFLAGS_RELEASE=-O3
QMAKE_CXXFLAGS += -std=c++11

# CUDA stuff
CUDA_SOURCES += cuda/snow.cu \
    cuda/wil.cu \
    cuda/max.cu \
    cuda/tim.cu \
    cuda/eric.cu \

# uncomment below to also import include CUDA SDK
#CUDA_SDK = /contrib/projects/cuda-sdk/C
#INCLUDEPATH += $$CUDA_SDK/common/inc/
#INCLUDEPATH += $$CUDA_SDK/../shared/inc/
#QMAKE_LIBDIR += $$CUDA_SDK/lib
#QMAKE_LIBDIR += $$CUDA_SDK/common/lib

CUDA_DIR = /contrib/projects/cuda5-toolkit
INCLUDEPATH += $$CUDA_DIR/include
INCLUDEPATH += $$CUDA_DIR/samples/common/inc
QMAKE_LIBDIR += $$CUDA_DIR/lib64
#LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$$CUDA_DIR/lib64

LIBS += -lcudart -lcuda

OTHER_FILES += \
    CUDA_notes.txt \
    cuda/snow.cu \
    cuda/wil.cu \
    cuda/max.cu \
    cuda/tim.cu \
    cuda/eric.cu \

# GPU ARCH
# this gets passed as the gpu-architecture flag to nvcc compiler
# specifying particular architectures enable certain features, limited to the compute capability
# of the GPU. compute capabilities listed here http://en.wikipedia.org/wiki/CUDA
# MSLAB GeForce 460 seems to have compute capability 2.1
CUDA_ARCH = sm_21

# custom NVCC flags
NVCCFLAGS     = --compiler-options -fno-strict-aliasing -use_fast_math --ptxas-options=-v

# Prepare the extra compiler configuration (taken from the nvidia forum - i'm not an expert in this part)
CUDA_INC = $$join(INCLUDEPATH,' -I','-I',' ') -I$$_PRO_FILE_PWD_


# compile CUDA kernels using nvcc
cuda.commands = $$CUDA_DIR/bin/nvcc -m64 -g -G -arch=$$CUDA_ARCH -c $$NVCCFLAGS $$CUDA_INC $$LIBS  ${QMAKE_FILE_NAME} -o ${QMAKE_FILE_OUT} \
    2>&1 | sed -r \"s/\\(([0-9]+)\\)/:\\1/g\" 1>&2
# Prepare the extra compiler configuration (taken from the nvidia forum - i'm not an expert in this part)
cuda.input = CUDA_SOURCES
cuda.output = ${OBJECTS_DIR}${QMAKE_FILE_BASE}_cuda.o # suffix needed for this to work?
# Tell Qt that we want add more stuff to the Makefile
QMAKE_EXTRA_COMPILERS += cuda
