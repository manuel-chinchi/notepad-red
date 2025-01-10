# Notepad Red
Un editor de texto sencillo hecho completamente en lenguaje RED.

## Referencias
* [Red VID > Dialogs](https://www.red-by-example.org/vid.html)
* [Red VID > Events](https://www.red-by-example.org/#cat-e04)
## Capturas

<p align="center">
    <img src="screenshots/2025-01-10 15_33_59-NotepadRed.png" width="334">
</p>

## TODO

* ~~cancelar salida por defecto en evento **on-close**~~
* implementar acciones del menu **Edición > mi_undo | mi_cut | mi_copy | mi_paste**.
* implementar atajos de teclado en evento **on-key**.
* evento **on-close** y acción de menu **mi_exit** son iguales. modularizar.
* investigar (si es posible) como deshabilitar items del menú.
* agregar manejo de errores. Especificamente cuando se quiere modificar un archivo 
  que se encuentra en una ubicación especial, por ej. C/f.txt se debe ejecutar en
  modo administrador.
* agregar barra de estado (si es posible)