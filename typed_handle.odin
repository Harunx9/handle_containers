package handle_containers

Typed_Handle :: struct($T: typeid) {
	idx: HandleId,
	gen: Generation,
}

Typed_Handle_Allocator :: struct($T: typeid) {
	free:         [dynamic]HandleId,
	alive:        [dynamic]Handle_Info,
	current_size: u32,
}

create_typed_handle_allocator :: proc($T:typeid, min_size := MIN_HANDLE_NUM) -> Typed_Handle_Allocator(T) {
	return(
		Typed_Handle_Allocator(T) {
			free = make([dynamic]HandleId, 0, min_size),
			alive = make([dynamic]Handle_Info, 0, min_size),
			current_size = 0,
		} \
	)
}

destroy_typed_handle_allocator :: proc(allocator: Typed_Handle_Allocator($T)) {
	delete(allocator.free)
	delete(allocator.alive)
}

alloc_typed_handle :: proc(allocator: ^Typed_Handle_Allocator($T)) -> Typed_Handle(T) {
	idx, ok := pop_safe(&allocator.free)
	if ok {
		info := &allocator.alive[idx]
		if info == nil {
			panic("Handle Allocator is corrupted")
		}
		info.generation += 1
		info.is_alive = true
		return Typed_Handle(T){idx = idx, gen = info.generation}
	} else {
		allocator.current_size += 1
		append(&allocator.alive, Handle_Info{generation = 1, is_alive = true})
		return Typed_Handle(T){idx = allocator.current_size - 1, gen = 1}
	}
}

free_typed_handle :: proc(allocator: ^Typed_Handle_Allocator($T), handle: Typed_Handle(T)) -> bool {
	if is_typed_handle_alive(allocator, handle) {
		info := &allocator.alive[handle.idx]
		info.is_alive = false

		append(&allocator.free, handle.idx)
		return true
	}

	return false
}

is_typed_handle_alive :: proc(allocator: ^Typed_Handle_Allocator($T), handle: Typed_Handle(T)) -> bool {
	info := &allocator.alive[handle.idx]
	if info == nil {
		return false
	}

	return info.generation == handle.gen && info.is_alive
}
