package internals 

Record :: struct {
    data: any,
    gen: Generation
}

Vector_Storage :: struct {
    elements: #soa[dynamic]Record
}

