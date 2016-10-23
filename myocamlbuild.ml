open Ocamlbuild_plugin
open Command 


let nvcc_rules nvcc = 
  rule "nvcc: cu -> o" 
       ~deps:["%.cu"]
       ~prod: "%.o"
       begin
         fun env build ->
         let c = env "%.cu" in
         Cmd (S [A nvcc; A "-arch=sm_20"; A "-Xcompiler"; A"-fPIC"; A "-c"; P c; A "-o"; Px (env "%.o");])
       end	
  
let () =
  dispatch begin function
             | Before_rules -> nvcc_rules "nvcc"
             | After_rules ->
                dep ["link"; "ocaml"; "native"; "staticlinkopt"] ["matrixIndex.o"];
                flag["link"; "ocaml"; "native"; "staticlinkopt"]
                    (S[A"-cclib";A"-lcudart"; A"-cclib";A"-lstdc++";  A"-cclib";A"-Wl,-E";])
               
             | _ -> ()
           end
  
