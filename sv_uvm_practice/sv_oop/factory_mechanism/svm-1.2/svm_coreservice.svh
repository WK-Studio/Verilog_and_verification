typedef class svm_factory;

class svm_coreservice_t;
    local static svm_coreservice_t inst;
    local svm_factory factory;

    static function svm_coreservice_t get();
        if (inst == null) begin
            inst = new();
            $display("Create a unique object of singleton class svm_coreservice_t");
        end
        return inst;
    endfunction

    virtual function svm_factory get_factory();
        if (factory == null) begin
            svm_factory f;
            f = new();
            $display("Create a unique object of singleton class svm_factory");
            factory = f;
        end
        return factory;
    endfunction
endclass