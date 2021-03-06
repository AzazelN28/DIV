# Makefile para el IDE
# CPU=586 genera D.EXE
# CPU=386 genera D.386

!ifndef ROOT
ROOT=..\..
!endif
!ifndef %OUTDIR
%OUTDIR = $(ROOT)\build.dos\$(CONFIG)
!endif
OUTDIR = $(%OUTDIR).$(CPU)

MAKE=$+ $(MAKE) -h $-
WASM=$(%WASM_EXE)
TASM=$(%TASM_EXE)
WASM_OPTIONS=$(%WASM_OPTIONS)
TASM_OPTIONS=$(%TASM_OPTIONS)

!ifeq CPU 586
%OPTIONS += -5r -fp5
WASM_OPTIONS = -5r -fp5
EXE = d.exe
!ifeq %STUB
OP_STUB = option nostub
!else
OP_STUB = option stub=$(%STUB)
!endif
!else
%OPTIONS += -3r -fpc
WASM_OPTIONS = -3r -fpc
EXE = d.386
OP_STUB = option nostub
!endif

INC_NOTARGETS=1
!include $(ROOT)\3rdparty.mif
!undef INC_NOTARGETS

SOURCES = cdrom.cpp det_vesa.cpp div.cpp divasm.cpp divbasic.cpp divbin.cpp &
	divbrow.cpp divc.cpp divcalc.cpp divcdrom.cpp divcolor.cpp divdsktp.cpp &
	divedit.cpp diveffec.cpp divfont.cpp divforma.cpp divfpg.cpp divgama.cpp &
	divhandl.cpp divhelp.cpp divinsta.cpp divkeybo.cpp divlengu.cpp &
	divmap3d.cpp divmix.cpp divmixer.cpp divmouse.cpp divpaint.cpp &
	divpalet.cpp divpcm.cpp divsb.cpp divsetup.cpp divsound.cpp divspr.cpp &
	divsprit.cpp divtimer.cpp divvideo.cpp divwindo.cpp fpgfile.cpp &
	grabador.cpp ifs.cpp divdll1.c divdll2.c a.asm
SOURCES += timer.asm
SOURCES += vesa.asm

#	divfrm.cpp mem.cpp
# VPE (modo-8) esto es para el int�rprete!
#SOURCES += vpe\draw_cw.cpp vpe\draw_f.cpp vpe\draw_o.cpp vpe\draw_sw.cpp vpe\fixed.cpp vpe\gfx.cpp vpe\globals.cpp &
#	vpe\hard.cpp vpe\load.cpp vpe\mem.cpp vpe\object.cpp vpe\scan.cpp vpe\update.cpp vpe\view.cpp vpe\vpe.cpp &
#	vpe\vpedll.cpp vpe\zone.cpp

!ifeq CPU 586
# VISOR (generador de sprites) s�lo para pentium
SOURCES += visor\animated.cpp visor\complex.cpp visor\fileanim.cpp &
	visor\global.cpp visor\hlrender.cpp visor\llrender.cpp visor\resource.cpp &
	visor\sprite3d.cpp visor\visor.cpp t.asm
#	visor\main.cpp
!else
SOURCES += div386.c
!endif

OBJS = $(SOURCES:.cpp=.obj)
OBJS = $(OBJS:.c=.obj)
OBJS = $(OBJS:.asm=.obj)

LIBS = $(JUDAS_LIB) $(JPEG_LIB) $(ZLIB_LIB) $(SVGA_LIB) $(PMODE_LIB)
INCLUDE += -I..
%OPTIONS += $(INCLUDE)

.BEFORE
	@if not exist $(OUTDIR) mkdir $(OUTDIR)
!ifeq CPU 586
	@if not exist $(OUTDIR)\visor mkdir $(OUTDIR)\visor
!endif
#	@if not exist $(OUTDIR)\vpe mkdir $(OUTDIR)\vpe

$(EXE): $(OUTDIR)\$(EXE) .SYMBOLIC

$(OUTDIR)\$(EXE): $(OBJS) $(LIBS) $(%STUB)
	*wlink &
		system dos4g &
		name $(OUTDIR)\$^. &
!ifeqi %CONFIG debug
		debug all &
!endif
		$(OP_STUB) &
		option map=$(OUTDIR)\$^& &
		path $(OUTDIR) &
		file { $(OBJS) } &
		libfile { $(LIBS) }

.asm: .;..;visor
.cpp: .;visor
#.c: .;vbe
#.cpp: .;visor;vpe;source
#.asm: .;source;visor

.obj: $(OUTDIR);$(OUTDIR)\visor

.c.obj:
	*$(%CC) $(%OPTIONS) -fo=$(OUTDIR)\$[:$^. -fr=$(OUTDIR)\$[:$^& $<

.cpp.obj:
	*$(%CC) $(%OPTIONS) -fo=$(OUTDIR)\$[:$^. -fr=$(OUTDIR)\$[:$^& $<

.asm.obj:
!ifeqi %ASM WASM
	* $(WASM) $(WASM_OPTIONS) -fo=$(OUTDIR)\$^. -fr=$(OUTDIR)\$^& $<
!else
	$(TASM) $(TASM_OPTIONS) /m2 $<,$(OUTDIR)\$^.
!endif
#vesa.obj: vesa.asm
#!ifeqi %ASM WASM
#	* $(WASM) -zcm=tasm $(WASM_OPTIONS) -fo=$(OUTDIR)\$^. -fr=$(OUTDIR)\$^& $<
#!else
#	$(TASM) $(TASM_OPTIONS) /m2 $<,$(OUTDIR)\$^.
#!endif
#
#timer.obj: timer.asm
#!ifeqi %ASM WASM
#	* $(WASM) -zcm=tasm $(WASM_OPTIONS) -fo=$(OUTDIR)\$^. -fr=$(OUTDIR)\$^& $<
#!else
#	$(TASM) $(TASM_OPTIONS) /m $<,$(OUTDIR)\$^.
#!endif
#
#a.obj: a.asm
#	* $(WASM) $(WASM_OPTIONS) -fo=$(OUTDIR)\$^. -fr=$(OUTDIR)\$^& $<
#
#visor\t.obj: visor\t.asm
#	* $(WASM) $(WASM_OPTIONS) -fo=$(OUTDIR)\$^. -fr=$(OUTDIR)\$^& $<

!ifdef %STUB
$(%STUB):
	@%make savedir
	cd $(ROOT)\src\wstub
	! $(MAKE) ROOT=$(ROOT) CONFIG=$(%CONFIG)
	@%make loaddir
!endif

clean: .SYMBOLIC
	@if exist $(OUTDIR)\*.err del $(OUTDIR)\*.err
	@if exist $(OUTDIR)\*.obj del $(OUTDIR)\*.obj
	@if exist $(OUTDIR)\*.exe del $(OUTDIR)\*.exe
#	@if exist $(OUTDIR)\vpe\*.err del $(OUTDIR)\vpe\*.err
#	@if exist $(OUTDIR)\vpe\*.obj del $(OUTDIR)\vpe\*.obj
!ifeq CPU 586
	@if exist $(OUTDIR)\visor\*.err del $(OUTDIR)\visor\*.err
	@if exist $(OUTDIR)\visor\*.obj del $(OUTDIR)\visor\*.obj
!endif
	@%make savedir
	cd $(ROOT)\src\wstub
	! $(MAKE) CONFIG=$(%CONFIG) clean
	@%make loaddir

INC_NOVARS=1
!include $(ROOT)\3rdparty.mif
!undef INC_NOVARS

!include $(ROOT)\common.mif
