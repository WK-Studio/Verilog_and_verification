
// svm-1.2 modify part
static function svm_factory get();
    svm_coreservice_t s;
    s = svm_coreservice_t::get();
    return s.get_factory();
endfunction