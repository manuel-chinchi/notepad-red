Red [
    author: "Manuel Chinchi"
    date: 25/Feb/25
]

f_to_string: func [_data] [
    if _data = none [return ""]
    if (type? _data) = string! [return _data]
    if (type? _data) = file! [return to string! _data]
    return none
]

f_path_exists: func [_path] [
    if _path = none [return false]
    return exists? to file! _path
]

f_to_file: func [_path] [
    ;if (_path = none) or (_path = "") [return %""]
    if _path = none [return %""]
    return to file! _path
]

; TODO dar soporte para "/", no lo toma actualmente
f_get_parent_dir: func [
{Devuelve el directorio de nivel superior del path. Si el path es un
directorio raíz que no tiene nivel superior entonces devuelve none}
    _path [string!]] [

    reverse _path ; invierto el path in situ
    _path: next _path ; elimino primer "\"
    ; si _path es por ej. "c:/" luego de esta instruccion será none
    _path: find _path "\" ; busco (elimino caracteres) hasta el proximo "\"
    if _path = none [return _path]
    return reverse _path
]

; TODO hacer mas pruebas
f_find_file_in_path: func [
{Busca el archivo en alguna ubicación relativa al path. Si la encuentra
devuelve el path del archivo sino devuelve none}
    _path [string!] _file [string!]] [

    _file: replace/all _file "/" "\"
    _path_file: rejoin [_path _file]
    while [true] [
        _path: f_get_parent_dir _path
        if (exists? to file! _path_file) or (_path = none) [
            break
        ]
        _path_file: rejoin [_path _file]
    ]
    return _path_file
]