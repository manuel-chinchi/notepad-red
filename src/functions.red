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
