# Vector con nombres de las librerías a instalar
librerias <- c("tidyverse",
               "wordcloud2",
               "RColorBrewer",
               "tidytext",
               "htmlwidgets",
               "htmltools")

# Instalar las librerías que no están instaladas
librerias_faltantes <- librerias[!(librerias %in% installed.packages()[, "Package"])]
if (length(librerias_faltantes) > 0) {
  install.packages(librerias_faltantes)
}

# Cargar las librerías
lapply(librerias, require, character.only = TRUE)

# Leer archivo txt
ruta_archivo <- "chat.txt"  # Actualizar con la ruta correcta del archivo txt
palabras_omitidas <- c("jajaja","si","ya","te","y","omitido","tu","un","o","null",
                       "jejeje","para","una","tengo","como","jajaj","nada","voy","jajajajaja",
                       "jijiji","me","https","muy","mucho",
                       "a","vm.tiktok.com","que","no",
                       "jaja","las","al","le",
                       "de","los","era","estoy","solo","sea","asi","sé",
                       "jajajaja","qué","más","está","ok","ver","soy",
                       "es","algo","bueno","ir","he","da","iba",
                       "en","q","tú","tan","bien","hacer","así","osea","fue",
                       "pero","jeje","todo","ese","creo","vas","estás",
                       "la","ser","ni","ahí","de","dar",
                       "lo",
                       "el",
                       "mi",
                       "por",
                       "yo",
                       "eso",
                       "con",
                       "se","multimedia")

# Extraer datos de fecha, hora, usuario y mensaje
datos <- read_lines(ruta_archivo)
patron <- "\\d+/\\d+/\\d+, \\d+:\\d+ - (.+): (.+)"
datos_extraidos <- str_match(datos, patron)

# Crear dataframe
mensajes <- as.data.frame(datos_extraidos[, c(2, 3)], stringsAsFactors = FALSE)
colnames(mensajes) <- c("Usuario", "Mensaje")
mensajes$Fecha <- substr(datos_extraidos[, 1], 1, 9)
mensajes$Hora <- substr(datos_extraidos[, 1], 12, 16)

mensaje_palabras <- mensajes %>%
  unnest_tokens(word, Mensaje) %>%
  filter(!word %in% palabras_omitidas) %>%
  count(word) %>%
  arrange(desc(n))

# Dibujar nube de palabras
wordcloud2(data = mensaje_palabras, size = 1, color = "random-dark", fontFamily = "JetBrains Mono")