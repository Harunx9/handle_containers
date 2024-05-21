package internals 

import "core:fmt"

Typed_Record :: struct($T: typeid) {
	data: Maybe(T),
	gen:  Generation,
}

Typed_Array_Storage_Iterator :: struct($T: typeid) {
    storage: ^Typed_Array_Storage(T),
    idx: int,
}

Typed_Array_Storage :: struct($T: typeid) {
	records: #soa[dynamic]Typed_Record(T),
}

create_typed_array_storage :: proc(
	$T: typeid,
	min_size := MIN_ELEMENT_NUMBER,
) -> Typed_Array_Storage(T) {
    rec, err := make_soa_dynamic_array_len_cap(#soa[dynamic]Typed_Record(T), 0, min_size)
    if err != nil {
        panic("Failed to create typed array storage")
    }
	return Typed_Array_Storage(T){records = rec}
}

destroy_typed_array_storage :: proc($T: typeid, storage: Typed_Array_Storage(T)) {
	delete_soa(storage.records)
}

insert_typed_data :: proc(storage: ^Typed_Array_Storage($T), hadnle: Typed_Handle(T), data: T) {
	idx := hadnle.idx
	gen := hadnle.gen

    for idx >= u32(len(storage.records)) {
        append_soa(&storage.records, Typed_Record(T) { data = nil, gen = 0 })
    }

	prev_gen := storage.records[idx].gen

	if prev_gen > gen {
		panic("Trying to insert data into outdated handle")
	}

	storage.records[idx] = Typed_Record(T) { data = data, gen = gen }
}

get_typed_data :: proc(storage: ^Typed_Array_Storage($T), hadnle: Typed_Handle(T)) -> Maybe(T) {
	if record := storage.records[hadnle.idx]; record.gen == hadnle.gen && record.data != nil {
		return record.data
	} else {
		panic("Trying to get data from outdated handle")
	}
}

get_typed_data_ptr :: proc(storage: ^Typed_Array_Storage($T), hadnle: Typed_Handle(T)) -> Maybe(^T) {
	if record := &storage.records[hadnle.idx]; record.gen == hadnle.gen && record.data != nil {
		return &record.data.? or_else nil
	} else {
		panic("Trying to get data from outdated handle")
	}
}

replace_typed_data :: proc(storage: ^Typed_Array_Storage($T), hadnle: Typed_Handle(T), data: T) {
	idx := hadnle.idx
	gen := hadnle.gen

	prev_gen := storage.records[idx].gen

	if prev_gen > gen {
		panic("Trying to insert data into outdated handle")
	}

	storage.records[idx].data = data
	storage.records[idx].gen = gen
}

remove_typed_data :: proc(storage: ^Typed_Array_Storage($T), hadnle: Typed_Handle(T)) {
    idx := hadnle.idx
    gen := hadnle.gen

    prev_gen := storage.records[idx].gen

    if prev_gen > gen {
        panic("Trying to remove data from outdated handle")
    }

    storage.records[idx].data = nil
}

typed_array_storage_is_empty:: proc(storage: ^Typed_Array_Storage($T)) -> bool {
    return len(storage.records) == 0 
}

make_typed_array_storage_iterator :: proc(storage: ^Typed_Array_Storage($T)) -> Typed_Array_Storage_Iterator(T) {
    return Typed_Array_Storage_Iterator(T) { storage = storage, idx = 0 }
}

typed_array_storage_iterator_next :: proc(iter: ^Typed_Array_Storage_Iterator($T)) -> (data: Maybe(^T), is_end: bool) {
    is_end = iter.idx >= len(iter.storage.records)

    for !is_end {
        record := &iter.storage.records[iter.idx]

        if record.data != nil {
            data = &record.data.? or_else nil
            iter.idx += 1
            return
        }
    }
    
    return
}

