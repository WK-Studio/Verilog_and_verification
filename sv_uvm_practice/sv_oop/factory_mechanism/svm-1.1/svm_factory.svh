`include "svm_component.svh"

virtual class svm_object_wrapper;
    virtual function svm_component create_component(string name);
        return null;
    endfunction
    pure virtual function string get_type_name();
    endfunction
endclass

class svm_factory;
    static svm_object_wrapper m_type_names[string]; // associative array
    
    static svm_factory m_inst; // factory class (singleton class) handle

    static function svm_factory get();
        if (m_inst == null) begin
            m_inst = new();
            $display("Create a unique object of singleton class svm_factory");
        end
        return m_inst;
    endfunction

    static function void register(svm_object_wrapper c);
        m_type_names[c.get_type_name()] = c; // register proxy object handle
    endfunction

    /* 
     *    Override mechanism member functions
     */
    // (1) Override type
    static function void override_type(string type_name/*idx*/, string override_type_name);
        override[type_name] = override_type_name;
    endfunction

    // (2) Create object by type
    function svm_object create_object_by_type(svm_object_wrapper proxy, string name);
        proxy = find_override(proxy);
        return proxy.create_component(name);
    endfunction

    // (3) Find override
    function svm_object_wrapper find_override(svm_object_wrapper proxy);
        if (override.exists(proxy.get_type_name))
            return m_type_names[override[proxy.get_type_name]];
        return proxy;
    endfunction

    static function svm_component get_test();
        string name;
        svm_object_wrapper test_wrapper;
        svm_component test_comp;

        if (!$value$plusargs("SVM_TESTNAME=%s", name)) begin
            $display("FATAL +SVM_TESTNAME not found");
            $finish();
        end

        $display("%m found +SVM_TESTNAME=%s", name);
        test_wrapper = svm_factory::m_type_names[name];
        $cast(test_comp, test_wrapper.create_component(name));
        return test_comp;
    endfunction
endclass 
