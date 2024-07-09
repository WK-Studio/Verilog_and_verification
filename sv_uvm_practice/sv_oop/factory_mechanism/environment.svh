class environment extends svm_component;
    `svm_component_utils(environment);

    function new(string name);
        super.new(name); // call parent class function
        $display("%m", name);
    endfunction

    virtual function void build();
        $display("call env's build");
    endfunction

    virtual function void connect();
        $display("call env's connect")
    endfunction

    virtual task main();
        $display("call env's main");
    endtask
endclass

class environment_bad extends environment;
    `svm_component_utils(environment_bad);

    function new(string name);
        super.new(name); // call parent class function
        $display("%m", name);
    endfunction

    virtual function void build();
        $display("call env_bad's build");
    endfunction

    virtual function void connect();
        $display("call env_bad's connect")
    endfunction

    virtual task main();
        $display("call env_bad's main");
    endtask
endclass