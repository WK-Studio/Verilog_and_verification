`include "svm_factory.svh"

class svm_component_registry #(type T = svm_component,
    string Tname = "<unknown>") extends svm_object_wrapper;
    typedef svm_component_registry #(T, Tname) this_type;

    // create test object
    virtual function svm_component create_component(string name="");
        T obj;
        obj = new(name);
        return obj;
    endfunction

    virtual function string get_type_name();
        return Tname;
    endfunction

    // singleton class automatic instantialization
    local static this_type me = get();

    static function this_type get();
        if (me == null) begin
            svm_factory f = svm_factory::get();
            me = new();
            $display("Create a unique object of singleton class svm_component_registry#(%s, %s)", Tname, Tname);
            f.register(me);
        end
        return me;
    endfunction

    // create component
    static function T create(string name);
        svm_object obj;
        svm_factory factory = svm_factory::get();
        obj = factory.create_object_by_type(me, name);
        $cast(create, obj); // downcasting
    endfunction
endclass