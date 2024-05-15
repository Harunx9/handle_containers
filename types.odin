package handle_containers

MIN_HANDLE_NUM : u32 = 1024

HandleId :: u32
Generation :: u32

Handle_Info :: struct{
    is_alive : bool,
    generation : Generation,
}
