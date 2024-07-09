`include "environment.svh"

class test_simple extends svm_component;
    environment env;
    `svm_component_utils(test_simple);

    function new(string name);
        super.new(name);
        $display("%m SVM_TESTNAME=%s", name);
        env = new("env");
        // env = environment::type_id::create("env");
    endfunction

    virtual task run_test();
        super.run_test();
        $display("%m");
        env.build();
        env.connect();
        env.main();
    endtask
endclass