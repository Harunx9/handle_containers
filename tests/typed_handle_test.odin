package tests
import "../internals"
import "core:fmt"
import "core:testing"

TestStruct :: struct {
	a: int,
	b: int,
}

@(test)
when_create_new_typed_handle_should_be_ok :: proc(t: ^testing.T) {
	handle_allocator := internals.create_typed_handle_allocator(TestStruct)

	handle := internals.alloc_typed_handle(&handle_allocator)

	testing.expect(t, handle.idx == 0, "handle idx should be 0")
	testing.expect(t, handle.gen == 1, "handle gen should be 1")
}

@(test)
when_create_two_new_typed_handles_should_be_ok :: proc(t: ^testing.T) {
	handle_allocator := internals.create_typed_handle_allocator(TestStruct)

	handle1 := internals.alloc_typed_handle(&handle_allocator)
	handle2 := internals.alloc_typed_handle(&handle_allocator)

	testing.expect(t, handle1.idx == 0, "handle1 idx should be 0")
	testing.expect(t, handle1.gen == 1, "handle1 gen should be 1")

	testing.expect(t, handle2.idx == 1, "handle2 idx should be 1")
	testing.expect(t, handle2.gen == 1, "handle2 gen should be 1")
}

@(test)
new_typed_handle_should_be_alive :: proc(t: ^testing.T) {
	handle_allocator := internals.create_typed_handle_allocator(TestStruct)

	handle := internals.alloc_typed_handle(&handle_allocator)

	testing.expect(
		t,
		internals.is_typed_handle_alive(&handle_allocator, handle),
		"handle should be alive",
	)
}

@(test)
when_free_typed_handle_should_not_be_alive :: proc(t: ^testing.T) {
	handle_allocator := internals.create_typed_handle_allocator(TestStruct)

	handle := internals.alloc_typed_handle(&handle_allocator)
	internals.free_typed_handle(&handle_allocator, handle)

	testing.expect(
		t,
		internals.is_typed_handle_alive(&handle_allocator, handle) == false,
		"handle should not be alive",
	)
}

@(test)
when_free_typed_handle_and_alloc_new_typed_handle_should_reuse_old_handle :: proc(t: ^testing.T) {
	handle_allocator := internals.create_typed_handle_allocator(TestStruct)

	handle1 := internals.alloc_typed_handle(&handle_allocator)
	internals.free_typed_handle(&handle_allocator, handle1)
	handle2 := internals.alloc_typed_handle(&handle_allocator)

	testing.expect(t, handle2.idx == 0, "handle2 idx should be 0")
	testing.expect(t, handle2.gen == 2, "handle2 gen should be 2")
}
