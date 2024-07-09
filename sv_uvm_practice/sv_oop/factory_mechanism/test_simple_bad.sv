`include "environment.svh"

class test_bad extends svm_component;
    environment env;
    `svm_component_utils(test_bad);

    function new(string name);
        super.new(name);
        $display("%m SVM_TESTNAME=%s", name);
        
        // register override associative array
        svm_factory::override_type("environment", "environment_bad");

        // create instance
        env = environment::type_id::create("env");
    endfunction

    virtual task run_test();
        super.run_test();
        $display("%m");
        env.build();
        env.connect();
        env.main();
    endtask
endclass