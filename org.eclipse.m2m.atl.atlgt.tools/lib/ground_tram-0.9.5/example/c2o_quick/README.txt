(* $Id: README.txt 596 2015-03-10 15:04:57Z hidaka $ *)

This short note shows how to use the bx_quick command for both 
forward and backward transformation. 

1. Forward Transformation
--------------------------

We can run the forward transformation by

> bx_quick -f -uq c2o_c.unql -idot customers_c.dot -odot orders_c.dot

which will apply the transformation c2s_c.unql to the database 
customers_c.dot and produce the result orders_c.dot.

If we want to check if the input database meets the schema 
Customers.km3 during forward transformation, we can do by

> bx_quick -f -uq c2o_c.unql -idot customers_c.dot -odot orders_c.dot -ikm3 Customer.km3 -ip Customer


2. Backward Transformation
---------------------------

For the backward transformation, we do not allow insertion to be done
together with inplace updates or deletion.

First of all, let us see how to do with inplace udpates and deletion.
You can use dotty or other tool to see the result produced by the 
forward transformation.

> dotty orders_c.dot

Now let us modify the orders_c.dot as follows:

  - (11,"16/10/2008",10) => (11,"31/01/2010",10)
　- (14,1001,13) => (14,1100,13)
  - delete (50,info,26)

and save it to orders_c.dot. To reflect this change to the source
database, we apply backward transformation as follows.

> bx_quick -b -uq c2o_c.unql -idot customers_c.dot -odot orders_c1.dot

The updated source and view will be saved in udb.dot and uout.dot respectively.
We can specify the files for saving these updated results by

> bx_quick -b -uq c2o_c.unql -idot customers_c.dot -odot orders_c1.dot -uidot xx.dot -uodot yy.dot

It is a bit tricky to deal with insertion. We adopt a simple way. First, we
specify where a new tree is to be inserted. For instance of orders_c.dot,
suppose that we want to insert a subtree 

   {info:...} 

below the node pointed by the edge 

  (59,Address,50)

We explain this modification by modifying the above edge to

  (59,_info,50)

and save the modified view to orders_c2.dot. 

Now we can reflect this change to the source by

> bx_quick -b -uq c2o_c.unql -idot customers_c.dot -odot orders_c2.dot -tdot customer_c_template.dot

where customer_c_template.dot is an instance of a customer's data following 
the schema Customer.
