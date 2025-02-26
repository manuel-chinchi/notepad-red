
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

do %dialogs.red
do %functions.red

; funciones
; -----------------------------------------------------------------------------
f_msgbox: func [
    "Muestra un cuadro de dialogo modal con botones Yes, No y Cancel" ;
    _msg [string!]
] [
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

f_update_statusbar: func [
    "Actualiza la barra de estado" ;
    _text _area
] [
    _length: length? f_to_string _area/text
    _lines: length? split (f_to_string _area/text) "^/"
    _text/text: rejoin ["Líneas " _lines ", Largo " _length]
]

; variables
; -----------------------------------------------------------------------------
g_appname: "Notepad Red"
g_version: "1.0"
g_author: "Manuel Chinchi"

g_size_editor: 320x240
g_text_editor: ""
g_current_file: none ; %/c/file.txt

g_size_statusbar: 320x22
g_text_statusbar: none

STR_NO_TITLE: "Sin título"
STR_QST_SAVE_CHANGES: "¿Desea guardar los cambios?"
STR_DLG_OPEN_TITLE: "Abrir"
STR_DLG_SAVE_TITLE: "Guardar"

g_args: system/options/args

if not empty? g_args [
    g_current_file: to file! first g_args
]

; main
; -----------------------------------------------------------------------------
view/options [
    at 0x0
    _editor: area
        g_text_editor ; texto que se carga en el editor solo si 'g_current_file' es none
        g_size_editor
        font-name "courier new"
        font-size 11
        focus
        on-change [
            f_update_statusbar
                g_text_statusbar
                _editor
        ]
    at 0x218
    _statusbar: panel
        g_size_statusbar
        [
            at 0x0
            _bordertop_statusbar: base 145.145.145 352x1
            at 5x3
            g_text_statusbar: text "" 200x18
        ]
] [
    text: STR_NO_TITLE ; título
    size: g_size_editor
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

        on-menu: func [_face [object!] _event [event!]] [
        
            if _event/picked = 'mi_new [
                _file_exists: exists? f_to_file g_current_file
                _editor_empty: (length? f_to_string _editor/text) = 0
                _has_changes: none
                
                either _file_exists [
                    _has_changes: (f_to_string _editor/text) <> (read f_to_file g_current_file)
                    either _has_changes [
                        ;print {case1: _file_exists & _has_changes}
                        _result: f_msgbox STR_QST_SAVE_CHANGES
                        if _result <> none [
                            if _result = true [
                                write g_current_file _editor/text
                            ]
                            _editor/text: none
                            g_current_file: none
                            _face/text: STR_NO_TITLE
                        ]
                    ] [
                        ;print {case2: _file_exists & not _has_changes}
                        _editor/text: none
                        g_current_file: none
                        _face/text: STR_NO_TITLE
                    ]
                ] [
                    either _editor_empty [
                        ;print {case3: not _file_exists & _editor_empty}
                    ] [
                        ;print {case4: not _file_exists & not _editor_empty}
                        _result: f_msgbox STR_QST_SAVE_CHANGES
                        if _result <> none [
                            either _result = true [
                                _file: request-file/save/title STR_DLG_SAVE_TITLE
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
                f_update_statusbar
                    g_text_statusbar
                    _editor
            ]
            
            if _event/picked = 'mi_open [
                _file_exists: exists? f_to_file g_current_file
                _editor_empty: (length? f_to_string _editor/text) = 0
                _has_changes: none
                
                either _file_exists [
                    _has_changes: (f_to_string _editor/text) <> (read f_to_file g_current_file)
                    either _has_changes [
                        _result: f_msgbox STR_QST_SAVE_CHANGES
                        if _result <> none [
                            either _result = true [
                                write g_current_file _editor/text
                                _file: request-file/title STR_DLG_OPEN_TITLE
                                if _file <> none [
                                    _editor/text: read _file
                                    g_current_file: _file
                                    _face/text: f_to_string _file
                                ]
                            ] [
                                _file: request-file/title STR_DLG_OPEN_TITLE
                                if _file <> none [
                                    _editor/text: read _file
                                    g_current_file: _file
                                    _face/text: f_to_string _file
                                ]
                            ]
                        ]
                    ] [
                        _file: request-file/title STR_DLG_OPEN_TITLE
                        if _file <> none [
                            _editor/text: read _file
                            g_current_file: _file
                            _face/text: f_to_string _file
                        ]
                    ]
                ] [
                    either _editor_empty [
                        _file: request-file/title STR_DLG_OPEN_TITLE
                        if _file <> none [
                            _editor/text: read _file
                            g_current_file: _file
                            _face/text: (f_to_string _file)
                        ]
                    ] [
                        _result: f_msgbox STR_QST_SAVE_CHANGES
                        if _result <> none [
                            either _result = true [
                                _file: request-file/save/title STR_DLG_SAVE_TITLE
                                if _file <> none [
                                    write _file _editor/text
                                    _file: request-file/title STR_DLG_OPEN_TITLE
                                    if _file <> none [
                                        _editor/text: read _file
                                        g_current_file: _file
                                        _face/text: f_to_string _file
                                    ]
                                ]
                            ] [
                                _file: request-file/title STR_DLG_OPEN_TITLE
                                if _file <> none [
                                    _editor/text: read _file
                                    g_current_file: _file
                                    _face/text: f_to_string _file
                                ]
                            ]
                        ]
                    ]
                ]
                f_update_statusbar
                    g_text_statusbar
                    _editor
            ]
            
            if _event/picked = 'mi_save [
                _file_exists: exists? f_to_file g_current_file
                
                either _file_exists [
                    write g_current_file _editor/text
                ] [
                    _file: request-file/save/title STR_DLG_SAVE_TITLE
                    if _file <> none [
                        write _file _editor/text
                        g_current_file: _file
                        _face/text: (f_to_string _file)
                    ]
                ]
            ]
            
            if _event/picked = 'mi_close [
                ;@TODO Si escribo algo y luego quiero cerrar se produce un error, o como que lo toma
                ; como si hubiese un archivo abierto. Corregir
                _file_exists: exists? f_to_file g_current_file
                _editor_empty: (length? f_to_string _editor/text) = 0
                _has_changes: none
                
                either _file_exists [
                    _has_changes: (f_to_string _editor/text) <> (read f_to_file g_current_file)
                    either _has_changes [
                        _result: f_msgbox STR_QST_SAVE_CHANGES
                        if _result <> none [
                            either _result = true [
                                write g_current_file _editor/text
                                _editor/text: none
                            ] [
                                _editor/text: none
                                g_current_file: none
                                _face/text: STR_NO_TITLE
                            ]
                        ]
                    ] [
                        _editor/text: none
                        g_current_file: none
                        _face/text: STR_NO_TITLE
                    ]
                ] [
                    either _editor_empty [
                        ;quit
                    ] [
                        _result: f_msgbox STR_QST_SAVE_CHANGES
                        if _result <> none [
                            either _result = true [
                                _file: request-file/title STR_DLG_SAVE_TITLE
                                if _file <> none [
                                    write _file _editor/text
                                    _editor/text: none
                                ]
                            ] [
                                _editor/text: none
                                g_current_file: none
                                _face/text: STR_NO_TITLE
                            ]
                        ]
                    ]
                ]
                f_update_statusbar
                    g_text_statusbar
                    _editor
            ]
            
            if _event/picked = 'mi_exit [
                _file_exists: exists? f_to_file g_current_file
                _editor_empty: (length? f_to_string _editor/text) = 0
                _has_changes: none
                
                either _file_exists [
                    _has_changes: (f_to_string _editor/text) <> (read f_to_file g_current_file)
                    either _has_changes [
                        _result: f_msgbox STR_QST_SAVE_CHANGES
                        if _result <> none [
                            if _result = true [
                                write g_current_file _editor/text
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
                        _result: f_msgbox STR_QST_SAVE_CHANGES
                        if _result <> none [
                            either _result = true [
                                _file: request-file/save/title STR_DLG_SAVE_TITLE
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
            
            if _event/picked = 'mi_undo [
                alert-popup "En desarrollo..."
            ]
            
            if _event/picked = 'mi_cut [
                alert-popup "En desarrollo..."
            ]
            
            if _event/picked = 'mi_copy [
                alert-popup "En desarrollo..."
            ]
            
            if _event/picked = 'mi_paste [
                ;#TODO hay que encontrar la ubicación del caret en el área y pegarla ahí
                alert-popup "En desarrollo..."
            ]
            
            if _event/picked = 'mi_font [
                _font: none
                either _editor/font <> none [
                    _font: request-font/font _editor/font
                ] [
                    _font: request-font
                ]
                if _font <> none [
                    _editor/font: _font
                ]
            ]
            
            if _event/picked = 'mi_about [
                _about_msg: rejoin [g_appname " " g_version " by " g_author]
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
        
        on-close: func [_face [object!] _event [event!]] [
            ;#NOTE la logica es igual a la de la accion de menu 'mi_exit. revisar posible refactorizacion
            _file_exists: exists? f_to_file g_current_file
            _editor_empty: (length? f_to_string _editor/text) = 0
            _has_changes: none
            
            either _file_exists [
                _has_changes: (f_to_string _editor/text) <> (read f_to_file g_current_file)
                either _has_changes [
                    _result: f_msgbox STR_QST_SAVE_CHANGES
                    if _result <> none [
                        if _result = true [
                            write g_current_file _editor/text
                        ]
                        ;#TODO revisar este caso de salida
                        quit
                    ]
                ] [
                    quit
                ]
            ] [
                either _editor_empty [
                    quit
                ] [
                    _result: f_msgbox STR_QST_SAVE_CHANGES
                    if _result <> none [
                        either _result = true [
                            _file: request-file/save/title STR_DLG_SAVE_TITLE
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
            view _face
        ]

        on-resizing: func [_face [object!] _event [event!]] [
            _editor/size: _face/size
            _editor/size/y: (_face/size/y - _statusbar/size/y)
            _statusbar/offset/y: _editor/size/y
            _statusbar/size/x: _editor/size/x
            _bordertop_statusbar/size/x: _editor/size/x
        ]
        
        on-resize: func [_face [object!] _event [event!]] [
            _editor/size: _face/size
            _editor/size/y: (_face/size/y - _statusbar/size/y)
            _statusbar/offset/y: _editor/size/y
            _statusbar/size/x: _editor/size/x
            _bordertop_statusbar/size/x: _editor/size/x
        ]

        ; el evento 'on-create' solamente usa el parametro face
        on-create: func [_face [object!]] [
            either (f_path_exists g_current_file) [
                _face/text: f_to_string g_current_file
                _editor/text: read g_current_file
            ] [
                if not (g_current_file = none) [
                    alert-popup (rejoin ["No se encontro el archivo " g_current_file])
                    g_current_file: none
                ]
            ]

            f_update_statusbar
                g_text_statusbar
                _editor
        ]
    ]
]

; software made in Argentina