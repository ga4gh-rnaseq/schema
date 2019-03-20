
# Testing and Interoperability

## rnaget API

Several sources have written test servers and clients for the rnaget API.  These are available for testing.


### Servers
* caltech.edu server - A demo server is available at http://felcat.caltech.edu/rnaget/ serving the Pan-Cancer Analysis of Whole Genomes (PCAWG) dataset.

* crg.cat server - A demo server is available at https://genome.crg.cat/rnaget/ serving the Pan-Cancer Analysis of Whole Genomes (PCAWG) dataset.  To access this server a request must have `Authorization` `Bearer abcdefuvwxyz` in the headers.


### Clients
* saupchurch client - This is an iPython notebook example designed to demonstrate basic navigation and operations on the demo PCAWG dataset.  It is available at: https://github.com/saupchurch/bioinformatics-tools/blob/master/ga4gh-rnaget-api/GA4GH-rnaget-API-examples.ipynb


### Interoperability
<table>
<tr markdown="block"><td>
</td><td>
caltech.edu server
</td><td>
crg.cat server
</td></tr>
<tr markdown="block"><td>
saupchurch client
</td><td>
Passed
</td><td>
Pending
</td></tr>
</table>

