# $Id: Makefile 596 2015-03-10 15:04:57Z hidaka $

all: uncal2dot_customer dot2png_customer validate_customer \
	forward_unql+ forward_uncal forward_uncal_trace \
	backward_uncal

# input graphs
uncal2dot_customer:
	uncalcmd -q customers_c.uncal -dot customers_c.dot

dot2png_customer:
	dot customers_c.dot -T png > customers_c.png

validate_customer:
	unqlplus -db customers_c.uncal -iv Customer.km3 -ip Customer \
		 -q c2o_c.unql

# forward transformation
forward_unql+: # with validation
	unqlplus \
		-db customers_c.uncal \
		-q c2o_c.unql \
		-cal orders_c.uncal \
		-iv Customer.km3 \
		-ip Customer \
		-ov Order.km3 \
		-op Order \
		-t -pa -pu

forward_st: # small step
	bwdIg_uncal \
		-idot customers_c.dot \
		-q c2o_c.uncal \
		-odot orders_c.dot

forward_uncal: # without validation, without tracing information
	fwd_uncal \
		-db customers_c.uncal \
		-uq c2o_c.unql \
		-dot orders_c.dot \
		-png orders_c.png \
		-xg orders_c.xg \
		-ei orders_c.ei \
		-t -ge -pa 

forward_uncal_trace: # without validation, with tracing information in the result
	fwd_uncal \
		-db customers_c.uncal \
		-uq c2o_c.unql \
		-dot orders_c_trace.dot \
		-png orders_c_trace.png \
		-xg orders_c_trace.xg \
		-ei orders_c_trace.ei \
		-sb -ge -pa

# backward transformation
backward_uncal:
	bwd_uncal \
		-db customers_c.uncal \
		-xg orders_c.xg \
		-ei orders_c.ei \
		-dot orders_c_mod.dot \
		-png customers_c_mod.png \
		-ucal customers_c_mod.uncal \
		-udot customers_c_mod.dot -pa -cm

# clean
clean:
	rm *.png *~ *.xg *.ei



