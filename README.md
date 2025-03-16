# ConJamOn25
Repositorio para la JAM "ConJamOn" 2025 de la Universidad Complutense de Madrid. Autores del grupo: Lagaltijo Games

## Instrucciones para añadir mods
- En la misma carpeta donde se encuentra el ejecutable, crear una carpeta con el nombre "GodotMods", dentro de esta carpeta irán todas las canciones que queramos meter al juego.
- Crear una carpeta para la canción que queramos meter (el nombre da igual)
- Dentro de la carpeta tiene que haber necesariamente 3 archivos: **la canción que queramos reproducir en formato OggVorbis** (es importante que sea ese formato, se puede exportar con esa extensión desde audacity), el nombre del archivo de sonido será el nombre que se muestre en el juego. En segundo lugar es necesario crear un archivo "enemies.txt" que contenga en la primera linea del archivo los beats por minuto de la canción en formato numérico. Y por último es necesario un archivo "notes.txt" que tenga en cada linea los instantes de tiempo en los que aparece una nota (ej: 2.54 2.54    Esto indica que la nota se generará en el segundo 2 con 54 décimas), este archivo se puede rellenar manualmente o mediante el uso de labels de audacity (una vez puestas las labels en una pista, se pueden exportar a un archivo .txt desde el propio programa de Audacity)
Si todos los pasos anteriores se cumplen, la canción aparecerá en la lista de canciones disponibles.
Además, el programa crea un archivo "score.txt" donde guarda todas las puntuaciones de los jugadores para cada canción, para borrar los datos de una canción basta con borrar dicho archivo de la carpeta del mod correspondiente.
