# $Id: Makefile 596 2015-03-10 15:04:57Z hidaka $

all: db fwd bwd

# generating doc files for the db graph and the graph to be inserted.

db:
	uncalcmd -q db.uncal -dot db.dot -png db.png
	uncalcmd -q to_be_inserted.uncal -dot to_be_inserted.dot -png to_be_inserted.png

# forward transformation to produce a view a subgraph is to be inserted
fwd:
	bwdIg_uncal -idot db.dot -q a2d_xc.uncal -odot view.dot -opng view.png
	uncalcmd -dbd db.dot -q a2d_xc.uncal -dot view1.dot -png view1.png -rec -sr -pi

# backward transformation to reflect the insertion and 
# produce udpated input and view graphs.
bwd:
	bwdIg_uncal \
	-idot db.dot \
	-q a2d_xc.uncal \
	-odot oview.dot \
	-ipt 3 \
	-tidot to_be_inserted.dot \
	-uidot udb.dot \
	-uodot uview.dot		

# clean
clean:
	rm *.png *~ *.dot 



