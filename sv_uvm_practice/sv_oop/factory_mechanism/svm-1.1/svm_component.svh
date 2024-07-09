virtual class svm_object;
endclass

virtual class svm_component extends svm_object;
    string name;

    function new (string name);
        this.name = name;
        $display("%m");
    endfunction

    virtual task run_test();
    endtask
endclass