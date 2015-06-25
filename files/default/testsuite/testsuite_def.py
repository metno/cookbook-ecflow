#!/usr/bin/env python2.7
import os
import ecflow 

def create_family_f1():
    f1 = ecflow.Family("native_python")
    f1.add_task("hello_task")
    return f1
      
print "Creating suite definition"   
defs = ecflow.Defs()
suite = defs.add_suite("testsuite")
suite.add_variable("ECF_HOME", os.environ['ECF_HOME'])
suite.add_variable("ECF_BASE", os.environ['ECF_BASE'])
suite.add_variable("ECF_MICRO", "$")
suite.add_variable("ECF_JOB_CMD", "python $ECF_JOB$ > $ECF_JOBOUT$ 2>&1")
suite.add_family( create_family_f1() )

print "Checking job creation: .ecf -> .job0"   
print defs.check_job_creation()

print "Saving definition to file 'testsuite'"
defs.save_as_defs("testsuite.def")
