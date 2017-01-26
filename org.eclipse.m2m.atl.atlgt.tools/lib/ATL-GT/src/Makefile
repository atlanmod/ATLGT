#GTDIR  = ../../ground_tram-0.9.3/src
GTDIR  = ../../ground_tram-0.9.5/src
GTCMXA = $(GTDIR)/unql.cmxa
GTCMA  = $(GTDIR)/unql.cma

XLDIR = xml-light
XLCMXA = $(XLDIR)/xml-light.cmxa
XLCMA  = $(XLDIR)/xml-light.cma

GT_TARGETS = all.$(GTDIR) clean.$(GTDIR)
XL_TARGETS = all.$(XLDIR)   opt.$(XLDIR)

INSTALL = /usr/bin/install
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin

# .PHONY: all $(GT_TARGETS) 

# .PHONY: clean all

# all: 
# all: all.$(GTDIR) $(XL_TARGETS) trace.byte trace xmi2dot_command xmi2dot_command.byte \
# 	atl2unql fixdot dot2dgm_command dot2xmi_command
all: all.$(GTDIR) $(XL_TARGETS) trace.byte trace \
	atl2unql fixdot dot2dgm_command dot2xmi_command xmi2dot_generic_command restrictxmi_xmi2dot_command


# include $(GTDIR)/Makefile

# $(GTCMXA): unql.cmxa.$(GTDIR)
# 	$(MAKE) -C $(GTDIR) unql.cmxa

$(GT_TARGETS): %.$(GTDIR):
	$(MAKE) -C $(GTDIR) $*

$(XL_TARGETS): %.$(XLDIR):
	$(MAKE) -C $(XLDIR) $*

GTSUBDIRS := util uncal datamodel dot unql eval insertion schema tologic range statebase 

INCLUDES := $(addprefix -I $(GTDIR)/,$(GTSUBDIRS)) -I . -I $(XLDIR)


##############################################################################
# OCaml 
##############################################################################

OCAMLC    := ${shell which ocamlc.opt ocamlc | head -1}
OCAMLOPT  := ${shell which ocamlopt.opt ocamlopt  | head -1}
OCAMLDEP  := ${shell which ocamldep.opt ocamldep | head -1}
OCAMLLEX  := ${shell which ocamllex.opt ocamllex | head -1}
OCAMLYACC := ${shell which ocamlyacc.opt ocamlyacc | head -1}
OCAMLDOC  := ${shell which ocamldoc.opt ocamldoc | head -1}
OCAMLCMD  := ${shell which ocaml ocaml.opt | head -1}

#OCAMLFLAGS = -w yu -annot
OCAMLFLAGS = -w yu -annot -g
OCAMLOPTFLAGS = -w yu

##############################################################################
# Files
##############################################################################

SRC_ATL-GT  := atl.ml lexatl.mll parseatl.mly printatl.ml objectGraph.ml g2objectGraph.ml dot2xmi.ml dispdotXMI.ml xmi2dot_generic.ml atlMin2unql.ml restrictObject.ml
SRC_COMMAND := trace.ml xmi2dot_generic_command.ml atl2unql.ml dot2dgm_command.ml dot2xmi_command.ml restrictxmi_xmi2dot_command.ml

SRCS_CORE   := $(SRC_ATL-GT)
SRCS_PARSER := \
	$(patsubst %.mly,%.ml,$(filter %.mly,$(SRCS_CORE))) \
	$(patsubst %.mly,%.mli,$(filter %.mly,$(SRCS_CORE))) \
	$(patsubst %.mll,%.ml,$(filter %.mll,$(SRCS_CORE))) \
	$(patsubst %.mll,%.mli,$(filter %.mll,$(SRCS_CORE)))
SRCS_ML  := $(filter %.ml,$(patsubst %.mly,%.ml,$(patsubst %.mll,%.ml,$(SRCS_CORE))))
SRCS_MLI := $(filter %.mli,$(SRCS_CORE)) \
	$(patsubst %.mly,%.mli,$(filter %.mly,$(SRCS_CORE)))

SRCS_DEPEND := $(SRCS_ML) $(SRCS_MLI) $(SRC_COMMAND)

OBJS = $(SRCS_ML:.ml=.cmo) 
OPTOBJS = $(SRCS_ML:.ml=.cmx) 

PROGRAMS = \
	trace xmi2dot_generic_command dot2xmi_command atl2unql restrictxmi_xmi2dot_command


##############################################################################
# Commands
##############################################################################


trace: $(GTCMXA) trace.cmx
	$(OCAMLOPT) $(OCAMLOPTFLAGS) unix.cmxa str.cmxa -o $@ $^

trace.byte: $(GTCMA) trace.cmo
	$(OCAMLC) $(OCAMLFLAGS) unix.cma str.cma -o $@ $^

# xmi2dot_command: $(GTCMXA) $(XLCMXA) atl.cmx lexatl.cmx parseatl.cmx  xmi2dot.cmx  xmi2dot_command.cmx
# 	$(OCAMLOPT) $(OCAMLOPTFLAGS) unix.cmxa str.cmxa -o $@ $^

xmi2dot_generic_command: $(GTCMXA) $(XLCMXA) objectGraph.cmx g2objectGraph.cmx xmi2dot_generic.cmx  xmi2dot_generic_command.cmx
	$(OCAMLOPT) $(OCAMLOPTFLAGS) unix.cmxa str.cmxa -o $@ $^

xmi2dot_generic_command.byte: $(GTCMA) $(XLCMA) objectGraph.cmo g2objectGraph.cmo xmi2dot_generic.cmo  xmi2dot_generic_command.cmo
	$(OCAMLC) $(OCAMLFLAGS) unix.cma str.cma -o $@ $^


#xmi2dot_command.byte: $(GTCMA) $(XLCMA) atl.cmo lexatl.cmo parseatl.cmo  xmi2dot.cmo  xmi2dot_command.cmo
#	$(OCAMLC) $(OCAMLFLAGS) unix.cma str.cma -o $@ $^

dot2xmi_command: $(GTCMXA) $(XLCMXA) objectGraph.cmx g2objectGraph.cmx dot2xmi.cmx dispdotXMI.cmx dot2xmi_command.cmx
	$(OCAMLOPT) $(OCAMLOPTFLAGS) unix.cmxa str.cmxa -o $@ $^

dot2xmi_command.byte: $(GTCMA) $(XLCMA) objectGraph.cmo g2objectGraph.cmo dot2xmi.cmo dispdotXMI.cmo dot2xmi_command.cmo
	$(OCAMLC) $(OCAMLFLAGS) unix.cma str.cma -o $@ $^

dot2dgm_command: $(GTCMXA) $(XLCMXA) objectGraph.cmx g2objectGraph.cmx dispdotXMI.cmx dot2dgm_command.cmx
	$(OCAMLOPT) $(OCAMLOPTFLAGS) unix.cmxa str.cmxa -o $@ $^

dot2dgm_command.byte: $(GTCMA) $(XLCMA) objectGraph.cmo g2objectGraph.cmo dispdotXMI.cmo dot2dgm_command.cmo
	$(OCAMLC) $(OCAMLFLAGS) unix.cma str.cma -o $@ $^

atl2unql: $(GTCMXA) $(XLCMXA) atl.cmx lexatl.cmx parseatl.cmx printatl.cmx atlMin2unql.cmx atl2unql.cmx
	$(OCAMLOPT) $(OCAMLOPTFLAGS) unix.cmxa str.cmxa -o $@ $^

atl2unql.byte: $(GTCMA) $(XLCMA) atl.cmo lexatl.cmo parseatl.cmo printatl.cmo atlMin2unql.cmo atl2unql.cmo
	$(OCAMLC) $(OCAMLFLAGS) unix.cma str.cma -o $@ $^

fixdot: $(GTCMXA) fixdot.cmx
	$(OCAMLOPT) $(OCAMLOPTFLAGS) unix.cmxa str.cmxa -o $@ $^

restrictxmi_xmi2dot_command.byte: $(GTCMA) $(XLCMA) objectGraph.cmo g2objectGraph.cmo dot2xmi.cmo xmi2dot_generic.cmo restrictObject.cmo restrictxmi_xmi2dot_command.cmo
	$(OCAMLC) $(OCAMLFLAGS) unix.cma str.cma -o $@ $^

restrictxmi_xmi2dot_command: $(GTCMXA) $(XLCMXA) objectGraph.cmx g2objectGraph.cmx dot2xmi.cmx xmi2dot_generic.cmx restrictObject.cmx restrictxmi_xmi2dot_command.cmx
	$(OCAMLOPT) $(OCAMLOPTFLAGS) unix.cmxa str.cmxa -o $@ $^

##############################################################################
# Misc
##############################################################################

# clean:
# 	rm -rf *~ *.cm* *.o *.output *.annot *.spot *.spit *.a $(SRCS_PARSER) depend
# 	rm -rf */*~ */*.cm* */*.o */*.output */*.annot */*.spot */*.spit */*.a $(SRCS_PARSER) depend

run-ocaml:
	$(OCAMLCMD) $(INCLUDES)

##############################################################################
# Dependency
##############################################################################

#depend: trace.ml atl.ml lexatl.ml parseatl.ml xmi2dot.ml xmi2dot_command.ml
depend: $(SRCS_DEPEND)
	$(OCAMLDEP) -slash $(INCLUDES) $^ > depend

-include depend


##############################################################################
# Implicit/Explicit Compilation Rules
##############################################################################

.SUFFIXES: .ml .mli .mly .mll .cmi .cmo .cmx

.ml.cmo: ; $(OCAMLC) $(OCAMLFLAGS) $(INCLUDES) $(OCAMLLIBS) -c $<
.ml.cmx: ; $(OCAMLOPT) $(OCAMLOPTFLAGS) $(INCLUDES) $(OCAMLOPTLIBS) -c $<
.mli.cmi: ; $(OCAMLC) $(OCAMLFLAGS) $(INCLUDES) $(OCAMLLIBS) -c $<
.mly.ml: ; $(OCAMLYACC) -v $<
.mll.ml: ; $(OCAMLLEX) $<


doc: $(SRCS_ML) $(SRC_COMMAND)
	mkdir -p html
	$(OCAMLDOC) $(INCLUDES) -d html -html $(SRCS_ML) $(SRC_COMMAND)

wc: $(SRCS_CORE) $(SRC_COMMAND)
	wc -l $^

# clean: clean.$(GTDIR)

clean:
	rm -rf *~ *.cm* *.o *.output *.annot *.spot *.spit *.a $(SRCS_PARSER) depend

cleanexec:
	rm -rf $(PROGRAMS) *.byte  *.exe


install: $(PROGRAMS) install-mkdir
	@PROGRAMS="$(PROGRAMS)"; \
	for p in $$PROGRAMS; do \
		$(INSTALL) -v $$p $(BINDIR) || break; \
	done

install-mkdir:
	mkdir -p $(PREFIX)/bin
