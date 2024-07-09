
module top_tb;
    import svm_pkg::*;
    `include "environment.svh"
    `include "test_simple.sv"
    `include "test_bad.sv"

    initial begin
        svm_component test_obj;
        test_obj = svm_factory::get_test();
        test_obj.run_test();
        $finish();
    end

    initial begin
        $fsdbDumpfile("./wave.fsdb");
        $fsdbDumpvers("+all");
        $fsdbDumpMDA(0, top_tb);
        $fsdbDumpSVA();
    end
endmodule