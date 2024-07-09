
// SVM-1.2 modify part
static function this_type get();
    if (me == null) begin
        svm_coreservice_t cs = svm_coreservice_t::get();
        svm_factory = cs.get_factory();
        me = new();
        $display("Create a unique object of singleton class svm_component_registry#(%s, %s)", Tname, Tname);
        factory.register(me);
    end
    return me;
endfunction