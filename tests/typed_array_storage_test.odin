package tests

import "../internals"
import "core:fmt"
import "core:testing"

Test_Storage_Item :: struct {
	a: int,
	b: int,
}

@(test)
when_storage_is_empty_should_be_appendable :: proc(t: ^testing.T) {
	allocator := internals.create_typed_handle_allocator(Test_Storage_Item)
	storage := internals.create_typed_array_storage(Test_Storage_Item)

	handle := internals.alloc_typed_handle(&allocator)
	internals.insert_typed_data(&storage, handle, Test_Storage_Item{a = 1, b = 2})

	item := internals.get_typed_data(&storage, handle).?

	testing.expect(t, item.a == 1, "Expected a to be 1")
	testing.expect(t, item.b == 2, "Expected b to be 2")
}

@(test)
when_storage_have_data_it_should_be_ptr_get :: proc(t: ^testing.T) {
	allocator := internals.create_typed_handle_allocator(Test_Storage_Item)
	storage := internals.create_typed_array_storage(Test_Storage_Item)

	handle := internals.alloc_typed_handle(&allocator)
	internals.insert_typed_data(&storage, handle, Test_Storage_Item{a = 1, b = 2})

	item := internals.get_typed_data_ptr(&storage, handle).?

	testing.expect(t, item.a == 1, "Expected a to be 1")
	testing.expect(t, item.b == 2, "Expected b to be 2")
}

@(test)
when_data_is_replaced_should_be_new_data :: proc(t: ^testing.T) {
	allocator := internals.create_typed_handle_allocator(Test_Storage_Item)
	storage := internals.create_typed_array_storage(Test_Storage_Item)

	handle := internals.alloc_typed_handle(&allocator)
	internals.insert_typed_data(&storage, handle, Test_Storage_Item{a = 1, b = 2})
	internals.replace_typed_data(&storage, handle, Test_Storage_Item{a = 3, b = 4})

	item := internals.get_typed_data_ptr(&storage, handle).?

	testing.expect(t, item.a == 3, "Expected a to be 1")
	testing.expect(t, item.b == 4, "Expected b to be 2")
}

@(test)
when_iterate_over_one_element_storage_should_be_ok :: proc(t: ^testing.T) {
	allocator := internals.create_typed_handle_allocator(Test_Storage_Item)
	storage := internals.create_typed_array_storage(Test_Storage_Item)

	handle := internals.alloc_typed_handle(&allocator)
	internals.insert_typed_data(&storage, handle, Test_Storage_Item{a = 1, b = 2})

	iter := internals.make_typed_array_storage_iterator(&storage)
    data , is_end := internals.typed_array_storage_iterator_next(&iter)

    result := data.?

    testing.expect(t, is_end == false, "Expected iterator to not be at end")
    testing.expect(t, result.a == 1, "Expected a to be 1")
    testing.expect(t, result.b == 2, "Expected b to be 2")
}

@(test)
when_iterate_beyond_array_one_element_storage_should_be_ok :: proc(t: ^testing.T) {
	allocator := internals.create_typed_handle_allocator(Test_Storage_Item)
	storage := internals.create_typed_array_storage(Test_Storage_Item)

	handle := internals.alloc_typed_handle(&allocator)
	internals.insert_typed_data(&storage, handle, Test_Storage_Item{a = 1, b = 2})

	iter := internals.make_typed_array_storage_iterator(&storage)

    data_1 , is_end_1 := internals.typed_array_storage_iterator_next(&iter)
    result_1 := data_1.?

    data_2 , is_end_2 := internals.typed_array_storage_iterator_next(&iter)

    testing.expect(t, is_end_1 == false, "Expected iterator to not be at end")
    testing.expect(t, result_1.a == 1, "Expected a to be 1")
    testing.expect(t, result_1.b == 2, "Expected b to be 2")

    testing.expect(t, is_end_2 == true, "Expected iterator should be at end")
    testing.expect(t, data_2 == nil, "Expected to be nil")
}
