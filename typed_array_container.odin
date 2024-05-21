package handle_containers

import "internals"

MIN_ELEMENT_NUMBER :: internals.MIN_ELEMENT_NUMBER

Typed_Array_Container :: struct($T: typeid) {
	allocator: internals.Typed_Handle_Allocator(T),
	storage:   internals.Typed_Array_Storage(T),
}

create_typed_array_container :: proc(
	$T: typeid,
	min_size := MIN_ELEMENT_NUMBER,
) -> Typed_Array_Container(T) {
	return(
		Typed_Array_Container(T) {
			allocator = internals.create_typed_handle_allocator(T),
			storage = internals.create_typed_array_storage(T),
		} \
	)
}

destroy_typed_array_container :: proc(container: ^Typed_Array_Container($T)) {
	destroy_typed_handle_allocator(container.allocator)
	destroy_typed_array_container(container.storage)
}

insert_into_typed_array_container :: proc(
    container: ^Typed_Array_Container($T),
    value: T,
) -> internals.Typed_Handle(T) {
    handle := internals.alloc_typed_handle(&container.allocator)
    internals.insert_typed_data(&container.storage, handle, value)
    return handle
}
