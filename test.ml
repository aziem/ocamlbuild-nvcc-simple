open Ctypes
open Foreign

let printhello = foreign "printHello" (void @-> returning void)

let _ = printhello ()
