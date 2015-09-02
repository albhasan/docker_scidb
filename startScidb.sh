#!/bin/bash
echo "********************************************"
echo "START SCIDB"
echo "********************************************"
export LC_ALL="en_US.UTF-8"
yes | scidb.py initall sdb_doc_twdtw
scidb.py startall sdb_doc_twdtw
scidb.py status sdb_doc_twdtw
