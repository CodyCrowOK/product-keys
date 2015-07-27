Simple Product Key Implementation
=================

This is a dead simple implementation of product keys in Perl with the Dancer2 framework. It uses MySQL for the backend, although it just as easily could have been anything else, and you could easily drop in something else.

There is no authentication of any kind, although something like Dancer2's Auth::Simple could be added nearly effortlessly.

All product keys are 7-digit numbers which have a Luhn mod 10 check digit of 7.

MIT Licensed

Routes:

* /product_key: POST form data in the format "key: $PRODUCTKEY" to check a product key. Returns 403 if the key is invalid, or 202 if it's valid
* /generate_keys: POST form data in the format "range: Z" where Z is any integer. It will return Z new product keys as a JSON array.
