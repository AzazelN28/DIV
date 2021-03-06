# Makefile para la DIV32RUN.DLL en todas sus variantes.
# SESSION=1 genera el int�rprete que incorpora el trazador. Es el int�rprete
# que se ejecuta desde el IDE cuando arrancamos un programa.
# SESSION=0 genera la DIV32RUN.DLL que se incluir� con el instalador de nuestro
# juego. Pero a�n no es la versi�n redistribuible, ya que al generar el
# instalador se le agrega la tabla de textos traducidos.

!ifndef ROOT
ROOT=..\..
!endif

#%OPTIONS += -fti

!ifeq SESSION 1
%OPTIONS += -DDEBUG
SYSTEM=dos4g
OUTDIR = $(%OUTDIR).$(CPU)\session
!ifeq CPU 586
EXE=session.div
!else
EXE=session.386
!endif
!else
SYSTEM=pmodew
OUTDIR = $(%OUTDIR).$(CPU)\div32run
!ifeq CPU 586
EXE=div32run.ins
!else
EXE=div32run.386
!endif
!endif

MAKE=$(MAKE) -h
WASM=$(%WASM_EXE)
TASM=$(%TASM_EXE)
WASM_OPTIONS=$(%WASM_OPTIONS)
TASM_OPTIONS=$(%TASM_OPTIONS)

!ifeq CPU 586
%OPTIONS += -5r -fp5
WASM_OPTIONS = -5r -fp5 -mf
!else
%OPTIONS += -3r -fpc
WASM_OPTIONS = -3r -fpc -mf
!endif

INC_NOTARGETS=1
!include $(ROOT)\3rdparty.mif
!undef INC_NOTARGETS

SOURCES = i.cpp f.cpp c.cpp s.cpp v.cpp a.asm divfli.cpp cdrom.cpp &
	divkeybo.cpp mouse.cpp divdll1.c divdll2.c ia.cpp divsound.cpp &
	divmixer.cpp divtimer.cpp timer.asm divlengu.cpp vesa.asm &
	det_vesa.cpp

!ifeq SESSION 1
SOURCES += d.cpp
!endif

# VPE (modo-8)
SOURCES += vpe\draw_cw.cpp vpe\draw_f.cpp vpe\draw_o.cpp vpe\draw_sw.cpp &
	vpe\fixed.cpp vpe\gfx.cpp vpe\globals.cpp vpe\hard.cpp vpe\load.cpp &
	vpe\mem.cpp vpe\object.cpp vpe\scan.cpp vpe\update.cpp vpe\view.cpp &
	vpe\vpe.cpp vpe\zone.cpp vpe\draw_fa.asm vpe\draw_oa.asm vpe\draw_wa.asm &
	vpe\vpedll.cpp

# NETLIB (red)
SOURCES += netlib\red.cpp netlib\net.c netlib\comlib.c netlib\comm.c &
	netlib\ipxlib.c netlib\dpmi_net.c

OBJS = $(SOURCES:.cpp=.obj)
OBJS = $(OBJS:.c=.obj)
OBJS = $(OBJS:.asm=.obj)

LIBS = $(JUDAS_LIB) $(JPEG_LIB) $(ZLIB_LIB) $(SVGA_LIB) $(PMODE_LIB) $(TFLC_LIB)
INCLUDE += -I..
%OPTIONS += $(INCLUDE)

.BEFORE
	@if not exist $(%OUTDIR).$(CPU) mkdir $(%OUTDIR).$(CPU)
	@if not exist $(OUTDIR) mkdir $(OUTDIR)
	@if not exist $(OUTDIR)\netlib mkdir $(OUTDIR)\netlib
	@if not exist $(OUTDIR)\vpe mkdir $(OUTDIR)\vpe

$(EXE): $(OUTDIR)\$(EXE) .SYMBOLIC
	@%null

$(OUTDIR)\$(EXE): $(OBJS) $(LIBS) $(%STUB)
	*wlink &
		system $(SYSTEM) &
		name $(OUTDIR)\$^. &
!ifeqi %CONFIG debug
		debug all &
!endif
		option stack=64k &
		option map=$(OUTDIR)\$^& &
		path $(OUTDIR) &
		file { $(OBJS) } &
		libfile { $(LIBS) }

$(%STUB): ..\wstub\makefile ..\wstub\wstub.c ..\cpuid.asm
	cd ..\wstub
	$(MAKE) CONFIG=$(%CONFIG)
	cd ..\div32run

.asm: .;..;..\vpe
.c: .;..\netlib
.cpp: .;..\vpe;..\netlib
#.c: source;vbe
#.cpp: source;vbe;netlib
#.asm: source

.obj: $(OUTDIR)
#.obj: $(OUTDIR);$(OUTDIR)\netlib;$(OUTDIR)\vpe

.c.obj:
	*$(%CC) $(%OPTIONS) -fo=$(OUTDIR)\$^@ -fr=$(OUTDIR)\$^* $<

.cpp.obj:
	*$(%CC) $(%OPTIONS) -fo=$(OUTDIR)\$^@ -fr=$(OUTDIR)\$^* $<

.asm.obj:
!ifeqi %ASM WASM
	*$(WASM) $(WASM_OPTIONS) -fo=$(OUTDIR)\$^@ -fr=$(OUTDIR)\$^* $<
!else
	$(TASM) $(TASM_OPTIONS) /m2 $<,$(OUTDIR)\$^@
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

clean: .SYMBOLIC
	@if exist $(OUTDIR)\*.err del $(OUTDIR)\*.err
	@if exist $(OUTDIR)\*.obj del $(OUTDIR)\*.obj
	@if exist $(OUTDIR)\*.exe del $(OUTDIR)\*.exe
	@if exist $(OUTDIR)\vpe\*.err del $(OUTDIR)\vpe\*.err
	@if exist $(OUTDIR)\vpe\*.obj del $(OUTDIR)\vpe\*.obj

INC_NOVARS=1
!include $(ROOT)\3rdparty.mif
!undef INC_NOVARS
