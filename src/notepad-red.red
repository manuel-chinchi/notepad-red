
; IMPORTANTE
; -----------------------------------------------------------------------------
; ESTE PROGRAMA FUE DESARROLLADO EN RED 0.6.4 Y PRESENTA ERRORES EN LAS ULTIMAS
; VERSIONES DE RED 0.6.5
; -----------------------------------------------------------------------------

Red [
    author: "Manuel Chinchi"
    date: 01/Jan/25
    needs: view
]

; funciones
; -----------------------------------------------------------------------------
fnc_tostring: func [_data] [
    if _data = none [return ""]
    if (type? _data) = string! [return _data]
    if (type? _data) = file! [return to string! _data]
    return none
]

fnc_pathexists: func [_path] [
    if _path = none [return false]
    return exists? to file! _path
]

fnc_tofile: func [_path] [
    if (_path = none) or (_path = "") [return %""]
    if (type? _path) = file! [return _path]
]

dlg_msgbox: func [_msg [string!]] [
    _result: none
    view/flags [
        title ""
        _txt_msg: text _msg center return
        _btn_yes: button "Sí" [_result: true unview]
        _btn_no: button "No" [_result: false unview]
        button "Cancelar" [unview]
        do [
            _offset: 83
            unless _txt_msg/size/x > (_btn_yes/size/x + _btn_no/size/x + _offset) [
                _txt_msg/size/x: _btn_yes/size/x + _btn_no/size/x + _offset
            ]
        ]
    ] [modal no-min no-max]
    return _result
]

; variables
; -----------------------------------------------------------------------------
_appname: "Red Notepad"
_version: "1.0"
_author: "Manuel Chinchi"

_size_editor: 320x240
_text_editor: ""
_current_file: none

; main
; -----------------------------------------------------------------------------
view/options [
    at 0x0
    _editor: area
        ;#NOTE solo se carga '_text_editor' si '_current_file' no existe
        _text_editor ; no set if only of _current_file exist
        _size_editor
        font-name "courier new"
        font-size 11
        focus
] [
    text: _appname
    size: _size_editor
    flags: ['resize]
    menu: [
        "&Archivo" [
            "&Nuevo" mi_new
            "&Abrir" mi_open 
            "&Guardar" mi_save
            "Cer&rar" mi_close
            ---
            "Sa&lir" mi_exit
        ]
        "&Edición" [
            "&Deshacer" mi_undo
            "&Cortar" mi_cut
            "C&opiar" mi_copy
            "&Pegar" mi_paste
        ]
        "F&ormato" [
            "Fuente" mi_font
        ]
        "Ay&uda" [
            "Acerca de" mi_about
        ]
    ]
    actors: make object! [

        on-menu: func [f [object!] e [event!]] [
        
            if e/picked = 'mi_new [
                _file_exists: exists? fnc_tofile _current_file
                _editor_empty: (length? fnc_tostring _editor/text) = 0
                _has_changes: none
                
                either _file_exists [
                    _has_changes: (fnc_tostring _editor/text) <> (read fnc_tofile _current_file)
                    either _has_changes [
                        ;print {case1: _file_exists & _has_changes}
                        _result: dlg_msgbox "¿Desea guardar los cambios?"
                        if _result <> none [
                            if _result = true [
                                write _current_file _editor/text
                            ]
                            _editor/text: none
                            _current_file: none
                            f/text: "Sin título"
                        ]
                    ] [
                        ;print {case2: _file_exists & not _has_changes}
                        _editor/text: none
                        _current_file: none
                        f/text: "Sin título"
                    ]
                ] [
                    either _editor_empty [
                        ;print {case3: not _file_exists & _editor_empty}
                    ] [
                        ;print {case4: not _file_exists & not _editor_empty}
                        _result: dlg_msgbox "¿Desea guardar los cambios?"
                        if _result <> none [
                            either _result = true [
                                _file: request-file/save/title "Guardar"
                                if _file <> none [
                                    write _file _editor/text
                                    _editor/text: none
                                ]
                            ] [
                                _editor/text: none
                            ]
                        ]
                    ]
                ]
            ]
            
            if e/picked = 'mi_open [
                _file_exists: exists? fnc_tofile _current_file
                _editor_empty: (length? fnc_tostring _editor/text) = 0
                _has_changes: none
                
                either _file_exists [
                    _has_changes: (fnc_tostring _editor/text) <> (read fnc_tofile _current_file)
                    either _has_changes [
                        _result: dlg_msgbox "¿Desea guardar los cambios?"
                        if _result <> none [
                            either _result = true [
                                write _current_file _editor/text
                                _file: request-file/title "Abrir"
                                if _file <> none [
                                    _editor/text: read _file
                                    _current_file: _file
                                    f/text: fnc_tostring _file
                                ]
                            ] [
                                _file: request-file/title "Abrir"
                                if _file <> none [
                                    _editor/text: read _file
                                    _current_file: _file
                                    f/text: fnc_tostring _file
                                ]
                            ]
                        ]
                    ] [
                        _file: request-file/title "Abrir"
                        if _file <> none [
                            _editor/text: read _file
                            _current_file: _file
                            f/text: fnc_tostring _file
                        ]
                    ]
                ] [
                    either _editor_empty [
                        _file: request-file/title "Abrir"
                        if _file <> none [
                            _editor/text: read _file
                            _current_file: _file
                            f/text: (fnc_tostring _file)
                        ]
                    ] [
                        _result: dlg_msgbox "¿Desea guardar los cambios?"
                        if _result <> none [
                            either _result = true [
                                _file: request-file/save/title "Guardar"
                                if _file <> none [
                                    write _file _editor/text
                                    _file: request-file/title "Abrir"
                                    if _file <> none [
                                        _editor/text: read _file
                                        _current_file: _file
                                        f/text: fnc_tostring _file
                                    ]
                                ]
                            ] [
                                _file: request-file/title "Abrir"
                                if _file <> none [
                                    _editor/text: read _file
                                    _current_file: _file
                                    f/text: fnc_tostring _file
                                ]
                            ]
                        ]
                    ]
                ]
            ]
            
            if e/picked = 'mi_save [
                _file_exists: exists? fnc_tofile _current_file
                
                either _file_exists [
                    write _current_file _editor/text
                ] [
                    _file: request-file/save/title "Guardar"
                    if _file <> none [
                        write _file _editor/text
                        _current_file: _file
                        f/text: (fnc_tostring _file)
                    ]
                ]
            ]
            
            if e/picked = 'mi_close [
                _file_exists: exists? fnc_tofile _current_file
                _editor_empty: (length? fnc_tostring _editor/text) = 0
                _has_changes: none
                
                either _file_exists [
                    _has_changes: (fnc_tostring _editor/text) <> (read fnc_tofile _current_file)
                    either _has_changes [
                        _result: dlg_msgbox "¿Desea guardar los cambios?"
                        if _result <> none [
                            either _result = true [
                                write _current_file _editor/text
                                _editor/text: none
                            ] [
                                _editor/text: none
                                _current_file: none
                                f/text: "Sin título"
                            ]
                        ]
                    ] [
                        _editor/text: none
                        _current_file: none
                        f/text: "Sin título"
                    ]
                ] [
                    either _editor_empty [
                        ;quit
                    ] [
                        _result: dlg_msgbox "¿Desea guardar los cambios?"
                        if _result <> none [
                            either _result = true [
                                _file: request-file/title "Guardar"
                                if _file <> none [
                                    write _file _editor/text
                                    _editor/text: none
                                ]
                            ] [
                                _editor/text: none
                                _current_file: none
                                f/text: "Sin título"
                            ]
                        ]
                    ]
                ]                
            ]
            
            if e/picked = 'mi_exit [
                _file_exists: exists? fnc_tofile _current_file
                _editor_empty: (length? fnc_tostring _editor/text) = 0
                _has_changes: none
                
                either _file_exists [
                    _has_changes: (fnc_tostring _editor/text) <> (read fnc_tofile _current_file)
                    either _has_changes [
                        _result: dlg_msgbox "¿Desea guardar los cambios?"
                        if _result <> none [
                            if _result = true [
                                write _current_file _editor/text
                            ]
                            ;#TODO revisar esta logica
                            quit
                        ]
                    ] [
                        quit
                    ]
                ] [
                    either _editor_empty [
                        quit
                    ] [
                        _result: dlg_msgbox "¿Desea guardar los cambios?"
                        if _result <> none [
                            either _result = true [
                                _file: request-file/save/title "Guardar"
                                if _file <> none [
                                    write _file _editor/text
                                ]
                                quit
                            ] [
                                quit
                            ]
                        ]
                    ]
                ]
            ]
            
            if e/picked = 'mi_undo [
                print "En desarrollo..."
            ]
            
            if e/picked = 'mi_cut [
                print "En desarrollo..."
            ]
            
            if e/picked = 'mi_copy [
                print "En desarrollo..."
            ]
            
            if e/picked = 'mi_paste [
                ;#TODO hay que encontrar la ubicación del caret en el area y pegarla ahí
                print "En desarrollo..."
            ]
            
            if e/picked = 'mi_font [
                _font: request-font/font _editor/font
                if _font <> none [
                    _editor/font: _font
                ]
            ]
            
            if e/picked = 'mi_about [
                _about_msg: rejoin [_appname " " _version " by " _author]
                _lyt_about: layout/options [
                    _txt_msg: text _about_msg return
                    _btn_accept: button "Aceptar" [unview]
                ] [
                    flags: ['modal 'no-min 'no-max]
                    text: ""
                ]
                center-face/x _txt_msg
                center-face/x _btn_accept
                view _lyt_about
            ]            
        ]
        
        on-close: func [f [object!] e [event!]] [
            ;#NOTE la logica es igual a la de la accion de menu 'mi_exit. revisar posible refactorizacion
            _file_exists: exists? fnc_tofile _current_file
            _editor_empty: (length? fnc_tostring _editor/text) = 0
            _has_changes: none
            
            either _file_exists [
                _has_changes: (fnc_tostring _editor/text) <> (read fnc_tofile _current_file)
                either _has_changes [
                    _result: dlg_msgbox "¿Desea guardar los cambios?"
                    if _result <> none [
                        if _result = true [
                            write _current_file _editor/text
                        ]
                        ;#TODO revisar este cas de salida
                        quit
                    ]
                ] [
                    quit
                ]
            ] [
                either _editor_empty [
                    quit
                ] [
                    _result: dlg_msgbox "¿Desea guardar los cambios?"
                    if _result <> none [
                        either _result = true [
                            _file: request-file/save/title "Guardar"
                            if _file <> none [
                                write _file _editor/text
                                quit
                            ]
                        ] [
                            quit
                        ]
                    ]
                ]
            ]
            view f
        ]

        on-resizing: func [f [object!] e [event!]] [
            _editor/size: f/size
        ]
        
        on-resize: func [f [object!] e [event!]] [
            _editor/size: f/size
        ]
        
        ;#NOTE 'on-create' solamente usa el parametro face
        on-create: func [f [object!]] [ 
            either (exists? fnc_tofile _current_file) [
                f/text: fnc_tostring _current_file
                _editor/text: read _current_file
            ] [
                f/text: "Sin título"
                _editor/text: _text_editor
            ]
        ]
    ]
]

; software made in Argentina