
`define svm_component_utils(T) \
    `m_svm_component_registry_internal(T, T)
    `m_svm_get_type_name_func(T)

`define m_svm_component_registry_internal(T, S) \
    typedef svm_component_registry #(T, `"S`") type_id; \
    static function type_id get_type(); \
        return type_id::get();
    endfunction
    virtual function svm_object_wrapper get_object_type(); \
        return type_id::get(); \
    endfunction

`define m_svm_get_type_name_func(T) \
    const static string type_name = `"T`"; \
    virtual function string get_type_name(); \
        return type_name; \
    endfunction