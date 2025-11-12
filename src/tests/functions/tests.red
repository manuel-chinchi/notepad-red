Red [
    author: "Manuel Chinchi"
    date: 24/Feb/25
]

do %../../functions.red ; cargar archivo de funciones

f_assert: func [param1 param2 out_ok [string!] out_err [string!]] [
    either param1 = param2 [
        print out_ok
    ] [
        print out_err
    ]
]

print "file: functions.red ^/"

; =================================== tests ===================================

print "A: f_to_string"
f_assert (type? f_to_string none) string! "test A1 ok" "test A1 error"
f_assert (type? f_to_string "") string! "test A2 ok" "test A2 error"
f_assert (type? f_to_string 0) string! "test A3 ok" "test A3 error" ; revisar a futuro. no es prioritario
f_assert (type? f_to_string %/c/setup.log) string! "test A4 ok" "test A4 error"
print ""

print "B: f_path_exists"
f_assert (f_path_exists none) false "test B1 ok" "test B1 error"
f_assert (f_path_exists %/c/setup.log) true "test B2 ok" "test B2 error" ; usar ruta de un archivo existente
f_assert (f_path_exists "/c/setup.log") true "test B3 ok" "test B3 error"
f_assert (f_path_exists %/c/none.txt) false "test B4 ok" "test B4 error" ; usar ruta de archivo no existente
print ""

print "C: f_to_file"
f_assert (f_to_file none) %"" "test C1 ok" "test C2 error"
f_assert (f_to_file %/c/setup.log) %/c/setup.log "test C2 ok" "test C2 error"
f_assert (f_to_file "/c/setup.log") %/c/setup.log "test C3 ok" "test C3 error"
f_assert (f_to_file "/c/newfile.txt") %/c/newfile.txt "test C4 ok" "test C4 error"
; el param2 que se pasa en este caso a pesar de que esta definido entre comillas es de tipo file! pero se pone 
; así en este test ya que si se pone directamente <<   c:/setup.log   >> red dara un error de sintaxis.
f_assert (f_to_file "c:/setup.log") "c:/setup.log" "test C5 ok" "test C5 error"
